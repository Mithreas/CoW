#include "inc_portal"

void main()
{
    object oSpeaker = GetPCSpeaker();
    int nNth        = GetLocalInt(OBJECT_SELF, "GS_PAGE_END");

    if (nNth != -1)
    {
        nNth = gsPOGetNextActivePortal(nNth, oSpeaker);
        if (nNth != -1) SetLocalInt(OBJECT_SELF, "GS_PAGE_START", nNth);
    }
}
