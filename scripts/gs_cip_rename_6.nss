#include "inc_chatutils"
// Append script - newline
void main()
{
  object oItem = GetFirstItemInInventory();
  object oPC   = GetPCSpeaker();

  string sAppendText = chatGetLastMessage(oPC);

  SetDescription(oItem, GetDescription(oItem) + "\n" + sAppendText);
  SetLocalInt(oItem, "_NOSTACK", TRUE);
}

