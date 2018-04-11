#include "inc_backgrounds"

int StartingConditional() {
    if (md_GetIsNoble(GetPCSpeaker(), miCZGetBestNationMatch(GetLocalString(GetArea(OBJECT_SELF), VAR_NATION)))) {
        return TRUE;
    }
    return FALSE;
}
