//::///////////////////////////////////////////////
//:: inc_bondeditems
//:: Library: Bonded Item Functions
//:://////////////////////////////////////////////
/*
    Library with functions for increasing the
    power of items over time.
	
    nBond = Type of bond (see below for currently implemented)
    sBondType = ChestSlot(=1), RightHandSlot(=4), LeftHandSlot(=5)
    BondType_ID = CharName_####
		
    Current types of bond 
		0 = Nobond, 
		1 = Bladesinger's Sword, 
		2 = Thieves Gloves
		3 = Orog Battle Armour
		4 = Orog Heavy Sword
		5 = Orog Bastard Sword

*/
//:://////////////////////////////////////////////
//:: Created By: Kirito
//:: Created On: October 9, 2017
//:://////////////////////////////////////////////


//:: Includes
#include "gs_inc_pc"
#include "gs_inc_subrace"

const int BOND_TAG_NULL = 0;
const int BOND_TAG_BLADESINGER = 1;
const int BOND_TAG_THIEVESGLOVES = 2;
const int BOND_TAG_OROGBATTLEARMOUR = 3;
const int BOND_TAG_OROGHEAVYSWORD = 4;
const int BOND_TAG_OROGBASTARDSWORD = 5;
const int BOND_TAG_EMPTY3 = 8;
const int BOND_TAG_EMPTY4 = 16;
const int BOND_TAG_EMPTY5 = 32;
const int BOND_TAG_EMPTY6 = 64;
const int BOND_TAG_EMPTY7 = 128;

const int BOND_TAG_EMPTY8 = 256;
const int BOND_TAG_EMPTY9 = 512;
const int BOND_TAG_EMPTY10 = 1024;
const int BOND_TAG_EMPTY11 = 2048;
const int BOND_TAG_EMPTY12 = 4096;
const int BOND_TAG_EMPTY13 = 8192;
const int BOND_TAG_EMPTY14 = 16384;
const int BOND_TAG_EMPTY15 = 32768;

const int BOND_TAG_EMPTY16 = 65536;
const int BOND_TAG_EMPTY17 = 131072;
const int BOND_TAG_EMPTY18 = 262144;
const int BOND_TAG_EMPTY19 = 524288;
const int BOND_TAG_EMPTY20 = 1048576;
const int BOND_TAG_EMPTY21 = 2097152;
const int BOND_TAG_EMPTY22 = 4194304;
const int BOND_TAG_EMPTY23 = 8388608;

const int BOND_TAG_EMPTY24 = 16777216;
const int BOND_TAG_EMPTY25 = 33554432;
const int BOND_TAG_EMPTY26 = 16777216;
const int BOND_TAG_EMPTY27 = 33554432;
const int BOND_TAG_EMPTY28 = 67108864;
const int BOND_TAG_EMPTY29 = 134217728;
const int BOND_TAG_EMPTY30 = 268435456;
const int BOND_TAG_EMPTY31 = 536870912;


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
//Add Properties to a bonded weapon
void AddBondedProperties(object oPC, object oItem, int nTimeCount, int nBond, int nBondType);
//Remove the Item Properties from a bonded item
void clear_bond_properties(object oItem);
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
void AddBondedProperties(object oPC, object oItem, int nTimeCount,int nBond, int nBondType)
{
    clear_bond_properties(oItem);
    SendMessageToPC(oPC, "nBond = " + IntToString(nBond));
    SendMessageToPC(oPC, "nTimeCount = " + IntToString(nTimeCount));
	
	//get subrace
	string sSubRace = GetSubRace(oPC);
	int nSubRace    = gsSUGetSubRaceByName(sSubRace);
	
    switch (nBond)
    {
        //no properties, normal weapon
        case BOND_TAG_NULL:
        {
            //no properties, normal weapon
        }
        //Bladesingers Sword
        case BOND_TAG_BLADESINGER:
        {
            if (nTimeCount >= 9)
            {
                SetLocalInt(oItem, "NextBond", -1);
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(4) ,oItem);
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySkillBonus(SKILL_PARRY,4) ,oItem);
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyKeen() ,oItem);
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SLASHING,IP_CONST_DAMAGEBONUS_2) ,oItem);
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_2d4) ,oItem);
                //Lock item properties to this player - using other items of this type will not lose the properties on this item!
                //Use with care - potential exploit for muling?
                SetLocalString(oItem, "BondID", gsPCGetPlayerID(oPC));
                SendMessageToPC(oPC, "Properties have been locked");
            }
            else if (nTimeCount >= 7)
            {
                SetLocalInt(oItem, "NextBond", 9);
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(4) ,oItem);
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySkillBonus(SKILL_PARRY,4) ,oItem);
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyKeen() ,oItem);
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SLASHING,IP_CONST_DAMAGEBONUS_2) ,oItem);
            }
            else if (nTimeCount >= 6)
            {
                SetLocalInt(oItem, "NextBond", 7);
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(4) ,oItem);
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySkillBonus(SKILL_PARRY,4) ,oItem);
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyKeen() ,oItem);
            }
            else if (nTimeCount >= 5)
            {
                SetLocalInt(oItem, "NextBond", 6);
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(3) ,oItem);
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySkillBonus(SKILL_PARRY,4) ,oItem);
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyKeen() ,oItem);
            }
            else if (nTimeCount >= 4)
            {
                SetLocalInt(oItem, "NextBond", 5);
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(2) ,oItem);
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySkillBonus(SKILL_PARRY,4) ,oItem);
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyKeen() ,oItem);
            }
            else if (nTimeCount >= 3)
            {
                SetLocalInt(oItem, "NextBond", 4);
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(2) ,oItem);
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySkillBonus(SKILL_PARRY,4) ,oItem);
            }
            else if (nTimeCount >= 2)
            {
                SetLocalInt(oItem, "NextBond", 3);
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(1) ,oItem);
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySkillBonus(SKILL_PARRY,4) ,oItem);
            }
            else if (nTimeCount >=1)
            {
                SetLocalInt(oItem, "NextBond", 2);
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySkillBonus(SKILL_PARRY,4) ,oItem);
            }
            break;
        }
        //Thieves Gloves - Level locked example
        case BOND_TAG_THIEVESGLOVES:
        {
            if (nTimeCount >= 0)
            {
                //sort timers out so no stack overflow
                object oHide = gsPCGetCreatureHide(oPC);
                SetLocalInt(oItem, "NextBond", 1);
				SetLocalInt(oItem, "LevelBond", 1);
                string sBondTypeCntr = IntToString(nBondType)+"_cntr";
                SetLocalInt(oHide, sBondTypeCntr, 0);

                int nThiefLevels = GetLevelByClass(CLASS_TYPE_ROGUE,oPC);
                int nBonus = (nThiefLevels + 2) / 3;
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySkillBonus(SKILL_OPEN_LOCK,nBonus) ,oItem);
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySkillBonus(SKILL_DISABLE_TRAP,nBonus) ,oItem);
            }
            break;
        }
		//Orog Battle Armour
		case BOND_TAG_OROGBATTLEARMOUR:
		{
			if (nTimeCount >= 0)
            {
                //sort timers out so no stack overflow
                object oHide = gsPCGetCreatureHide(oPC);
                SetLocalInt(oItem, "NextBond", 1);
				SetLocalInt(oItem, "LevelBond", 1);
                string sBondTypeCntr = IntToString(nBondType)+"_cntr";
                SetLocalInt(oHide, sBondTypeCntr, 0);
				
				//add properties
				if (nSubRace == GS_SU_HALFORC_OROG)
				{
					AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(3) ,oItem);
					AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR, 2) ,oItem);
					AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_SLASHING, IP_CONST_DAMAGEIMMUNITY_10_PERCENT) ,oItem);
				}
            }
            break;
		}
		//Orog Heavy Sword
		case BOND_TAG_OROGHEAVYSWORD:
		{
			if (nTimeCount >= 0)
            {
                //sort timers out so no stack overflow
                object oHide = gsPCGetCreatureHide(oPC);
                SetLocalInt(oItem, "NextBond", 1);
				SetLocalInt(oItem, "LevelBond", 1);
                string sBondTypeCntr = IntToString(nBondType)+"_cntr";
                SetLocalInt(oHide, sBondTypeCntr, 0);

                //add properties
				if (nSubRace == GS_SU_HALFORC_OROG)
				{
					SendMessageToPC(oPC, "Adding Properties");
					DelayCommand(0.1,AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(4) ,oItem));
					DelayCommand(0.01,AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyKeen() ,oItem));
					DelayCommand(0.1,AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_BLUDGEONING,IP_CONST_DAMAGEBONUS_4) ,oItem));	
					SendMessageToPC(oPC, "Properties Added");
				}
            }
            break;
		}
		//Orog Bastard Sword
		case BOND_TAG_OROGBASTARDSWORD:
		{
			if (nTimeCount >= 0)
            {
                //sort timers out so no stack overflow
                object oHide = gsPCGetCreatureHide(oPC);
                SetLocalInt(oItem, "NextBond", 1);
				SetLocalInt(oItem, "LevelBond", 1);
                string sBondTypeCntr = IntToString(nBondType)+"_cntr";
                SetLocalInt(oHide, sBondTypeCntr, 0);

                //add properties
				if (nSubRace == GS_SU_HALFORC_OROG)
				{
					AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(4) ,oItem);
					AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyKeen() ,oItem);
					AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_BLUDGEONING,IP_CONST_DAMAGEBONUS_2) ,oItem);
				}
            }
            break;
		}
    }
}

//Remove the Item Properties from a bonded item
//Leaves temp. properties and properties from elemental esscences
void clear_bond_properties(object oItem)
{
	SetLocalInt(oItem, "NextBond", 0);

    int nCount = 0;
    itemproperty ipLoop = GetFirstItemProperty(oItem);
	
	int nBond = GetLocalInt(oItem, "BondType");
	switch (nBond)
    {
		//no properties, normal weapon
		case BOND_TAG_NULL:
		{
			//no properties, normal weapon
		}
		//Bladesingers Sword
		case BOND_TAG_BLADESINGER:
		{ 
			while (GetIsItemPropertyValid(ipLoop))
			{
				if(GetItemPropertyDurationType(ipLoop) == DURATION_TYPE_PERMANENT)//don't remove temp. properties
				{
					//remove divine bonus
					if(GetItemPropertyType(ipLoop) == ITEM_PROPERTY_DAMAGE_BONUS && 
						(GetItemPropertySubType(ipLoop) == IP_CONST_DAMAGETYPE_DIVINE || GetItemPropertySubType(ipLoop) == IP_CONST_DAMAGETYPE_SLASHING)
					  )
					{
						RemoveItemProperty(oItem, ipLoop);
					}
					// remove enhancement bonus or keen
					else if (GetItemPropertyType(ipLoop) == ITEM_PROPERTY_ENHANCEMENT_BONUS || GetItemPropertyType(ipLoop) == ITEM_PROPERTY_KEEN)
					{
						RemoveItemProperty(oItem, ipLoop);
					}
					//Remove skill bonus
					else if(GetItemPropertyType(ipLoop) == ITEM_PROPERTY_SKILL_BONUS && GetItemPropertySubType(ipLoop) == SKILL_PARRY)
					{
						RemoveItemProperty(oItem, ipLoop);
					}
				}
				ipLoop=GetNextItemProperty(oItem);
			}
			break;
		}
		case BOND_TAG_THIEVESGLOVES:
        {
			
			while (GetIsItemPropertyValid(ipLoop))
			{
				if(GetItemPropertyDurationType(ipLoop) == DURATION_TYPE_PERMANENT)//don't remove temp. properties
				{
					//Remove skill bonus
					if(GetItemPropertyType(ipLoop) == ITEM_PROPERTY_SKILL_BONUS && 
						(GetItemPropertySubType(ipLoop) != SKILL_OPEN_LOCK || GetItemPropertySubType(ipLoop) != SKILL_DISABLE_TRAP))
					{
						RemoveItemProperty(oItem, ipLoop);
					}
				}
				ipLoop=GetNextItemProperty(oItem);
			}
			break;
		}
		//Orog Battle Armour
		case BOND_TAG_OROGBATTLEARMOUR:
		{
			while (GetIsItemPropertyValid(ipLoop))
			{
				if(GetItemPropertyDurationType(ipLoop) == DURATION_TYPE_PERMANENT)//don't remove temp. properties
				{
					//Remove bonus
					if((GetItemPropertyType(ipLoop) == ITEM_PROPERTY_ABILITY_BONUS && GetItemPropertySubType(ipLoop) == IP_CONST_ABILITY_STR) ||
						GetItemPropertyType(ipLoop) == ITEM_PROPERTY_AC_BONUS ||
						GetItemPropertyType(ipLoop) == ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE
					  )
					{
						RemoveItemProperty(oItem, ipLoop);
					}
				}
				ipLoop=GetNextItemProperty(oItem);
			}
			break;
		}
		//Orog Heavy Sword
		case BOND_TAG_OROGHEAVYSWORD:
		//Orog Bastard Sword
		case BOND_TAG_OROGBASTARDSWORD:
		{
			while (GetIsItemPropertyValid(ipLoop))
			{
				if(GetItemPropertyDurationType(ipLoop) == DURATION_TYPE_PERMANENT)//don't remove temp. properties
				{
					//remove Damage bonus
					if(GetItemPropertyType(ipLoop) == ITEM_PROPERTY_DAMAGE_BONUS && GetItemPropertySubType(ipLoop) == IP_CONST_DAMAGETYPE_BLUDGEONING)
					{
						RemoveItemProperty(oItem, ipLoop);
					}
					// remove enhancement bonus or keen
					else if (GetItemPropertyType(ipLoop) == ITEM_PROPERTY_ENHANCEMENT_BONUS || GetItemPropertyType(ipLoop) == ITEM_PROPERTY_KEEN)
					{
						RemoveItemProperty(oItem, ipLoop);
					}
				}
				ipLoop=GetNextItemProperty(oItem);
			}
			break;
		}
		default:
		{
			while (GetIsItemPropertyValid(ipLoop))
			{
				if(GetItemPropertyDurationType(ipLoop) == DURATION_TYPE_PERMANENT)//don't remove temp. properties
				{
					//Don't remove elemental damages that will have been added by essences
					if(GetItemPropertyType(ipLoop) == ITEM_PROPERTY_DAMAGE_BONUS)
					{
						//Remove other damage bonuses
						if(GetItemPropertySubType(ipLoop) <= 5 || GetItemPropertySubType(ipLoop) == 8)
						{
							RemoveItemProperty(oItem, ipLoop);
						}
					}
					//Leave bond ability
					else if (GetItemPropertyType(ipLoop) == ITEM_PROPERTY_CAST_SPELL)
					{
					//Remove other cast spell abilities
						if(GetItemPropertySubType(ipLoop) != IP_CONST_CASTSPELL_UNIQUE_POWER_SELF_ONLY)
						{
							RemoveItemProperty(oItem, ipLoop);
						}
					}
					//Remove Property
					else
					{
						RemoveItemProperty(oItem, ipLoop);
					}
				}
				ipLoop=GetNextItemProperty(oItem);
			}
		}
	}
}


