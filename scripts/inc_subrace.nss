//::///////////////////////////////////////////////
//:: Name  inc_subrace
//:: FileName
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Purpose of this include is to move functions from gs_inc_subrace
    that are not dependant on other libraries to reduce circular dependances
    Feel free to add any I missed.
    If you wish to add functions that are subraced related and dependant on other libraries
    Please add them to gs_inc_subrace

    How to add a subrace:

    inc_subrace (this file)

    constant groups:

    GS_SU_??? add one for your subrace

    NAME_GS_SU_?? name of subrace

    DESC_GS_SU_?? desc of subrace

    HIGHEST_SR & HIGHEST_SSR - Highest subrace

    Optional: MD_BIT_??? currently only used for warehouse/crafting. Only add for non-5%s that are different enough from base race

    Functions:

    All of them may need to be looked at.

    Those starting with md* are optional and only to be used if using bitwise.


    Script: gs_inc_subrace

    Functions:

    gsSUApplyProperty: use to add propeties, seperate into files once for character life time and every log in sections.

    Follow other subraces as an example

    Script: zdlg_subrace

    is_UnderdarkSubrace - needs to be looked at if adding a halfling/gnome/dwarf base race

    _ApplySubrace - especially for award or reskinned races

    Init - where you add the subrace as an option

    Script: ck_entermyon1 & ck_entermyon2

    May need additions if a base race half elf or elf is used

    Script: ck_ishalfling

    May need additions if base race is halfling

    Script: sep_earthkinport

    May need additions if base race is any of the earthkin.

    Script: ar_utils

    If is underdark race

    Script: gs_inc_langage

    Function:

    _gsLAGetCanSpeakLanguage To modify what language it can speak

    Remember to remove base race language if necessary

    Script: gs_inc_worship

    Function:

    gsWOGetIsRacialTypeAllowed

    To change deity selection, remember to remove base race deities if necessary.


*/
//:://////////////////////////////////////////////
//:: Created By:  Mord
//:: Created On:  3/21/17
//:://////////////////////////////////////////////

#include "gs_inc_text"

const string SUBRACE    = "SUBRACE"; // for logging

//void main() {}

const string GS_SU_TEMPLATE_PROPERTY      = "gs_item317";
const string GS_SU_TEMPLATE_ABILITY       = "gs_item318";

const int GS_SU_NONE                      =   0;
const int GS_SU_DWARF_GOLD                =   1;
const int GS_SU_DWARF_GRAY                =   2;
const int GS_SU_DWARF_SHIELD              =   3;
const int GS_SU_ELF_DROW                  =   4;
const int GS_SU_ELF_MOON                  =   5;
const int GS_SU_ELF_SUN                   =   6;
const int GS_SU_ELF_WILD                  =   7;
const int GS_SU_ELF_WOOD                  =   8;
const int GS_SU_GNOME_DEEP                =   9;
const int GS_SU_GNOME_ROCK                =  10;
const int GS_SU_HALFLING_GHOSTWISE        =  11;
const int GS_SU_HALFLING_LIGHTFOOT        =  12;
const int GS_SU_HALFLING_STRONGHEART      =  13;
const int GS_SU_PLANETOUCHED_AASIMAR      =  14;
const int GS_SU_PLANETOUCHED_GENASI_AIR   =  15;
const int GS_SU_PLANETOUCHED_GENASI_EARTH =  16;
const int GS_SU_PLANETOUCHED_GENASI_FIRE  =  17;
const int GS_SU_PLANETOUCHED_GENASI_WATER =  18;
const int GS_SU_PLANETOUCHED_TIEFLING     =  19;
const int GS_SU_HALFORC_OROG              =  20;
const int GS_SU_HALFORC_GNOLL             =  21;
const int GS_SU_GNOME_FOREST              =  22;
const int GS_SU_FR_OROG = 23;
const int GS_SU_DWARF_WILD                = 24;
const int GS_SU_DEEP_IMASKARI             = 25;

const int GS_SU_SPECIAL_FEY               = 100;
const int GS_SU_SPECIAL_GOBLIN            = 101;
const int GS_SU_SPECIAL_KOBOLD            = 102;
const int GS_SU_SPECIAL_BAATEZU           = 103;
const int GS_SU_SPECIAL_RAKSHASA          = 104;
const int GS_SU_SPECIAL_DRAGON            = 105;
const int GS_SU_SPECIAL_VAMPIRE           = 106;
const int GS_SU_SPECIAL_OGRE              = 107;
const int GS_SU_SPECIAL_IMP               = 108;
const int GS_SU_SPECIAL_HOBGOBLIN         = 109;
const int GS_SU_SPECIAL_CAMBION           = 110;

//Please update to highest subrace
const int HIGHEST_SR = 25;
const int HIGHEST_SSR = 110;

//Race represented as bits
const int MD_BIT_DWARF                    = 0x01; //use for shield as well!
const int MD_BIT_ELF                      = 0x02; //use for moon as well!
const int MD_BIT_HORC                     = 0x04;
const int MD_BIT_HUMAN                    = 0x08;
const int MD_BIT_HELF                     = 0x10;
const int MD_BIT_HLING                    = 0x20;  //use for lightfoot
const int MD_BIT_GNOME                    = 0x40;  //use for rock gnomes too
//Now monster subraces
const int MD_BIT_DUERGAR                  = 0x80;
const int MD_BIT_DROW                     = 0x100;
const int MD_BIT_DEEP_GNOME               = 0x200;
const int MD_BIT_OROG                     = 0x400;
const int MD_BIT_GNOLL                    = 0x800;
const int MD_BIT_FEY                      = 0x1000;
const int MD_BIT_GOBLIN                   = 0x2000;
const int MD_BIT_KOBOLD                   = 0x4000;
//const int MB_BIT_FR_OROG                  = 0x8000; //fr orog can use the orog bit
const int MD_BIT_FOREST_GNOME             = 0x8000;
const int MD_BIT_SUN_ELF                  = 0x10000;
const int MD_BIT_WOOD_ELF                 = 0x20000;
const int MD_BIT_WILD_ELF                 = 0x40000;
const int MD_BIT_DWARF_GOLD               = 0x80000;
const int MD_BIT_AASIMAR                  = 0x100000;
const int MD_BIT_TIEFLING                 = 0x200000;
const int MD_BIT_HL_STR                   = 0x400000;
const int MD_BIT_HL_GHOST                 = 0x800000;
const int MD_BIT_HOBGOBLIN                = 0x1000000;
const int MD_BIT_IMP                      = 0x2000000;
const int MD_BIT_OGRE                     = 0x4000000;
const int MD_BIT_DWARF_WILD               = 0x8000000;
const int MD_BIT_DEEP_IMASKARI            = 0x10000000; //begining of last set

//Subrace groups
const int MD_BIT_UNDARK                   = 0x17006780;
const int MD_BIT_SU_ELF                   = 0x70012;
const int MD_BIT_SU_DWARF                 = 0x8080001;
const int MD_BIT_SU_GNOMES                = 0x8040;
const int MD_BIT_SU_HL                    = 0xC00020;
const int MD_BIT_EARTHKIN                 = 0x8C88061;

const string NAME_GS_SU_FR_OROG = GS_T_16777582;
const string NAME_GS_SU_VAMPIRE = "Vampire";
const string DESC_GS_SU_VAMPIRE = "(Favored Class: Wizard)\n\nEveryone knows Vampires.\n\nRequires Major Award (and approval by admin team). Undead Traits, Bat Shape, Regeneration +1 (in Sun -1), Vulnerability to Heal/Mass Heal. ECL +3";
const string NAME_GS_SU_OGRE    = "Ogre";
const string DESC_GS_SU_OGRE    = "\nNOTE: Selecting this subrace will change your appearance to that of an Ogre.\n(Str +6, Con +2, Int -4, Cha -4, Dex -2, Darkvision, +2 Natural AC, -4 Hide, 5% Physical Immunity, Favored Class: Barbarian, ECL +2)\n\nAdult ogres stand 9 to 10 feet tall and weigh 600 to 650 pounds. They tend to be lazy and brutal, preferring to rely on an ambush and overwhelming numbers in battle. Ogres often works as mercenaries, hoping for easy plunder.";
const string NAME_GS_SU_HOBGOB  = "Hobgoblin";
const string DESC_GS_SU_HOBGOB  = "\nNOTE: Selecting this subrace will change your appearance to that of a Hobgoblin.\n(Con +2, Dex +2, Darkvision, +4 Move Silently, Favored Class: Fighter, ECL +1)\n\nHobgoblins are a larger, stronger, smarter, and more menacing form of goblinoids. They sometimes act as commanders over their lesser goblinoids such as the Goblins.";
const string NAME_GS_SU_IMP     = "Imp";
const string DESC_GS_SU_IMP     = "\nNOTE: Selecting this subrace will change your appearance to that of an Imp.\n(Cha +4, +2 Dex, -4 Str, Darkvision, Invisibility, Polymorph Self, Regeneration +2, Tiny Weapons only, Favored Class: Rogue, ECL +3)\n\nImps are vicious, manipulative fiends that make up some of the lesser ranks of the infernal legions. They serve as tempters and lackeys to mortals whom devils want groomed to the side of evil. Imps delight in the opportunity to leave Hell and tempt a mortal to evil.";
const string NAME_GS_SU_DWAWIL  = "Wild Dwarf";
const string DESC_GS_SU_DWAWIL  = "\nNOTE: Selecting this subrace will change your racial stats as follows:\n(As Base Dwarf. Size: Small. Gains: Poison Use, Fire Immunity 15%, +1 additional save against poison, +4 saves against disease. Loses: Skill affinity Lore and Stonecunning. Favored Class: Barbarian, ECL +0)\n\n";
const string NAME_GS_SU_DPIMA  = "Deep Imaskari";
const string DESC_GS_SU_DPIMA  = "\nNOTE: Selecting this subrace will change your racial stats as follows:\n(-2 dex, +2 int. Low-light vision, Spell Clutch (Refresh circle 1 spells 1/day), +4 hide, Language: Undercommon. Loses: All half-elf feats, elven. Favored Class: Wizard, ECL +0)\n\n";
const string NAME_GS_SU_CAMBION = "Cambion";
const string DESC_GS_SU_CAMBION = "(Favored Class: Rogue)\n\nCambions are considered to be the result of breeding a devil with mortals. In general, a Cambion is described as any humanoid creature that is half-fiend.\n\nRequires Major Award (and approval by admin team). +2 STR, +4 CHA, Darkvision, Bonus Language: Infernal, Pit Fiend Shape. ECL +3";


//return subrace constant resembling sSubRace
int gsSUGetSubRaceByName(string sSubRace);
//return name of nSubRace
string gsSUGetNameBySubRace(int nSubRace);
//return effective character level for nSubRace of nLevel
int gsSUGetECL(int nSubRace, int nLevel);
//return favored class of nSubRace and nGender
int gsSUGetFavoredClass(int nSubRace, int nGender = GENDER_MALE);
//return description of nSubRace (text description of race and abilities)
string gsSUGetDescriptionBySubRace(int nSubRace);
// return TRUE if this is an UD-based subrace
int gsSUGetIsUnderdarker(int nSubRace);
// return TRUE if this is an UD-bases subrace that is usually hostile to
// surfacers (i.e. excludes gnolls and svirfs).
int gsSUGetIsHostileUnderdarker(int nSubRace);
// return TRUE if this is a neutral subrace (gnolls and svirfs)
int gsSUGetIsNeutralRace(int nSubRace);
// return TRUE if this race is mortal.
int gsSUGetIsMortal(int nSubrace);
// return the name of nRacialType
string gsSUGetRaceName(int nRacialType);
//Returns the bit given racial Number
int md_ConvertRaceToBit(int nRace);
//Returns the bit given subrace.
int md_ConvertSubraceToBit(int nSubrace);
//Returns true if PC belongs to any sub/race specified in nSubracebit
int md_IsSubRace(int nSubracebit, object oPC);
//----------------------------------------------------------------

int gsSUGetSubRaceByName(string sSubRace)
{
    // Addition by Mithreas - subraces may have a background attached.
    int nPara1 = FindSubString(sSubRace, "(");

    if (nPara1 > -1)
    {
      // subrace = player's subrace (player's background)
      sSubRace = GetStringLeft(sSubRace, nPara1 - 1);
    }

    if (sSubRace == GS_T_16777263) return GS_SU_DWARF_GOLD;
    if (sSubRace == GS_T_16777264) return GS_SU_DWARF_GRAY;
    if (sSubRace == GS_T_16777265) return GS_SU_DWARF_SHIELD;
    if (sSubRace == GS_T_16777266) return GS_SU_ELF_DROW;
    if (sSubRace == GS_T_16777267) return GS_SU_ELF_MOON;
    if (sSubRace == GS_T_16777268) return GS_SU_ELF_SUN;
    if (sSubRace == GS_T_16777269) return GS_SU_ELF_WILD;
    if (sSubRace == GS_T_16777270) return GS_SU_ELF_WOOD;
    if (sSubRace == GS_T_16777271) return GS_SU_GNOME_DEEP;
    if (sSubRace == GS_T_16777272) return GS_SU_GNOME_ROCK;
    if (sSubRace == GS_T_16777599) return GS_SU_GNOME_FOREST;
    if (sSubRace == GS_T_16777273) return GS_SU_HALFLING_GHOSTWISE;
    if (sSubRace == GS_T_16777274) return GS_SU_HALFLING_LIGHTFOOT;
    if (sSubRace == GS_T_16777275) return GS_SU_HALFLING_STRONGHEART;
    if (sSubRace == GS_T_16777276) return GS_SU_PLANETOUCHED_AASIMAR;
    if (sSubRace == GS_T_16777277) return GS_SU_PLANETOUCHED_GENASI_AIR;
    if (sSubRace == GS_T_16777278) return GS_SU_PLANETOUCHED_GENASI_EARTH;
    if (sSubRace == GS_T_16777279) return GS_SU_PLANETOUCHED_GENASI_FIRE;
    if (sSubRace == GS_T_16777280) return GS_SU_PLANETOUCHED_GENASI_WATER;
    if (sSubRace == GS_T_16777281) return GS_SU_PLANETOUCHED_TIEFLING;
    if (sSubRace == GS_T_16777427) return GS_SU_SPECIAL_FEY;
    if (sSubRace == GS_T_16777428) return GS_SU_SPECIAL_GOBLIN;
    if (sSubRace == GS_T_16777429) return GS_SU_SPECIAL_KOBOLD;
    if (sSubRace == GS_T_16777536) return GS_SU_SPECIAL_BAATEZU;
    if (sSubRace == GS_T_16777582) return GS_SU_HALFORC_OROG;
    if (sSubRace == GS_T_16777587) return GS_SU_HALFORC_GNOLL;
    if (sSubRace == GS_T_16777594) return GS_SU_SPECIAL_RAKSHASA;
    if (sSubRace == GS_T_16777596) return GS_SU_SPECIAL_DRAGON;
    if (sSubRace == NAME_GS_SU_FR_OROG) return GS_SU_FR_OROG;
    if (sSubRace == NAME_GS_SU_VAMPIRE) return GS_SU_SPECIAL_VAMPIRE;
    if (sSubRace == NAME_GS_SU_OGRE)    return GS_SU_SPECIAL_OGRE;
    if (sSubRace == NAME_GS_SU_IMP)     return GS_SU_SPECIAL_IMP;
    if (sSubRace == NAME_GS_SU_HOBGOB)  return GS_SU_SPECIAL_HOBGOBLIN;
    if (sSubRace == NAME_GS_SU_DWAWIL)  return GS_SU_DWARF_WILD;
    if (sSubRace == NAME_GS_SU_DPIMA)   return GS_SU_DEEP_IMASKARI;
    if (sSubRace == NAME_GS_SU_CAMBION) return GS_SU_SPECIAL_CAMBION;
    return GS_SU_NONE;
}
//----------------------------------------------------------------
string gsSUGetNameBySubRace(int nSubRace)
{
    switch (nSubRace)
    {
    case GS_SU_DWARF_GOLD:                return GS_T_16777263;
    case GS_SU_DWARF_GRAY:                return GS_T_16777264;
    case GS_SU_DWARF_SHIELD:              return GS_T_16777265;
    case GS_SU_ELF_DROW:                  return GS_T_16777266;
    case GS_SU_ELF_MOON:                  return GS_T_16777267;
    case GS_SU_ELF_SUN:                   return GS_T_16777268;
    case GS_SU_ELF_WILD:                  return GS_T_16777269;
    case GS_SU_ELF_WOOD:                  return GS_T_16777270;
    case GS_SU_GNOME_DEEP:                return GS_T_16777271;
    case GS_SU_GNOME_ROCK:                return GS_T_16777272;
    case GS_SU_GNOME_FOREST:              return GS_T_16777599;
    case GS_SU_HALFLING_GHOSTWISE:        return GS_T_16777273;
    case GS_SU_HALFLING_LIGHTFOOT:        return GS_T_16777274;
    case GS_SU_HALFLING_STRONGHEART:      return GS_T_16777275;
    case GS_SU_PLANETOUCHED_AASIMAR:      return GS_T_16777276;
    case GS_SU_PLANETOUCHED_GENASI_AIR:   return GS_T_16777277;
    case GS_SU_PLANETOUCHED_GENASI_EARTH: return GS_T_16777278;
    case GS_SU_PLANETOUCHED_GENASI_FIRE:  return GS_T_16777279;
    case GS_SU_PLANETOUCHED_GENASI_WATER: return GS_T_16777280;
    case GS_SU_PLANETOUCHED_TIEFLING:     return GS_T_16777281;
    case GS_SU_SPECIAL_FEY:               return GS_T_16777427;
    case GS_SU_SPECIAL_GOBLIN:            return GS_T_16777428;
    case GS_SU_SPECIAL_KOBOLD:            return GS_T_16777429;
    case GS_SU_SPECIAL_BAATEZU:           return GS_T_16777536;
    case GS_SU_HALFORC_OROG:              return GS_T_16777582;
    case GS_SU_FR_OROG:                   return NAME_GS_SU_FR_OROG;
    case GS_SU_HALFORC_GNOLL:             return GS_T_16777587;
    case GS_SU_SPECIAL_RAKSHASA:          return GS_T_16777594;
    case GS_SU_SPECIAL_DRAGON:            return GS_T_16777596;
    case GS_SU_SPECIAL_VAMPIRE:           return NAME_GS_SU_VAMPIRE;
    case GS_SU_SPECIAL_OGRE:              return NAME_GS_SU_OGRE;
    case GS_SU_SPECIAL_IMP:               return NAME_GS_SU_IMP;
    case GS_SU_SPECIAL_HOBGOBLIN:         return NAME_GS_SU_HOBGOB;
    case GS_SU_DWARF_WILD:                return NAME_GS_SU_DWAWIL;
    case GS_SU_DEEP_IMASKARI:             return NAME_GS_SU_DPIMA;
    case GS_SU_SPECIAL_CAMBION:           return NAME_GS_SU_CAMBION;

    }

    return "";
}

//----------------------------------------------------------------
int gsSUGetECL(int nSubRace, int nLevel)
{
    switch (nSubRace)
    {
    case GS_SU_DWARF_GOLD:                return nLevel;
    case GS_SU_DWARF_GRAY:                return nLevel + 1;
    case GS_SU_DWARF_SHIELD:              return nLevel;
    case GS_SU_ELF_DROW:                  return nLevel + 2;
    case GS_SU_ELF_MOON:                  return nLevel;
    case GS_SU_ELF_SUN:                   return nLevel;
    case GS_SU_ELF_WILD:                  return nLevel;
    case GS_SU_ELF_WOOD:                  return nLevel;
    case GS_SU_GNOME_DEEP:                return nLevel + 2;
    case GS_SU_GNOME_ROCK:                return nLevel;
    case GS_SU_GNOME_FOREST:              return nLevel;
    case GS_SU_HALFLING_GHOSTWISE:        return nLevel;
    case GS_SU_HALFLING_LIGHTFOOT:        return nLevel;
    case GS_SU_HALFLING_STRONGHEART:      return nLevel;
    case GS_SU_PLANETOUCHED_AASIMAR:      return nLevel + 1;
    case GS_SU_PLANETOUCHED_GENASI_AIR:   return nLevel + 1;
    case GS_SU_PLANETOUCHED_GENASI_EARTH: return nLevel + 1;
    case GS_SU_PLANETOUCHED_GENASI_FIRE:  return nLevel + 1;
    case GS_SU_PLANETOUCHED_GENASI_WATER: return nLevel + 1;
    case GS_SU_PLANETOUCHED_TIEFLING:     return nLevel + 1;
    case GS_SU_SPECIAL_FEY:               return nLevel + 2;
    case GS_SU_SPECIAL_GOBLIN:            return nLevel;
    case GS_SU_SPECIAL_KOBOLD:            return nLevel;
    case GS_SU_SPECIAL_BAATEZU:           return nLevel + 4;
    case GS_SU_HALFORC_OROG:              return nLevel;
    // FR Orogs have +2 ECL. However, for migration purposes, this is applied when
    // stat bonuses are applied, since character creation dialogue cannot distinguish
    // these from old-style orogs.
    case GS_SU_FR_OROG:                   return nLevel;
    case GS_SU_HALFORC_GNOLL:             return nLevel + 1;
    case GS_SU_SPECIAL_RAKSHASA:          return nLevel + 5;
    case GS_SU_SPECIAL_DRAGON:            return nLevel + 4;
    case GS_SU_SPECIAL_VAMPIRE:           return nLevel + 3;
    case GS_SU_SPECIAL_OGRE:              return nLevel + 2;
    case GS_SU_SPECIAL_HOBGOBLIN:         return nLevel + 1;
    case GS_SU_SPECIAL_IMP:               return nLevel + 3;
    case GS_SU_DWARF_WILD:
    case GS_SU_DEEP_IMASKARI:             return nLevel;
    case GS_SU_SPECIAL_CAMBION:           return nLevel + 3;
    }

    return nLevel;
}
//----------------------------------------------------------------
int gsSUGetFavoredClass(int nSubRace, int nGender = GENDER_MALE)
{
    switch (nSubRace)
    {
    case GS_SU_DWARF_GOLD:                return CLASS_TYPE_FIGHTER;
    case GS_SU_DWARF_GRAY:                return CLASS_TYPE_FIGHTER;
    case GS_SU_DWARF_SHIELD:              return CLASS_TYPE_FIGHTER;
    case GS_SU_ELF_DROW:
        if (nGender == GENDER_MALE)   return CLASS_TYPE_WIZARD;
        if (nGender == GENDER_FEMALE) return CLASS_TYPE_CLERIC;
        return CLASS_TYPE_INVALID;
    case GS_SU_ELF_MOON:                  return CLASS_TYPE_WIZARD;
    case GS_SU_ELF_SUN:                   return CLASS_TYPE_WIZARD;
    case GS_SU_ELF_WILD:                  return CLASS_TYPE_SORCERER;
    case GS_SU_ELF_WOOD:                  return CLASS_TYPE_RANGER;
    case GS_SU_GNOME_DEEP:                return CLASS_TYPE_WIZARD;
    case GS_SU_GNOME_ROCK:                return CLASS_TYPE_WIZARD;
    case GS_SU_GNOME_FOREST:              return CLASS_TYPE_BARD;
    case GS_SU_HALFLING_GHOSTWISE:        return CLASS_TYPE_BARBARIAN;
    case GS_SU_HALFLING_LIGHTFOOT:        return CLASS_TYPE_ROGUE;
    case GS_SU_HALFLING_STRONGHEART:      return CLASS_TYPE_ROGUE;
    case GS_SU_PLANETOUCHED_AASIMAR:      return CLASS_TYPE_PALADIN;
    case GS_SU_PLANETOUCHED_GENASI_AIR:   return CLASS_TYPE_FIGHTER;
    case GS_SU_PLANETOUCHED_GENASI_EARTH: return CLASS_TYPE_FIGHTER;
    case GS_SU_PLANETOUCHED_GENASI_FIRE:  return CLASS_TYPE_FIGHTER;
    case GS_SU_PLANETOUCHED_GENASI_WATER: return CLASS_TYPE_FIGHTER;
    case GS_SU_PLANETOUCHED_TIEFLING:     return CLASS_TYPE_ROGUE;
    case GS_SU_SPECIAL_FEY:               return CLASS_TYPE_DRUID;
    case GS_SU_SPECIAL_GOBLIN:            return CLASS_TYPE_ROGUE;
    case GS_SU_SPECIAL_KOBOLD:            return CLASS_TYPE_SORCERER;
    case GS_SU_SPECIAL_BAATEZU:           return CLASS_TYPE_FIGHTER;
    case GS_SU_HALFORC_OROG:              return CLASS_TYPE_FIGHTER;
    case GS_SU_FR_OROG:                   return CLASS_TYPE_FIGHTER;
    case GS_SU_HALFORC_GNOLL:             return CLASS_TYPE_RANGER;
    case GS_SU_SPECIAL_RAKSHASA:          return CLASS_TYPE_SORCERER;
    case GS_SU_SPECIAL_DRAGON:            return CLASS_TYPE_SORCERER;
    case GS_SU_SPECIAL_VAMPIRE:           return CLASS_TYPE_WIZARD;
    case GS_SU_SPECIAL_OGRE:              return CLASS_TYPE_BARBARIAN;
    case GS_SU_SPECIAL_HOBGOBLIN:         return CLASS_TYPE_FIGHTER;
    case GS_SU_SPECIAL_IMP:               return CLASS_TYPE_ROGUE;
    case GS_SU_DWARF_WILD:                return CLASS_TYPE_BARBARIAN;
    case GS_SU_DEEP_IMASKARI:             return CLASS_TYPE_WIZARD;
    case GS_SU_SPECIAL_CAMBION:           return CLASS_TYPE_ROGUE;
    }

    return CLASS_TYPE_INVALID;
}

//----------------------------------------------------------------
string gsSUGetDescriptionBySubRace(int nSubRace)
{
    switch (nSubRace)
    {
    case GS_SU_DWARF_GOLD:                return GS_T_16777558;
    case GS_SU_DWARF_GRAY:                return GS_T_16777559;
    case GS_SU_DWARF_SHIELD:              return GS_T_16777560;
    case GS_SU_ELF_DROW:                  return GS_T_16777561;
    case GS_SU_ELF_MOON:                  return GS_T_16777562;
    case GS_SU_ELF_SUN:                   return GS_T_16777563;
    case GS_SU_ELF_WILD:                  return GS_T_16777564;
    case GS_SU_ELF_WOOD:                  return GS_T_16777565;
    case GS_SU_GNOME_DEEP:                return GS_T_16777566;
    case GS_SU_GNOME_ROCK:                return GS_T_16777567;
    case GS_SU_GNOME_FOREST:              return GS_T_16777600;
    case GS_SU_HALFLING_GHOSTWISE:        return GS_T_16777568;
    case GS_SU_HALFLING_LIGHTFOOT:        return GS_T_16777569;
    case GS_SU_HALFLING_STRONGHEART:      return GS_T_16777570;
    case GS_SU_PLANETOUCHED_AASIMAR:      return GS_T_16777571;
    case GS_SU_PLANETOUCHED_GENASI_AIR:   return GS_T_16777572;
    case GS_SU_PLANETOUCHED_GENASI_EARTH: return GS_T_16777573;
    case GS_SU_PLANETOUCHED_GENASI_FIRE:  return GS_T_16777574;
    case GS_SU_PLANETOUCHED_GENASI_WATER: return GS_T_16777575;
    case GS_SU_PLANETOUCHED_TIEFLING:     return GS_T_16777576;
    case GS_SU_SPECIAL_FEY:               return GS_T_16777577;
    case GS_SU_SPECIAL_GOBLIN:            return GS_T_16777578;
    case GS_SU_SPECIAL_KOBOLD:            return GS_T_16777579;
    case GS_SU_SPECIAL_BAATEZU:           return GS_T_16777580;
    case GS_SU_HALFORC_OROG:              return GS_T_16777583;
    case GS_SU_FR_OROG:                   return GS_T_16777583;
    case GS_SU_HALFORC_GNOLL:             return GS_T_16777588;
    case GS_SU_SPECIAL_RAKSHASA:          return GS_T_16777595;
    case GS_SU_SPECIAL_DRAGON:            return GS_T_16777597;
    case GS_SU_SPECIAL_VAMPIRE:           return DESC_GS_SU_VAMPIRE;
    case GS_SU_SPECIAL_OGRE:              return DESC_GS_SU_OGRE;
    case GS_SU_SPECIAL_HOBGOBLIN:         return DESC_GS_SU_HOBGOB;
    case GS_SU_SPECIAL_IMP:               return DESC_GS_SU_IMP;
    case GS_SU_DWARF_WILD:                return DESC_GS_SU_DWAWIL;
    case GS_SU_DEEP_IMASKARI:             return DESC_GS_SU_DPIMA;
    case GS_SU_SPECIAL_CAMBION:           return DESC_GS_SU_CAMBION;
    }

    return "";
}
//----------------------------------------------------------------
int gsSUGetIsUnderdarker(int nSubRace)
{
  switch (nSubRace)
  {
    case GS_SU_DWARF_GOLD:
    case GS_SU_DWARF_SHIELD:
    case GS_SU_ELF_MOON:
    case GS_SU_ELF_SUN:
    case GS_SU_ELF_WILD:
    case GS_SU_ELF_WOOD:
    case GS_SU_GNOME_ROCK:
    case GS_SU_GNOME_FOREST:
    case GS_SU_HALFLING_GHOSTWISE:
    case GS_SU_HALFLING_LIGHTFOOT:
    case GS_SU_HALFLING_STRONGHEART:
    case GS_SU_PLANETOUCHED_AASIMAR:
    case GS_SU_PLANETOUCHED_GENASI_AIR:
    case GS_SU_PLANETOUCHED_GENASI_EARTH:
    case GS_SU_PLANETOUCHED_GENASI_FIRE:
    case GS_SU_PLANETOUCHED_GENASI_WATER:
    case GS_SU_PLANETOUCHED_TIEFLING:
    case GS_SU_SPECIAL_FEY:
    case GS_SU_SPECIAL_CAMBION:
      return FALSE;
    case GS_SU_DWARF_GRAY:
    case GS_SU_ELF_DROW:
    case GS_SU_GNOME_DEEP:
    case GS_SU_SPECIAL_BAATEZU:
    case GS_SU_SPECIAL_GOBLIN:
    case GS_SU_SPECIAL_KOBOLD:
    case GS_SU_HALFORC_OROG:
    case GS_SU_FR_OROG:
    case GS_SU_HALFORC_GNOLL:
    case GS_SU_SPECIAL_RAKSHASA:
    case GS_SU_SPECIAL_DRAGON:
    case GS_SU_SPECIAL_VAMPIRE:
    case GS_SU_SPECIAL_OGRE:
    case GS_SU_SPECIAL_IMP:
    case GS_SU_SPECIAL_HOBGOBLIN:
    case GS_SU_DEEP_IMASKARI:
      return TRUE;
  }

  return FALSE;
}
//----------------------------------------------------------------
int gsSUGetIsHostileUnderdarker(int nSubRace)
{
  switch (nSubRace)
  {
    case GS_SU_DWARF_GOLD:
    case GS_SU_DWARF_SHIELD:
    case GS_SU_DWARF_GRAY:
    case GS_SU_ELF_MOON:
    case GS_SU_ELF_SUN:
    case GS_SU_ELF_WILD:
    case GS_SU_ELF_WOOD:
    case GS_SU_GNOME_ROCK:
    case GS_SU_GNOME_FOREST:
    case GS_SU_HALFLING_GHOSTWISE:
    case GS_SU_HALFLING_LIGHTFOOT:
    case GS_SU_HALFLING_STRONGHEART:
    case GS_SU_PLANETOUCHED_AASIMAR:
    case GS_SU_PLANETOUCHED_GENASI_AIR:
    case GS_SU_PLANETOUCHED_GENASI_EARTH:
    case GS_SU_PLANETOUCHED_GENASI_FIRE:
    case GS_SU_PLANETOUCHED_GENASI_WATER:
    case GS_SU_PLANETOUCHED_TIEFLING:
    case GS_SU_SPECIAL_FEY:
    case GS_SU_GNOME_DEEP:
    case GS_SU_HALFORC_GNOLL:
    case GS_SU_SPECIAL_RAKSHASA:
    case GS_SU_SPECIAL_DRAGON:
    case GS_SU_SPECIAL_VAMPIRE:
      return FALSE;
    case GS_SU_ELF_DROW:
    case GS_SU_SPECIAL_BAATEZU:
    case GS_SU_SPECIAL_GOBLIN:
    case GS_SU_SPECIAL_KOBOLD:
    case GS_SU_HALFORC_OROG:
    case GS_SU_FR_OROG:
    case GS_SU_SPECIAL_OGRE:
    case GS_SU_SPECIAL_HOBGOBLIN:
    case GS_SU_SPECIAL_IMP:
      return TRUE;
  }

  return FALSE;
}
//----------------------------------------------------------------
int gsSUGetIsNeutralRace(int nSubRace)
{
  switch (nSubRace)
  {
    case GS_SU_DWARF_GOLD:
    case GS_SU_DWARF_SHIELD:
    case GS_SU_ELF_MOON:
    case GS_SU_ELF_SUN:
    case GS_SU_ELF_WILD:
    case GS_SU_ELF_WOOD:
    case GS_SU_GNOME_ROCK:
    case GS_SU_GNOME_FOREST:
    case GS_SU_HALFLING_GHOSTWISE:
    case GS_SU_HALFLING_LIGHTFOOT:
    case GS_SU_HALFLING_STRONGHEART:
    case GS_SU_PLANETOUCHED_AASIMAR:
    case GS_SU_PLANETOUCHED_GENASI_AIR:
    case GS_SU_PLANETOUCHED_GENASI_EARTH:
    case GS_SU_PLANETOUCHED_GENASI_FIRE:
    case GS_SU_PLANETOUCHED_GENASI_WATER:
    case GS_SU_PLANETOUCHED_TIEFLING:
    case GS_SU_SPECIAL_FEY:
    case GS_SU_ELF_DROW:
    case GS_SU_SPECIAL_BAATEZU:
    case GS_SU_SPECIAL_GOBLIN:
    case GS_SU_SPECIAL_KOBOLD:
    case GS_SU_HALFORC_OROG:
    case GS_SU_FR_OROG:
    case GS_SU_SPECIAL_OGRE:
    case GS_SU_SPECIAL_HOBGOBLIN:
    case GS_SU_SPECIAL_IMP:
    case GS_SU_DWARF_WILD:
    case GS_SU_SPECIAL_CAMBION:
      return FALSE;
    case GS_SU_GNOME_DEEP:
    case GS_SU_DWARF_GRAY:
    case GS_SU_HALFORC_GNOLL:
    case GS_SU_SPECIAL_RAKSHASA:
    case GS_SU_SPECIAL_DRAGON:
    case GS_SU_SPECIAL_VAMPIRE:
    case GS_SU_DEEP_IMASKARI:
      return TRUE;
  }

  return FALSE;
}
//----------------------------------------------------------------
int gsSUGetIsMortal(int nSubrace)
{
  switch (nSubrace)
  {
    case GS_SU_DWARF_GOLD:
    case GS_SU_DWARF_SHIELD:
    case GS_SU_ELF_MOON:
    case GS_SU_ELF_SUN:
    case GS_SU_ELF_WILD:
    case GS_SU_ELF_WOOD:
    case GS_SU_GNOME_ROCK:
    case GS_SU_GNOME_FOREST:
    case GS_SU_HALFLING_GHOSTWISE:
    case GS_SU_HALFLING_LIGHTFOOT:
    case GS_SU_HALFLING_STRONGHEART:
    case GS_SU_PLANETOUCHED_AASIMAR:
    case GS_SU_PLANETOUCHED_GENASI_AIR:
    case GS_SU_PLANETOUCHED_GENASI_EARTH:
    case GS_SU_PLANETOUCHED_GENASI_FIRE:
    case GS_SU_PLANETOUCHED_GENASI_WATER:
    case GS_SU_PLANETOUCHED_TIEFLING:
    case GS_SU_ELF_DROW:
    case GS_SU_SPECIAL_GOBLIN:
    case GS_SU_SPECIAL_KOBOLD:
    case GS_SU_HALFORC_OROG:
    case GS_SU_FR_OROG:
    case GS_SU_SPECIAL_OGRE:
    case GS_SU_SPECIAL_HOBGOBLIN:
    case GS_SU_DWARF_WILD:
    case GS_SU_GNOME_DEEP:
    case GS_SU_DWARF_GRAY:
    case GS_SU_HALFORC_GNOLL:
    case GS_SU_SPECIAL_RAKSHASA:
    case GS_SU_SPECIAL_DRAGON:
    case GS_SU_DEEP_IMASKARI:
    case GS_SU_SPECIAL_CAMBION:
      return TRUE;
    case GS_SU_SPECIAL_FEY:
    case GS_SU_SPECIAL_BAATEZU:
    case GS_SU_SPECIAL_IMP:
    case GS_SU_SPECIAL_VAMPIRE:
      return FALSE;
  }

  return TRUE;
}
//----------------------------------------------------------------
string gsSUGetRaceName(int nRacialType)
{
  switch (nRacialType)
  {
    case RACIAL_TYPE_DWARF:
      return "Dwarf";
    case RACIAL_TYPE_ELF:
      return "Elf";
    case RACIAL_TYPE_GNOME:
      return "Gnome";
    case RACIAL_TYPE_HALFELF:
      return "Half-Elf";
    case RACIAL_TYPE_HALFLING:
      return "Halfling";
    case RACIAL_TYPE_HALFORC:
      return "Half-Orc";
    case RACIAL_TYPE_HUMAN:
      return "Human";
  }

  return "";
}
//----------------------------------------------------------------
int md_ConvertRaceToBit(int nRace)
{
    switch(nRace)
    {
    case RACIAL_TYPE_DWARF: return MD_BIT_DWARF;
    case RACIAL_TYPE_ELF: return MD_BIT_ELF;
    case RACIAL_TYPE_HALFELF: return MD_BIT_HELF;
    case RACIAL_TYPE_HALFLING: return MD_BIT_HLING;
    case RACIAL_TYPE_HUMAN: return MD_BIT_HUMAN;
    case RACIAL_TYPE_HALFORC: return MD_BIT_HORC;
    case RACIAL_TYPE_GNOME: return MD_BIT_GNOME;
    }

    return 0; //whoops
}
//----------------------------------------------------------------
int md_ConvertSubraceToBit(int nSubrace)
{
    if(nSubrace == GS_SU_NONE) return 0;
    switch(nSubrace)
    {
    case GS_SU_DWARF_GRAY: return MD_BIT_DUERGAR;
    case GS_SU_ELF_DROW: return MD_BIT_DROW;
    case GS_SU_GNOME_DEEP: return MD_BIT_DEEP_GNOME;
    case GS_SU_HALFORC_GNOLL: return MD_BIT_GNOLL;
    case GS_SU_HALFORC_OROG:
    case GS_SU_FR_OROG: return MD_BIT_OROG;
    case GS_SU_SPECIAL_FEY: return MD_BIT_FEY;
    case GS_SU_SPECIAL_GOBLIN: return MD_BIT_GOBLIN;
    case GS_SU_SPECIAL_KOBOLD: return MD_BIT_KOBOLD;
    case GS_SU_GNOME_FOREST: return MD_BIT_FOREST_GNOME;
    case GS_SU_ELF_SUN: return MD_BIT_SUN_ELF;
    case GS_SU_ELF_WOOD: return MD_BIT_WOOD_ELF;
    case GS_SU_ELF_WILD: return MD_BIT_WILD_ELF;
    case GS_SU_DWARF_GOLD: return MD_BIT_DWARF_GOLD;
    case GS_SU_PLANETOUCHED_AASIMAR: return MD_BIT_AASIMAR;
    case GS_SU_PLANETOUCHED_TIEFLING: return MD_BIT_TIEFLING;
    case GS_SU_HALFLING_STRONGHEART: return MD_BIT_HL_STR;
    case GS_SU_HALFLING_GHOSTWISE: return MD_BIT_HL_GHOST;
    case GS_SU_SPECIAL_HOBGOBLIN:  return MD_BIT_HOBGOBLIN;
    case GS_SU_SPECIAL_IMP:        return MD_BIT_IMP;
    case GS_SU_SPECIAL_OGRE:       return MD_BIT_OGRE;
    case GS_SU_DWARF_WILD:         return MD_BIT_DWARF_WILD;
    case GS_SU_DEEP_IMASKARI:      return MD_BIT_DEEP_IMASKARI;
    }

    return 0;
}
//----------------------------------------------------------------
int md_IsSubRace(int nSubracebit, object oPC)
{
    if(nSubracebit)
    {
        int nPCSubraceBit = md_ConvertSubraceToBit(gsSUGetSubRaceByName(GetSubRace(oPC)));
        int nPCRace = GetRacialType(oPC);      //only use base race if there's no subrace retrieved
        if(!(nPCSubraceBit & nSubracebit || (!nPCSubraceBit && md_ConvertRaceToBit(nPCRace) & nSubracebit)))
            return FALSE;

       return TRUE;
    }

    return FALSE;
}
