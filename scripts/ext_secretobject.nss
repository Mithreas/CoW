//::///////////////////////////////////////////////
//:: On Exit: Secret Object
//:: ext_secretobject
//:://////////////////////////////////////////////
/*
    Handler for PCs exiting a secret object
    trigger. Resets the secret object's useable
    state and plot flag (if applicable).

    For further useage details, see commentary
    in ent_secretobject.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 16, 2016
//:://////////////////////////////////////////////

// Returns TRUE if a PC or a PC associate is within the area of the trigger.
int GetIsPCInTrigger();

//::///////////////////////////////////////////////
//:: main
//:://////////////////////////////////////////////
/*
    Main handler for secret object trigger exit
    routine.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 16, 2016
//:://////////////////////////////////////////////
void main()
{
    object oSecretObject = GetLocalObject(OBJECT_SELF, "SO_SecretObject");

    if(GetIsPCInTrigger() || !GetIsObjectValid(oSecretObject) || GetLocalInt(oSecretObject, "SO_NeverResetUseableFlag"))
        return;

    SetUseableFlag(oSecretObject, FALSE);
    if(GetLocalInt(oSecretObject, "SO_TogglePlotFlag"))
    {
        SetPlotFlag(oSecretObject, TRUE);
    }
}

//::///////////////////////////////////////////////
//:: GetIsPCInTrigger
//:://////////////////////////////////////////////
/*
    Returns TRUE if a PC or a PC associate is
    within the area of the trigger.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 16, 2016
//:://////////////////////////////////////////////
int GetIsPCInTrigger()
{
    object oPC = GetFirstInPersistentObject();

    while(GetIsObjectValid(oPC))
    {
        if((GetIsPC(oPC) && !GetIsDM(oPC)) || (GetIsPC(GetMaster(oPC)) && !GetIsDM(GetMaster(oPC))))
        {
            return TRUE;
        }
        oPC = GetNextInPersistentObject();
    }
    return FALSE;
}
