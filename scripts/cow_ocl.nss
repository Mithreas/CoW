#include "inc_database"
void main()
{
  // Mark that the player is no longer logged in.
  object oPC = GetExitingObject();
  SetPersistentString(OBJECT_INVALID, GetName(oPC), "");
}
