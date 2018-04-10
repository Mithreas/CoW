#include "gs_inc_common"

void main()
{
    object oUser   = GetLastUsedBy();
    if (! GetIsPC(oUser)) return;
    string sTag    = GetLocalString(OBJECT_SELF, "CustomFlag");
    object oTarget = GetWaypointByTag(sTag);

    gsCMTeleportToObject(oUser, oTarget, FALSE);
}
