//::///////////////////////////////////////////////
//:: Neutralize Poison
//:: NW_S0_NeutPois.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Removes all poison effects from the target.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 22, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: Aug 3, 2001

#include "inc_effect"
#include "mi_inc_poison"

void main()
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nType;
    effect eVis = EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);

    object oItem = GetSpellCastItem();
    if (!GetIsObjectValid(oItem))
    {
      // Use an ingredient - Lady's Tear
      object oTear = GetItemPossessedBy(OBJECT_SELF, "ar_it_herb005");

      if (!GetIsObjectValid(oTear))
      {
        FloatingTextStringOnCreature("You need a Lady's Tear to cast that!", OBJECT_SELF);
        return;
      }
      else
      {
        gsCMReduceItem(oTear);
      }
    }

    //Get the first effect on the target
    effect ePoison = GetFirstEffect(oTarget);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NEUTRALIZE_POISON, FALSE));
    while(GetIsEffectValid(ePoison))
    {
        //Check to see if the effect is type poison
        if (GetEffectType(ePoison) == EFFECT_TYPE_POISON || GetIsTaggedEffect(ePoison, EFFECT_TAG_POISON))
        {
            //Remove poison effect and apply VFX constant
            RemoveEffect(oTarget, ePoison);

            if ( GetIsTaggedEffect(ePoison, EFFECT_TAG_POISON) )
                RemoveTaggedEffects(oTarget, EFFECT_TAG_POISON);

            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
        //Get next effect on target
        GetNextEffect(oTarget);
    }

    // Remove Arelith specific poisons.
    int nPoison = GetLocalInt(oTarget, VAR_POISON_TYPE);
    if (nPoison)
    {
      int nDC = StringToInt(Get2DAString("poison", "Save_DC", nPoison));
      if (GetIsSkillSuccessful(OBJECT_SELF, SKILL_SPELLCRAFT, nDC))
      {
        DeleteLocalInt(oTarget, VAR_POISON_TYPE);
      }
    }
}

