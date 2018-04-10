//::///////////////////////////////////////////////
//:: Associate Commands Library
//:: inc_associates
//:://////////////////////////////////////////////
/*
    Contains fuctions for use with custom
    RTS-style associate commands.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 13, 2016
//:://////////////////////////////////////////////

#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"
#include "nw_i0_generic"
#include "x0_i0_assoc"

/**********************************************************************
 * CONFIG PARAMETERS
 **********************************************************************/

// Error message sent for an invalid command.
const string ERROR_INVALID_COMMAND = "Invalid command. You must target an enemy, party member, door, placeable, or the ground.";
// Error message sent when an associate is assigned to follow a target in a different area.
const string ERROR_INVALID_FOLLOW_TARGET = "Invalid target. Associates can only follow party members in the same area.";
// Error message sent when no associate is selected to command.
const string ERROR_NO_ASSOCIATE_SELECTED = "Invalid command. You must first select an associate to control.";
// Message sent when associate command is granted.
const string ASSOCIATE_COMMAND_GRANTED = "You have been granted the Player Tool 1 feat, which allows you to select and command associates. Type '-manual Player Tool 1' for help.";
// Message sent when associate command is removed.
const string ASSOCIATE_COMMAND_REMOVED = "Player Tool 1 has been removed from your feat list. The position of this feat on your quickbar will be restored when summoning an associate if that slot remains empty.";

/**********************************************************************
 * CONSTANT DEFINITIONS
 **********************************************************************/

// Associate command constants.
const int ASSOCIATE_COMMAND_INVALID = 0;
const int ASSOCIATE_COMMAND_ATTACK = 1;
const int ASSOCIATE_COMMAND_MOVE = 2;
const int ASSOCIATE_COMMAND_INTERACT_DOOR = 3;
const int ASSOCIATE_COMMAND_INTERACT_PLACEABLE = 4;
const int ASSOCIATE_COMMAND_FORCE_FOLLOW = 5;
const int ASSOCIATE_COMMAND_AI_ACTIVATE = 6;
const int ASSOCIATE_COMMAND_AI_DEACTIVATE = 7;

// Will return the associate's follow distance when used in AssociateForceFollow().
const float ASSOCIATE_FOLLOW_DISTANCE = 0.0;
// Follow distance to use when none has been assigned to the associate via associate
// state flags.
const float ASSOCIATE_DEFAULT_FOLLOW_DISTANCE = 4.0;

// Associate controller feat granted to PCs.
const int FEAT_ASSOCIATE_COMMAND = 1106; // Player tool 1.

// Prefix to separate associate variables from other libraries.
const string LIB_PREFIX_ASSOCIATES = "Lib_Associates_";
// Error log prefix.
const string ASSOCIATES_ERROR = "ASSOCIATE";

/**********************************************************************
 * PUBLIC FUNCTION PROTOTYPES
 **********************************************************************/

// Commands the associate to follow its current force follow target.
void AssociateForceFollow(object oAssociate = OBJECT_SELF, float fFollowDistance = ASSOCIATE_FOLLOW_DISTANCE);
// Decrements associate count for the PC.
void DecrementAssociateCount(object oPC);
// Determines and returns the type of associate command to execute based on player tool selection.
int DetermineAssociateCommand(object oPC = OBJECT_SELF);
// Returns the associate's designated attack target.
object GetAssociateAttackTarget(object oAssociate = OBJECT_SELF);
// Returns the associate controller of oAssociate. Differs from GetMaster() in that it handles nested associates.
// Returns OBJECT_INVALID if no controller exists.
object GetAssociateController(object oAssociate);
// Returns the number of associates belonging to the PC.
int GetAssociateCount(object oPC);
// Returns TRUE if the creature can disarm the specified object.
int GetCanDisarm(object oCreature, object oTrappedObject);
// Returns TRUE if the associate's master can speak through it using the
// -associate command (i.e. it is an animal companion, familiar, or has been flagged
// with the SetCanMasterSpeakThroughAssociate() function).
int GetCanMasterSpeakThroughAssociate(object oAssociate);
// Returns TRUE if the creature can unlock the specified object.
int GetCanUnlock(object oCreature, object oObject);
// Returns the associate(s) that the PC is currently controlling.
object GetControlledAssociate(object oPC = OBJECT_SELF);
// Returns the distance between the associate and the object it is following.
float GetDistanceToFollowObject(object oAssociate = OBJECT_SELF);
// Returns TRUE if the creature is an associate of any kind.
int GetIsAssociate(object oCreature);
// Returns TRUE if the associate's AI is enabled.
int GetIsAssociateAIEnabled(object oAssociate = OBJECT_SELF);
// Returns TRUE if the associate attack target is invalid.
int GetIsAssociateAttackTargetInvalid(object oAssociate = OBJECT_SELF);
// Returns TRUE if the target can be selected as an associate to control.
int GetIsControllableAssociate(object oAssociate, object oPC = OBJECT_SELF);
// Returns TRUE if the PC is in a party with oMember.
int GetIsPartyMember(object oPC, object oMember);
// Returns the first associate through which the PC can speak using the
// -associate command. If a speaking associate is selected, that one will be
// returned instead.
object GetSpeakingAssociate(object oPC);
// Returns the number of associates through which the PC can speak using the
// -associate command.
int GetSpeakingAssociateCount(object oPC);
// Grants the associate command feat to the PC.
void GrantAssociateCommand(object oPC);
// Increments associate count for the PC.
void IncrementAssociateCount(object oPC);
// Issues the specified command to all selected associates.
void IssueAssociateCommands(object oAssociate, int nAssociateCommand, object oPC = OBJECT_SELF);
// Removes the associate command feat from the PC.
void RemoveAssociateCommand(object oPC);
// Removes force follow objects that are no longer valid from the associate.
void RemoveInvalidForceFollowObjects(object oAssociate);
// Sets associate count for the PC.
void SetAssociateCount(object oPC, int nCount);
// Sets whether the master can speak through the associate using the -associate
// command. Does not work on animal companions or familiars (for which this value
// always returns TRUE).
void SetCanMasterSpeakThroughAssociate(object oAssociate, int bCanSpeak = TRUE);
// Sets the currently controlled associate(s) for the player.
void SetControlledAssociate(object oAssociate, object oPC = OBJECT_SELF);
// Enables or disables the associate's AI.
void SetIsAssociateAIEnabled(object oAssociate, int bAIEnabled);
// Updates associate AI. Selected associates will have AI enabled, others will have AI disabled.
void UpdateAssociateAISettings(object oPC);

/**********************************************************************
 * PRIVATE FUNCTION PROTOTYPES
 **********************************************************************/

/* Commands the associate to attack the designated target. */
void AssociateCommandAttack(object oAssociate);
/* Commands the associate to enable its AI. */
void AssociateCommandAIActivate(object oAssociate);
/* Commands the associate to disable its AI. */
void AssociateCommandAIDeactivate(object oAssociate);
/* Commands the associate to follow the designated target. */
void AssociateCommandForceFollowObject(object oAssociate);
/* Commands the associate to interact with the designated door: disarm traps, open locks, open/close,
   or bash it if none of the above applies. */
void AssociateCommandInteractDoor(object oAssociate);
/* Commands the associate to interact with the designated placeable: disarm traps, open locks,
   or bash it if neither of the above applies. */
void AssociateCommandInteractPlaceable (object oAssociate);
/* Commands the associate to move to the designated location. */
void AssociateCommandMove(object oAssociate);
/* Commands the associate to execute the specified command. */
void ExecuteAssociateCommand(object oAssociate, int nAssociateCommand);
/* Returns the object that the associate has been assigned to follow. */
object GetAssociateForceFollowObject(object oAssociate);
/* Returns the name of the controlled associate, or the string "all associates" if
   oAssociate is the associate controller. */
string GetControlledAssociateName(object oAssociate);
/* Returns TRUE if oFollow is a valid object for the associate to follow. */
int GetIsForceFollowObjectValid(object oAssociate, object oFollow);
/* Returns the last command assigned to the associate. */
int GetLastAssociateAction(object oAssociate);
/* Sets the associate's current attack target. If AI is disabled, the associate will only attack the designated target. */
void SetAssociateAttackTarget(object oAssociate, object oTarget);
/* Sets the object that the associate is assigned to follow. */
void SetAssociateForceFollowObject(object oAssociate, object oFollow);
/* Stores the given action as the last command assigned to the associate. */
void SetLastAssociateAction(object oAssociate, int nCommand = ASSOCIATE_COMMAND_INVALID);

/**********************************************************************
 * PUBLIC FUNCTION DEFINITIONS
 **********************************************************************/

//::///////////////////////////////////////////////
//:: AssociateForceFollow
//:://////////////////////////////////////////////
/*
    Commands the associate to follow its current
    force follow target.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 13, 2016
//:://////////////////////////////////////////////
void AssociateForceFollow(object oAssociate = OBJECT_SELF, float fFollowDistance = ASSOCIATE_FOLLOW_DISTANCE)
{
    object oMaster = GetMaster(oAssociate);
    object oFollow = GetAssociateForceFollowObject(oAssociate);

    if(!GetIsForceFollowObjectValid(oAssociate, oFollow))
    {
        oFollow = oMaster;
        if(GetArea(oAssociate) != GetArea(oFollow))
        {
            AssignCommand(oAssociate, JumpToObject(oFollow));
        }
    }
    if(fFollowDistance == ASSOCIATE_FOLLOW_DISTANCE)
    {
        if(GetAssociateState(NW_ASC_DISTANCE_2_METERS, oAssociate))
        {
            fFollowDistance = 2.0;
        }
        else if(GetAssociateState(NW_ASC_DISTANCE_4_METERS, oAssociate))
        {
            fFollowDistance = 4.0;
        }
        else if(GetAssociateState(NW_ASC_DISTANCE_6_METERS, oAssociate))
        {
            fFollowDistance = 6.0;
        }
        else
        {
            fFollowDistance = ASSOCIATE_DEFAULT_FOLLOW_DISTANCE;
        }
    }

    AssignCommand(oAssociate, ClearAllActions());
    AssignCommand(oAssociate, ActionForceFollowObject(oFollow, fFollowDistance));
}

//::///////////////////////////////////////////////
//:: DecrementAssociateCount
//:://////////////////////////////////////////////
/*
    Decrements associate count for the PC.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 18, 2016
//:://////////////////////////////////////////////
void DecrementAssociateCount(object oPC)
{
    int nCount = GetAssociateCount(oPC);

    // This should never happen, but just in case...
    if(nCount == 0)
        return;

    SetLocalInt(oPC, LIB_PREFIX_ASSOCIATES + "AssociateCount", nCount - 1);
}

//::///////////////////////////////////////////////
//:: DetermineAssociateCommand
//:://////////////////////////////////////////////
/*
    Determines and returns the type of associate
    command to execute based on player tool
    selection.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 13, 2016
//:://////////////////////////////////////////////
int DetermineAssociateCommand(object oPC = OBJECT_SELF)
{
    object oAssociate = GetControlledAssociate(oPC);
    object oTarget = GetSpellTargetObject();

    if(!GetIsObjectValid(oAssociate))
        return ASSOCIATE_COMMAND_INVALID;

    if(GetIsObjectValid(oTarget))
    {
        switch(GetObjectType(oTarget))
        {
            case OBJECT_TYPE_CREATURE:
                if(GetIsEnemy(oTarget, oPC))
                    return ASSOCIATE_COMMAND_ATTACK;
                else if(GetIsPartyMember(oPC, oTarget))
                    return ASSOCIATE_COMMAND_FORCE_FOLLOW;
                return ASSOCIATE_COMMAND_INVALID;
            case OBJECT_TYPE_DOOR:
                return ASSOCIATE_COMMAND_INTERACT_DOOR;
            case OBJECT_TYPE_PLACEABLE:
                return ASSOCIATE_COMMAND_INTERACT_PLACEABLE;
        }
    }
    return ASSOCIATE_COMMAND_MOVE;
}

//::///////////////////////////////////////////////
//:: GetAssociateAttackTarget
//:://////////////////////////////////////////////
/*
    Returns the associate's designated attack
    target.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 13, 2016
//:://////////////////////////////////////////////
object GetAssociateAttackTarget(object oAssociate = OBJECT_SELF)
{
    return GetLocalObject(oAssociate, LIB_PREFIX_ASSOCIATES + "AttackTarget");
}

//::///////////////////////////////////////////////
//:: GetAssociateController
//:://////////////////////////////////////////////
/*
    Returns the associate controller of
    oAssociate. Differs from GetMaster() in that
    it handles nested associates. Returns
    OBJECT_INVALID if no controller exists.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 13, 2016
//:://////////////////////////////////////////////
object GetAssociateController(object oAssociate)
{
    object oMaster = GetMaster(oAssociate);

    while(GetIsObjectValid(GetMaster(oMaster)))
    {
        oMaster = GetMaster(oMaster);
    }

    return oMaster;
}

//::///////////////////////////////////////////////
//:: GetAssociateCount
//:://////////////////////////////////////////////
/*
    Returns the number of associates belonging
    to the PC.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 13, 2016
//:://////////////////////////////////////////////
int GetAssociateCount(object oPC)
{
    return GetLocalInt(oPC, LIB_PREFIX_ASSOCIATES + "AssociateCount");
}

//::///////////////////////////////////////////////
//:: GetCanDisarm
//:://////////////////////////////////////////////
/*
    Returns TRUE if the creature can disarm
    the specified object.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 13, 2016
//:://////////////////////////////////////////////
int GetCanDisarm(object oCreature, object oTrappedObject)
{
    // * The trap can be disarmed
    // * The trap has been detected by the creature or its master
    // * The creature has the disable trap skill
    // * The creature is a rogue if the trap DC is greater than 35
    // * The creature can disarm the trap on a take 20

    return GetTrapDisarmable(oTrappedObject)
        && (GetTrapDetectedBy(oTrappedObject, oCreature) || GetTrapDetectedBy(oTrappedObject, GetAssociateController(oCreature)))
        && GetSkillRank(SKILL_DISABLE_TRAP, oCreature)
        && !(GetTrapDisarmDC(oTrappedObject) > 35 && !GetLevelByClass(CLASS_TYPE_ROGUE, oCreature))
        && GetSkillRank(SKILL_DISABLE_TRAP, oCreature) + 20 >= GetTrapDisarmDC(oTrappedObject);
}

//::///////////////////////////////////////////////
//:: GetCanMasterSpeakThroughAssociate
//:://////////////////////////////////////////////
/*
    Returns TRUE if the associate's master can
    speak through it using the -associate command
    (i.e. it is an animal companion, familiar, or
    has been flagged with the
    SetCanMasterSpeakThroughAssociate() function).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 3, 2016
//:://////////////////////////////////////////////
int GetCanMasterSpeakThroughAssociate(object oAssociate)
{
    return GetAssociateType(oAssociate) == ASSOCIATE_TYPE_FAMILIAR ||
        GetAssociateType(oAssociate) == ASSOCIATE_TYPE_ANIMALCOMPANION ||
        GetAssociateType(oAssociate) == ASSOCIATE_TYPE_DOMINATED ||
        GetLocalInt(oAssociate, LIB_PREFIX_ASSOCIATES + "SpeakingAssociate");
}

//::///////////////////////////////////////////////
//:: GetCanUnlock
//:://////////////////////////////////////////////
/*
    Returns TRUE if the creature can unlock
    the specified object.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 13, 2016
//:://////////////////////////////////////////////
int GetCanUnlock(object oCreature, object oObject)
{
    // * The object can be unlocked
    // * The creature possesses the open lock skill
    // * The creature can unlock the object on a take 20
    return !GetLockKeyRequired(oObject)
        && GetSkillRank(SKILL_OPEN_LOCK, oCreature)
        && (GetSkillRank(SKILL_OPEN_LOCK, oCreature) + 20 >= GetLockUnlockDC(oObject));
}

//::///////////////////////////////////////////////
//:: GetControlledAssociate
//:://////////////////////////////////////////////
/*
    Returns the associate(s) that the PC is
    currently controlling.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 13, 2016
//:://////////////////////////////////////////////
object GetControlledAssociate(object oPC = OBJECT_SELF)
{
    return GetLocalObject(oPC, LIB_PREFIX_ASSOCIATES + "ControlObject");
}

//::///////////////////////////////////////////////
//:: GetDistanceToFollowObject
//:://////////////////////////////////////////////
/*
    Returns distance between the associate
    and the object it is following.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 13, 2016
//:://////////////////////////////////////////////
float GetDistanceToFollowObject(object oAssociate = OBJECT_SELF)
{
    object oFollow = GetAssociateForceFollowObject(oAssociate);

    if(!GetIsForceFollowObjectValid(oAssociate, oFollow))
        oFollow = GetMaster(oAssociate);

    return GetDistanceBetween(oAssociate, oFollow);
}

//::///////////////////////////////////////////////
//:: GetIsAssociate
//:://////////////////////////////////////////////
/*
    Returns TRUE if the creature is an associate
    of any kind.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 13, 2016
//:://////////////////////////////////////////////
int GetIsAssociate(object oCreature)
{
    return (GetAssociateType(oCreature) != ASSOCIATE_TYPE_NONE);
}

//::///////////////////////////////////////////////
//:: GetIsAssociateAIEnabled
//:://////////////////////////////////////////////
/*
    Returns TRUE if the associate's AI is
    enabled.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 13, 2016
//:://////////////////////////////////////////////
int GetIsAssociateAIEnabled(object oAssociate = OBJECT_SELF)
{
    if(!GetIsAssociate(oAssociate) || !GetIsPC(GetAssociateController(oAssociate)))
        return TRUE;
    return !GetLocalInt(oAssociate, LIB_PREFIX_ASSOCIATES + "AIDeactivated");

}

//::///////////////////////////////////////////////
//:: GetIsAssociateAttackTargetInvalid
//:://////////////////////////////////////////////
/*
    Returns TRUE if the associate attack target is invalid.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 13, 2016
//:://////////////////////////////////////////////
int GetIsAssociateAttackTargetInvalid(object oAssociate = OBJECT_SELF)
{
    return GetLastAssociateAction(OBJECT_SELF) == ASSOCIATE_COMMAND_ATTACK && (!GetIsObjectValid(GetAssociateAttackTarget()) || GetIsDead(GetAssociateAttackTarget()));
}

//::///////////////////////////////////////////////
//:: GetIsControllableAssociate
//:://////////////////////////////////////////////
/*
    Returns TRUE if the target can be selected
    as an associate to control.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 13, 2016
//:://////////////////////////////////////////////
int GetIsControllableAssociate(object oAssociate, object oPC = OBJECT_SELF)
{
    // check for manual overrides (i.e. lassoed associates)
    if (GetLocalInt(oAssociate, LIB_PREFIX_ASSOCIATES + "AssociateControlDisabled") == 1) {
      return FALSE;
    } else {
      return oAssociate == oPC || GetAssociateController(oAssociate) == oPC;
    }
}

//::///////////////////////////////////////////////
//:: GetIsPartyMember
//:://////////////////////////////////////////////
/*
    Returns TRUE if the PC is in a party with
    oMember.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 14, 2016
//:://////////////////////////////////////////////
int GetIsPartyMember(object oPC, object oMember)
{
    if(!GetIsPC(oPC) || GetIsDM(oPC) || GetIsDM(oMember))
        return FALSE;

    return GetFactionLeader(oPC) == GetFactionLeader(oMember);
}

//::///////////////////////////////////////////////
//:: GetSpeakingAssociate
//:://////////////////////////////////////////////
/*
    Returns the first associate through which
    the PC can speak using the -associate command.
    If a speaking associate is selected, that
    one will be returned instead.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 3, 2017
//:://////////////////////////////////////////////
object GetSpeakingAssociate(object oPC)
{
    int i, j;

    if(GetCanMasterSpeakThroughAssociate(GetControlledAssociate(oPC)))
    {
        return GetControlledAssociate(oPC);
    }

    for(i = ASSOCIATE_TYPE_HENCHMAN; i < ASSOCIATE_TYPE_DOMINATED; i++)
    {
        while(GetIsObjectValid(GetAssociate(i, oPC, ++j)))
        {
            if(GetCanMasterSpeakThroughAssociate(GetAssociate(i, oPC, j)))
            {
                return GetAssociate(i, oPC, j);
            }
        }
        j = 0;
    }
    if(GetCanMasterSpeakThroughAssociate(GetAssociate(ASSOCIATE_TYPE_DOMINATED, oPC)))
    {
        return GetAssociate(ASSOCIATE_TYPE_DOMINATED, oPC);
    }
    return OBJECT_INVALID;
}

//::///////////////////////////////////////////////
//:: GetSpeakingAssociateCount
//:://////////////////////////////////////////////
/*
    Returns the number of associates through
    which the PC can speak using the -associate
    command.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 3, 2016
//:://////////////////////////////////////////////
int GetSpeakingAssociateCount(object oPC)
{
    int nCount;

    int i, j;

    for(i = ASSOCIATE_TYPE_HENCHMAN; i < ASSOCIATE_TYPE_DOMINATED; i++)
    {
        while(GetIsObjectValid(GetAssociate(i, oPC, ++j)))
        {
            if(GetCanMasterSpeakThroughAssociate(GetAssociate(i, oPC, j)))
            {
                nCount++;
            }
        }
        j = 0;
    }
    if(GetCanMasterSpeakThroughAssociate(GetAssociate(ASSOCIATE_TYPE_DOMINATED, oPC)))
    {
        nCount ++;
    }
    return nCount;
}

//::///////////////////////////////////////////////
//:: GrantAssociateCommand
//:://////////////////////////////////////////////
/*
    Grants the associate command feat to
    the PC.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 13, 2016
//:://////////////////////////////////////////////
void GrantAssociateCommand(object oPC)
{
    if(!GetIsPC(oPC) || GetIsDM(oPC))
        return;
    if(!GetHasFeat(FEAT_ASSOCIATE_COMMAND, oPC))
    {
        AddKnownFeat(oPC, FEAT_ASSOCIATE_COMMAND);
        SendMessageToPC(oPC, ASSOCIATE_COMMAND_GRANTED);
    }
}

//::///////////////////////////////////////////////
//:: IncrementAssociateCount
//:://////////////////////////////////////////////
/*
    Increments associate count for the PC.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 18, 2016
//:://////////////////////////////////////////////
void IncrementAssociateCount(object oPC)
{
    SetLocalInt(oPC, LIB_PREFIX_ASSOCIATES + "AssociateCount", GetAssociateCount(oPC) + 1);
}

//::///////////////////////////////////////////////
//:: IssueAssociateCommands
//:://////////////////////////////////////////////
/*
    Issues the specified command to all
    selected associates.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 13, 2016
//:://////////////////////////////////////////////
void IssueAssociateCommands(object oAssociate, int nAssociateCommand, object oPC = OBJECT_SELF)
{
    int i;
    int j = 0;

    if(!GetIsObjectValid(oAssociate))
        return;
    if(nAssociateCommand == ASSOCIATE_COMMAND_INVALID)
    {
        SendMessageToPC(oPC, ERROR_INVALID_COMMAND);
        return;
    }

    if(oAssociate != oPC)
    {
        if(GetAssociateController(oAssociate) == oPC)
        {
            ExecuteAssociateCommand(oAssociate, nAssociateCommand);
        }
    }
    else
    {
        for(i = ASSOCIATE_TYPE_HENCHMAN; i <= ASSOCIATE_TYPE_DOMINATED; i++)
        {
            while(GetIsObjectValid(GetAssociate(i, oPC, ++j)))
            {
                ExecuteAssociateCommand(GetAssociate(i, oPC, j), nAssociateCommand);
                // Fix for GetAssociate() ignoring nth parameter with dominated associates.
                if(i == ASSOCIATE_TYPE_DOMINATED)
                    break;
            }
            j = 0;
        }
    }
}

//::///////////////////////////////////////////////
//:: RemoveAssociateCommand
//:://////////////////////////////////////////////
/*
    Removes the associate command feat from
    the PC.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 13, 2016
//:://////////////////////////////////////////////
void RemoveAssociateCommand(object oPC)
{
    return; //remove this if we ever need to remove the command again
    if(!GetIsPC(oPC) || GetIsDM(oPC))
        return;
    if(GetHasFeat(FEAT_ASSOCIATE_COMMAND, oPC))
    {
        NWNX_Creature_RemoveFeat(oPC, FEAT_ASSOCIATE_COMMAND);
        SendMessageToPC(oPC, ASSOCIATE_COMMAND_REMOVED);
    }
}

//::///////////////////////////////////////////////
//:: RemoveInvalidForceFollowObjects
//:://////////////////////////////////////////////
/*
    Removes force follow objects that are no
    longer valid from the associate.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 15, 2016
//:://////////////////////////////////////////////
void RemoveInvalidForceFollowObjects(object oAssociate)
{
    object oFollow = GetAssociateForceFollowObject(oAssociate);

    if(!GetIsForceFollowObjectValid(oAssociate, oFollow))
        SetAssociateForceFollowObject(oAssociate, OBJECT_INVALID);
}

//::///////////////////////////////////////////////
//:: SetCanMasterSpeakThroughAssociate
//:://////////////////////////////////////////////
/*
    Sets whether the master can speak through
    the associate using the -associate command.
    Does not work on animal companions or
    familiars (for which this value always returns
    TRUE).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 3, 2016
//:://////////////////////////////////////////////
void SetCanMasterSpeakThroughAssociate(object oAssociate, int bCanSpeak = TRUE)
{
    SetLocalInt(oAssociate, LIB_PREFIX_ASSOCIATES + "SpeakingAssociate", bCanSpeak);
}

//::///////////////////////////////////////////////
//:: SetAssociateCount
//:://////////////////////////////////////////////
/*
    Sets associate count for the PC.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 18, 2016
//:://////////////////////////////////////////////
void SetAssociateCount(object oPC, int nCount)
{
    SetLocalInt(oPC, LIB_PREFIX_ASSOCIATES + "AssociateCount", nCount);
}

//::///////////////////////////////////////////////
//:: SetControlledAssociate
//:://////////////////////////////////////////////
/*
    Sets the currently controlled associate(s)
    for the player.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 13, 2016
//:://////////////////////////////////////////////
void SetControlledAssociate(object oAssociate, object oPC = OBJECT_SELF)
{
    object oCurrentAssociate = GetControlledAssociate(oPC);
    string sAssociateMessage;
    string sAssociateName = GetControlledAssociateName(oAssociate);

    if(oCurrentAssociate == oAssociate)
    {
        sAssociateMessage = "You are no longer controlling " + sAssociateName + ".";
        oAssociate = OBJECT_INVALID;
    }
    else
    {
        sAssociateMessage = "You are now controlling " + sAssociateName + ".";
    }
    SendMessageToPC(oPC, sAssociateMessage);
    SetLocalObject(oPC, LIB_PREFIX_ASSOCIATES + "ControlObject", oAssociate);
    UpdateAssociateAISettings(oPC);
}

//::///////////////////////////////////////////////
//:: SetIsAssociateAIEnabled
//:://////////////////////////////////////////////
/*
    Enables or disables the associate's AI.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 13, 2016
//:://////////////////////////////////////////////
void SetIsAssociateAIEnabled(object oAssociate, int bAIEnabled)
{
    SetLocalInt(oAssociate, LIB_PREFIX_ASSOCIATES + "AIDeactivated", !bAIEnabled);
    if(bAIEnabled)
        AssignCommand(oAssociate, ClearAllActions());
}

//::///////////////////////////////////////////////
//:: UpdateAssociateAISettings
//:://////////////////////////////////////////////
/*
    Updates associate AI. Selected associates
    will have AI enabled, others will have
    AI disabled.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 13, 2016
//:://////////////////////////////////////////////
void UpdateAssociateAISettings(object oPC)
{
    IssueAssociateCommands(oPC, ASSOCIATE_COMMAND_AI_ACTIVATE, oPC);
    IssueAssociateCommands(GetControlledAssociate(oPC), ASSOCIATE_COMMAND_AI_DEACTIVATE, oPC);
}

/**********************************************************************
 * PRIVATE FUNCTION DEFINITIONS
 **********************************************************************/

//::///////////////////////////////////////////////
//:: AssociateCommandAttack
//:://////////////////////////////////////////////
/*
    Commands the associate to attack the designated
    target.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 13, 2016
//:://////////////////////////////////////////////
void AssociateCommandAttack(object oAssociate)
{
    object oTarget = GetSpellTargetObject();

    SetAssociateState(NW_ASC_IS_BUSY, FALSE, oAssociate);
    SetAssociateAttackTarget(oAssociate, oTarget);
    AssignCommand(oAssociate, ClearAllActions());
    AssignCommand(oAssociate, DetermineCombatRound(oTarget));
}

//::///////////////////////////////////////////////
//:: AssociateCommandAIActivate
//:://////////////////////////////////////////////
/*
    Commands the associate to enable its AI.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 13, 2016
//:://////////////////////////////////////////////
void AssociateCommandAIActivate(object oAssociate)
{
    SetIsAssociateAIEnabled(oAssociate, TRUE);
}

//::///////////////////////////////////////////////
//:: AssociateCommandAIDeactivate
//:://////////////////////////////////////////////
/*
    Commands the associate to disable its AI.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 13, 2016
//:://////////////////////////////////////////////
void AssociateCommandAIDeactivate(object oAssociate)
{
    SetIsAssociateAIEnabled(oAssociate, FALSE);
}

//::///////////////////////////////////////////////
//:: AssociateCommandForceFollowObject
//:://////////////////////////////////////////////
/*
    Commands the associate to follow the
    designated target.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 14, 2016
//:://////////////////////////////////////////////
void AssociateCommandForceFollowObject(object oAssociate)
{
    object oController = GetAssociateController(oAssociate);
    object oTarget = GetSpellTargetObject();

    if(GetArea(oTarget) != GetArea(oController))
    {
        SendMessageToPC(oController, ERROR_INVALID_FOLLOW_TARGET);
        return;
    }

    SetAssociateForceFollowObject(oAssociate, oTarget);
    AssociateForceFollow(oAssociate);
}

//::///////////////////////////////////////////////
//:: AssociateCommandInteractDoor
//:://////////////////////////////////////////////
/*
    Commands the associate to interact with
    the designated door: disarm traps, open locks,
    open/close, or bash it if none of the above
    applies.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 13, 2016
//:://////////////////////////////////////////////
void AssociateCommandInteractDoor(object oAssociate)
{
    object oTarget = GetSpellTargetObject();

    AssignCommand(oAssociate, ClearAllActions());

    if(GetIsTrapped(oTarget) && GetCanDisarm(oAssociate, oTarget))
        AssignCommand(oAssociate, ActionUseSkill(SKILL_DISABLE_TRAP, oTarget));
    else if(GetLocked(oTarget))
    {
        if(GetCanUnlock(oAssociate, oTarget))
            AssignCommand(oAssociate, ActionUnlockObject(oTarget));
        else
            AssignCommand(oAssociate, ActionAttack(oTarget));
    }
    else if(GetIsOpen(oTarget))
        AssignCommand(oAssociate, ActionCloseDoor(oTarget));
    else
        AssignCommand(oAssociate, ActionOpenDoor(oTarget));
}

//::///////////////////////////////////////////////
//:: AssociateCommandInteractPlaceable
//:://////////////////////////////////////////////
/*
    Commands the associate to interact with
    the designated placeable: disarm traps,
    open locks, or bash it if neighter of
    the above applies.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 13, 2016
//:://////////////////////////////////////////////
void AssociateCommandInteractPlaceable(object oAssociate)
{
    object oTarget = GetSpellTargetObject();

    AssignCommand(oAssociate, ClearAllActions());

    if(GetIsTrapped(oTarget) && GetCanDisarm(oAssociate, oTarget))
        AssignCommand(oAssociate, ActionUseSkill(SKILL_DISABLE_TRAP, oTarget));
    else if(GetLocked(oTarget) && GetCanUnlock(oAssociate, oTarget))
        AssignCommand(oAssociate, ActionUnlockObject(oTarget));
    else
        AssignCommand(oAssociate, ActionAttack(oTarget));
}

//::///////////////////////////////////////////////
//:: AssociateCommandMove
//:://////////////////////////////////////////////
/*
    Commands the associate to move to the designated
    location.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 13, 2016
//:://////////////////////////////////////////////
void AssociateCommandMove(object oAssociate)
{
    location lTarget = GetSpellTargetLocation();

    AssignCommand(oAssociate, ClearAllActions());
    AssignCommand(oAssociate, ActionMoveToLocation(lTarget, TRUE));
}

//::///////////////////////////////////////////////
//:: ExecuteAssociateCommand
//:://////////////////////////////////////////////
/*
    Commands the associate to execute the
    specified command.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 13, 2016
//:://////////////////////////////////////////////
void ExecuteAssociateCommand(object oAssociate, int nAssociateCommand)
{
    SetAssociateAttackTarget(oAssociate, OBJECT_INVALID);

    if (nAssociateCommand != ASSOCIATE_COMMAND_AI_ACTIVATE &&
        nAssociateCommand != ASSOCIATE_COMMAND_AI_DEACTIVATE)
    {
        SetAssociateForceFollowObject(oAssociate, OBJECT_INVALID);
    }

    switch(nAssociateCommand)
    {
        case ASSOCIATE_COMMAND_ATTACK:
            AssociateCommandAttack(oAssociate);
            break;
        case ASSOCIATE_COMMAND_MOVE:
            AssociateCommandMove(oAssociate);
            break;
        case ASSOCIATE_COMMAND_INTERACT_DOOR:
            AssociateCommandInteractDoor(oAssociate);
            break;
        case ASSOCIATE_COMMAND_INTERACT_PLACEABLE:
            AssociateCommandInteractPlaceable(oAssociate);
            break;
        case ASSOCIATE_COMMAND_AI_ACTIVATE:
            AssociateCommandAIActivate(oAssociate);
            break;
        case ASSOCIATE_COMMAND_AI_DEACTIVATE:
            AssociateCommandAIDeactivate(oAssociate);
            break;
        case ASSOCIATE_COMMAND_FORCE_FOLLOW:
            AssociateCommandForceFollowObject(oAssociate);
            break;
    }
    SetLastAssociateAction(oAssociate, nAssociateCommand);
}

//::///////////////////////////////////////////////
//:: GetAssociateForceFollowObject
//:://////////////////////////////////////////////
/*
    Returns the object that the associate has
    been assigned to follow.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 14, 2016
//:://////////////////////////////////////////////
object GetAssociateForceFollowObject(object oAssociate)
{
    return GetLocalObject(oAssociate, LIB_PREFIX_ASSOCIATES + "ForceFollowObject");
}

//::///////////////////////////////////////////////
//:: GetControlledAssociateName
//:://////////////////////////////////////////////
/*
    Returns the name of the controlled associate,
    or the string "all associates" if oAssociate
    is a PC.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 13, 2016
//:://////////////////////////////////////////////
string GetControlledAssociateName(object oAssociate)
{
    return (GetIsPC(oAssociate)) ? "all associates" : GetName(oAssociate);
}

//::///////////////////////////////////////////////
//:: GetIsForceFollowObjectValid
//:://////////////////////////////////////////////
/*
    Returns TRUE if oFollow is a valid object
    for the associate to follow.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 15, 2016
//:://////////////////////////////////////////////
int GetIsForceFollowObjectValid(object oAssociate, object oFollow)
{
    object oController = GetAssociateController(oAssociate);

    return(GetIsObjectValid(oController) && GetIsObjectValid(oFollow) && GetIsPartyMember(oController, oFollow) && GetArea(oController) == GetArea(oFollow));
}

//::///////////////////////////////////////////////
//:: GetLastAssociateAction
//:://////////////////////////////////////////////
/*
    Returns the last command assigned to the
    associate.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 14, 2016
//:://////////////////////////////////////////////
int GetLastAssociateAction(object oAssociate)
{
    return GetLocalInt(oAssociate, LIB_PREFIX_ASSOCIATES + "LastAction");
}

//::///////////////////////////////////////////////
//:: SetAssociateAttackTarget
//:://////////////////////////////////////////////
/*
    Sets the associate's current attack target.
    If AI is disabled, the associate will only
    attack the designated target.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 13, 2016
//:://////////////////////////////////////////////
void SetAssociateAttackTarget(object oAssociate, object oTarget)
{
    SetLocalObject(oAssociate, LIB_PREFIX_ASSOCIATES + "AttackTarget", oTarget);
}

//::///////////////////////////////////////////////
//:: SetAssociateForceFollowObject
//:://////////////////////////////////////////////
/*
    Sets the object that the associate is
    assigned to follow.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 14, 2016
//:://////////////////////////////////////////////
void SetAssociateForceFollowObject(object oAssociate, object oFollow)
{
    SetLocalObject(oAssociate, LIB_PREFIX_ASSOCIATES + "ForceFollowObject", oFollow);
}

//::///////////////////////////////////////////////
//:: SetLastAssociateAction
//:://////////////////////////////////////////////
/*
    Stores the given action as the last
    command assigned to the associate.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 14, 2016
//:://////////////////////////////////////////////
void SetLastAssociateAction(object oAssociate, int nAction = ASSOCIATE_COMMAND_INVALID)
{
    SetLocalInt(oAssociate, LIB_PREFIX_ASSOCIATES + "LastAction", nAction);
}
