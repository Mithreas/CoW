/*
  Random Quest System
  Author: Mithreas
  Date: 9 Apr 06

  Description:
  * Selects a random quest from the available ones
  * No PC will do the same quest more than once.
  * Quests can be one of a number of types.
    * Retrieve item(s). Character must fetch a number of items of the same
      type.
    * Kill NPC. Character must kill an NPC.
    * Messenger quest. Character must carry an item from the quest giver to
      another NPC, carry an item from the other NPC to the quest giver, or both.
    * Help NPC. Character must find another NPC and do a quest for them.
    * Patrol areas. Character must visit a number of areas on a patrol.
	* Cull creatures.  Character must kill X creatures with tag Y. 

  @@@ Support more than one quest at a time.
  @@@ Rework the database structure so that there is a single quests table with
  all the variables as columns (including questset).  Then cache information
  about each quest on a cache item on startup (see inc_database).
  

  The same system can be used for a number of different quest givers, each needs
  their own set of tables. The NPC using the quest system must have a variable,
  QUEST_DB_NAME, containing the string that will be used by the scripts to
  construct the names of the tables for that NPC's quests. Each quest the NPC
  can give must be identified by a unique tag.  The following tables
  need to be set up (using "questname" as the value of QUEST_DB_NAME for this
  example).

  Tables that must be filled out by the builder (all in standard APS-style):
  questname_quests - Contains a list of quest tags, matching them to templates.
                     A template is one of the quest types, stored as a string:
                     RETRIEVE, KILL, MESSENGER, HELP, PATROL
  questname_vars   - Stores the variables for each quest. The variables needed
                     depend on the quest type, but all quest types have two
                     common variables:

                     Required:
                     questtag_description - The briefing the NPC will give.

                     Optional (defaults to none in each case):
                     questtag_rewardgold  - Amount of gold to give in reward
                     questtag_rewardxp    - Amount of xp to give in reward
                     questtag_rewardfrep  - Amount of faction reputation gained.
                     questtag_rewardgrep  - Amount of global reputation gained.
                     questtag_rewarditem  - Item to give as a reward.
					 questtag_repeatable  - Any value makes the quest repeatable.

                     Optional (defaults to "any")
                     questtag_levelrange  - "any" or two numbers separated by
                                            a dash, e.g. "03-07". Must use 2
                                            digits.

                     RETRIEVE:
                     questtag_itemtag     - The tag of the item needed.
                     questtag_numitems    - The number of items needed (if left
                                            unset or not numeric, defaults to 1)

                     KILL:
                     questtag_targettag   - The tag (and hence resref) of the
                                            mark.
                     NB: If a waypoint exists with tag WP_tag_SPAWN for the NPC
                     they will be spawned there if they don't exist already.

                     MESSENGER:
                     questtag_itemtogive  - The item the NPC gives to be carried
                                            (if unset, no item given)
                     questtag_itemtobring - The item the NPC wants retrieved
                                            (if unset, no item given)
                     questtag_othernpc    - The tag (and hence resref) of the
                                            NPC to give/get items to/from.
                     questtag_type        - "GIVE", "GET" or "BOTH".
                     NB: If a waypoint exists with tag WP_tag_SPAWN for the NPC
                     they will be spawned there if they don't exist already.

                     HELP:
                     questtag_othernpc    - The tag (and hence resref) of the
                                            NPC to help.
                     NB: Create a waypoint with tag WP_tag_SPAWN for the NPC.
                     they will be spawned there if they don't exist already.

                     PATROL:
                     questtag_areatags    - Comma separated list of area tags
                                            that the PC must visit.

					 CULL: 
					 questtag_culltag      - the tag of the creature(s)
					 questtag_numcreatures - the number to kill


  Tables that are used by the scripts, and need to be set up (in usual APS
  style) but not populated with data:
  questname_player - Stores the fact that a player has done a particular
                     quest. One entry per player/character hash, containing a
                     colon-delimited list of quests that the char has done. (Two
                     colons are used to make substring matching easier and
                     prevent problems if one quest name is a substring of
                     another!).


  __Hooking NPCs into this system__

  NPC questgivers need the following:
  conversation: zdlg_converse
  variables:
    QUEST_DB_NAME - Used to link the NPC to databases as above.
    dialog        - zdlg_randomquest

  Other quest NPCs (such as victims and people to give/receive items) need:
  conversation: zdlg_converse
  variables:
    dialog        - zdlg_questnpc
*/
#include "pg_lists_i"
#include "inc_common"
#include "inc_pc";
#include "inc_perspeople"
#include "inc_reputation"
#include "inc_stacking"
// inc_reputation includes inc_database and inc_log
#include "inc_quest"
// inc_quest includes inc_database, inc_log, and inc_disguise.
// For constructing variable names
const string RQUEST          = "RANDOM_QUESTS"; // For tracing
const string QUEST_DB        = "_quests";
const string QUEST_VAR_DB    = "_vars";
const string QUEST_PLAYER_DB = "rquest_player_data";
const string QUEST_DB_NAME   = "QUEST_DB_NAME";
const string CURRENT_QUEST   = "rand_quest_current_quest";
const string CULL_TAG        = "_culltag";
const string DESCRIPTION     = "_description";
const string REWARD_GOLD     = "_rewardgold";
const string REWARD_XP       = "_rewardxp";
const string REWARD_FAC_REP  = "_rewardfrep";
const string REWARD_GLO_REP  = "_rewardgrep";
const string REWARD_ITEM     = "_rewarditem";
const string IS_REPEATABLE   = "_repeatable";
const string LEVEL_RANGE     = "_levelrange";
const string ITEM_TAG        = "_itemtag";
const string NUM_ITEMS       = "_numitems";
const string NUM_CREATURES   = "_numcreatures";
const string TARGET_TAG      = "_targettag";
const string ITEM_TO_GIVE    = "_itemtogive";
const string ITEM_TO_BRING   = "_itemtobring";
const string OTHER_NPC       = "_othernpc";
const string TYPE            = "_type";
const string AREA_TAGS       = "_areatags";
const string ACTIVE_PLAYERS  = "_activeplayers";
const string QUEST_TYPE      = "_questtype";

// Quest type constants
const string RETRIEVE        = "RETRIEVE";
const string KILL            = "KILL";
const string MESSENGER       = "MESSENGER";
const string HELP            = "HELP";
const string PATROL          = "PATROL";
const string CULL            = "CULL";

const string AREA_LIST       = "AREA_LIST";
const string KILL_COUNT      = "RQST_KILL_COUNT";

// Returns TRUE if the PC's current quest is complete. 
int IsQuestComplete(object oPC, int bFinish = FALSE);
// Returns 1 if the PC has completed their current quest for oNPC, and rewards
// the PC appropriately.
int QuestIsDone(object oPC, object oNPC);
// Reset all information pertaining to the current quest oPC is doing for oNPC.
// oPC will now not be doing a quest for oNPC.
void TidyQuest(object oPC, object oNPC);
// Set up everything for the quest assigned to the PC.
void SetUpQuest(object oPC, object oNPC);
// Pick a new quest for this PC. Return value on error: "".
string GenerateNewQuest(object oPC, object oNPC);
// Creates a quest NPC in the marked location.
void CreateQuestNPC(string sNPCTag);
// Called in area OnEnter script to check if the PC is meant to be patrolling
// this area, and to record it if so.
void CheckIfOnPatrol(object oPC, object oArea);
// Returns TRUE if this PC has active players still waiting for them.
int GetHasActivePlayers(object oNPC);
// Is oPC registered with sNPCTag?
int GetIsPlayerActive(object oPC, string sNPCTag);
// Does sNPCTag have players registered with it?
int GetHasActivePlayers(object oNPC);
// Register that oPC is no longer active with sNPCTag
void PlayerNoLongerActive(object oPC, string sNPCTag);
// Register that oPC is active with sNPCTag
void PlayerIsActive(object oPC, string sNPCTag);
// Check whether oPC is active with sNPCTag
int GetIsPlayerActive(object oPC, string sNPCTag);
// Check whether oPC has done sQuest with oQuestNPC
int HasDoneRandomQuest(object oPC, string sQuest, object oQuestNPC = OBJECT_SELF);
// Mark sQuest as having been done by oPC for oQuestNPC
void MarkQuestDone(object oPC, string sQuest, object oQuestNPC = OBJECT_SELF);
// Called at startup and every game day to update the quest targets for repeatable quests.
void UpdateRepeatableQuests();

void CreateQuestNPC(string sNPCTag)
{
  Trace(RQUEST, "Spawning NPC: " + sNPCTag);
  object oWaypoint = GetObjectByTag("WP_"+sNPCTag+"_SPAWN");

  if (oWaypoint == OBJECT_INVALID)
  {
    Trace(RQUEST, "Could not find spawn waypoint for NPC." + sNPCTag);
    return;
  }

  object oNPC = CreateObject(OBJECT_TYPE_CREATURE, sNPCTag, GetLocation(oWaypoint));
  SetLocalObject(oNPC, "HOME_WP", oWaypoint);
}

// Returns GetPCPlayerName(oPC)+GetName(oPC)
string GetPCIdentifier(object oPC)
{
  return GetPCPlayerName(oPC)+GetName(oPC, TRUE);
}

void RemovePCFromActiveList(object oPC, string sTag)
{
  Trace(RQUEST, "Marking player as no longer active on " + sTag);
  string sActivePlayers = GetPersistentString(OBJECT_INVALID,
                                              sTag+ACTIVE_PLAYERS);
  Trace(RQUEST, "Current active player list for "+sTag+" is "+sActivePlayers);

  int nIndex = FindSubString(sActivePlayers, ":" + GetPCIdentifier(oPC) + ":");
  if (nIndex > -1)
  {
    // PC exists, remove them
    string sLeft = GetStringLeft(sActivePlayers, nIndex);
    string sRight = GetStringRight(sActivePlayers,
                      GetStringLength(sActivePlayers) -
                          (nIndex + GetStringLength(GetPCIdentifier(oPC)) + 2));

    string sNew = sLeft + sRight;
    Trace(RQUEST, "Updating active player list for "+sTag+" to "+sNew);
    SetPersistentString(OBJECT_INVALID, sTag+ACTIVE_PLAYERS, sNew);
  }

}

void AddPCToActiveList(object oPC, string sTag)
{
  Trace(RQUEST, "Marking player as active on " + sTag);

  string sActivePlayers = GetPersistentString(OBJECT_INVALID,
                                              sTag+ACTIVE_PLAYERS);
  Trace(RQUEST, "Current active player list for "+sTag+" is "+sActivePlayers);

  int nIndex = FindSubString(sActivePlayers, ":" + GetPCIdentifier(oPC) + ":");
  if (nIndex == -1)
  {
    // PC doesn't exist, add them.
    string sNew = sActivePlayers + ":" + GetPCIdentifier(oPC) + ":";
    Trace(RQUEST, "Updating active player list for "+sTag+" to "+sNew);
    SetPersistentString(OBJECT_INVALID, sTag+ACTIVE_PLAYERS, sNew);
  }
}

int GetHasActivePlayers(object oNPC)
{
  string sTag = GetTag(oNPC);
  string sActivePlayers = GetPersistentString(OBJECT_INVALID,
                                              sTag+ACTIVE_PLAYERS);
  Trace(RQUEST, "Current active player list for "+sTag+" is "+sActivePlayers);

  if (sActivePlayers == "")
  {
    Trace(RQUEST, "NPC "+sTag+" has no active players.");
    return FALSE;
  }
  else
  {
    Trace(RQUEST, "NPC "+sTag+" has active players.");
    return TRUE;
  }
}

/*  Functions to keep track of multiple PCs using an NPC for quests. */

void PlayerNoLongerActive(object oPC, string sNPCTag)
{
  RemovePCFromActiveList(oPC, sNPCTag);
}

void PlayerIsActive(object oPC, string sNPCTag)
{
  Trace(RQUEST, "Marking player as active on NPC "+sNPCTag+" and creating if necessary");
  object oNPC = GetObjectByTag(sNPCTag);

  if (!GetIsObjectValid(oNPC))
  {
    Trace(RQUEST, "NPC not found with this tag. Creating them.");
    CreateQuestNPC(sNPCTag);
  }
  else
  {
    Trace(RQUEST, "NPC already exists.");
  }

  AddPCToActiveList(oPC, sNPCTag);
}

int GetIsPlayerActive(object oPC, string sNPCTag)
{
  Trace (RQUEST, "Checking if player is active on NPC");
  string sActivePlayers = GetPersistentString(OBJECT_INVALID,
                                              sNPCTag+ACTIVE_PLAYERS);
  if (FindSubString(sActivePlayers, GetPCPlayerName(oPC)+GetName(oPC, TRUE)) > -1)
  {
    Trace(RQUEST, "Returning TRUE.");
    return TRUE;
  }
  else
  {
    Trace(RQUEST, "Returning FALSE.");
    return FALSE;
  }
}

void DestroyNPCIfInactive(string sNPCTag)
{
  Trace(RQUEST, "Checking whether we can remove NPC");
  string sActivePlayers = GetPersistentString(OBJECT_INVALID,
                                              sNPCTag+ACTIVE_PLAYERS);
  Trace(RQUEST, "Current active player list for NPC "+sNPCTag+" is "+sActivePlayers);

  object oNPC = GetObjectByTag(sNPCTag);
  if ((sActivePlayers == "") && GetIsObjectValid(oNPC))
  {
    DestroyObject(oNPC);
    RemovePersistentPerson(GetObjectByTag("WP_"+sNPCTag+"_SPAWN"), GetResRef(oNPC));
  }
}

/* Functions to keep track of PCs in patrol areas. */
void ParseAreaList(string sAreaList)
{
  DeleteList(AREA_LIST);

  int nPos = FindSubString(sAreaList, ",");

  if (nPos == -1)
  {
    nPos = GetStringLength(sAreaList);
  }

  string sAreaTag = GetSubString(sAreaList, 0, nPos);

  while (sAreaTag != "")
  {
    object oArea = GetObjectByTag(sAreaTag);
    if (GetIsObjectValid(oArea))
    {
      AddStringElement(sAreaTag, AREA_LIST);
    }
    else
    {
      Trace(RQUEST, "Invalid area: " + sAreaTag);
    }

    sAreaList = GetSubString(sAreaList, nPos + 1,
                             GetStringLength(sAreaList) - nPos -1);

    nPos = FindSubString(sAreaList, ",");
    if (nPos == -1)
    {
      nPos = GetStringLength(sAreaList);
    }
	
    sAreaTag = GetSubString(sAreaList, 0, nPos);
  }
}


void DontWaitForPC(object oPC, string sAreaList)
{
  ParseAreaList(sAreaList);

  string sAreaTag = GetFirstStringElement(AREA_LIST);

  while(sAreaTag != "")
  {
    RemovePCFromActiveList(oPC, sAreaTag);

    sAreaTag = GetNextStringElement();
  }
}

void WaitForPC(object oPC, string sAreaList)
{
  ParseAreaList(sAreaList);

  string sAreaTag = GetFirstStringElement(AREA_LIST);

  while(sAreaTag != "")
  {
    AddPCToActiveList(oPC, sAreaTag);

    sAreaTag = GetNextStringElement();
  }
}

void RemovePatrolVariables(object oPC, string sAreaList)
{
  ParseAreaList(sAreaList);

  string sAreaTag = GetFirstStringElement(AREA_LIST);

  while(sAreaTag != "")
  {
    DeletePersistentVariable(oPC, sAreaTag);

    sAreaTag = GetNextStringElement();
  }
}

void CheckIfOnPatrol(object oPC, object oArea)
{
  Trace(RQUEST, "Checking whether PC "+GetName(oPC, TRUE)+" has been told to patrol "+GetName(oArea));
  string sQuest = GetPersistentString(oPC, CURRENT_QUEST);
  if (sQuest == "") return;
  string sQuestSet =  GetPersistentString(oPC, sQuest);

  string sVarsDB   = sQuestSet + QUEST_VAR_DB;
  
  object oCache = miDAGetCacheObject(sVarsDB);

  string sAreaList = GetLocalString(oCache, sQuest+AREA_TAGS);
  Trace(RQUEST, "PC's list of areas to patrol is: " + sAreaList);

  if (sAreaList != "")
  {
    if (FindSubString(sAreaList, GetTag(oArea)) > -1)
    {
      Trace(RQUEST, "Marking area as patrolled.");
      SetPersistentInt(oPC,GetTag(oArea),1);
    }
  }
}

void RewardPC(object oPC, object oNPC)
{
  Trace(RQUEST, "Rewarding PC " + GetName(oPC, TRUE));
  // setup.
  string sQuest = GetPersistentString(oPC, CURRENT_QUEST);
  if (sQuest == "") return; // No quest, so mark as complete so PC can get
                            // another one (graceful handling).

  string sQuestSet = GetLocalString(oNPC, QUEST_DB_NAME);

  if (sQuestSet == "")
  {
    Trace(RQUEST, "No QUEST_DB_NAME var found on NPC!");
    SendMessageToPC(oPC,
                    "You've found a bug. This NPC isn't set up correctly.");
    return;
  }

  // Databases.
  string sVarsDB   = sQuestSet + QUEST_VAR_DB;
  
  object oCache = miDAGetCacheObject(sVarsDB);
  // end setup.

  int nGold = StringToInt(GetLocalString(oCache, sQuest+REWARD_GOLD));
  if (nGold > 0)
  {
    GiveGoldToCreature(oPC, nGold);
  }

  int nXP = StringToInt(GetLocalString(oCache, sQuest+REWARD_XP));
  if (nXP > 0)
  {
    float fXP = IntToFloat(nXP);
    // Module-wide XP scale control.
    float fMultiplier = GetLocalFloat(GetModule(), "XP_RATIO");

    if (fMultiplier == 0.0) fMultiplier = 1.0;

    fXP *= fMultiplier;
    GiveXPToCreature(oPC, FloatToInt(fXP));
  }

  int nFacRep = StringToInt(GetLocalString(oCache, sQuest+REWARD_FAC_REP));
  if (nFacRep > 0)
  {
    // Give rep points with the House to everyone in the party.
    GiveRepPoints(oPC, nFacRep, CheckFactionNation(oNPC), TRUE);
  }

  int nGloRep = StringToInt(GetLocalString(oCache, sQuest+REWARD_GLO_REP));
  if (nGloRep > 0)
  {
    GiveRepPoints(oPC, nGloRep);
  }

  string sItemTag = GetLocalString(oCache, sQuest+REWARD_ITEM);
  if (sItemTag != "")
  {
    CreateItemOnObject(sItemTag, oPC);
  }
}

int IsQuestComplete(object oPC, int bFinish = FALSE)
{
  // Returns TRUE if the PC has completed their current quest.
  Trace(RQUEST, "Checking if quest is completed.");
  // setup.
  string sQuest = GetPersistentString(oPC, CURRENT_QUEST);
  if (sQuest == "") return 1; // No quest, so mark as complete so PC can get
                              // another one (graceful handling).
							  
  string sQuestSet = GetPersistentString(oPC, sQuest);

  if (sQuestSet == "")
  {
    Trace(RQUEST, "No QUEST_DB_NAME var found on NPC!");
    SendMessageToPC(oPC,
                    "You've found a bug. This NPC isn't set up correctly.");
    return 1;
  }

  // Databases.
  string sVarsDB   = sQuestSet + QUEST_VAR_DB;
  
  object oCache = miDAGetCacheObject(sVarsDB);
  // end setup.

  int nDone = 0;

  string sQuestType = GetLocalString(oCache, sQuest + QUEST_TYPE);
  Trace(RQUEST, "Got quest type of: " + sQuestType);

  if (sQuestType == RETRIEVE)
  {
    string sItemTag = GetLocalString(oCache, sQuest+ITEM_TAG);
    int nNum = StringToInt(GetLocalString(oCache, sQuest+NUM_ITEMS));
    if (nNum == 0)
    {
      Trace(RQUEST, "Number not specified, default to 1.");
      nNum = 1;
    }
    Trace(RQUEST, "Checking retrieve quest, tag: "+sItemTag+", number: " + IntToString(nNum));
    int nCount = 0;

    object oItem = GetFirstItemInInventory(oPC);
    while (oItem != OBJECT_INVALID)
    {
      if (ConvertedStackTag(oItem) == sItemTag)
      {
        nCount+= GetItemStackSize(oItem);
      }

      oItem = GetNextItemInInventory(oPC);
    }

    if (nCount < nNum)
    {
      nDone = 0;
    }
    else
    {
      nDone = 1;

      // Remove the items.
	  if (bFinish)
	  {
        nCount = 0;
	  
	    oItem = GetFirstItemInInventory(oPC);
        while (oItem != OBJECT_INVALID && nCount < nNum)
        {
          if (ConvertedStackTag(oItem) == sItemTag)
          {
            nCount += GetItemStackSize(oItem); // doesn't matter if we overshoot
		    gsCMReduceItem(oItem, nNum);
          }

          oItem = GetNextItemInInventory(oPC);
        }
      }		
    }
  }
  else if (sQuestType == KILL)
  {
    string sNPC = GetLocalString(oCache, sQuest+TARGET_TAG);
    object oTarget = GetObjectByTag(sNPC);
    if (!GetIsObjectValid(oTarget) || !GetIsPlayerActive(oPC, sNPC))
    {
      nDone = 1;
    }
  }
  else if (sQuestType == MESSENGER)
  {
    string sItemToBring = GetLocalString(oCache, sQuest+ITEM_TO_BRING);

    if (sItemToBring != "")
    {
      // If the PC has the item they were sent to get, they're done.
      object oItem = GetItemPossessedBy(oPC, sItemToBring);

      if (GetIsObjectValid(oItem))
      {
        if (bFinish) DestroyObject(oItem);
        nDone = 1;
      }
    }
    else
    {
      // If the PC hasn't got the item they left with, they're done.
      string sItemToGive = GetLocalString(oCache, sQuest+ITEM_TO_GIVE);
      object oItem = GetItemPossessedBy(oPC, sItemToGive);

      if (!GetIsObjectValid(oItem))
      {
        nDone = 1;
      }
    }
  }
  else if (sQuestType == HELP)
  {
    nDone = IsQuestDoneByName(sQuest, oPC);
  }
  else if (sQuestType == PATROL)
  {
    string sAreaList = GetLocalString(oCache, sQuest+AREA_TAGS);
	ParseAreaList(sAreaList);
	
    string sArea = GetFirstStringElement(AREA_LIST);
    nDone = 1;
	int status;
	
    while (sArea != "")
    {
	  status = GetPersistentInt(oPC, sArea);
      Trace(RQUEST, "Checking area variable for PC: " + sArea + " : " + IntToString(status));
      if (!status)
      {
        nDone = 0;
      }

      sArea = GetNextStringElement();
    }

    if (nDone && bFinish)
    {
      // Clear all the area variables in case the PC is asked to go again.
      string sArea = GetFirstStringElement(AREA_LIST);
      while (sArea != "")
      {
        Trace(RQUEST, "Removing area variable for PC: " + sArea);
        DeletePersistentVariable(oPC, sArea);
        sArea = GetNextStringElement();
      }
    }
  }
  else if (sQuestType == CULL)
  {
    int nKillCount = GetLocalInt(gsPCGetCreatureHide(oPC), KILL_COUNT);
	
	nDone = !nKillCount;
  }
  else
  {
    SendMessageToPC(oPC,
                    "You've found a bug. Invalid quest type.");
    Trace(RQUEST, "!!!Invalid quest type!");
  }
  
  return nDone;
}

int QuestIsDone(object oPC, object oNPC)
{
  int nDone = IsQuestComplete(oPC, TRUE);

  // Reward if quest completed.
  if (nDone) RewardPC(oPC, oNPC);

  // Cleanup if done.
  if (nDone) TidyQuest(oPC, oNPC);
  return nDone;
}

void TidyQuest(object oPC, object oNPC)
{
  Trace(RQUEST, "Tidying up current quest for " + GetName(oPC, TRUE));
  // setup.
  string sQuest = GetPersistentString(oPC, CURRENT_QUEST);
  if (sQuest == "") return; // Nothing to do, no quest active.

  string sQuestSet = GetLocalString(oNPC, QUEST_DB_NAME);

  if (sQuestSet == "")
  {
    Trace(RQUEST, "No QUEST_DB_NAME var found on NPC!");
    SendMessageToPC(oPC,
                    "You've found a bug. This NPC isn't set up correctly.");
    return;
  }

  // Databases.
  string sVarsDB   = sQuestSet + QUEST_VAR_DB;
  
  object oCache = miDAGetCacheObject(sVarsDB);
  // end setup.

  // Remove NPCs spawned, if they exist and are not in use by another PC.
  string sNPC = GetLocalString(oCache, sQuest+OTHER_NPC);
  if (sNPC != "")
  {
    // Check that no other players are using the NPC and delete if not..
    PlayerNoLongerActive(oPC, sNPC);
    DestroyNPCIfInactive(sNPC);
  }

  sNPC = GetLocalString(oCache, sQuest+TARGET_TAG);
  if (sNPC != "")
  {
    // Check that no other players are using the NPC and delete if not..
    PlayerNoLongerActive(oPC, sNPC);
    DestroyNPCIfInactive(sNPC);
  }

  // Remove item from PC if they were given one.
  string sItemGiven = GetLocalString(oCache, sQuest+ITEM_TO_GIVE);
  if  (sItemGiven != "")
  {
    object oItem = GetItemPossessedBy (oPC, sItemGiven);
    DestroyObject(oItem);
  }

  // Tell areas not to expect a visit from this PC.
  string sAreaList = GetLocalString(oCache, sQuest+AREA_TAGS);
  if (sAreaList != "")
  {
    RemovePatrolVariables(oPC, sAreaList);
  }

  // Mark quest as done for this PC, if it's not a repeatable one. 
  if (GetLocalString(oCache, sQuest + IS_REPEATABLE) == "")
  {
    MarkQuestDone(oPC, sQuest);
  }	
  else
  {
    // Put a flag on the PC hide so that they don't try the same quest again for 20 RL hours.
	SetLocalInt(gsPCGetCreatureHide(oPC), sQuest, gsTIGetActualTimestamp() + 3600 * 20);
  }

  // Remove the quest vars from the PC.
  DeletePersistentVariable(oPC, CURRENT_QUEST);
  DeletePersistentVariable(oPC, sQuest);
}

void SetUpQuest(object oPC, object oNPC)
{
  Trace (RQUEST, "Setting up new quest for " + GetName(oPC, TRUE));
  // setup.
  // Todo - tag the quest with the questtag so that PCs can have multiple.
  string sQuest = GetPersistentString(oPC, CURRENT_QUEST);
  if (sQuest == "") return; // Nothing to do, no quest active.

  string sQuestSet = GetLocalString(oNPC, QUEST_DB_NAME);

  if (sQuestSet == "")
  {
    Trace(RQUEST, "No QUEST_DB_NAME var found on NPC!");
    SendMessageToPC(oPC,
                    "You've found a bug. This NPC isn't set up correctly.");
    return;
  }

  // Databases.
  string sQuestDB  = sQuestSet + QUEST_DB;
  string sVarsDB   = sQuestSet + QUEST_VAR_DB;
  
  object oCache = miDAGetCacheObject(sVarsDB);
  // end setup.

  // Give item to PC if needed
  string sItemGiven = GetLocalString(oCache, sQuest+ITEM_TO_GIVE);
  if  (sItemGiven != "")
  {
    CreateItemOnObject (sItemGiven, oPC);
  }

  // Create NPCs if any
  string sNPC = GetLocalString(oCache, sQuest+OTHER_NPC);
  if (sNPC != "")
  {
    //Tell the NPC to hang around for the PC.
    PlayerIsActive(oPC, sNPC);

    // Make the NPC persistent.
    AddPersistentPerson(GetObjectByTag("WP_"+sNPC+"_SPAWN"), sNPC, FALSE);

    if (sItemGiven != "")
    {
      // Add a variable to the NPC we've just created.
      SetPersistentString(GetObjectByTag(sNPC), "quest1item1", sItemGiven);
    }

    string sItemToBring = GetLocalString(oCache, sQuest+ITEM_TO_BRING);
    if (sItemToBring != "")
    {
      // Add a variable to the NPC we've just created.
      SetPersistentString(GetObjectByTag(sNPC), "quest1item2", sItemGiven);
    }
  }

  // Victim?
  sNPC = GetLocalString(oCache, sQuest+TARGET_TAG);
  if (sNPC != "")
  {
    //Tell the NPC to hang around for the PC.
    PlayerIsActive(oPC, sNPC);

    // Make the NPC persistent.
    AddPersistentPerson(GetObjectByTag("WP_"+sNPC+"_SPAWN"), sNPC, FALSE);
  }

  if (GetLocalString(oCache, sQuest + QUEST_TYPE) == HELP)
  {
    // Note the quest as started.
    SetPersistentInt(oPC, sQuest, 1, 0, DB_MISC_QUESTS);
  }
  
  // Set the target kill count.
  if (StringToInt(GetLocalString(oCache, sQuest + NUM_CREATURES)))
  {
    SetLocalInt(gsPCGetCreatureHide(oPC), KILL_COUNT, StringToInt(GetLocalString(oCache, sQuest + NUM_CREATURES)));
	SetLocalString(gsPCGetCreatureHide(oPC), CULL_TAG, GetLocalString(oCache, sQuest + CULL_TAG));
  }

  // Done.
}

// Get a new quest suitable for this PC. Return value on error: "".
string GenerateNewQuest(object oPC, object oNPC)
{
  Trace(RQUEST, "Generating new quest for " + GetName(oPC, TRUE));
  string sQuestSet = GetLocalString(oNPC, QUEST_DB_NAME);
  string sQuest = "";

  if (sQuestSet == "")
  {
    Trace(RQUEST, "No QUEST_DB_NAME var found on NPC!");
    SendMessageToPC(oPC,
                    "You've found a bug. This NPC isn't set up correctly.");
    return sQuest;
  }

  // Databases.
  string sQuestDB  = "rquest_quests";
  string sVarsDB   = sQuestSet + QUEST_VAR_DB;
  string sLevel    = IntToString(GetHitDice(oPC));
  
  object oCache = miDAGetCacheObject(sVarsDB);

  int nCount = 0;

  // Get all quests for this provider where we are within the level range.
  string sSQL = "SELECT quest FROM " + sQuestDB + " WHERE questset='" + sQuestSet + 
    "' AND minlevel <= '" + sLevel + "' AND maxlevel >= '" + sLevel + "' ORDER BY RAND()";
  SQLExecDirect(sSQL);

  // Save them in a list so we can make another query to check whether each has been done.
  DeleteList(sQuestDB);
  
  while (SQLFetch() == SQL_SUCCESS)
  {
    AddStringElement(SQLGetData(1), sQuestDB);
  }

  string sQuestToTry = GetFirstStringElement(sQuestDB);

  while (sQuestToTry != "")
  {
    Trace(RQUEST, "Got quest: " + sQuestToTry);

    // Is this quest suitable for this PC?
    // Has the PC done it?
    if (!HasDoneRandomQuest(oPC, sQuestToTry))
    {
      // PC hasn't already done this quest.
      Trace (RQUEST, "PC hasn't already done quest, selecting quest.");
	  sQuest = sQuestToTry;
    }	
	
	nCount++;
    sQuestToTry = GetStringElement(nCount, sQuestDB);
  }  

  if (sQuest == "")
  {
     // No valid quest found.
     Trace(RQUEST, "Found no available quests.");
     return "";
  }
  else
  {
    // We found a valid quest. Save the new quest on the PC, and return.
    SetPersistentString(oPC, CURRENT_QUEST, sQuest);
	
    // Save a var on the PC linking the quest to a quest set, in case we need
    // to look up details later.
    SetPersistentString(oPC, sQuest, sQuestSet);

    return sQuest;
  }
}

int HasDoneRandomQuest(object oPC, string sQuest, object oQuestNPC = OBJECT_SELF)
{ 
  string sSQL = "SELECT pcid FROM " + QUEST_PLAYER_DB + " WHERE quest = '" + sQuest + "' AND pcid = '" + 
   gsPCGetPlayerID(oPC) + "' AND questset = '" + GetLocalString(oQuestNPC, QUEST_DB_NAME) + "'";
   
  SQLExecDirect(sSQL);
  
  if (SQLFetch())
  {
    Trace(RQUEST, "PC has already done non-repeatable quest " + sQuest);
    return TRUE;
  }
  
  // Check whether this is a repeatable quest that they have done in the last day.
  // Use a 20 hour timeout so that someone can play at the same time each day.
  int nTimestamp = GetLocalInt(gsPCGetCreatureHide(oPC), sQuest);
  if (nTimestamp > gsTIGetActualTimestamp())
  {
    // Check for time reversal.  
	if (nTimestamp > (gsTIGetActualTimestamp() + 60 * 60 * 24))
	{
	  // Timestamp is more than a day in the future, time has gone back.  Reset.
	  DeleteLocalInt(gsPCGetCreatureHide(oPC), sQuest);
	  Trace(RQUEST, "Time has gone backwards! Resetting variable.");
	  return FALSE;
	}
	
    Trace(RQUEST, "PC has recently done repeatable quest " + sQuest);
    return TRUE;
  }
  
  return FALSE;  
}

void MarkQuestDone(object oPC, string sQuest, object oQuestNPC = OBJECT_SELF)
{
  string sSQL = "INSERT INTO " + QUEST_PLAYER_DB + " (pcid,quest,questset) VALUES ('" + gsPCGetPlayerID(oPC) + 
   "','" + sQuest + "','" + GetLocalString(oQuestNPC, QUEST_DB_NAME) + "')";
   
  SQLExecDirect(sSQL);
  
  // Doesn't matter if this fails (i.e. if the quest was already marked done). 
}

void SetStringValue(string sName, string sValue, string sDatabase)
{
  object oCache = miDAGetCacheObject(sDatabase);
  SetLocalString(oCache, sName, sValue);
}

void UpdateRepeatableQuests()
{
  //----------------------------------------------------------------------------------------------------------------------
  // Renerrin
  string DB_VARS;
  string QUEST;
  
  DB_VARS  = "renerrin_vars";
  QUEST = "gather_gemstone"; // 4-10
  SetStringValue(QUEST+QUEST_TYPE, RETRIEVE, DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "50", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "150", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);
  
  switch (d3())
  {
    case 1:
	case 2:
		SetStringValue(QUEST+DESCRIPTION,
					   "I need a gemstone, a phenalope. Can you get me one? I'll give you 50 gold for it.",
					   DB_VARS);
		SetStringValue(QUEST+ITEM_TAG, "NW_IT_GEM004", DB_VARS);
		break;
	case 3:
		SetStringValue(QUEST+DESCRIPTION,
					   "Hm, I have use of a polished malachite.  A simple thing, can you get me one please?\n\n" +
					   "(You can polish gemstones at a jeweler's bench.)",
					   DB_VARS);
		SetStringValue(QUEST+ITEM_TAG, "cow_gemmala", DB_VARS);
		break;
  }
  
  QUEST = "badger_skin"; // 3-6
  SetStringValue(QUEST+QUEST_TYPE, RETRIEVE, DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "75", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "25", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);
  
  switch (d3())
  {
    case 1:
		SetStringValue(QUEST+DESCRIPTION,
					   "My wife got a badger skin muff, and now everyone wants one.  Please get me three skins.  " + 
					   "There are usually badgers outside the West Gates, if you hunt around - you'll need a " +
					   "skinning knife to part them from their fur.  Try the Market Square if you don't have one.",
					   DB_VARS);
		SetStringValue(QUEST+ITEM_TAG, "cnrskinbadger", DB_VARS);
		SetStringValue(QUEST+NUM_ITEMS, "3", DB_VARS);
		break;
	case 2:
		SetStringValue(QUEST+DESCRIPTION,
					   "One of my other helpers is going to make me a leather cloak, and needs the skin of a deer.  " +
					   "You'll need to hunt around outside the west gates, maybe into the woods. Don't forget to " +
					   "take a skinning knife, you can acquire one in the market square if you need to.",
					   DB_VARS);
		SetStringValue(QUEST+ITEM_TAG, "cnrskindeer", DB_VARS);
		SetStringValue(QUEST+NUM_ITEMS, "1", DB_VARS);
		break;
	case 3:
		SetStringValue(QUEST+DESCRIPTION,
					   "Wood is used for a range of different crafts.  Fetch five Irl branches " +
					   "which our carpenters can use.  You'll need to head outside the city to find it, and " +
					   "if you are not proficient with axes, pick up a Crafter's Apron from the crafthall.",
					   DB_VARS);
		SetStringValue(QUEST+ITEM_TAG, "cnrbranch1", DB_VARS);		
		SetStringValue(QUEST+NUM_ITEMS, "5", DB_VARS);
		break;
  }
  
  QUEST = "cull_spiders"; // 6-8
  SetStringValue(QUEST+QUEST_TYPE, CULL, DB_VARS);
  SetStringValue(QUEST+NUM_CREATURES, "12", DB_VARS);  
  SetStringValue(QUEST+REWARD_GOLD, "100", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "100", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);
  
  switch (d3())
  {
    case 1:
	case 2:
		SetStringValue(QUEST+DESCRIPTION, "Below the northern part of the Undercity you will find a large spider nest. " +
		"The spiders are big enough to carry off unwary denizens, so I would like you to cull a dozen of them, please.", DB_VARS);
		SetStringValue(QUEST+CULL_TAG, "av_DeepSpiders", DB_VARS);
		break; 
	case 3:
		SetStringValue(QUEST+DESCRIPTION, "There are some dark caverns below the Undercity, easiest reached from the caves in " +
		  "the northwest.  A tribe of dark-skinned goblins there sometimes emerge to prey on the populace.  Cull a dozen of them and return here.", DB_VARS);
		SetStringValue(QUEST+CULL_TAG, "blackgoblin", DB_VARS);
		break; 
  }
  
  QUEST = "cull_cutthroats"; // 9-10
  SetStringValue(QUEST+QUEST_TYPE, CULL, DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "200", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "200", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);
  SetStringValue(QUEST+NUM_CREATURES, "20", DB_VARS);  
  
  switch (d3())
  {
    case 1:
	case 2:
		SetStringValue(QUEST+DESCRIPTION, "The Undercity has a bad crime problem.  The Imperial Guard do not have the resources " +
		"to patrol there, so I want you to bring some justice.  Go down there and look like a mark, and deal with any dog who takes the bait. " +
		"Come back when you've dealt with 20 or more.", DB_VARS);
		SetStringValue(QUEST+CULL_TAG, "cutthroat", DB_VARS);
		break;
	case 3:
		SetStringValue(QUEST+DESCRIPTION, "There is a Formian hive somewhere beneath the undercity; our scouts have reported sightings when " +
		"harvesting silk from the spiders.  Find it and take out 20 of their workers; that should keep them from expanding into our silk supply.", DB_VARS);
		SetStringValue(QUEST+CULL_TAG, "X0_FORM_WORKER", DB_VARS);
		break;
  }
  
  QUEST = "more_gonnes"; // 11-15
  SetStringValue(QUEST+QUEST_TYPE, RETRIEVE, DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "250", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);
  
  switch (d3())
  {
    case 1:
		SetStringValue(QUEST+REWARD_XP, "250", DB_VARS);
		SetStringValue(QUEST+DESCRIPTION,
		"Our House wishes to stockpile more firearms.  Please bring me another Gonne.",
		DB_VARS);
		SetStringValue(QUEST+ITEM_TAG, "Gonne", DB_VARS);
		SetStringValue(QUEST+NUM_ITEMS, "1", DB_VARS);
		break;
	case 2:
	case 3:
		SetStringValue(QUEST+REWARD_XP, "100", DB_VARS);
		SetStringValue(QUEST+DESCRIPTION,
		"The best agents are able to surgically remove potential threats.  Bring back two " +
		"heads of enemy leaders.",
		DB_VARS);
		SetStringValue(QUEST+ITEM_TAG, "GS_HEAD_EVIL", DB_VARS);
		SetStringValue(QUEST+NUM_ITEMS, "2", DB_VARS);
		break;
  }
  
  //----------------------------------------------------------------------------------------------------------------------
  // Drannis  
  DB_VARS  = "drannis_vars";
    
  QUEST = "gather_ond"; // 3-6
  SetStringValue(QUEST+QUEST_TYPE, RETRIEVE, DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "50", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "50", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);
  
  switch (d3())
  {
    case 1:
	case 2:
		SetStringValue(QUEST+DESCRIPTION,
			"Maintaining our outposts always takes more wood.  Fetch five Irl branches " +
			"which our carpenters can use.  You'll need to head outside the city to find it, and " +
			"if you are not proficient with axes, pick up a Crafter's Apron from the crafthall.",
			DB_VARS);
		SetStringValue(QUEST+ITEM_TAG, "cnrbranch1", DB_VARS);
		SetStringValue(QUEST+NUM_ITEMS, "5", DB_VARS);
		break;
	case 3:
		SetStringValue(QUEST+DESCRIPTION,
			"Ondaran does not make good weapons, but it makes excellent nails " +
			"and braces.  Since I have nothing more pressing for you right now, " +
			"bring back a couple of nuggets for our stores.  You'll need to head to " + 
			"a mine, most likely up among the Skyreach Summits, and " +
			"if you are not proficient with axes, pick up a Crafter's Apron from the crafthall.",
			DB_VARS);
		SetStringValue(QUEST+ITEM_TAG, "cnrnuggetond", DB_VARS);
		SetStringValue(QUEST+NUM_ITEMS, "2", DB_VARS);
		break;
  }
   
  QUEST = "gather_wood"; // 4-10
  SetStringValue(QUEST+QUEST_TYPE, RETRIEVE, DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "50", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "50", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);

  switch (d3())
  {
    case 1:
		SetStringValue(QUEST+DESCRIPTION,
			"Every soldier should have a basic grounding in trade skills.  Bring me five planks of Irl for our stores.  " +
			"You can make them easily enough from Irl branches at a carpenter's bench.",
			DB_VARS);
		SetStringValue(QUEST+ITEM_TAG, "cnrplank1", DB_VARS);
		SetStringValue(QUEST+NUM_ITEMS, "5", DB_VARS);
		break;
	case 2:
		SetStringValue(QUEST+DESCRIPTION,
			"Every soldier should have a basic grounding in trade skills.  Bring me five ingots of Ondaran for our stores.  " +
			"You can turn the ore into ingots in any public forge.",
			DB_VARS);
		SetStringValue(QUEST+ITEM_TAG, "cnringotond", DB_VARS);
		SetStringValue(QUEST+NUM_ITEMS, "5", DB_VARS);
		break;
	case 3:
		SetStringValue(QUEST+DESCRIPTION,
			"Every soldier should have a basic grounding in trade skills. Bring me two pieces of badger leather.  " +
			"Once you've skinned the blighters, a hide rack is used to process them into leather.  The process uses tanning " +
			"oil, but you can pick that up in the trade hall if need be.",
			DB_VARS);
		SetStringValue(QUEST+ITEM_TAG, "cnrleathbadg", DB_VARS);
		SetStringValue(QUEST+NUM_ITEMS, "2", DB_VARS);
		break;
  }
  
  QUEST = "cull_spiders"; // 6-8
  SetStringValue(QUEST+QUEST_TYPE, CULL, DB_VARS);
  SetStringValue(QUEST+NUM_CREATURES, "12", DB_VARS);  
  SetStringValue(QUEST+REWARD_GOLD, "100", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "100", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);
  
  switch (d3())
  {
    case 1:
		SetStringValue(QUEST+DESCRIPTION, "Below the northern part of the Undercity you will find a large spider nest. " +
		"The spiders are big enough to carry off unwary denizens, so I would like you to cull a dozen of them, please.", DB_VARS);
		SetStringValue(QUEST+CULL_TAG, "av_DeepSpiders", DB_VARS);
		break; 
	case 2:
	case 3:
		SetStringValue(QUEST+DESCRIPTION, "There are some dark caverns below the Undercity, easiest reached from the caves in " +
		  "the northwest.  A tribe of dark-skinned goblins there sometimes emerge to prey on the populace.  Cull a dozen of them and return here.", DB_VARS);
		SetStringValue(QUEST+CULL_TAG, "blackgoblin", DB_VARS);
		break; 
  }

  QUEST = "cull_taskmasters"; // 9-10
  SetStringValue(QUEST+QUEST_TYPE, CULL, DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "150", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "150", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);
  
  switch (d3())
  {
    case 1:
		SetStringValue(QUEST+DESCRIPTION, "The Undercity has a bad crime problem.  The Imperial Guard do not have the resources " +
		"to patrol there, so I want you to bring some justice.  Go down there and make yourself visible, and deal with any cut-throats that take the bait. " +
		"Come back when you've dealt with 20 or more.", DB_VARS);
		SetStringValue(QUEST+CULL_TAG, "cutthroat", DB_VARS);
		SetStringValue(QUEST+NUM_CREATURES, "20", DB_VARS);  
		break;
	case 2:
	case 3:
		SetStringValue(QUEST+DESCRIPTION, "There is a Formian hive somewhere beneath the Undercity.  Their warriors have been sighted " +
		"scouting out our defenses, and I want you to persuade them to stop.  Kill six of their Taskmasters, that should make them think twice.", DB_VARS);
		SetStringValue(QUEST+CULL_TAG, "av_FormorianTaskmaster", DB_VARS);
		SetStringValue(QUEST+NUM_CREATURES, "6", DB_VARS);  
		break;
  }
  
  QUEST = "boss_heads";  // 5-15
  SetStringValue(QUEST+QUEST_TYPE, RETRIEVE, DB_VARS);
  SetStringValue(QUEST+DESCRIPTION,
   "House Drannis takes the defense of the City very seriously.  Bring back two " +
   "heads of creatures from beneath the City that could pose a threat.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "250", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "100", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "GS_HEAD_EVIL", DB_VARS);
  SetStringValue(QUEST+NUM_ITEMS, "2", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);
  
  //----------------------------------------------------------------------------------------------------------------------
  // Erenia  
  DB_VARS  = "erenia_vars";
  
  QUEST = "more_holywater"; // 3-6
  SetStringValue(QUEST+QUEST_TYPE, RETRIEVE, DB_VARS);
  SetStringValue(QUEST+DESCRIPTION,
   "I've run out of holy water to keep the ghost out of my rooms. " + 
   "Please can you fetch me some more?", DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "50", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "50", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "X1_WMGRENADE005", DB_VARS); 
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);
  
  QUEST = "patrolcrypts"; // 4-10
  SetStringValue(QUEST+QUEST_TYPE, PATROL, DB_VARS);
  SetStringValue(QUEST+DESCRIPTION,
  "Our brethren guarding the Undercity entrance report that the dead are stirring " +
  "in Ancestors' Rest again.  Please visit the four crypts there and restore peace.",
  DB_VARS);
  SetStringValue(QUEST+AREA_TAGS, "DarkenedCrypt,hauntedcrypt,OldCrypt,ShadowedCrypt", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "250", DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "250", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);

  QUEST = "gather_incense"; // 4-10
  SetStringValue(QUEST+QUEST_TYPE, RETRIEVE, DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "600", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "50", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);
  
  switch (d3())
  {
    case 1:
		SetStringValue(QUEST+DESCRIPTION,
			"I'm low on incense. Please can you fetch me a couple of sticks? The temple "
			+ "will have some.",
			DB_VARS);
		SetStringValue(QUEST+ITEM_TAG, "stickofincense", DB_VARS);
		SetStringValue(QUEST+NUM_ITEMS, "2", DB_VARS);
		break;
	case 2:
		SetStringValue(QUEST+DESCRIPTION,
					   "One of my other helpers is going to make me a leather cloak, and needs the skin of a deer.  " +
					   "You'll need to hunt around outside the west gates, maybe into the woods. Don't forget to " +
					   "take a skinning knife, you can acquire one in the market square if you need to.",
					   DB_VARS);
		SetStringValue(QUEST+ITEM_TAG, "cnrskindeer", DB_VARS);
		SetStringValue(QUEST+NUM_ITEMS, "1", DB_VARS);
		break;
	case 3:
		SetStringValue(QUEST+DESCRIPTION,
					   "Wood is used for a range of different crafts.  Fetch five Irl branches " +
					   "which our carpenters can use.  You'll need to head outside the city to find it, and " +
					   "if you are not proficient with axes, pick up a Crafter's Apron from the crafthall.",
					   DB_VARS);
		SetStringValue(QUEST+ITEM_TAG, "cnrbranch1", DB_VARS);		
		SetStringValue(QUEST+NUM_ITEMS, "5", DB_VARS);
		break;
  }

  QUEST = "cull_spiders"; // 6-8
  SetStringValue(QUEST+QUEST_TYPE, CULL, DB_VARS);  
  SetStringValue(QUEST+NUM_CREATURES, "12", DB_VARS); 
  SetStringValue(QUEST+REWARD_GOLD, "100", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "100", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);

  switch (d3())
  {
    case 1:
		SetStringValue(QUEST+DESCRIPTION, "Below the northern part of the Undercity you will find a large spider nest. " +
		"The spiders are big enough to carry off unwary denizens, so I would like you to cull a dozen of them, please.", DB_VARS);
		SetStringValue(QUEST+CULL_TAG, "av_DeepSpiders", DB_VARS);
		break; 
	case 2:
	case 3:
		SetStringValue(QUEST+DESCRIPTION, "Back in the early days of the City we buried the dead in some old tombs in the caves below the northern part " +
		  "of the Undercity.  But it became too dangerous to do funeral processions out there, between the spiders on the way and the ghosts there.  " +
		  "Still, we should not forget the dead.  Please visit the old tombs and banish a dozen of the Spectre ghosts that haunt the area.", DB_VARS);
		SetStringValue(QUEST+CULL_TAG, "NW_SPECTRE", DB_VARS);
		break; 
  }
  
  QUEST = "cull_taskmasters"; // 9-10
  SetStringValue(QUEST+QUEST_TYPE, CULL, DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "150", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "150", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);
  
  switch (d3())
  {
    case 1:
		SetStringValue(QUEST+DESCRIPTION, "The Undercity has a bad crime problem.  The Imperial Guard do not have the resources " +
		"to patrol there, so I want you to bring some justice.  Go down there and make yourself visible, and deal with any cut-throats that take the bait. " +
		"Come back when you've dealt with 20 or more.", DB_VARS);
		SetStringValue(QUEST+CULL_TAG, "cutthroat", DB_VARS);
		SetStringValue(QUEST+NUM_CREATURES, "20", DB_VARS);  
		break;
	case 2:
	case 3:
		SetStringValue(QUEST+DESCRIPTION, "There is a Formian hive somewhere beneath the Undercity.  Their warriors have been sighted " +
		"scouting out our defenses, and I want you to persuade them to stop.  Kill six of their Taskmasters, that should make them think twice.", DB_VARS);
		SetStringValue(QUEST+CULL_TAG, "av_FormorianTaskmaster", DB_VARS);
		SetStringValue(QUEST+NUM_CREATURES, "6", DB_VARS);  
		break;
  }
  
  QUEST = "sanctify"; // 10-15
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);
  
  switch (d3())
  {
    case 1:
		SetStringValue(QUEST+REWARD_XP, "250", DB_VARS);
		SetStringValue(QUEST+QUEST_TYPE, PATROL, DB_VARS);
		SetStringValue(QUEST+DESCRIPTION,
		   "The Shrine to the Emperor in the Western part of the Great Wall is an important part of our spiritual defense against Elven magic.  Please " +
		   "visit it and speak a blessing over the altar.  Should anything be amiss, report it to the Guards nearby.", DB_VARS);
		SetStringValue(QUEST+AREA_TAGS,
						 "GrWallWestWallInt",
						 DB_VARS);
		break;
	case 2:
	case 3:	
		SetStringValue(QUEST+REWARD_GOLD, "250", DB_VARS);
		SetStringValue(QUEST+REWARD_XP, "100", DB_VARS);
		SetStringValue(QUEST+QUEST_TYPE, RETRIEVE, DB_VARS);
		SetStringValue(QUEST+DESCRIPTION,
		"Despite our best efforts, there is still much danger about the city.  Please help secure the populace by bringing in two " +
		"heads of enemy leaders.",
		DB_VARS);
		SetStringValue(QUEST+ITEM_TAG, "GS_HEAD_EVIL", DB_VARS);
		SetStringValue(QUEST+NUM_ITEMS, "2", DB_VARS);
		break;
  }
  
  //----------------------------------------------------------------------------------------------------------------------
  // Wardens
  DB_VARS  = "wardens_vars";
  
  QUEST = "patrol_farms"; // 3-5
  SetStringValue(QUEST+QUEST_TYPE, PATROL, DB_VARS);
  SetStringValue(QUEST+DESCRIPTION,
    "We always need to be watchful against fey incursions into our fields.  Please check on the Home Farms, " +
	"South Farms and West Farms and clear out any wandering fey you see.",
  DB_VARS);
  SetStringValue(QUEST+AREA_TAGS, "PerHomeFarms,PerVilSouthFarms,PerVyvVilWestFarms", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "200", DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "150", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);
  
  QUEST = "patrol_borders"; // 4-6
  SetStringValue(QUEST+QUEST_TYPE, PATROL, DB_VARS);
  SetStringValue(QUEST+DESCRIPTION,
    "Time to go a little further afield.  Please do a patrol of the East, South and Southwest borderland and " +
	"report back on any fey you find.",
  DB_VARS);
  SetStringValue(QUEST+AREA_TAGS, "PerVyvEastBorder,PerVilSouthBorder,PerVyvVilSWBorders", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "250", DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "200", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);
    
  QUEST = "cull_xvarts"; // 4-7
  SetStringValue(QUEST+QUEST_TYPE, CULL, DB_VARS);
  SetStringValue(QUEST+NUM_CREATURES, "6", DB_VARS);  
  SetStringValue(QUEST+REWARD_GOLD, "150", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "150", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);	
  
  switch (d3())
  {
    case 1:
	case 2:
		SetStringValue(QUEST+DESCRIPTION, 
			"A nest of xvarts have settled into the caves above Lake Vyvian.  They occasionally try snatching our kin meditating by the lake; " +
			"I'd like you to put some fear into their warriors so they know not to mess with us.  Killing half a dozen should do the trick.", 
			DB_VARS);
		SetStringValue(QUEST+CULL_TAG, "xvart", DB_VARS);
		break;
	case 3:
		SetStringValue(QUEST+DESCRIPTION, 
			"There is a tribe of troglodytes settled in part of the cave complex above Lake Vyvian.  They are annoying the elementals there " +
			"and to assuage them I'd like you to cull half a dozen of the trog warriors.  Hopefully that will calm the elementals for now.", 
			DB_VARS);
		SetStringValue(QUEST+CULL_TAG, "trog_warrior", DB_VARS);
		break;
	
  }
  
  QUEST = "cull_goblin_boss"; // 8-10
  SetStringValue(QUEST+QUEST_TYPE, CULL, DB_VARS);
  SetStringValue(QUEST+NUM_CREATURES, "1", DB_VARS);  
  SetStringValue(QUEST+REWARD_GOLD, "150", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "150", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);	
  
  switch (d3())
  {
    case 1:
	case 2:
		SetStringValue(QUEST+DESCRIPTION, 
			"Night goblins have been reported southwest of town, encroaching onto the borderlands from the Wild Coast.  I need you to find their " +
			"lair and kill their chief.  That should make them descend into infighting and leave us alone.", 
			DB_VARS);
		SetStringValue(QUEST+CULL_TAG, "blackgoblinboss", DB_VARS);
		break;
	case 3:
		SetStringValue(QUEST+DESCRIPTION, 
			"I have a demanding challenge for you today.  One of the trogs in the coastal caves past Lake Vyvian has reached dominance over the others, " +
			"and it's only a matter of time before he sends raiders to Vyvian.  Strike first and eliminate him; that will keep them from encroaching without " +
			"upsetting the Balance.", 
			DB_VARS);
		SetStringValue(QUEST+CULL_TAG, "trog_king", DB_VARS);
		break;    
  }
  
  QUEST = "boss_heads";  // 6-15
  SetStringValue(QUEST+QUEST_TYPE, RETRIEVE, DB_VARS);
  SetStringValue(QUEST+DESCRIPTION,
   "As a Warden, you are expected to help in the defense of the village.  Bring me two heads from creatures that mean us harm.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "300", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "150", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "GS_HEAD_EVIL", DB_VARS);
  SetStringValue(QUEST+NUM_ITEMS, "2", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);
  
  // Fernvale
  DB_VARS  = "fernvale_vars";
  
  QUEST = "cull_goblins"; // 3-4
  SetStringValue(QUEST+QUEST_TYPE, CULL, DB_VARS);
  SetStringValue(QUEST+DESCRIPTION, "The nearby nest of goblins is infected with the plague.  I need you to " +
  "reduce their numbers to keep it from spreading; please destroy six diseased goblins.", DB_VARS);
  SetStringValue(QUEST+CULL_TAG, "diseased_gobbo", DB_VARS);
  SetStringValue(QUEST+NUM_CREATURES, "6", DB_VARS);  
  SetStringValue(QUEST+REWARD_GOLD, "100", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "100", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);
  
  QUEST = "cure_ingredients"; // 4-9
  SetStringValue(QUEST+QUEST_TYPE, RETRIEVE, DB_VARS);
  SetStringValue(QUEST+DESCRIPTION,
   "Keeping the plague from affecting our peoples requires a constant source of cure.  Happily this can be made with " +
   "local ingredients.  Please bring back some ginseng from the foothills to the west.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "100", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "100", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "cnrginsengroot", DB_VARS);
  SetStringValue(QUEST+NUM_ITEMS, "2", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);
  
  QUEST = "cull_zombies"; // 5-7
  SetStringValue(QUEST+QUEST_TYPE, CULL, DB_VARS);
  SetStringValue(QUEST+DESCRIPTION, "South of the village the land is blighted by the past war, and the dead walk.  We must " +
  "keep them from getting too close to the village; please destroy six zombies to keep their numbers down.", DB_VARS);
  SetStringValue(QUEST+CULL_TAG, "NW_ZOMBIE01", DB_VARS);
  SetStringValue(QUEST+NUM_CREATURES, "6", DB_VARS);  
  SetStringValue(QUEST+REWARD_GOLD, "100", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "50", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);
  
  QUEST = "make_cure";  // 6-10
  SetStringValue(QUEST+QUEST_TYPE, RETRIEVE, DB_VARS);
  SetStringValue(QUEST+DESCRIPTION,
   "Keeping the plague from affecting our peoples requires a constant source of cure.  Please deliver me five potions " +
   "of cure disease.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "250", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "250", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "it_mpotion007", DB_VARS);
  SetStringValue(QUEST+NUM_ITEMS, "5", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);
  
  QUEST = "cull_scovin"; // 8-10
  SetStringValue(QUEST+QUEST_TYPE, CULL, DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "150", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "150", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);
  
  switch (d3())
  {
    case 1:
		SetStringValue(QUEST+DESCRIPTION, "Our mages are working on cleansing the wasteland to the East.  However, a tribe of Scovin " +
		  "have settled there, and are attacking our mages as they try to do their work.  Please help the mages by thinning the number of " +
		  "Scovin; 12 or so should do it for now.", DB_VARS);
		SetStringValue(QUEST+CULL_TAG, "ScovinRager", DB_VARS);
		SetStringValue(QUEST+NUM_CREATURES, "12", DB_VARS);  
		break;
	case 2:
		SetStringValue(QUEST+DESCRIPTION, "As you have probably noticed, the trade route between here and Merivale is threatened by orcs and harpies.  " +
		  "Today, I want you to focus on the harpies.  Please slay six of the harpies that live in the mountains between here and Merivale.", DB_VARS);
		SetStringValue(QUEST+CULL_TAG, "Harpy", DB_VARS);
		SetStringValue(QUEST+NUM_CREATURES, "6", DB_VARS);  
		break;
	case 3:
		SetStringValue(QUEST+DESCRIPTION, "As you have probably noticed, the trade route between here and Merivale is threatened by orcs and harpies.  " +
		  "Today, I want you to focus on the orcs.  Please slay three of the Black Orcs that threaten our caravans.", DB_VARS);
		SetStringValue(QUEST+CULL_TAG, "BlackOrc", DB_VARS);
		SetStringValue(QUEST+NUM_CREATURES, "3", DB_VARS);  
		break;
  }
  
  QUEST = "boss_heads";  // 10-15
  SetStringValue(QUEST+REWARD_GOLD, "150", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "150", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);
  
  switch (d3())
  {
    case 1:
		SetStringValue(QUEST+QUEST_TYPE, RETRIEVE, DB_VARS);
		SetStringValue(QUEST+DESCRIPTION,
		   "The plague has brought more danger to our village, desperate creatures that will not live alongside us and need to be " +
		   "culled.  Bring me two heads from creatures that mean us harm.",
		   DB_VARS);
		SetStringValue(QUEST+ITEM_TAG, "GS_HEAD_EVIL", DB_VARS);
		SetStringValue(QUEST+NUM_ITEMS, "2", DB_VARS);
		break;
	case 2:
		SetStringValue(QUEST+QUEST_TYPE, CULL, DB_VARS);
		SetStringValue(QUEST+CULL_TAG, "NW_GHOUL", DB_VARS);
		SetStringValue(QUEST+NUM_CREATURES, "10", DB_VARS);  
		SetStringValue(QUEST+DESCRIPTION,
		   "Ghouls roam the Merivale valley, on the far side of our outpost.  While human raids mean we're not yet ready to start purifying the area, " +
		   "we should get started on removing the undead.  Destroy ten of the ghouls please.",
		   DB_VARS);
		break;	
	case 3:
	    SetStringValue(QUEST+QUEST_TYPE, PATROL, DB_VARS);
		SetStringValue(QUEST+AREA_TAGS, "MerivaleAbandonedGrove", DB_VARS);
		SetStringValue(QUEST+DESCRIPTION,
		   "On the far side of the Merivale valley, well to the south of the outpost, is a forest of giant mushrooms.  Just where the trees end and the mushrooms begin, " +
		   "there is an old grove to the west of the road.  It's a place of power, and worth checking that that power isn't behaving erratically.  Go and check, please, and let me know what you find.",
		   DB_VARS);
		break;   
  }
  
}