/*
  obj_qstjournal

  When used, tells the PC their last briefing.

*/
#include "inc_randomquest"
#include "x2_inc_switches"
const string QJ_QUEST = "qj_quest_";
const string QJ_SET   = "qj_questset_";
void main()
{
	object oItem   = GetSpellCastItem();
	object oPC     = GetItemPossessor(oItem);

	string sSQL = "SELECT quest,questset FROM " + QUEST_CURRENT_DB + " where pcid='" + gsPCGetPlayerID(oPC) + "'";
	string sQuestSet;
	string sQuest = "";
	int nCount    = 0;
	
	SQLExecDirect(sSQL);
	
	while (SQLFetch())
	{
		// Build a list and recall it later, because checking for quest completion runs another SQL query.
		nCount++;
		SetLocalString(oItem, QJ_QUEST + IntToString(nCount), SQLGetData(1));
		SetLocalString(oItem, QJ_SET + IntToString(nCount), SQLGetData(2));
	}
	
	int ii = 1;
	for (ii; ii <= nCount; ii++)
	{
		sQuest    = GetLocalString(oItem, QJ_QUEST + IntToString(ii));
		sQuestSet = GetLocalString(oItem, QJ_SET + IntToString(ii));
		
		DeleteLocalString(oItem, QJ_QUEST + IntToString(ii));
		DeleteLocalString(oItem, QJ_SET + IntToString(ii));
		  
		string sVarsDB = sQuestSet + QUEST_VAR_DB;
		object oCache = miDAGetCacheObject(sVarsDB);

		string sDescription = GetLocalString(gsPCGetCreatureHide(oPC), sQuest+DESCRIPTION);
		if (sDescription == "") sDescription = GetLocalString(gsPCGetCreatureHide(oPC), DESCRIPTION); // Backwards compatibility
		if (sDescription == "") sDescription = GetLocalString(oCache, sQuest+DESCRIPTION);

		SendMessageToPC(oPC, "QUEST: " + sDescription);
		
		// Is the quest complete?
		if (IsQuestComplete(oPC, sQuest, sQuestSet))
		{
		  SendMessageToPC(oPC, "You have done everything you need to - return for your reward."); 
		}  
	}
  
	if (sQuest == "")
	{
		SendMessageToPC (oPC, "You don't have a quest at the moment.");
	}
}
