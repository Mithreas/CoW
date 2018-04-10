// awrit_co9
#include "gs_inc_token"
#include "inc_quest"

void main()
{
    object oSpeaker = GetPCSpeaker();
    object oWrit = GetQuestWrit(oSpeaker);

	   if (oWrit == OBJECT_INVALID)
		      return;

	   RemoveQuestFromWrit(oWrit, GetLocalString(oWrit, "ExaminedContract"));
}
