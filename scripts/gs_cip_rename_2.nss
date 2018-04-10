#include "gs_inc_iprop"
#include "fb_inc_chatutils"
#include "x3_inc_string"

void main()
{
  object oItem = GetFirstItemInInventory();
  object oPC   = GetPCSpeaker();

  string sNewName = chatGetLastMessage(oPC);

  if (GetLocalInt(oItem, "RUNIC"))
  {
    // Runic items are coloured blue.
    sNewName = StringToRGBString(sNewName, "339");
  }

  SetName(oItem, sNewName);
  gsIPSetOwner(oItem, oPC);
}
