#include "inc_teleport"
#include "cow_house_check"
#include "inc_database"
void main()
{
  object oPC = GetPCSpeaker();
  // Set var so as note we've initialised.
  SetPersistentInt(oPC, "INITIALIZED", 1);

  if (isRenerrin(oPC))
  {
    JumpAllToLocation(oPC,
                      GetLocation(GetObjectByTag("renerrin_start")));
  }
  else if (isDrannis(oPC))
  {
    JumpAllToLocation(oPC,
                      GetLocation(GetObjectByTag("drannis_start")));
  }
  else if (isErenia(oPC))
  {
    JumpAllToLocation(oPC,
                      GetLocation(GetObjectByTag("erenia_start")));
  }
  else
  {
    JumpAllToLocation(oPC,
                      GetLocation(GetObjectByTag("gen_start")));
  }

}
