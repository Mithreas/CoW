/*
  obj_qstjournal

  When used, tells the PC their last briefing.

*/
#include "inc_randomquest"
#include "x2_inc_switches"
void main()
{
  // If this script was called in an acquire routine, run away.
  if (GetUserDefinedItemEventNumber() != X2_ITEM_EVENT_ACTIVATE)
  { Trace(RQUEST, "journal object not activated"); return; }

  object oPC = GetItemActivator();

  string sCurrentQuest = GetPersistentString(oPC, CURRENT_QUEST);
  string sCurrentQuestSet = GetPersistentString(oPC, sCurrentQuest);

  string sVarsDB = sCurrentQuestSet + QUEST_VAR_DB;

  string sDescription = GetPersistentString(OBJECT_INVALID, sCurrentQuest+DESCRIPTION, sVarsDB);

  if (sDescription == "")
  {
    SendMessageToPC (oPC, "You don't have a quest at the moment.");
  }
  else
  {
    SendMessageToPC(oPC, "Your current quest is: " + sDescription);
  }
}
