/*
  Name: mi_remq2item1
  Author: Mithreas
  Date: 10 Sep 05
  Version: 1.0

  Checks for the existence of an item with a tag stored on the speaking NPC
  under the variable name "quest1item1"/
*/
#include "inc_log"
void main()
{
  string sItemTag = GetLocalString(OBJECT_SELF, "quest2item1");
  object sItem = GetItemPossessedBy(GetPCSpeaker(), sItemTag);

  if (sItem != OBJECT_INVALID)
  {
    DestroyObject(sItem);
    Log("Destroyed " + GetName(sItem));
  }
}
