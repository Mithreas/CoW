/*
zdlg_registrar
 - lets non-leaders sign up for citizenship
 - lets anyone call an election if appropriate
 - lets leaders...
  - access war menu (declare war, end war)
  - access trade menu (open trade route, close trade route)
  - remove citizen or banish player (speak name to get list of matches)
  - bank account (deposit/withdraw)
  - tax management (change tax rate)
  - manage positions
  - vassal menu (view/become/release)
*/

#include "inc_chatutils"
#include "inc_class"
#include "inc_factions"
#include "inc_time"
#include "inc_quarter"
#include "x3_inc_string"
#include "inc_zdlg"
#include "ar_utils"

//in game time, how long between a new token is earned
const int NOBLE_TK_TIMESTAMP        = 29030400; //336 days/IG year

const string LIST_APPLY       = "APPLY";
const string LIST_DONE        = "DONE";
const string LIST_EMPLOY      = "EMPLOY";
const string LIST_FOREIGN     = "FOREIGN";
const string LIST_OPTIONS     = "OPTIONS";
const string LIST_PERSONAL    = "PERSONAL";
const string LIST_RESIGN_DONE = "RESIGN_DONE";
const string LIST_VOTE        = "VOTE";
const string LIST_NAMES       = "CZ_NAMES";
const string LIST_IDS         = "CZ_IDS";
const string LIST_CANCEL      = "CANCEL";
const string LIST_APCAN       = "APCAN";
const string LIST_FACID       = "FACID";
const string LIST_REPLACE     = "REPLACE";
const string LIST_REPID       = "REPID";
const string LIST_FACLEA      = "FACLEA";
const string LIST_HOLDER      = "HOLDER";
const string LIST_CANPW       = "CANPW";
const string LIST_NOBLE       = "NOBLE";

const string VAR_ACTION           = "ZD_ACTION";
const string VAR_ADDL_TXT         = "ZD_ADDL_TXT";
const string VAR_CANNOT_EXILE     = "NO_EXILE";
const string VAR_CONV_INIT        = "ZD_CONV_INIT";
const string VAR_DLG_FOREIGN      = "ZD_DLG_FOREIGN";
const string VAR_DLG_STAGE        = "ZD_DLG_STAGE";
const string VAR_DLG_TAX          = "ZD_DLG_TAX";
const string VAR_ELECT_VOTERS     = "ZD_ELECT_VOTERS";
const string VAR_ELECT_INIT       = "ZD_ELECT_INIT";
const string VAR_FIRST_TIME       = "ZD_FIRST_TIME";
const string VAR_RESIGN           = "ZD_RESIGN";
const string VAR_WELCOME          = "ZD_WELCOME";
const string VAR_HOLDER           = "MD_VAR_HOLDER";

const string ACTION_REVOKE   = "CZ_REVOKE";
const string ACTION_BANISH   = "CZ_BANISH";
const string ACTION_UNBANISH = "CZ_UNBANISH";

// TEXT_ constants should be used in any file which includes this one, in the
// UniqueConversation method.
const string TEXT_ANYTHING_ELSE       = "TEXT_ANYTHING_ELSE";
const string TEXT_APPLY_CONFIRM       = "TEXT_APPLY_CONFIRM";
const string TEXT_ELECTION_PROGRESS   = "TEXT_ELECTION_PROGRESS";
const string TEXT_FOREIGN_PROMPT      = "TEXT_FOREIGN_PROMPT";
const string TEXT_FOREIGN_TRADE_CLOSE = "TEXT_FOREIGN_TRADE_CLOSE";
const string TEXT_FOREIGN_TRADE_OPEN  = "TEXT_FOREIGN_TRADE_OPEN";
const string TEXT_FOREIGN_VASSAL      = "TEXT_FOREIGN_VASSAL";
const string TEXT_FOREIGN_WAR_CEASE   = "TEXT_FOREIGN_WAR_CEASE";
const string TEXT_FOREIGN_WAR_DECLARE = "TEXT_FOREIGN_WAR_DECLARE";
const string TEXT_GOODBYE_CANCEL      = "TEXT_GOODBYE_CANCEL";
const string TEXT_GOODBYE_DONE        = "TEXT_GOODBYE_DONE";
const string TEXT_PERSONAL_PROMPT     = "TEXT_PERSONAL_PROMPT";
const string TEXT_RESIGN_CONFIRM      = "TEXT_RESIGN_CONFIRM";
const string TEXT_RESIGN_VASSAL_CONFIRM = "TEXT_RESIGN_VASSAL_CONFIRM";
const string TEXT_RESIGN_DONE         = "TEXT_RESIGN_DONE";
const string TEXT_SELECT_NAME         = "TEXT_SELECT_NAME";
const string TEXT_TAX_PROMPT          = "TEXT_TAX_PROMPT";
const string TEXT_WELCOME_BANISHED    = "TEXT_WELCOME_BANISHED";
const string TEXT_WELCOME_CANDIDATE   = "TEXT_WELCOME_CANDIDATE";
const string TEXT_WELCOME_MEMBER      = "TEXT_WELCOME_MEMBER";
const string TEXT_WELCOME_NONVOTER    = "TEXT_WELCOME_NONVOTER";
const string TEXT_WELCOME_OUTSIDER    = "TEXT_WELCOME_OUTSIDER";
const string TEXT_WELCOME_VOTER       = "TEXT_WELCOME_VOTER";
const string TEXT_WHO                 = "TEXT_WHO";
const string TEXT_VOTE_PROMPT         = "TEXT_VOTE_PROMPT";
const string TEXT_CAN_CIT             = "TEXT_CAN_CIT";
const string TEXT_WELCOME_CANNOTVOTE  = "TEXT_WELCOME_CANNOTVOTE";
const string TEXT_APCAN               = "TEXT_APCAN";
const string TEXT_REPLACE             = "TEXT_REPLACE";
const string TEXT_SELECT_LEADER       = "TEXT_SEL_LEADERE";
const string TEXT_CANPW               = "TEXT_CANPW";
const string TEXT_NOBLE               = "TEXT_NOBILITY";
// STR_ constants contain the text for PC responses.
const string STR_BACK = "<c þ >[Back]</c>";
const string STR_BANISH = "<c þ >[...]</c> is banished and must not be allowed within our walls.";
const string STR_CITIZEN_APPLY = "I would like to support this settlement in leadership challenges.";
const string STR_CITIZEN_GOODBYE = "Thank you, farewell.";
const string STR_CITIZEN_NO = "Maybe not, then.";
const string STR_CITIZEN_NOCASH = "Oh, I don't have enough money for that.";
const string STR_CITIZEN_YES = "Certainly, here is the money.";
const string STR_DONE = "<c þ >[Done]</c>";
const string STR_ELEC_CALL = "I wish to call a leadership challenge!";
const string STR_ELEC_CAST = "I wish to indicate my support in the leadership challenge.";
const string STR_ELEC_LEADER = "I want to stand for leadership!";
const string STR_HOW_DOING = "How much support do I have in the leadership challenge?";
const string STR_LEADER_BANK = "I need to access our bank account.";
const string STR_LEADER_FOREIGN = "I have come to some decisions regarding our neighbours.";
const string STR_LEADER_PERSONAL = "There are some people who must be dealt with.";
const string STR_LEADER_RESIGN = "I am resigning my post here, immediately.";
const string STR_LEADER_TAX = "I need to change our tax rates.";
//const string STR_LISTCIT = "I want to see who is a citizen here.";  Mord edit: No longer needed
const string STR_LISTEX  = "I want to see who has been banished from here.";
const string STR_PEACE_DECLARE = "We must make peace with <c þ >[...]</c>.";
//const string STR_REVOKE = "<c þ >[...]</c> has become a liability. Revoke their citizenship at once!";
const string STR_TRADE_CLOSE = "I want us to close off trade with <c þ >[...]</c>.";
const string STR_TRADE_OPEN = "I want us to open trade with <c þ >[...]</c>.";
const string STR_UNBANISH = "<c þ >[...]</c> is no longer banished and is to be allowed within our walls once again.";
const string STR_VASSAL = "We must become the vassal of <c þ >[...]</c>.";
const string STR_VASSAL_RESIGN = "Your town is free now - you are no longer our vassal.";
const string STR_WAR_DECLARE = "We must make war with <c þ >[...]</c>.";
const string STR_FACTION = "I want to manage personnel within our settlement.";
const string STR_WITHDRAW = "I wish to withdraw my leadership challenge and release my supporters.";
const string STR_WRIT_REQUEST = "I want a writ.";
const string STR_CAN_CIT = "I no longer wish to be a citizen here.";
const string STR_REPFAC = "I wish to represent faction <c þ >[...]</c> .";
const string STR_REMLEA = "I wish to remove the settelement's current leader.";
const string STR_SGNUP  = "I wish to put my name forth in next settlement challange.";
const string STR_CANPW  = "I need to view my paperwork for my candidancy.";
const string STR_NOBLE = "I wish to grant nobility.";
// Sets the text for the current speaker on sVarName to sText. sVarName is one
// of the TEXT_ constants.
void SetText(string sVarName, string sText);
// Must be defined within each individual file. Contains multiple instances of
// SetText for each dialog handle.
void UniqueConversation();

void _OwnerOfSettlementFaction(object oPC, object oNation)
{
  int x;
  for(x = 1; x <= GetLocalInt(oNation, VAR_NUM_LEADERS); x++)
  {
    if(fbFAGetIsOwningRank(GetLocalString(oNation, VAR_CURRENT_LEADER+IntToString(x)+"F"), oPC))
    {
        AddStringElement(STR_REMLEA, LIST_OPTIONS);
        return;
    }
  }
}
void _AddPowerOptions(string sNationName, int bLeader, object oPC, int bOwner, int bMaster)
{
    int nRank;
    int nRank2;
    object oModule = GetModule();
    string sFDatabaseID = GetLocalString(oModule, "MD_FA_"+sNationName);
    nRank     = mdFAInFaction(sFDatabaseID, oPC);

    if(nRank == 0)
    {
      int nMax = md_FaRankCount(sFDatabaseID);
      int nCount;
      for(nCount = 1; nCount <= nMax; nCount++)
      {
        nRank2 = mdFAInFaction(GetLocalString(oModule, "MD_FA_"+md_FAGetRankName(sFDatabaseID, md_FAGetNthRankID(sFDatabaseID, nCount))), oPC);
        if(nRank2)
          break;
      }
    }

    if(bLeader || nRank > 0 || nRank2 > 0)
    {
        if(bLeader || nRank > 0)
            AddStringElement(STR_FACTION, LIST_OPTIONS);
        if(GetElementCount(LIST_FOREIGN))
            AddStringElement(STR_LEADER_FOREIGN, LIST_OPTIONS);
        if(GetElementCount(LIST_PERSONAL))
            AddStringElement(STR_LEADER_PERSONAL, LIST_OPTIONS);
        AddStringElement(STR_LEADER_BANK, LIST_OPTIONS);  //this one can stay out in the open
        if(bLeader || md_GetHasPowerSettlement(MD_PR2_CHT, oPC, sFDatabaseID, "2"))
            SetLocalInt(oPC, VAR_DLG_TAX, AddStringElement(STR_LEADER_TAX, LIST_OPTIONS) - 1);
        else
            SetLocalInt(oPC, VAR_DLG_TAX, -1);
    }
    else if(bMaster)
    {
        AddStringElement(STR_LEADER_PERSONAL, LIST_OPTIONS);
    }
    else if (bOwner)
    {
        AddStringElement(STR_LEADER_FOREIGN, LIST_OPTIONS);
        AddStringElement(STR_LEADER_BANK, LIST_OPTIONS);
        SetLocalInt(oPC, VAR_DLG_TAX, -1);
    }
    else
        SetLocalInt(oPC, VAR_DLG_TAX, -1);
}

void _LoadElectionData(object oNation, string sNation)
{
  SQLExecStatement("SELECT votes FROM micz_votes WHERE nation=?", sNation);
  string sCandidates = ";;";
  string sCandidate;
  string sVoters;
  string sVoterList;
  while (SQLFetch())
  {
    sVoters      = SQLGetData(1);
    // Chop off votes count and extra ;; seperator.
    sVoters      = GetStringRight(sVoters, GetStringLength(sVoters) - 7);
    sVoterList  += sVoters;
  }
  SetLocalString(oNation, VAR_ELECT_VOTERS, ";;" + sVoterList);
  SetLocalInt(oNation, VAR_ELECT_INIT, TRUE);
}

string Parse(string sString, string sReplace1 = "", string sReplace2 = "")
{
  if (sReplace1 != "")
  {
    sString = gsCMReplaceString(sString, sReplace1, sReplace2);
  }

  int nPos = FindSubString(sString, "%");
  if (nPos == -1)
  {
    return sString;
  }
  string sChar;
  string sDone;
  do
  {
    sDone += GetStringLeft(sString, nPos);
    sChar = GetSubString(sString, nPos + 1, 1);
    if (sChar == "f")
    {
      string sName = GetName(GetPcDlgSpeaker());
      // Some people create characters with spaces at the start of their name...
      int nSpace = FindSubString(sName, " ", 2);
      if (nSpace != -1)
      {
        sDone += GetStringLeft(sName, nSpace);
      }
      else
      {
        sDone += sName;
      }
    }
    else if (sChar == "t")
    {
      sDone += (GetIsDawn()) ? "morning" :
               (GetIsDusk()) ? "evening" :
               (GetIsNight()) ? "night" : "day";
    }
    else
    {
      sDone += "%" + sChar;
    }
    sString = GetStringRight(sString, GetStringLength(sString) - nPos - 2);
    nPos    = FindSubString(sString, "%");
  } while (nPos != -1);
  return sDone + sString;
}

string GetText(string sVarName, string sReplace1 = "", string sReplace2 = "")
{
  return Parse(GetLocalString(OBJECT_SELF, "REG_ZD_" + sVarName), sReplace1, sReplace2);
}

void SetText(string sVarName, string sText)
{
  SetLocalString(OBJECT_SELF, "REG_ZD_" + sVarName, sText);
}

// Call when submit a query that has a list of names.  This method parses them
// all and populates LIST_NAMES and LIST_IDs with the IDs.  Duplicates are
// discarded so all queries of gs_pc_data should be ordered by 'modified' (desc)
void ParseNameList()
{
   DeleteList(LIST_NAMES);
   DeleteList(LIST_IDS);
   string sID;
   string sName;
   int nCount;
   int bExists;

   while (SQLFetch())
   {
     sID = SQLGetData(1);
     sName = SQLGetData(2);
     bExists = FALSE;

     for (nCount = 0; nCount < GetElementCount(LIST_NAMES); nCount++)
     {
       if (GetStringElement(nCount, LIST_NAMES) == sName) bExists = TRUE;
     }

     if (!bExists)
     {
       AddStringElement(sName, LIST_NAMES);
       AddStringElement(sID, LIST_IDS);
     }
   }
}

int GetIsCandidate(object oNation, string sNation, object oPC)
{
  SQLExecStatement("SELECT candidate FROM micz_votes WHERE nation=? AND candidate=?",
    sNation, gsPCGetPlayerID(oPC));

  return SQLFetch();
}

int GetHasVoted(object oNation, string sNation, object oPC)
{
  if (!GetLocalInt(oNation, VAR_ELECT_INIT))
  {
    _LoadElectionData(oNation, sNation);
  }
  return FindSubString(GetLocalString(oNation, VAR_ELECT_VOTERS), ";;" +
   gsPCGetPlayerID(oPC) + "_") != -1;
}

void CastVote(object oNation, string sNation, object oPC, string sCandidate)
{
  // Query to select a list of votes (in the form 00000;;1_KKKKKKKK;;... where
  // 00000 is the number of votes, 1 is the PC ID and KKKKKKKK is that PC's CD
  // key), the ID of sCandidate and sCandidate's CD key.
  SQLExecStatement("SELECT v.votes, l.cdkey FROM micz_votes AS v " +
   "INNER JOIN gs_pc_data AS p ON v.candidate = p.id LEFT JOIN gs_player_data " +
   "AS l ON p.keydata = l.id WHERE v.nation=? AND v.candidate=? LIMIT 1",
   sNation, sCandidate);

  if (!SQLFetch())
  {
    return;
  }

  string sVoters  = SQLGetData(1);
  string sCandKey = SQLGetData(2);
  string sCDKey   = GetPCPublicCDKey(oPC);
  string sPCID    = gsPCGetPlayerID(oPC) + "_" + sCDKey + ";;";

  // No more than one vote per candidate per CD key.
  if (FindSubString(sVoters, sCDKey) > -1 || sCDKey == sCandKey)
  {
    SendMessageToPC(oPC, "No more than one vote per candidate per CD key.");
    return;
  }
  Log(CITIZENSHIP, "!!!VOTING!!! Name: " + GetName(oPC) + " HD: " + IntToString(GetHitDice(oPC)) + " CD KEY:" + sCDKey + " IP: " + GetPCIPAddress(oPC) + " Candidate:" + gsPCGetPlayerName(sCandidate) + " Candidate CDKey: " + sCandKey);
  // No more than one vote per player per year.
  // Removed now that people can't jump between nations.
  /*
  int nLastVoteTime = gsPCGetLastVote(oPC);
  int nNow = gsTIGetActualTimestamp();
  if (gsTIGetAbsoluteYear(nNow - nLastVoteTime) < 0)
  {
    SendMessageToPC(oPC, "No more than one vote per player per game year.");
    return;
  }
  else
  {
    gsPCSetLastVote(oPC, nNow);
  }
  */
  int nVoteAddition = 1;
  if(miCZGetCitizenCount(sNation) >= 50 && md_GetIsNoble(oPC, sNation) &  LANDED_NOBLE_INSIDE)
    nVoteAddition = 2;
  int nVotes     = StringToInt(gsCMTrimString(GetStringLeft(sVoters, 5))) + nVoteAddition;
  sVoters        = GetStringRight(sVoters, GetStringLength(sVoters) - 5);
  sVoters        = gsCMPadString(IntToString(nVotes), 5) + sVoters + sPCID;

  // Update DB and cache
  SQLExecStatement("UPDATE micz_votes SET votes=? WHERE nation=? AND candidate=?",
   sVoters, sNation, sCandidate);
  SetLocalString(oNation, VAR_ELECT_VOTERS, GetLocalString(oNation,
   VAR_ELECT_VOTERS) + sPCID);
}

int GetCanEmploy(object oPC, string sNation)
{
  return FALSE;

  // FIXME: This query doesn't make any sense, and is as it stands functionally
  // equivalent to return FALSE.

  //SQLExecStatement("SELECT 1 FROM micz_positions WHERE nation=? AND pc_id=? LIMIT 1",
  // sNation, gsPCGetPlayerID(oPC));
  //return SQLFetch();
}

void Revoke(string sTargetID, string sNation)
{
  // Not possible any more.
  /*
  miDASetKeyedValue("gs_pc_data", sTargetID, "nation", "NULL");
  object oTarget = gsPCGetPlayerByID(sTargetID);

  if (GetIsObjectValid(oTarget))
  {
    SetLocalString(oTarget, VAR_NATION, "");
    SendMessageToPC(oTarget, "Your citizenship in " + sNation + " has been revoked.");
  }

  LeaderLog(GetPCSpeaker(), "Revoked citizenship of " + sTargetID + " in " + sNation);
  SendMessageToPC(GetPCSpeaker(), "Citizenship revoked successfully.");
  */
}

void Banish(string sTargetID, string sNation)
{
  SQLExecStatement("SELECT pc_id FROM micz_banish WHERE nation=? AND pc_id =?",
                   sNation, sTargetID);

  // Already banished
  if (SQLFetch())
  {
    SendMessageToPC(GetPCSpeaker(), "This player has already been banished from this nation.");
    return;
  }
  int nPerCitizen = 10;
  if(miCZGetBestNationMatch("Cordor") == sNation) //it's cordor so.. change it
    nPerCitizen = 20;
  if(mdCZGetExileCount(sNation) >= (3+miCZGetCitizenCount(sNation)/nPerCitizen))
  {
      SendMessageToPC(GetPCSpeaker(), "You've reached the maximum exiles allowed");
      return;

  }

  miCZSetBanished(sNation, sTargetID, TRUE);
  LeaderLog(GetPCSpeaker(), "Banished " + sTargetID + " from " + sNation);
  SendMessageToPC(GetPCSpeaker(), "Player banished successfully.");
}


void UnBanish(string sTargetID, string sNation)
{
  miCZSetBanished(sNation, sTargetID, FALSE);
  LeaderLog(GetPCSpeaker(), "Unbanished " + sTargetID + " from " + sNation);
  SendMessageToPC(GetPCSpeaker(), "Player is no longer banished.");
}

// InitMenu - run once when the conversation initializes and whenever the menu
// needs refreshing.
void InitMenu()
{
  object oPC       = GetPcDlgSpeaker();
  string sNation   = GetLocalString(oPC, VAR_NATION);
  string sNationName = GetLocalString(OBJECT_SELF, VAR_NATION);
  string sMyNation = miCZGetBestNationMatch(sNationName);
  //get the factions full name for factions
  sNationName = miCZGetName(sMyNation);
  object oNation   = miCZLoadNation(sMyNation);
  int bMaster      = miCZGetIsMaster(oPC, sMyNation);
  int bHarper      = GetLevelByClass(CLASS_TYPE_HARPER, oPC);
  int bHarperAgent = bHarper > 4 || (bHarper && !GetLocalInt(gsPCGetCreatureHide(oPC), VAR_HARPER));
  bHarper = bHarper || GetIsObjectValid(GetItemPossessedBy(oPC, "GS_PERMISSION_CLASS_28"));
  // Override functions for 'owned' settlements (i.e. warehouses).
  int bOwner = gsQUGetIsOwner(OBJECT_SELF, oPC);

  string sWelcomePrompt;
  int nResponse;

  DeleteList(LIST_OPTIONS);

  if (miCZGetBanished(sMyNation, gsPCGetPlayerID(oPC)))
  {
    sWelcomePrompt = GetText(TEXT_WELCOME_BANISHED);
    AddStringElement(STR_DONE, LIST_OPTIONS);
    SetLocalInt(oPC, VAR_DLG_TAX, -1);
  }
  else if (sNation == sMyNation || bMaster || bOwner || bHarperAgent)
  {
    int bLeader = miCZGetIsLeader(oPC, sMyNation);
    int nCurrentTime = gsTIGetActualTimestamp();
    int nVCooldown = GetLocalInt(gsPCGetCreatureHide(oPC), VAR_VOTE_COOLDOWN);
    if(nVCooldown > gsTIGetTimestamp(GetCalendarYear()+1, GetCalendarMonth(), GetCalendarDay(), GetTimeHour(), GetTimeMinute(), GetTimeSecond())+1 && nVCooldown > 1451520000)
    {
        nVCooldown -= 1451520000;
        SetLocalInt(gsPCGetCreatureHide(oPC), VAR_VOTE_COOLDOWN, nVCooldown);
    }
    if (miCZIsElectionInProgress(oPC, sMyNation) && !bMaster)
    {
      if (GetIsCandidate(oNation, sMyNation, oPC))
      {
        sWelcomePrompt = GetText(TEXT_WELCOME_CANDIDATE);
        AddStringElement(STR_HOW_DOING, LIST_OPTIONS);
        AddStringElement(STR_WITHDRAW, LIST_OPTIONS);
      }
      else if(nVCooldown > nCurrentTime)
      {
        sWelcomePrompt = GetText(TEXT_WELCOME_CANNOTVOTE);
      }
      else if (!GetHasVoted(oNation, sMyNation, oPC))
      {
        sWelcomePrompt = GetText(TEXT_WELCOME_NONVOTER);
        AddStringElement(STR_ELEC_CAST, LIST_OPTIONS);
        if (!bHarper) AddStringElement(STR_ELEC_LEADER, LIST_OPTIONS);
      }
      else
      {
        sWelcomePrompt = GetText(TEXT_WELCOME_VOTER);
      }
    }
    else
    {
      sWelcomePrompt = GetText(TEXT_WELCOME_MEMBER);
      if(!bMaster && !bOwner && !bHarper)
      {
        string sID = gsPCGetPlayerID(oPC);
        SQLExecStatement("SELECT candidate FROM mdcz_cand WHERE candidate=?", sID);
        int nFetch = SQLFetch();
        if(nVCooldown <= nCurrentTime)
        {
            if (miCZTimeForElection(sMyNation) && !bLeader)
            {
                    AddStringElement(STR_ELEC_CALL, LIST_OPTIONS);
            }
            else if(nFetch)
                AddStringElement(STR_CANPW, LIST_OPTIONS);
            else
                AddStringElement(STR_SGNUP, LIST_OPTIONS);
        }
        if(!nFetch)
        {
            SQLExecStatement("SELECT c.nation FROM mdcz_cand AS c INNER JOIN md_fa_members AS m ON c.fac_id=m.faction_id WHERE m.is_OwnerRank=1 AND m.pc_id=? AND c.nation=?", sID, sMyNation);
            if(SQLFetch())
                AddStringElement(STR_CANPW, LIST_OPTIONS);
        }
      }
    }

    _AddPowerOptions(sNationName, bLeader, oPC, bOwner, bMaster);
    _OwnerOfSettlementFaction(oPC, oNation);

    if(!bMaster && !bLeader)
        AddStringElement(STR_CAN_CIT, LIST_OPTIONS);
    if (bLeader)
    {
      // Store the index for later - AddStringElement returns 1 more than
      // the index of the item just added so subtract 1.
      SetLocalInt(oPC, VAR_RESIGN, AddStringElement(STR_LEADER_RESIGN, LIST_OPTIONS) - 1);
      //AddStringElement(STR_NOBLE, LIST_OPTIONS);
      //Refresh token if it is time!
      SQLExecStatement("UPDATE micz_nations SET noble_remove=1 WHERE (noble_remove<=0 OR noble_remove IS NULL) AND (noble_timestamp BETWEEN 0 AND ? OR noble_timestamp IS NULL)", IntToString(gsTIGetActualTimestamp()));
      if(GetLocalInt(oNation, VAR_NUM_LEADERS) > 1)
        AddStringElement(STR_WRIT_REQUEST, LIST_OPTIONS);
    }
    else if(bMaster)
    {
        SetLocalInt(oPC, VAR_RESIGN, AddStringElement(STR_VASSAL_RESIGN, LIST_OPTIONS) - 1);
    }
  }
  else
  {

    sWelcomePrompt = GetText(TEXT_WELCOME_OUTSIDER);

    _AddPowerOptions(sNationName, 0, oPC, bOwner, 0); //leader shouldn't be making it this far
    _OwnerOfSettlementFaction(oPC, oNation);
    SQLExecStatement("SELECT c.nation FROM mdcz_cand AS c INNER JOIN md_fa_members AS m ON c.fac_id=m.faction_id WHERE m.is_OwnerRank=1 AND m.pc_id=? AND c.nation=?", gsPCGetPlayerID(oPC), sMyNation);
    if(SQLFetch())
        AddStringElement(STR_CANPW, LIST_OPTIONS);
    if(!miCZGetIsLeader(oPC) && !GetIsObjectValid(GetItemPossessedBy(oPC, "piratecontract")))
        AddStringElement(STR_CITIZEN_APPLY, LIST_OPTIONS);
    AddStringElement(STR_CITIZEN_GOODBYE, LIST_OPTIONS);

  }

  SetLocalString(oPC, VAR_WELCOME, sWelcomePrompt);
}

void Init()
{
  object oNPC    = OBJECT_SELF;
  object oPC = GetPcDlgSpeaker();
  string sNation = miCZGetBestNationMatch(GetLocalString(oNPC, VAR_NATION));
  object oNation = miCZLoadNation(sNation);
  int    bLeader = miCZGetIsLeader(oPC, sNation);
  int    bMaster = miCZGetIsMaster(oPC, sNation);
  string sFactionID = GetLocalString(GetModule(), "MD_FA_"+miCZGetName(sNation));

  // Initialize the conversation - one time per registrar.
  if (!GetLocalInt(oNPC, VAR_CONV_INIT))
  {
    UniqueConversation();
    SetLocalInt(oNPC, VAR_CONV_INIT, TRUE);
  }

  // Override functions for 'owned' settlements (i.e. warehouses).
  int bOwner = gsQUGetIsOwner(OBJECT_SELF, oPC);

  InitMenu();

  DeleteList(LIST_FOREIGN);

  if(bLeader || md_GetHasPowerSettlement(MD_PR2_SUT, oPC, sFactionID, "2") || bOwner)
  {
    AddStringElement(STR_TRADE_OPEN, LIST_FOREIGN);
    AddStringElement(STR_TRADE_CLOSE, LIST_FOREIGN);
  }
  if (!GetLocalInt(oNPC, VAR_CANNOT_EXILE) && (bLeader || md_GetHasPowerSettlement(MD_PR2_WAR, oPC, sFactionID, "2")))
  {
    AddStringElement(STR_WAR_DECLARE, LIST_FOREIGN);
    AddStringElement(STR_PEACE_DECLARE, LIST_FOREIGN);
  }

  if (bLeader && GetLocalString(oNation, VAR_MASTER) == "NONE")
  {
    AddStringElement(STR_VASSAL, LIST_FOREIGN);
  }

  if(GetElementCount(LIST_FOREIGN))
    AddStringElement(STR_BACK, LIST_FOREIGN);

  DeleteList(LIST_PERSONAL);

  //AddStringElement(STR_LISTCIT, LIST_PERSONAL);
  //AddStringElement(STR_REVOKE, LIST_PERSONAL);

  if (!GetLocalInt(oNPC, VAR_CANNOT_EXILE))
  {
        AddStringElement(STR_LISTEX, LIST_PERSONAL);
        if(bMaster || bLeader || md_GetHasPowerSettlement(MD_PR2_EXL, oPC, sFactionID, "2"))
            AddStringElement(STR_BANISH, LIST_PERSONAL);
        if(bLeader || md_GetHasPowerSettlement(MD_PR2_RME, oPC, sFactionID, "2"))
            AddStringElement(STR_UNBANISH, LIST_PERSONAL);
  }
  if(GetElementCount(LIST_PERSONAL))
    AddStringElement(STR_BACK, LIST_PERSONAL);


  SetDlgPageString(LIST_OPTIONS);
}
void PageInit()
{
  object oPC        = GetPcDlgSpeaker();
  object oNPC       = OBJECT_SELF;
  string sDlg       = GetDlgPageString();
  string sNation    = miCZGetBestNationMatch(GetLocalString(oNPC, VAR_NATION));
  int bMaster       = miCZGetIsMaster(oPC, sNation);

  // Override functions for 'owned' settlements (i.e. warehouses).
  int bOwner = gsQUGetIsOwner(OBJECT_SELF, oPC);

  //::  ActionReplay:  Checks for UD only and a deny of Outcasts (potentially for Surface settlements)
  int isUDOnly      = GetLocalInt(oNPC, "AR_UD_ONLY");
  int denyOutcast   = GetLocalInt(oNPC, "AR_DENY_OUTCASTS");

  if ( !bMaster && isUDOnly && !ar_IsEligibleToUDVote(oPC) && !GetIsDM(oPC)) {
    SetDlgPrompt("Get away from me you filth!");
    SendMessageToPC(oPC, "Only Monster races, Drow and Outcasts can engage in Andunor politics.");
    SetDlgResponseList("");
    EndDlg();
  }
  else if ( !bMaster && denyOutcast && ar_IsUDOutcast(oPC) && !GetIsDM(oPC)) {
    SetDlgPrompt("Get away before I call the guards!");
    SendMessageToPC(oPC, "As an Outcast you cannot engage in politics on the Surface.");
    SetDlgResponseList("");
    EndDlg();
  }
  //::  -----   ActionReplay END
  else if (sDlg == LIST_OPTIONS)
  {
    if (GetLocalInt(oPC, VAR_FIRST_TIME))
    {
      if (GetDlgPageInt() == 1)
      {
        SetDlgPrompt(GetText(TEXT_ELECTION_PROGRESS));
        SetDlgResponseList("");
        EndDlg();
      }
      else
      {
        SetDlgPrompt(GetText(TEXT_ANYTHING_ELSE) + "\n\nSettlement status:\n" +
        miCZGetSettlementStatus(sNation));
        SetDlgResponseList(LIST_OPTIONS);
      }
    }
    else
    {
      SetDlgPrompt(GetLocalString(oPC, VAR_WELCOME) + "\n\nSettlement status:\n" +
        miCZGetSettlementStatus(sNation));
      SetLocalInt(oPC, VAR_FIRST_TIME, TRUE);
      SetDlgResponseList(LIST_OPTIONS);
    }

    // Valid: "+5", "-12.4", etc.
    if (GetLocalInt(oPC, VAR_DLG_TAX) != -1)
    {
      miZDInputText(GetLocalInt(oPC, VAR_DLG_TAX),
                    GetText(TEXT_TAX_PROMPT,
                            gsCMGetAsString(miCZGetTaxRate(sNation) * 100)),
                    "(*n|(*n.*n))",
                    FALSE);
    }

    int nResign = GetLocalInt(oPC, VAR_RESIGN);
    if (nResign && bMaster)
    {
      miZDConfirmResponse(nResign, GetText(TEXT_RESIGN_VASSAL_CONFIRM), LIST_RESIGN_DONE, LIST_OPTIONS);
    }
    else if (nResign)
    {
      miZDConfirmResponse(nResign, GetText(TEXT_RESIGN_CONFIRM), LIST_RESIGN_DONE, LIST_OPTIONS);

    }
  }
  else if (sDlg == LIST_RESIGN_DONE)
  {
    // NB - if the PC selects resign they go into a confirm dialog.  If they're
    // sure, they come back here and hit this code branch.
    string sID     = gsPCGetPlayerID(oPC);
    object oNation = miCZLoadNation(sNation);
    if (miCZGetIsLeader(oPC, sNation))
    {
      miCZResign(sID, sNation);
      SetDlgPageString(LIST_DONE);
      SetDlgPageInt(1);
    }
    else if (miCZGetIsMaster(oPC, sNation))
    {
      miCZSetVassal(sNation);
      SetDlgPageString(LIST_DONE);
      SetDlgPageInt(1);
    }
    else
    {
      Error(CITIZENSHIP, "Error - PC resigned despite not being leader/master");
    }

    SetDlgPrompt(GetText(TEXT_RESIGN_DONE));
    SetDlgResponseList("");
    EndDlg();
  }
  else if (sDlg == LIST_FOREIGN)
  {
    int nStage = GetDlgPageInt();
    string sText;
    string sForeign = GetLocalString(oPC, VAR_DLG_FOREIGN);
    switch (nStage)
    {
      // Before selecting the policy
      case 0:
      {
        sText = TEXT_FOREIGN_PROMPT;
        SetDlgResponseList(LIST_FOREIGN);
        chatClearLastMessage(oPC);
        break;
      }
      // After selecting the policy
      case 1:
      {
        sText = TEXT_FOREIGN_TRADE_OPEN;
        SetDlgResponseList(MI_ZD_CONFIRM);
        break;
      }
      case 2:
      {
        sText = TEXT_FOREIGN_TRADE_CLOSE;
        SetDlgResponseList(MI_ZD_CONFIRM);
        break;
      }
      case 3:
      {
        sText = TEXT_FOREIGN_WAR_DECLARE;
        SetDlgResponseList(MI_ZD_CONFIRM);
        break;
      }
      case 4:
      {
        sText = TEXT_FOREIGN_WAR_CEASE;
        SetDlgResponseList(MI_ZD_CONFIRM);
        break;
      }
      case 5:
      {
        sText = TEXT_FOREIGN_VASSAL;
        SetDlgResponseList(MI_ZD_CONFIRM);
        break;
      }
    }
    SetDlgPrompt(GetText(sText, miCZGetName(sForeign)));
  }
  else if (sDlg == LIST_PERSONAL)
  {
    SetDlgPrompt(GetText(TEXT_PERSONAL_PROMPT) +
                 GetLocalString(OBJECT_SELF, VAR_ADDL_TXT));
    DeleteLocalString(OBJECT_SELF, VAR_ADDL_TXT);
    SetDlgResponseList(LIST_PERSONAL);
    chatClearLastMessage(oPC);
  }
  else if (sDlg == LIST_VOTE)
  {
    DeleteList(LIST_VOTE);
    string sCandidateID;
    SQLExecStatement("SELECT v.candidate, p.name, f.name FROM micz_votes AS v INNER JOIN " +
     "gs_pc_data AS p ON v.candidate = p.id LEFT JOIN md_fa_factions AS f ON f.id=v.fac_id WHERE v.nation=?", sNation);
    while (SQLFetch())
    {
      sCandidateID = SQLGetData(1);
      SetLocalString(oNPC, "CANDIDATE_" + IntToString(AddStringElement(
       SQLGetData(2) + " of " + SQLGetData(3), LIST_VOTE) - 1), sCandidateID);
    }
    AddStringElement(STR_BACK, LIST_VOTE);
    SQLExecStatement("SELECT COUNT(candidate) FROM micz_votes WHERE nation=?", sNation);
    SQLFetch();
    SetDlgPrompt(GetText(TEXT_VOTE_PROMPT) + " There are " + SQLGetData(1) + " candidates.");
    SetDlgResponseList(LIST_VOTE);
  }
  else if (sDlg == LIST_APPLY)
  {
    DeleteList(LIST_APPLY);
    //No longer consider gold from bank balance
    if (GetGold(oPC) /*+ gsFIGetBalance(oPC)*/ >= MI_CZ_JOIN_PRICE)
    {
      AddStringElement(STR_CITIZEN_YES, LIST_APPLY);
    }
    else
    {
      AddStringElement(STR_CITIZEN_NOCASH, LIST_APPLY);
    }

    AddStringElement(STR_CITIZEN_NO, LIST_APPLY);
    SetDlgPrompt(GetText(TEXT_APPLY_CONFIRM, IntToString(MI_CZ_JOIN_PRICE)));
    SetDlgResponseList(LIST_APPLY);
  }
  else if (sDlg == LIST_CANCEL)
  {
    SetDlgPrompt(GetText(TEXT_CAN_CIT));
    DeleteList(LIST_CANCEL);
    AddStringElement("Yes.", LIST_CANCEL);
    AddStringElement("No.", LIST_CANCEL);
    SetDlgResponseList(LIST_CANCEL);
  }
  else if (sDlg == LIST_NAMES)
  {
    SetDlgPrompt(GetText(TEXT_SELECT_NAME));
    AddStringElement(STR_BACK, LIST_NAMES);
    SetDlgResponseList(LIST_NAMES);
  }
  else if (sDlg == LIST_DONE)
  {
    if (GetDlgPageInt())
    {
      SetDlgPrompt(GetText(TEXT_GOODBYE_DONE));
    }
    else
    {
      SetDlgPrompt(GetText(TEXT_GOODBYE_CANCEL));
    }
    SetDlgResponseList("");
    EndDlg();
  }
  else if(sDlg == LIST_APCAN)
  {
    SetDlgPrompt(GetText(TEXT_APCAN));

    DeleteList(LIST_APCAN);
    DeleteList(LIST_FACID);
    AddStringElement(STR_REPFAC, LIST_APCAN);
    AddStringElement("0", LIST_FACID);
    SQLExecStatement("SELECT f.id,f.name FROM md_fa_factions AS f INNER JOIN md_fa_members AS m ON m.faction_id=f.id WHERE f.nation IS NULL AND f.name LIKE ? AND m.pc_id=? LIMIT 8", "%"+chatGetLastMessage(oPC)+"%", gsPCGetPlayerID(oPC));
    while (SQLFetch())
    {
        AddStringElement(SQLGetData(1), LIST_FACID);

        AddStringElement("<c þ >[Faction: " + SQLGetData(2) + "]</c>", LIST_APCAN);
    }
    SetDlgResponseList(LIST_APCAN);
  }
  else if(sDlg == LIST_FACLEA)
  {
    SetDlgPrompt(GetText(TEXT_SELECT_LEADER));
    SetDlgResponseList(LIST_FACLEA);
  }
  else if(sDlg == LIST_REPLACE)
  {
    SetDlgPrompt(GetText(TEXT_REPLACE));

    SQLExecStatement("SELECT p.id FROM micz_rank AS r INNER JOIN md_fa_members AS m ON r.fac_id=m.faction_id INNER JOIN gs_pc_data AS p ON p.id=m.pc_id WHERE p.nation=? GROUP BY p.id", sNation);
    DeleteList(LIST_REPLACE);
    DeleteList(LIST_REPID);
    string sID;
    int nCurrentTime = gsTIGetActualTimestamp();
    int nVCooldown;
    object oLoop;
    while(SQLFetch())
    {
        sID = SQLGetData(1);

        oLoop = gsPCGetPlayerByID(sID);

        if(GetIsObjectValid(oLoop))
        {

            nVCooldown = GetLocalInt(gsPCGetCreatureHide(oLoop), VAR_VOTE_COOLDOWN);
            if(nVCooldown <= nCurrentTime && !GetIsObjectValid(GetItemPossessedBy(oPC, "GS_PERMISSION_CLASS_28")))
            {
                AddStringElement(GetName(oLoop), LIST_REPLACE);
                AddStringElement(sID, LIST_REPID);
            }

        }

    }

    SetDlgResponseList(LIST_REPLACE);

  }
  else if(sDlg == LIST_CANPW)
  {

     SetDlgPrompt(GetText(TEXT_CANPW));
     string sID = gsPCGetPlayerID(oPC);
     SQLExecStatement("SELECT p.id,p.name,f.name FROM mdcz_cand AS c INNER JOIN md_fa_members AS m ON c.fac_id=m.faction_id INNER JOIN gs_pc_data AS p ON p.id=c.candidate INNER JOIN md_fa_factions AS f ON f.id=c.fac_id WHERE (c.candidate=? OR (m.is_OwnerRank=1 AND m.pc_id=?) AND c.nation=?) GROUP BY p.name", sID, sID, sNation);
     DeleteList(LIST_REPID);
     DeleteList(LIST_CANPW);


     while(SQLFetch())
     {
        AddStringElement(SQLGetData(1), LIST_REPID);
        AddStringElement(SQLGetData(2) + " representing faction " + SQLGetData(3), LIST_CANPW);
     }

     SetDlgResponseList(LIST_CANPW);


  }
  else if(sDlg == LIST_NOBLE)
  {

    DeleteList(LIST_REPID);
    DeleteList(LIST_NOBLE);
    string sFaction = md_GetDatabaseID(miCZGetName(sNation));
    SQLExecStatement("SELECT m.pc_id,g.name,m.is_Noble FROM md_fa_members AS m INNER JOIN gs_pc_data AS g ON m.pc_id = g.id WHERE m.faction_id=? ORDER BY m.is_Noble DESC, g.name ASC", sFaction);
    int x;
    int z;
    string sText;
    string sID;
    int nStatus;
    while(SQLFetch())
    {
        sID = SQLGetData(1);
        nStatus = GetLocalInt(oPC, LIST_NOBLE+sID);
        AddStringElement(sID, LIST_REPID);
        if(nStatus == -1)
        {
            z++;
            sText = "770";
        }
        else if(SQLGetData(3) == "1" || nStatus)
        {
            x++;
            sText = STRING_COLOR_GREEN;
        }

        else
            sText = STRING_COLOR_RED;
        AddStringElement(StringToRGBString(SQLGetData(2), sText), LIST_NOBLE);
    }
    int nWrit = md_GetHasWrit(oPC, sFaction, 0);
    if(nWrit == 3 || nWrit == 1)
        AddStringElement("[CONFIRM]", LIST_NOBLE);
    SetLocalInt(oPC, LIST_NOBLE+"_COUNT", x);
    SQLExecStatement("SELECT noble_remove FROM micz_nations WHERE id=?", sNation);
    SQLFetch();
    int y = StringToInt(SQLGetData(1));
    SetDlgPrompt(GetText(TEXT_NOBLE, IntToString(x), IntToString(y)));
    SetLocalInt(oPC, LIST_NOBLE+"_REMOVE", y-z);

    SetDlgResponseList(LIST_NOBLE);
  }
}
//------------------------------------------------------------------------------
void HandleSelection()
{
  object oPC         = GetPcDlgSpeaker();
  object oNPC        = OBJECT_SELF;
  string sNationName = GetLocalString(oNPC, VAR_NATION);
  string sNation     = miCZGetBestNationMatch(sNationName);
  sNationName        = miCZGetName(sNation);
  object oNation     = miCZLoadNation(sNation);
  string sDlg        = GetDlgPageString();
  int nSelection     = GetDlgSelection();
  string sText       = GetDlgResponse(nSelection, oPC);
  string sID         = gsPCGetPlayerID(oPC);
  string sFactionID  = GetLocalString(GetModule(), "MD_FA_"+sNationName);

  // Override functions for 'owned' settlements (i.e. warehouses).
  int bOwner = gsQUGetIsOwner(OBJECT_SELF, oPC);

  if (sText == STR_BACK)
  {
    SetDlgPageString(LIST_OPTIONS);
    SetDlgPageInt(0);
    return;
  }

  if (sDlg == LIST_OPTIONS)
  {
    if (sText == STR_CITIZEN_APPLY)
    {
      SetDlgPageString(LIST_APPLY);
      SetDlgPageInt(0);
    }
    else if (sText == STR_CAN_CIT)
    {
      SetDlgPageString(LIST_CANCEL);
      SetDlgPageInt(0);
    }
    else if (sText == STR_ELEC_CALL || sText == STR_ELEC_LEADER)
    {
      //miCZStartElection(sNation, sID);
      DeleteLocalInt(oNPC, "MD_EL_SGNUP");
      SetDlgPageString(LIST_APCAN);
      SetDlgPageInt(1);
    }
    else if(sText == STR_SGNUP)
    {
      SetLocalInt(oNPC, "MD_EL_SGNUP", TRUE);
      SetDlgPageString(LIST_APCAN);
      SetDlgPageInt(1);
    }
    else if (sText == STR_ELEC_CAST)
    {
      SetDlgPageString(LIST_VOTE);
      SetDlgPageInt(0);
    }
    else if (sText == STR_HOW_DOING)
    {
      SetDlgPageInt(1);
    }
    else if (sText == STR_WITHDRAW)
    {
      miCZRemoveCandidate(sNation, sID);
      DeleteLocalInt(oNation, VAR_ELECT_INIT);
    }
    else if (sText == STR_LEADER_BANK)
    {
      //Removed: Everyone can see the treasury, so why have a check here to see if the can deposit gold?
      //Withdrawal option is handled in zdlg_bank, as well as the writ removal.
     /* if(!md_GetHasPowerSettlement(MD_PR_CKB, oPC, sFactionID))
      {
        SendMessageToPC(oPC, "You do not have the power to do that");
        return;
      } */
      SetLocalString(oPC, "BANK_OVERRIDE_ID", "N" + sNation);
      SetDlgPageInt(0);
      EndDlg();
      LeaderLog(GetPCSpeaker(), "Accessed bank account of " + sNationName);
      AssignCommand(oPC, DelayCommand(1.0, StartDlg(oPC, oNPC, "zdlg_bank", TRUE, FALSE)));
    }
    else if (sText == STR_LEADER_FOREIGN)
    {
      SetDlgPageString(LIST_FOREIGN);
      SetDlgPageInt(0);
    }
    else if (sText == STR_LEADER_PERSONAL)
    {
      SetDlgPageString(LIST_PERSONAL);
      SetDlgPageInt(0);
    }
    else if(sText == STR_FACTION)
    {
      EndDlg();
      SetLocalString(oPC, "zzdlgCurrentDialog", "zz_co_nation");
      ActionStartConversation(oPC, "zzdlg_conv", TRUE, FALSE);
    }
    else if (sText == STR_WRIT_REQUEST)
    {
      object oWrit = CreateItemOnObject("micz_writ", oPC);
      SetLocalString(oWrit, VAR_NATION, sNation);
      //so as to not get reisgn menu
      SetLocalInt(oPC, VAR_RESIGN, 0);
      SetLocalInt(oPC, VAR_DLG_TAX, -1);
    }
    else if(sText == STR_REMLEA)
    {
        if(GetLocalInt(oNation, VAR_NUM_LEADERS) == 1)
        {
            SetDlgPageString(LIST_REPLACE);
        }
        else
        {
            DeleteList(LIST_FACLEA);
            DeleteList(LIST_HOLDER);
            string sHolder;
            SQLExecStatement("SELECT p.name, r.holder_id FROM gs_pc_data AS p INNER JOIN micz_rank AS r ON p.id=r.pc_id INNER JOIN md_fa_members AS m ON m.pc_id=r.pc_id AND r.fac_id=m.faction_id WHERE p.nation=? AND r.fac_id= ANY (SELECT faction_id FROM md_fa_members WHERE is_OwnerRank=1 AND pc_id=?)", sNation, sID);
            while(SQLFetch())
            {
                sHolder = SQLGetData(2);
                AddStringElement(SQLGetData(1), LIST_FACLEA);
                AddStringElement(sHolder, LIST_HOLDER);
            }

            if(GetElementCount(LIST_FACLEA) == 1)
            {
                SetLocalString(oNPC, VAR_HOLDER, sHolder);
                SetDlgPageString(LIST_REPLACE);
            }
            else
                SetDlgPageString(LIST_FACLEA);
        }

    }
    else if(sText == STR_CANPW)
    {
         SetDlgPageString(LIST_CANPW);
    }
    else if(sText == STR_NOBLE)
        SetDlgPageString(LIST_NOBLE);
    else
    {
      EndDlg();
    }
  }
  else if (sDlg == LIST_FOREIGN)
  {


    // Get the named nation
    string sForeign = miCZGetBestNationMatch(chatGetLastMessage(oPC));
    if (sForeign == "")
    {
       SendMessageToPC(oPC, "Nation not found, please speak as much of the " +
            "exact name as you can remember. Case does not matter.");
       return;
    }



    if(sText == STR_TRADE_OPEN || sText == STR_TRADE_CLOSE)
    {
        // Continue
        int nPower = bOwner || md_GetHasPowerSettlement(MD_PR2_SUT, oPC, sFactionID, "2");
        if(!nPower)
        {
          SendMessageToPC(oPC, "You do not have the power to do that");
          return;
        }
        // Open/close trade.
        miCZSetTrade(sNation, sForeign, sText == STR_TRADE_OPEN);
        SendMessageToPC(oPC, sNationName + ((sText == STR_TRADE_OPEN) ? " will supply " :
            " will no longer supply ") + miCZGetName(sForeign) + " in trade.");

        if(nPower == 3)
        {
            object oWrit = GetItemPossessedBy(oPC, "micz_writ_sgn");
            if (GetIsObjectValid(oWrit))
            {
              SpeakString("*takes a writ, checks it over, and removes it.*");
              gsCMReduceItem(oWrit);
            }
        }

        SetDlgPageInt(0);
    }
    else if(sText == STR_WAR_DECLARE || sText == STR_PEACE_DECLARE)
    {
        // Continue
        int nPower = md_GetHasPowerSettlement(MD_PR2_WAR, oPC, sFactionID, "2");
        if(!nPower)
        {
          SendMessageToPC(oPC, "You do not have the power to do that");
          return;
        }

        // Declare/cease war
        miCZSetWar(sNation, sForeign, sText == STR_WAR_DECLARE);
        SendMessageToPC(oPC, sNationName + ((sText == STR_WAR_DECLARE) ? " will now attack " :
            " will no longer attack ") + miCZGetName(sForeign) + " on sight.");

        if(nPower == 3)
        {
            object oWrit = GetItemPossessedBy(oPC, "micz_writ_sgn");
            if (GetIsObjectValid(oWrit))
            {
              SpeakString("*takes a writ, checks it over, and removes it.*");
              gsCMReduceItem(oWrit);
            }
        }

        SetDlgPageInt(0);
    }
    else if(sText == STR_VASSAL)
    {
        // Continue
        if(md_GetHasWrit(oPC, sFactionID, 0) == 0 || !miCZGetIsLeader(oPC, sNation))
        {
          SendMessageToPC(oPC, "You do not have the power to do that");
          return;
        }

        // Become vassal
        miCZSetVassal(sNation, sForeign);
        SendMessageToPC(oPC, miCZGetName(sForeign) + " is now " + sNationName +
         "'s protectorate.");

        object oWrit = GetItemPossessedBy(oPC, "micz_writ_sgn");
        if (GetIsObjectValid(oWrit))
        {
            SpeakString("*takes a writ, checks it over, and removes it.*");
            gsCMReduceItem(oWrit);

        }

        SetDlgPageInt(0);

    }
  }
  else if (sDlg == LIST_PERSONAL)
  {
    // Find the PC ID
    string sSpoken   = chatGetLastMessage(oPC);
    string sTargetID = "";
    if (sSpoken == "" && (nSelection == 1 || nSelection == 2 )) //Changed because we only need to display this message for invoking and removing banishment
    {
      SendMessageToPC(oPC, "Please speak the character's name (or a few letters) before choosing an option.");
      return;
    }

    //--------------------------------------------------------------------------
    // From here on we do seperate queries, since we can narrow down the search
    // a little depending on what option the leader chooses.
    //--------------------------------------------------------------------------


    // List citizens  - Removed
    /*if (nSelection == 0)
    {
        // Modified by Scholar Midnight on 14/11/2014.
        // Calls out to the nwnx_arelith plugin -- eliminating TMIs and need to format the data.
        // Returns one single string, which is a list of names. IDs aren't required for the display
        // of the citizen list, so there's no need to process then.

        object note = CreateItemOnObject("gs_citroster", oPC);
        SetLocalInt(note, "_NOSTACK", 1);

        string presentableNationName = StringReplace(miCZGetName(sNation), "_", " ");
        SetName(note, presentableNationName + " Citizenship Roster");

        SetLocalString(GetModule(), "NWNX!ARELITH!REQUESTS!GET_CITIZEN_LIST", sNation);
        string list = GetLocalString(GetModule(), "NWNX!ARELITH!REQUESTS!GET_CITIZEN_LIST");
        string registrarName = GetName(oNPC);
        string pcName = GetName(oPC);

        string desc = "This document details the citizenship roster for "
                      + presentableNationName + ", requested by " + pcName +
                      " on " + gsTIGetPresentableTime()+ ".\n\n" + list +
                      "\n\nSigned by " + registrarName;

        SetDescription(note, desc);

        string dialogue = "\n\n[" + registrarName + " hands you a note " +
                          "detailing the list of citizens in the " +
                          presentableNationName + " district.]";

        SetLocalString(OBJECT_SELF, VAR_ADDL_TXT, StringToRGBString(dialogue, STRING_COLOR_GREEN));
    }
    // Revoke citizenship - removed
    /*
    else if (nSelection == 1)
    {
      //Special exception for masters, they can remove if they have power
      int nOverride = md_GetHasPowerSettlement(MD_PR2_RVC, oPC, sFactionID, "2");
      if(!nOverride)
      {
        SendMessageToPC(oPC, "You do not have the power to do that");
        return;
      }
      SQLExecStatement("SELECT id, name FROM gs_pc_data WHERE name LIKE ? AND " +
       "nation=? AND DATE_SUB(CURDATE(), INTERVAL 37 DAY) < modified " +
       "ORDER BY modified DESC LIMIT 10", "%" + sSpoken + "%", sNation);

      // Parse results into LIST_NAMES & LIST_IDS.
      ParseNameList();

      if (GetElementCount(LIST_NAMES) == 0)
      {
        SendMessageToPC(oPC, "Player not found, please speak the character's name (or a few letters) before choosing an option. Those who are not citizens will not be searched.");
        return;
      }
      else if (GetElementCount(LIST_NAMES) == 1)
      {
        string sTarget = GetStringElement(0, LIST_IDS);
        if (miCZGetHasAuthority(sID, sTarget, sNation, nOverride)) Revoke(sTarget, sNation);
        else SendMessageToPC(oPC, "You're not authorized to do that.");
      }
      else
      {
        SetDlgPageString(LIST_NAMES);
        SetLocalString(OBJECT_SELF, VAR_ACTION, ACTION_REVOKE);
      }
      if(nOverride == 3)
      {
        object oWrit = GetItemPossessedBy(oPC, "micz_writ_sgn");
        if (GetIsObjectValid(oWrit))
        {
          SpeakString("*takes a writ, checks it over, and removes it.*");
          gsCMReduceItem(oWrit);
        }
      }
    }
     */
    // List exiles
    if (sText == STR_LISTEX)
    {
      // Allow anyone to list exiles.
      //if(!md_GetHasPowerSettlement(MD_PR2_LIE, oPC, sNationName, "2"))
      //{
      //  SendMessageToPC(oPC, "You do not have the power to do that");
      //  return;
      //}
      SQLExecStatement("SELECT p.id, p.name FROM gs_pc_data AS p INNER JOIN " +
       "micz_banish AS b ON b.pc_id = p.id WHERE b.nation=?", sNation);

      // Parse results into LIST_NAMES & LIST_IDS.
      ParseNameList();

      // Append the names to a list.
      string sList = "";
      int nCount;
      for (nCount = 0; nCount < GetElementCount(LIST_NAMES); nCount++)
      {
        sList += GetStringElement(nCount, LIST_NAMES) + "\n";
      }

      SetLocalString(OBJECT_SELF, VAR_ADDL_TXT, "\n\nList of exiles:\n" + sList);
    }
    // Banish PC
    else if (sText == STR_BANISH)
    {
      int nOverride = md_GetHasPowerSettlement(MD_PR2_EXL, oPC, sFactionID, "2");
      //Allow vassal masters to boot the leader
      if(!miCZGetIsMaster(oPC, sNation) && !nOverride)
      {
        SendMessageToPC(oPC, "You do not have the power to do that");
        return;
      }
      // Get the PC name...
      SQLExecStatement("SELECT id, name FROM gs_pc_data WHERE name LIKE ? " +
       "ORDER BY modified DESC LIMIT 10", "%" + sSpoken + "%");

      // Parse results into LIST_NAMES & LIST_IDS.
      ParseNameList();

      if (GetElementCount(LIST_NAMES) == 0)
      {
        SendMessageToPC(oPC, "Player not found, please speak the character's name (or a few letters) before choosing an option.");
        return;
      }
      else if (GetElementCount(LIST_NAMES) == 1)
      {
        string sTarget = GetStringElement(0, LIST_IDS);
        if (miCZGetHasAuthority(sID, sTarget, sNation, nOverride)) Banish(sTarget, sNation);
        else SendMessageToPC(oPC, "You're not authorized to do that.");
      }
      else
      {
        SetDlgPageString(LIST_NAMES);
        SetLocalString(OBJECT_SELF, VAR_ACTION, ACTION_BANISH);
      }
      if(nOverride == 3)
      {
        object oWrit = GetItemPossessedBy(oPC, "micz_writ_sgn");
        if (GetIsObjectValid(oWrit))
        {
          SpeakString("*takes a writ, checks it over, and removes it.*");
          gsCMReduceItem(oWrit);
        }
      }
    }
    // Lift banishment
    else if (sText == STR_UNBANISH)
    {
      int nOverride = md_GetHasPowerSettlement(MD_PR2_RME, oPC, sFactionID, "2");
      if(!nOverride)
      {
        SendMessageToPC(oPC, "You do not have the power to do that");
        return;
      }
      SQLExecStatement("SELECT p.id, p.name FROM gs_pc_data AS p INNER JOIN " +
       "micz_banish AS b ON b.pc_id = p.id WHERE p.name LIKE ? AND b.nation=?",
       "%" + sSpoken + "%", sNation);

      // Parse results into LIST_NAMES & LIST_IDS.
      ParseNameList();

      if (GetElementCount(LIST_NAMES) == 0)
      {
        SendMessageToPC(oPC, "Player not found, please speak the character's name (or a few letters) before choosing an option. Those who are not banished will not be searched.");
        return;
      }
      else if (GetElementCount(LIST_NAMES) == 1)
      {
        string sTarget = GetStringElement(0, LIST_IDS);
        if (miCZGetHasAuthority(sID, sTarget, sNation, nOverride)) UnBanish(sTarget, sNation);
        else SendMessageToPC(oPC, "You're not authorized to do that.");
      }
      else
      {
        SetDlgPageString(LIST_NAMES);
        SetLocalString(OBJECT_SELF, VAR_ACTION, ACTION_UNBANISH);
      }
      if(nOverride == 3)
      {
        object oWrit = GetItemPossessedBy(oPC, "micz_writ_sgn");
        if (GetIsObjectValid(oWrit))
        {
          SpeakString("*takes a writ, checks it over, and removes it.*");
          gsCMReduceItem(oWrit);
        }
      }
    }
  }
  else if (sDlg == LIST_VOTE)
  {
    CastVote(oNation, sNation, oPC, GetLocalString(oNPC, "CANDIDATE_" + IntToString(nSelection)));
    SetDlgPageString(LIST_DONE);
    SetDlgPageInt(1);
  }
  else if (sDlg == LIST_APPLY)
  {
    // Yes

    if (!nSelection && (GetGold(oPC)  >= MI_CZ_JOIN_PRICE))
    {

      if(GetLocalInt(gsPCGetCreatureHide(oPC), VAR_VOTE_COOLDOWN) != 0)
            SetLocalInt(gsPCGetCreatureHide(oPC), VAR_VOTE_COOLDOWN, gsTIGetTimestamp(GetCalendarYear()+1, GetCalendarMonth(), GetCalendarDay(), GetTimeHour(), GetTimeMinute(), GetTimeSecond()));
      else
            SetLocalInt(gsPCGetCreatureHide(oPC), VAR_VOTE_COOLDOWN, -1);

      SetLocalString(oPC, VAR_NATION, sNation);
      miDASetKeyedValue("gs_pc_data", sID, "nation", sNation);
      SQLExecStatement("DELETE FROM mdcz_cand WHERE candidate=?", sID);
      // If there's not enough in the bank, pay the difference in first.
      gsFIPayIn(oPC, MI_CZ_JOIN_PRICE, "N"+sNation);



      SetDlgPageInt(1);
    }
    else
    {
      SetDlgPageInt(0);
    }

    SetDlgPageString(LIST_DONE);
  }
  else if(sDlg == LIST_CANCEL)
  {
     // Yes

    if (!nSelection)
    {
      SetLocalInt(gsPCGetCreatureHide(oPC), VAR_VOTE_COOLDOWN, -1);
      DeleteLocalString(oPC, VAR_NATION);
      miDASetKeyedValue("gs_pc_data", sID, "nation", "");
      SQLExecStatement("DELETE FROM mdcz_cand WHERE candidate=?", sID);
      SetDlgPageInt(1);
   }
    else
    {
      SetDlgPageInt(0);
    }

    SetDlgPageString(LIST_DONE);
  }
  else if (sDlg == LIST_NAMES)
  {
    if (nSelection != GetElementCount(LIST_NAMES))
    {
      string sAction = GetLocalString(OBJECT_SELF, VAR_ACTION);
      string sTarget = GetStringElement(nSelection, LIST_IDS);

      if (sAction == ACTION_REVOKE)
      {
        if (miCZGetHasAuthority(sID, sTarget, sNation, md_GetHasPowerSettlement(MD_PR2_RVC, oPC, sFactionID, "2"))) Revoke(sTarget, sNation);
        else SendMessageToPC(oPC, "You're not authorized to do that.");
      }
      else if (sAction == ACTION_BANISH)
      {
        if (miCZGetHasAuthority(sID, sTarget, sNation, md_GetHasPowerSettlement(MD_PR2_EXL, oPC, sFactionID, "2"))) Banish(sTarget, sNation);
        else SendMessageToPC(oPC, "You're not authorized to do that.");
      }
      else if (sAction == ACTION_UNBANISH)
      {
        if (miCZGetHasAuthority(sID, sTarget, sNation, md_GetHasPowerSettlement(MD_PR2_RME, oPC, sFactionID, "2"))) UnBanish(sTarget, sNation);
        else SendMessageToPC(oPC, "You're not authorized to do that.");
      }
    }

    SetDlgPageString(LIST_PERSONAL);
  }
  else if(sDlg == LIST_APCAN)
  {
    if(sText == STR_REPFAC)
    {
        SetDlgPageString(LIST_APCAN);
    }
    else if(GetLocalInt(oNPC, "MD_EL_SGNUP"))
    {
        SQLExecStatement("INSERT INTO mdcz_registration(nation,fac_id) VALUES (?,?)", sNation, GetStringElement(nSelection, LIST_FACID));
        SQLExecStatement("INSERT INTO mdcz_cand(nation, candidate, fac_id) VALUES (?,?,?)", sNation, sID, GetStringElement(nSelection, LIST_FACID));
        SetDlgPageInt(1);
        SetDlgPageString(LIST_DONE);
    }
    else
    {
        if(_miCZIsElectionInProgress(sNation))
            miCZAddCandidate(sNation, sID, GetStringElement(nSelection, LIST_FACID));
        else
            miCZStartElection(sNation, sID, GetStringElement(nSelection, LIST_FACID));

        SetDlgPageInt(1);
        SetDlgPageString(LIST_DONE);
    }
  }
  else if(sDlg == LIST_FACLEA)
  {
    SetLocalString(oNPC, VAR_HOLDER, GetStringElement(nSelection, LIST_HOLDER));
    SetDlgPageString(LIST_REPLACE);
  }
  else if(sDlg == LIST_REPLACE)
  {
    string sLeaderID;
    string sNewLeaderID;
    string sHolder;
    if(GetLocalInt(oNation, VAR_NUM_LEADERS) == 1)
    {
        sHolder = "1";
    }
    else
    {
        sHolder = GetLocalString(oNPC, VAR_HOLDER);
    }
    sLeaderID = GetLocalString(oNation, VAR_CURRENT_LEADER + sHolder);
    sNewLeaderID = GetStringElement(nSelection, LIST_REPID);
    SetLocalString(oNation, VAR_CURRENT_LEADER + sHolder, sNewLeaderID);
    SQLExecStatement("UPDATE micz_rank SET pc_id=? WHERE pc_id=?", sNewLeaderID, sLeaderID);
    SetDlgPageString(LIST_DONE);
  }
  else if(sDlg == LIST_CANPW)
  {
    SQLExecStatement("DELETE FROM mdcz_cand WHERE candidate=?", GetStringElement(nSelection, LIST_REPID));
  }
  else if (sDlg == MI_ZD_INPUT)
  {
    int nPower = md_GetHasPowerSettlement(MD_PR2_CHT, oPC, sFactionID, "2");
    if(!nPower)
    {
      SendMessageToPC(oPC, "You do not have the power to do that");
      return;
    }
    // Tax
    string sTax = GetLocalString(oPC, MI_ZD_TEXT);
    float fTax  = StringToFloat(sTax);
    if (fTax > 99.0)
    {
      fTax = 99.0;
    }

    miCZSetTaxRate(sNation, fTax / 100);
    miZDSetInputPrompt(GetText(TEXT_TAX_PROMPT,
                               gsCMGetAsString(miCZGetTaxRate(sNation) * 100)));
    if(nPower == 3)
    {
      object oWrit = GetItemPossessedBy(oPC, "micz_writ_sgn");
      if (GetIsObjectValid(oWrit))
      {
          SpeakString("*takes a writ, checks it over, and removes it.*");
          gsCMReduceItem(oWrit);
      }
    }
  }
  else if(sDlg == LIST_NOBLE)
  {
    int nWrit = md_GetHasWrit(oPC, sFactionID, 0);
    if(sText == "[CONFIRM]")
    {
        int x;
        int nStatus;
        string sID;

        for(x = 0; x <= GetElementCount(LIST_NOBLE); x++)
        {
            sID = GetStringElement(x, LIST_REPID);
            nStatus = GetLocalInt(oPC, LIST_NOBLE+sID);
            DeleteLocalInt(oPC, LIST_NOBLE+sID); //so no issues later
            if(nStatus == 1)
                SQLExecStatement("UPDATE md_fa_members SET is_Noble=1 WHERE faction_id=? AND pc_id=?", sFactionID, sID);
            else if(nStatus == -1)
            {
                SQLExecStatement("UPDATE md_fa_members SET is_Noble=NULL WHERE faction_id=? AND pc_id=?", sFactionID, sID);
                SQLExecStatement("UPDATE micz_nations SET noble_remove=noble_remove-1,noble_timestamp=? WHERE id=?", IntToString(gsTIGetActualTimestamp() + NOBLE_TK_TIMESTAMP), sNation);
                SQLExecStatement("UPDATE md_fa_members AS m INNER JOIN md_fa_factions AS f ON m.faction_id=f.id SET m.is_Noble=NULL WHERE m.faction_id IN ( SELECT tempM.tempID FROM (SELECT faction_id AS  tempID FROM md_fa_members WHERE is_OwnerRank=1 AND pc_id=? ) AS tempM)" +
                " AND (f.type IS NULL OR f.type !=?)", sID, IntToString(FAC_NATION));
            }
        }
        if(nWrit == 3)
        {
            object oWrit = GetItemPossessedBy(oPC, "micz_writ_sgn");
            if (GetIsObjectValid(oWrit))
            {
                SpeakString("*takes a writ, checks it over, and removes it.*");
                gsCMReduceItem(oWrit);
            }
        }
    }
    else
    {
        string sID = GetStringElement(nSelection, LIST_REPID);
        int nNoble = GetLocalInt(oPC, LIST_NOBLE+sID);
        if(nNoble != 0)
            DeleteLocalInt(oPC, LIST_NOBLE+sID); //selected again, revert back to default
        else
        {
          SQLExecStatement("SELECT is_Noble FROM md_fa_members WHERE faction_id=? AND pc_id=? AND is_Noble=1", sFactionID, sID);
          if(SQLFetch()) //turn off noble
          {
            if(GetLocalInt(oPC, LIST_NOBLE+"_REMOVE") > 0 && (nWrit == 1 || nWrit == 3)) //greater than 0 just in case a negative is passed through
                SetLocalInt(oPC, LIST_NOBLE+sID, -1);
            else
                SendMessageToPC(oPC, "You cannot remove a noble.");
          }
          else if(nWrit == 1 || nWrit == 3)
          {  //turn on noble
            if(GetLocalInt(oPC, LIST_NOBLE+"_COUNT") >= 4)
            {
                SendMessageToPC(oPC, "You must remove a noble before accepting a new one.");
                return;
            }
            SetLocalInt(oPC, LIST_NOBLE+sID, 1);

          }
        }

    }

  }
}
void Cleanup()
{
  object oPC = GetPcDlgSpeaker();
  DeleteLocalInt(oPC, VAR_FIRST_TIME);
}

