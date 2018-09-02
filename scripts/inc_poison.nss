/*
  inc_poison - poison library.

  - Poisons are craftable under Cooking, with moderately high DCs.
  - There are two sorts of poisons: contact poisons (applied to weapons) and
    ingestion poisons (which must be eaten or drunk to take effect).
  - Contact poisons are 'standard' NWN poisons - they do 1d2 ability damage on
    a failed save (des_crft_poison.2da).
  - Ingestion poisons use the poison.2da file (http://nwn.wikia.com/wiki/Poison
    has a good list of standard poisons).  We can add custom poisons later...
  - All ingestion poisons have a tag of the form mi_poisonXXX where XXX is the
    poison.2da row ID (e.g. 012 = row 12 = Deathblade, a CON poison).

  Ingestion poisons can be used the following ways.
  - Applied to a food item.  If applied to the stack, it splits the stack and
    modifies the tag so that ration will only stack with other rations with the
    same poison effect.  One poison item is needed to poison each food item.
  - Applied to a well.  A poisoned well has a 1% chance of applying the selected
    poison for each posion item used on it whenever someone drinks.  The effect
    lasts until next reset.
  - Applied to a plant object (i.e. something that spawns food).  The next time
    (only) the plant spawns food, the stack of food will be poisoned.
  - Neutralize Poison cast on food items or wells will remove the poison,
    subject to a Spellcraft roll against the poison's DC.

  If a poisoned food item is eaten, the last poison applied to it will be
  applied to the victim.

  If a poisoned food item is sold to a settlement, the settlement *loses* its
  food value instead of gaining it.  (The settlement still pays for the food).
  Bulk goods (i.e. the object produced when you buy food from a settlement)
  cannot be poisoned.



*/
#include "inc_common"

const string VAR_POISON_TYPE = "mi_poison_type";
const string VAR_POISON_QTY  = "mi_poison_quantity";

void miPODoPoison(object oPoisoner, object oTarget, object oPoison);

void miPODoPoison(object oPoisoner, object oTarget, object oPoison)
{
  int nPoison = StringToInt(GetStringRight(GetTag(oPoison), 3));

  if (!nPoison)
  {
    SendMessageToPC(oPoisoner, "Not a valid poison object.");
    return;
  }

  // Decide what the target is.
  int nType = 0;

  if (GetLocalInt(oTarget, "GS_QUALITY"))
  {
    // Water source.
    nType = 1;
  }
  else if (GetLocalString(oTarget, "GS_TEMPLATE") != "")
  {
    // Resource that creates something (maybe food).
    nType = 2;
  }
  else if (GetStringLeft(GetTag(oTarget), 6) == "GS_ST_")
  {
    // Food or drink object.
    nType = 3;
  }

  if (!nType)
  {
    SendMessageToPC(oPoisoner, "That's not a valid target.  You can poison food, drinks, bushes and water sources.");
    return; // Not a valid target.
  }

  // Check that the poisoner is competent...
  if (!GetHasFeat(FEAT_USE_POISON, oPoisoner))
  {
    int nApplyDC = StringToInt(Get2DAString("poison", "Handle_DC", nPoison));

    if (d20() + GetAbilityModifier(ABILITY_DEXTERITY,oPoisoner) < nApplyDC)
    {
      // Uh oh.
      SendMessageToPC(oPoisoner, "You poisoned yourself!");
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectPoison(nPoison), oPoisoner);
      gsCMReduceItem(oPoison);
      return;
    }
  }

  // If we get here, we should apply the poison effect.
  switch (nType)
  {
    case 1: // Water source
    {
      int nPoisonQuantity = GetLocalInt(oTarget, VAR_POISON_QTY);
      if (nPoisonQuantity && d2() == 1)
      {
        // 50% chance of overwriting the previous poison type.
        SetLocalInt(oTarget, VAR_POISON_TYPE, nPoison);
      }

      SetLocalInt(oTarget, VAR_POISON_QTY, nPoisonQuantity + 1);

      FloatingTextStringOnCreature("*Pours something into the water*",
                                   oTarget,
                                   FALSE);

      // Hostile nearby NPCs if they spot it (spot check vs PC's Hide skill).
      int nNth = 1;
      object oNPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,
                                    PLAYER_CHAR_NOT_PC,
                                    oPoisoner, nNth);

      while (GetIsObjectValid(oNPC) && GetDistanceBetween(oNPC, oPoisoner) <= 20.0)
      {
        if (LineOfSightObject(oNPC, oPoisoner) &&
            GetIsSkillSuccessful(oNPC, SKILL_SPOT, GetSkillRank(SKILL_HIDE, oPoisoner)))
        {
          AdjustReputation(oPoisoner, oNPC, -100);

          // Use the DMFI trick of blinding an NPC so that they see the PC again
          // and trigger hostility.
          effect eInvis =EffectBlindness();
          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, oNPC, 6.1);
        }

        nNth++;
        oNPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,
                                    PLAYER_CHAR_NOT_PC,
                                    oPoisoner, nNth);
      }

      break;
    }
    case 2: // Resource
    {
      // This is read in gs_pl_resource.
      SetLocalInt(oTarget, VAR_POISON_TYPE, nPoison);
      break;
    }
    case 3: // Food item
    {
      object oPoisonedFood = CreateItemOnObject(GetResRef(oTarget),
                                     oPoisoner,
                                     1,
                                     GetTag(oTarget) + "p" + IntToString(nPoison));
      gsCMReduceItem(oTarget);

      SetLocalInt(oPoisonedFood, VAR_POISON_TYPE, nPoison);
      break;
    }
  }

  gsCMReduceItem(oPoison);
}
