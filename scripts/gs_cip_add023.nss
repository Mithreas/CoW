#include "inc_iprop"

int StartingConditional()
{
    int nTableID    = gsIPGetTableID("itempropdef");
    int nProperty   = GetLocalInt(OBJECT_SELF, "GS_PROPERTY");
    int nSubTableID = gsIPGetValue(nTableID, nProperty, "SUBREF");
    int nID         = GetLocalInt(OBJECT_SELF, "GS_OFFSET_2");
    int nCount      = gsIPGetCount(nSubTableID);

    return nID + 5 < nCount;
}
