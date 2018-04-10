#include "mi_inc_citizen"

int StartingConditional()
{
    object oPC       = GetPCSpeaker();
    object oArea     = GetArea(OBJECT_SELF);
    string sNation   = GetLocalString(oArea, "MI_NATION");
    string sPCNation = miCZGetName( GetLocalString(oPC, VAR_NATION) );

    if (sPCNation == sNation && sNation != "" && sNation != "0")
        return TRUE;

    return FALSE;
}
