#include "inc_subrace"

int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();
    string sSubRace = GetSubRace(oSpeaker);
    int nSubRace    = gsSUGetSubRaceByName(sSubRace);

    return (nSubRace == GS_SU_SPECIAL_KOBOLD ||
        nSubRace == GS_SU_SPECIAL_GOBLIN ||
        nSubRace == GS_SU_SPECIAL_OGRE ||
        nSubRace == GS_SU_SPECIAL_HOBGOBLIN );
}
