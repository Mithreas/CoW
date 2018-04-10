#include "gs_inc_pc"
#include "gvd_inc_slave"

void main()
{
    //AdjustAlignment(GetPCSpeaker(), ALIGNMENT_GOOD, 5);

  // addition Dunshine:
  // track the releasing of this slave on the PC in case the PC is a slaveguild member in Andunor
  object oPC = GetPCSpeaker();

  // only for slaveguild members
  if (gvd_SlaveGuildMember(oPC) == TRUE) {

    object oClamp = gvd_GetSlaveTrackingItem(oPC);
    int iSlavesReleased = GetLocalInt(oClamp, "GVD_SLAVEGUILD_RELEASED");
    SetLocalInt(oClamp, "GVD_SLAVEGUILD_RELEASED", iSlavesReleased + 1);

  }

}
