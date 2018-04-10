/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_tree_opa
//
//  Desc:  OnPhysicalAttack event handler for wood
//         producing trees. Cutting trees requires a
//         Woodcutter's Axe.
//
//  Author: David Bobeck 02Feb03
//
/////////////////////////////////////////////////////////
#include "cnr_language_inc"
#include "cnr_config_inc"

void main()
{
  object oPC = GetLastAttacker();
  if (GetIsObjectValid(oPC) && GetIsPC(oPC))
  {
    int bHasAxe = FALSE;
    object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    if (GetIsObjectValid(oItem))
    {
      if (GetTag(oItem) == "cnrWoodCutterAxe")
      {
        bHasAxe = TRUE;
      }
    }

    if (bHasAxe == FALSE)
    {
      oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
      if (GetIsObjectValid(oItem))
      {
        if (GetTag(oItem) == "cnrWoodCutterAxe")
        {
          bHasAxe = TRUE;
        }
      }
    }

    if (bHasAxe == TRUE)
    {
      // sometimes the woodaxe will break.
      if (cnr_d100(1) <= CNR_FLOAT_WOOD_MINING_AXE_BREAKAGE_PERCENTAGE)
      {
        DestroyObject(oItem);
        FloatingTextStringOnCreature(CNR_TEXT_BROKEN_WOODCUTTERS_AXE, oPC, FALSE);
        SetPlotFlag(OBJECT_SELF, TRUE);
        DelayCommand(1.0, SetPlotFlag(OBJECT_SELF, FALSE));
        return;
      }

      SetPlotFlag(OBJECT_SELF, FALSE);
      return;
    }

    SetPlotFlag(OBJECT_SELF, TRUE);
    FloatingTextStringOnCreature(CNR_TEXT_REQUIRES_A_WOODCUTTERS_AXE, oPC, FALSE);

    // clear the plot flag so the next attacker won't get "weapon not effective"
    DelayCommand(1.0, SetPlotFlag(OBJECT_SELF, FALSE));
  }
}
