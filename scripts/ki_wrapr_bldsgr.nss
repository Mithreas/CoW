//::///////////////////////////////////////////////
//:: ki_wrapr_bldsgr
//:: Library: Bonded Item Functions
//:://////////////////////////////////////////////
/*
    Wrapper for bonding the bladesinger blade
*/
//:://////////////////////////////////////////////
//:: Created By: Kirito
//:: Created On: October 9, 2017
//:://////////////////////////////////////////////

//:: Includes
#include "inc_spellsword"
#include "inc_bondeditems"
#include "inc_bondeditems"
#include "inc_subrace"


//:: Public Function Declarations
//bond the BladeSinger Blade with PC
void BondBladeSingerBlade(object oItem, object oPC);

//bond the BladeSinger Blade with PC
void BondBladeSingerBlade(object oItem, object oPC)
{
    if (miSSGetIsSpellsword(oPC)
        && GetRacialType(oPC) == RACIAL_TYPE_ELF
        && gsSUGetSubRaceByName(GetSubRace(oPC)) != GS_SU_ELF_DROW) // && must be elf && not drow
    {
        bond_item(oItem, oPC, BOND_TAG_BLADESINGER, INVENTORY_SLOT_RIGHTHAND);
    }
    else
    {
        SendMessageToPC(oPC, "Only an Elven spellsword can use this weapon");
    }
}
