#include "inc_iprop"

int StartingConditional()
{
    int nTableID      = gsIPGetTableID("itempropdef");
    int nProperty     = GetLocalInt(OBJECT_SELF, "GS_PROPERTY");
    int nSubTableID   = gsIPGetValue(nTableID, nProperty, "SUBREF");
    int nSubType      = GetLocalInt(OBJECT_SELF, "GS_SUBTYPE");
    int nParamTableID = gsIPGetValue(nSubTableID, nSubType, "PARREF");
    int nID           = GetLocalInt(OBJECT_SELF, "GS_OFFSET_4");
    int nCount        = gsIPGetCount(nParamTableID);

    return nID + 5 < nCount;
}
