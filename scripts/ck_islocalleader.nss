#include "mi_inc_citizen"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oArea = GetArea(oPC);

    return miCZGetIsLeader(oPC, GetLocalString(oArea, "MI_NATION"));
}

