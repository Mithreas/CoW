/*
 * Dialog script to open the nearest store.
 * 
 */
#include "inc_shop"
#include "inc_divination"
void main()
{
    object oPC = GetPCSpeaker();
	
    int nTimeout = GetLocalInt(oPC, "WATER_TIMEOUT");
	if (gsTIGetActualTimestamp() > nTimeout)
	{
      miDVGivePoints(oPC, ELEMENT_WATER, 8.0);
	  SetLocalInt(oPC, "WATER_TIMEOUT", gsTIGetActualTimestamp() + 15*60);
	}  

    object oStore = GetNearestObject(OBJECT_TYPE_STORE);
    if (GetIsObjectValid(oStore)) gsSHOpenStore(oStore, OBJECT_SELF, oPC);
}
