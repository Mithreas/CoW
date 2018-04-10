/*
  Name: obj_wantedN
  Author: Mithreas
  Date: 4 Sep 05
  Version: 1.0

  Create a copy of this script for each Wanted token in your mod, and save it
  as obj_wantedN, where N is the number matching the nation and tag of the
  wanted token.

  This script fires when the Wanted token is activated, allowing people to find
  out their current bounty.
*/
#include "mi_crimcommon"
void main()
{
  int nBounty = GetLocalInt(GetItemActivated(), BOUNTY);
  SendMessageToPC(GetItemActivator(), "You currently have a bounty of " +
                                      IntToString(nBounty) +
                                      " on your head!");
}
