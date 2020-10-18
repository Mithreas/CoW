#include "inc_external"
#include "inc_awards"

void main()
{
    object oPC = GetEnteringObject();
	
	if (!GetIsPC(oPC)) return;
	if (GetIsDM(oPC) || GetIsDMPossessed(oPC)) return;
	
    gvd_DoRewards(oPC);

    miXFUnregisterPlayer(oPC);
    fbEXDeletePC(oPC);
}