//::///////////////////////////////////////////////
//:: Summons Library
//:: inc_summons
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 23, 2017
//:://////////////////////////////////////////////

#include "inc_sumbonuses"
#include "inc_sumstream"
#include "inc_timelock"

/**********************************************************************
 * CONFIG PARAMETERS
 **********************************************************************/

// Controls the update interval for delayed summon cooldowns (i.e. cooldowns
// that begin after a summon is dismissed).
const int SUMMON_TIMELOCK_UPDATE_INTERVAL = 0;
const int SUMMON_TIMELOCK_PENULTIMATE_UPDATE_TIME = 6;

// Feedback messages for PCs.
// * %s = ability name
// * %t = time
const string FEEDBACK_TIMELOCK_INITIALIZED = "%s has been locked and will not become available until %t after the summon has been killed or is dismissed.";
const string FEEDBACK_TIMELOCK_COUNTING = "%s will be available once more in %t.";

/**********************************************************************
 * CONSTANT DEFINITIONS
 **********************************************************************/

// Prefix to separate summon variables from other libraries.
const string LIB_SUMMONS_PREFIX = "Lib_Summon_";

/**********************************************************************
 * PUBLIC FUNCTION PROTOTYPES
 **********************************************************************/

// Activates delayed cooldowns on the master's associates. Call whenever a PC is leaving
// the module.
void ActivateAssociateCooldowns(object oMaster);
// Initializes the cooldown for a summon, setting it on a permanent timer until
// unsummoned. Should be called whenever an associate is added to a PC
void InitializeSummonCooldown(object oSummon);
// Schedules a delayed summon cooldown, which begins when an associate is removed from the
// party. Call this just before the associate is actually summoned. If nFeat is set, then
// the given feat will be disabled until the cooldown expires.
void ScheduleSummonCooldown(object oSummoner, int nTimeSeconds, string sLabel, int nFeat = -1);
// Starts the temporary portion of a delayed summon cooldown timer, which finally allows
// a summon to be called again when finished. Should be called whenever an associate
// is removed from a PC.
void StartSummonCooldownTimer(object oSummon);

/**********************************************************************
 * PRIVATE FUNCTION PROTOTYPES
 **********************************************************************/

/* Internal function called on a delay to resolve timing issues. */
void _InitializeSummonCooldown(object oSummon);

/**********************************************************************
 * PUBLIC FUNCTION DEFINITIONS
 **********************************************************************/

//::///////////////////////////////////////////////
//:: ActivateAssociateCooldowns
//:://////////////////////////////////////////////
/*
    Activates delayed cooldowns on the master's
    associates. Call whenever a PC is leaving
    the module.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 13, 2017
//:://////////////////////////////////////////////
void ActivateAssociateCooldowns(object oMaster)
{
    int i;
    int bIsValid;
    object oSummon;

    do
    {
        i++;
        oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oMaster, i);
        if(GetIsObjectValid(oSummon))
        {
            bIsValid = TRUE;
            StartSummonCooldownTimer(oSummon);
        }
        else
        {
            bIsValid = FALSE;
        }
    } while(bIsValid);
}

//::///////////////////////////////////////////////
//:: InitializeSummonCooldown
//:://////////////////////////////////////////////
/*
    Initializes the cooldown for a summon,
    setting it on a permanent timer until
    unsummoned. Should be called whenever
    an associate is added to a PC.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 23, 2017
//:://////////////////////////////////////////////
void InitializeSummonCooldown(object oSummon)
{
    DelayCommand(0.0, _InitializeSummonCooldown(oSummon));
}

//::///////////////////////////////////////////////
//:: ScheduleSummonCooldown
//:://////////////////////////////////////////////
/*
    Schedules a delayed summon cooldown, which
    begins when an associate is removed from the
    party. Call this just before the associate
    is actually summoned. If nFeat is set, then
    the given feat will be disabled until the
    cooldown expires.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 23, 2017
//:://////////////////////////////////////////////
void ScheduleSummonCooldown(object oSummoner, int nTimeSeconds, string sLabel, int nFeat = -1)
{
    SetLocalInt(oSummoner, LIB_SUMMONS_PREFIX + "SummonCooldownTime", nTimeSeconds);
    SetLocalString(oSummoner, LIB_SUMMONS_PREFIX + "SummonCooldownLabel", sLabel);
    SetLocalInt(oSummoner, LIB_SUMMONS_PREFIX + "SummonCooldownFeat", nFeat);
}

//::///////////////////////////////////////////////
//:: StartSummonCooldownTimer
//:://////////////////////////////////////////////
/*
    Starts the temporary portion of a delayed
    summon cooldown timer, which finally allows
    a summon to be called again when finished.
    Should be called whenever an associate
    is removed from a PC.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 23, 2017
//:://////////////////////////////////////////////
void StartSummonCooldownTimer(object oSummon)
{
    object oSummoner = GetMaster(oSummon);
    string sLabel = GetLocalString(oSummon, LIB_SUMMONS_PREFIX + "SummonCooldownLabel");

    if(sLabel == "") return;

    int nFeat = GetLocalInt(oSummon, LIB_SUMMONS_PREFIX + "SummonCooldownFeat");
    int nTimeSeconds = GetLocalInt(oSummon, LIB_SUMMONS_PREFIX + "SummonCooldownTime");

    SetTimelock(oSummoner, nTimeSeconds, sLabel, SUMMON_TIMELOCK_UPDATE_INTERVAL, SUMMON_TIMELOCK_PENULTIMATE_UPDATE_TIME, nFeat,
        _ParseTimelockString(FEEDBACK_TIMELOCK_COUNTING, sLabel, nTimeSeconds));
}

/**********************************************************************
 * PRIVATE FUNCTION DEFINITIONS
 **********************************************************************/

//::///////////////////////////////////////////////
//:: _InitializeSummonCooldown
//:://////////////////////////////////////////////
/*
    Internal function called on a delay to
    resolve timing issues.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 23, 2017
//:://////////////////////////////////////////////
void _InitializeSummonCooldown(object oSummon)
{
    object oSummoner = GetMaster(oSummon);
    string sLabel = GetLocalString(oSummoner, LIB_SUMMONS_PREFIX + "SummonCooldownLabel");

    if(sLabel == "") return;

    int nFeat = GetLocalInt(oSummoner, LIB_SUMMONS_PREFIX + "SummonCooldownFeat");
    int nTimeSeconds = GetLocalInt(oSummoner, LIB_SUMMONS_PREFIX + "SummonCooldownTime");

    SetLocalInt(oSummon, LIB_SUMMONS_PREFIX + "SummonCooldownFeat", nFeat);
    SetLocalInt(oSummon, LIB_SUMMONS_PREFIX + "SummonCooldownTime", nTimeSeconds);
    SetLocalString(oSummon, LIB_SUMMONS_PREFIX + "SummonCooldownLabel", sLabel);
    DeleteLocalInt(oSummoner, LIB_SUMMONS_PREFIX + "SummonCooldownFeat");
    DeleteLocalInt(oSummoner, LIB_SUMMONS_PREFIX + "SummonCooldownTime");
    DeleteLocalString(oSummoner, LIB_SUMMONS_PREFIX + "SummonCooldownLabel");

    SetTimelock(oSummoner, TIMELOCK_TIMESTAMP_PERMANENT, sLabel, SUMMON_TIMELOCK_UPDATE_INTERVAL, SUMMON_TIMELOCK_PENULTIMATE_UPDATE_TIME, nFeat,
        _ParseTimelockString(FEEDBACK_TIMELOCK_INITIALIZED, sLabel, nTimeSeconds));
}
