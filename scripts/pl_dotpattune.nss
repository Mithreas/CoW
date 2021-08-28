#include "inc_common"
#include "inc_pc"
#include "inc_respawn"
void main()
{
    object oPC = GetLastUsedBy();
	location lLoc = APSStringToLocation(GetLocalString(gsPCGetCreatureHide(oPC), "ESF_TELEPORT_LOCATION"));
	if (!GetIsObjectValid(GetAreaFromLocation(lLoc))) lLoc = gsREGetRespawnLocation(oPC);
	gsCMTeleportToLocation(oPC, lLoc, VFX_IMP_AC_BONUS, TRUE);
}