/* SUBRACE Library */
/*
    How to add a subrace:
	Script: inc_subrace
      constant groups:
      - GS_SU_??? add one for your subrace
      - NAME_GS_SU_?? name of subrace
      - DESC_GS_SU_?? desc of subrace
      - HIGHEST_SR & HIGHEST_SSR - Highest subrace
      - Optional: MD_BIT_??? currently only used for warehouse/crafting. Only add for non-5%s that are different enough from base race

      Functions:
        All of them may need to be looked at.
        Those starting with md* are optional and only to be used if using bitwise.
        gsSUApplyProperty: use to add properties, separate into files once for character life time and every log in sections.

    Follow other subraces as an example.

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

    Script: inc_language
      _gsLAGetCanSpeakLanguage To modify what language it can speak
      Remember to remove base race language if necessary

    Script: inc_worship
      gsWOGetIsRacialTypeAllowed
      To change deity selection, remember to remove base race deities if necessary.



*/
#include "inc_effect"
#include "inc_generic"
#include "inc_iprop"
#include "inc_log"
#include "inc_sumstream"
#include "inc_text"
#include "inc_totem"
#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"

// Constants 
const string SUBRACE    = "SUBRACE"; // for logging

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

//Please update to highest subrace and special subrace
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

//::  Bloodlines
const string BLOODLINE = "BLOODLINE";
const int BLOODLINE_NONE                    = 0;
const int BLOODLINE_AASIMAR_DUTY            = 1;
const int BLOODLINE_AASIMAR_GRACE           = 2;
const int BLOODLINE_AASIMAR_PERCEPTION      = 3;
const int BLOODLINE_AASIMAR_SPLENDOUR       = 4;
const int BLOODLINE_AASIMAR_ACUMEN          = 5;
const int BLOODLINE_TIEFLING_BRUTALITY      = 6;
const int BLOODLINE_TIEFLING_LETHALITY      = 7;
const int BLOODLINE_TIEFLING_INSIDIOUS      = 8;
const int BLOODLINE_TIEFLING_ALLURE         = 9;
const int BLOODLINE_TIEFLING_VISION         = 10;

//apply properties for nSubrace of nLevel to oItem
void gsSUApplyProperty(object oItem, int nSubRace, int nLevel, int bUpdateNaturalAC = FALSE);
//apply abilities for nSubrace of nLevel to oItem
void gsSUApplyAbility(object oItem, int nSubRace, int nLevel);
//::  Applies properties for nBloodline to oItem
void arSUApplyBloodline(object oItem, int nBloodline);
//:: Removes base race feats on oPC for certain subraces.
void arSURemoveBaseRacialFeats(object oPC, int nSubRace, int nLevel);
//::  Return name of nBloodline
string arSUGetNameByBloodline(int nBloodline);
//Adds racial bonuses
void md_AddRacialBonuses(object oPC, int nSubrace, object oItem=OBJECT_INVALID, int nHardBonuses=TRUE, int nSoftBonuses=TRUE);
// Adds racial SR based on nLevel
void _arSUApplyRacialSR(int nLevel, object oItem);
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

void gsSUApplyProperty(object oItem, int nSubRace, int nLevel, int bUpdateNaturalAC = FALSE)
{
    object oPossessor = GetItemPossessor(oItem);
    int nRacialType   = GetIsObjectValid(oPossessor) ?
                        GetRacialType(oPossessor) : -1;

    if(nSubRace == GS_SU_HALFORC_OROG && GetLocalInt(gsPCGetCreatureHide(oPossessor), "IsFROrog"))
    {
        // Check to see if this is a new-style orog, and if so, change the subrace being checked.
        // Necessary since both share the same name.
        nSubRace = GS_SU_FR_OROG;
    }

    // First level - add permanent character changes.
    int nAppliedAbilities = GetLocalInt(oItem, "APPLIED_ABILITIES");

    if (GetHitDice(oPossessor) == 1 && !nAppliedAbilities)
    {
      SetLocalInt(oItem, "APPLIED_ABILITIES", TRUE);

      Trace(SUBRACE, GetName(oPossessor) + " has not yet had stat changes applied.");

      switch (nSubRace)
      {
        case GS_SU_DWARF_GOLD:
          ModifyAbilityScore(oPossessor, ABILITY_CHARISMA, 2);
          ModifyAbilityScore(oPossessor, ABILITY_DEXTERITY, -2);
          break;

        case GS_SU_DWARF_GRAY:
          ModifyAbilityScore(oPossessor, ABILITY_STRENGTH, 2);
          ModifyAbilityScore(oPossessor, ABILITY_CHARISMA, -2);
          break;

        case GS_SU_ELF_DROW:
          IncreasePCSkillPoints(oPossessor, GetHitDice(oPossessor) + 3);
          ModifyAbilityScore(oPossessor, ABILITY_INTELLIGENCE, 2);
          ModifyAbilityScore(oPossessor, ABILITY_CHARISMA, 2);
          break;

        case GS_SU_ELF_SUN:
          IncreasePCSkillPoints(oPossessor, GetHitDice(oPossessor) + 3);
          ModifyAbilityScore(oPossessor, ABILITY_DEXTERITY, -2);
          ModifyAbilityScore(oPossessor, ABILITY_INTELLIGENCE, 2);
          break;

        case GS_SU_ELF_WILD:
          ModifyAbilityScore(oPossessor, ABILITY_CONSTITUTION, 2);
          ModifyAbilityScore(oPossessor, ABILITY_INTELLIGENCE, -2);
          break;

        //::  +2 STR, -2 CON, -2 DEX (Removing Elf base +2 DEX), Weapon Focus: Longbow
        case GS_SU_ELF_WOOD:
          ModifyAbilityScore(oPossessor, ABILITY_STRENGTH, 2);
          ModifyAbilityScore(oPossessor, ABILITY_DEXTERITY, -2);
          AddKnownFeat(oPossessor, FEAT_WEAPON_FOCUS_LONGBOW);
          break;

        case GS_SU_GNOME_DEEP:
          ModifyAbilityScore(oPossessor, ABILITY_CONSTITUTION, -2);
          ModifyAbilityScore(oPossessor, ABILITY_DEXTERITY, 2);
          ModifyAbilityScore(oPossessor, ABILITY_WISDOM, 2);
          ModifyAbilityScore(oPossessor, ABILITY_CHARISMA, -4);
          break;

        case GS_SU_PLANETOUCHED_AASIMAR:
          //ModifyAbilityScore(oPossessor, ABILITY_WISDOM, 2);
          //ModifyAbilityScore(oPossessor, ABILITY_CHARISMA, 2);
          break;

        case GS_SU_PLANETOUCHED_GENASI_AIR:
          IncreasePCSkillPoints(oPossessor, GetHitDice(oPossessor) + 3);
          ModifyAbilityScore(oPossessor, ABILITY_DEXTERITY, 2);
          ModifyAbilityScore(oPossessor, ABILITY_INTELLIGENCE, 2);
          ModifyAbilityScore(oPossessor, ABILITY_WISDOM, -2);
          ModifyAbilityScore(oPossessor, ABILITY_CHARISMA, -2);
          break;

        case GS_SU_PLANETOUCHED_GENASI_EARTH:
          ModifyAbilityScore(oPossessor, ABILITY_STRENGTH, 2);
          ModifyAbilityScore(oPossessor, ABILITY_CONSTITUTION, 2);
          ModifyAbilityScore(oPossessor, ABILITY_WISDOM, -2);
          ModifyAbilityScore(oPossessor, ABILITY_CHARISMA, -2);
          break;

        case GS_SU_PLANETOUCHED_GENASI_FIRE:
          IncreasePCSkillPoints(oPossessor, GetHitDice(oPossessor) + 3);
          ModifyAbilityScore(oPossessor, ABILITY_INTELLIGENCE, 2);
          ModifyAbilityScore(oPossessor, ABILITY_CHARISMA, -2);
          break;

        case GS_SU_PLANETOUCHED_GENASI_WATER:
          ModifyAbilityScore(oPossessor, ABILITY_CONSTITUTION, 2);
          ModifyAbilityScore(oPossessor, ABILITY_CHARISMA, -2);
          break;

        case GS_SU_PLANETOUCHED_TIEFLING:
          IncreasePCSkillPoints(oPossessor, GetHitDice(oPossessor) + 3);
          //ModifyAbilityScore(oPossessor, ABILITY_DEXTERITY, 2);
          //ModifyAbilityScore(oPossessor, ABILITY_INTELLIGENCE, 2);
          //ModifyAbilityScore(oPossessor, ABILITY_CHARISMA, -2);
          break;

        //::  Strongheart Halfling: Lucky feat is replaced with Strongsoul
        case GS_SU_HALFLING_STRONGHEART:
            AddKnownFeat(oPossessor, FEAT_STRONGSOUL);
            NWNX_Creature_RemoveFeat(oPossessor, FEAT_LUCKY);
            break;

        case GS_SU_SPECIAL_FEY: //subrace of halfling, generic
          //STR -4
          ModifyAbilityScore(oPossessor, ABILITY_STRENGTH, -2);
          //DEX +4
          ModifyAbilityScore(oPossessor, ABILITY_DEXTERITY, 2);
          //CHA +4
          ModifyAbilityScore(oPossessor, ABILITY_CHARISMA, 4);
          break;

        case GS_SU_SPECIAL_GOBLIN: //subrace of halfling
          //STR -2
          //DEX +2
          //CHA -2
          //ModifyAbilityScore(oPossessor, ABILITY_CHARISMA, -2);
          AddKnownFeat(oPossessor, FEAT_USE_POISON);
          break;

        case GS_SU_SPECIAL_KOBOLD: //subrace of halfling
          //STR -2
          //ModifyAbilityScore(oPossessor, ABILITY_STRENGTH, -2);
          //DEX +2
          break;

        case GS_SU_HALFORC_OROG:
        case GS_SU_FR_OROG:
          // Character generation cannot distinguish between old and new orog subrace. However,
          // if we're here, we know that this a new-style orog (since old ones can no longer
          // be selected). Therefore, flag the PC as such for future calls.
          SetLocalInt(gsPCGetCreatureHide(oPossessor), "IsFROrog", 1);
          nSubRace = GS_SU_FR_OROG;

          IncreasePCSkillPoints(oPossessor, GetHitDice(oPossessor) + 3);
          ModifyAbilityScore(oPossessor, ABILITY_STRENGTH, 2);
          ModifyAbilityScore(oPossessor, ABILITY_DEXTERITY, -2);
          ModifyAbilityScore(oPossessor, ABILITY_INTELLIGENCE, 2);
          ModifyAbilityScore(oPossessor, ABILITY_WISDOM, -2);
          ModifyAbilityScore(oPossessor, ABILITY_CHARISMA, 4);
          AddKnownFeat(oPossessor, FEAT_POWER_ATTACK);
          ExecuteScript("exe_add2ecl", oPossessor);
          break;

        case GS_SU_HALFORC_GNOLL:
          ModifyAbilityScore(oPossessor, ABILITY_CONSTITUTION, 2);
          AddKnownFeat(oPossessor, FEAT_POWER_ATTACK);
          AddKnownFeat(oPossessor, FEAT_TOUGHNESS);
          AddKnownFeat(oPossessor, FEAT_SKILL_AFFINITY_LISTEN);
          AddKnownFeat(oPossessor, FEAT_SKILL_AFFINITY_SPOT);
          break;

        case GS_SU_SPECIAL_RAKSHASA:
          ModifyAbilityScore(oPossessor, ABILITY_DEXTERITY, 2);
          ModifyAbilityScore(oPossessor, ABILITY_CHARISMA, 2);
          AddKnownFeat(oPossessor, FEAT_SKILL_AFFINITY_LISTEN);
          AddKnownFeat(oPossessor, FEAT_SKILL_AFFINITY_SPOT);
          break;

        case GS_SU_SPECIAL_DRAGON:
          ModifyAbilityScore(oPossessor, ABILITY_STRENGTH, 2);
          ModifyAbilityScore(oPossessor, ABILITY_CONSTITUTION, 2);
          ModifyAbilityScore(oPossessor, ABILITY_CHARISMA, 2);
          AddKnownFeat(oPossessor, FEAT_DRAGON_ARMOR);
          AddKnownFeat(oPossessor, FEAT_EPIC_ARMOR_SKIN);
          break;

        case GS_SU_SPECIAL_VAMPIRE:
          // Vampire Traits being:
          // Undead Traits
          // Heal/Mass Heal vulnerability
          // Regeneration +1 (outside sun)
          // Degeneration -1 (inside sun)
          // Batshape (skin only)
          // ECL+3
          // Class/build must be agreed upon by admins before granted this major award
          break;

        //::  Based on Half-Orc (+6 Strength, +2 Constitution, 2 Dexterity, 4 Intelligence, 4 Charisma)
        case GS_SU_SPECIAL_OGRE:
        {
            //IncreasePCSkillPoints(oPossessor, GetHitDice(oPossessor) + 2);
            ModifyAbilityScore(oPossessor, ABILITY_STRENGTH, 4);        // +2 from Halforc
            ModifyAbilityScore(oPossessor, ABILITY_CONSTITUTION, 2);
            ModifyAbilityScore(oPossessor, ABILITY_DEXTERITY, -2);
            ModifyAbilityScore(oPossessor, ABILITY_INTELLIGENCE, -2);   // -2 from Halforc
            ModifyAbilityScore(oPossessor, ABILITY_CHARISMA, -2);       // -2 from Halforc
            break;
        }

        //::  Based on Half-Elf (+2 Constitution, +2 Dexterity)
        case GS_SU_SPECIAL_HOBGOBLIN:
        {
            //IncreasePCSkillPoints(oPossessor, GetHitDice(oPossessor) + 2);
            ModifyAbilityScore(oPossessor, ABILITY_CONSTITUTION, 2);
            ModifyAbilityScore(oPossessor, ABILITY_DEXTERITY, 2);
            break;
        }
        //::  Based on Halfling (+4 Charisma, +2 Dexterity, -4 Strength)
        case GS_SU_SPECIAL_IMP:
        {
            //IncreasePCSkillPoints(oPossessor, GetHitDice(oPossessor) + 3);
            ModifyAbilityScore(oPossessor, ABILITY_STRENGTH, -2);       // -2 from Halfling
            ModifyAbilityScore(oPossessor, ABILITY_CHARISMA, 4);
            break;
        }

        case GS_SU_DEEP_IMASKARI://half-elf
        {
            ModifyAbilityScore(oPossessor, ABILITY_DEXTERITY, -2);
            ModifyAbilityScore(oPossessor, ABILITY_INTELLIGENCE, 2);
            IncreasePCSkillPoints(oPossessor, GetHitDice(oPossessor) + 3);
            break;
        }

        case GS_SU_DWARF_WILD:
        {
            AddKnownFeat(oPossessor, FEAT_USE_POISON);
            AddKnownFeat(oPossessor, 375); //small stature
            NWNX_Creature_RemoveFeat(oPossessor, FEAT_STONECUNNING);
            NWNX_Creature_RemoveFeat(oPossessor, FEAT_SKILL_AFFINITY_LORE);
            break;
        }

        case GS_SU_SPECIAL_CAMBION:
        {
            // Cambion:
            // +2 STR
            // +4 CHA
            // Infernal Language
            // Darkvision
            // Polymorph into Pit Fiend
            // ECL+3
            // Class/build must be agreed upon by admins before granted this major award
            ModifyAbilityScore(oPossessor, ABILITY_STRENGTH, 2);
            ModifyAbilityScore(oPossessor, ABILITY_CHARISMA, 4);
            break;
        }
      }
    }


    //::  Remove Base Racial Feats for certain subraces
    arSURemoveBaseRacialFeats(oPossessor, nSubRace, nLevel);

    gsIPRemoveAllProperties(oItem);

    switch (nSubRace)
    {
    case GS_SU_NONE:
        break;

    case GS_SU_DWARF_GOLD:
        ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(VersusRacialTypeEffect(EffectAttackIncrease(1), RACIAL_TYPE_ABERRATION)), oPossessor, 0.0, EFFECT_TAG_CHARACTER_BONUS);
        break;

    case GS_SU_DWARF_GRAY:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_PARALYSIS),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_POISON),
                        oItem);
        if(!GetHasFeat(FEAT_DIAMOND_BODY, oPossessor)) AddKnownFeat(oPossessor, FEAT_DIAMOND_BODY, 1);
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_LISTEN, 1),
                        oItem);
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_MOVE_SILENTLY, 4),
                        oItem);
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_SPOT, 1),
                        oItem);
        break;

    case GS_SU_DWARF_SHIELD: //default
        break;

    case GS_SU_SPECIAL_DRAGON: {
        // addition Dunshine:
        // depending on dragon color, different immunities
        int iDragonType = GetLocalInt(oItem, "MI_TOTEM");

    if (iDragonType == 0) {
          // transfer MI_TOTEM variable from PC to hide on dragonselection to make it permanent (was set temporarily by gs_m_activate.nss with the gvd_dm_dragon tool)
          if (GetLocalInt(oPossessor, "MI_TOTEM") != 0) {
            SetLocalInt(oItem, "MI_TOTEM", GetLocalInt(oPossessor, "MI_TOTEM"));      
          } else {        
          // default to silver
          SetLocalInt(oItem, "MI_TOTEM", MI_TO_DRG_SILVER); // Silver dragon.
        }
        }

        // for now only check for gold dragon, we can add more types from inc_totem later
        if (iDragonType == MI_TO_DRG_GOLD) {
          AddItemProperty(DURATION_TYPE_PERMANENT,
                          ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE,
                                                       IP_CONST_DAMAGERESIST_20),
                          oItem);
          AddKnownSummonStream(oPossessor, STREAM_TYPE_DRAGON, STREAM_DRAGON_GOLD);

        } else if (iDragonType == MI_TO_DRG_SHADOW) {
          AddKnownSummonStream(oPossessor, STREAM_TYPE_DRAGON, STREAM_DRAGON_SHADOW);

        } else {
          // default (silver)
          AddItemProperty(DURATION_TYPE_PERMANENT,
                          ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD,
                                                       IP_CONST_DAMAGERESIST_20),
                          oItem);
        }


    AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyTrueSeeing(),
                        oItem);

    // No break - spill down and inherit Drow SR and Darkvision
    }
    case GS_SU_ELF_DROW:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDarkvision(),
                        oItem);

        _arSUApplyRacialSR(nLevel, oItem);
        break;

    case GS_SU_ELF_MOON: //default
        break;

    case GS_SU_ELF_SUN:
        break;

    case GS_SU_ELF_WILD:
        if(bUpdateNaturalAC) NWNX_Creature_SetBaseAC(oPossessor, GetACNaturalBase(oPossessor) + 1);
        break;

    case GS_SU_ELF_WOOD:
        break;

    case GS_SU_GNOME_DEEP:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDarkvision(),
                        oItem);

        _arSUApplyRacialSR(nLevel, oItem);
        if(bUpdateNaturalAC) NWNX_Creature_SetBaseAC(oPossessor, GetACNaturalBase(oPossessor) + 1);

        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 2),
                        oItem);
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_HIDE, 2),
                        oItem);
        break;

    case GS_SU_GNOME_ROCK: //default
        break;

    case GS_SU_GNOME_FOREST: //boons aren't mechanical
        break;

    case GS_SU_HALFLING_GHOSTWISE:
        break;

    case GS_SU_HALFLING_LIGHTFOOT: //default
        break;

    case GS_SU_HALFLING_STRONGHEART:
        //predefined bonus talent
        DelayCommand(1.0, AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyBonusFeat(IP_CONST_FEAT_ALERTNESS),
                        oItem));
        //AddStackingItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyReducedSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 1), oItem);
        break;

    case GS_SU_PLANETOUCHED_AASIMAR:

        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_LISTEN, 2),
                        oItem);
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_SPOT, 2),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDarkvision(),
                        oItem);
        ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, 15)), oPossessor, 0.0, EFFECT_TAG_CHARACTER_BONUS);
        ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 15)), oPossessor, 0.0, EFFECT_TAG_CHARACTER_BONUS);
        ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 15)), oPossessor, 0.0, EFFECT_TAG_CHARACTER_BONUS);
        break;

    case GS_SU_PLANETOUCHED_GENASI_AIR:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDarkvision(),
                        oItem);
        AddKnownSummonStream(oPossessor, STREAM_TYPE_ELEMENTAL, STREAM_ELEMENTAL_AIR);
        break;

    case GS_SU_PLANETOUCHED_GENASI_EARTH:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDarkvision(),
                        oItem);
        AddKnownSummonStream(oPossessor, STREAM_TYPE_ELEMENTAL, STREAM_ELEMENTAL_EARTH);
        break;

    case GS_SU_PLANETOUCHED_GENASI_FIRE:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDarkvision(),
                        oItem);
        AddKnownSummonStream(oPossessor, STREAM_TYPE_ELEMENTAL, STREAM_ELEMENTAL_FIRE);
        break;

    case GS_SU_PLANETOUCHED_GENASI_WATER:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDarkvision(),
                        oItem);
        AddKnownSummonStream(oPossessor, STREAM_TYPE_ELEMENTAL, STREAM_ELEMENTAL_WATER);
        break;

    case GS_SU_PLANETOUCHED_TIEFLING:
        ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 15)), oPossessor, 0.0, EFFECT_TAG_CHARACTER_BONUS);
        ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 15)), oPossessor, 0.0, EFFECT_TAG_CHARACTER_BONUS);
        ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 15)), oPossessor, 0.0, EFFECT_TAG_CHARACTER_BONUS);
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_BLUFF, 2),
                        oItem);
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_HIDE, 2),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDarkvision(),
                        oItem);
        break;

    case GS_SU_SPECIAL_FEY: //subrace of halfling, generic
        //Hide +4
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_HIDE, 4),
                        oItem);
        //Move Silently +4
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_MOVE_SILENTLY, 2),
                        oItem);
        //SR 16
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_16),
                        oItem);
        //neutralize racial traits
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyReducedSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 1),
                        oItem);
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyReducedSavingThrowVsX(IP_CONST_SAVEVS_FEAR, 1),
                        oItem);
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDecreaseSkill(SKILL_LISTEN, 2),
                        oItem);
        break;

    case GS_SU_SPECIAL_GOBLIN: //subrace of halfling
        //Move Silently +4
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_MOVE_SILENTLY, 2),
                        oItem);
        //Alertness (Listen +2, Spot +2)
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_SPOT, 2),
                        oItem);
        //Darkvision
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDarkvision(),
                        oItem);
        //neutralize racial traits
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyReducedSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 1),
                        oItem);
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyReducedSavingThrowVsX(IP_CONST_SAVEVS_FEAR, 1),
                        oItem);
        break;

    case GS_SU_SPECIAL_KOBOLD: //subrace of halfling
        //Craft Trap +2
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_CRAFT_TRAP, 2),
                        oItem);
        //Alertness (Listen +2, Spot +2)
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_SPOT, 2),
                        oItem);
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_LISTEN, 2),
                        oItem);
        //Darkvision
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDarkvision(),
                        oItem);
        //neutralize racial traits
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyReducedSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 1),
                        oItem);
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyReducedSavingThrowVsX(IP_CONST_SAVEVS_FEAR, 1),
                        oItem);
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDecreaseSkill(SKILL_MOVE_SILENTLY, 2),
                        oItem);
        break;

    case GS_SU_SPECIAL_BAATEZU: //subrace of human

        //common baatezu traits
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ACID,
                                                     IP_CONST_DAMAGERESIST_10),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD,
                                                     IP_CONST_DAMAGERESIST_10),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDarkvision(),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_FIRE,
                                                   IP_CONST_DAMAGEIMMUNITY_100_PERCENT),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_POISON),
                        oItem);

        //soul shell
        if (nLevel <= 3)
        {
            SetCreatureAppearanceType(oPossessor, APPEARANCE_TYPE_WRAITH);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1,
                                                        IP_CONST_DAMAGESOAK_5_HP),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_MINDSPELLS),
                            oItem);

            SendMessageToPC(oPossessor, gsCMReplaceString(GS_T_16777537, GS_T_16777538));
        }

        //lemure
        else if (nLevel <= 6)
        {
            SetCreatureAppearanceType(oPossessor, APPEARANCE_TYPE_GOLEM_FLESH);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1,
                                                        IP_CONST_DAMAGESOAK_5_HP),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_MINDSPELLS),
                            oItem);

            SendMessageToPC(oPossessor, gsCMReplaceString(GS_T_16777537, GS_T_16777539));
        }

        //barbazu
        else if (nLevel <= 9)
        {
            SetCreatureAppearanceType(oPossessor, APPEARANCE_TYPE_ASABI_WARRIOR);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1,
                                                        IP_CONST_DAMAGESOAK_5_HP),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_16),
                            oItem);

            SendMessageToPC(oPossessor, gsCMReplaceString(GS_T_16777537, GS_T_16777541));
        }

        //erinyes
        else if (nLevel <= 12)
        {
            SetCreatureAppearanceType(oPossessor, APPEARANCE_TYPE_SUCCUBUS);
            SetCreatureWingType(CREATURE_WING_TYPE_ANGEL, oPossessor);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1,
                                                        IP_CONST_DAMAGESOAK_5_HP),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_20),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyTrueSeeing(),
                            oItem);

            SendMessageToPC(oPossessor, gsCMReplaceString(GS_T_16777537, GS_T_16777540));
        }

        //osyluth
        else if (nLevel <= 15)
        {
            SetCreatureAppearanceType(oPossessor, APPEARANCE_TYPE_GHAST);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1,
                                                        IP_CONST_DAMAGESOAK_10_HP),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_20),
                            oItem);

            SendMessageToPC(oPossessor, gsCMReplaceString(GS_T_16777537, GS_T_16777542));
        }

        //hamatula
        else if (nLevel <= 18)
        {
            SetCreatureAppearanceType(oPossessor, APPEARANCE_TYPE_SLAAD_GREEN);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1,
                                                        IP_CONST_DAMAGESOAK_10_HP),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_22),
                            oItem);

            SendMessageToPC(oPossessor, gsCMReplaceString(GS_T_16777537, GS_T_16777543));
        }

        //gelugon
        else if (nLevel <= 21)
        {
            SetCreatureAppearanceType(oPossessor, APPEARANCE_TYPE_VROCK);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1,
                                                        IP_CONST_DAMAGESOAK_10_HP),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyRegeneration(5),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_24),
                            oItem);

            SendMessageToPC(oPossessor, gsCMReplaceString(GS_T_16777537, GS_T_16777545));
        }

        //cornugon
        else if (nLevel <= 24)
        {
            SetCreatureAppearanceType(oPossessor, APPEARANCE_TYPE_ASABI_CHIEFTAIN);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1,
                                                        IP_CONST_DAMAGESOAK_10_HP),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyRegeneration(5),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_28),
                            oItem);

            SendMessageToPC(oPossessor, gsCMReplaceString(GS_T_16777537, GS_T_16777544));
        }

        //pit fiend
        else if (nLevel <= 27)
        {
            SetCreatureAppearanceType(oPossessor, APPEARANCE_TYPE_DEVIL);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1,
                                                        IP_CONST_DAMAGESOAK_15_HP),
                            oItem);
            AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyRegeneration(5),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_32),
                            oItem);

            SendMessageToPC(oPossessor, gsCMReplaceString(GS_T_16777537, GS_T_16777546));
        }

        //hell lord
        else
        {
            SetCreatureAppearanceType(oPossessor, APPEARANCE_TYPE_MEPHISTO_NORM);

            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1,
                                                        IP_CONST_DAMAGESOAK_15_HP),
                            oItem);
            AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyRegeneration(5),
                            oItem);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_32),
                            oItem);

            SendMessageToPC(oPossessor, gsCMReplaceString(GS_T_16777537, GS_T_16777547));
        }
        break;

      case GS_SU_HALFORC_OROG:
        break;
      case GS_SU_FR_OROG:
        ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 10)), oPossessor, 0.0, EFFECT_TAG_CHARACTER_BONUS);
        ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 10)), oPossessor, 0.0, EFFECT_TAG_CHARACTER_BONUS);
        ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, 5)), oPossessor, 0.0, EFFECT_TAG_CHARACTER_BONUS);
        ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 5)), oPossessor, 0.0, EFFECT_TAG_CHARACTER_BONUS);
        ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, 5)), oPossessor, 0.0, EFFECT_TAG_CHARACTER_BONUS);

        if(bUpdateNaturalAC) NWNX_Creature_SetBaseAC(oPossessor, GetACNaturalBase(oPossessor) + 1);
        break;
      case GS_SU_HALFORC_GNOLL:
        ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, 5)), oPossessor, 0.0, EFFECT_TAG_CHARACTER_BONUS);
        ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 5)), oPossessor, 0.0, EFFECT_TAG_CHARACTER_BONUS);
        ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, 5)), oPossessor, 0.0, EFFECT_TAG_CHARACTER_BONUS);
        break;

      case GS_SU_SPECIAL_RAKSHASA:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_2,
                                                    IP_CONST_DAMAGESOAK_5_HP),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_32),
                        oItem);
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_BLUFF, 8),
                        oItem);
        break;

      case GS_SU_SPECIAL_VAMPIRE:

        // undead traits
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_CRITICAL_HITS), oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_DEATH_MAGIC), oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_DISEASE), oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN), oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_MINDSPELLS), oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_PARALYSIS), oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_POISON), oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_BACKSTAB), oItem);

        // Turn resistance
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyTurnResistance(4), oItem);

        // apply regeneration/degeneration traits, handled in gs_m_heartbeat
        // apply heal/mass heal vulnerability, this is handled in nw_s0_heal and nw_s0_masheal
        // allow batshape, this is handled in chat_polymorph

        break;

      case GS_SU_SPECIAL_OGRE:
        //::  Ogres get Darkvision (Given by Half-orc base), -4 Hide, +2 Natural AC, 5% Physical Immunity
        AddStackingItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDecreaseSkill(SKILL_HIDE, 4), oItem);
        ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, 5)), oPossessor, 0.0, EFFECT_TAG_CHARACTER_BONUS);
        ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 5)), oPossessor, 0.0, EFFECT_TAG_CHARACTER_BONUS);
        ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, 5)), oPossessor, 0.0, EFFECT_TAG_CHARACTER_BONUS);

        if(bUpdateNaturalAC) NWNX_Creature_SetBaseAC(oPossessor, GetACNaturalBase(oPossessor) + 2);
        break;

      case GS_SU_SPECIAL_HOBGOBLIN:
        //::  Hobgoblins get Darkvision, +4 Move Silently
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDarkvision(), oItem);
        AddStackingItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySkillBonus(SKILL_MOVE_SILENTLY, 4), oItem);
        break;

      case GS_SU_SPECIAL_IMP:
        //::  Imps get Darkvision, Regeneration +2, SR 10, Damage Resistance Fire 20/-, DR 5/+1
        //::  Immunity to Poison, Permanent Ultravision.
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDarkvision(), oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyRegeneration(2), oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_10), oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_20), oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1, IP_CONST_DAMAGESOAK_5_HP), oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_POISON), oItem);

        //::  Imps have weird hitboxes and makes it hard to sometimes navigate doors/transitions.
        //::  We remove their collisions with other NPCs/PCs.
        //::  Imps also get Permanent Ultravision.
        ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectCutsceneGhost()), oPossessor, 0.0, EFFECT_TAG_CHARACTER_BONUS);
        ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectUltravision()), oPossessor, 0.0, EFFECT_TAG_CHARACTER_BONUS);
        break;

      case GS_SU_DWARF_WILD:
        AddStackingItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_POISON, 1), oItem);
        AddStackingItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_DISEASE, 4), oItem);
        ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 15)), oPossessor, 0.0, EFFECT_TAG_CHARACTER_BONUS);
        if(!GetHasEffect(EFFECT_TYPE_POLYMORPH, oPossessor))
            SetCreatureSize(oPossessor, CREATURE_SIZE_SMALL);
        break;

      case GS_SU_DEEP_IMASKARI:
        AddStackingItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySkillBonus(SKILL_HIDE, 4), oItem);
        break;

      case GS_SU_SPECIAL_CAMBION:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDarkvision(),
                        oItem);
        break;

    }

    miDASetKeyedValue("gs_pc_data", gsPCGetPlayerID(oPossessor), "subrace_applied", "1");
}
//----------------------------------------------------------------
void gsSUApplyAbility(object oItem, int nSubRace, int nLevel)
{
    object oPC;
    int iDragonType;
    
    gsIPRemoveAllProperties(oItem);

    switch (nSubRace)
    {
    case GS_SU_NONE:
        break;

    case GS_SU_DWARF_GOLD:
        break;

    case GS_SU_DWARF_GRAY:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_INVISIBILITY_3,
                                              IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);
        break;

    case GS_SU_DWARF_SHIELD:
        break;

    case GS_SU_ELF_DROW:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_DARKNESS_3,
                                              IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);
        break;

    case GS_SU_ELF_MOON:
        break;

    case GS_SU_ELF_SUN:
        break;

    case GS_SU_ELF_WILD:
        break;

    case GS_SU_ELF_WOOD:
        break;

    case GS_SU_GNOME_DEEP:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_INVISIBILITY_3,
                                              IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);
        break;

    case GS_SU_GNOME_ROCK:
        break;

    case GS_SU_HALFLING_GHOSTWISE:
        break;

    case GS_SU_HALFLING_LIGHTFOOT:
        break;

    case GS_SU_HALFLING_STRONGHEART:
        break;

    case GS_SU_PLANETOUCHED_AASIMAR:
        switch (nLevel)
        {
        case 1:
        case 2:
        case 3:
        case 4:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyCastSpell(IP_CONST_CASTSPELL_LIGHT_1,
                                                  IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                            oItem);
            break;

        default:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyCastSpell(IP_CONST_CASTSPELL_LIGHT_5,
                                                  IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                            oItem);
            break;
        }
        break;

    case GS_SU_PLANETOUCHED_GENASI_AIR:
        /*AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(418,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);*/
        break;

    case GS_SU_PLANETOUCHED_GENASI_EARTH:
        /*AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(420,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);*/
        break;

    case GS_SU_PLANETOUCHED_GENASI_FIRE:
        /*AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(421,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);*/
        break;

    case GS_SU_PLANETOUCHED_GENASI_WATER:
        /*AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(419,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);*/
        break;

    case GS_SU_PLANETOUCHED_TIEFLING:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_DARKNESS_3,
                                              IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);
        break;

    case GS_SU_SPECIAL_FEY:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_CHARM_PERSON_2,
                                              IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_INVISIBILITY_3,
                                              IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);
        break;

    case GS_SU_SPECIAL_GOBLIN:
        break;

    case GS_SU_SPECIAL_KOBOLD:
        break;

    case GS_SU_SPECIAL_BAATEZU:


        //...
        break;
    case GS_SU_HALFORC_OROG:
      break;
    case GS_SU_FR_OROG:
      break;
    case GS_SU_HALFORC_GNOLL:   //::  Gnolls get War Cry at Level 7 1/Day, Level 16 2/Day, Level 24 3/Day
      if ( nLevel >= 7 && nLevel < 16 )
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyCastSpell(IP_CONST_CASTSPELL_WAR_CRY_7, IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY), oItem);
      else if ( nLevel >= 16 && nLevel < 24 )
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyCastSpell(IP_CONST_CASTSPELL_WAR_CRY_7, IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY), oItem);
      else if ( nLevel >= 24 )
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyCastSpell(IP_CONST_CASTSPELL_WAR_CRY_7, IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY), oItem);

      break;
    case GS_SU_SPECIAL_RAKSHASA:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_UNIQUE_POWER_SELF_ONLY,
                                              IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE),
                        oItem);
        break;
    case GS_SU_SPECIAL_DRAGON:
        oPC = GetItemPossessor(oItem);
        iDragonType = GetLocalInt(gsPCGetCreatureHide(oPC), "MI_TOTEM");

        if (iDragonType == MI_TO_DRG_SHADOW) {

          AddItemProperty(DURATION_TYPE_PERMANENT,
                          ItemPropertyCastSpell(IP_CONST_CASTSPELL_DARKNESS_3,
                                                IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE),
                          oItem);
        }
        break;

    case GS_SU_SPECIAL_OGRE:
        break;

    case GS_SU_SPECIAL_IMP:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_INVISIBILITY_3,
                                              IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oItem);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_POLYMORPH_SELF_7,
                                              IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY),
                        oItem);
        break;

    case GS_SU_SPECIAL_HOBGOBLIN:
        break;
    }

    AddItemProperty(DURATION_TYPE_PERMANENT,
                    ItemPropertyWeightReduction(IP_CONST_REDUCEDWEIGHT_10_PERCENT),
                    oItem);
}
//----------------------------------------------------------------
void arSUApplyBloodline(object oItem, int nBloodline) {
    object oPossessor = GetItemPossessor(oItem);

    //:: First level - add permanent character Bloodline changes.
    int nAppliedBloodline = GetLocalInt(oItem, "APPLIED_BLOODLINE");

    if ( GetHitDice(oPossessor) == 1 && nBloodline != BLOODLINE_NONE && !nAppliedBloodline )
    {
        SetLocalInt(oItem, "APPLIED_BLOODLINE", TRUE);

        string sBloodline = arSUGetNameByBloodline(nBloodline);
        Trace(SUBRACE, "Applying " + sBloodline + " for " + GetName(oPossessor));

        switch (nBloodline)
        {
            //::----------------------------------------------------------------
            //::  +2 STR, +2 CON, -2 CHA, -2 WIS
            case BLOODLINE_AASIMAR_DUTY:
              ModifyAbilityScore(oPossessor, ABILITY_STRENGTH, 2);
              ModifyAbilityScore(oPossessor, ABILITY_CONSTITUTION, 2);
              ModifyAbilityScore(oPossessor, ABILITY_CHARISMA, -2);
              ModifyAbilityScore(oPossessor, ABILITY_WISDOM, -2);
              break;

            //::  +2 DEX, +2 CON, -2 CHA
            case BLOODLINE_AASIMAR_GRACE:
              ModifyAbilityScore(oPossessor, ABILITY_DEXTERITY, 2);
              ModifyAbilityScore(oPossessor, ABILITY_CONSTITUTION, 2);
              ModifyAbilityScore(oPossessor, ABILITY_CHARISMA, -2);
              break;

            //::  +2 WIS, +2 CHA, -2 DEX
            case BLOODLINE_AASIMAR_PERCEPTION:
              ModifyAbilityScore(oPossessor, ABILITY_WISDOM, 2);
              ModifyAbilityScore(oPossessor, ABILITY_CHARISMA, 2);
              ModifyAbilityScore(oPossessor, ABILITY_DEXTERITY, -2);
              break;

            //::  +2 CHA, +2 CON, -2 DEX
            case BLOODLINE_AASIMAR_SPLENDOUR:
              ModifyAbilityScore(oPossessor, ABILITY_CHARISMA, 2);
              ModifyAbilityScore(oPossessor, ABILITY_CONSTITUTION, 2);
              ModifyAbilityScore(oPossessor, ABILITY_DEXTERITY, -2);
              break;

            //::  +2 INT, +2 CON, -2 DEX
            case BLOODLINE_AASIMAR_ACUMEN:
              ModifyAbilityScore(oPossessor, ABILITY_INTELLIGENCE, 2);
              ModifyAbilityScore(oPossessor, ABILITY_CONSTITUTION, 2);
              ModifyAbilityScore(oPossessor, ABILITY_DEXTERITY, -2);
              break;

            //::----------------------------------------------------------------
            //::  +2 STR, +2 CON, -2 CHA, -2 WIS
            case BLOODLINE_TIEFLING_BRUTALITY:
              ModifyAbilityScore(oPossessor, ABILITY_STRENGTH, 2);
              ModifyAbilityScore(oPossessor, ABILITY_CONSTITUTION, 2);
              ModifyAbilityScore(oPossessor, ABILITY_CHARISMA, -2);
              ModifyAbilityScore(oPossessor, ABILITY_WISDOM, -2);
              break;

            //::  +2 DEX, +2 CON, -2 CHA
            case BLOODLINE_TIEFLING_LETHALITY:
              ModifyAbilityScore(oPossessor, ABILITY_DEXTERITY, 2);
              ModifyAbilityScore(oPossessor, ABILITY_CONSTITUTION, 2);
              ModifyAbilityScore(oPossessor, ABILITY_CHARISMA, -2);
              break;

            //::  +2 INT, +2 CON, -2 CHA
            case BLOODLINE_TIEFLING_INSIDIOUS:
              ModifyAbilityScore(oPossessor, ABILITY_INTELLIGENCE, 2);
              ModifyAbilityScore(oPossessor, ABILITY_CONSTITUTION, 2);
              ModifyAbilityScore(oPossessor, ABILITY_CHARISMA, -2);
              break;

            //::  +2 CHA, +2 CON, -2 WIS
            case BLOODLINE_TIEFLING_ALLURE:
              ModifyAbilityScore(oPossessor, ABILITY_CHARISMA, 2);
              ModifyAbilityScore(oPossessor, ABILITY_CONSTITUTION, 2);
              ModifyAbilityScore(oPossessor, ABILITY_WISDOM, -2);
              break;

            //::  +2 WIS, +2 CON, -2 DEX
            case BLOODLINE_TIEFLING_VISION:
              ModifyAbilityScore(oPossessor, ABILITY_WISDOM, 2);
              ModifyAbilityScore(oPossessor, ABILITY_CONSTITUTION, 2);
              ModifyAbilityScore(oPossessor, ABILITY_DEXTERITY, -2);
              break;
        }

        SendMessageToPC(oPossessor, "<c  >" + sBloodline + " applied.</c>");
    }
}
//----------------------------------------------------------------
void arSURemoveBaseRacialFeats(object oPC, int nSubRace, int nLevel) {

    switch(nSubRace) {
        case GS_SU_DEEP_IMASKARI:
        case GS_SU_SPECIAL_HOBGOBLIN:   //::  Remove Half-Elf base
            if (GetHasFeat(FEAT_IMMUNITY_TO_SLEEP, oPC))                NWNX_Creature_RemoveFeat(oPC, FEAT_IMMUNITY_TO_SLEEP);
            if (GetHasFeat(FEAT_HARDINESS_VERSUS_ENCHANTMENTS, oPC))    NWNX_Creature_RemoveFeat(oPC, FEAT_HARDINESS_VERSUS_ENCHANTMENTS);
            if (GetHasFeat(FEAT_PARTIAL_SKILL_AFFINITY_LISTEN, oPC))    NWNX_Creature_RemoveFeat(oPC, FEAT_PARTIAL_SKILL_AFFINITY_LISTEN);
            if (GetHasFeat(FEAT_PARTIAL_SKILL_AFFINITY_SEARCH, oPC))    NWNX_Creature_RemoveFeat(oPC, FEAT_PARTIAL_SKILL_AFFINITY_SEARCH);
            if (GetHasFeat(FEAT_PARTIAL_SKILL_AFFINITY_SPOT, oPC))      NWNX_Creature_RemoveFeat(oPC, FEAT_PARTIAL_SKILL_AFFINITY_SPOT);
        break;

        case GS_SU_SPECIAL_IMP:         //::  Remove Halfling base
            if (GetHasFeat(FEAT_SKILL_AFFINITY_MOVE_SILENTLY, oPC))     NWNX_Creature_RemoveFeat(oPC, FEAT_SKILL_AFFINITY_MOVE_SILENTLY);
            if (GetHasFeat(FEAT_SKILL_AFFINITY_LISTEN, oPC))            NWNX_Creature_RemoveFeat(oPC, FEAT_SKILL_AFFINITY_LISTEN);
            if (GetHasFeat(FEAT_LUCKY, oPC))                            NWNX_Creature_RemoveFeat(oPC, FEAT_LUCKY);
            if (GetHasFeat(FEAT_FEARLESS, oPC))                         NWNX_Creature_RemoveFeat(oPC, FEAT_FEARLESS);
            if (GetHasFeat(FEAT_GOOD_AIM, oPC))                         NWNX_Creature_RemoveFeat(oPC, FEAT_GOOD_AIM);
        break;
    }
}

//----------------------------------------------------------------
string arSUGetNameByBloodline(int nBloodline) {
    switch (nBloodline)
    {
    case BLOODLINE_AASIMAR_ACUMEN:              return "Bloodline of Acumen";
    case BLOODLINE_AASIMAR_DUTY:                return "Bloodline of Duty";
    case BLOODLINE_AASIMAR_GRACE:               return "Bloodline of Grace";
    case BLOODLINE_AASIMAR_PERCEPTION:          return "Bloodline of Perception";
    case BLOODLINE_AASIMAR_SPLENDOUR:           return "Bloodline of Splendour";

    case BLOODLINE_TIEFLING_ALLURE:             return "Bloodline of Allure";
    case BLOODLINE_TIEFLING_BRUTALITY:          return "Bloodline of Brutality";
    case BLOODLINE_TIEFLING_INSIDIOUS:          return "Bloodline of Insidious";
    case BLOODLINE_TIEFLING_LETHALITY:          return "Bloodline of Lethality";
    case BLOODLINE_TIEFLING_VISION:             return "Bloodline of Vision";
    }

    return "None";
}
//----------------------------------------------------------------
void md_AddRacialBonuses(object oPC, int nSubrace, object oItem=OBJECT_INVALID, int nHardBonuses=TRUE, int nSoftBonuses=TRUE)
{
    if(!GetIsObjectValid(oItem)) oItem = gsPCGetCreatureHide(oPC);

    //:: Drow & kobolds get Rapid Reload.
    if (nSubrace == GS_SU_ELF_DROW || nSubrace == GS_SU_SPECIAL_KOBOLD)
    {
      SetLocalInt(oItem, "BAT_RAPIDRELOAD_BOON", 1);
      if(!GetHasFeat(FEAT_RAPID_RELOAD, oPC))
          AddKnownFeat(oPC, FEAT_RAPID_RELOAD, 1);
    }
    //::  Wild-Elf
    else if (nSubrace == GS_SU_ELF_WILD) {
        if (nHardBonuses) {
            if(!GetHasFeat(FEAT_TRACKLESS_STEP, oPC))   AddKnownFeat(oPC, FEAT_TRACKLESS_STEP, 1);
            if(!GetHasFeat(FEAT_TOUGHNESS, oPC))        AddKnownFeat(oPC, FEAT_TOUGHNESS, 1);
        }
    }
    //::  Orog
    else if (nSubrace == GS_SU_FR_OROG || nSubrace == GS_SU_HALFORC_OROG) {
        if (nHardBonuses) {
            if(!GetHasFeat(FEAT_POWER_ATTACK, oPC))     AddKnownFeat(oPC, FEAT_POWER_ATTACK, 1);
        }
    }
    //::  Gnoll
    else if (nSubrace == GS_SU_HALFORC_GNOLL) {
        if (nHardBonuses) {
            if(!GetHasFeat(FEAT_POWER_ATTACK, oPC))     AddKnownFeat(oPC, FEAT_POWER_ATTACK, 1);
            if(!GetHasFeat(FEAT_TOUGHNESS, oPC))        AddKnownFeat(oPC, FEAT_TOUGHNESS, 1);
        }
	}
    //::  Goblin
    else if (nSubrace == GS_SU_SPECIAL_GOBLIN) {
        if (nHardBonuses) {
            if(!GetHasFeat(FEAT_USE_POISON, oPC))   AddKnownFeat(oPC, FEAT_USE_POISON, 1);
        }
    }
    //::  Default Races & Plane touched!
    else if(nSubrace == GS_SU_NONE || (nSubrace >= 14 && nSubrace <= 19))
    {
        //::  Half-Orc
        if(GetRacialType(oPC) == RACIAL_TYPE_HALFORC)
        {
            SetLocalInt(oItem, "MD_HALF_ORC_BOONS", 1);
            if(nHardBonuses)
            {
                if(!GetHasFeat(FEAT_AMBIDEXTERITY, oPC))
                    AddKnownFeat(oPC, FEAT_AMBIDEXTERITY, 1);
                if(!GetHasFeat(FEAT_POWER_ATTACK, oPC))
                    AddKnownFeat(oPC, FEAT_POWER_ATTACK, 1);
            }

            if(nSoftBonuses)
            {
                AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_INTIMIDATE, 5),
                        oItem);

                ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, 5)), oPC, 0.0, EFFECT_TAG_CHARACTER_BONUS);
                ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 5)), oPC, 0.0, EFFECT_TAG_CHARACTER_BONUS);
                ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, 5)), oPC, 0.0, EFFECT_TAG_CHARACTER_BONUS);
            }
        }
        //:: Half-Elf
        else if (GetRacialType(oPC) == RACIAL_TYPE_HALFELF) {
            if (nHardBonuses) {
                if(!GetHasFeat(FEAT_DODGE, oPC))    AddKnownFeat(oPC, FEAT_DODGE, 1);
            }
        }
    }
}
//----------------------------------------------------------------
void _arSUApplyRacialSR(int nLevel, object oItem) {
    switch (nLevel)
    {
    case  1:
    case  2:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_12),
                        oItem);
        break;

    case  3:
    case  4:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_14),
                        oItem);
        break;

    case  5:
    case  6:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_16),
                        oItem);
        break;

    case  7:
    case  8:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_18),
                        oItem);
        break;

    case  9:
    case 10:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_20),
                        oItem);
        break;

    case 11:
    case 12:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_22),
                        oItem);
        break;

    case 13:
    case 14:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_24),
                        oItem);
        break;

    case 15:
    case 16:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_26),
                        oItem);
        break;

    case 17:
    case 18:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_28),
                        oItem);
        break;

    case 19:
    case 20:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_30),
                        oItem);
        break;

    default:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_32),
                        oItem);
        break;
    }
}
//----------------------------------------------------------------
int gsSUGetSubRaceByName(string sSubRace)
{
    // Remove background, if any.
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
