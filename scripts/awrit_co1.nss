// awrit_co1
#include "gs_inc_token"
#include "inc_quest"

int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();
    object oWrit = GetQuestWrit(oSpeaker);

    if (GetQuestsStored(oWrit) < 1)
        return FALSE;

    if (oWrit == OBJECT_INVALID)
        return FALSE;

    struct QuestData ActiveQuest;
    string sString;

    int i = 1;

    if (GetLocalString(oWrit, QUEST_ONE_IDENT) != "") {
        ActiveQuest = GenerateQuestData(GetLocalString(oWrit, QUEST_ONE_IDENT));
        sString = "'" + ActiveQuest.name + "' - " + ActiveQuest.advert;
        gsTKSetToken(501, sString);
        gsTKSetToken(504, "Examine documents related to '" + ActiveQuest.name + ".'");
        gsTKRecallToken(504);
        i++;
    }
    if (GetLocalString(oWrit, QUEST_TWO_IDENT) != "") {
        ActiveQuest = GenerateQuestData(GetLocalString(oWrit, QUEST_TWO_IDENT));
        sString = "'" + ActiveQuest.name + "' - " + ActiveQuest.advert;
        gsTKSetToken(502, sString);
        gsTKSetToken(505, "Examine documents related to '" + ActiveQuest.name + ".'");
        gsTKRecallToken(505);
        i++;
    }
    if (GetLocalString(oWrit, QUEST_THREE_IDENT) != "") {
        ActiveQuest = GenerateQuestData(GetLocalString(oWrit, QUEST_THREE_IDENT));
        sString = "'" + ActiveQuest.name + "' - " + ActiveQuest.advert;
        gsTKSetToken(503, sString);
        gsTKSetToken(506, "Examine documents related to '" + ActiveQuest.name + ".'");
        gsTKRecallToken(506);
        i++;
    }

    // Set the remaining tokens of this page blank.
    while (i < 3) {
        gsTKSetToken(500 + i, "");
        i++;
    }
    gsTKRecallToken(501);
    gsTKRecallToken(502);
    gsTKRecallToken(503);

    return TRUE;
}
