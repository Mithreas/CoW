#include "inc_chatutils"
#include "inc_examine"
#include "inc_rename"

const string HELP = "-follow [name]. Follows the provided target if you are within 15 yards of them.";

void main()
{
    string params = chatGetParams(OBJECT_SELF);

    if (params == "?")
    {
        DisplayTextInExamineWindow("-follow", HELP);
    }
    else
    {
        object target = chatGetTarget(OBJECT_SELF);

        if (!GetIsObjectValid(target))
        {
            int paramLen = GetStringLength(params);

            object pc = GetFirstPC();
            while (GetIsObjectValid(pc))
            {
                // dunshine: use dynamic names instead:
                // if (GetStringLeft(GetName(pc), paramLen) == params)
                if (GetStringLeft(svGetPCNameOverride(pc), paramLen) == params)
                {
                    target = pc;
                    break;
                }

                pc = GetNextPC();
            }
        }

        if (!GetIsObjectValid(target))
        {
            SendMessageToPC(OBJECT_SELF, "Could not find character " + params + "!");
        }
        else if (GetArea(OBJECT_SELF) != GetArea(target))
        {
            SendMessageToPC(OBJECT_SELF, "Character " + svGetPCNameOverride(target) + " is in another area!");
        }
        else if (GetDistanceBetween(OBJECT_SELF, target) > YardsToMeters(15.0))
        {
            SendMessageToPC(OBJECT_SELF, "Character " + svGetPCNameOverride(target) + " is too far away!");
        }
        else if (!LineOfSightObject(OBJECT_SELF, target))
        {
            SendMessageToPC(OBJECT_SELF, "Character " + svGetPCNameOverride(target) + " isn't in your line of sight!");
        }
        else if (target == OBJECT_SELF)
        {
            SendMessageToPC(OBJECT_SELF, "You can't follow yourself, silly!");
        }
        else
        {
            ActionForceFollowObject(target, 5.0);
            SendMessageToPC(OBJECT_SELF, "You're now following " + svGetPCNameOverride(target) + "!");
        }
    }

    chatVerifyCommand(OBJECT_SELF);
}
