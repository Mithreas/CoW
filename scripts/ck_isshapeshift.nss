#include "inc_subrace"
int StartingConditional()
{
  return gsSUGetSubRaceByName(GetSubRace(GetPCSpeaker())) == GS_SU_SHAPECHANGER;
}