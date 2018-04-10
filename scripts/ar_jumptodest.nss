void main()
{
  string sDestWP = GetLocalString(OBJECT_SELF, "MI_DEST");

  if (sDestWP != "")
  {
    AssignCommand(GetPCSpeaker(), ActionJumpToObject(GetWaypointByTag(sDestWP)));
  }
}
