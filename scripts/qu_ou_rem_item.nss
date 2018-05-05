// Used in a messenger-type quest to allow a placeable to swallow an item.
void main()
{
  object oPC  = GetLastUsedBy();
  string sTag = GetLocalString(OBJECT_SELF, "QUEST_ITEM");

  object oItem = GetItemPossessedBy(oPC, sTag);

  if (GetIsObjectValid(oItem))
  {
    CopyItem(oItem, OBJECT_SELF);
    DestroyObject(oItem);
  }
}