#include "inc_subrace"

int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();
    string sSubRace = GetSubRace(oSpeaker);
    int nSubRace    = gsSUGetSubRaceByName(sSubRace);

    return nSubRace == GS_SU_SPECIAL_FEY ;
}
