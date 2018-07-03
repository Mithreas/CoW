/*
  Name: mi_hasq1item1
  Author: Mithreas
  Date: 30 May 06
  Version: 1.2

  Checks for the existence of an item with a tag stored on the speaking NPC
  under the variable name "quest2item1"
*/
#include "inc_log"
int StartingConditional()
{
  string sItemTag = GetLocalString(OBJECT_SELF, "quest2item1");
  object oItem = GetFirstItemInInventory(GetPCSpeaker());
  int nNum = GetLocalInt(OBJECT_SELF, "quest2item1num");
  int nCount = 0;

  if (nNum == 0) nNum = 1;

  while ((nCount < nNum) && GetIsObjectValid(oItem))
  {
    if (GetTag(oItem) == sItemTag)
    {
      nCount += GetItemStackSize(oItem);
      Trace("QUESTS","Destroyed " + GetName(oItem));
    }

    oItem = GetNextItemInInventory(GetPCSpeaker());
  }

  return (nCount >= nNum);
}