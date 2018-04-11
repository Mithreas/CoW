//::///////////////////////////////////////////////
//:: DM Library
//:: inc_dm
//:://////////////////////////////////////////////
/*
    Contains helper functions for use with DM
    actions and tools.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 27, 2016
//:://////////////////////////////////////////////

#include "inc_string"

/**********************************************************************
 * CONFIG PARAMETERS
 **********************************************************************/

const string MESSAGE_DM_ACTION_TARGET_SELECTED = "You are now targeting %target.";

/**********************************************************************
 * CONSTANT DEFINITIONS
 **********************************************************************/

const string LIB_DM_PREFIX = "Lib_DM_";

/**********************************************************************
 * PUBLIC FUNCTION PROTOTYPES
 **********************************************************************/

// Returns the DM's current action target for use with various commands.
object GetDMActionTarget(object oDM = OBJECT_SELF);
// Sets the DM's current action target for use with various commands.
void SetDMActionTarget(object oTarget, object oDM = OBJECT_SELF, int bFeedback = TRUE);

 /**********************************************************************
 * PUBLIC FUNCTION DEFINITIONS
 **********************************************************************/

//::///////////////////////////////////////////////
//:: GetDMActionTarget
//:://////////////////////////////////////////////
/*
    Returns the DM's current action target
    for use with various commands.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 27, 2016
//:://////////////////////////////////////////////
object GetDMActionTarget(object oDM = OBJECT_SELF)
{
    return GetLocalObject(oDM, LIB_DM_PREFIX + "DMActionTarget");
}

//::///////////////////////////////////////////////
//:: SetDMActionTarget
//:://////////////////////////////////////////////
/*
    Sets the DM's current action target for
    use with various commands.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 27, 2016
//:://////////////////////////////////////////////
void SetDMActionTarget(object oTarget, object oDM = OBJECT_SELF, int bFeedback = TRUE)
{
    SetLocalObject(oDM, LIB_DM_PREFIX + "DMActionTarget", oTarget);
    if(bFeedback) SendMessageToPC(oDM, ParseFormatStrings(MESSAGE_DM_ACTION_TARGET_SELECTED, "%target", GetName(oTarget)));
}
