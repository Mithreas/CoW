#include "aps_include"
void main()
{
  // Mark that the player is no longer logged in.
  object oPC = GetExitingObject();
  SetPersistentString(OBJECT_INVALID, GetName(oPC), "");
}
