//::///////////////////////////////////////////////
//:: ki_wrapr_thfglv
//:: Wrapper: Bonded Thieves Gloves
//:://////////////////////////////////////////////
/*
    Wrapper for bonding theives gloves
*/
//:://////////////////////////////////////////////
//:: Created By: Kirito
//:: Created On: October 9, 2017
//:://////////////////////////////////////////////

//:: Includes
#include "inc_bondeditems"
#include "inc_bondeditems"

//:: Public Function Declarations
//bond the Thieves Gloves with PC
void BondThievesGloves(object oItem, object oPC);

//bond the Thieves Gloves with PC
void BondThievesGloves(object oItem, object oPC)
{
    if (GetLevelByClass(CLASS_TYPE_ROGUE,oPC) > 0)
    {
        bond_item(oItem, oPC, BOND_TAG_THIEVESGLOVES, INVENTORY_SLOT_ARMS);
    }
    else
    {
        SendMessageToPC(oPC, "You cannot use these gloves effectively");
    }
}
