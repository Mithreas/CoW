#include "inc_portal"

int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();
    int nNth        = GetLocalInt(OBJECT_SELF, "GS_PAGE_START");

    return nNth > 0 && gsPOGetPreviousActivePortal(nNth, oSpeaker) != -1;
}
