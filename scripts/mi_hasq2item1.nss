/*
  Name: mi_hasq2item1
  Author: Mithreas
  Date: 10 Sep 05
  Version: 1.0

  Checks for the existence of an item with a tag stored on the speaking NPC
  under the variable name "quest1item1"/
*/
#include "mi_log"
int StartingConditional()
{
  string sItemTag = GetLocalString(OBJECT_SELF, "quest2item1");
  object sItem = GetItemPossessedBy(GetPCSpeaker(), sItemTag);
  int nRetVal = 0;
   if (sItem != OBJECT_INVALID)
  {
    nRetVal = 1;
    Log("Found item: " + GetName(sItem));
  }

  return nRetVal;
}
