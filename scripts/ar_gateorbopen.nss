void main()
{
    object oGate = GetObjectByTag("AR_GateOrbG");

    SetLocked(oGate, FALSE);
    AssignCommand(oGate, ActionOpenDoor(oGate));
    DelayCommand(8.0, AssignCommand(oGate, ActionCloseDoor(oGate)));
}
