#include "gs_inc_portal"

int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();
    int nNth        = GetLocalInt(OBJECT_SELF, "GS_PAGE_END");

    return nNth > 0 && gsPOGetNextActivePortal(nNth, oSpeaker) != -1;
}
