void main()
{
  if (d6() < 6) return;
  string sResref   = GetLocalString(OBJECT_SELF, "RESREF");
  if (sResref == "") sResref = "door_ghost";

  SpeakString("Suddenly, the air seems very cold.");
  object oGhost = CreateObject(OBJECT_TYPE_CREATURE,
                               sResref,
                               GetLocation(GetLastOpenedBy()),
                               TRUE);

  string sText;
  switch (d6())
  {
    case 1:
      sText = "Hssssss";
      break;
    case 2:
      sText = "Deathhhhhh";
      break;
    case 3:
      sText = "Your ssssoul is sssstrong, live one";
      break;
    case 4:
      sText = "Hate...";
      break;
    case 5:
      sText = "Life... it will be mine...";
      break;
    case 6:
      sText = "Join me in death...";
      break;
  }

  AssignCommand(oGhost, ActionSpeakString(sText, TALKVOLUME_WHISPER));
}
