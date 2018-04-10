#include "gs_inc_common"

void main()
{
    object oSpeaker    = GetPCSpeaker();
    object oTarget     = gsCMGetObject("GS_DOOR_001_01", OBJECT_TYPE_DOOR);
    float fFacing      = GetFacing(oTarget) + 180.0;
    location lLocation = Location(GetArea(oTarget),
                                  GetPosition(oTarget) + AngleToVector(fFacing),
                                  fFacing);

    AssignCommand(oTarget, ActionOpenDoor(oTarget));
    AssignCommand(oSpeaker, JumpToLocation(lLocation));
}
