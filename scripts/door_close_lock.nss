void main()
{
DelayCommand(20.0, ActionCloseDoor(OBJECT_SELF));
DelayCommand(20.0, SetLocked(OBJECT_SELF, 1));
}
