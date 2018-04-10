////////////////////////////////////////////////////////////
// OnClick/OnAreaTransitionClick
// NW_G0_Transition.nss
// Copyright (c) 2001 Bioware Corp.
////////////////////////////////////////////////////////////
// Created By: Sydney Tang
// Created On: 2001-10-26
// Description: This is the default script that is called
//              if no OnClick script is specified for an
//              Area Transition Trigger or
//              if no OnAreaTransitionClick script is
//              specified for a Door that has a LinkedTo
//              Destination Type other than None.
////////////////////////////////////////////////////////////
#include "mi_inc_teleport"
#include "mi_inc_tracks"
void main()
{
  object oClicker = GetClickingObject();
  object oTarget = GetTransitionTarget(OBJECT_SELF);

  SetAreaTransitionBMP(AREA_TRANSITION_RANDOM);

  JumpAllToObject(oClicker, oTarget);

  if (GetObjectType(OBJECT_SELF) == OBJECT_TYPE_DOOR)
  {
    DelayCommand(30.0, AssignCommand(OBJECT_SELF,
                                     ActionCloseDoor(OBJECT_SELF)));
  }

  // Tracks
  miTRDoTracks(oClicker, FALSE);
}
