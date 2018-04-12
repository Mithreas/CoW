#include "inc_common"
#include "inc_text"

void main()
{
    object oEntering = GetEnteringObject();
    object oTarget   = gsCMGetObject(GetTag(OBJECT_SELF));

    if (GetIsObjectValid(oTarget))
    {
        if (GetIsPC(oEntering))
            AssignCommand(oEntering, JumpToLocation(GetLocation(oTarget)));
        return;
    }

    SendMessageToPC(oEntering, GS_T_16777421);
}
