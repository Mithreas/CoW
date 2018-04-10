// awrit_co2
#include "gs_inc_token"
#include "inc_quest"

int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();
    object oWrit = GetQuestWrit(oSpeaker);

	   if (oWrit == OBJECT_INVALID)
		      return FALSE;

	   if (GetLocalString(oWrit, QUEST_ONE_IDENT) != "")
		      return TRUE;

	   return FALSE;
}
