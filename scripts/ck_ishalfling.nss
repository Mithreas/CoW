#include "inc_subrace"
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int nSubRace = gsSUGetSubRaceByName(GetSubRace(oPC));

  if (GetRacialType(oPC) == RACIAL_TYPE_HALFLING &&
      nSubRace != GS_SU_SPECIAL_FEY &&
      nSubRace != GS_SU_SPECIAL_GOBLIN &&
      nSubRace != GS_SU_SPECIAL_KOBOLD)
  {
    return TRUE;
  }

  return FALSE;
}
