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
  return GetPCPlayerName(oPC)+GetName(oPC);
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
  if (FindSubString(sActivePlayers, GetPCPlayerName(oPC)+GetName(oPC)) > -1)
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
  Trace(RQUEST, "Checking whether PC "+GetName(oPC)+" has been told to patrol "+GetName(oArea));
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
  Trace(RQUEST, "Rewarding PC " + GetName(oPC));
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
    while (sArea != "")
    {
      Trace(RQUEST, "Checking area variable for PC: " + sArea);
      if (!GetPersistentInt(oPC, sArea))
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
  Trace(RQUEST, "Tidying up current quest for " + GetName(oPC));
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
    DontWaitForPC(oPC, sAreaList);
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
  Trace (RQUEST, "Setting up new quest for " + GetName(oPC));
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

  // Tell areas to wait for PC if needed
  string sAreaList = GetLocalString(oCache, sQuest+AREA_TAGS);
  if (sAreaList != "")
  {
    WaitForPC(oPC, sAreaList);
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
  Trace(RQUEST, "Generating new quest for " + GetName(oPC));
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
