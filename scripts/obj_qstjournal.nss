/*
  obj_qstjournal

  When used, tells the PC their last briefing.

*/
#include "inc_randomquest"
#include "x2_inc_switches"
void main()
{
  object oItem   = GetSpellCastItem();
  object oPC     = GetItemPossessor(oItem);

  string sCurrentQuest = GetPersistentString(oPC, CURRENT_QUEST);
  string sCurrentQuestSet = GetPersistentString(oPC, sCurrentQuest);

  string sVarsDB = sCurrentQuestSet + QUEST_VAR_DB;
  object oCache = miDAGetCacheObject(sVarsDB);

  string sDescription = GetLocalString(oCache, sCurrentQuest+DESCRIPTION);

  if (sDescription == "")
  {
    SendMessageToPC (oPC, "You don't have a quest at the moment.");
  }
  else
  {
    SendMessageToPC(oPC, "Your current quest is: " + sDescription);
  }
  
  // Is the quest complete?
  if (IsQuestComplete(oPC))
  {
    SendMessageToPC(oPC, "You have done everything you need to - return for your reward."); 
  }  
}
