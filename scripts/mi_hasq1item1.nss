/*
  Name: mi_hasq1item1
  Author: Mithreas
  Date: 30 May 06
  Version: 1.2

  Checks for the existence of an item with a tag stored on the speaking NPC
  under the variable name "quest1item1"/
*/
#include "mi_log"
int StartingConditional()
{
  string sItemTag = GetLocalString(OBJECT_SELF, "quest1item1");
  object oItem = GetFirstItemInInventory(GetPCSpeaker());
  int nNum = GetLocalInt(OBJECT_SELF, "quest1item1num");
  int nCount = 0;

  if (nNum == 0) nNum = 1;

  while ((nCount < nNum) && GetIsObjectValid(oItem))
  {
    if (GetTag(oItem) == sItemTag)
    {
      nCount++;
      Trace("QUESTS","Destroyed " + GetName(oItem));
    }

    oItem = GetNextItemInInventory(GetPCSpeaker());
  }

  return (nCount == nNum);
}
