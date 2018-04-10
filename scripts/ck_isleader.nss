#include "mi_inc_citizen"

int StartingConditional()
{
  object oPC     = GetPCSpeaker();
  object oArea   = GetArea(OBJECT_SELF);
  string sNation = GetLocalString(oArea, "MI_NATION");
  string sBestMatch = miCZGetBestNationMatch(sNation);

  return miCZGetIsLeader(oPC, sBestMatch);
}
