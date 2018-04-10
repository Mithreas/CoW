// Used for doors that open to a passphrase.
// Put this script on the listen event of an NPC, and give the PC the following
// variables:
//  - mi_passphrase - case sensitive string that, if contained in a PC's
//                    utterance, will open the door.
//  - mi_passdoor - tag of the door to open when the passphrase is spoken
// The standard AI script handles setting up the listen event.
void main()
{
  if (GetListenPatternNumber() != 166) return;

  object oSpeaker = GetLastSpeaker();
  //SpeakString("*The statue turns its head to look at " + GetName(oSpeaker) +
  // " for a moment, then gestures to the door.");

  object oDoor = GetObjectByTag(GetLocalString(OBJECT_SELF, "mi_passdoor"));

  if (GetIsObjectValid(oDoor))
  {
    AssignCommand(oDoor, SetLocked(oDoor, FALSE));
    AssignCommand(oDoor, ActionOpenDoor(oDoor));
    AssignCommand(oDoor, DelayCommand(30.0, ActionCloseDoor(oDoor)));
    AssignCommand(oDoor, DelayCommand(30.0, SetLocked(oDoor, TRUE)));
  }
}
