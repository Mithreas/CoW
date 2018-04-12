#include "inc_text"
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
    case ITEM_APPR_ARMOR_COLOR_CLOTH1:
        SetCustomToken(105, GS_T_16777241 + " 1\n");
        break;

    case ITEM_APPR_ARMOR_COLOR_CLOTH2:
        SetCustomToken(105, GS_T_16777241 + " 2\n");
        break;

    case ITEM_APPR_ARMOR_COLOR_LEATHER1:
        SetCustomToken(105, GS_T_16777242 + " 1\n");
        break;

    case ITEM_APPR_ARMOR_COLOR_LEATHER2:
        SetCustomToken(105, GS_T_16777242 + " 2\n");
        break;

    case ITEM_APPR_ARMOR_COLOR_METAL1:
        SetCustomToken(105, GS_T_16777243 + " 1\n");
        break;

    case ITEM_APPR_ARMOR_COLOR_METAL2:
        SetCustomToken(105, GS_T_16777243 + " 2\n");
        break;
    }

    return TRUE;
}
