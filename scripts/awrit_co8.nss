// awrit_co8
#include "gs_inc_token"
#include "inc_quest"

int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();
    object oWrit = GetQuestWrit(oSpeaker);

    struct QuestData ActiveQuest = GenerateQuestData(GetLocalString(oWrit, "ExaminedContract"));
    string sLine;

    gsTKSetToken(507, "'" + ActiveQuest.name + "'");
    gsTKSetToken(508, ActiveQuest.qlogstart);

    if (ActiveQuest.goaltype1 != "")
        gsTKSetToken(509, ActiveQuest.goalsummary1);
    else
        gsTKSetToken(509, "");

    if (ActiveQuest.goaltype1 != "")
        gsTKSetToken(510, ActiveQuest.goalsummary2);
    else
        gsTKSetToken(510, "");

    if (ActiveQuest.goaltype1 != "")
        gsTKSetToken(511, ActiveQuest.goalsummary3);
    else
        gsTKSetToken(511, "");

    if (ActiveQuest.goaltype1 != "")
        gsTKSetToken(512, ActiveQuest.goalsummary4);
    else
        gsTKSetToken(512, "");

    int i = 1;
    while (i < 7) {
        gsTKRecallToken(506 + i);
        i++;
    }

    return TRUE;
}
