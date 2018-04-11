//::///////////////////////////////////////////////
//:: Level Bonuses Library
//:: inc_levelbonuses
//:://////////////////////////////////////////////
/*
    Contains helper functions to add, remove, and
    track level bonuses outside the scope of
    .2das (e.g. bonus skill points for rangers).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 8, 2016
//:://////////////////////////////////////////////

#include "gs_inc_common"
#include "inc_list"
#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"

/**********************************************************************
 * CONFIG PARAMETERS
 **********************************************************************/

const string LEVEL_BONUS_SCRIPT_PREFIX = "bon_";

/**********************************************************************
 * CONSTANT DEFINITIONS
 **********************************************************************/

 // Prefix to separate bonuses variables from other libraries.
const string LIB_LEVEL_BONUSES_PREFIX = "Lib_Level_Bonuses_";

const int LEVEL_BONUS_APPLY = 1;
const int LEVEL_BONUS_REMOVE = 2;

const int PC_MIN_LEVEL = 1;
const int PC_MAX_LEVEL = 30;

/**********************************************************************
 * PUBLIC FUNCTION PROTOTYPES
 **********************************************************************/

// Applies level bonuses to the PC for the designated level using the designated
// script. If the script designated has already been applied for that level, this function
// will do nothing.
void ApplyLevelBonuses(object oPC, int nLevel, int nClass, string sBonusScript, int bForceApply = FALSE);
// Returns whether level bonuses have been configured to apply or be removed from the
// PC. Should be called from an external level bonus script.
int GetLevelBonusParamApplyRemove(object oPC);
// Returns the level for which bonuses are being applied or removed from the PC. Should be
// called from an external level bonus script.
int GetLevelBonusParamLevel(object oPC);
// Removes all level bonuses from the PC at the designated level.
void RemoveLevelBonuses(object oPC, int nClass, int nLevel);
// Updates level bonuses for the PC at all levels, adding bonuses for levels that the PC
// meets or exceeds, and removing bonuses for the levels the PC does not. If no bonus script
// is passed in, bonuses will only be removed, not added.
void UpdateLevelBonuses(object oPC, int nClass = CLASS_TYPE_ANY, string sBonusScript = "");

/**********************************************************************
 * PRIVATE FUNCTION PROTOTYPES
 **********************************************************************/

/* Deletes all level bonus config params from the PC. */
void _DeleteLevelBonusConfigParams(object oPC);
/* Sets level bonus config params for the PC. There is no need to ever call this directly;
   it is called automatically bt the relevant functions. */
void _SetLevelBonusConfigParams(object oPC, int nLevel, int nApplyRemove);

/**********************************************************************
 * PUBLIC FUNCTION DEFINITIONS
 **********************************************************************/

//::///////////////////////////////////////////////
//:: ApplyLevelBonuses
//:://////////////////////////////////////////////
/*
    Applies level bonuses to the PC for the
    designated level using the designated
    script. If the script designated has already
    been applied for that level, this function
    will do nothing.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 8, 2016
//:://////////////////////////////////////////////
void ApplyLevelBonuses(object oPC, int nLevel, int nClass, string sBonusScript, int bForceApply = FALSE)
{
    object oHide = gsPCGetCreatureHide(oPC);
    int bBonusesPreviouslyApplied = (GetListElementIndex(oHide, LIB_LEVEL_BONUSES_PREFIX + "LevelBonuses" + IntToString(nLevel), sBonusScript) != LIST_INDEX_OUT_OF_BOUNDS);

    if(sBonusScript == "" || (nClass != CLASS_TYPE_ANY && NWNX_Creature_GetClassByLevel(oPC, nLevel) != nClass) || (bBonusesPreviouslyApplied && !bForceApply))
        return;

    _SetLevelBonusConfigParams(oPC, nLevel, LEVEL_BONUS_APPLY);
    if(!bBonusesPreviouslyApplied) AddListElement(oHide, LIB_LEVEL_BONUSES_PREFIX + "LevelBonuses" + IntToString(nLevel), sBonusScript);
    ExecuteScript(LEVEL_BONUS_SCRIPT_PREFIX + sBonusScript, oPC);
    _DeleteLevelBonusConfigParams(oPC);
}

//::///////////////////////////////////////////////
//:: GetLevelBonusParamApplyRemove
//:://////////////////////////////////////////////
/*
    Returns whether level bonuses have been
    configured to apply or be removed from the
    PC. Should be called from an external
    level bonus script.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 8, 2016
//:://////////////////////////////////////////////
int GetLevelBonusParamApplyRemove(object oPC)
{
    return GetLocalInt(oPC, LIB_LEVEL_BONUSES_PREFIX + "LevelBonusConfigParamApplyRemove");
}

//::///////////////////////////////////////////////
//:: GetLevelBonusParamLevel
//:://////////////////////////////////////////////
/*
    Returns the level for which bonuses are being
    applied or removed from the PC. Should be
    called from an external level bonus script.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 8, 2016
//:://////////////////////////////////////////////
int GetLevelBonusParamLevel(object oPC)
{
    return GetLocalInt(oPC, LIB_LEVEL_BONUSES_PREFIX + "LevelBonusConfigParamLevel");
}

//::///////////////////////////////////////////////
//:: RemoveLevelBonuses
//:://////////////////////////////////////////////
/*
    Removes all level bonuses from the PC
    at the designated level.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 8, 2016
//:://////////////////////////////////////////////
void RemoveLevelBonuses(object oPC, int nClass, int nLevel)
{
    object oHide = gsPCGetCreatureHide(oPC);
    int i;
    int nSize = GetListSize(oHide, LIB_LEVEL_BONUSES_PREFIX + "LevelBonuses" + IntToString(nLevel));

    _SetLevelBonusConfigParams(oPC, nLevel, LEVEL_BONUS_REMOVE);

    for(i = 0; i < nSize; i++)
    {
        ExecuteScript(LEVEL_BONUS_SCRIPT_PREFIX + GetListElement(oHide, LIB_LEVEL_BONUSES_PREFIX + "LevelBonuses" + IntToString(nLevel), i), oPC);
    }

    DeleteListArray(oHide, LIB_LEVEL_BONUSES_PREFIX + "LevelBonuses" + IntToString(nLevel));
    _DeleteLevelBonusConfigParams(oPC);
}

//::///////////////////////////////////////////////
//:: UpdateLevelBonuses
//:://////////////////////////////////////////////
/*
    Updates level bonuses for the PC at all
    levels, adding bonuses for levels that the PC
    meets or exceeds, and removing bonuses for
    the levels the PC does not. If no bonus script
    is passed in, bonuses will only be removed,
    not added.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 8, 2016
//:://////////////////////////////////////////////
void UpdateLevelBonuses(object oPC, int nClass = CLASS_TYPE_ANY, string sBonusScript = "")
{
    int i;
    int nLevel = GetHitDice(oPC);

    for(i = PC_MIN_LEVEL; i <= PC_MAX_LEVEL; i++)
    {
        if(nLevel >= i)
        {
            ApplyLevelBonuses(oPC, i, nClass, sBonusScript);
        }
        else
        {
            RemoveLevelBonuses(oPC, nClass, i);
        }
    }
}

/**********************************************************************
 * PRIVATE FUNCTION DEFINITIONS
 **********************************************************************/

//::///////////////////////////////////////////////
//:: _DeleteLevelBonusConfigParams
//:://////////////////////////////////////////////
/*
    Deletes all level bonus config params from
    the PC.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 8, 2016
//:://////////////////////////////////////////////
void _DeleteLevelBonusConfigParams(object oPC)
{
    DeleteLocalInt(oPC, LIB_LEVEL_BONUSES_PREFIX + "LevelBonusConfigParamLevel");
    DeleteLocalInt(oPC, LIB_LEVEL_BONUSES_PREFIX + "LevelBonusConfigParamApplyRemove");
}

//::///////////////////////////////////////////////
//:: _SetLevelBonusConfigParams
//:://////////////////////////////////////////////
/*
    Sets level bonus config params for the PC.
    There is no need to ever call this directly;
    it is called automatically bt the relevant
    functions.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 8, 2016
//:://////////////////////////////////////////////
void _SetLevelBonusConfigParams(object oPC, int nLevel, int nApplyRemove)
{
    SetLocalInt(oPC, LIB_LEVEL_BONUSES_PREFIX + "LevelBonusConfigParamLevel", nLevel);
    SetLocalInt(oPC, LIB_LEVEL_BONUSES_PREFIX + "LevelBonusConfigParamApplyRemove", nApplyRemove);
}
