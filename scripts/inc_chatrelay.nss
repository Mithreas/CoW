//::///////////////////////////////////////////////
//:: Chat Library
//:: inc_chatrelay
//:://////////////////////////////////////////////
/*
    Contains chat relay helper functions.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 5, 2016
//:://////////////////////////////////////////////

/**********************************************************************
 * CONSTANT DEFINITIONS
 **********************************************************************/

 // Prefix to separate chat variables from other libraries.
const string LIB_CHAT_RELAY_PREFIX = "Lib_Chat_Relay";

/**********************************************************************
 * PUBLIC FUNCTION PROTOTYPES
 **********************************************************************/

// Returns the name of the relay object as seen by the recipient.
string GetChatRelayName(object oRelayObject);
// Returns the recipient for chat relay messages from the object.
object GetChatRelayTarget(object oRelayObject);
// Returns TRUe if the object is a chat relay object.
int GetIsChatRelayObject(object oObject);
// Sets the name of the relay object as seen by the recipient.
void SetChatRelayName(object oRelayObject, string sName);
// Sets the recipient for chat messages relayed by the object.
void SetChatRelayTarget(object oRelayObject, object oTarget);

/**********************************************************************
 * PUBLIC FUNCTION DEFINITIONS
 **********************************************************************/

//::///////////////////////////////////////////////
//:: GetChatRelayName
//:://////////////////////////////////////////////
/*
    Returns the name of the relay object as
    seen by the recipient.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 5, 2016
//:://////////////////////////////////////////////
string GetChatRelayName(object oRelayObject)
{
    return GetLocalString(oRelayObject, LIB_CHAT_RELAY_PREFIX + "ChatRelayName");
}

//::///////////////////////////////////////////////
//:: GetChatRelayTarget
//:://////////////////////////////////////////////
/*
    Returns the recipient for chat relay messages
    from the object.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 5, 2016
//:://////////////////////////////////////////////
object GetChatRelayTarget(object oRelayObject)
{
    return GetLocalObject(oRelayObject, LIB_CHAT_RELAY_PREFIX + "ChatRelayTarget");
}

//::///////////////////////////////////////////////
//:: GetIsChatRelayObject
//:://////////////////////////////////////////////
/*
    Returns TRUe if the object is a chat relay
    object.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 5, 2016
//:://////////////////////////////////////////////
int GetIsChatRelayObject(object oObject)
{
    return GetIsObjectValid(GetChatRelayTarget(oObject));
}

//::///////////////////////////////////////////////
//:: SetChatRelayName
//:://////////////////////////////////////////////
/*
    Sets the name of the relay object as seen
    by the recipient.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 5, 2016
//:://////////////////////////////////////////////
void SetChatRelayName(object oRelayObject, string sName)
{
    SetLocalString(oRelayObject, LIB_CHAT_RELAY_PREFIX + "ChatRelayName", sName);
}

//::///////////////////////////////////////////////
//:: SetChatRelayTarget
//:://////////////////////////////////////////////
/*
    Sets the recipient for chat messages
    relayed by the object.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 5, 2016
//:://////////////////////////////////////////////
void SetChatRelayTarget(object oRelayObject, object oTarget)
{
    SetLocalObject(oRelayObject, LIB_CHAT_RELAY_PREFIX + "ChatRelayTarget", oTarget);
}
