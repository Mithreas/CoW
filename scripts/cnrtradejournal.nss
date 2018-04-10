// cnrtradejournal
#include "x2_inc_switches"
void main()
{
  // If this script was called in an acquire routine, run away.
  if (GetUserDefinedItemEventNumber() != X2_ITEM_EVENT_ACTIVATE)
  { return; }

  BeginConversation("cnr_c_journal", GetLastUsedBy());
}
