//::///////////////////////////////////////////////
//:: ki_inc_bondprop
//:: Library: Bonded Item Properties
//:://////////////////////////////////////////////
/*
    Library with properties of items that grow in
    power over time

    nBond = Type of bond 
		0 = Nobond, 
		1 = Bladesinger's Sword, 
		2 = Thieves Gloves
		3 = Orog Battle Armour
		4 = Orog Heavy Sword
		5 = Orog Bastard Sword
    BondType_ID = CharName_####

*/
//:://////////////////////////////////////////////
//:: Created By: Kirito
//:: Created On: October 9, 2017
//:://////////////////////////////////////////////

//:: Includes
#include "inc_bondtags"
#include "inc_subrace"

//:: Public Function Declarations

//Add Properties to a bonded weapon
void AddBondedProperties(object oPC, object oItem, int nTimeCount, int nBond, int nBondType);
//Remove the Item Properties from a bonded item
void clear_bond_properties(object oItem);

//:: Function Declarations
void AddBondedProperties(object oPC, object oItem, int nTimeCount,int nBond, int nBondType)
{
    clear_bond_properties(oItem);
    //SendMessageToPC(oPC, "nBond = " + IntToString(nBond));
    //SendMessageToPC(oPC, "nTimeCount = " + IntToString(nTimeCount));
	
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


