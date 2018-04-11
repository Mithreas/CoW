//::///////////////////////////////////////////////
//:: Generic Library
//:: inc_generic
//:://////////////////////////////////////////////
/*
    This is a catchall library for functions
    of general use.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 3, 2016
//:://////////////////////////////////////////////

#include "inc_behaviors"
#include "inc_item"
#include "inc_time"
#include "nwnx_alts"
#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "x0_i0_match"

/**********************************************************************
 * CONFIG PARAMETERS
 **********************************************************************/

// Module corpse blueprint.
const string RESREF_CORPSE = "gs_placeable017";
const string RESREF_CORPSE2 = "gs_placeable016";

// Maximum PC level for the server.
const int MAX_LEVEL = 30;

// The maximum number of uses a feat can have.
// Current value = Monk Level + Extra Stunning Attacks (Feat) for Stunning Fist
const int FEAT_MAXIMUM_USES = 33;

/**********************************************************************
 * CONSTANT DEFINITIONS
 **********************************************************************/

// Prefix to separate generic variables from other libraries.
const string LIB_GENERIC_PREFIX = "Lib_Generic_";

/**********************************************************************
 * PUBLIC FUNCTION PROTOTYPES
 **********************************************************************/

// Sets the creature's maximum hit points. Unlike the default nwnx function, the given
// value includes modifiers from base constitution and toughness.
void AR_NWNX_Object_SetMaxHitPoints(object oCreature, int nAmount);
// Despawns the creature with the given VFX if its time, as set via SetDespawnTimer,
// has expired.
void CheckDespawn();
// Clears the inventory of the target. Flags determine whether equipped items,
// non-equipped items, and/or gold will be removed.
void ClearInventory(object oTarget, int bIncludeNonEquipped = TRUE, int bIncludeEquipped = TRUE, int bIncludeGold = TRUE);
// Copies the appearance of one creature to another, making them appear identical. May
// behave unexpectedly if genders do not match.
void CopyCreatureAppearance(object oSource, object oTarget, int bCopyPortrait = FALSE, int bCopySoundset = FALSE,
    int bCopyDescription = FALSE, int bCopyArmor = FALSE, int bCopyWeapons = FALSE);
// Copies all variables from oSource to oTarget. If set, variables with a name beginning with
// Exclude will not be copied (e.g. if sExclude is "_", then no variables beginning
// with "_" will be copied).
void CopyVariables(object oSource, object oTarget, string sExclude = "");
// Returns the degree by which the two alignments differ on every axis (e.g. LG
// and CE would return 4).
int GetAlignmentDifferential(int nAlignment1GoodEvil, int nAlignment2GoodEvil, int nAlignment1LawChaos, int nAlignment2LawChaos);
// Returns the degree by which the two alignments differ on the good-evil axis (e.g. good
// and evil would return 2).
int GetAlignmentDifferentialGoodEvil(int nAlignment1GoodEvil, int nAlignment2GoodEvil);
// Returns the degree by which the two alignments differ on the lawful-chaotic axis (e.g. lawful
// and chaotic would return 2).
int GetAlignmentDifferentialLawChaos(int nAlignment1LawChaos, int nAlignment2LawChaos);
// Returns the base ability modifier for the given creature, unaltered by spells
// and equipment.
int GetBaseAbilityModifier(object oCreature, int nAbility);
// Returns the bonus hit dice value for the creature, which is flagged and used by
// some abilities.
int GetBonusHitDice(object oCreature);
// Returns the hit die used for the given class (e.g. 8 for clerics).
int GetClassHitDie(int nClass);
// Returns TRUE if oCreature has any weapon focus feat.
int GetHasWeaponFocusFeat(object oCreature);
// Returns bonus hit points granted to the creature from constitution and toughness.
int GetHitPointBonus(object oCreature);
// Returns TRUE if the given appearance type is dynamic.
int GetIsAppearanceDynamic(int nAppearanceType);
// Returns TRUE if the object is a corpse placeable.
int GetIsCorpse(object oObject);
// Returns TRUE if the creature suffers from a hard movement-impairing effect. Does not
// include movement speed reduction.
int GetIsImmobilized(object oCreature);
// Returns the level at which the PC learned the specified feat. Returns -1 on error.
int GetKnownFeatLevel(object oPC, int nFeat);
// Returns TRUE if the PC learned the feat at the specified level.
int GetKnowsFeatAtLevel(object oPC, int nFeat, int nLevel);
// Returns the level at which the PC had taken nLevels of nClass (e.g. for a PC
// that had taken their 9th ranger level at level 13, the parameters nClass =
// CLASS_TYPE_RANGER and nLevel = 9 would return 13.)
// Returns -1 on error.
int GetLevelByClassLevel(object oPC, int nClass, int nLevel);
// Returns the PC's level as a function of their current experience total. Note that
// this function ignores whether the PC has leveled up or not. Returns -1 on error.
int GetLevelFromXP(object oPC);
// Returns the class in which the given creature has the most levels. If two classes are tied,
// then the first will be returned.
int GetPrimaryClass(object oCreature);
// Returns the amount of experience required to reach the specified level. Returns -1
// on error.
int GetXPRequiredForLevel(int nLevel);
// Increases ranks of all skills known by the creature by the given amount.
void IncreaseKnownSkillRanks(object oCreature, int nAmount);
// Increases the maximum hit points of the creature by the given amount.
void IncreaseMaximumHitPoints(object oCreature, int nAmount);
// Increases (or decreases) the PC's skill point total by nAmount. If bRelevel is TRUE, then
// the PC will be releveled if they currently have the ability to level up; this will
// ensure that the skill points appear on the level up interface.
void IncreasePCSkillPoints(object oPC, int nAmount, int bRelevel = TRUE);
// Maximize's the creature's hit points, as if it had gained max hit points her level.
// Does not work for PCs.
void MaximizeHitPoints(object oCreature, int nPercent = 100);
// Sets ranks of all skills known by the creature to the maximum value for its level.
void MaximizeKnownSkillRanks(object oCreature);
// Removes all associates from the creature.
void RemoveAllAssociates(object oCreature);
// Removes all feats from the creature granted via the given package.
void RemovePackageFeats(object oCreature, int nPackage);
// Modifies the creature's base AC so that its current AC value matches the given value.
void SetAC(object oCreature, int nValue);
// Sets all skill ranks for the creature to the given value.
void SetAllSkillRanks(object oCreature, int nValue);
// Sets the bonus hit dice value for the creature, which is flagged and used by
// some abilities.
void SetBonusHitDice(object oCreature, int nBonus);
// Sets a despawn timer for the given creature. After the given delay, it will be destroyed
// with the given VFX. Note that this will only work for creatures that have custom
// behaviors (per inc_behaviors) enabled.
void SetDespawnTimer(object oCreature, int nDelay, int nVFX = VFX_NONE);
// Updates the droppable flag for all specified items to the specified value.
void SetInventoryDroppable(object oTarget, int bIsDroppable = TRUE, int bIncludeNonEquipped = TRUE, int bIncludeEquipped = TRUE);
// Sets the remaining uses per day for the given feat.
void SetRemainingFeatUses(object oCreature, int nFeat, int nUses);

/**********************************************************************
 * PRIVATE FUNCTION PROTOTYPES
 **********************************************************************/

/* Internal function used to equip items copied to a creature with a copied appearance. */
void _EquipCopiedItems(object oArmor, object oHelm, object oMainHand, object oOffHand);

/**********************************************************************
 * PUBLIC FUNCTION DEFINITIONS
 **********************************************************************/

//::///////////////////////////////////////////////
//:: AR_SetMaxHitPoints
//:://////////////////////////////////////////////
/*
    Sets the creature's maximum hit points.
    Unlike the default nwnx function, the given
    value includes modifiers from base constitution
    and toughness.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 10, 2016
//:://////////////////////////////////////////////
void AR_NWNX_Object_SetMaxHitPoints(object oCreature, int nAmount)
{
    NWNX_Object_SetMaxHitPoints(oCreature, nAmount - GetHitPointBonus(oCreature));
}

//::///////////////////////////////////////////////
//:: CheckDespawn
//:://////////////////////////////////////////////
/*
    Despawns the creature with the given VFX
    if its time, as set via SetDespawnTimer,
    has expired.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 16, 2017
//:://////////////////////////////////////////////
void CheckDespawn()
{
    if(GetModuleTime() >= GetLocalInt(OBJECT_SELF, LIB_GENERIC_PREFIX + "DespawnTime"))
    {
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(GetLocalInt(OBJECT_SELF, LIB_GENERIC_PREFIX + "DespawnVFX")), GetLocation(OBJECT_SELF));
        SetIsDestroyable(TRUE, FALSE, FALSE);
        DestroyObject(OBJECT_SELF);
    }
}

//::///////////////////////////////////////////////
//:: ClearInventory
//:://////////////////////////////////////////////
/*
    Clears the inventory of the target. Flags
    determine whether equipped items, non-equipped
    items, and/or gold will be removed.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 3, 2016
//:://////////////////////////////////////////////
void ClearInventory(object oTarget, int bIncludeNonEquipped = TRUE, int bIncludeEquipped = TRUE, int bIncludeGold = TRUE)
{
    int nSlot;
    object oItem;

    if(bIncludeNonEquipped)
    {
        oItem = GetFirstItemInInventory(oTarget);
        while(GetIsObjectValid(oItem))
        {
            DestroyObject(oItem);
            oItem = GetNextItemInInventory(oTarget);
        }
    }
    if(bIncludeEquipped)
    {
        for(nSlot = 0; nSlot < NUM_INVENTORY_SLOTS; ++nSlot)
        {
            DestroyObject(GetItemInSlot(nSlot, oTarget));
        }
    }
    if(bIncludeGold)
    {
        AssignCommand(oTarget, TakeGoldFromCreature(GetGold(oTarget), oTarget, TRUE));
    }
}

//::///////////////////////////////////////////////
//:: CopyCreatureAppearance
//:://////////////////////////////////////////////
/*
    Copies the appearance of one creature to
    another, making them appear identical. May
    behave unexpectedly if genders do not match.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 16, 2016
//:://////////////////////////////////////////////
void CopyCreatureAppearance(object oSource, object oTarget, int bCopyPortrait = FALSE, int bCopySoundset = FALSE,
    int bCopyDescription = FALSE, int bCopyArmor = FALSE, int bCopyWeapons = FALSE)
{
    int i;
    int nAC = GetAC(oTarget);
    int nAppearance = GetAppearanceType(oSource);
    object oArmor, oHelm, oMainHand, oOffHand;

    SetCreatureAppearanceType(oTarget, nAppearance);
    SetCreatureTailType(GetCreatureTailType(oSource), oTarget);
    SetCreatureWingType(GetCreatureWingType(oSource), oTarget);

    if(GetIsAppearanceDynamic(nAppearance))
    {
        for(i = COLOR_CHANNEL_SKIN; i <= COLOR_CHANNEL_TATTOO_2; i++)
        {
            SetColor(oTarget, i, GetColor(oSource, i));
        }
        for (i = CREATURE_PART_RIGHT_FOOT; i <= CREATURE_PART_HEAD; i++)
        {
            SetCreatureBodyPart(i, GetCreatureBodyPart(i, oSource), oTarget);
        }
    }
    if(bCopyPortrait)
    {
        SetPortraitResRef(oTarget, GetPortraitResRef(oSource));
    }
    if(bCopySoundset)
    {
        NWNX_Creature_SetSoundset(oTarget, NWNX_Creature_GetSoundset(oSource));
    }
    if(bCopyDescription)
    {
        SetDescription(oTarget, GetDescription(oSource));
    }
    if(bCopyArmor)
    {
        oArmor = CopyItem(GetItemInSlot(INVENTORY_SLOT_CHEST, oSource), oTarget);
        RemoveAllItemProperties(oArmor);
        SetDroppableFlag(oArmor, FALSE);
        if(!GetHiddenWhenEquipped(GetItemInSlot(INVENTORY_SLOT_HEAD, oSource)))
        {
            oHelm = CopyItem(GetItemInSlot(INVENTORY_SLOT_HEAD, oSource), oTarget);
            RemoveAllItemProperties(oHelm);
            SetDroppableFlag(oHelm, FALSE);
        }
    }
    if(bCopyWeapons)
    {
        if(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oSource) != GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oSource))
        {
            oOffHand = CopyItem(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oSource), oTarget);
            RemoveAllItemProperties(oOffHand);
            SetDroppableFlag(oOffHand, FALSE);
        }
        oMainHand = CopyItem(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oSource), oTarget);
        RemoveAllItemProperties(oMainHand);
        SetDroppableFlag(oMainHand, FALSE);
    }
    if(bCopyArmor || bCopyWeapons)
    {
        AssignCommand(oTarget, ClearAllActions());
        AssignCommand(oTarget, _EquipCopiedItems(oArmor, oHelm, oMainHand, oOffHand));
        DelayCommand(1.0, SetAC(oTarget, nAC));
    }
}

//::///////////////////////////////////////////////
//:: CopyVariables
//:://////////////////////////////////////////////
/*
    Copies all variables from oSource to oTarget.
    If set, variables with a name beginning with
    sExclude will not be copied (e.g. if
    sExclude is "_", then no variables beginning
    with "_" will be copied).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 17, 2017
//:://////////////////////////////////////////////
void CopyVariables(object oSource, object oTarget, string sExclude = "")
{
    int iVars = NWNX_Object_GetLocalVariableCount(oSource);
    int iVar = 0;  

    struct NWNX_Object_LocalVariable var = NWNX_Object_GetLocalVariable(oSource, iVar);

    while (iVar < iVars)
    {
        if(sExclude != "" && (GetStringLeft(var.key, GetStringLength(sExclude)) != sExclude))
        {
            switch(var.type)
            {
                case VARIABLE_TYPE_INT:
                    SetLocalInt(oTarget, var.key, GetLocalInt(oSource, var.key));
                    break;
                case VARIABLE_TYPE_FLOAT:
                    SetLocalFloat(oTarget, var.key, GetLocalFloat(oSource, var.key));
                    break;
                case VARIABLE_TYPE_STRING:
                    SetLocalString(oTarget, var.key, GetLocalString(oSource, var.key));
                    break;
                case VARIABLE_TYPE_OBJECT:
                    SetLocalObject(oTarget, var.key, GetLocalObject(oSource, var.key));
                    break;
                case VARIABLE_TYPE_LOCATION:
                    SetLocalLocation(oTarget, var.key, GetLocalLocation(oSource, var.key));
                    break;
            }
        }
		
		iVar++;
        var = NWNX_Object_GetLocalVariable(oSource, iVar);
    }
}

//::///////////////////////////////////////////////
//:: GetAlignmentDifferential
//:://////////////////////////////////////////////
/*
    Returns the degree by which the two
    alignments differ on every axis (e.g. LG
    and CE would return 4).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 15, 2016
//:://////////////////////////////////////////////
int GetAlignmentDifferential(int nAlignment1GoodEvil, int nAlignment2GoodEvil, int nAlignment1LawChaos, int nAlignment2LawChaos)
{
    return GetAlignmentDifferentialGoodEvil(nAlignment1GoodEvil, nAlignment2GoodEvil) + GetAlignmentDifferentialLawChaos(nAlignment1LawChaos, nAlignment2LawChaos);
}

//::///////////////////////////////////////////////
//:: GetAlignmentDifferentialGoodEvil
//:://////////////////////////////////////////////
/*
    Returns the degree by which the two alignments
    differ on the good-evil axis (e.g. good
    and evil would return 2).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 15, 2016
//:://////////////////////////////////////////////
int GetAlignmentDifferentialGoodEvil(int nAlignment1GoodEvil, int nAlignment2GoodEvil)
{
    switch(nAlignment1GoodEvil)
    {
        case ALIGNMENT_GOOD:
        {
            switch(nAlignment2GoodEvil)
            {
                case ALIGNMENT_NEUTRAL: return 1;
                case ALIGNMENT_EVIL:    return 2;
            }
            break;
        }
        case ALIGNMENT_NEUTRAL:
        {
            switch(nAlignment2GoodEvil)
            {
                case ALIGNMENT_GOOD:
                case ALIGNMENT_EVIL: return 1;
            }
            break;
        }
        case ALIGNMENT_EVIL:
        {
            switch(nAlignment2GoodEvil)
            {
                case ALIGNMENT_GOOD:    return 2;
                case ALIGNMENT_NEUTRAL: return 1;
            }
            break;
        }
    }
    return 0;
}

//::///////////////////////////////////////////////
//:: GetAlignmentDifferentialLawChaos
//:://////////////////////////////////////////////
/*
    Returns the degree by which the two alignments
    differ on the lawful-chaotic axis (e.g. lawful
    and chaotic would return 2).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 15, 2016
//:://////////////////////////////////////////////
int GetAlignmentDifferentialLawChaos(int nAlignment1LawChaos, int nAlignment2LawChaos)
{
    switch(nAlignment1LawChaos)
    {
        case ALIGNMENT_LAWFUL:
        {
            switch(nAlignment2LawChaos)
            {
                case ALIGNMENT_NEUTRAL: return 1;
                case ALIGNMENT_CHAOTIC: return 2;
            }
            break;
        }
        case ALIGNMENT_NEUTRAL:
        {
            switch(nAlignment2LawChaos)
            {
                case ALIGNMENT_LAWFUL:
                case ALIGNMENT_CHAOTIC: return 1;
            }
            break;
        }
        case ALIGNMENT_CHAOTIC:
        {
            switch(nAlignment2LawChaos)
            {
                case ALIGNMENT_LAWFUL:    return 2;
                case ALIGNMENT_NEUTRAL:   return 1;
            }
            break;
        }
    }
    return 0;
}

//::///////////////////////////////////////////////
//:: GetBaseAbilityModifier
//:://////////////////////////////////////////////
/*
    Returns the base ability modifier for
    the given creature, unaltered by spells
    and equipment.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 10, 2016
//:://////////////////////////////////////////////
int GetBaseAbilityModifier(object oCreature, int nAbility)
{
    int nAbilityScore = GetAbilityScore(oCreature, nAbility, TRUE);

    if(nAbilityScore < 10) nAbilityScore -= 1;

    return (nAbilityScore - 10) / 2;
}

//::///////////////////////////////////////////////
//:: GetBonusHitDice
//:://////////////////////////////////////////////
/*
    Returns the bonus hit dice value for the
    creature, which is flagged and used by
    some abilities.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 2, 2016
//:://////////////////////////////////////////////
int GetBonusHitDice(object oCreature)
{
    return GetLocalInt(oCreature, LIB_GENERIC_PREFIX + "BonusHitDice");
}

//::///////////////////////////////////////////////
//:: GetClassHitDie
//:://////////////////////////////////////////////
/*
    Returns the hit die used for the given
    class (e.g. 8 for clerics).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 10, 2016
//:://////////////////////////////////////////////
int GetClassHitDie(int nClass)
{
    return StringToInt(Get2DAString("classes", "HitDie", nClass));
}

//::///////////////////////////////////////////////
//:: GetHasWeaponFocusFeat
//:://////////////////////////////////////////////
/*
    Returns TRUE if oCreature has any weapon
    focus feat.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: October 25, 2017
//:://////////////////////////////////////////////
int GetHasWeaponFocusFeat(object oCreature)
{
    int i;

    for(i = FEAT_WEAPON_FOCUS_DAGGER; i <= FEAT_WEAPON_FOCUS_TWO_BLADED_SWORD; i++)
    {
        if(GetHasFeat(i, oCreature))
            return TRUE;
    }
    if(GetHasFeat(FEAT_WEAPON_FOCUS_CREATURE, oCreature))
        return TRUE;
    if(GetHasFeat(FEAT_WEAPON_FOCUS_DWAXE, oCreature))
        return TRUE;
    if(GetHasFeat(FEAT_WEAPON_FOCUS_WHIP, oCreature))
        return TRUE;
    if(GetHasFeat(FEAT_WEAPON_FOCUS_TRIDENT, oCreature))
        return TRUE;

    return FALSE;
}

//::///////////////////////////////////////////////
//:: GetHitPointBonus
//:://////////////////////////////////////////////
/*
    Returns bonus hit points granted to the
    creature from constitution and toughness.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 10, 2016
//:://////////////////////////////////////////////
int GetHitPointBonus(object oCreature)
{
    int nHPBonus = GetBaseAbilityModifier(oCreature, ABILITY_CONSTITUTION) * GetHitDice(oCreature);

    if(GetHasFeat(FEAT_TOUGHNESS, oCreature)) nHPBonus += GetHitDice(oCreature);
    if(GetHasFeat(FEAT_EPIC_TOUGHNESS_10, oCreature)) nHPBonus += 200;
    else if(GetHasFeat(FEAT_EPIC_TOUGHNESS_9, oCreature)) nHPBonus += 180;
    else if(GetHasFeat(FEAT_EPIC_TOUGHNESS_8, oCreature)) nHPBonus += 160;
    else if(GetHasFeat(FEAT_EPIC_TOUGHNESS_7, oCreature)) nHPBonus += 140;
    else if(GetHasFeat(FEAT_EPIC_TOUGHNESS_6, oCreature)) nHPBonus += 120;
    else if(GetHasFeat(FEAT_EPIC_TOUGHNESS_5, oCreature)) nHPBonus += 100;
    else if(GetHasFeat(FEAT_EPIC_TOUGHNESS_4, oCreature)) nHPBonus += 80;
    else if(GetHasFeat(FEAT_EPIC_TOUGHNESS_3, oCreature)) nHPBonus += 60;
    else if(GetHasFeat(FEAT_EPIC_TOUGHNESS_2, oCreature)) nHPBonus += 40;
    else if(GetHasFeat(FEAT_EPIC_TOUGHNESS_1, oCreature)) nHPBonus += 20;

    return nHPBonus;
}

//::///////////////////////////////////////////////
//:: GetIsAppearanceDynamic
//:://////////////////////////////////////////////
/*
    Returns TRUE if the given appearance type
    is dynamic.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 16, 2016
//:://////////////////////////////////////////////
int GetIsAppearanceDynamic(int nAppearanceType)
{
    return Get2DAString("appearance", "MODELTYPE", nAppearanceType) == "P";
}

//::///////////////////////////////////////////////
//:: GetIsCorpse
//:://////////////////////////////////////////////
/*
    Returns TRUE if the object is a corpse
    placeable.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 22, 2016
//:: Modified By: Miesny_Jez
//:: Modified On: February 12, 2018
//:://////////////////////////////////////////////
int GetIsCorpse(object oObject)
{
    if (GetObjectType(oObject) == OBJECT_TYPE_PLACEABLE && 
			(GetResRef(oObject) == RESREF_CORPSE || GetResRef(oObject) == RESREF_CORPSE2))
    {
    	return TRUE;
	}
	else
	{
		return FALSE;
	}
}

//::///////////////////////////////////////////////
//:: GetIsImmobilized
//:://////////////////////////////////////////////
/*
    Returns TRUE if the creature suffers from
    a hard movement-impairing effect. Does not
    include movement speed reduction.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 1, 2016
//:://////////////////////////////////////////////
int GetIsImmobilized(object oCreature)
{
    return (GetHasEffect(EFFECT_TYPE_CUTSCENE_PARALYZE, oCreature)
        || GetHasEffect(EFFECT_TYPE_CUTSCENEIMMOBILIZE, oCreature)
        || GetHasEffect(EFFECT_TYPE_ENTANGLE, oCreature)
        || GetHasEffect(EFFECT_TYPE_PARALYZE, oCreature)
        || GetHasEffect(EFFECT_TYPE_PETRIFY, oCreature)
        || GetHasEffect(EFFECT_TYPE_SLEEP, oCreature)
        || GetHasEffect(EFFECT_TYPE_STUNNED, oCreature));
}

//::///////////////////////////////////////////////
//:: GetKnownFeatLevel
//:://////////////////////////////////////////////
/*
    Returns the level at which the PC learned
    the specified feat. Returns -1 on error.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 11, 2016
//:://////////////////////////////////////////////
int GetKnownFeatLevel(object oPC, int nFeat)
{
    int i;

    for(i = 1; i <= GetHitDice(oPC); i++)
    {
        if(GetKnowsFeatAtLevel(oPC, nFeat, i))
        {
            return i;
        }
    }

    return -1;
}

//::///////////////////////////////////////////////
//:: GetKnowsFeatAtLevel
//:://////////////////////////////////////////////
/*
    Returns TRUE if the PC learned the feat at
    the specified level.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 11, 2016
//:://////////////////////////////////////////////
int GetKnowsFeatAtLevel(object oPC, int nFeat, int nLevel)
{
    int i = 0;
    int nKnownFeat = NWNX_Creature_GetFeatByLevel(oPC, nLevel, i);

    while(nKnownFeat >= 0)
    {
        if(nKnownFeat == nFeat)
        {
            return TRUE;
        }
        i++;
        nKnownFeat = NWNX_Creature_GetFeatByLevel(oPC, nLevel, i);
    }
    return FALSE;
}

//::///////////////////////////////////////////////
//:: GetLevelByClassLevel
//:://////////////////////////////////////////////
/*
    Returns the level at which the PC had
    taken nLevels of nClass (e.g. for a PC
    that had taken their 9th ranger level at
    level 13, the parameters nClass =
    CLASS_TYPE_RANGER and nLevel = 9 would return
    13.)

    Returns -1 on error.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 11, 2016
//:://////////////////////////////////////////////
int GetLevelByClassLevel(object oPC, int nClass, int nLevel)
{
    int nClassLevel;
    int i;

    if(GetLevelByClass(nClass, oPC) < nLevel) return -1;

    for(i = 1; i <= GetHitDice(oPC); i++)
    {
        if(NWNX_Creature_GetClassByLevel(oPC, i) == nClass)
        {
            nClassLevel++;
        }
        if(nClassLevel == nLevel)
        {
            return i;
        }
    }

    return -1;
}

//::///////////////////////////////////////////////
//:: GetLevelFromXP
//:://////////////////////////////////////////////
/*
    Returns the PC's level as a function of
    their current experience total. Note that
    this function ignores whether the PC
    has leveled up or not. Returns -1 on error.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 11, 2016
//:://////////////////////////////////////////////
int GetLevelFromXP(object oPC)
{
    if(!GetIsPC(oPC)) return -1;

    int nLevel = FloatToInt(0.5 + sqrt(0.25 + (IntToFloat(GetXP(oPC)) / 500)));

    return nLevel > MAX_LEVEL ? MAX_LEVEL : nLevel;
}

//::///////////////////////////////////////////////
//:: GetPrimaryClass
//:://////////////////////////////////////////////
/*
    Returns the class in which the given creature
    has the most levels. If two classes are tied,
    then the first will be returned.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 10, 2016
//:://////////////////////////////////////////////
int GetPrimaryClass(object oCreature)
{
    int nClass = GetClassByPosition(1, oCreature);

    if(GetLevelByClass(GetClassByPosition(2, oCreature)) > GetLevelByClass(nClass, oCreature))
        nClass = GetClassByPosition(2, oCreature);
    if(GetLevelByClass(GetClassByPosition(3, oCreature)) > GetLevelByClass(nClass, oCreature))
        nClass = GetClassByPosition(3, oCreature);

    return nClass;
}

//::///////////////////////////////////////////////
//:: GetXPRequiredForLevel
//:://////////////////////////////////////////////
/*
    Returns the amount of experience required
    to reach the specified level. Returns -1
    on error.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 11, 2016
//:://////////////////////////////////////////////
int GetXPRequiredForLevel(int nLevel)
{
    if(nLevel < 1 || nLevel > MAX_LEVEL) return -1;

    return StringToInt(Get2DAString("exptable", "XP", nLevel - 1));
}

//::///////////////////////////////////////////////
//:: IncreaseKnownSkillRanks
//:://////////////////////////////////////////////
/*
    Increases ranks of all skills known by
    the creature by the given amount.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 10, 2016
//:://////////////////////////////////////////////
void IncreaseKnownSkillRanks(object oCreature, int nAmount)
{
    int nSkill;
    int nSkillRank;

    for(nSkill = SKILL_ANIMAL_EMPATHY; nSkill <= SKILL_RIDE; nSkill++)
    {
        int nSkillRank = GetSkillRank(nSkill, oCreature, TRUE);
        if(nSkillRank)
        {
            NWNX_Creature_SetSkillRank(oCreature, nSkill, nSkillRank + nAmount);
        }
    }
}

//::///////////////////////////////////////////////
//:: IncreaseMaximumHitPoints
//:://////////////////////////////////////////////
/*
    Increases the maximum hit points of the
    creature by the given amount.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 10, 2016
//:://////////////////////////////////////////////
void IncreaseMaximumHitPoints(object oCreature, int nAmount)
{
    int nMaxHP = GetMaxHitPoints(oCreature) + nAmount;

    AR_NWNX_Object_SetMaxHitPoints(oCreature, nMaxHP);
    NWNX_Object_SetCurrentHitPoints(oCreature, nMaxHP);
}

//::///////////////////////////////////////////////
//:: IncreasePCSkillPoints
//:://////////////////////////////////////////////
/*
    Increases (or decreases) the PC's skill point
    total by nAmount. If bRelevel is TRUE, then
    the PC will be releveled if they currently
    have the ability to level up; this will
    ensure that the skill points appear on
    the level up interface.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 11, 2016
//:://////////////////////////////////////////////
void IncreasePCSkillPoints(object oPC, int nAmount, int bRelevel = TRUE)
{
    int nCurrentXP = GetXP(oPC);
    int nLowerBoundXP = GetXPRequiredForLevel(GetHitDice(oPC));

    if(!(GetLevelFromXP(oPC) > GetHitDice(oPC)))
        bRelevel = FALSE;

    if(bRelevel) SetXP(oPC, nLowerBoundXP - 1);
    SetPCSkillPoints(oPC, GetPCSkillPoints(oPC) + nAmount);
    DelayCommand(1.0, SetXP(oPC, nCurrentXP));
}

//::///////////////////////////////////////////////
//:: MaximizeHitPoints
//:://////////////////////////////////////////////
/*
    Maximize's the creature's hit points, as
    if it had gained max hit points her level.
    Does not work for PCs.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 10, 2016
//:://////////////////////////////////////////////
void MaximizeHitPoints(object oCreature, int nPercent = 100)
{
    int nClass1 = GetClassByPosition(1, oCreature);
    int nClass2 = GetClassByPosition(2, oCreature);
    int nClass3 = GetClassByPosition(3, oCreature);
    int nPaleMaster = GetLevelByClass(CLASS_TYPE_PALEMASTER, oCreature);
    int nRDD = GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE, oCreature);
    int nTotalHitDice = GetHitDice(oCreature);
    int nHitDie1 = (nClass1 != CLASS_TYPE_INVALID) ? GetClassHitDie(nClass1) : 0;
    int nHitDie2 = (nClass2 != CLASS_TYPE_INVALID) ? GetClassHitDie(nClass2) : 0;
    int nHitDie3 = (nClass3 != CLASS_TYPE_INVALID) ? GetClassHitDie(nClass3) : 0;
    int nMaxHP = GetLevelByClass(nClass1, oCreature) * nHitDie1
        + GetLevelByClass(nClass2, oCreature) + nHitDie2
        + GetLevelByClass(nClass3, oCreature) + nHitDie3;

    // Add pale master deathless vigor
    if(nPaleMaster >= 5) nMaxHP += 3;
    if(nPaleMaster >= 6) nMaxHP += 3;
    if(nPaleMaster>= 7) nMaxHP += 3;
    if(nPaleMaster >= 8) nMaxHP += 3;
    if(nPaleMaster >= 9) nMaxHP += 3;
    if(nPaleMaster >= 10) nMaxHP += 3;
    if(nPaleMaster >= 15) nMaxHP += 5;
    if(nPaleMaster >= 20) nMaxHP += 5;
    if(nPaleMaster >= 25) nMaxHP += 5;
    if(nPaleMaster >= 30) nMaxHP += 5;

    // Add RDD hit die increase
    if(nRDD > 3) nMaxHP += (2 * nRDD - 3);
    if(nRDD > 5) nMaxHP += (2 * nRDD - 5);
    if(nRDD > 10) nMaxHP += (2 * nRDD - 10);

    nMaxHP *= nPercent;
    nMaxHP /= 100;

    NWNX_Object_SetMaxHitPoints(oCreature, nMaxHP);
    NWNX_Object_SetCurrentHitPoints(oCreature, GetMaxHitPoints(oCreature));
}

//::///////////////////////////////////////////////
//:: MaximizeKnownSkillRanks
//:://////////////////////////////////////////////
/*
    Sets ranks of all skills known by the
    creature to the maximum value for its level.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 10, 2016
//:://////////////////////////////////////////////
void MaximizeKnownSkillRanks(object oCreature)
{
    int nSkill;
    int nSkillMax = (GetHitDice(oCreature) + 3);

    for(nSkill = SKILL_ANIMAL_EMPATHY; nSkill <= SKILL_RIDE; nSkill++)
    {
        if(GetSkillRank(nSkill, oCreature, TRUE))
        {
            NWNX_Creature_SetSkillRank(oCreature, nSkill, nSkillMax);
        }
    }
}

//::///////////////////////////////////////////////
//:: RemoveAllAssociates
//:://////////////////////////////////////////////
/*
    Removes all associates from the creature.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 27, 2016
//:://////////////////////////////////////////////
void RemoveAllAssociates(object oCreature)
{
    int i, j;

    for(i = ASSOCIATE_TYPE_HENCHMAN; i < ASSOCIATE_TYPE_DOMINATED; i++)
    {
        while(GetIsObjectValid(GetAssociate(i, oCreature, ++j)))
        {
            if(i == ASSOCIATE_TYPE_HENCHMAN)
            {
                RemoveHenchman(oCreature, GetAssociate(i, oCreature, j));
            }
            else
            {
                RemoveSummonedAssociate(oCreature, GetAssociate(i, oCreature, j));
            }
        }
        j = 0;
    }
    RemoveSummonedAssociate(oCreature, GetAssociate(ASSOCIATE_TYPE_DOMINATED, oCreature));
}

//::///////////////////////////////////////////////
//:: RemovePackageFeats
//:://////////////////////////////////////////////
/*
    Removes all feats from the creature granted
    via the given package.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 17, 2016
//:://////////////////////////////////////////////
void RemovePackageFeats(object oCreature, int nPackage)
{
    int i;
    string sPackage2DA = Get2DAString("packages", "FeatPref2DA", nPackage);
    string sFeat;

    do
    {
        sFeat = Get2DAString(sPackage2DA, "FeatIndex", i);
        if(sFeat != "") NWNX_Creature_RemoveFeat(oCreature, StringToInt(sFeat));
        i++;
    } while(sFeat != "");
}

//::///////////////////////////////////////////////
//:: SetAC
//:://////////////////////////////////////////////
/*
    Modifies the creature's base AC so that its
    current AC value matches the given value.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 16, 2016
//:://////////////////////////////////////////////
void SetAC(object oCreature, int nValue)
{
    NWNX_Creature_SetBaseAC(oCreature, GetACNaturalBase(oCreature) + nValue - GetAC(oCreature));
}

//::///////////////////////////////////////////////
//:: SetAllSkillRanks
//:://////////////////////////////////////////////
/*
    Sets all skill ranks for the creature to
    the given value.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 17, 2016
//:://////////////////////////////////////////////
void SetAllSkillRanks(object oCreature, int nValue)
{
    int nSkill;

    for(nSkill = SKILL_ANIMAL_EMPATHY; nSkill <= SKILL_RIDE; nSkill++)
    {
        NWNX_Creature_SetSkillRank(oCreature, nSkill, nValue);
    }
}

//::///////////////////////////////////////////////
//:: SetBonusHitDice
//:://////////////////////////////////////////////
/*
    Sets the bonus hit dice value for the
    creature, which is flagged and used by
    some abilities.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 2, 2016
//:://////////////////////////////////////////////
void SetBonusHitDice(object oCreature, int nBonus)
{
    SetLocalInt(oCreature, LIB_GENERIC_PREFIX + "BonusHitDice", nBonus);
}

//::///////////////////////////////////////////////
//:: SetDespawnTimer
//:://////////////////////////////////////////////
/*
    Sets a despawn timer for the given creature.
    After the given delay, it will be destroyed
    with the given VFX. Note that this will
    only work for creatures that have custom
    behaviors (per inc_behaviors) enabled.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 16, 2017
//:://////////////////////////////////////////////
void SetDespawnTimer(object oCreature, int nDelay, int nVFX = VFX_NONE)
{
    SetLocalInt(oCreature, LIB_GENERIC_PREFIX + "DespawnTime", GetModuleTime() + nDelay);
    SetLocalInt(oCreature, LIB_GENERIC_PREFIX + "DespawnVFX", nVFX);
    AddSpecialBehavior(oCreature, EVENT_HEARTBEAT, "hrt_despawn");
}

//::///////////////////////////////////////////////
//:: SetInventoryDroppable
//:://////////////////////////////////////////////
/*
    Updates the droppable flag for all specified
    items to the specified value.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 13, 2016
//:://////////////////////////////////////////////
void SetInventoryDroppable(object oTarget, int bIsDroppable = TRUE, int bIncludeNonEquipped = TRUE, int bIncludeEquipped = TRUE)
{
    int nSlot;
    object oItem;

    if(bIncludeNonEquipped)
    {
        oItem = GetFirstItemInInventory(oTarget);
        while(GetIsObjectValid(oItem))
        {
            SetDroppableFlag(oItem, bIsDroppable);
            oItem = GetNextItemInInventory(oTarget);
        }
    }
    if(bIncludeEquipped)
    {
        for(nSlot = 0; nSlot < NUM_INVENTORY_SLOTS; ++nSlot)
        {
            SetDroppableFlag(GetItemInSlot(nSlot, oTarget), bIsDroppable);
        }
    }
}

//::///////////////////////////////////////////////
//:: SetRemainingFeatUses
//:://////////////////////////////////////////////
/*
    Sets the remaining uses per day for the given
    feat.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On:
//:://////////////////////////////////////////////
void SetRemainingFeatUses(object oCreature, int nFeat, int nUses)
{
    int i;

    for(i = 0; i < FEAT_MAXIMUM_USES; i++)
    {
        DecrementRemainingFeatUses(oCreature, nFeat);
    }
    for(i = 0; i < nUses; i++)
    {
        IncrementRemainingFeatUses(oCreature, nFeat);
    }
}

/**********************************************************************
 * PRIVATE FUNCTION DEFINITIONS
 **********************************************************************/

//::///////////////////////////////////////////////
//:: _EquipCopiedItems
//:://////////////////////////////////////////////
/*
    Internal function used to equip items
    copied to a creature with a copied appearance.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 17, 2016
//:://////////////////////////////////////////////
void _EquipCopiedItems(object oArmor, object oHelm, object oMainHand, object oOffHand)
{
    ActionEquipItem(oArmor, INVENTORY_SLOT_CHEST);
    ActionEquipItem(oHelm, INVENTORY_SLOT_HEAD);
    ActionEquipItem(oMainHand, INVENTORY_SLOT_RIGHTHAND);
    ActionEquipItem(oOffHand, INVENTORY_SLOT_LEFTHAND);
    ActionDoCommand(SetCommandable(TRUE, OBJECT_SELF));
    SetCommandable(FALSE, OBJECT_SELF);
}
