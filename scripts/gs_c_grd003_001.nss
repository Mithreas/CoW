#include "gs_inc_class"

int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();
    int nNth        = 1;

    for (; nNth <= 16; nNth++)
    {
        if (gsCLGetIsOwner("QUARTER_001", nNth, oSpeaker)) return TRUE;
    }

    return FALSE;
}
