// awrit_co10
// Writ discard prereq.

#include "gs_inc_token"
#include "inc_quest"

int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();
    object oWrit = GetQuestWrit(oSpeaker);

    if (gsTIGetActualTimestamp() - GetLocalInt(oWrit, "QuestTakenWhen") < QUEST_REFRESH)
        return FALSE;

    return TRUE;
}
