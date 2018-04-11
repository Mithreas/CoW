#include "gs_inc_state"

int StartingConditional()
{
    object oPC      = GetPCSpeaker();
    int nRaceOnly   = GetLocalInt(OBJECT_SELF, "AR_QU_SUBRACE");
    string sSubRace = GetSubRace(oPC);
    int nSubRace    = gsSUGetSubRaceByName(sSubRace);

    return nSubRace == nRaceOnly;
}
