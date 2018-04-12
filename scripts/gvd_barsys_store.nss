#include "inc_shop"
#include "inc_divination"

void main()
{
    miDVGivePoints(GetPCSpeaker(), ELEMENT_WATER, 4.0);
	
  // open the NPC store for this NPC Barkeepers bar
  object oStore = GetLocalObject(OBJECT_SELF, "gvd_store");

  if (oStore != OBJECT_INVALID) {
    object oPC = GetPCSpeaker();
    gsSHOpenStore(oStore, OBJECT_SELF, oPC);
  }

}
