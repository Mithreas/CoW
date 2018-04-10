void main()
{
  object oDoor = GetNearestObject(OBJECT_TYPE_DOOR);

  if (GetLocked(oDoor))
  {
    SetLocked (oDoor, FALSE);
    DelayCommand(0.5, AssignCommand(oDoor, ActionOpenDoor(oDoor)));
    ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
  }
  else
  {
    AssignCommand(oDoor, ActionCloseDoor(oDoor));
    DelayCommand(0.5, SetLocked(oDoor, TRUE));
    ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);
  }
}
