#include "gs_inc_pc"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int nRating = gsPCGetRolePlay(oPC);

    return nRating >= 20;
}
