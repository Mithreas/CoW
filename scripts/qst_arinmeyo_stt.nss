void main()
{
  SetLocalInt(OBJECT_SELF, "in_progress", 1);
  DelayCommand(450.0, SetLocalInt(OBJECT_SELF, "in_progress", 2));
}
