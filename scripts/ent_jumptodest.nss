#include "inc_common"
void main()
{
  string sDestTag = GetLocalString(OBJECT_SELF, "GS_TARGET");

  object oDest = GetObjectByTag(sDestTag);

  object oEntered = GetEnteringObject();

  gsCMTeleportToObject(oEntered, oDest, VFX_IMP_CHARM, FALSE);
}