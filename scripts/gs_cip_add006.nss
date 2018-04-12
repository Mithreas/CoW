#include "inc_iprop"

int StartingConditional()
{
    int nTableID = gsIPGetTableID("itempropdef");
    int nID      = GetLocalInt(OBJECT_SELF, "GS_OFFSET_1");
    int nCount   = gsIPGetCount(nTableID);

    return nID + 5 < nCount;
}
