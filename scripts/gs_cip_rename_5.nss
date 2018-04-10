#include "fb_inc_chatutils"
// Append script - same paragraph.
void main()
{
  object oItem = GetFirstItemInInventory();
  object oPC   = GetPCSpeaker();

  string sAppendText = chatGetLastMessage(oPC);

  SetDescription(oItem, GetDescription(oItem) + sAppendText);
  SetLocalInt(oItem, "_NOSTACK", TRUE);
}

