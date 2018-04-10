#include "gs_inc_common"
#include "gs_inc_time"

const int GS_TIMEOUT = 7200; //2 hours

void main()
{
    string sTemplate    = GetLocalString(OBJECT_SELF, "ORE_TEMPLATE");
    int nExpiration     = GetLocalInt(OBJECT_SELF, "ORE_EXPIRE");
    int nDbId           = GetLocalInt(OBJECT_SELF, "GVD_PLACEABLE_ID");
    gsCMCreateRecreatorAsOreVein(gsTIGetActualTimestamp() + GS_TIMEOUT, sTemplate, nExpiration, nDbId);
}
