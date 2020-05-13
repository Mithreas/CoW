// mi_livingforest
// Script intended to make a properly scary forest.  Think the Old Forest from
// LoTR.
#include "inc_rename"
#include "inc_flag"

void _DoQuicksand(object oPC, int nCount = 0)
{
  object oPC2 = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,
                                   PLAYER_CHAR_IS_PC,
                                   oPC);
  int nBonus = (GetDistanceBetween(oPC, oPC2) > 0.0f && GetDistanceBetween(oPC, oPC2) < 1.5f) ? GetAbilityModifier(ABILITY_STRENGTH, oPC2) : 0;

  if (nBonus) FloatingTextStringOnCreature(svGetPCNameOverride(oPC2) + " helps you get free", oPC);

  if (d20() + GetAbilityModifier(ABILITY_STRENGTH, oPC) + nBonus > 15 + nCount)
  {
    DelayCommand(1.0f, FloatingTextStringOnCreature("You break free of the quicksand.", oPC));
  }
  else
  {
    FloatingTextStringOnCreature("Your struggles only pull you deeper...", oPC);
    effect eHold = EffectEntangle();
    effect eEntangle = EffectVisualEffect(VFX_DUR_ENTANGLE);
    effect eLink = EffectLinkEffects(eHold, eEntangle);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(1));

    if (nCount > 10)
    {
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oPC);
    }
    else
    {
      SetCommandable(FALSE, oPC);

      DelayCommand(RoundsToSeconds(1) - 0.1f, SetCommandable(TRUE, oPC));
      DelayCommand(RoundsToSeconds(1), _DoQuicksand(oPC, ++nCount));
    }
  }
}

void main()
{
  object oPC = GetEnteringObject();
  if (!GetIsPC(oPC) || GetIsDM(oPC)) return;
  int bForestWalker = (GetLevelByClass(CLASS_TYPE_RANGER, oPC) || GetLevelByClass(CLASS_TYPE_DRUID, oPC));

  switch (d20())
  {
    case 1:
    case 2:
    case 3:
    case 4:
    case 5:
    case 6:
    case 7:
    case 8:
    case 9:
    case 10:
      // Nothing happens.
      break;
    case 11:
      if (bForestWalker || ReflexSave(oPC, 20)) FloatingTextStringOnCreature("A root snakes out to grab you, but you dodge it!", oPC);
      else
      {
        FloatingTextStringOnCreature("A root snakes out and grabs your ankle!", oPC);
        effect eHold = EffectEntangle();
        effect eEntangle = EffectVisualEffect(VFX_DUR_ENTANGLE);
        effect eLink = EffectLinkEffects(eHold, eEntangle);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(2));
      }
      break;
    case 12:
      SendMessageToPC(oPC, "There is an ominous creaking from the branches overhead.");
      break;
    case 13:
      SendMessageToPC(oPC, "Something blown on the wind brushes against your cheek, leaving a stinging sensation.");
      break;
    case 14:
      SendMessageToPC(oPC, "You get the distinct feeling that something is watching you.");
      break;
    case 15:
      break;
    case 16:
    {
      FloatingTextStringOnCreature("You have angered the forest!", oPC);
      int nD3 = d3();
      int nCount = 0;
      for (nCount = 0; nCount < nD3; nCount++)
      {
        object tree = CreateObject(OBJECT_TYPE_CREATURE, "angrytree", GetLocation(oPC));

        // Flag the tree so that it can be cleaned up by the area cleanup script.
        gsFLSetFlag(GS_FL_ENCOUNTER, tree);
      }
    }
    break;
    case 17:
    case 18:
    case 19:
    case 20:
  }

}
