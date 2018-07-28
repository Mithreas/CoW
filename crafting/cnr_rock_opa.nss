/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_rock_opa
//
//  Desc:  OnPhysicalAttack event handler for minable
//         rocks. Mining rock requires a Miner's Pickaxe.
//
//  Author: David Bobeck 02Feb03
//
/////////////////////////////////////////////////////////
#include "cnr_config_inc"
#include "cnr_language_inc"

void main()
{
  object oPC = GetLastAttacker();
  if (GetIsObjectValid(oPC) && GetIsPC(oPC))
  {
    int bHasPickaxe = FALSE;
    object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    if (GetIsObjectValid(oItem))
    {
      if (GetTag(oItem) == "cnrMinersPickaxe")
      {
        bHasPickaxe = TRUE;
      }
    }

    if (bHasPickaxe == FALSE)
    {
      oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
      if (GetIsObjectValid(oItem))
      {
        if (GetTag(oItem) == "cnrMinersPickaxe")
        {
          bHasPickaxe = TRUE;
        }
      }
    }
        
    if (bHasPickaxe == TRUE)
    {
      // sometimes the pickaxe will break.
      if (cnr_d100(1) <= CNR_FLOAT_ORE_MINING_PICKAXE_BREAKAGE_PERCENTAGE)
      {
        DestroyObject(oItem);
        FloatingTextStringOnCreature(CNR_TEXT_SHATTERED_PICKAXE, oPC, FALSE);
        SetPlotFlag(OBJECT_SELF, TRUE);
        DelayCommand(1.0, SetPlotFlag(OBJECT_SELF, FALSE));
        return;
      }

      SetPlotFlag(OBJECT_SELF, FALSE);
      return;
    }

    SetPlotFlag(OBJECT_SELF, TRUE);
    FloatingTextStringOnCreature(CNR_TEXT_REQUIRES_A_MINERS_PICKAXE, oPC, FALSE);

    // clear the plot flag so the next attacker won't get "weapon not effective"
    DelayCommand(1.0, SetPlotFlag(OBJECT_SELF, FALSE));
  }
}
