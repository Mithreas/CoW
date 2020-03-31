// Teleports the entering PC to a "random" location outside the Feywilds.
#include "inc_common"
void main()
{
  object oPC = GetEnteringObject();
  if (!GetIsPC(oPC)) return;
  
  object oWP = GetObjectByTag("WP_FAIRY_" + IntToString(Random(10)));

  gsCMTeleportToObject(oPC, oWP);
}