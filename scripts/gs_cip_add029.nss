#include "inc_iprop"

int StartingConditional()
{
    int nTableID     = gsIPGetTableID("itempropdef");
    int nProperty    = GetLocalInt(OBJECT_SELF, "GS_PROPERTY");
    int nCostTableID = gsIPGetValue(nTableID, nProperty, "COSREF");
    int nID          = GetLocalInt(OBJECT_SELF, "GS_OFFSET_3");
    int nCount       = gsIPGetCount(nCostTableID);

    return nID + 5 < nCount;
}
