// file that includes several previous nwnx functions, we currently don't have and use a work-around for
// or that we replaced with an empty function for now, which can be removed here when the nwnx version is done

#include "inc_data_arr"
#include "nwnx_creature"
#include "inc_database"
#include "nwnx_weapon"

const string OBJECT_ARRAY_AREAS = "OBJECT_ARRAY_AREAS";

///////////////////////////////
// constants from nwnx_funcs //
///////////////////////////////

const int CREATURE_EVENT_HEARTBEAT              = 0;
const int CREATURE_EVENT_PERCEPTION             = 1;
const int CREATURE_EVENT_SPELLCAST              = 2;
const int CREATURE_EVENT_ATTACKED               = 3;
const int CREATURE_EVENT_DAMAGED                = 4;
const int CREATURE_EVENT_DISTURBED              = 5;
const int CREATURE_EVENT_ENDCOMBAT              = 6;
const int CREATURE_EVENT_CONVERSATION           = 7;
const int CREATURE_EVENT_SPAWN                  = 8;
const int CREATURE_EVENT_RESTED                 = 9;
const int CREATURE_EVENT_DEATH                  = 10;
const int CREATURE_EVENT_USERDEF                = 11;
const int CREATURE_EVENT_BLOCKED                = 12;

// Supported by SetEventHandler() / GetEventHandler
int CREATURE_SCRIPT_ON_HEARTBEAT              = 0;
int CREATURE_SCRIPT_ON_NOTICE                 = 1;
int CREATURE_SCRIPT_ON_SPELLCASTAT            = 2;
int CREATURE_SCRIPT_ON_MELEE_ATTACKED         = 3;
int CREATURE_SCRIPT_ON_DAMAGED                = 4;
int CREATURE_SCRIPT_ON_DISTURBED              = 5;
int CREATURE_SCRIPT_ON_END_COMBATROUND        = 6;
int CREATURE_SCRIPT_ON_DIALOGUE               = 7;
int CREATURE_SCRIPT_ON_SPAWN_IN               = 8;
int CREATURE_SCRIPT_ON_RESTED                 = 9;
int CREATURE_SCRIPT_ON_DEATH                  = 10;
int CREATURE_SCRIPT_ON_USER_DEFINED_EVENT     = 11;
int CREATURE_SCRIPT_ON_BLOCKED_BY_DOOR        = 12;
// Trigger
int SCRIPT_TRIGGER_ON_HEARTBEAT          = 0;
int SCRIPT_TRIGGER_ON_OBJECT_ENTER       = 1;
int SCRIPT_TRIGGER_ON_OBJECT_EXIT        = 2;
int SCRIPT_TRIGGER_ON_USER_DEFINED_EVENT = 3;
int SCRIPT_TRIGGER_ON_TRAPTRIGGERED      = 4;
int SCRIPT_TRIGGER_ON_DISARMED           = 5;
int SCRIPT_TRIGGER_ON_CLICKED            = 6;
// Area
int SCRIPT_AREA_ON_HEARTBEAT            = 0;
int SCRIPT_AREA_ON_USER_DEFINED_EVENT   = 1;
int SCRIPT_AREA_ON_ENTER                = 2;
int SCRIPT_AREA_ON_EXIT                 = 3;
int SCRIPT_AREA_ON_CLIENT_ENTER         = 4;
// Door
int SCRIPT_DOOR_ON_OPEN            = 0;
int SCRIPT_DOOR_ON_CLOSE           = 1;
int SCRIPT_DOOR_ON_DAMAGE          = 2;
int SCRIPT_DOOR_ON_DEATH           = 3;
int SCRIPT_DOOR_ON_DISARM          = 4;
int SCRIPT_DOOR_ON_HEARTBEAT       = 5;
int SCRIPT_DOOR_ON_LOCK            = 6;
int SCRIPT_DOOR_ON_MELEE_ATTACKED  = 7;
int SCRIPT_DOOR_ON_SPELLCASTAT     = 8;
int SCRIPT_DOOR_ON_TRAPTRIGGERED   = 9;
int SCRIPT_DOOR_ON_UNLOCK          = 10;
int SCRIPT_DOOR_ON_USERDEFINED     = 11;
int SCRIPT_DOOR_ON_CLICKED         = 12;
int SCRIPT_DOOR_ON_DIALOGUE        = 13;
int SCRIPT_DOOR_ON_FAIL_TO_OPEN    = 14;
// Encounter
int SCRIPT_ENCOUNTER_ON_OBJECT_ENTER        = 0;
int SCRIPT_ENCOUNTER_ON_OBJECT_EXIT         = 1;
int SCRIPT_ENCOUNTER_ON_HEARTBEAT           = 2;
int SCRIPT_ENCOUNTER_ON_ENCOUNTER_EXHAUSTED = 3;
int SCRIPT_ENCOUNTER_ON_USER_DEFINED_EVENT  = 4;
// Module
int SCRIPT_MODULE_ON_HEARTBEAT              = 0;
int SCRIPT_MODULE_ON_USER_DEFINED_EVENT     = 1;
int SCRIPT_MODULE_ON_MODULE_LOAD            = 2;
int SCRIPT_MODULE_ON_MODULE_START           = 3;
int SCRIPT_MODULE_ON_CLIENT_ENTER           = 4;
int SCRIPT_MODULE_ON_CLIENT_EXIT            = 5;
int SCRIPT_MODULE_ON_ACTIVATE_ITEM          = 6;
int SCRIPT_MODULE_ON_ACQUIRE_ITEM           = 7;
int SCRIPT_MODULE_ON_LOSE_ITEM              = 8;
int SCRIPT_MODULE_ON_PLAYER_DEATH           = 9;
int SCRIPT_MODULE_ON_PLAYER_DYING           = 10;
int SCRIPT_MODULE_ON_RESPAWN_BUTTON_PRESSED = 11;
int SCRIPT_MODULE_ON_PLAYER_REST            = 12;
int SCRIPT_MODULE_ON_PLAYER_LEVEL_UP        = 13;
int SCRIPT_MODULE_ON_PLAYER_CANCEL_CUTSCENE = 14;
int SCRIPT_MODULE_ON_EQUIP_ITEM             = 15;
int SCRIPT_MODULE_ON_UNEQUIP_ITEM           = 16;
// Placeable
int SCRIPT_PLACEABLE_ON_CLOSED              = 0;
int SCRIPT_PLACEABLE_ON_DAMAGED             = 1;
int SCRIPT_PLACEABLE_ON_DEATH               = 2;
int SCRIPT_PLACEABLE_ON_DISARM              = 3;
int SCRIPT_PLACEABLE_ON_HEARTBEAT           = 4;
int SCRIPT_PLACEABLE_ON_INVENTORYDISTURBED  = 5;
int SCRIPT_PLACEABLE_ON_LOCK                = 6;
int SCRIPT_PLACEABLE_ON_MELEEATTACKED       = 7;
int SCRIPT_PLACEABLE_ON_OPEN                = 8;
int SCRIPT_PLACEABLE_ON_SPELLCASTAT         = 9;
int SCRIPT_PLACEABLE_ON_TRAPTRIGGERED       = 10;
int SCRIPT_PLACEABLE_ON_UNLOCK              = 11;
int SCRIPT_PLACEABLE_ON_USED                = 12;
int SCRIPT_PLACEABLE_ON_USER_DEFINED_EVENT  = 13;
int SCRIPT_PLACEABLE_ON_DIALOGUE            = 14;
// AOE
int SCRIPT_AOE_ON_HEARTBEAT            = 0;
int SCRIPT_AOE_ON_USER_DEFINED_EVENT   = 1;
int SCRIPT_AOE_ON_OBJECT_ENTER         = 2;
int SCRIPT_AOE_ON_OBJECT_EXIT          = 3;
// Store
int SCRIPT_STORE_ON_OPEN              = 0;
int SCRIPT_STORE_ON_CLOSE             = 1;

const int MOVEMENT_RATE_PC                      = 0;
const int MOVEMENT_RATE_IMMOBILE                = 1;
const int MOVEMENT_RATE_VERY_SLOW               = 2;
const int MOVEMENT_RATE_SLOW                    = 3;
const int MOVEMENT_RATE_NORMAL                  = 4;
const int MOVEMENT_RATE_FAST                    = 5;
const int MOVEMENT_RATE_VERY_FAST               = 6;
const int MOVEMENT_RATE_DEFAULT                 = 7;
const int MOVEMENT_RATE_DM_FAST                 = 8;

const int VARIABLE_TYPE_INT                     = 1;
const int VARIABLE_TYPE_FLOAT                   = 2;
const int VARIABLE_TYPE_STRING                  = 3;
const int VARIABLE_TYPE_OBJECT                  = 4;
const int VARIABLE_TYPE_LOCATION                = 5;

const int QUICKBAR_TYPE_INVALID                 = 0;
const int QUICKBAR_TYPE_ITEM                    = 1;
const int QUICKBAR_TYPE_SPELL                   = 2;
const int QUICKBAR_TYPE_PARRY                   = 3;
const int QUICKBAR_TYPE_FEAT                    = 4;
const int QUICKBAR_TYPE_TALKTO                  = 6;
const int QUICKBAR_TYPE_ATTACK                  = 7;
const int QUICKBAR_TYPE_EMOTE                   = 8;
const int QUICKBAR_TYPE_MODE                    = 10;
const int QUICKBAR_TYPE_MACRO                   = 18;

const int QUICKBAR_METAMAGIC_NONE               = 0;
const int QUICKBAR_METAMAGIC_EMPOWER            = 1;
const int QUICKBAR_METAMAGIC_EXTEND             = 2;
const int QUICKBAR_METAMAGIC_MAXIMIZE           = 4;
const int QUICKBAR_METAMAGIC_QUICKEN            = 8;
const int QUICKBAR_METAMAGIC_SILENT             = 16;
const int QUICKBAR_METAMAGIC_STILL              = 32;


struct QuickBarSlot {
    int slot;
    int type, class;
    int id, meta;
};



/////////////////////////////
// worked around functions //
/////////////////////////////

/* Modifies oCreature's ability score nAbility by nValue. */
int ModifyAbilityScore (object oCreature, int nAbility, int nValue);

/* Adds nFeat to oCreature. Does not check if the creature already knows
 * the feat. If the feat has limited uses per day and is added to a PC,
 * the PC must relog for proper use limiting. If nLevel is specified,
 * the feat will also be added to the specified level stat list. */
int AddKnownFeat (object oCreature, int nFeat, int nLevel=-1);

/* Returns TRUE if the target inherently knows a feat (as opposed to
 * by any equipment they may possess) */
int GetKnowsFeat (int nFeatId, object oCreature);

/* Check if oCreature knows the specified spell (this will only work for innate casters) */
/* Must pass bard or sorcerer. Make work with other casters (notably, wizard, untested) */
int GetKnowsSpell (int nSpellId, object oCreature, int nSpellLevel, int nClass=CLASS_TYPE_INVALID);

/* Sets oCreature's size using a CREATURE_SIZE_* constant. */
int SetCreatureSize (object oCreature, int nSize);

/* Gets oPC's remaining skill points. */
int GetPCSkillPoints (object oPC);

/* Sets oPC's remaining skill points. */
int SetPCSkillPoints (object oPC, int nSkillPoints);

/* Sets the internal item property integer at the specified index to the
 * value specified. */
itemproperty SetItemPropertyInteger (itemproperty ipProp, int nIndex, int nValue);

/* Sets oCreature's gender using a GENDER_* constant. */
int SetGender (object oCreature, int nGender);

/* Gets oCreature's natural base AC */
int GetACNaturalBase (object oCreature);

/* Sets oCreature's natural base AC */
int SetACNaturalBase (object oCreature, int nAC);

/* Get and set the minimum Monk level required for nBaseItem to be a Monk weapon. */
int SetWeaponIsMonkWeapon (int nBaseItem, int nMonkLevelsRequired);

/* Get and set finesse size (e.g. Medium for rapiers). */
int SetWeaponFinesseSize (int nBaseItem, int nSize);

/* Get and set the various weapon feats for individual base item types. */
int SetWeaponEpicFocusFeat (int nBaseItem, int nFeat);
int SetWeaponEpicSpecializationFeat (int nBaseItem, int nFeat);
int SetWeaponFocusFeat (int nBaseItem, int nFeat);
int SetWeaponImprovedCriticalFeat (int nBaseItem, int nFeat);
int SetWeaponOfChoiceFeat (int nBaseItem, int nFeat);
int SetWeaponOverwhelmingCriticalFeat (int nBaseItem, int nFeat);
int SetWeaponSpecializationFeat (int nBaseItem, int nFeat);

////////////////////////////////
// emptied/disabled functions //
////////////////////////////////

// Index of the effect integer that defines a visual effect's value.
const int EFFECT_INTEGER_VISUAL_EFFECT_TYPE = 0;

/* Returns the internal effect integer at the index specified. The index
 * is limited to being between 0 and GetEffectNumIntegers(), and which index
 * contains what value depends entirely on the type of effect. */
int GetEffectInteger (effect eEffect, int nIndex);

// Sets whether OBJECT_SELF can be detected by their own party.
void SetStealthPartyRevealed(int state);

// Sets whether OBJECT_SELF can be detected by obj.
void SetStealthRevealed(object obj);

// Determines whether the currently executing HIPS event should process.
void SetStealthSkipHIPS(int state);

// Sets the callback script which determines whether HIPS should be applied.
// Should call SetStealthSkipHIPS().
void SetStealthHIPSCallback(string script);

/* Return a string containing the entire appearance for oItem which can later be
 * passed to RestoreItemAppearance(). */
string GetEntireItemAppearance (object oItem);

/* Restore an item's appearance with the value returned by GetEntireItemAppearance(). */
void RestoreItemAppearance (object oItem, string sApp);

/* Get whether or not a position or location is walkable. */
int GetIsWalkable (object oArea, vector vPos);

/* Check if nSkill is a class skill for nClass. If the class cannot raise
 * the skill at all (e.g. Perform for non-bards), returns -1. */
int GetIsClassSkill (int nClass, int nSkill);

string GetRawQuickBarSlot (object oPC, int nSlot);

void SetRawQuickBarSlot (object oPC, string sSlot);




/////////////////////////////
// internal functions used //
/////////////////////////////



/////////////////////
// implementations //
/////////////////////


int ModifyAbilityScore (object oCreature, int nAbility, int nValue) {
  if (GetAbilityScore(oCreature, nAbility, TRUE) + nValue < 3) {
    NWNX_Creature_SetRawAbilityScore(oCreature, nAbility, 3);    
  }
  else 
    NWNX_Creature_ModifyRawAbilityScore(oCreature, nAbility, nValue);

  return 1;
}

int AddKnownFeat (object oCreature, int nFeat, int nLevel=-1) {

  if (nLevel == 0)
      nLevel = GetHitDice(oCreature);

  if (nLevel > 0) {
    NWNX_Creature_AddFeatByLevel(oCreature, nFeat, nLevel);
  } else {
    NWNX_Creature_AddFeat(oCreature, nFeat);
  }

  return 1;

}

int GetKnowsFeat (int nFeatId, object oCreature) {

  return NWNX_Creature_GetKnowsFeat(oCreature, nFeatId);

}





int GetEffectInteger (effect eEffect, int nIndex) {
  return 0;
}

void SetStealthPartyRevealed(int state) {
}

void SetStealthRevealed(object obj) {
}

void SetStealthSkipHIPS(int state) {
}

void SetStealthHIPSCallback(string script) {
}

string GetEntireItemAppearance (object oItem) {
  return "";
}

void RestoreItemAppearance (object oItem, string sApp) {
}

int GetIsWalkable (object oArea, vector vPos) {
  return 0;
}

int GetKnowsSpell (int nSpellId, object oCreature, int nSpellLevel, int nClass=CLASS_TYPE_INVALID) {
  if(nClass != CLASS_TYPE_BARD && nClass != CLASS_TYPE_SORCERER) //might work for other classes, this is currently only used for warlocks
    return 0;
  int x;

  for(x = 0; x < NWNX_Creature_GetKnownSpellCount(oCreature, nClass, nSpellLevel); x++)
  {

    if(NWNX_Creature_GetKnownSpell(oCreature, nClass, nSpellLevel, x) == nSpellId)
        return TRUE;
  }

  return FALSE;
}

int SetCreatureSize (object oCreature, int nSize) {
  NWNX_Creature_SetSize(oCreature, nSize);
  return GetCreatureSize(oCreature);
}

itemproperty SetItemPropertyInteger (itemproperty ipProp, int nIndex, int nValue) {

    int ipType = GetItemPropertyType(ipProp);
    int nSub = GetItemPropertySubType(ipProp);
    if(ipType == ITEM_PROPERTY_AC_BONUS)
    {
        return ItemPropertyACBonus(nValue);
    }
    else if(ipType == ITEM_PROPERTY_ATTACK_BONUS)
    {
        return ItemPropertyAttackBonus(nValue);
    }
    else if(ipType == ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP)
    {
        return ItemPropertyAttackBonusVsRace(nSub, nValue);
    }
    else if(ipType == ITEM_PROPERTY_DAMAGE_BONUS)
    {
        return ItemPropertyDamageBonus(nSub, nValue);
    }
    else if(ipType == ITEM_PROPERTY_SKILL_BONUS)
    {
        return ItemPropertySkillBonus(nSub, nValue);
    }
    else if(ipType == ITEM_PROPERTY_DECREASED_SKILL_MODIFIER)
    {
        return ItemPropertyDecreaseSkill(nSub, nValue);
    }
    else if(ipType == ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC)
    {
        return ItemPropertyBonusSavingThrowVsX(nSub, nValue);
    }
    else if(ipType == ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC)
    {
        return ItemPropertyReducedSavingThrowVsX(nSub, nValue);
    }
    else if(ipType == ITEM_PROPERTY_SAVING_THROW_BONUS)
    {
        return ItemPropertyBonusSavingThrow(nSub, nValue);
    }
    else if(ipType == ITEM_PROPERTY_DECREASED_SAVING_THROWS)
    {
        return ItemPropertyReducedSavingThrow(nSub, nValue);
    }
    else if(ipType == ITEM_PROPERTY_REGENERATION)
    {
        return ItemPropertyRegeneration(nValue);
    }
    else if(ipType == ITEM_PROPERTY_ABILITY_BONUS)
    {
        return ItemPropertyAbilityBonus(nSub, nValue);
    }
    return ipProp;
}

int GetPCSkillPoints (object oPC) {
  return NWNX_Creature_GetSkillPointsRemaining(oPC);

}

int SetPCSkillPoints (object oPC, int nSkillPoints) {
  NWNX_Creature_SetSkillPointsRemaining(oPC, nSkillPoints);
  return GetPCSkillPoints(oPC);
}

int GetIsClassSkill (int nClass, int nSkill) {
  return 0;
}

int SetGender (object oCreature, int nGender) {
  NWNX_Creature_SetGender(oCreature, nGender);
  return GetGender(oCreature);
}

int GetACNaturalBase (object oCreature) {
  // Only called from places that are using NWNX_Creature_SetBaseAC - which I believe
  // sets the *bonus to base AC* not the actual base AC.  So use 0 instead of 10.
  return NWNX_Creature_GetBaseAC(oCreature);

}

int SetACNaturalBase (object oCreature, int nAC) {
  NWNX_Creature_SetBaseAC(oCreature, nAC);
  return GetACNaturalBase(oCreature);
}



string GetRawQuickBarSlot (object oPC, int nSlot) {
  return "";
}

void SetRawQuickBarSlot (object oPC, string sSlot) {
}


int SetWeaponIsMonkWeapon (int nBaseItem, int nMonkLevelsRequired) {
  return 0;
}

int SetWeaponFinesseSize (int nBaseItem, int nSize) {
  NWNX_Weapon_SetWeaponFinesseSize(nBaseItem, nSize);
  return 1;
}

int SetWeaponEpicFocusFeat (int nBaseItem, int nFeat) {
  NWNX_Weapon_SetEpicWeaponFocusFeat(nBaseItem, nFeat);
  return 1;
}

int SetWeaponEpicSpecializationFeat (int nBaseItem, int nFeat) {
  NWNX_Weapon_SetEpicWeaponSpecializationFeat(nBaseItem, nFeat);
  return 1;
}

int SetWeaponFocusFeat (int nBaseItem, int nFeat) {
  NWNX_Weapon_SetWeaponFocusFeat(nBaseItem, nFeat);
  return 1;
}

int SetWeaponImprovedCriticalFeat (int nBaseItem, int nFeat) {
  NWNX_Weapon_SetWeaponImprovedCriticalFeat(nBaseItem, nFeat);
  return 1;
}

int SetWeaponOfChoiceFeat (int nBaseItem, int nFeat) {
  NWNX_Weapon_SetWeaponOfChoiceFeat(nBaseItem, nFeat);
  return 1;
}

int SetWeaponOverwhelmingCriticalFeat (int nBaseItem, int nFeat) {
  NWNX_Weapon_SetEpicWeaponOverwhelmingCriticalFeat(nBaseItem, nFeat);
  return 1;
}

int SetWeaponSpecializationFeat (int nBaseItem, int nFeat) {
  NWNX_Weapon_SetWeaponSpecializationFeat(nBaseItem, nFeat);
  return 1;
}
