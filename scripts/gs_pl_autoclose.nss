void main()
{
  DelayCommand(30.0f,ActionCloseDoor(OBJECT_SELF));
  DelayCommand(30.5f,SetLocked(OBJECT_SELF,TRUE));
}
