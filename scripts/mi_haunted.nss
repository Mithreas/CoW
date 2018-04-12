const int TRIGGER_COOLDOWN = 360; // 6 minutes

// Haunt script by Mith
#include "inc_encounter"
#include "inc_timelock"
void main()
{
  object oEntering = GetEnteringObject();

  if (d6() < 6 || !GetIsPC(oEntering) || GetIsDM(oEntering) || GetModuleTime() < GetLocalInt(OBJECT_SELF, "MI_TRIGGERED_GHOST")) return;

  SetLocalInt(OBJECT_SELF, "MI_TRIGGERED_GHOST", GetModuleTime() + TRIGGER_COOLDOWN);

  string sText;
  switch (d6())
  {
    case 1:
      sText = "*Suddenly, the air seems very cold*";
      break;
    case 2:
      sText = "*You feel a sudden chill in the air*";
      break;
    case 3:
      sText = "*The shadows move around you*";
      break;
    case 4:
      sText = "*You catch a glimpse of movement out of the corner of your eye*";
      break;
    case 5:
      sText = "*A sudden draft gusts through the area*";
      break;
    case 6:
      sText = "*The mist coalesces into a humanoid form*";
      break;
  }

  FloatingTextStringOnCreature(sText, oEntering, FALSE);

  object oGhost = CreateObject(OBJECT_TYPE_CREATURE,
                               "door_ghost",
                               GetLocation(OBJECT_SELF),
                               TRUE);
  gsFLSetFlag(GS_FL_ENCOUNTER, oGhost);

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

  AssignCommand(oGhost, ActionSpeakString(sText));
}

