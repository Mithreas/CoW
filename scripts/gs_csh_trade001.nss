#include "inc_common"
#include "inc_shop"

int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();
    object oItem    = GetLocalObject(oSpeaker, "GS_SH_ITEM");
    int nSalePrice  = gsSHGetSalePrice(OBJECT_SELF);
    int nValue      = gsCMGetItemValue(oItem) * nSalePrice / 100;
    if (nValue < 1) nValue = 1;

    SetCustomToken(823, GetName(oItem));
    SetCustomToken(824, IntToString(nValue));

    return TRUE;
}
