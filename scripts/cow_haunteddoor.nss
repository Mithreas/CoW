// Haunted Door script, by Mith.
void CloseDoorIfOpen(object oDoor)
{
  if (GetIsOpen(oDoor))
  {
    AssignCommand(oDoor, ActionSpeakString("The door slams suddenly."));
    AssignCommand(oDoor, ActionCloseDoor(oDoor));
  }
}

void main()
{
  int nD6 = d6();

  switch(nD6)
  {
    case 1:
      SpeakString("The door slams in your face.");
      AssignCommand(OBJECT_SELF, ActionCloseDoor(OBJECT_SELF));
      break;
    case 2:
    {
      SpeakString("The door slams in your face, and you hear the faint click of a lock catching.");
      AssignCommand(OBJECT_SELF, ActionCloseDoor(OBJECT_SELF));
      SetLocked(OBJECT_SELF, TRUE);
      float fDelay = IntToFloat(d6(5));
      DelayCommand(fDelay, SpeakString("Click"));
      DelayCommand(fDelay, SetLocked(OBJECT_SELF, FALSE));
      break;
    }
    case 3:
      SpeakString("Crrrrrreeeeeeeaaaaaaak!");
      break;
    case 4:
      SpeakString("The door opens soundlessly.");
      break;
    case 5:
      SpeakString("Suddenly, the air seems very cold.");
      CreateObject(OBJECT_TYPE_CREATURE, "door_ghost", GetLocation(GetLastOpenedBy()), TRUE);
      break;
    case 6:
      // Nothing happens.
      break;
  }

  DelayCommand(30.0, CloseDoorIfOpen(OBJECT_SELF));
}
