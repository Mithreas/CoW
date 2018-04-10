#include "fb_inc_chatutils"
// Append script
void main()
{
  object oItem = GetFirstItemInInventory();
  object oPC   = GetPCSpeaker();

  string sAppendText = chatGetLastMessage(oPC);

  SetDescription(oItem, GetDescription(oItem) + "\n\n" + sAppendText);
  SetLocalInt(oItem, "_NOSTACK", TRUE);
}

