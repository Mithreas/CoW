//::///////////////////////////////////////////////
//:: ki_check_bonds
//:: Wrapper for Checking Bonded Items
//:://////////////////////////////////////////////
/*
    Wrapper holding all Bond Item Subscripts
    Bond is checked or activated on equip
*/
//:://////////////////////////////////////////////
//:: Created By: Kirito
//:: Created On: October 9, 2017
//:://////////////////////////////////////////////

//:: Includes
#include "inc_bondeditems"
#include "inc_bondeditems"
#include "ki_wrapr_bldsgr"
#include "ki_wrapr_thfglv"

//:: Public Function Declarations

//Check item bonds
void CheckBonds(object oPC, object oItem);

// wrapper holding all bonds item scripts
void BondItemWrapper(object oPC, object oItem, int nBondType);

//:: Function Declarations

//Check item bonds
void CheckBonds(object oPC, object oItem)
{
    //Setup
    object oHide = gsPCGetCreatureHide(oPC);
    int nBondType;

    if (oItem == GetItemInSlot(INVENTORY_SLOT_CHEST, oPC))
    {
        nBondType = INVENTORY_SLOT_CHEST;
    }
    else if (oItem == GetItemInSlot(INVENTORY_SLOT_ARMS, oPC))
    {
        nBondType = INVENTORY_SLOT_ARMS;
    }
    else if (oItem == GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC))
    {
        nBondType = INVENTORY_SLOT_RIGHTHAND;
    }
    else if (oItem == GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC))
    {
        nBondType = INVENTORY_SLOT_LEFTHAND;
    }
    else
    {
        return;
    }

    string sBondTypeID = IntToString(nBondType)+"_id";

    if (GetStringLength(GetLocalString(oItem, "BondID")) == 0)
    {
        BondItemWrapper(oPC, oItem, nBondType);
    }
    else if (GetStringLength(GetLocalString(oItem, "BondID")) > 0 &&
        (    !TestStringAgainstPattern(GetLocalString(oHide, sBondTypeID), GetLocalString(oItem, "BondID")) // check if bonded with player
          && !TestStringAgainstPattern(gsPCGetPlayerID(oPC), GetLocalString(oItem, "BondID")) // item abilities locked - not lost if another item is used - only for timelocked items
        )
            )
    {
        break_bond_Item (oPC, oItem, nBondType);
        BondItemWrapper(oPC, oItem, nBondType);
    }
    if (GetStringLength(GetLocalString(oHide, sBondTypeID)) > 0 &&
        !TestStringAgainstPattern(GetLocalString(oHide, sBondTypeID), GetLocalString(oItem, "BondID")))
    {
        break_bond_PC(oPC, nBondType);
    }
	
	if (GetLocalInt(oItem, "LevelBond") == 1)
	{
		_updatebonds(oPC, oItem, nBondType);
	}
}


void BondItemWrapper(object oPC, object oItem, int nBondType)
{
    string sTag        = GetStringUpperCase(GetTag(oItem));
    string sBondTypeID = IntToString(nBondType)+"_id";

    if (GetStringLength(GetLocalString(oItem, "BondID")) > 0)
    {
        CheckBonds(oPC, oItem);
    }
    else
    {
		//Get Bond Tag
		int nBondTag = GetLocalInt(oItem, "BondTag");
		
		if (nBondTag == BOND_TAG_NULL)
		{
			return;
		}
        //Bladesinger's Blade
        else if (sTag == "KI_BLDSGR" || GetLocalInt(oItem, "Elfblade") == 1 || nBondTag == BOND_TAG_BLADESINGER)
        {
            BondBladeSingerBlade(oItem, oPC);
        }
        //Thieves Gloves
        else if (sTag == "KI_THFGLV" || nBondTag == BOND_TAG_THIEVESGLOVES)
        {
            BondThievesGloves(oItem, oPC);
        }
    }
}

