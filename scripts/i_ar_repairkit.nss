#include "gs_inc_istate"
#include "gs_inc_craft"

/*

    A repair kit can be used on an item to repair charges on it
    based on current gold cost of item.

    Amount repaired is equal to 100% - 10% for each 5k of the item value, with a minimum of 20%.

    Crafting Types Used:

    GS_CR_SKILL_CARPENTER       =   1;
    GS_CR_SKILL_FORGE           =   4;
    GS_CR_SKILL_SEW             =   6;

*/

void main()
{
    object oRepairKit  = GetItemActivated();
    object oActivator  = GetItemActivator();
    object oTarget     = GetItemActivatedTarget();

    //::  Invalid target
    if ( oTarget == OBJECT_INVALID || GetObjectType(oTarget) != OBJECT_TYPE_ITEM ) {
        FloatingTextStringOnCreature("Invalid Target.  Must be used on a Item.", oActivator, FALSE);
        return;
    }

    int nCraftingType  = gsISGetItemCraftSkill(oTarget);
    int nCraftingKit   = GetLocalInt(oRepairKit, "REPAIR_TYPE");

    //::  Invalid Item.
    if ( nCraftingType == FALSE ) {
        FloatingTextStringOnCreature("You can't repair this item.", oActivator, FALSE);
        return;
    }

    //::  Wrong Item base type for Repair Kit
    if ( nCraftingType != nCraftingKit ) {
        FloatingTextStringOnCreature("Item type does not match the Repair Kit.", oActivator, FALSE);
        return;
    }

    //::  All good, lets try and repair the item based on its GP value.
    int nGoldValue      = GetGoldPieceValue(oTarget);
    int nSplit          = nGoldValue / 5000;
    int nCurrentCharges = gsISGetItemState(oTarget);
    int nMaxCharges     = gsISGetMaximumItemState(oTarget);
    float fRepairAmount = 1.0 - (0.1 * nSplit);

    //::  Fully repaired, no need for repair.
    if ( nCurrentCharges >= nMaxCharges ) {
        FloatingTextStringOnCreature("Item is already fully repaired.", oActivator, FALSE);
        return;
    }

    //::  Minimum 20% repaired
    if ( fRepairAmount < 0.2 ) fRepairAmount = 0.2;

    //::  Repair Item
    int nRepairedCharges = FloatToInt( IntToFloat(nMaxCharges) * fRepairAmount);
    if ( nRepairedCharges > 0 ) {
        gsISSetItemState(oTarget, nCurrentCharges + nRepairedCharges);
        gsCMReduceItem(oRepairKit);
    }
}
