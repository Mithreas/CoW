#include "inc_token"

int StartingConditional()
{
    int nSlot  = 0;
    int nNth   = GetLocalInt(OBJECT_SELF, "GS_OFFSET");
    int nCount = nNth + 5;

    for (; nNth < nCount; nNth++)
    {
        nSlot++;

        if (nNth < 176)
        {
            gsTKSetToken(99 + nSlot, IntToString(nNth));
            SetLocalInt(OBJECT_SELF, "GS_SLOT_" + IntToString(nSlot), nNth);
        }
        else
        {
            SetLocalInt(OBJECT_SELF, "GS_SLOT_" + IntToString(nSlot), -1);
        }
    }

    switch (GetLocalInt(OBJECT_SELF, "GS_ID"))
    {
    case COLOR_CHANNEL_TATTOO_1:
        SetCustomToken(105, "Tattoo Color 1\n");
        break;

    case COLOR_CHANNEL_TATTOO_2:
        SetCustomToken(105, "Tattoo Color 2\n");
        break;
    }

    return TRUE;
}
