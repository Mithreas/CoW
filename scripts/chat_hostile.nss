#include "inc_chatutils"
#include "inc_names"
#include "inc_fixture"
#include "inc_examine"

const string HELP = "-hostile [distance]. Hostiles all characters in the area up to specified distance in yards. If no distance specified, hostiles the entire area.";

void main()
{
    string params = chatGetParams(OBJECT_SELF);

    if (params == "?")
    {
        DisplayTextInExamineWindow("-hostile", HELP);
    }
    else
    {
        object target = chatGetTarget(OBJECT_SELF);

        if (GetIsObjectValid(target) && target != OBJECT_SELF)
        {
            SetPCDislike(OBJECT_SELF, target);
            SendMessageToPC(target, fbNAGetGlobalDynamicName(OBJECT_SELF) + " now dislikes you!");
        }
        else
        {
            int entireArea = (params == "" && !GetIsObjectValid(target));
            float distance = StringToFloat(params);

            object pc = GetFirstPC();
            while (GetIsObjectValid(pc))
            {
                if (pc != OBJECT_SELF && GetArea(pc) == GetArea(OBJECT_SELF))
                {
                    if (entireArea || GetDistanceBetween(OBJECT_SELF, pc) <= YardsToMeters(distance))
                    {
                        SetPCDislike(OBJECT_SELF, pc);
                        SendMessageToPC(pc, fbNAGetGlobalDynamicName(OBJECT_SELF) + " now dislikes you!");
                    }
                }

                pc = GetNextPC();
            }

            if (entireArea)
            {
                SendMessageToPC(OBJECT_SELF, "You hostiled all characters in your current area!");
            }
            else
            {
                SendMessageToPC(OBJECT_SELF, "You hostiled all characters within " + FloatToString(distance) + " yards!");
            }
        }
    }

    chatVerifyCommand(OBJECT_SELF);
}
