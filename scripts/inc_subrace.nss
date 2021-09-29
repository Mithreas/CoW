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

const int GS_SU_NONE                      =  0;
const int GS_SU_SHAPECHANGER              =  1;

const int GS_SU_SPECIAL_FEY               = 100;
const int GS_SU_SPECIAL_GOBLIN            = 101;
const int GS_SU_SPECIAL_KOBOLD            = 102;
const int GS_SU_SPECIAL_RAKSHASA          = 103;
const int GS_SU_SPECIAL_DRAGON            = 104;
const int GS_SU_SPECIAL_VAMPIRE           = 105;
const int GS_SU_SPECIAL_OGRE              = 106;
const int GS_SU_SPECIAL_HOBGOBLIN         = 107;

//Please update to highest subrace and special subrace
const int HIGHEST_SR = 1;
const int HIGHEST_SSR = 107;

//Race represented as bits
const int MD_BIT_DWARF                    = 0x01;
const int MD_BIT_ELF                      = 0x02;
const int MD_BIT_HORC                     = 0x04;
const int MD_BIT_HUMAN                    = 0x08;
const int MD_BIT_HELF                     = 0x10;
const int MD_BIT_HLING                    = 0x20; 
const int MD_BIT_GNOME                    = 0x40; 
//Now monster subraces
const int MD_BIT_VAMPIRE                  = 0x80;
const int MD_BIT_FEY                      = 0x100;
const int MD_BIT_GOBLIN                   = 0x200;
const int MD_BIT_KOBOLD                   = 0x400;
const int MD_BIT_RAKSHASA                 = 0x800;
const int MD_BIT_HOBGOBLIN                = 0x1000;
const int MD_BIT_OGRE                     = 0x2000;
const int MD_BIT_SHAPECHANGER             = 0x4000;
const int MD_BIT_DRAGON                   = 0x8000; 
// Other PC races
const int MD_BIT_ELFLING                  = 0x10000;
const int MD_BIT_MONSTROUS                = 0x20000;

const string NAME_GS_SU_VAMPIRE = "Vampire";
const string DESC_GS_SU_VAMPIRE = "(Favored Class: Wizard)\n\nEveryone knows Vampires.\n\nRequires Major Award (and approval by admin team). Undead Traits, Bat Shape, Regeneration +1 (in Sun -1), Vulnerability to Heal/Mass Heal. ECL +3";
const string NAME_GS_SU_OGRE    = "Ogre";
const string DESC_GS_SU_OGRE    = "\nNOTE: Selecting this subrace will change your appearance to that of an Ogre.\n(Str +6, Con +2, Int -4, Cha -4, Dex -2, Darkvision, +2 Natural AC, -4 Hide, 5% Physical Immunity, Favored Class: Barbarian, ECL +2)\n\nAdult ogres stand 9 to 10 feet tall and weigh 600 to 650 pounds. They tend to be lazy and brutal, preferring to rely on an ambush and overwhelming numbers in battle. Ogres often works as mercenaries, hoping for easy plunder.";
const string NAME_GS_SU_HOBGOB  = "Hobgoblin";
const string DESC_GS_SU_HOBGOB  = "\nNOTE: Selecting this subrace will change your appearance to that of a Hobgoblin.\n(Con +2, Dex +2, Darkvision, +4 Move Silently, Favored Class: Fighter, ECL +1)\n\nHobgoblins are a larger, stronger, smarter, and more menacing form of goblinoids. They sometimes act as commanders over their lesser goblinoids such as the Goblins.";
const string NAME_GS_SU_SHAPECHANGER = "Shapechanger";
const string DESC_GS_SU_SHAPECHANGER = "(Favored Class: Shifter)\n\nA Shapechanger is one who has several natural forms.  Most are born this way, though it's also a trait that can be learnt or gifted.";

//apply properties for nSubrace of nLevel to oItem
void gsSUApplyProperty(object oItem, int nSubRace, int nLevel, int bUpdateNaturalAC = FALSE);
//apply abilities for nSubrace of nLevel to oItem
void gsSUApplyAbility(object oItem, int nSubRace, int nLevel);
//::  Applies properties for nBloodline to oItem
void arSUApplyBloodline(object oItem, int nBloodline);
//:: Removes base race feats on oPC for certain subraces.
void arSURemoveBaseRacialFeats(object oPC, int nSubRace, int nLevel);
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

    // First level - add permanent character changes.
    int nAppliedAbilities = GetLocalInt(oItem, "APPLIED_ABILITIES");

    if (GetHitDice(oPossessor) == 1 && !nAppliedAbilities)
    {
      SetLocalInt(oItem, "APPLIED_ABILITIES", TRUE);

      Trace(SUBRACE, GetName(oPossessor) + " has not yet had stat changes applied.");

      switch (nSubRace)
      {
	    case GS_SU_SHAPECHANGER:
		  // Put this in a separate script to avoid looping includes.
		  ExecuteScript("exe_makechanger", oPossessor);
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
      }
    }


    //::  Remove Base Racial Feats for certain subraces
    arSURemoveBaseRacialFeats(oPossessor, nSubRace, nLevel);

    gsIPRemoveAllProperties(oItem);

    switch (nSubRace)
    {
    case GS_SU_NONE:
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
						
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyDarkvision(),
                        oItem);

        _arSUApplyRacialSR(nLevel, oItem);

    }

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

    case GS_SU_SPECIAL_HOBGOBLIN:
        break;
		
	case GS_SU_SHAPECHANGER:
		break;
    }

    AddItemProperty(DURATION_TYPE_PERMANENT,
                    ItemPropertyWeightReduction(IP_CONST_REDUCEDWEIGHT_10_PERCENT),
                    oItem);
}
//----------------------------------------------------------------
void arSURemoveBaseRacialFeats(object oPC, int nSubRace, int nLevel) {

    switch(nSubRace) {
        case GS_SU_SPECIAL_HOBGOBLIN:   //::  Remove Half-Elf base
            if (GetHasFeat(FEAT_IMMUNITY_TO_SLEEP, oPC))                NWNX_Creature_RemoveFeat(oPC, FEAT_IMMUNITY_TO_SLEEP);
            if (GetHasFeat(FEAT_HARDINESS_VERSUS_ENCHANTMENTS, oPC))    NWNX_Creature_RemoveFeat(oPC, FEAT_HARDINESS_VERSUS_ENCHANTMENTS);
            if (GetHasFeat(FEAT_PARTIAL_SKILL_AFFINITY_LISTEN, oPC))    NWNX_Creature_RemoveFeat(oPC, FEAT_PARTIAL_SKILL_AFFINITY_LISTEN);
            if (GetHasFeat(FEAT_PARTIAL_SKILL_AFFINITY_SEARCH, oPC))    NWNX_Creature_RemoveFeat(oPC, FEAT_PARTIAL_SKILL_AFFINITY_SEARCH);
            if (GetHasFeat(FEAT_PARTIAL_SKILL_AFFINITY_SPOT, oPC))      NWNX_Creature_RemoveFeat(oPC, FEAT_PARTIAL_SKILL_AFFINITY_SPOT);
        break;
    }
}

//----------------------------------------------------------------
void md_AddRacialBonuses(object oPC, int nSubrace, object oItem=OBJECT_INVALID, int nHardBonuses=TRUE, int nSoftBonuses=TRUE)
{
    if(!GetIsObjectValid(oItem)) oItem = gsPCGetCreatureHide(oPC);

    //:: kobolds get Rapid Reload.
    if (nSubrace == nSubrace == GS_SU_SPECIAL_KOBOLD)
    {
      SetLocalInt(oItem, "BAT_RAPIDRELOAD_BOON", 1);
      if(!GetHasFeat(FEAT_RAPID_RELOAD, oPC))
          AddKnownFeat(oPC, FEAT_RAPID_RELOAD, 1);
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

    if (sSubRace == GS_T_16777427) return GS_SU_SPECIAL_FEY;
    if (sSubRace == GS_T_16777428) return GS_SU_SPECIAL_GOBLIN;
    if (sSubRace == GS_T_16777429) return GS_SU_SPECIAL_KOBOLD;
    if (sSubRace == GS_T_16777594) return GS_SU_SPECIAL_RAKSHASA;
    if (sSubRace == GS_T_16777596) return GS_SU_SPECIAL_DRAGON;
    if (sSubRace == NAME_GS_SU_VAMPIRE) return GS_SU_SPECIAL_VAMPIRE;
    if (sSubRace == NAME_GS_SU_OGRE)    return GS_SU_SPECIAL_OGRE;
    if (sSubRace == NAME_GS_SU_HOBGOB)  return GS_SU_SPECIAL_HOBGOBLIN;
	if (sSubRace == NAME_GS_SU_SHAPECHANGER) return GS_SU_SHAPECHANGER;
    return GS_SU_NONE;
}
//----------------------------------------------------------------
string gsSUGetNameBySubRace(int nSubRace)
{
    switch (nSubRace)
    {
    case GS_SU_SPECIAL_FEY:               return GS_T_16777427;
    case GS_SU_SPECIAL_GOBLIN:            return GS_T_16777428;
    case GS_SU_SPECIAL_KOBOLD:            return GS_T_16777429;
    case GS_SU_SPECIAL_RAKSHASA:          return GS_T_16777594;
    case GS_SU_SPECIAL_DRAGON:            return GS_T_16777596;
    case GS_SU_SPECIAL_VAMPIRE:           return NAME_GS_SU_VAMPIRE;
    case GS_SU_SPECIAL_OGRE:              return NAME_GS_SU_OGRE;
    case GS_SU_SPECIAL_HOBGOBLIN:         return NAME_GS_SU_HOBGOB;
	case GS_SU_SHAPECHANGER:              return NAME_GS_SU_SHAPECHANGER;

    }

    return "";
}
//----------------------------------------------------------------
int gsSUGetECL(int nSubRace, int nLevel)
{
    switch (nSubRace)
    {
    case GS_SU_SPECIAL_FEY:               return nLevel + 2;
    case GS_SU_SPECIAL_GOBLIN:            return nLevel;
    case GS_SU_SPECIAL_KOBOLD:            return nLevel;
    case GS_SU_SPECIAL_RAKSHASA:          return nLevel + 5;
    case GS_SU_SPECIAL_DRAGON:            return nLevel + 4;
    case GS_SU_SPECIAL_VAMPIRE:           return nLevel + 3;
    case GS_SU_SPECIAL_OGRE:              return nLevel + 2;
    case GS_SU_SPECIAL_HOBGOBLIN:         return nLevel + 1;
	case GS_SU_SHAPECHANGER:              return nLevel;
    }

    return nLevel;
}
//----------------------------------------------------------------
int gsSUGetFavoredClass(int nSubRace, int nGender = GENDER_MALE)
{
    switch (nSubRace)
    {
    case GS_SU_SPECIAL_FEY:               return CLASS_TYPE_DRUID;
    case GS_SU_SPECIAL_GOBLIN:            return CLASS_TYPE_ROGUE;
    case GS_SU_SPECIAL_KOBOLD:            return CLASS_TYPE_SORCERER;
    case GS_SU_SPECIAL_RAKSHASA:          return CLASS_TYPE_SORCERER;
    case GS_SU_SPECIAL_DRAGON:            return CLASS_TYPE_SORCERER;
    case GS_SU_SPECIAL_VAMPIRE:           return CLASS_TYPE_WIZARD;
    case GS_SU_SPECIAL_OGRE:              return CLASS_TYPE_BARBARIAN;
    case GS_SU_SPECIAL_HOBGOBLIN:         return CLASS_TYPE_FIGHTER;
	case GS_SU_SHAPECHANGER:              return CLASS_TYPE_SHIFTER;
    }

    return CLASS_TYPE_INVALID;
}

//----------------------------------------------------------------
string gsSUGetDescriptionBySubRace(int nSubRace)
{
    switch (nSubRace)
    {
    case GS_SU_SPECIAL_FEY:               return GS_T_16777577;
    case GS_SU_SPECIAL_GOBLIN:            return GS_T_16777578;
    case GS_SU_SPECIAL_KOBOLD:            return GS_T_16777579;
    case GS_SU_SPECIAL_RAKSHASA:          return GS_T_16777595;
    case GS_SU_SPECIAL_DRAGON:            return GS_T_16777597;
    case GS_SU_SPECIAL_VAMPIRE:           return DESC_GS_SU_VAMPIRE;
    case GS_SU_SPECIAL_OGRE:              return DESC_GS_SU_OGRE;
    case GS_SU_SPECIAL_HOBGOBLIN:         return DESC_GS_SU_HOBGOB;
	case GS_SU_SHAPECHANGER:              return DESC_GS_SU_SHAPECHANGER;
    }

    return "";
}
//----------------------------------------------------------------
int gsSUGetIsNeutralRace(int nSubRace)
{
  switch (nSubRace)
  {
    case GS_SU_SPECIAL_FEY:
    case GS_SU_SPECIAL_GOBLIN:
    case GS_SU_SPECIAL_KOBOLD:
	case GS_SU_SPECIAL_OGRE:
    case GS_SU_SPECIAL_HOBGOBLIN:
      return FALSE;
    case GS_SU_SPECIAL_RAKSHASA:
    case GS_SU_SPECIAL_DRAGON:
    case GS_SU_SPECIAL_VAMPIRE:
 	case GS_SU_SHAPECHANGER:
      return TRUE;
  }

  return FALSE;
}
//----------------------------------------------------------------
int gsSUGetIsMortal(int nSubrace)
{
  switch (nSubrace)
  {
    case GS_SU_SPECIAL_GOBLIN:
    case GS_SU_SPECIAL_KOBOLD:
    case GS_SU_SPECIAL_OGRE:
    case GS_SU_SPECIAL_HOBGOBLIN:
    case GS_SU_SPECIAL_RAKSHASA:
    case GS_SU_SPECIAL_DRAGON:
	case GS_SU_SHAPECHANGER:
      return TRUE;
    case GS_SU_SPECIAL_FEY:
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
	case 21: // Elfling
	  return "Elfling";
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
	case RACIAL_TYPE_HUMANOID_MONSTROUS: return MD_BIT_MONSTROUS;
	case 21: return MD_BIT_ELFLING;
    }

    return 0; //whoops
}
//----------------------------------------------------------------
int md_ConvertSubraceToBit(int nSubrace)
{
    if(nSubrace == GS_SU_NONE) return 0;
    switch(nSubrace)
    {
    case GS_SU_SPECIAL_FEY: return MD_BIT_FEY;
    case GS_SU_SPECIAL_GOBLIN: return MD_BIT_GOBLIN;
    case GS_SU_SPECIAL_KOBOLD: return MD_BIT_KOBOLD;
    case GS_SU_SPECIAL_HOBGOBLIN:  return MD_BIT_HOBGOBLIN;
    case GS_SU_SPECIAL_VAMPIRE:        return MD_BIT_VAMPIRE;
    case GS_SU_SPECIAL_OGRE:       return MD_BIT_OGRE;
    case GS_SU_SPECIAL_RAKSHASA:   return MD_BIT_RAKSHASA;
    case GS_SU_SPECIAL_DRAGON:     return MD_BIT_DRAGON;
	case GS_SU_SHAPECHANGER:       return MD_BIT_SHAPECHANGER;
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
