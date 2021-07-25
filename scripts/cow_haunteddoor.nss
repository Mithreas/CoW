// Haunted Door script, by Mith.
#include "inc_encounter"
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
  int nN = d10();
  object oDoor = OBJECT_SELF;

  switch(nN)
  {
    case 1:
      SpeakString("The door slams in your face.");
      AssignCommand(oDoor, ActionCloseDoor(OBJECT_SELF));
      break;
    case 2:
    {
      SpeakString("The door slams in your face, and you hear the faint click of a lock catching.");
      AssignCommand(oDoor, ActionCloseDoor(oDoor));
      SetLocked(oDoor, TRUE);
      float fDelay = IntToFloat(d6(5));
      DelayCommand(fDelay, SpeakString("Click"));
      DelayCommand(fDelay, SetLocked(oDoor, FALSE));
      break;
    }
    case 3:
      SpeakString("Crrrrrreeeeeeeaaaaaaak!");
      break;
    case 4:
      SpeakString("The door opens soundlessly.");
      break;
    case 5:
    {
      string sText;
      switch (d6())
      {
    case 1:
      sText = "Suddenly, the air seems very cold.";
      break;
    case 2:
      sText = "You feel a sudden chill in the air.";
      break;
    case 3:
      sText = "The shadows move around you.";
      break;
    case 4:
      sText = "You catch a glimpse of movement out of the corner of your eye.";
      break;
    case 5:
      sText = "What was that?";
      break;
    case 6:
      sText = "The mist coalesces into a humanoid form.";
      break;
      }

      SpeakString(sText);
      object oGhost = CreateObject(OBJECT_TYPE_CREATURE, "door_ghost", GetLocation(oDoor), TRUE);
      gsFLSetFlag(GS_FL_ENCOUNTER, oGhost);
      break;
    }
    case 6:
    {
      SpeakString("The air is suddenly filled with unpleasant sticky webs.");
      object oWeb = CreateObject(OBJECT_TYPE_PLACEABLE, "door_web", GetLocation(oDoor));
      AssignCommand(oWeb, SetFacing(GetFacing(oDoor)));
      DestroyObject(oWeb, 20.0);
      break;
    }
    default:
      // Nothing happens.
      break;
  }

  DelayCommand(30.0, CloseDoorIfOpen(oDoor));
}

