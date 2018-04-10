/*
  Name: mi_questcomm
  Author: Mithreas
  Date: 20 Apr 06
  Version: 1.2

  Common functionality for quests - only #include in a dialog-triggered
  script. To use, ensure that the quest-giving NPC has a local variable on
  him called "quest1name" with a value that's unique across the mod.
  If an NPC has multiple quests, give them variables called "quest2name",
  "quest3name" and so on.

  This value is then used as the name of a local variable on the PC. This
  variable stores the "quest integer". The quest integer is valued as follows.
  0 - hasn't started quest.
  1-99 - has done part of quest but not completed it.
  100 - has completed the quest once.

  This package supports multiple runs - so if you complete the quest once and
  start it again, you will have a value of 101-199. Once you complete it twice
  you will have a value of 200. And so on.

  This package provides the following methods:
  string GetQuestVariableName(int nQuestNum)
    Returns the name of the quest variable for this NPC and this quest number.

  int GetQuestInt (int nQuestNum)
    Gets the current value of the quest integer for the speaking PC for the
    nQuestNum'th quest this NPC gives.

  void SetQuestInt(int nQuestNum, int nNewValue)
    Sets the quest integer.

  int GetNumOfTimesQuestDone(int nQuestNum)
    Gets the number of times this quest has been completed.

  void DoneQuest(int nQuestNum)
    Adds 100 to the quest number for this quest, and sets the quest progress to
    0. So 150 becomes 200.

  int GetQuestProgress(int nQuestNum)
    Gets the current quest progress for the current quest (e.g 10, 110, 210,
    310 all return 10).

  void SetQuestProgress(int nQuestNum, int nNewValue)
    Sets the current quest progress - without changing the number of times it's
    been completed. So calling SetQuestProgress(1, 40) when the value of the
    quest int for quest 1 is 110, will set the value to 140.

  int GetIsPCRecognised(int nQuestNum)
    Works out if the NPC recognises the PC. Uses the mi_disguise scripts.

  void DoneNextStageOfQuest(int nQuestNum)
    Adds 1 to the value of the quest integer, marking that the next stage of
    the quest is done.

  1.1 - made quest vars persistent.
  1.2 - added IsQuestDoneByName for the random quest scripts to call, updated
        to use Trace not Log, and changed DB table used for CoW.
*/
#include "mi_disguiseinc"
#include "mi_log"
#include "aps_include"
const string DB_MISC_QUESTS = "misc_quest_db";
const string QUESTS         = "QUESTS"; // for trace

/* Utility method to get the name of the quest. */
string GetQuestVariableName(int nQuestNum)
{
  object oNPC = OBJECT_SELF;
  string oQuestName = "quest" + IntToString(nQuestNum) + "name";
  return GetLocalString(oNPC, oQuestName);
}

/*
  Gets the current value of the quest integer for the speaking PC for the
  nQuestNum'th quest this NPC gives.
*/
int GetQuestInt (int nQuestNum)
{
  int nQuestInt = GetPersistentInt(GetPCSpeaker(),
                                   GetQuestVariableName(nQuestNum),
                                   DB_MISC_QUESTS);
  Trace(QUESTS,"Returned quest value for " + GetName(OBJECT_SELF) + " of " +
      IntToString(nQuestInt));
  return nQuestInt;
}

/* Sets the quest integer. */
void SetQuestInt(int nQuestNum, int nNewValue)
{
  SetPersistentInt(GetPCSpeaker(),
                   GetQuestVariableName(nQuestNum),
                   nNewValue,
                   0,
                   DB_MISC_QUESTS);
  Trace(QUESTS, "Set quest value for " + GetName(OBJECT_SELF) + " to " +
      IntToString(nNewValue));
}

/*
  Gets the number of times this quest has been completed.
*/
int GetNumOfTimesQuestDone(int nQuestNum)
{
  int nQuestInt = GetQuestInt(nQuestNum);
  int nNumTimes = 0;

  while (nQuestInt > 99)
  {
    nQuestInt -= 100;    // Decrement by 100.
    nNumTimes++;
  }

  return nNumTimes;
}

/*
  Adds 100 to the quest number for this quest, and sets the quest progress to
  0. So 150 becomes 200.
  */
void DoneQuest(int nQuestNum)
{
  int nNumTimes = GetNumOfTimesQuestDone(nQuestNum);

  SetQuestInt(nQuestNum, (nNumTimes + 1)*100 );
}

/*
  Gets the current quest progress for the current quest (e.g 10, 110, 210,
  310 all return 10).
  */
int GetQuestProgress(int nQuestNum)
{
  int nQuestInt = GetQuestInt(nQuestNum);

  while (nQuestInt > 99)
  {
    nQuestInt -= 100;    // Decrement by 100.
  }

  return nQuestInt;
}
/*
  Sets the current quest progress - without changing the number of times it's
  been completed. So calling SetQuestProgress(1, 40) when the value of the
  quest int for quest 1 is 110, will set the value to 140.
  */
void SetQuestProgress(int nQuestNum, int nNewValue)
{
  int nAdd = nNewValue - GetQuestProgress(nQuestNum);

  SetQuestInt(nQuestNum, GetQuestInt(nQuestNum) + nAdd);
}

int GetIsPCRecognised(int nQuestNum)
{
  if (GetLocalInt(GetPCSpeaker(), DISGUISED) == 1)
  {
    return SeeThroughDisguise(GetPCSpeaker(),
                              OBJECT_SELF,
                  GetName(OBJECT_SELF) + " seems to think you look familiar...",
                              GetNumOfTimesQuestDone(nQuestNum));
  }
  else
  {
    return 1;
  }
}

/*
  Adds 1 to the value of the quest integer, marking that the next stage of
  the quest is done.
*/
void DoneNextStageOfQuest(int nQuestNum)
{
  SetQuestInt(nQuestNum, GetQuestInt(nQuestNum) + 1);
}

/*
  Returns TRUE if the named quest has been done by the PC, false otherwise.
*/
int IsQuestDoneByName(string sQuestName, object oPC)
{
  int nQuestInt = GetPersistentInt(oPC, sQuestName, DB_MISC_QUESTS);

  if (nQuestInt > 99)
  {
    Trace(QUESTS, "Quest "+sQuestName+" has been completed by "+GetName(oPC));
    return TRUE;
  }
  else
  {
    Trace(QUESTS, "Quest "+sQuestName+" has not been completed by "+GetName(oPC));
    return FALSE;
  }
}
