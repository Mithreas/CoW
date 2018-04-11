#include "inc_customspells"
void main()
{
  object oPC = GetExitingObject();
  SendMessageToPC(oPC, "You are no longer close enough to use the crystal ball.");
  SetScryOverride (oPC, FALSE);
}
