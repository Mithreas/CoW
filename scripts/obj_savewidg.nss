// OOC save device
#include "x2_inc_switches"
void main()
{
  // If this script was called in an acquire routine, run away.
  if (GetUserDefinedItemEventNumber() != X2_ITEM_EVENT_ACTIVATE)
  { /* do nothing */ return; }

  object oPC = GetItemActivator();

  ExportSingleCharacter(oPC);
  SendMessageToPC(oPC, "Character saved.");
}
