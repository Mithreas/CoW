//::///////////////////////////////////////////////
//:: inc_calc_bab
//:: Library: Spellsword
//:://////////////////////////////////////////////
/*
    Functions to calculate BAB
*/
//:://////////////////////////////////////////////
//:: Created By: Kirito
//:: Created On: July 14, 2017
//:://////////////////////////////////////////////

#include "inc_data_arr_int"
#include "nwnx_creature"

/**********************************************************************
 * PUBLIC FUNCTION PROTOTYPES
 **********************************************************************/
// calculates the pre epic portion of BAB
int _Calculate_pre_epic_BAB(object oPC, int bSpellsword = FALSE);
// calculates the BAB of a class at a set level
int _GetBAB(object oPC, int nClass, int nLevel, int bSpellsword = FALSE);

/**********************************************************************
 * PUBLIC FUNCTION DEFINITIONS
 **********************************************************************/
// calculates the pre epic portion of BAB
int _Calculate_BAB(object oPC, int bSpellsword = FALSE)
{
    int nBAB;
    int nLevel = GetCharacterLevel(oPC);
    //works out epic BAB
    if (nLevel > 20)
    {
        nBAB = (nLevel - 19) / 2;
    }

    nBAB += _Calculate_pre_epic_BAB(oPC, bSpellsword);

    return nBAB;
}

// calculates the pre epic portion of BAB
int _Calculate_pre_epic_BAB(object oPC, int bSpellsword = FALSE)
{
    int nBAB;
    int nMaxLevel = 0;

    //set maximum pre epic level
    if (GetCharacterLevel(oPC) <= 20)
    {
        nMaxLevel = GetCharacterLevel(oPC);
    }
    else
    {
        nMaxLevel = 20;
    }

    int nCount;

    int nClass1 = GetClassByPosition(1, oPC);
    int nClass2 = GetClassByPosition(2, oPC);
    int nClass3 = GetClassByPosition(3, oPC);
    int nLevel1 = 0;
    int nLevel2 = 0;
    int nLevel3 = 0;

    for (nCount = 1; nCount <= nMaxLevel; nCount++)
    {
        int nClass = NWNX_Creature_GetClassByLevel(oPC, nCount);
        if (nClass == nClass1)
        {
            nLevel1++;
        }
        else if (nClass == nClass2)
        {
            nLevel2++;
        }
        else if (nClass == nClass3)
        {
            nLevel3++;
        }
    }

    nBAB = _GetBAB(oPC, nClass1, nLevel1, bSpellsword);
	SendMessageToPC(oPC, IntToString(nClass1) + ":" + IntToString(nLevel1) + ":" + IntToString(bSpellsword) + ":" + IntToString(nBAB));

    if (nLevel2 > 0)
    {
        nBAB += _GetBAB(oPC, nClass2, nLevel2, bSpellsword);
		SendMessageToPC(oPC, IntToString(nClass2) + ":" + IntToString(nLevel2) + ":" + IntToString(bSpellsword) + ":" + IntToString(nBAB));
    }
    if (nLevel3 > 0)
    {
        nBAB += _GetBAB(oPC, nClass3, nLevel3, bSpellsword);
		SendMessageToPC(oPC, IntToString(nClass3) + ":" + IntToString(nLevel3) + ":" + IntToString(bSpellsword) + ":" + IntToString(nBAB));
    }

    return nBAB;
}

// calculates the BAB of a class at a set level
int _GetBAB(object oPC, int nClass, int nLevel, int bSpellsword = FALSE)
{
    int nBAB;
    //works out epic BAB
    if (nLevel > 20)
    {
     nBAB = (nLevel - 19) / 2;
     nLevel = 20;
    }

    //works out preepic BAB
    switch (nClass)
    {
        case CLASS_TYPE_ARCANE_ARCHER:
        case CLASS_TYPE_BARBARIAN:
        case CLASS_TYPE_BLACKGUARD:
        case CLASS_TYPE_DIVINE_CHAMPION:
        case CLASS_TYPE_DWARVEN_DEFENDER:
        case CLASS_TYPE_FIGHTER:
        case CLASS_TYPE_PALADIN:
        case CLASS_TYPE_PURPLE_DRAGON_KNIGHT:
        case CLASS_TYPE_RANGER:
        case CLASS_TYPE_WEAPON_MASTER:
        {
            nBAB = nLevel;
			break;
        }
        case CLASS_TYPE_ASSASSIN:
        case CLASS_TYPE_BARD:
        case CLASS_TYPE_CLERIC:
        case CLASS_TYPE_DRAGON_DISCIPLE:
        case CLASS_TYPE_DRUID:
        case CLASS_TYPE_HARPER:
        case CLASS_TYPE_MONK:
        case CLASS_TYPE_ROGUE:
        case CLASS_TYPE_SHADOWDANCER:
        case CLASS_TYPE_SHIFTER:
        {
            nBAB = nLevel * 3 / 4;
			break;
        }
        case CLASS_TYPE_PALE_MASTER:
        case CLASS_TYPE_SORCERER:
        {
            nBAB = nLevel / 2;
			break;
        }
        case CLASS_TYPE_WIZARD:
        {
            if (bSpellsword)
            {
                nBAB = nLevel * 3 / 4;
            }
            else
            {
                nBAB = nLevel / 2;
            }
			break;
        }
    }
    return nBAB;
}

