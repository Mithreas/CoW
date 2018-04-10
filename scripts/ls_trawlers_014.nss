
void main()
{

if (!GetIsPC(GetLastSpeaker())) return;


  int nLiner1 = GetLocalInt(OBJECT_SELF, "oneliner_tracking1");

  if (nLiner1 < 1)
  {
    AssignCommand(OBJECT_SELF, ActionSpeakString("What a daring thing to do!"));
    SetLocalInt(OBJECT_SELF, "oneliner_tracking1", 1);
    return;
  }
  else if (nLiner1 == 1)
  {
    AssignCommand(OBJECT_SELF, ActionSpeakString("It looks quite... exotic."));
    SetLocalInt(OBJECT_SELF, "oneliner_tracking1", 2);
    return;
  }
  else if (nLiner1 == 2)
  {
AssignCommand(OBJECT_SELF, ActionSpeakString("Won't you be prosecuted?"));
    SetLocalInt(OBJECT_SELF, "oneliner_tracking1", 0);
    return;
}
}
