//::///////////////////////////////////////////////
//:: ki_inc_bonditem
//:: Library: Bonded Item Functions
//:://////////////////////////////////////////////
/*
    Library with functions for increasing the
    power of items over time

    nBond = Type of bond (0 = Nobond, 1 = Bladesinger's Sword, 2 = ??)
    sBondType = ChestSlot(=1), RightHandSlot(=4), LeftHandSlot(=5)
    BondType_ID = CharName_####

*/
//:://////////////////////////////////////////////
//:: Created By: Kirito
//:: Created On: October 9, 2017
//:://////////////////////////////////////////////


//:: Includes
#include "gs_inc_pc"
#include "ki_inc_bondprop"

//:: Public Function Declarations

//Form bond with item
void bond_item(object oItem, object oPC, int nBond, int nBondType);
//Break bond with item - Character side
void break_bond_PC(object oPC, int nBondType);
//Break bond with item - Item side
void break_bond_Item(object oPC, object oItem, int nBondType);
//Update all item bond counters on a character
void UpdateBonds(object oPC);
//Actually Update the Bond Counters
void _updatebonds(object oPC, object oITEM, int nBondType);
//Check item bonds
void CheckBonds(object oPC, object oItem);

//:: Function Declarations

//Form bond with item
void bond_item(object oItem, object oPC, int nBond, int nBondType)
{
    //Setup
    object oHide = gsPCGetCreatureHide(oPC);
    string sBondTypeID = IntToString(nBondType)+"_id";
    string sBondType = IntToString(nBondType)+"_type";

    //Check for existing bond and break it if not matching.
    if (GetLocalInt(oHide, sBondType) != 0)
    {
		if(TestStringAgainstPattern(GetLocalString(oHide, sBondTypeID), GetLocalString(oItem, "BondID"))
		|| TestStringAgainstPattern(gsPCGetPlayerID(oPC), GetLocalString(oItem, "BondID")) // item abilities locked - not lost if another item is used - only for timelocked items 
		  )
		{
			return;
		}
		break_bond_PC(oPC, nBondType);
	}

    //set unique ID
    string sBondID;
    //sBondID = GetName(oPC) + "-" + IntToString(d100(10));
    sBondID = gsPCGetPlayerID(oPC) + "-" + IntToString(gsTIGetActualTimestamp());

    //set Timer
    string sBondTypeCntr = IntToString(nBondType)+"_cntr";
    SetLocalInt(oHide, sBondTypeCntr, 0);

    //set bonded flag
    SetLocalString(oHide, sBondTypeID, sBondID);
    SetLocalInt(oHide, sBondType, nBond);
    SetLocalString(oItem, "BondID", sBondID);
    SetLocalInt(oItem, "NextBond", 1);
	SetLocalInt(oItem, "BondType", nBond);

    //update properties
    _updatebonds(oPC, oItem, nBondType);

    SendMessageToPC(oPC, "sBondTypeID - "+sBondTypeID + "-" + sBondID);
    SendMessageToPC(oPC, "sBondTypeID-PC - "+ GetLocalString(oHide, sBondTypeID));
    SendMessageToPC(oPC, "sBondTypeID-Item - " + GetLocalString(oItem, "BondID"));
    SendMessageToPC(oPC, "sBondType - "+sBondType + "-" + IntToString(nBond));
    SendMessageToPC(oPC, "sBondTypeCntr - "+sBondTypeCntr + "-" + IntToString(GetLocalInt(oHide,sBondTypeCntr)));
    SendMessageToPC(oPC, "NextBond - " + IntToString(GetLocalInt(oItem,"NextBond")));
}

//Break bond with item - Character side
void break_bond_PC(object oPC, int nBondType)
{
    string sItem;
    if (nBondType == INVENTORY_SLOT_CHEST)
    {
        sItem = "Armour";
    }
    else if (nBondType == INVENTORY_SLOT_ARMS)
    {
        sItem = "Gloves";
    }
    else
    {
        sItem = "Weapon";
    }
    SendMessageToPC(oPC, "You have broken the bond with your "+sItem);


    //Setup
    object oHide = gsPCGetCreatureHide(oPC);
    string sBondTypeID = IntToString(nBondType)+"_id";
    string sBondType = IntToString(nBondType)+"_type";
    string sBondTypeCntr = IntToString(nBondType)+"_cntr";

    //Clear Flags
    SetLocalString(oHide, sBondTypeID, "");
    SetLocalInt(oHide, sBondType, 0);

    //Reset Timer
    SetLocalInt(oHide, sBondTypeCntr, 0);
}

//Break bond with item - Item side
void break_bond_Item(object oPC, object oItem, int nBondType)
{
    string sItem;
    if (nBondType == INVENTORY_SLOT_CHEST)
    {
        sItem = "Armour";
    }
    else if (nBondType == INVENTORY_SLOT_ARMS)
    {
        sItem = "Gloves";
    }
    else
    {
        sItem = "Weapon";
    }
    SendMessageToPC(oPC, "The power fades from this "+sItem);


    //clear Tags
    SetLocalString(oItem, "BondID", "");

    //clear properties
    clear_bond_properties(oItem);
}

//Update all item bond counters on a character
void UpdateBonds(object oPC)
{
    //Setup
    object oHide = gsPCGetCreatureHide(oPC);
    object oChest = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    object oArms = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);
    object oRHand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    object oLHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);

    int nBondType;

    if (oChest != OBJECT_INVALID)
    {
        _updatebonds(oPC, oChest, INVENTORY_SLOT_CHEST);
    }
    if (oArms != OBJECT_INVALID)
    {
        _updatebonds(oPC, oArms, INVENTORY_SLOT_ARMS);
    }
    if (oRHand != OBJECT_INVALID)
    {
        _updatebonds(oPC, oRHand, INVENTORY_SLOT_RIGHTHAND);
    }
    if (oLHand != OBJECT_INVALID)
    {
        _updatebonds(oPC, oLHand, INVENTORY_SLOT_LEFTHAND);
    }
}

//Actually Update the Bond Counters
void _updatebonds(object oPC, object oItem, int nBondType)
{
    //Setup
    object oHide = gsPCGetCreatureHide(oPC);
    string sBondTypeID = IntToString(nBondType)+"_id";
    string sBondTypeCntr = IntToString(nBondType)+"_cntr";
    string sBondType = IntToString(nBondType)+"_type";

    //SendMessageToPC(oPC, sBondTypeID + " - " + GetLocalString(oHide, sBondTypeID));
    //SendMessageToPC(oPC, GetLocalString(oHide, sBondTypeID) + "_" + GetLocalString(oItem, "BondID"));
    if (GetStringLength(GetLocalString(oHide, sBondTypeID)) > 0)
    {
        if (TestStringAgainstPattern(GetLocalString(oHide, sBondTypeID), GetLocalString(oItem, "BondID"))
			|| TestStringAgainstPattern(gsPCGetPlayerID(oPC), GetLocalString(oItem, "BondID")) // item abilities locked - not lost if another item is used - only for timelocked items
		   )
		{
            int NewCnt = GetLocalInt(oHide, sBondTypeCntr) + 1;
            SetLocalInt(oHide, sBondTypeCntr, NewCnt);
            if (NewCnt >= GetLocalInt(oItem, "NextBond") && GetLocalInt(oItem, "NextBond") != -1)
            {
                SendMessageToPC(oPC, "The magical bond grows stronger");
                AddBondedProperties(oPC, oItem, NewCnt, GetLocalInt(oHide, sBondType), nBondType);
            }
        }
        else
        {
            break_bond_PC(oPC, nBondType);
        }
    }
}


