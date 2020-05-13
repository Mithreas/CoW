#include "inc_chatutils"
#include "inc_assassin"
#include "inc_examine"

const string HELP = "-assassinate [Target].  Activates the Assassination class ability, increasing damage against a specified target.  Can be sent directly via Tell.";

void main()
{
    string params = chatGetParams(OBJECT_SELF);

    if (params == "?")
    {
        DisplayTextInExamineWindow("-assassinate", HELP);
        chatVerifyCommand(OBJECT_SELF);
        return;
    }

    object oTarget = chatGetTarget(OBJECT_SELF);

    if (GetIsObjectValid(oTarget))
    {
        if (asCanAssassinate(OBJECT_SELF, oTarget))
            asApplyDamage(OBJECT_SELF, oTarget);
    }
    else
    {
        // Namecheck nearby creatures
        object oCreature = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF), TRUE);
        string sName;
        while(GetIsObjectValid(oCreature))
        {
            sName = GetStringLowerCase(svGetPCNameOverride(oCreature));
            if (FindSubString(GetStringLowerCase(params), sName) > -1) oTarget = oCreature;
            oCreature = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF), TRUE);
        }
        if (GetIsObjectValid(oTarget))
        {
            if (asCanAssassinate(OBJECT_SELF, oTarget)) asApplyDamage(OBJECT_SELF, oTarget);
        }
        else SendMessageToPC(OBJECT_SELF, "There are no visible targets nearby by the name of '" + params + "'.");
    }

    chatVerifyCommand(OBJECT_SELF);
}
