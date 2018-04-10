/* SUBRACE Library by Gigaschatten */
/*
Loooking to add a new subrace?

See inc_subrace


*/
#include "gs_inc_iprop"
#include "gs_inc_text"
#include "inc_generic"
#include "inc_effect"
#include "inc_sumstream"
#include "mi_log"
#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"
#include "mi_inc_totem"
#include "inc_subrace"

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

        // for now only check for gold dragon, we can add more types from mi_inc_totem later
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
