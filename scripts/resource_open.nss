/*
  Opens or closes a gate if the user is of the correct faction (the ones that
  owns this resource point).
  Gate can be specified with "GATE_TAG" variable on this placeable. If not
  specified, the nearest gate will be used.
*/
#include "mi_resourcecomm"
void main()
{
  object oPC = GetLastUsedBy();
  if (!GetIsPC(oPC)) return;
  string sGateTag = GetLocalString(OBJECT_SELF, "GATE_TAG");
  object oGate;

  if (GetPCFactionOwnsArea(oPC, GetArea(OBJECT_SELF)))
  {
    if (sGateTag == "")
    {
      oGate = GetNearestObject(OBJECT_TYPE_DOOR);
    }
    else
    {
      oGate = GetNearestObjectByTag(sGateTag);
    }

    if (GetLocked(oGate))
    {
      // unlock and open
      /*DoDoorAction(oGate, DOOR_ACTION_UNLOCK);
      DelayCommand(0.1, DoDoorAction(oGate, DOOR_ACTION_OPEN));*/
      AssignCommand(oGate, SetLocked(oGate, FALSE));
      AssignCommand(oGate, ActionOpenDoor(oGate));
    }
    else
    {
      // lock and close
      AssignCommand(oGate, ActionCloseDoor(oGate));
      AssignCommand(oGate, SetLocked(oGate, TRUE));
    }
  }
  else
  {
    SendMessageToPC(oPC, "Your faction doesn't own this area.");
  }
}
