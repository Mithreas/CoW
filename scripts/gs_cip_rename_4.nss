#include "fb_inc_chatutils"
// Replace script
void main()
{
  object oItem = GetFirstItemInInventory();
  object oPC   = GetPCSpeaker();

  string sReplaceText = chatGetLastMessage(oPC);

  SetDescription(oItem, sReplaceText);
  SetLocalInt(oItem, "_NOSTACK", TRUE);
}

