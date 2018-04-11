#include "gs_inc_common"

void main()
{
  // open the NPC store for this NPC Barkeepers bar
  object oStore = GetLocalObject(OBJECT_SELF, "gvd_store");

  if (oStore != OBJECT_INVALID) {
    object oPC = GetPCSpeaker();
    gsCMOpenStore(oStore, OBJECT_SELF, oPC);
  }

}
