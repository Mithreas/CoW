#include "inc_chatutils"
#include "nwnx_reveal"
#include "inc_examine"

const string HELP = "-reveal Name\nReveals yourself to the named character if you are stealthed.";

void main()
{
    string params = chatGetParams(OBJECT_SELF);
    object target = chatGetTarget(OBJECT_SELF);

    if (params == "?")
    {
        DisplayTextInExamineWindow("-reveal", HELP);
    }
    else
    {
        if (!GetIsObjectValid(target))
        {
            object pc = GetFirstPC();
            int paramLen = GetStringLength(params);

            while (GetIsObjectValid(pc))
            {
                if (GetStringLeft(GetName(pc), paramLen) == params)
                {
                    target = pc;
                    break;
                }

                pc = GetNextPC();
            }
        }

        if (GetIsObjectValid(target))
        {
            if (GetArea(OBJECT_SELF) == GetArea(target))
            {
                NWNX_Reveal_RevealTo(OBJECT_SELF, target);
                SendMessageToPC(OBJECT_SELF, "You are now revealed to " + GetName(target) + ".");
            }
            else
            {
                SendMessageToPC(OBJECT_SELF, "Character " + GetName(target) + " is in another area!");
            }
        }
        else
        {
            SendMessageToPC(OBJECT_SELF, "Could not find character: " + params + ".");
        }
    }

    chatVerifyCommand(OBJECT_SELF);
}