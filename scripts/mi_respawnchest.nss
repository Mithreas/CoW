/* mi_chestrespawn v1.2 */
#include "inc_log"

void CreateObjectReturnsVoid(int nObjectType, string sResRef, location lLocation)
{
  CreateObject(nObjectType, sResRef, lLocation);
}

void main()
{
  int nRespawning = GetLocalInt(OBJECT_SELF, "respawning");
  if (nRespawning) return;
  SetLocalInt(OBJECT_SELF, "respawning", 1);

  string sResRef = GetResRef(OBJECT_SELF);
  location lChest = GetLocation(OBJECT_SELF);
  DelayCommand(60.0, DestroyObject(OBJECT_SELF));
  AssignCommand(GetModule(), DelayCommand(80.0,
  CreateObjectReturnsVoid(OBJECT_TYPE_PLACEABLE, sResRef, lChest)));

}

