/*
  Name: mi_getq1item1
  Author: Mithreas
  Date: 17 Apr 06
  Version: 1.1

  Gives the PC the item with a tag stored on the speaking NPC under the variable
  name "quest1item1".
*/
#include "inc_log"
#include "inc_database"
#include "inc_quest"
void main()
{
  string sItemTag = GetPersistentString(OBJECT_SELF, "quest1item1");
  object oItem = CreateItemOnObject(sItemTag, GetPCSpeaker());

  if (oItem == OBJECT_INVALID)
  {
    Trace(QUESTS, "ERROR! Tried to create non-existent item " + sItemTag);
  }
}
