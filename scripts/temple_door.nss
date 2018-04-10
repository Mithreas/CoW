#include "mi_teleport"
void main()
{
  string sDestWP = GetLocalString(OBJECT_SELF, "DEST_WP");
  object oWP = GetNearestObjectByTag(sDestWP);
  object oPC = GetLastUsedBy();

  JumpAllToLocation(oPC,GetLocation(oWP));
}
