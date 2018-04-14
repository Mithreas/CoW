/*
  Name: goto_conv
  Author: Mithreas
  Date: 7 Apr 06

  Jump the PC speaker to the location marked by the object whose tag is the
  variable "GOTO" on the NPC speaker.
*/
#include "inc_teleport"
void main()
{
  JumpAllToLocation(GetPCSpeaker(),
                    GetLocation(GetObjectByTag(GetLocalString(OBJECT_SELF, "GOTO"))));
}
