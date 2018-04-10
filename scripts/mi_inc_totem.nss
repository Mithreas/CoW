// mi_inc_totem
//
// Library with functions for totem druids.
// Totem druids get the following changes:
// - -4 permanent penalty to all physical stats
// - different wildshape rules
//  - only ever shift into one form
//  - different stat boosts (level dependent)
//  - size of form level dependent
// - All summoned creatures and animal companions have the same form.

// form      tailmodel     appearance
// wolf         392           181
// panther      373           202
// spider       475           159
// parrot       376             7
// eagle        378           144
// bear         350            13
// raven        380           145
// bat          348            10
// rat          379           386
// snake        358           183
// invis - 853-863
#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"
#include "gs_inc_pc"
#include "inc_generic"
#include "inc_item"
#include "inc_spells"
const string MI_TOTEM   = "MI_TOTEM";
const int MI_TO_WOLF    = 1;
const int MI_TO_PANTHER = 2;
const int MI_TO_SPIDER  = 3;
const int MI_TO_PARROT  = 4;
const int MI_TO_EAGLE   = 5;
const int MI_TO_BEAR    = 6;
const int MI_TO_RAVEN   = 7;
const int MI_TO_BAT     = 8;
const int MI_TO_RAT     = 9;
const int MI_TO_SNAKE   = 10;

const int MI_TO_DRG_BLACK  = 101;
const int MI_TO_DRG_BLUE   = 102;
const int MI_TO_DRG_BRASS  = 103;
const int MI_TO_DRG_BRONZE = 104;
const int MI_TO_DRG_COPPER = 105;
const int MI_TO_DRG_GOLD   = 106;
const int MI_TO_DRG_GREEN  = 107;
const int MI_TO_DRG_MIST   = 108;
const int MI_TO_DRG_PRIS   = 109;
const int MI_TO_DRG_RED    = 110;
const int MI_TO_DRG_SHADOW = 111;
const int MI_TO_DRG_SILVER = 112;
const int MI_TO_DRG_WHITE  = 113;

const int MI_TO_WEREWOLF     = 200;
const int MI_TO_VAMPIRE_BAT  = 201;
const int MI_TO_VAMPIRE_WOLF = 202;

const int TOTEM_SIZE_1 = 854;
const int TOTEM_SIZE_2 = 855;
const int TOTEM_SIZE_3 = 856;
const int TOTEM_SIZE_4 = 857;
const int TOTEM_SIZE_5 = 858;
const int TOTEM_SIZE_6 = 859;
const int TOTEM_SIZE_7 = 860;
const int TOTEM_SIZE_8 = 861;
const int TOTEM_SIZE_9 = 862;
const int TOTEM_SIZE_10 = 863;
const int TOTEM_SIZE_11 = 864;

const string TOTEM_EAGLE_SUMMON_DESCRIPTION = "Large and powerfully built, eagles are among the deadliest avian predators.";

const int TOTEM_DRUID_SUMMON_VFX = VFX_NONE;

// Returns the totem animal appearance number, if oPC has a totem
int miTOGetTotemAnimalAppearance(object oPC);
// Returns the totem animal appearance number for nTotem (MI_TO_*).
int miTOGetAppearanceFromTotem(int nTotem);
// Returns the totem animal tail appearance number, if oPC has a totem
int miTOGetTotemAnimalTailNumber(object oPC);
// Grants a totem to oPC, lowering their physical stats by 4.
void miTOGrantTotem(object oPC, int nTotem);
// Summons an animal companion, setting totem shape if appropriate
void miTOSummonAnimalCompanion(object oPC);
// Applies special totem animal abilities to a PC's creature hide (oHide)
void miTOApplyTotemAbilities(object oHide, int bNew = FALSE);
// Get the number of bonus levels to apply to the PC's totem shifting.
int miTOGetTotemBonus(object oPC);
// Set the number of bonus levels to apply to the PC's totem shifting.
void miTOSetTotemBonus(int nBonus, object oPC);

// get the name of the totem for oPC
string gvd_GetTotemName(object oPC);
// Returns TRUE if the PC is a totem druid.
int GetIsTotemDruid(object oPC);
// Returns TRUE if the PC is a totem ranger.
int GetIsTotemRanger(object oPC);
// Sets whether the PC is a totem druid.
void SetIsTotemDruid(object oPC, int bIsTotemDruid = TRUE);
// Sets whether the PC is a totem ranger.
void SetIsTotemRanger(object oPC, int bIsTotemRanger = TRUE);
// Sets path variables for the PC to distinguish totem druids and totem rangers.
void UpdateTotemPathFlags(object oPC);
// Returns TRUE if the totem can be selected by a totem druid.
int GetIsDruidTotem(int nTotem);
// Returns the base model (i.e. invisible scaling base) for use with the given totem
// and spell Id.
int GetTotemSummonAppearanceBaseModel(int nTotem, object oCaster, int nSpellId);
// Converts totem constant into a 2DA line number.
int TotemToTotem2DAId(int nTotem);
// Returns the description to be assigned to summons of the given totem.
string GetTotemSummonDescription(int nTotem);
// Returns the soundset to be assigned to summons of the given totem.
int GetTotemSummonSoundset(int nTotem);
// Returns the portrait to be assigned to summons of the given totem.
string GetTotemSummonPortrait(int nTotem);
// Returns true if the given totem's model scales with level.
int GetTotemModelScales(int nTotem);
// Returns the given PC's totem (if any).
int GetTotem(object oPC, int bAllowOverride = TRUE);
// Returns the root name to be assigned to summons of the given totem (e.g. "bear").
string GetTotemName(int nTotem);
// Returns the tail to be assigned to summons of the given totem.
int GetTotemSummonTail(int nTotem);
// Applies totem properties to the summon, converting it to the appropriate appearance
// type, name, etc.
void ApplyTotemPropertiesToSummon(object oSummon);
// Applies totem properties to the companion, converting it to the appropriate appearance
// type, name, etc.
void ApplyTotemPropertiesToAnimalCompanion(object oCompanion);

//------------------------------------------------------------------------------
int miTOGetTotemAnimalAppearance(object oPC)
{
  int nTotem = GetLocalInt(gsPCGetCreatureHide(oPC), MI_TOTEM);
  if (nTotem) return miTOGetAppearanceFromTotem(nTotem);
  else return FALSE;
}
//------------------------------------------------------------------------------
int miTOGetAppearanceFromTotem(int nTotem)
{
    return StringToInt(Get2DAString("totems", "BaseModel", TotemToTotem2DAId(nTotem)));
}
//------------------------------------------------------------------------------
int miTOGetTotemAnimalTailNumber(object oPC)
{
  int nTotem = GetLocalInt(oPC, "MI_TOTEM_OVERRIDE");
  if (!nTotem) nTotem = GetLocalInt(gsPCGetCreatureHide(oPC), MI_TOTEM);

  return StringToInt(Get2DAString("totems", "Tail", TotemToTotem2DAId(nTotem)));
}
//------------------------------------------------------------------------------
void miTOGrantTotem(object oPC, int nTotem)
{
   if (GetLevelByClass(CLASS_TYPE_DRUID, oPC))
   {
     ModifyAbilityScore(oPC, ABILITY_STRENGTH, -4);
     ModifyAbilityScore(oPC, ABILITY_DEXTERITY, -4);
     ModifyAbilityScore(oPC, ABILITY_CONSTITUTION, -4);
   }

   object oHide = gsPCGetCreatureHide(oPC);
   SetLocalInt(oHide, MI_TOTEM, nTotem);
   miTOApplyTotemAbilities(oHide, TRUE);
}
//------------------------------------------------------------------------------
void miTOSummonAnimalCompanion(object oPC)
{
  int nTotem = GetLocalInt(gsPCGetCreatureHide(oPC), MI_TOTEM);

  SummonAnimalCompanion(oPC);

  if (nTotem)
  {
    object oCompanion = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oPC);
    SetCreatureAppearanceType(oCompanion, miTOGetAppearanceFromTotem(nTotem));
    SetPortraitResRef(oCompanion, GetTotemSummonPortrait(nTotem));
    SetDescription(oCompanion, GetTotemSummonDescription(nTotem));
    NWNX_Creature_SetSoundset(oCompanion, GetTotemSummonSoundset(nTotem));
  }
}
//------------------------------------------------------------------------------
void miTOApplyTotemAbilities(object oHide, int bNew = FALSE)
{
  object oPC = GetItemPossessor(oHide);
  object oAbility  = GetItemPossessedBy(oPC, "GS_SU_ABILITY");

  // Flags updated here to migrate existing totem druids and rangers.
  UpdateTotemPathFlags(oPC);

  if(!GetIsTotemDruid(oPC)) return;

  int nTotem = GetLocalInt(oHide, MI_TOTEM);

   switch (nTotem)
   {
     case MI_TO_WOLF:
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_SPOT, 2),
                        oHide);
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyAbilityBonus(ABILITY_STRENGTH, 2),
                        oHide);
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyAbilityBonus(ABILITY_DEXTERITY, 2),
                        oHide);
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_HIDE, 2),
                        oHide);
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_MOVE_SILENTLY, 2),
                        oHide);
       break;
     case MI_TO_PANTHER:
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyAbilityBonus(ABILITY_DEXTERITY, 4),
                        oHide);
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_HIDE, 4),
                        oHide);
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_MOVE_SILENTLY, 4),
                        oHide);
       break;
     case MI_TO_SPIDER:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_PARALYSIS),
                        oHide);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_POISON),
                        oHide);
        if (bNew)
        {
            ModifyAbilityScore(oPC, ABILITY_INTELLIGENCE, 2);
            if(GetHitDice(oPC) == 1) IncreasePCSkillPoints(oPC, 4);
        }
       break;
     case MI_TO_PARROT:
        if (bNew) ModifyAbilityScore(oPC, ABILITY_CHARISMA, 4);
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_PERFORM, 8),
                        oHide);
       break;
     case MI_TO_EAGLE:
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_SPOT, 12),
                        oHide);
        if (bNew) ModifyAbilityScore(oPC, ABILITY_CHARISMA, 2);
       break;
     case MI_TO_BEAR:
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyAbilityBonus(ABILITY_CONSTITUTION, 4),
                        oHide);
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyAbilityBonus(ABILITY_STRENGTH, 4),
                        oHide);
       break;
     case MI_TO_RAVEN:
        if (bNew)
        {
            ModifyAbilityScore(oPC, ABILITY_INTELLIGENCE, 2);
            if(GetHitDice(oPC) == 1) IncreasePCSkillPoints(oPC, 4);
        }
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_LISTEN, 8),
                        oHide);
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_LORE, 10),
                        oHide);
       break;
     case MI_TO_BAT:
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_LISTEN, 12),
                        oHide);
       break;
    case MI_TO_RAT:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_DISEASE),
                        oHide);
        if (bNew)
        {
            ModifyAbilityScore(oPC, ABILITY_INTELLIGENCE, 4);
            if(GetHitDice(oPC) == 1) IncreasePCSkillPoints(oPC, 8);
        }
      break;
    case MI_TO_SNAKE:
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_POISON),
                        oHide);
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_DISEASE),
                        oHide);
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyAbilityBonus(ABILITY_DEXTERITY, 2),
                        oHide);
        if (bNew) ModifyAbilityScore(oPC, ABILITY_CHARISMA, 2);
      break;
   }
}
//------------------------------------------------------------------------------
int miTOGetTotemBonus(object oPC)
{
  return GetLocalInt(gsPCGetCreatureHide(oPC), "MI_TOTEM_BONUS");
}
//------------------------------------------------------------------------------
void miTOSetTotemBonus(int nBonus, object oPC)
{
  SetLocalInt(gsPCGetCreatureHide(oPC), "MI_TOTEM_BONUS", nBonus);
}
//------------------------------------------------------------------------------
string gvd_GetTotemName(object oPC) {

  int nTotem = GetLocalInt(gsPCGetCreatureHide(oPC), MI_TOTEM);

  return Get2DAString("totems", "Name", TotemToTotem2DAId(nTotem));
}
//------------------------------------------------------------------------------
string GetTotemName(int nTotem) {

  return Get2DAString("totems", "Name", TotemToTotem2DAId(nTotem));
}
//------------------------------------------------------------------------------
int GetIsTotemDruid(object oPC)
{
    return GetLevelByClass(CLASS_TYPE_DRUID, oPC) && GetLocalInt(gsPCGetCreatureHide(oPC), "TOTEM_DRUID");
}
//------------------------------------------------------------------------------
int GetIsTotemRanger(object oPC)
{
    return GetLevelByClass(CLASS_TYPE_RANGER, oPC) && GetLocalInt(gsPCGetCreatureHide(oPC), "TOTEM_RANGER");
}
//------------------------------------------------------------------------------
void SetIsTotemDruid(object oPC, int bIsTotemDruid = TRUE)
{
    SetLocalInt(gsPCGetCreatureHide(oPC), "TOTEM_DRUID", 1);
}
//------------------------------------------------------------------------------
void SetIsTotemRanger(object oPC, int bIsTotemRanger = TRUE)
{
    SetLocalInt(gsPCGetCreatureHide(oPC), "TOTEM_RANGER", 1);
}
//------------------------------------------------------------------------------
void UpdateTotemPathFlags(object oPC)
{
    if(!GetLocalInt(gsPCGetCreatureHide(oPC), MI_TOTEM) || GetIsTotemDruid(oPC) || GetIsTotemRanger(oPC)) return;

    if(GetLevelByClass(CLASS_TYPE_DRUID, oPC))
    {
        SetIsTotemDruid(oPC);
    }
    else
    {
        SetIsTotemRanger(oPC);
    }
}
//------------------------------------------------------------------------------
int GetIsDruidTotem(int nTotem)
{
    return StringToInt(Get2DAString("totems", "IsDruidTotem", TotemToTotem2DAId(nTotem)));
}
//------------------------------------------------------------------------------
int GetTotemSummonAppearanceBaseModel(int nTotem, object oCaster, int nSpellId)
{
    if(!GetIsDruidTotem(nTotem))
        return miTOGetAppearanceFromTotem(nTotem);

    int nSpellLevel = GetSpellInnateLevel(nSpellId);

    switch(nSpellId)
    {
        case SPELL_EPIC_DRAGON_KNIGHT:
            return TOTEM_SIZE_11;
        case SPELL_ELEMENTAL_SWARM:
            return TOTEM_SIZE_8;
        case SPELL_SUMMON_CREATURE_I:
        case SPELL_SUMMON_CREATURE_II:
        case SPELL_SUMMON_CREATURE_III:
        case SPELL_SUMMON_CREATURE_IV:
        case SPELL_SUMMON_CREATURE_V:
        case SPELL_SUMMON_CREATURE_VI:
        case SPELL_SUMMON_CREATURE_VII:
        case SPELL_SUMMON_CREATURE_VIII:
        case SPELL_SUMMON_CREATURE_IX:
            if(GetHasFeat(FEAT_GREATER_SPELL_FOCUS_CONJURATION, oCaster) || GetHasFeat(FEAT_ANIMAL_DOMAIN_POWER, oCaster))
                nSpellLevel++;
            break;
    }

    switch(nSpellLevel)
    {
        case 1:  return TOTEM_SIZE_1;
        case 2:  return TOTEM_SIZE_2;
        case 3:  return TOTEM_SIZE_3;
        case 4:  return TOTEM_SIZE_4;
        case 5:  return TOTEM_SIZE_5;
        case 6:  return TOTEM_SIZE_6;
        case 7:  return TOTEM_SIZE_7;
        case 8:  return TOTEM_SIZE_8;
        case 9:  return TOTEM_SIZE_9;
        case 10: return TOTEM_SIZE_10;
    }

    return TOTEM_SIZE_1;
}
//------------------------------------------------------------------------------
int TotemToTotem2DAId(int nTotem)
{
    switch(nTotem)
    {
        case MI_TO_WOLF:         return 0;
        case MI_TO_PANTHER:      return 1;
        case MI_TO_SPIDER:       return 2;
        case MI_TO_PARROT:       return 3;
        case MI_TO_EAGLE:        return 4;
        case MI_TO_BEAR:         return 5;
        case MI_TO_RAVEN:        return 6;
        case MI_TO_BAT:          return 7;
        case MI_TO_RAT:          return 8;
        case MI_TO_SNAKE:        return 9;
        case MI_TO_DRG_BLACK:    return 10;
        case MI_TO_DRG_BLUE:     return 11;
        case MI_TO_DRG_BRASS:    return 12;
        case MI_TO_DRG_BRONZE:   return 13;
        case MI_TO_DRG_COPPER:   return 14;
        case MI_TO_DRG_GOLD:     return 15;
        case MI_TO_DRG_GREEN:    return 16;
        case MI_TO_DRG_MIST:     return 17;
        case MI_TO_DRG_PRIS:     return 18;
        case MI_TO_DRG_RED:      return 19;
        case MI_TO_DRG_SHADOW:   return 20;
        case MI_TO_DRG_SILVER:   return 21;
        case MI_TO_DRG_WHITE:    return 22;
        case MI_TO_WEREWOLF:     return 23;
        case MI_TO_VAMPIRE_BAT:  return 24;
        case MI_TO_VAMPIRE_WOLF: return 25;

    }
    return -1;
}
//------------------------------------------------------------------------------
string GetTotemSummonDescription(int nTotem)
{
    if(nTotem == MI_TO_EAGLE) return TOTEM_EAGLE_SUMMON_DESCRIPTION;
    return GetStringByStrRef(StringToInt(Get2DAString("totems", "Description", TotemToTotem2DAId(nTotem))));
}
//------------------------------------------------------------------------------
int GetTotemSummonSoundset(int nTotem)
{
    return StringToInt(Get2DAString("totems", "Soundset", TotemToTotem2DAId(nTotem)));
}
//------------------------------------------------------------------------------
string GetTotemSummonPortrait(int nTotem)
{
    return Get2DAString("totems", "Portrait", TotemToTotem2DAId(nTotem));
}
//------------------------------------------------------------------------------
int GetTotemModelScales(int nTotem)
{
    return StringToInt(Get2DAString("totems", "ModelScales", TotemToTotem2DAId(nTotem)));
}
//------------------------------------------------------------------------------
int GetTotem(object oPC, int bAllowOverride = TRUE)
{
    int nTotem = GetLocalInt(oPC, "MI_TOTEM_OVERRIDE");
    if (!nTotem || !bAllowOverride) nTotem = GetLocalInt(gsPCGetCreatureHide(oPC), MI_TOTEM);

    return nTotem;
}
//------------------------------------------------------------------------------
string GetTotemSummonName(int nTotem)
{
    return Get2DAString("totems", "Name", TotemToTotem2DAId(nTotem));
}
//------------------------------------------------------------------------------
int GetTotemSummonTail(int nTotem)
{
    return StringToInt(Get2DAString("totems", "Tail", TotemToTotem2DAId(nTotem)));
}
//------------------------------------------------------------------------------
void ApplyTotemPropertiesToSummon(object oSummon)
{
    object oMaster = GetMaster(oSummon);
    int nTotem = GetTotem(oMaster, FALSE);

    if(GetAssociateType(oSummon) != ASSOCIATE_TYPE_SUMMONED || !nTotem || !GetIsDruidTotem(nTotem) || GetIsCreatureLastSpellCastItemValid(oMaster)) return;

    int bDruidSummon =
        (GetCreatureLastSpellCastClass(oMaster) == CLASS_TYPE_DRUID
        || GetCreatureLastSpellCastClass(oMaster) == CLASS_TYPE_INVALID // For innate abilities
        || (GetIsEpicSpell(GetCreatureLastSpellId(oMaster))) && GetLevelByClass(CLASS_TYPE_DRUID, oMaster)) ? TRUE : FALSE;

    string sName = "Totemic ";

    if(bDruidSummon)
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectVisualEffect(TOTEM_DRUID_SUMMON_VFX)), oSummon);
    }

    sName += GetTotemSummonName(nTotem);

    SetName(oSummon, sName);
    SetCreatureAppearanceType(oSummon, GetTotemSummonAppearanceBaseModel(nTotem, oMaster, GetCreatureLastSpellId(oMaster)));
    SetCreatureTailType(GetTotemSummonTail(nTotem), oSummon);
    SetPortraitResRef(oSummon, GetTotemSummonPortrait(nTotem));
    SetDescription(oSummon, GetTotemSummonDescription(nTotem));
    NWNX_Creature_SetSoundset(oSummon, GetTotemSummonSoundset(nTotem));
}
//------------------------------------------------------------------------------
void ApplyTotemPropertiesToAnimalCompanion(object oCompanion)
{
    object oMaster = GetMaster(oCompanion);
    int nTotem = GetTotem(oMaster, FALSE);

    if(GetAssociateType(oCompanion) != ASSOCIATE_TYPE_ANIMALCOMPANION || !nTotem || !GetIsDruidTotem(nTotem)) return;

    SetCreatureAppearanceType(oCompanion, miTOGetAppearanceFromTotem(nTotem));
    SetPortraitResRef(oCompanion, GetTotemSummonPortrait(nTotem));
    SetDescription(oCompanion, GetTotemSummonDescription(nTotem));
    NWNX_Creature_SetSoundset(oCompanion, GetTotemSummonSoundset(nTotem));
}
