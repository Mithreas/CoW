//::///////////////////////////////////////////////
//:: On Enter: Secret Object
//:: ent_secretobject
//:://////////////////////////////////////////////
/*
    Placed on the on enter event for a trigger
    to handle discovery of secret objects
    within the trigger. Secret objects are
    objects that become useable when detected.
    The secret object handled by this trigger
    will correspond to the nearest object with
    the tag "SecretObject".

    Secret objects can be detected via PCs and
    their associates. Their detect mode state
    will be respected for this (i.e. active
    detect mode will allow them to find objects
    faster and at longer range).

    Detection DC is controlled by a flag on the
    trigger.

    int SO_DetectDC

    Config parameters can also be set on the
    object itself:

    int SO_TogglePlotFlag (if set to 1, then the
        secret object will be flagged plot
        when unuseable, and not plot otherwise)
    int SO_NeverResetUseableFlag (if set to 1, then
        the object will not become unuseable again
        when the trigger is exited)
    int SO_MuteFeedback (if set to 1, then no
        feedback message will be given to PCs
        that detect the object)
    float SO_DetectRadius (if a positive radius
        is given, then the default detect radii
        will be overridden; if a negative value
        is given, then the detect radius will be
        of infinite range)
    string SO_FeedbackMessage (controls the
        feedback message given to players; a
        default one will be given if not specified)
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 16, 2016
//:://////////////////////////////////////////////
#include "inc_common"

// Tag of secret objects.
const string VAR_SECRET_OBJECT_TAG = "SecretObject";

// Radii for active and passive detect mode detection. These values correspond to
// those used to detect traps in the default game engine.
const float ACTIVE_DETECT_MODE_RADIUS = 6.66;
const float PASSIVE_DETECT_MODE_RADIUS = 3.33;

// Number of seconds between search checks for active and passive detect mode. These
// values correspond to the default values used for search checks.
const float ACTIVE_DETECT_MODE_SEARCH_INTERVAL = 3.0;
const float PASSIVE_DETECT_MODE_SEARCH_INTERVAL = 6.0;

// Default message shown to PCs that detect a secret object.
const string MESSAGE_SECRET_OBJECT_DETECTED = "*You have discovered a secret object!*";

// Recursive search routine.
void DetectSecretObject(object oPC, object oSecretObject, object oTrigger = OBJECT_SELF);
// Returns TRUE if the object is within the area of this trigger.
int GetIsInTriggerArea(object oPC);

//::///////////////////////////////////////////////
//:: main
//:://////////////////////////////////////////////
/*
    Main driver responsible for initiating the
    recursive search routine.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 16, 2016
//:://////////////////////////////////////////////
void main()
{
    object oPC = GetEnteringObject();
    object oSecretObject = GetLocalObject(OBJECT_SELF, "SO_SecretObject");

    if(!GetIsObjectValid(oSecretObject))
    {
        oSecretObject = GetNearestObjectByTag(VAR_SECRET_OBJECT_TAG);
        SetLocalObject(OBJECT_SELF, "SO_SecretObject", oSecretObject);
    }

    if((!GetIsPC(oPC) && !GetIsPC(GetMaster(oPC))) || GetIsDM(oPC) || GetIsDM(GetMaster(oPC)) || !GetIsObjectValid(oSecretObject) || GetUseableFlag(oSecretObject) || GetLocalInt(oPC, "SO_Searching"))
        return;

    SetLocalInt(oPC, "SO_Searching", TRUE);
    DetectSecretObject(oPC, oSecretObject);
}

//::///////////////////////////////////////////////
//:: DetectSecretObject
//:://////////////////////////////////////////////
/*
    Recursive search routine.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 16, 2016
//:://////////////////////////////////////////////
void DetectSecretObject(object oPC, object oSecretObject, object oTrigger = OBJECT_SELF)
{
    if(!GetIsObjectValid(oPC) || !GetIsObjectValid(oSecretObject) || GetUseableFlag(oSecretObject) || !GetIsObjectValid(OBJECT_SELF) || !GetIsInTriggerArea(oPC))
    {
        DeleteLocalInt(oPC, "SO_Searching");
        return;
    }

    int nDetectMode = GetDetectMode(oPC);
    float fDetectRadius = GetLocalFloat(oTrigger, "SO_DetectRadius");
    float fSearchInterval = nDetectMode == DETECT_MODE_ACTIVE ? ACTIVE_DETECT_MODE_SEARCH_INTERVAL : PASSIVE_DETECT_MODE_SEARCH_INTERVAL;
    string sFeedback;

    // Undefined detect radius. Use default values.
    if(fDetectRadius == 0.0)
    {
        fDetectRadius = (nDetectMode == DETECT_MODE_ACTIVE) ? ACTIVE_DETECT_MODE_RADIUS : PASSIVE_DETECT_MODE_RADIUS;
    }
    // Out of detect radius. Try again next search interval.
    if(fDetectRadius != 0.0 && GetDistanceBetween(oPC, oSecretObject) > fDetectRadius)
    {
        DelayCommand(fSearchInterval, DetectSecretObject(oPC, oSecretObject, oTrigger));
    }
    // Not detected. Try again next search interval.
    else if(!gsCMGetIsSkillSuccessful(oPC, SKILL_SEARCH, GetLocalInt(OBJECT_SELF, "SO_DetectDC"), FALSE))
    {
        DelayCommand(fSearchInterval, DetectSecretObject(oPC, oSecretObject, oTrigger));
    }
    // Detected!
    else
    {
        SetUseableFlag(oSecretObject, TRUE);
        if(GetLocalInt(oSecretObject, "SO_TogglePlotFlag"))
        {
            SetPlotFlag(oSecretObject, FALSE);
        }
        if(!GetLocalInt(oSecretObject, "SO_MuteFeedback"))
        {
            // Fetch the master if this is a PC's summon.
            if(GetIsObjectValid(GetMaster(oPC)))
            {
                oPC = GetMaster(oPC);
            }
            sFeedback = (GetLocalString(oSecretObject, "SO_FeedbackMessage") == "") ? MESSAGE_SECRET_OBJECT_DETECTED :
                GetLocalString(oSecretObject, "SO_FeedbackMessage");
            FloatingTextStringOnCreature(sFeedback, oPC, FALSE);
        }
        DeleteLocalInt(oPC, "SO_Searching");
    }
}

//::///////////////////////////////////////////////
//:: GetIsInTriggerArea
//:://////////////////////////////////////////////
/*
    Returns TRUE if the object is within
    the area of this trigger.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 16, 2016
//:://////////////////////////////////////////////
int GetIsInTriggerArea(object oPC)
{
    object oCheck = GetFirstInPersistentObject();

    while(GetIsObjectValid(oCheck))
    {
        if(oCheck == oPC)
            return TRUE;
        oCheck = GetNextInPersistentObject();
    }
    return FALSE;
}

