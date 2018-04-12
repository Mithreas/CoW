//------------------------------------------------------------------------------
// Take:
// golem heart
// golem parts, one of
// -stone
// -iron
// -bone
//
// output
// create golem NPC of the right type.
//------------------------------------------------------------------------------
#include "inc_common"
void CreateGolem(string sResRef)
{
  object oGolem = CreateObject(OBJECT_TYPE_CREATURE, sResRef, GetLocation(OBJECT_SELF));
  FloatingTextStringOnCreature("Slowly, the golem takes shape before your eyes.", oGolem, FALSE);
}

void main()
{
  object oWorkstation = OBJECT_SELF;
  object oPC = GetLastClosedBy();
  object oItem = GetFirstItemInInventory(oWorkstation);

  object oHeart = OBJECT_INVALID;
  object oParts = OBJECT_INVALID;
  string sGolemResRef;

  int bTransmuter = GetHasFeat(FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION, oPC) ||
                    GetHasFeat(FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION, oPC);
  string sTag;

  while (GetIsObjectValid(oItem))
  {
    sTag = GetTag(oItem);

    if (sTag == "mi_golem_heart") oHeart = oItem;
    else if (sTag == "mi_golem_p_stone")
    {
      oParts = oItem;
      sGolemResRef = "mi_golem_stone";
    }
    else if (sTag == "mi_golem_p_iron")
    {
      oParts = oItem;
      sGolemResRef = "mi_golem_iron";
    }
    else if (sTag == "mi_golem_p_bone")
    {
      oParts = oItem;
      sGolemResRef = "mi_golem_bone";
    }

    oItem = GetNextItemInInventory(oWorkstation);
  }

  if (GetIsObjectValid(oHeart) && GetIsObjectValid(oParts) && bTransmuter)
  {
    FloatingTextStringOnCreature("You combine the golem parts and power them up with the heart.", oPC);
    CreateGolem(sGolemResRef);
    gsCMReduceItem(oParts);
    gsCMReduceItem(oHeart);
  }
  else
  {
    FloatingTextStringOnCreature("Nothing happens.", oPC);
    SendMessageToPC(oPC, "You need to have Greater Spell Focus: Transmutation and the right materials to make a golem.");
  }
}
