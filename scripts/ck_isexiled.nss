#include "mi_inc_citizen"
int StartingConditional()
{
    string sNation = miCZGetBestNationMatch(GetLocalString(OBJECT_SELF, VAR_NATION));
    object oPC = GetPCSpeaker();

    return miCZGetIsExiled(oPC, sNation);
}
