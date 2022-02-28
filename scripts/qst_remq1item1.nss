/*
  Name: mi_remq1item1
  Author: Mithreas
  Date: 30 May 06
  Version: 1.2

  Checks for the existence of an item with a tag stored on the speaking NPC
  under the variable name "quest1item1"/
*/
#include "inc_common"
#include "inc_log"
void main()
{
  string sItemTag = GetLocalString(OBJECT_SELF, "quest1item1");
  object oItem = GetFirstItemInInventory(GetPCSpeaker());
  int nNum = GetLocalInt(OBJECT_SELF, "quest1item1num");

  if (nNum == 0) nNum = 1;

  while ((nNum > 0) && GetIsObjectValid(oItem))
  {
    if (GetTag(oItem) == sItemTag)
    {
      nNum = gsCMReduceItem(oItem, nNum);
      Trace("QUESTS","Destroyed " + GetName(oItem));
    }

    oItem = GetNextItemInInventory(GetPCSpeaker());
  }
}
