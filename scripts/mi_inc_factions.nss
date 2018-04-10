/*
  fb_inc_factions

  Written by Fireboar (with some edits by Mith)
  Design by Mithreas
  Heavily Edited by Morderon.

  Library to handle faction creation and membership.  Key capabilities:
   - Allow any player to create any number of factions.
     - Cannot create a faction that already exists
   - Allow any player to join any number of factions
   - Allow faction leaders to have control of their faction
     - Including deleting it.
   - Allow faction leadership to be passed on (multiple 'leaders' can exist)
   - Allow scripts to quickly check "is X in Y faction"
     - Cache locally (-1 to mean 0) to ensure maximum perf
   - Allow broadcast of ooc messages to factions (expire after 1 RL week)
   - Allow PCs to receive all messages for all their factions
   - Allow DMs to check all active messages (SELECT DISTINCT faction = list).
   - The creation and removal of ranks
     -And the ability to place PCs within them
   - The ability to give or take a wide range of powers.
   - Draws from locally cached data.
   - Lists for settlement factions and other factions.
   - Lists for Non-members (Salaried), members, ranks and owners for each faction
   - Settlement leaders are leaders of their settelement factions
     - As well as any child factions
     - Have complete authority in both
   - To become an owner of a child faction is done by a settlement leader
     through the settlement coordinator
     - Can have more than one owner
   -these powers include view ranks, view members, view messages
   -And recruit, they can give any of their default powers

   Helpful hints:
   A faction can forcefully be loaded by 'creating' it.

   Database tables:
   (1) fb_fa_members
    - faction                                  VARCHAR(50)
    - pcid                                     VARCHAR(50)
    - rank                                     VARCHAR(50)
    - powers                                   BIGINT(20), Unsigned
    - powersST                                 BIGINT(20), Unsigned
    - pay                                      INT(11), signed
    - timestamp                                INT(11), Unsigned

create table fb_fa_members (faction VARCHAR(50), pcid VARCHAR(50), rank VARCHAR(50), powers INT(10), timestamp INT(11), pay INT(10), modified TIMESTAMP(8));

   (2) fb_fa_messages
    - faction (starts with 0 1 2 or 3)         VARCHAR(51)
    - message                                  TEXT
    - timestamp                                INT(11), Unsigned

create table fb_fa_messages (faction VARCHAR(51), message TEXT, timestamp INT(11), modified TIMESTAMP(8));


  Ranks are handled like this (IC of course these would be represented differently):
   - -1: Not associated
   -  0: Non-member that receives salary or pays dues
   -  1: Member (can be placed into a custom rank)
   -  2: Unused
   -  3: Owner


  Messages when sent can be sent selectively to a certain rank or above, as given
  by the first character of the "Faction" table in fb_fa_messages. So 0 sends
  the message to all members, 1 to messengers and above, 2 to officers and above
  and 3 only to the owner. To disable this feature, set FB_FA_SELECTIVE_MESSAGING
  to FALSE.
  Above no longer applies as of 2/24/11

  Now to specify a rank(s) type {rank or part of rank} in {} at start of message
  Update by Mith, March 2008:
    Dozens of factions led to us having a huge amount of info on the module.  So
    I've redesigned the library to store its information on a local cache
    object.  See miDAGetCacheObject() in mi_inc_database.

    The module stores: Faction ID -> name mapping
                       Number of factions

    The cache object is keyed by faction name, and stores:
                       Name -> ID mapping
                       Member lists
                       Everything else.

    We also hit a TMI when trying to load over 50ish factions' worth of info
    from the database.  To work around this, get a list of factions and then
    load each one individually.

*/
//To do list:

//2) Add give salary to non-member job

// Required libraries
//

#include "mi_inc_database"
//#include "gs_inc_finance"
#include "mi_inc_citizen"
#include "mi_log"

//
// Constants
//

// Change this to FALSE to disallow messages being sent selectively through factions
const int FB_FA_SELECTIVE_MESSAGING = TRUE;
// Set this to the amount of time the message remains in circulation (in seconds)
const int FB_FA_MESSAGE_TIME = 1209600; // 2 weeks
//Set this to the amount time members last in the faction without logging in.
const int MD_FA_MEMBER_LIMIT = 1209600; // 2 weeks
//Set this to the amount of time the faction survives without an active owner.
const int MD_FA_FACTION_LIMIT = 2419200; //4 weeks
// Set this to TRUE to use real time for the above, FALSE to use game time
const int FB_FA_USE_REAL_TIME = TRUE;
//Remove rank, not really a rank, just a reponse to let people know when a rank has been removed
const string MD_FAC_RANK_REMOVED = "Rank Removed";
//Vassal rank, masters of vassals return this rank
const string MD_FAC_VAS_RANK = "VASSAL";
//Factions other than settlements start at this number
//Prefixes
//These are now defined in the md_factions_hb script
//Procedes a settlement faction and faction ID in the sql database
const string SETTLEMENT_PREFIX = "ST_";
//procedes a child faction in the sql database and faction ID
const string CHILD_PREFIX = "CF_";
const string FACTION_DB = "FACTIONS";

//List of powers start here.
//Faction Management:
const int MD_PR_VAM = 0x00000001;
const string MD_PRS_VAM = "View members";
const int MD_PR_VRK = 0x00000002;
const string MD_PRS_VRK = "View Ranks";
const int MD_PR_RNRA = 0x0000004;
const string MD_PRS_RNRA = "Rename Any Rank (Includes View Ranks)";
const int MD_PR_RNR = 0x00000008;
const string MD_PRS_RNR = "Rename Rank (Character's division only, includes View Ranks)";
const int MD_PR_ADR = 0x00000010;
const string MD_PRS_ADR = "Create Rank";
const int MD_PR_RMR = 0x00000020;
const string MD_PRS_RMR = "Remove Rank (Includes View Ranks)";
const int MD_PR_GPM = 0x00000040;
const string MD_PRS_GPM = "Give Powers to other Members (Includes View Members)";
const int MD_PR_GPR = 0x00000080;
const string MD_PRS_GPR = "Give Powers to Ranks (Includes View Ranks)";
const int MD_PR_CHR = 0x00000100;
const string MD_PRS_CHR = "Change character's rank (Includes View Members and View Ranks)";
const int MD_PR_REC = 0x00000200;
const string MD_PRS_REC = "Recruit";
const int MD_PR_RMM = 0x00000400;
const string MD_PRS_RMM = "Remove Member (includes View Members)";
const int MD_PR_IMM = 0x00000800;
const string MD_PRS_IMM = "Immunity (Character/Rank can only be modified by owners)";
const int MD_PR_REF = 0x00001000;
const string MD_PRS_REF = "Refresh Faction";
const int MD_PR_VPM = 0x00002000;
const string MD_PRS_VPM = "View member powers (Includes View Members)";
const int MD_PR_VPR = 0x00004000;
const string MD_PRS_VPR = "View rank powers (Includes View Ranks)";

//OOC messages
const int MD_PR_VFM = 0x00008000;
const string MD_PRS_VFM = "View Messages";
const int MD_PR_CFM = 0x00010000;
const string MD_PRS_CFM = "Create Message (includes View Messages)";
const int MD_PR_RMS = 0x00020000;
const string MD_PRS_RMS = "Remove Message (includes View Messages)";
const int MD_PR_SAM = 0x00040000;
const string MD_PRS_SAM = "See all messages regardless of rank (Includes View Messages)";

//Fixtures
const int MD_PR_RNF = 0x00080000;
const string MD_PRS_RNF = "Rename/Redescribe Fixtures";
const int MD_PR_TDM = 0x00100000;
const string MD_PRS_TDM = "Remove Messages from Message Boards";

//Shops
const int MD_PR_SSF = 0x00200000;
const string MD_PRS_SSF = "See Shop Owned By Faction";
const int MD_PR_PIS = 0x00400000;
const string MD_PRS_PIS = "Place Item in Shop (Includes See Shop Owned)";
const int MD_PR_RIS = 0x00800000;
const string MD_PRS_RIS = "Remove Item from Shop (Includes See Shop Owned)";

//Banks
const int MD_PR_CKB = 0x01000000;
const string MD_PRS_CKB = "Check Balance";
const int MD_PR_GSL = 0x02000000;
const string MD_PRS_GSL = "Set Member Salary (Includes View Members, Includes View Member Salaries)";
const int MD_PR_WDG = 0x04000000;
const string MD_PRS_WDG = "Withdrawal (Includes Check Balance)";
const int MD_PR_VMS = 0x08000000;
const string MD_PRS_VMS = "View Member Salaries (Includes View Members)";
const int MD_PR_VRS = 0x10000000;
const string MD_PRS_VRS = "View Rank Salaries (Includes View Ranks)"; //settlements only
const int MD_PR_VMD = 0x20000000;
const string MD_PRS_VMD = "View Member Dues (Includes View Members)";
const int MD_PR_VRD = 0x40000000;
const string MD_PRS_VRD = "View Rank Dues (Includes View Ranks.)"; //settlements only
const int MD_PR_VOD = 0x80000000;
const string MD_PRS_VOD = "View Outsiders Paying Dues";
//List (2) two powers start here, specify list two ("2") when
//setting powers and checking for powers
const int MD_PR2_VOS = 0x00000001;
string MD_PRS_VOS = "View Outsiders Being Payed Salaries";
const int MD_PR2_VAS = 0x00000002;
const string MD_PRS_VAS = "View Outsider Salaried Amount (Includes View Outsiders (Salary))";
const int MD_PR2_VAD = 0x00000004;
const string MD_PRS_VAD = "View Outsider Due Amount (Includes View Outsiders (Due)).";
const int MD_PR2_SOS = 0x00000008;
const string MD_PRS_SOS = "Set Outsider Salary (Includes View Outsiders (Salary) & View Outsider Salary Amount)";
const int MD_PR2_AOS = 0x00000010;
const string MD_PRS_AOS = "Add Salaried Outsider (Includes Set Outsider Salary, View Outsider (Salary), View Outsider Salary Amount)";
const int MD_PR2_ROD = 0x00000020;
const string MD_PRS_ROD = "Remove Outsider Paying Due (Includes View Outsider (due))";
const int MD_PR2_ROS = 0x00000040;
const string MD_PRS_ROS = "Remove Outsider Being Payed Salary (Includes View Outsider (Salary))";
const int MD_PR2_SRS = 0x00000080;
const string MD_PRS_SRS = "Set Salaries for Ranks (Includes View Rank Salaries, View Ranks)"; //Settlement Only
const int MD_PR2_SRD = 0x00000100;
const string MD_PRS_SRD = "Set Dues for Ranks (Includes View Rank Dues, View Ranks)"; //Settlement Only

//Settlement
const int MD_PR2_EXL = 0x00000200;
const string MD_PRS_EXL = "Exile."; //goes through authority as well
const int MD_PR2_RME = 0x00000400;
const string MD_PRS_RME = "Remove Exile."; //goes through authority as well
const int MD_PR2_RVH = 0x00000800;
const string MD_PRS_RVH = "Revoke Housing.";
const int MD_PR2_RVS = 0x00001000;
const string MD_PRS_RVS = "Revoke Shop.";
const int MD_PR2_CHT = 0x00002000;
const string MD_PRS_CHT = "Modify Taxes.";
const int MD_PR2_RSB = 0x00004000;
const string MD_PRS_RSB = "Modify Buy/Sell Prices for Resources.";
const int MD_PR2_SUT = 0x00008000;
const string MD_PRS_SUT = "Manage Foreign Trade.";
const int MD_PR2_WAR = 0x00010000;
const string MD_PRS_WAR = "Start/Cease War.";
const int MD_PR2_LIC = 0x00020000;
const string MD_PRS_LIC = "List citizens.";
const int MD_PR2_RVC = 0x00040000;
const string MD_PRS_RVC = "Revoke citizens."; //goes through authority as well
const int MD_PR2_LIE = 0x00080000;
const string MD_PRS_LIE = "List exiles.";

//Shops continued:
const int MD_PR2_SPR = 0x00800000;
const string MD_PRS_SPR = "Set default shop prices (Includes See Shop Owned)";
const int MD_PR2_SCP = 0x01000000;
const string MD_PRS_SCP = "Set custom shop prices (Includes See Shop Owned)";
const int MD_PR2_SCI = 0x02000000;
const string MD_PRS_SCI = "Set custom shop prices when placing items in shop only";

//Skipped variables
const int MD_PR2_KEY = 0x00100000;
const string MD_PRS_KEY = "Create Key/Keyless Entry";
const int MD_PR2_CAP = 0x00200000;
const string MD_PRS_CAP = "Captain";
//const int = 0x00400000;
//const int = 0x04000000;
//const int = 0x08000000;
//const int = 0x10000000;
//const int = 0x20000000;
//const int = 0x40000000;
//const int = 0x80000000;

//Shop abilities from shop convsation
const string ABL_TOG = "{Shop} Toggle faction display.";
const int ABL_B_TOG = 0x01;
const string ABL_SPR = "{Factions} Set default prices.";
const int ABL_B_SPR = 0x02;
const string ABL_PLI = "{Factions} Place items in shop.";
const int ABL_B_PLI = 0x04;
const string ABL_TKI = "{Factions} Take items from shop.";
const int ABL_B_TKI = 0x08;
const string ABL_STK = "{Shop} Buy partial stacks.";
const int ABL_B_STK = 0x10;
const string ABL_SCP = "{Factions} Set custom prices.";
const int ABL_B_SCP = 0x20;
const string ABL_SCI = "{Factions} Set custom prices, placed items only.";
const int ABL_B_SCI = 0x40;

//Variables used in shop convsation.
const string VAR_FTAX = "MD_VAR_FTAX";
const string VAR_FID = "MD_VAR_FID";
const string VAR_FAB = "MD_VAR_FAB";

//Faction types
const int FAC_NATION = 0x40000000; //used in mi_inc_citizen w/o the constant due to circular depenancies.. be mindful if needs to be changed
const int FAC_DIVISION = 0x20000000;  //want these two to be the highest, also known as child factions
const int FAC_NORMAL = 0;
const int FAC_BROKER = 0x01;

//Includes view members, view ranks
//Withdrawal, check balance
//All OOC messaging
//Both view powers
//Don't set banish power, vassals can banish everyone with that power
//but without it they can only banish settlement leaders
//const int VASSAL_POWERS =  1;

//Other powers variables aren't required for:
//Disband faction (owner only)
//Leave faction (open to all)
//Set Due (open to all)
//Change Rank to Owner (Owner only)
//
// Function prototypes
//

// Initializes each faction and saves them and their members on the module. Should
// be run OnModuleLoad. Also removes all old faction related data.
void fbFALoadFactions();
// Called by fbFALoadFactions on a DelayCommand to avoid hitting the TMI limit.
// sPrefix is SETTLEMENT_PREFIX for settlements, child factions
// should be loaded by loading the settlement faction.
// sNation is the id of the nation
void fbFALoadFaction(string sFactionID, string sFactionName, string sDatabaseID, int nPower1, int nPower2, int nPowerST1, int nPowerST2, int nTimetamp, string sPrefix="", string sNation = "");
// Wrapper of: gsPCGetPlayerID
string fbFAGetPCID(object oPC);
// Wrapper of: gsPCGetPlayerName
string fbFAGetNameFromID(string sID);
// Returns the ID of sFaction. The ID is usually numeric
// The id of a faction is alpha-numeric for settlement and child factions
string fbFAGetFactionID(string sDatabaseID);
// Returns the name of nFaction, place in SETTLEMENT_PREFIX for sSuffix to gather
// the settlement factions
// Use sID to get the name from the ID
// Using nFaction and sSuffix is good when you're looping through factions
// And when you want to specify a list
// sID is used when you only have the faction ID to work with
string fbFAGetFactionNameCacheID(int nFaction);
//Retrieves the name using the DatabaseID
string fbFAGetFactionNameDatabaseID(string sDatabaseID);
//Retrives the databaseID from the name using the SQL database
string mdfaGetDatabaseIDFromName(string sTable, string sName, string sAnd = "");
// Creates a faction with sName under oLeader's leadership and returns its ID
// OBJECT INVALID accepted if faction has no leader
// Returns 0 if everything worked fine.
// Returns 1 if faction already exists
// Returns 2 if sName was too long (>50 chars)
// Returns 3 if sName is an empty string ("")
// sPrefix is either SETTLEMENT or CHILD_ prefix
// sNation is the nations NAME (if any)
int fbFACreateFaction(string sName, object oLeader = OBJECT_SELF, string sPrefix = "", string sNation = "", int nType=0);
// Renames faction with  to sNewNamee
// nSelection is the current ID of the faction (or in the case of ranks and child factions, the rank ID)
// Returns 0 if everything worked fine.
// Returns 1 if faction already exists
// Returns 2 if sName was too long (>50 chars)
// Returns 3 if sName is an empty string ("")
// sPrefix is either SETTLEMENT or CHILD_ prefix
int md_FaRenameFaction(string sNewName, string sDatabaseID, string sPrefix="");
// Removes a faction
// System (variable cleanup happens on reset)
void fbFARemoveFaction(string sDatabaseID, string sPrefix = "");
// Refreshes the faction, can only be used once per minute
int md_faRefreshFaction(string sDatabaseID);
// Retrieve the faction's nation (if any)
// Will return "" if there is no nation
// This returns the nation's ID and not the nation's name
// Also acts as a cache for miCZGetBestNationMatch()
string md_GetFacNation(string sDatabaseID);
// Returns the rank of oPC within nFaction (or "" if oPC is not associated)
// This will return owner or vassal rank
// Wraper of fbFAGetRank, with the additional that it ignores the outsider rank
//int fbFAGetRankIgnoreOutsider(string sDatabaseID, object oPC = OBJECT_SELF);
//Returns true if oPC is member of the faction with ID sDatabaseID
int mdFAInFaction(string sDatabaseID, object oPC = OBJECT_SELF);
// Returns the rank of oPC within nFaction (or "" if oPC is not associated)
// This will return owner or vassal rank
int fbFAGetRank(string sDatabaseID, object oPC = OBJECT_SELF);
// Returns the rank of sID within nFaction (or "" if sID is not associated)
// This will only return owner rank if sID belongs to a NEW as of that reset
// faction owner. Does not return vassal rank.
int fbFAGetRankByID(string sDatabaseID, string sID);
// Promotes oPC to sRank
int fbFAChangeRank(object oPC, string sDatabaseID, int nRank = FB_FA_MEMBER_RANK);
// Promotes the PC that corresponds with sID to sRank
int fbFAChangeRankByID(string sID, string sDatabaseID, int nRank = FB_FA_MEMBER_RANK);
//Adds sRank to sFactionName.
// Returns 0 if everything worked fine.
// Returns 1 if rank already exists
// Returns 2 if sRank was too long (>50 chars)
// Returns 3 if sRank is an empty string ("")
// Returns 4 if sRank is a number
int md_FaAddRank(string sRank, string sDatabaseID, int nTimestamp = 0);
//Removes sRank from sDatabaseID, nSelection is the DLG selection
int md_FaRemoveRank(int nSelection, string sDatabaseID);
// Renames the rank to the new rank, nSelection is the DLG selection
// Returns 0 if everything worked fine.
// Returns 1 reserved
// Returns 2 if sNewRank was too long (>50 chars)
// Returns 3 if sNNewRank is an empty string ("")
// Returns 4 if sNewRank is a number
int md_FaRenameRank(int nSelection, string sDatabaseID, string sNewRank);
// Returns true if oPC is owner (or DM). DM's return as 99
int fbFAGetIsOwningRank(string sDatabaseID, object oPC, int nNation = FALSE);
// Returns true if sID is that of an owners.
// Settlement leaders having owning rank for nation and child factions
// Those with the settlement rank that match's the child's faction's name
// Are owners when nNation is False;
int fbFAGetIsOwningRankByID(string sDatabaseID, string sID, int nNation = FALSE);
// Gets the owner count for the faction
int md_FaOwnerCount(string sDatabaseID);
// Returns the unique ID of owner number nNth in nFaction
string fbFAGetNthOwnerID(string sDatabaseID, int nNth);
// oMember adds oPC to nFaction. Returns FALSE if unsuccessful, TRUE if successful
// No longer used as once was. Now sends everything through AddMemberByID
int fbFAAddMember(object oPC, string sDatabaseID);
// oMember adds oPC to nFaction. Returns FALSE if unsuccessful, TRUE if successful
int fbFAAddMemberByID(string sID, string sDatabaseID);
//Adds a salaried/due member to the guild based on pay.
//Returns 0 on success
//Returns 1 when nPay is 0
//Returns 2 when sID is already a member
int md_FA_AddOutsider(string sID, string sDatabaseID, int nPay, int nPayIN=TRUE);
// Returns the number of members in nFaction
int fbFAGetMemberCount(string sDatabaseID);
// Returns member number nNth in nFaction as an object if online, or OBJECT_INVALID
object fbFAGetNthMember(string sDatabaseID, int nNth);
// Returns the unique ID of member number nNth in nFaction
string fbFAGetNthMemberID(string sDatabaseID, int nNth);
// True if oPC has the power on their own private list. Always true for owners and DMs
//Owners include: DMs, Faction, If appropriate for faction type (and nNation being true): Nation leaders and division ranked
int md_GetHasPower(int nPower, object oPC, string sDatabaseID, string sList = "1", int nNation = FALSE);
// Gets the Ranks/PC power from sID or Rank's name, only use when the PC is not required to be logged in
// Use this if you wish to bypass the owner check for PCs
int md_GetHasPowerByID(int nPower, string sID, string sDatabaseID, string sList = "1", int nNation = FALSE);
// Nation Leader from local cache
int GetIsNationLeaderByIDFromCache(string sID, string sDatabaseID);
// Nation Master from Cache
int GetIsNationMasterByIDFromCache(string sID, string sDatabaseID);
// Checks if oPC has the power through a job given to the PC or a job given to the PC's rank
//Checks the PC, rank, and faction power list, should return TRUE for owners and DMs.
//nNation only applies for division factions, if TRUE checks the settlement version of the lists instead
//As well as checking the parent faction's power lists, but only if the PC belongs to a rank matching the division faction's name
//If it doesn't involve settlements, this is probably what you're looking for
int md_GetHasPowerMaster(int nPower, object oPC, string sDatabaseID, string sList = "1", int nNation = FALSE);
// Checks if oPC has the power through a job given to the PC or a job given to the PC's rank
// Wrapper of PowerMaster, checks the faction and then the nation the faction belongs to (if any)
// To see if oPC has the power
// If withdrawing gold, checks for a writ if needed
// For everything else checks primary faction. In addition for nation factions will check main settlement faction.
// Main settlements can snoop in on child factions, child factions can't do the same
// To be used for division factions OR non-settlement factions
int md_GetHasPowerBank(int nPower, object oPC, string sDatabaseID, string sList = "1");
//Shop power check
//Same check as md_GetHasPowerBank
//Also in addition checks, for main settlement factions, if power was given through a child faction's settlement list.
//Can be used for any type of faction
int md_GetHasPowerShop(int nPower, object oPC, string sDatabaseID, string sList = "1");
//Loops through factions in sName (signaled by {}) to see if oPC has the power to modify
//This is for fixtures
// Same check as shop basically.. not wrapped.
int md_GetHasPowerFixture(int nPower, object oPC, string sName, string sList = "1");
//Checks to see if oLeader has a valid writ.
//Returns FALSE (0) in the case the leader does not have a writ
//Returns TRUE (1) in the case the leader does not require a writ
//Returns 3 in the case has a writ
//Returns 2 in the case that a leader wasn't passed through the function.
//sDatabaseID should be the faction ID
//If nPower is set to 0, writs will always be required if it's a faction/nation that uses writs
int md_GetHasWrit(object oLeader, string sDatabaseID, int nPower, string sList = "1", int nNation=FALSE);
//Checks to see if they have the power for the settlement
//Returns 3 in the case the leader has a writ and it's required
// Checks for writs
// Checks if power is on primary list
// Checks if power is on any child faction list
// To be used only for main settlement factions
int md_GetHasPowerSettlement(int nPower, object oPC, string sDatabaseID, string sList = "1");
// Gives or takes away a power from Rank/Owner of sID depending of value of nGive
// nPower should be a MD_PR_* constant
void md_SetPower(int nPower, string sID, string sDatabaseID, int nGive=TRUE, string sList = "1", int nNation = FALSE);
// Loads all the messages for nFaction to the module and returns the number of
// messages + 1. Internally used, should not be called from anywhere
int fbFALoadMessages(string sDatabaseID, string sPrefix = "");
// Saves a message for nFaction. Returns FALSE if if went smoothly, 1 if oMessenger
// is not allowed to send messages for nFaction, 2 if sMessage is too long (there
// is a 400 character limit on messages). nRank specifies which ranks are allowed
// to receive the message (0 is all)
// Messages show for anyone whose rank is similar to the rank specified in {} in the message
int fbFACreateMessage(string sMessage, string sDatabaseID, object oMessenger = OBJECT_SELF);
// Returns nMessage on nFaction. If oPC is specified, will return nothing if oPC
// is not in the faction or not of a high enough rank unless they are a DM
string fbFAGetMessageByID(string sDatabaseID, int nMessage, object oPC = OBJECT_INVALID);
// Removes nMessage from the database and reloads nFaction's messages
void fbFARemoveMessage(string sDatabaseID, int nMessage);
// Returns the number of active messages for nFaction
int fbFAGetMessageCount(string sDatabaseID);
// Sets the number of active messages for nFaction to nAmount
void fbFASetMessageCount(string sDatabaseID, int nAmount);
// Check whether any of the PC's factions have messages in them.
// Potentially a lengthy search but at least everything should be cached :(
void fbFACheckMessages(object oPC, int nStart = 1, int nEnd = 50);
//Called in onClientEnter, updates PC's faction timestamps.
void md_UpdateMemberTimestamp(object oPC);
//Called in onClientEnter, updates faction timestamps.
void md_UpdateFactionTimestamp(string sDatabaseID);
//Creates timestamp based on realtime variable
int md_CreateTimestamp(int nTime);
// Retrieves when the faction expires, 0 when it doesn'te expire
int md_GetFactionTime(string sDatabaseID);
//Calls every function that needs to run onClientEnter for factions
void md_FactionClientEnter(object oPC);
//Retrives sID's pay. Postive number is dues and negative number is salaries
int md_GetFacPay(string sID, string sDatabaseID);
//Sets sIDs Pay
//Returns 0 on success
//Returns 1 if nPay is 0 and sID is succesfully remove from the outsider rank
//Returns 2 if nPay is 0 and sID cannot be removed from the outsider rank
//Checks if oPC has the power to remove sID, If oPC is invalid no check is necessary.
int md_SetFacPay(string sID, string sDatabaseID, int nPay, int nPower = MD_PR2_ROS, object oPC=OBJECT_INVALID, int nPayIN=FALSE);
//Gets the pay total, sType should be "SAL" or "DUE"
int md_GetFacPayTotal(string sDatabaseID, string sType="SAL");
//Gets nNth outsider sID by listt (either in or out)
string md_GetnNthOutsiderID(string sDatabaseID, int nNth, string sList="IN");
//DoMonthlySalary, handles paying salary (and collecting dues)
//Due to errors in implementing mi_inc_factions2 as an include with
void DoMonthlySalary();
//Get the DatabaseID from the faction's name
string md_GetDatabaseID(string sName);
//Retrieves the shop id, first attempts a local variable then from the SQL database
string md_SHLoadFacID(object oShop=OBJECT_SELF);
//Retrieves the shop tax, first attempts a local variable then from the SQL database
string md_SHLoadFacTax(object oShop=OBJECT_SELF);
//Retrieves the shop ability, first attempts a local variable then from the SQL database
int md_SHLoadFacABL(int nAbility, object oShop=OBJECT_SELF);
//Calculates Bounties
/*int md_BountyMultiplier(object oDefeated, string sNation);
//Checks if faction is at war
int md_FactionsAtWar(object oOffense, object oDefense, string sIgnoreNat="0", int nPay = FALSE);*/
//Internal functions below here
void _LoadFactionIfNotExist(string sID, string sDatabaseID, string sName, int nPower1, int nPower2, int nPowerST1, int nPowerST2, int nTimestamp, string sPrefix = "", string sNation = "");
void _fbFALoadFactions();
int _RetrieveFactionFromDB(string sName, object oPC);
int _FactionErrors(string sName, string sPrefix, object oPC);
int _md_IsRank(string sRank, string sDatabaseID);
int _RankErrors(string sRank, string sDatabaseID);
int _IsOwningRank(string sID, string sDatabaseID);
void _AddMemberVariables(string sID, string sDatabaseID);
//void _CreateFactionBankAccount(string sFactionName);
void _AddOutsiderVariables(string sID, string sDatabaseID, int nPay);
// Returns TRUE if sLeaderID has authority to act over sCitizenID.  This will be
// true unless sCitizenID and sLeaderID are peers (e.g. fellow councilors).  A
// councilor can be banished etc by the leader of a master state.
// Mord added an override so that these powers can be designated
// Where there is more than one leader, a whit signed by a majority is needed.
int miCZGetHasAuthority(string sLeaderID, string sCitizenID, string sNation, int nOverride=FALSE);
// Returns the type of faction, see FAC_* constants for options
int GetFactionType(string sFactionID);




//
// Function implementation
//
void fbFALoadMessagesVoid(string sDatabaseID)
{
  fbFALoadMessages(sDatabaseID);
}

//----------------------------------------------------------------
void fbFALoadFaction(string sFactionID, string sFactionName, string sDatabaseID, int nPower1, int nPower2, int nPowerST1, int nPowerST2, int nTimestamp, string sPrefix = "", string sNation = "")
{

  Trace(FACTION_DB, ".. confirmling load of faction " + sFactionName + " Database ID " + sDatabaseID + " Faction ID " + sFactionID);
  //Call the information from the database
  int nOwner, nDivision, nPay, nNMember;
  int nSal, nDue, nOwnerRank, nRank, nOldRank;
  string sID, sRank;
  int nRankC = 0;
  object oModule = GetModule();
  //Save information locally on this object.
  object cacheObject = miDAGetCacheObject(DATABASE_PREFIX+sDatabaseID);
  //Save the faction ID
  SetLocalString(cacheObject, "MD_FA_ID", sFactionID);
  SetLocalString(cacheObject, "MD_FA_NAME", sFactionName);
  //Save the nation the child faction belongs to.
  if(sNation != "")
  {
    SetLocalString(cacheObject, "MD_FA_NATION", sNation);
  }
  //Only rank factions will have pay
  if(nTimestamp)
    SetLocalInt(cacheObject, "MD_FAC_TIME", nTimestamp);

  if(sPrefix != "")
    SetLocalString(cacheObject, "MD_FAC_PREFIX", sPrefix);

  SetLocalString(oModule, "MD_FA_"+sFactionName, sDatabaseID);
  SetLocalString(oModule, "MD_FA_DATABASEID_"+sFactionID, sDatabaseID);


  if(nPower1 != 0) SetLocalInt(cacheObject, "MD_FA_POWER_1_F", nPower1);
  if(nPowerST1 != 0) SetLocalInt(cacheObject, "MD_FA_POWER_ST_1_F", nPowerST1);
  if(nPower2 != 0) SetLocalInt(cacheObject, "MD_FA_POWER_2_F", nPower2);
  if(nPowerST2 != 0) SetLocalInt(cacheObject, "MD_FA_POWER_ST_2_F", nPowerST2);

  //Cache ranks
  SQLExecDirect("SELECT id,name,powers1,powersST1,powers2,powersST2,pay FROM md_fa_ranks WHERE faction_id ='"
                     + sDatabaseID + "'");

  while(SQLFetch())
  {
    sID = SQLGetData(1);
    sRank = SQLGetData(2);
    //nPay = StringToInt(SQLGetData(3));
    nPower1 = StringToInt(SQLGetData(3));
    nPowerST1 = StringToInt(SQLGetData(4));
    nPower2 = StringToInt(SQLGetData(5));
    nPowerST2 = StringToInt(SQLGetData(6));
    nPay = StringToInt(SQLGetData(7));
    Trace(FACTION_DB, "LOADING RANKS Rank ID: " + sID + " Rank Name " + sRank);
    SetLocalString(cacheObject, "MD_FA_RANK_"+IntToString(++nDivision), sID);
    SetLocalString(cacheObject, "MD_FA_RANK_R"+sID, sRank);
    if(nPower1 != 0) SetLocalInt(cacheObject, "MD_FA_POWER_1_R"+sID, nPower1);
    if(nPowerST1 != 0) SetLocalInt(cacheObject, "MD_FA_POWER_ST_1_R"+sID, nPowerST1);
    if(nPower2 != 0) SetLocalInt(cacheObject, "MD_FA_POWER_2_R"+sID, nPower2);
    if(nPowerST2 != 0) SetLocalInt(cacheObject, "MD_FA_POWER_ST_2_R"+sID, nPowerST2);

    if(nPay != 0)
      SetLocalInt(cacheObject, "MD_FA_PAY_R"+sID, nPay);

    if(nPay < 0)//Pay out/salary
      nSal += nPay;
    else if(nPay > 0) //Pay in/dues
      nDue += nPay;
  }



  SQLExecDirect("SELECT pc_id,rank_id,pay,powers1,powersST1,powers2,powersST2,is_OwnerRank FROM md_fa_members WHERE faction_id ='"
                     + sDatabaseID + "' ORDER BY rank_id");
  // Loop through each member
  while (SQLFetch())
  {
    sID = SQLGetData(1);
    nRank = StringToInt(SQLGetData(2));
    nPay = StringToInt(SQLGetData(3));
    nPower1 = StringToInt(SQLGetData(4));
    nPowerST1 = StringToInt(SQLGetData(5));
    nPower2 = StringToInt(SQLGetData(6));
    nPowerST2 = StringToInt(SQLGetData(7));
    nOwnerRank = StringToInt(SQLGetData(8));
    // Store PC's rank and the fact that they're a member
    //Gets the integers from sPower and sPowerST
    Trace(FACTION_DB, "LOADING MEMBERS PCID: " + sID + " Rank ID " + IntToString(nRank) + " Owner " + IntToString(nOwnerRank));

    // Store the owners of the faction.
    if (nOwnerRank)
    {
      SetLocalString(cacheObject, "MD_FA_OWNER_"+IntToString(++nOwner), sID);

    }
    //Store ranks/divisions and their powers, pcid is rank  for divisions
    else if(nRank != 1)
    {
     // SetLocalString(cacheObject, "MD_FA_M"+IntToString(++nMembers), sID);
      if(nPower1 != 0) SetLocalInt(cacheObject, "MD_FA_POWER_1_"+sID, nPower1);
      if(nPowerST1 != 0) SetLocalInt(cacheObject, "MD_FA_POWER_ST_1_"+sID, nPowerST1);
      if(nPower2 != 0) SetLocalInt(cacheObject, "MD_FA_POWER_2_"+sID, nPower2);
      if(nPowerST2 != 0) SetLocalInt(cacheObject, "MD_FA_POWER_ST_2_"+sID, nPowerST2);
      //Seperate list for members of settlements only, ties the rank through variable
      //to pcid for easy retrival
      if(sPrefix == SETTLEMENT_PREFIX)
      {
        //Can only do it this way because the sql call is ordered by rank.
        //When ranks change, refresh
        if(nOldRank != nRank)
        {
          if(nOldRank != 0)
            SetLocalInt(cacheObject, "MD_FA_R"+IntToString(nOldRank), nRankC);

          nOldRank = nRank;
          nRankC = 0;
        }
        SetLocalString(cacheObject, "MD_FA_R"+IntToString(nRank)+"_"+IntToString(++nRankC), sID);
      }


    }
    //Store PC as non-member, but salaried
    else
    {
    /*  if(nPay < 0)//Pay out/salary
        SetLocalString(cacheObject, "MD_FA_POUT_"+IntToString(++nPayOUT), sID);
      else if(nPay > 0) //Pay in/dues
        SetLocalString(cacheObject, "MD_FA_PIN_"+IntToString(++nPayIN), sID);
      */
      nRank = FB_FA_NON_MEMBER;
    }

    if(nRank == 0)
        nRank = FB_FA_MEMBER_RANK;
    SetLocalInt(cacheObject, "MD_FA_MR_"+sID, nRank);

    Trace(FACTION_DB, "LOADING MEMBERS PCID: " + sID + " Rank ID changed to " + IntToString(nRank));
    //Store pay
    if(nPay != 0) SetLocalInt(cacheObject, "MD_FA_PAY_"+sID, nPay);
    if(nPay < 0)//Pay out/salary
      nSal += nPay;
    else if(nPay > 0) //Pay in/dues
      nDue += nPay;


  }
  //Store count of owners, member, nMembers, and ranks
  SetLocalInt(cacheObject, "MD_FA_OWNER", nOwner);
 // SetLocalInt(cacheObject, "MD_FA_POUT", nPayOUT);
 // SetLocalInt(cacheObject, "MD_FA_PIN", nPayIN);
 // SetLocalInt(cacheObject, "MD_FA", nMembers);
  SetLocalInt(cacheObject, "MD_FA_RANK", nDivision);

  //Store pay in and outs totals
  SetLocalInt(cacheObject, "MD_FA_SAL", nSal);
  SetLocalInt(cacheObject, "MD_FA_DUE", nDue);
  Trace(FACTION_DB, "Information cached to object with tag " + GetTag(cacheObject));

  DelayCommand(0.1, fbFALoadMessagesVoid(sDatabaseID));
}
//----------------------------------------------------------------
//Checks to see if the faction does not already exist before loading it
void _LoadFactionIfNotExist(string sID, string sDatabaseID, string sName, int nPower1, int nPower2, int nPowerST1, int nPowerST2, int nTimestamp, string sPrefix = "", string sNation = "")
{
  object oModule = GetModule();
  Trace(FACTION_DB, "gs_m_load: Attempting to load faction " + sName);
  if(GetLocalString(oModule, "MD_FA_"+sName) == "")
  {
    fbFALoadFaction(sID, sName, sDatabaseID, nPower1, nPower2, nPowerST1, nPowerST2, nTimestamp, sPrefix, sNation);
  }
}
//----------------------------------------------------------------
void _mdFALoadNationFac()
{
  object oModule = GetModule();
  string sFactionName, sFactionID, sDatabaseID, sNationID, sPrefix;
  int nPower, nPower2, nPowerST1, nPowerST2, nTimestamp;
  //Check to see if any factions have been loaded already.

  int nFactionID = GetLocalInt(oModule, "MD_FA_HIGHEST");
 // int nFactionID = GetLocalInt(oModule, "MD_FA_HIGHEST_ST");
 // SQLExecDirect("SELECT md.id, mi.name, mi.id, md.powers1, md.powers2, md.powersST1, md.powersST2, md.timestamp  FROM micz_nations AS mi INNER JOIN md_fa_factions AS md ON "+
//                "md.name = CONCAT('"+SETTLEMENT_PREFIX+"', mi.name) ORDER BY md.id");

  //Load settlement factions and child factions, I want them listed first
  SQLExecDirect("SELECT id, name, nation, powers1, powers2, powersST1, powersST2, timestamp FROM md_fa_factions WHERE nation > 0 ORDER BY name DESC");
  while (SQLFetch())
  {
      sDatabaseID = SQLGetData(1);
      sFactionName = SQLGetData(2);
      sNationID = SQLGetData(3);
      nPower = StringToInt(SQLGetData(4));
      nPower2 = StringToInt(SQLGetData(5));
      nPowerST1 = StringToInt(SQLGetData(6));
      nPowerST2 = StringToInt(SQLGetData(7));
      nTimestamp = StringToInt(SQLGetData(8));

      nFactionID++;
      sPrefix = GetStringLeft(sFactionName, 3);
      sFactionName = GetStringRight(sFactionName, GetStringLength(sFactionName) - 3);

      DelayCommand(1.0 * IntToFloat(nFactionID), _LoadFactionIfNotExist(IntToString(nFactionID), sDatabaseID,
                         sFactionName, nPower, nPower2, nPowerST1, nPowerST2, nTimestamp, sPrefix, sNationID));


  }

  SetLocalInt(oModule, "MD_FA_HIGHEST", nFactionID);
}
//----------------------------------------------------------------
void _mdFALoadPlayerFactions(int nStart, int nCount)
{
  object oModule = GetModule();
  string sFactionName, sFactionID, sDatabaseID;
  int nPower, nPower2, nPowerST1, nPowerST2, nTimestamp;
  //Check to see if any factions have been loaded already.

  int nFactionID = GetLocalInt(oModule, "MD_FA_HIGHEST");
  int nOFID = nFactionID;

  SQLExecDirect("SELECT id,name,powers1,powers2,powersST1,powersST2,timestamp FROM md_fa_factions WHERE name not like '"+SETTLEMENT_PREFIX+"%' AND"+
                " name not like '"+CHILD_PREFIX+"%' LIMIT " +  IntToString(nStart) + "," + IntToString(nCount));

  // Loop through each faction
  while (SQLFetch())
  {
      sDatabaseID = SQLGetData(1);
      sFactionName = SQLGetData(2);
      nPower = StringToInt(SQLGetData(3));
      nPower2 = StringToInt(SQLGetData(4));
      nPowerST1 = StringToInt(SQLGetData(5));
      nPowerST2 = StringToInt(SQLGetData(6));
      nTimestamp = StringToInt(SQLGetData(7));
      nFactionID++;
      sFactionID = IntToString(nFactionID);
      DelayCommand(1.0 * IntToFloat(nFactionID), _LoadFactionIfNotExist(sFactionID, sDatabaseID, sFactionName, nPower, nPower2, nPowerST1, nPowerST2, nTimestamp));
  }

  if(nFactionID > nOFID)
  {
    SetLocalInt(oModule, "MD_FA_HIGHEST", nFactionID);
    DelayCommand(0.1, _mdFALoadPlayerFactions(nStart+50, 50));
  }
}
//----------------------------------------------------------------
//For Delay, loads factions
void _fbFALoadFactions()
{
  DelayCommand(0.1, _mdFALoadNationFac());
  DelayCommand(0.2, _mdFALoadPlayerFactions(0, 50));
}
//----------------------------------------------------------------
void fbFALoadFactions()
{
    Trace(FACTION_DB, "Loading function called from gs_m_load.");
    //_MergeDatabase();
    //Check factions first.
    string sTimestamp = IntToString(gsTIGetActualTimestamp());     //Member rank holds the timestamp for the faction

    //Delete any old factions                                                               //For some reason between wasn't working here
    SQLExecDirect("SELECT id FROM md_fa_factions WHERE name LIKE '"+CHILD_PREFIX +"%' AND timestamp BETWEEN  '1' AND '"+sTimestamp+"'");
    string sFaction;
    //Some factions are not deleted, and their timestamp is set to 0.
    while(SQLFetch())
    {
      //Delay it so it goes through every faction without interferance
      sFaction = SQLGetData(1);
      DelayCommand(0.1, fbFARemoveFaction(sFaction, CHILD_PREFIX));
    }
    DelayCommand(0.2, SQLExecDirect("DELETE FROM md_fa_factions WHERE timestamp BETWEEN  '1' AND '"+sTimestamp+"'"));
    //Delete inactive members                                 //don't delete it if it doesn't have a value
    //Delay as remove faction above may delete it
    DelayCommand(0.3, SQLExecDirect("DELETE FROM md_fa_members WHERE timestamp BETWEEN  '1' AND '"+sTimestamp+"'"));
    //Delete all old messages  Delay as remove faction above may delete it
    DelayCommand(0.3, SQLExecDirect("DELETE FROM md_fa_messages WHERE timestamp BETWEEN  '1' AND '"+sTimestamp+"'"));

    //Load the factions, Delay this to make sure all factions are
    //deleted before it runs
    DelayCommand(0.4, _fbFALoadFactions());

}
//----------------------------------------------------------------
string fbFAGetPCID(object oPC)
{
    return gsPCGetPlayerID(oPC);
}
//----------------------------------------------------------------
string fbFAGetNameFromID(string sID)
{
  return gsPCGetPlayerName(sID);
}
//----------------------------------------------------------------
string fbFAGetFactionID(string sDatabaseID)
{
  return GetLocalString(miDAGetCacheObject(DATABASE_PREFIX+sDatabaseID), "MD_FA_ID");
}
//----------------------------------------------------------------
string fbFAGetFactionNameCacheID(int nFaction)
{
  return fbFAGetFactionNameDatabaseID(GetLocalString(GetModule(), "MD_FA_DATABASEID_"+IntToString(nFaction)));
}
//----------------------------------------------------------------
string fbFAGetFactionNameDatabaseID(string sDatabaseID)
{
  return GetLocalString(miDAGetCacheObject(DATABASE_PREFIX+sDatabaseID), "MD_FA_NAME");
}
//----------------------------------------------------------------
string mdfaGetDatabaseIDFromName(string sTable, string sName, string sAnd = "")
{
  SQLExecStatement("SELECT id FROM "+sTable+" WHERE name='"+SQLEncodeSpecialChars(sName)+"' " + sAnd + " LIMIT 1");

  if(SQLFetch())
  {
    return SQLGetData(1);
  }

  return "";
}
//----------------------------------------------------------------
// Used during faction creation.
// If the faction was not loaded for whatever reason,
// This will load the faction
int _RetrieveFactionFromDB(string sName, object oPC)
{


   object oModule = GetModule();
   //Norm
   SQLExecDirect("SELECT id,powers1,powers2,powersST1,powersST2,timestamp,name,nation FROM md_fa_factions WHERE " +
                 "name='"+SQLEncodeSpecialChars(sName) + "' OR name='"+SQLEncodeSpecialChars(CHILD_PREFIX+sName)+"' OR " +
                  "name = '"+SQLEncodeSpecialChars(SETTLEMENT_PREFIX+sName)+"'");

   if(SQLFetch()) //Not cached, so cache it
   {
      Trace(FACTION_DB, "Failed to create: Attempting to load faction " + sName);
     // Add the faction to the module
      int nFaction = GetLocalInt(oModule, "MD_FA_HIGHEST") + 1;
      string sFactionID = IntToString(nFaction);
      string sDatabaseID = SQLGetData(1);
      string sPrefix = SQLGetData(7);
      string sNation = SQLGetData(8);
      if(sNation != "")
      {
        sPrefix = GetStringLeft(sPrefix, 3);
      }
      else
        sPrefix = "";

      SetLocalInt(oModule, "MD_FA_HIGHEST", nFaction);
      //Set the Faction ID
      //Set the faction name on module
      fbFALoadFaction(sFactionID, sName, sDatabaseID, StringToInt(SQLGetData(2)), StringToInt(SQLGetData(3)), StringToInt(SQLGetData(4)), StringToInt(SQLGetData(5)), StringToInt(SQLGetData(6)), sPrefix, sNation);
      return TRUE;
   }

   return FALSE;

}
//Errors for factions
int _FactionErrors(string sName, string sPrefix, object oPC)
{

   //Faction Names cannot be blank.
   if(sName == "") return 3;
   // Name too long, Factions can only be 50 characters long.
   if (GetStringLength(sPrefix + sName) > 50) return 2;

   // Already exists
   if (GetLocalString(GetModule(), "MD_FA_"+sName) != "" || sName == MD_FAC_RANK_REMOVED) return 1;

   //Have to check the sql database too as the faction
   //might not be cached. If the facion is cached already the
   //above statement will catch it.
   if(_RetrieveFactionFromDB(sName, oPC)) return 1;


   return 0;
}
//----------------------------------------------------------------
int fbFACreateFaction(string sName, object oLeader = OBJECT_SELF, string sPrefix = "", string sNation = "", int nType=0)
{

    int nError = _FactionErrors(sName, sPrefix, oLeader);

    if(nError) return nError;

    string sFactionID;
    int nFactionID;
    int nTimestamp;
    object oModule = GetModule();

    // Add the faction to the module
    int nFaction = GetLocalInt(oModule, "MD_FA_HIGHEST") + 1;
    sFactionID =  IntToString(nFaction);

    SetLocalInt(oModule, "MD_FA_HIGHEST", nFaction);
    //Set the Faction ID
    //Set the faction name on module
    if(sPrefix != SETTLEMENT_PREFIX)
      nTimestamp = md_CreateTimestamp(MD_FA_FACTION_LIMIT);
    //Bank accounts for normal factions!
    //_CreateFactionBankAccount(sName);
    string sSQLNation;
    if(sNation != "")
    {
      sNation = miCZGetBestNationMatch(sNation);
      sSQLNation = "'"+sNation+"'";
    }
    else
      sSQLNation="NULL";


    //Place the faction in the database
    SQLExecStatement("INSERT INTO md_fa_factions (name,timestamp,nation,type) VALUES (?,?,"+sSQLNation+",?)", sPrefix+sName, IntToString(nTimestamp), IntToString(nType));


    string sDatabaseID = mdfaGetDatabaseIDFromName("md_fa_factions", sPrefix+sName);
    //lets load the faction into the database first than do the ID.
    object oCacheObject = miDAGetCacheObject(DATABASE_PREFIX+sDatabaseID);
    if(nTimestamp)
      SetLocalInt(oCacheObject, "MD_FAC_TIME", nTimestamp);

    SetLocalString(oCacheObject, "MD_FA_NATION", sNation);
    SetLocalString(oCacheObject, "MD_FA_ID", sFactionID);
    SetLocalString(oModule, "MD_FA_"+sName, sDatabaseID);
    SetLocalString(oModule, "MD_FA_DATABASEID_"+sFactionID, sDatabaseID);
    SetLocalString(oCacheObject, "MD_FA_NAME", sName);

    //Invalid for child factions and settlements
    if(oLeader != OBJECT_INVALID)
    {
      string sPCID = fbFAGetPCID(oLeader);

       // Add the creator as the first member (its owner)
      SetLocalString(oCacheObject, "MD_FA_OWNER_1", sPCID);
      //Owner count
      SetLocalInt(oCacheObject, "MD_FA_OWNER", 1);
      // Store this information on the database
      SQLExecStatement("INSERT INTO md_fa_members (pc_id,faction_id,is_OwnerRank) VALUES (?,?,?)",
                       sPCID, sDatabaseID, "1");


    }

    //Add New Member division here, this rank is added so Powers can be given
   // md_FaAddRank(FB_FA_MEMBER_RANK, sName, nTimestamp);
    return 0;
}
//----------------------------------------------------------------
int md_FaRenameFaction(string sNewName, string sDatabaseID, string sPrefix="")
{
  int nError = _FactionErrors(sNewName, sPrefix, OBJECT_INVALID);
  if(nError) return nError;

  object oModule = GetModule();
  string sOldName = fbFAGetFactionNameDatabaseID(sDatabaseID);
  //Open up the old name for use
  DeleteLocalString(oModule, "MD_FA_"+sOldName);
  SetLocalString(oModule, "MD_FA_"+sNewName, sDatabaseID);
  SetLocalString(miDAGetCacheObject(DATABASE_PREFIX+sDatabaseID), "MD_FA_NAME", sNewName);
  //Kill the old faction cache

  SQLExecStatement("UPDATE md_fa_factions SET name=?"+
                      " WHERE id=?", sPrefix+sNewName, sDatabaseID);

  return 0;
}
//----------------------------------------------------------------
void fbFARemoveFaction(string sDatabaseID, string sPrefix = "")
{

    // Drop it from the module
    object oModule = GetModule();
    object oCache = miDAGetCacheObject(DATABASE_PREFIX+sDatabaseID);
    string sFactionName = GetLocalString(oCache, "MD_FA_NAME");
    DeleteLocalString(oModule, "MD_FA_"+sFactionName);
    string sFactionID = GetLocalString(oCache, "MD_FA_ID");
    DeleteLocalString(oModule, "MD_FA_DATABASEID_"+sFactionID);
    DeleteLocalString(oCache, "MD_FA_NAME");

    //Child faction, give the gold in the account back to the settlement
    if(sPrefix == CHILD_PREFIX)
    {
      SQLExecDirect("SELECT bank,nation FROM md_fa_factions WHERE id='"+sDatabaseID+"' AND bank > '-1000'");

      string sNation;
      string sBank;
      if(SQLFetch())
      {
        sBank = SQLGetData(1);
        sNation = SQLGetData(2);




        gsFITransferFromTo("F"+sDatabaseID, "N"+sNation, StringToInt(sBank)+1000);

      }
    }

    // Remove the database entries
    SQLExecDirect("DELETE FROM md_fa_factions WHERE id='"+sDatabaseID+"'");
}
//----------------------------------------------------------------
int md_faRefreshFaction(string sDatabaseID)
{
  int nTime = gsTIGetActualTimestamp();
  object oCache = miDAGetCacheObject(DATABASE_PREFIX+sDatabaseID);
  if(nTime < GetLocalInt(oCache, "MD_FAC_REFRESHTL"))
    return FALSE; //To soon to do it again
  //Not again for 60 seconds
  SetLocalInt(oCache, "MD_FAC_REFRESHTL", nTime + 60);

  string sFactionID = fbFAGetFactionID(sDatabaseID);

  string sNation = md_GetFacNation(sDatabaseID);


  string sName = fbFAGetFactionNameDatabaseID(sDatabaseID);
  string sPrefix = GetLocalString(oCache, "MD_FAC_PREFIX");
  int nPower1 = GetLocalInt(oCache, "MD_FA_POWER_1_F");
  int nPowerST1 = GetLocalInt(oCache, "MD_FA_POWER_ST_1_F");
  int nPower2 = GetLocalInt(oCache, "MD_FA_POWER_2_F");
  int nPowerST2 = GetLocalInt(oCache, "MD_FA_POWER_ST_2_F");
  int nTimestamp = GetLocalInt(oCache, "MD_FAC_TIME");
  DestroyObject(oCache);

  DelayCommand(0.1, fbFALoadFaction(sFactionID, sName, sDatabaseID,  nPower1, nPower2, nPowerST1, nPowerST2, nTimestamp, sPrefix, sNation));

  return TRUE;
}
//----------------------------------------------------------------
string md_GetFacNation(string sDatabaseID)
{
  return GetLocalString(miDAGetCacheObject(DATABASE_PREFIX+sDatabaseID), "MD_FA_NATION");
}

//----------------------------------------------------------------
int mdFAInFaction(string sDatabaseID, object oPC = OBJECT_SELF)
{
  // DMs and Owners always have full privileges.
  Trace(FACTION_DB, "IN FACTION Seeing if " + gsPCGetPlayerID(oPC) + " is member of faction with ID " + sDatabaseID +
       " Owner " + IntToString(fbFAGetIsOwningRank(sDatabaseID, oPC)) + " Rank " + IntToString(fbFAGetRank(sDatabaseID, oPC)) +
       " Faction name " + fbFAGetFactionNameDatabaseID(sDatabaseID));
  if (fbFAGetRank(sDatabaseID, oPC) > 0 || fbFAGetIsOwningRank(sDatabaseID, oPC)) return TRUE;

  return FALSE;
}
//----------------------------------------------------------------
int fbFAGetRank(string sDatabaseID, object oPC = OBJECT_SELF)
{
    // If faction has been removed, return "".
    if (GetLocalString(GetModule(), "MD_FA_"+fbFAGetFactionNameDatabaseID(sDatabaseID)) == "")
      return 0;

    // DMs and Owners always have full privileges.
   // if (fbFAGetIsOwningRank(sDatabaseID, oPC)) return FB_FA_OWNER_RANK;

    string sID = fbFAGetPCID(oPC);
    //if(GetIsNationMasterByIDFromCache(sID, sFactionName)) return MD_FAC_VAS_RANK;

    return GetLocalInt(miDAGetCacheObject(DATABASE_PREFIX+sDatabaseID),
                       "MD_FA_MR_"+sID);
}
//----------------------------------------------------------------
int fbFAGetRankByID(string sDatabaseID, string sID)
{
    return GetLocalInt(miDAGetCacheObject(DATABASE_PREFIX+sDatabaseID),
                       "MD_FA_MR_"+sID);
}
//----------------------------------------------------------------
int fbFAChangeRank(object oPC, string sDatabaseID, int nRank = FB_FA_MEMBER_RANK)
{
    // Add a new member?
    if (fbFAGetRank(sDatabaseID, oPC) == 0) return fbFAAddMember(oPC, sDatabaseID);

    return fbFAChangeRankByID(fbFAGetPCID(oPC), sDatabaseID, nRank);
}
//----------------------------------------------------------------
int fbFAChangeRankByID(string sID, string sDatabaseID, int nRank = FB_FA_MEMBER_RANK)
{

    // Add a new member?
    int nOldRank = fbFAGetRankByID(sDatabaseID, sID);
    if (nOldRank == 0) //Add the member if they have no rank
      return fbFAAddMemberByID(sID, sDatabaseID);


    string sFactionID = fbFAGetFactionID(sDatabaseID);
    //Get object to save rank on
    object oCacheObject = miDAGetCacheObject(DATABASE_PREFIX+sDatabaseID);


    //This will be true only for settlement factions
    if(fbFAGetFactionNameDatabaseID(sDatabaseID) == miCZGetName(md_GetFacNation(sDatabaseID)))
    {
     /* string sNation = DATABASE_PREFIX+sDatabaseID;
      object oNatCache = miDAGetCacheObject(sNation);
      string sNatID = fbFAGetFactionID(sNation); */
      string sNID = GetLocalString(oCacheObject, "MD_FA_R"+IntToString(nOldRank)+"_"+"1");
      int nCount = 1;
      //Removed the old rank, these lists shouldn't be to long.
      while(sNID != "")
      {
        if(sNID == sID)
        {
          SetLocalString(oCacheObject, "MD_FA_R"+IntToString(nOldRank)+"_"+IntToString(nCount), "REMOVED");
          break;
        }
        sNID = GetLocalString(oCacheObject, "MD_FA_R"+IntToString(nOldRank)+"_"+IntToString(++nCount));
      }
      //now add to the new rank
      if(nRank != 0 && nRank != FB_FA_MEMBER_RANK && nRank != FB_FA_NON_MEMBER)
      {
        nCount = GetLocalInt(oCacheObject, "MD_FA_R"+IntToString(nRank)) + 1;
        SetLocalString(oCacheObject, "MD_FA_R"+IntToString(nRank)+"_"+IntToString(nCount), sID);
        SetLocalInt(oCacheObject, "MD_FA_R"+IntToString(nRank), nCount);
      }
    }

    //The PC belonged to the outsider rank, so add the member rank variables
    //But don't do if we're removing from the faction anyways
    if(nOldRank == FB_FA_NON_MEMBER && nRank != 0)
      _AddMemberVariables(sID, sDatabaseID);

    // New leader? If so, demote the old one.
    if (nRank == FB_FA_OWNER_RANK)
    {
        string sOldLeaderID = GetLocalString(oCacheObject, "MD_FA_OWNER_1");
        _AddMemberVariables(sOldLeaderID, sDatabaseID);
        SQLExecStatement("UPDATE md_fa_members SET is_OwnerRank=?, timestamp=? WHERE faction_id=? AND pc_id=?", "0", IntToString(md_CreateTimestamp(MD_FA_MEMBER_LIMIT)), sDatabaseID, sOldLeaderID);
        SQLExecStatement("UPDATE md_fa_members INNER JOIN md_fa_factions AS f ON f.id=faction_id SET is_Noble=NULL WHERE faction_id=? AND (type IS NULL OR type!=?)", sDatabaseID, IntToString(FAC_BROKER));
        SetLocalString(oCacheObject, "MD_FA_OWNER_1", sID);
        SetLocalInt(oCacheObject, "MD_FA_MR_"+sID, FB_FA_MEMBER_RANK);
    }
    else if(nRank == 0)
    {
      _RemoveMemFacCache(oCacheObject, sID);
    }
    else if(nRank ==  FB_FA_NON_MEMBER)
    {
      DeleteLocalInt(oCacheObject, "MD_FA_MR_"+sID);
      DeleteLocalInt(oCacheObject, "MD_FA_POWER_1_"+sID);
      DeleteLocalInt(oCacheObject, "MD_FA_POWER_ST_1_"+sID);
      DeleteLocalInt(oCacheObject, "MD_FA_POWER_2_"+sID);
      DeleteLocalInt(oCacheObject, "MD_FA_POWER_ST_2_"+sID);
      _AddOutsiderVariables(sID, sDatabaseID, GetLocalInt(oCacheObject,"MD_FA_PAY_"+sID));
    }
    else
      SetLocalInt(oCacheObject,
                   "MD_FA_MR_"+sID,
                   nRank);

    // Remove membership?
    if (nRank == 0)
    {
        SQLExecStatement("DELETE FROM md_fa_members WHERE faction_id=? AND pc_id=?"
                         ,sDatabaseID, sID);
    }
    else if(nRank == FB_FA_MEMBER_RANK)
    {
      SQLExecStatement("UPDATE md_fa_members SET rank_id=NULL" +
                      " WHERE faction_id=? AND pc_id=?", sDatabaseID, sID);
    }
    else if(nRank == FB_FA_NON_MEMBER)
    {
      SQLExecStatement("UPDATE md_fa_members SET rank_id='1'" +
                      " WHERE faction_id=? AND pc_id=?", sDatabaseID, sID);
    }
    else if(nRank == FB_FA_OWNER_RANK)
    {
      SQLExecStatement("UPDATE md_fa_members SET is_OwnerRank='1', timestamp='0'" +
                    " WHERE faction_id=? AND pc_id=?", sDatabaseID, sID);
    }
    else
    {
      SQLExecStatement("UPDATE md_fa_members SET rank_id=?" +
                      " WHERE faction_id=? AND pc_id=?", IntToString(nRank), sDatabaseID, sID);

    }

    return TRUE;
}

//----------------------------------------------------------------
//Private function, checks if rank already exist
int _md_IsRank(string sRank, string sDatabaseID)
{
   int nRanks = md_FaRankCount(sDatabaseID);
   int nCount;
   string sNth;
   object oCache = miDAGetCacheObject(DATABASE_PREFIX+sDatabaseID);
   for(nCount = 1; nCount <= nRanks; nCount++)
   {
     sNth = GetLocalString(oCache, "MD_FA_RANK_R"+GetLocalString(oCache, "MD_FA_RANK_"+ IntToString(nCount)));
     if(sRank == sNth)
       return nCount;
   }

   return FALSE;
}
//----------------------------------------------------------------
int _RankErrors(string sRank, string sDatabaseID)
{
  //Do not create rank if: Already exists, name to long, "", or reserved rank
  if(sRank == "") return 3;
  if (_md_IsRank(sRank, sDatabaseID) || sRank == MD_FA_MEMBER_RANK
      || sRank == MD_FA_NON_MEMBER || sRank == MD_FA_OWNER_RANK || sRank == MD_FAC_RANK_REMOVED) return 1;

  if(GetStringLength(sRank) > 50) return 2;
 /// if(StringToInt(sRank)) return 4;  //Cannot be a number

  return 0;
}
//----------------------------------------------------------------
int md_FaAddRank(string sRank, string sDatabaseID, int nTimestamp = 0)
{
    int nError = _RankErrors(sRank, sDatabaseID);
    if(nError) return nError;
    // Store in the database
    SQLExecStatement("INSERT INTO md_fa_ranks (faction_id,name) VALUES (?,?)", sDatabaseID, sRank);
    // Add the rank to the cache
    int nRanks = md_FaRankCount(sDatabaseID) + 1;
    object oCacheObject = miDAGetCacheObject(DATABASE_PREFIX+sDatabaseID);
    string sRankID = mdfaGetDatabaseIDFromName("md_fa_ranks", sRank, "AND faction_id='"+sDatabaseID+"'");
    SetLocalString(oCacheObject, "MD_FA_RANK_"+IntToString(nRanks), sRankID);
    SetLocalInt(oCacheObject, "MD_FA_RANK", nRanks);
    SetLocalString(oCacheObject, "MD_FA_RANK_R"+sRankID, sRank);

    return 0;
}
//----------------------------------------------------------------
int md_FaRemoveRank(int nSelection, string sDatabaseID)
{

    object oCacheObject = miDAGetCacheObject(DATABASE_PREFIX+sDatabaseID);


    string sRank = md_FAGetNthRankID(sDatabaseID, nSelection);

    //All those members that were this rank? Demote them to 'new members'
  /*  int nCount;
    string sID;
    int nMemCount = fbFAGetMemberCount(sFactionName);
    for(nCount = 1; nCount <= nMemCount; nCount++)
    {
      sID = fbFAGetNthMemberID(sFactionName, nCount);
      if(fbFAGetRankByID(sFactionName, sID) == sRank)        //Update SQL database later
        fbFAChangeRankByID(sID, sFactionName, FB_FA_MEMBER_RANK, FALSE);
    }    */
    string sFactionID = fbFAGetFactionID(sDatabaseID);
    //This will be true only for settlement factions
    if(FindSubString(sFactionID, SETTLEMENT_PREFIX) == 0)
    {
      string sNation = GetLocalString(GetModule(), "MD_FA_"+miCZGetName(md_GetFacNation(sRank)));
      object oNatCache = miDAGetCacheObject(DATABASE_PREFIX+sNation);
      string sNID = GetLocalString(oNatCache, "MD_FA_R"+sRank+"1");
      int nCount = 1;
      //Removed the old rank, these lists shouldn't be to long.
      while(sNID != "")
      {
        DeleteLocalString(oNatCache, "MD_FA_R"+sRank+IntToString(nCount));
        sNID = GetLocalString(oNatCache, "MD_FA_R"+sRank+IntToString(++nCount));
      }
    }
    //Remove the rank and set the new one.
    SetLocalString(oCacheObject, "MD_FA_RANK_R"+sRank, MD_FAC_RANK_REMOVED);
    //Remove it's powers too
    DeleteLocalInt(oCacheObject, "MD_FA_POWER_1_R"+sRank);
    DeleteLocalInt(oCacheObject, "MD_FA_POWER_ST_1_R"+sRank);
    DeleteLocalInt(oCacheObject, "MD_FA_POWER_2_R"+sRank);
    DeleteLocalInt(oCacheObject, "MD_FA_POWER_ST_2_R"+sRank);
    int nPay = GetLocalInt(oCacheObject, "MD_FA_PAY_R"+sRank);
    if(nPay > 0) //dues
      SetLocalInt(oCacheObject, "MD_FA_DUE",
        GetLocalInt(oCacheObject, "MD_FA_DUE")  - nPay);
    else if(nPay < 0)
      SetLocalInt(oCacheObject, "MD_FA_SAL",
        GetLocalInt(oCacheObject, "MD_FA_SAL") - nPay);
    DeleteLocalInt(oCacheObject, "MD_FA_PAY_R"+sRank);

    //Delete the rank from the database, pcid is blank for ranks
    SQLExecStatement("DELETE FROM md_fa_ranks WHERE id=?", sRank);

    return TRUE;
}

//----------------------------------------------------------------
int md_FaRenameRank(int nSelection, string sDatabaseID, string sNewRank)
{
    //Don't rename rank if it's to long, "" or reserved
    int nError = _RankErrors(sNewRank, sDatabaseID);
    if(nError) return nError;
    //Don't rename rank if it's the member rank as well

    object oCacheObject = miDAGetCacheObject(DATABASE_PREFIX+sDatabaseID);

    string sRank = md_FAGetNthRankID(sDatabaseID, nSelection);

    //Set the new rank, overwrite the old
    SetLocalString(oCacheObject, "MD_FA_RANK_R"+sRank, sNewRank);

    SQLExecStatement("UPDATE md_fa_ranks SET name=?" +
            " WHERE id=?", sNewRank, sRank);

    return FALSE;
}
//----------------------------------------------------------------
int fbFAGetIsOwningRank(string sDatabaseID, object oPC, int nNation = FALSE)
{
  //DM's are also owners
  if(GetIsDM(oPC)) return 99;

  return fbFAGetIsOwningRankByID(sDatabaseID,  fbFAGetPCID(oPC), nNation);
}
//Gets the settlement leader from Cache
int GetIsNationLeaderByIDFromCache(string sID,  string sDatabaseID)
{
  //Get the nation in case it's a child faction
  sDatabaseID = md_GetFacNation(sDatabaseID);
  if(sDatabaseID == "") return FALSE;
  int nCount;
  object oNation = miCZLoadNation(sDatabaseID);
  int nMax = GetLocalInt(oNation, VAR_NUM_LEADERS);

  for(nCount = 1; nCount <= nMax; nCount++)
  {
    if(sID == GetLocalString(oNation, VAR_CURRENT_LEADER + IntToString(nCount)))
    {
      return TRUE;
    }
  }

  return FALSE;
}
//----------------------------------------------------------------
//Gets the settlement master from Cache
int GetIsNationMasterByIDFromCache(string sID, string sDatabaseID)
{
  sDatabaseID = md_GetFacNation(sDatabaseID);
  if(sDatabaseID == "") return FALSE;
  sDatabaseID =  GetLocalString(miCZLoadNation(sDatabaseID), VAR_MASTER);
  if(sDatabaseID == "") return FALSE;

  object oNation = miCZLoadNation(sDatabaseID);
  int nCount;
  int nMax = GetLocalInt(oNation, VAR_NUM_LEADERS);
  for(nCount = 1; nCount <= nMax; nCount++)
  {
    if(sID == GetLocalString(oNation, VAR_CURRENT_LEADER + IntToString(nCount)))
      return TRUE;
  }

  return FALSE;

}
//True if sID belongs to that of an owner
int _IsOwningRank(string sID, string sDatabaseID)
{
  //Loop through the owner list and see if the ID matches
  object oCache = miDAGetCacheObject(DATABASE_PREFIX+sDatabaseID);
  int nOwnerCount = md_FaOwnerCount(sDatabaseID);

  int nCount;
  for(nCount = 1; nCount <= nOwnerCount; nCount++)
  {
    if(sID == GetLocalString(oCache, "MD_FA_OWNER_"+ IntToString(nCount)))
      return nCount;
  }

  return FALSE;
}
//----------------------------------------------------------------
int fbFAGetIsOwningRankByID(string sDatabaseID, string sID, int nNation = FALSE)
{
  //The 'owners' of child factions only count as owners when they're not giving settlement powers
  if(!nNation)
  {

    if(_IsOwningRank(sID, sDatabaseID)) return TRUE;

    string sNation = md_GetFacNation(sDatabaseID);
    if(sNation == "") return FALSE;
    string sNName = miCZGetName(sNation);
    string sFName = fbFAGetFactionNameDatabaseID(sDatabaseID);
    sNation = md_GetDatabaseID(sNName);
    //if rank of our nation and faction name matches, we're the owners
    //Nation name and faction name cannot be the same
    if(sFName != sNName &&
       sFName == md_FAGetRankName(sNation, IntToString(fbFAGetRankByID(sNation, sID))))
      return TRUE;
  }
  //Nation Leaders can be owners too.
  return GetIsNationLeaderByIDFromCache(sID, sDatabaseID);
}
//----------------------------------------------------------------
int md_FaOwnerCount(string sDatabaseID)
{
  return GetLocalInt(miDAGetCacheObject(DATABASE_PREFIX+sDatabaseID), "MD_FA_OWNER");
}
//----------------------------------------------------------------
string fbFAGetNthOwnerID(string sDatabaseID, int nNth)
{
  return GetLocalString(miDAGetCacheObject(DATABASE_PREFIX+sDatabaseID),
                                  "MD_FA_OWNER_"+IntToString(nNth));
}
//----------------------------------------------------------------
int fbFAAddMember(object oPC, string sDatabaseID)
{
  return fbFAAddMemberByID(fbFAGetPCID(oPC), sDatabaseID);
}
//----------------------------------------------------------------
//Adds the variables for members
void _AddMemberVariables(string sID, string sDatabaseID)
{
  //int nMembers = fbFAGetMemberCount(sDatabaseID) + 1;
  object oCacheObject = miDAGetCacheObject(DATABASE_PREFIX+sDatabaseID);

  SetLocalInt(oCacheObject, "MD_FA_MR_"+sID, FB_FA_MEMBER_RANK);
  //SetLocalString(oCacheObject, "MD_FA_"+IntToString(nMembers), sID);
//  SetLocalInt(oCacheObject, "MD_FA", nMembers);
}
//----------------------------------------------------------------
int fbFAAddMemberByID(string sID, string sDatabaseID)
{
    //The PC is already a member
  int nRank = fbFAGetRankByID(sDatabaseID, sID);
  string sNation = md_GetFacNation(sDatabaseID);
  object oNation;
  if(sNation != "")
    oNation = miCZLoadNation(sNation);
  if(_IsOwningRank(sID, sDatabaseID) || nRank > 0) return FALSE;
  if(nRank == FB_FA_NON_MEMBER) return fbFAChangeRankByID(sID, sDatabaseID);

  _AddMemberVariables(sID, sDatabaseID);

  SendMessageToPC(gsPCGetPlayerByID(sID), "You have been added to faction " + fbFAGetFactionNameDatabaseID(sDatabaseID));
   // Store in the database
  SQLExecStatement("INSERT INTO md_fa_members (faction_id,pc_id,timestamp) VALUES (?,?,?)",
      sDatabaseID, sID, IntToString(md_CreateTimestamp(MD_FA_MEMBER_LIMIT)));

  return TRUE;
}
//----------------------------------------------------------------
void _AddOutsiderVariables(string sID, string sDatabaseID, int nPay)
{
  object oCache = miDAGetCacheObject(DATABASE_PREFIX+sDatabaseID);

  SetLocalInt(oCache, "MD_FA_MR_"+sID, FB_FA_NON_MEMBER);
  //Set the pay
  SetLocalInt(oCache, "MD_FA_PAY_"+sID, nPay);
}
//----------------------------------------------------------------
int md_FA_AddOutsider(string sID, string sDatabaseID, int nPay, int nPayIN=TRUE)
{
  //Cannot add an outsider without pay
  if(nPay == 0) return 1;
  //Cannot add an outsider that already has a rank
  if(fbFAGetRankByID(sDatabaseID, sID) != 0||
     _IsOwningRank(sID, sDatabaseID)) return 2;

  //Salaries(pay outs) are negative numbers.
  //Dues (pay ins) are positive numbers
  if(nPayIN && nPay < 0)
   nPay *= -1; //convert to positive
  else if(!nPayIN && nPay > 0)
   nPay *= -1; //Convert to negative

  _AddOutsiderVariables(sID, sDatabaseID, nPay);
  object oCache = miDAGetCacheObject(DATABASE_PREFIX+sDatabaseID);
  if(nPay > 0)
    SetLocalInt(oCache, "MD_FA_DUE", GetLocalInt(oCache, "MD_FA_DUE") + nPay);
  else
    SetLocalInt(oCache, "MD_FA_SAL", GetLocalInt(oCache, "MD_FA_SAL") + nPay);

  SQLExecStatement("INSERT INTO md_fa_members (faction_id,pc_id,timestamp,pay,rank_id) VALUES (?,?,?,?,?)", sDatabaseID, sID, IntToString(md_CreateTimestamp(MD_FA_MEMBER_LIMIT)), IntToString(nPay), "1");

  return FALSE;
}
//----------------------------------------------------------------
int fbFAGetMemberCount(string sDatabaseID)
{
    return GetLocalInt(miDAGetCacheObject(DATABASE_PREFIX+sDatabaseID), "MD_FA");
}

//----------------------------------------------------------------
string fbFAGetNthMemberID(string sDatabaseID, int nNth)
{
    return GetLocalString(miDAGetCacheObject(DATABASE_PREFIX+sDatabaseID),
                          "MD_FA_"+IntToString(nNth));
}
//----------------------------------------------------------------
int md_GetHasPower(int nPower, object oPC, string sDatabaseID, string sList = "1", int nNation = FALSE)
{
  //Owners and settlement leaders have all powers
  if(fbFAGetIsOwningRank(sDatabaseID, oPC, nNation)) return TRUE;
  return md_GetHasPowerByID(nPower, fbFAGetPCID(oPC), sDatabaseID, sList, nNation);
}
//----------------------------------------------------------------
int md_GetHasPowerByID(int nPower, string sID, string sDatabaseID, string sList = "1", int nNation = FALSE)
{
  //Masters of vassasls have certain powers from being owner of the vassal
  /*if(GetIsNationMasterByIDFromCache(sID, sFactionName) &&
     VASSAL_POWERS & nPower && sList == "1")
     return TRUE;  */


  string sVar;
  if(nNation)
    sVar = "MD_FA_POWER_ST_"+sList+"_"+sID;
  else
    sVar = "MD_FA_POWER_"+sList+"_"+sID;

  return (GetLocalInt(miDAGetCacheObject(DATABASE_PREFIX+sDatabaseID), sVar) & nPower);
}
//----------------------------------------------------------------
int md_GetHasPowerMaster(int nPower, object oPC, string sDatabaseID, string sList = "1", int nNation = FALSE)
{
   //If the PC has the power or By Default Rank or By PC rank
   //We use GetRankByID because we want to get the non-vassal or non-owner rank, if any
  if(md_GetHasPower(nPower, oPC, sDatabaseID, sList, nNation) || md_GetHasPowerByID(nPower, "F", sDatabaseID, sList, nNation) ||
     md_GetHasPowerByID(nPower, "R"+IntToString(fbFAGetRankByID(sDatabaseID, fbFAGetPCID(oPC))), sDatabaseID, sList, nNation))
    return TRUE;
  //Check to see if the individual has this power in the settlement faction
  //but only if their rank in that faction matches the factions name (owner)
  if(nNation)
  {
    string sNation = md_GetFacNation(sDatabaseID);
    if(sNation == "") return FALSE;
    string sNName = miCZGetName(sNation);
    sNation = md_GetDatabaseID(sNName);
    string sFName = fbFAGetFactionNameDatabaseID(sDatabaseID);
    string sID = fbFAGetPCID(oPC);
    string sRank = IntToString(fbFAGetRankByID(sNation, sID));
    if(sNName != sFName && sFName == md_FAGetRankName(sNation, sRank) &&
       (md_GetHasPowerByID(nPower, sID, sNation, sList) ||
       md_GetHasPowerByID(nPower, "F", sNation, sList) ||
       md_GetHasPowerByID(nPower, "R"+sRank, sNation, sList)))
       return TRUE;
  }

  return FALSE;
}
//----------------------------------------------------------------
int md_GetHasPowerBank(int nPower, object oPC, string sDatabaseID, string sList = "1")
{
  //if withdraw gold comes through here, check for a writ
  if(nPower == MD_PR_WDG)
  {
    int nWrit = md_GetHasWrit(oPC, sDatabaseID, nPower, sList);
    if(nWrit != 2) return nWrit;
  }
   ///power from the faction's primary list...
  if(mdFAInFaction(sDatabaseID, oPC) && md_GetHasPowerMaster(nPower, oPC, sDatabaseID, sList, FALSE))
    return TRUE;

  string sNation = md_GetFacNation(sDatabaseID);
  //No Nation, so exit
  if(sNation == "") return FALSE;

  sNation = GetLocalString(GetModule(), "MD_FA_"+miCZGetName(sNation));
  //or we have the power directly from the settlement.
  if(mdFAInFaction(sNation, oPC) && md_GetHasPowerMaster(nPower, oPC, sNation, sList, FALSE))
    return TRUE;

  return FALSE;
}
//----------------------------------------------------------------
int md_GetHasPowerShop(int nPower, object oPC, string sDatabaseID, string sList = "1")
{
  //Checks the faction itself and the settlement faction
  if(md_GetHasPowerBank(nPower, oPC, sDatabaseID, sList))
    return TRUE;

  //For settlement factions only, check every rank
  string sNation = md_GetFacNation(sDatabaseID);
  if(sNation == "") return FALSE;
  if(miCZGetName(sNation) != fbFAGetFactionNameDatabaseID(sDatabaseID)) return FALSE;

  int nMax = md_FaRankCount(sDatabaseID);
  string sRank;
  int nCount;
  for(nCount = 1; nCount <= nMax; nCount++)
  {
    sRank = md_GetDatabaseID(md_FAGetRankName(sDatabaseID, md_FAGetNthRankID(sDatabaseID, nCount)));
    if(mdFAInFaction(sRank, oPC) && (md_GetHasPower(nPower, oPC, sRank, sList, TRUE) || md_GetHasPowerByID(nPower, "F", sRank, sList, TRUE) ||
       md_GetHasPowerByID(nPower, "R"+IntToString(fbFAGetRankByID(sRank, fbFAGetPCID(oPC))), sRank, sList, TRUE)))
      return TRUE;
  }

  return FALSE;
}
//----------------------------------------------------------------
void md_SetPower(int nPower, string sID, string sDatabaseID, int nGive=TRUE, string sList = "1", int nNation=FALSE)
{
    object oCache = miDAGetCacheObject(DATABASE_PREFIX+sDatabaseID);

    string sVar;
    string sPowerVar;

    if(nNation)
    {
      sVar = "MD_FA_POWER_ST_"+sList+"_"+sID;
      sPowerVar = "powersST"+sList;
    }
    else
    {
      sVar = "MD_FA_POWER_"+sList+"_"+sID;
      sPowerVar = "powers"+sList;
    }
    int nCurPower = GetLocalInt(oCache, sVar);

    if(nGive)
      nPower = nCurPower | nPower;
    else
      nPower = nCurPower & ~nPower;

    string sAlt = GetStringLeft(sID, 1);
    SetLocalInt(oCache, sVar, nPower);

    if(sAlt == "F")
      SQLExecStatement("UPDATE md_fa_factions SET "+sPowerVar+"=?" +
                    " WHERE id=?", IntToString(nPower), sDatabaseID);
    else if(sAlt == "R")
      SQLExecStatement("UPDATE md_fa_ranks SET "+sPowerVar+"=?" +
                    " WHERE id=?", IntToString(nPower), GetStringRight(sID, GetStringLength(sID) - 1));
    else
      SQLExecStatement("UPDATE md_fa_members SET "+sPowerVar+"=?" +
                    " WHERE pc_id=? AND " +
                    "faction_id=?", IntToString(nPower), sID, sDatabaseID);

}
//----------------------------------------------------------------
int md_GetHasPowerFixture(int nPower, object oPC, string sName, string sList = "1")
{
  int nStart = FindSubString(sName, "{");
  int nEnd = FindSubString(sName, "}", nStart);
  string sFactionName = GetSubString(sName, nStart+1, nEnd-nStart-1);

  string sNation;
  string sDatabaseID;
  string sRankDB;
  object oModule = GetModule();
  while(sFactionName != "")
  {
    sDatabaseID = GetLocalString(oModule, "MD_FA_"+sFactionName);
    //This performs all necessary actions for normal factions
    //This performs all necessary actions for child factions (checks the faction itself, and it's nation)
    if(md_GetHasPowerBank(nPower, oPC, sDatabaseID, sList))
      return TRUE;

    string sNation = md_GetFacNation(sDatabaseID);

    if(sNation != "")
    {

      sNation = miCZGetName(sNation);

      if(sNation == sFactionName) //settlements
      {
        //loop through the ranks
        //This checks all the child rank's to see if the
        //Child's ranks have the power to modify the nation's fixtures
        int nMax = md_FaRankCount(sDatabaseID);
        string sRank;
        int nCount;
        for(nCount = 1; nCount <= nMax; nCount++)
        {
          sRank = md_FAGetRankName(sDatabaseID, md_FAGetNthRankID(sDatabaseID, nCount));
          sRankDB = GetLocalString(oModule, "MD_FA_"+sRank);
          if(sRank != MD_FA_MEMBER_RANK && sRank != MD_FAC_RANK_REMOVED && mdFAInFaction(sRankDB, oPC) && md_GetHasPowerMaster(nPower, oPC, sRankDB, sList, TRUE))
            return TRUE;
        }

      }
    }

    nStart = FindSubString(sName, "{", nEnd);
    nEnd =  FindSubString(sName, "}", nStart);
    if(nStart == -1 || nEnd == -1)
     sFactionName = "";
    else
     sFactionName = GetSubString(sName, nStart+1, nEnd-nStart-1);

  }
  return FALSE;
}
//----------------------------------------------------------------
int md_GetHasWrit(object oLeader, string sDatabaseID, int nPower, string sList = "1", int nNation=FALSE)
{
  string sID = gsPCGetPlayerID(oLeader);
  if(GetIsNationLeaderByIDFromCache(sID, sDatabaseID))
  {
    string sNation = md_GetFacNation(sDatabaseID);
    object oNation = miCZLoadNation(sNation);
    int nMax = GetLocalInt(oNation, VAR_NUM_LEADERS);
    // For nations with multiple leaders, check that we have a valid writ.
    if (nMax > 1)
    {
      //If they have the powers, they don't need a writ
      if(md_GetHasPowerByID(nPower, sID, sDatabaseID, sList, nNation) ||
         md_GetHasPowerByID(nPower, "F", sDatabaseID, sList, nNation) ||
         md_GetHasPowerByID(nPower, "R"+IntToString(fbFAGetRankByID(sDatabaseID, sID)), sDatabaseID, sList, nNation))
           return TRUE;
      //Check if owner of a child faction

      string sFName = fbFAGetFactionNameDatabaseID(sDatabaseID);
      string sNName = miCZGetName(sNation);
      sNation = md_GetDatabaseID(sNName);
      //If no power is set, ignore
      //If doing stuff on the nation power list.. it doesn't matter
      if(nPower != 0 && sFName != sNName && sFName == md_FAGetRankName(sNation, IntToString(fbFAGetRankByID(sNation, sID))) && !nNation)
        return TRUE;
      // Look for a signed writ.
      if (!GetIsObjectValid(oLeader)) return FALSE;
      object oWrit = GetItemPossessedBy(oLeader, "micz_writ_sgn");

      int bValidWrit = GetIsObjectValid(oWrit);
      int nTStamp = GetLocalInt(oWrit, "_Writ_Timestamp");
      if(gsTIGetActualTimestamp() > nTStamp || nTStamp == 0)
      {
        SendMessageToPC(oLeader, "Writ Expired! If you have a valid writ try again.");
        DestroyObject(oWrit);
        return FALSE;
      }
      else if (!bValidWrit)
      {
        SendMessageToPC(oLeader, "You need a writ signed by at least half the leaders to act.");
        return FALSE;
      }
      //They need a writ
      return 3;
    }
    //They don't need a writ
    return TRUE;
  }
  //Not a leader, so needs the power
  return 2;
}
//----------------------------------------------------------------
int md_GetHasPowerSettlement(int nPower, object oPC, string sDatabaseID, string sList = "1")
{
  int nWrit = md_GetHasWrit(oPC, sDatabaseID, nPower, sList);

  if(nWrit != 2) return nWrit;
   //Continue if nWrit = 2 (non-leader)
  if(mdFAInFaction(sDatabaseID, oPC) && md_GetHasPowerMaster(nPower, oPC, sDatabaseID, sList))
    return TRUE;

  int nMax = md_FaRankCount(sDatabaseID);
  string sRank;
  int nCount;
  for(nCount = 1; nCount <= nMax; nCount++)
  {
    sRank = md_GetDatabaseID(md_FAGetRankName(sDatabaseID, md_FAGetNthRankID(sDatabaseID, nCount)));
    if(mdFAInFaction(sRank, oPC) && (md_GetHasPower(nPower, oPC, sRank, sList, TRUE) || md_GetHasPowerByID(nPower, "F", sRank, sList, TRUE) ||
       md_GetHasPowerByID(nPower, "R"+IntToString(fbFAGetRankByID(sRank, fbFAGetPCID(oPC))), sRank, sList, TRUE)))
      return TRUE;
  }

  return FALSE;
}
//----------------------------------------------------------------
int fbFALoadMessages(string sDatabaseID, string sPrefix = "")
{
    // Search for messages with a valid expiry date


    SQLExecDirect("SELECT message FROM md_fa_messages WHERE faction_id='"+sDatabaseID+
                  "' ORDER BY modified ASC");

    // Loop round each

    object oCache = miDAGetCacheObject(DATABASE_PREFIX+sDatabaseID);
    int nNth = 0;
    while (SQLFetch())
    {
        nNth++;
        SetLocalString(oCache,
                       "MD_FA_MESSAGE_"+IntToString(nNth),
                       SQLGetData(1));
    }

    // I'm adding 1 here to signify that the messages have been loaded, even if there are none.
    fbFASetMessageCount(sDatabaseID, nNth);
    return nNth + 1;
}
//----------------------------------------------------------------
int fbFACreateMessage(string sMessage, string sDatabaseID, object oMessenger = OBJECT_SELF)
{
  /*  // Fail if creating a message is impossible, checked during conversation if they have the power
    if (fbFAGetRank(nFaction, oMessenger) < FB_FA_MESSENGER_RANK && !GetIsDM(oMessenger)) return 1; */
    if(sMessage == "") return 1;
    // Fail if message is over 400 characters
    if (GetStringLength(sMessage) > 400) return 2;

    // Save the ranks allowed to view the message
  /*  if (!FB_FA_SELECTIVE_MESSAGING) nRank = 0;*/
    sMessage = GetName(oMessenger) + ": " + sMessage;

    // Are messages for this faction loaded?
    int nMessageCount = fbFAGetMessageCount(sDatabaseID) + 1;
    //Taken care of during above function
    //if (!nMessageCount) nMessageCount = fbFALoadMessages(nFaction);

    // Save the message to the database
    SQLExecDirect("INSERT INTO md_fa_messages (faction_id,message,timestamp) VALUES('"+
                 sDatabaseID+
                  "', '"+SQLEncodeSpecialChars(sMessage)+"', '"+IntToString(md_CreateTimestamp(FB_FA_MESSAGE_TIME))+"')");

    // Store the message on the module
    fbFASetMessageCount(sDatabaseID, nMessageCount);
    SetLocalString(miDAGetCacheObject(DATABASE_PREFIX+sDatabaseID),
                   "MD_FA_MESSAGE_"+IntToString(nMessageCount),
                   sMessage);

    return FALSE;
}
//----------------------------------------------------------------
string fbFAGetMessageByID(string sDatabaseID, int nMessage, object oPC = OBJECT_INVALID)
{
    // Are messages for this faction loaded?
    int nMessageCount = fbFAGetMessageCount(sDatabaseID) + 1;


    string sMessage = GetLocalString(miDAGetCacheObject(DATABASE_PREFIX+sDatabaseID),
                         "MD_FA_MESSAGE_"+IntToString(nMessage));

    // If the requester is valid, check they can view it
    if (GetIsObjectValid(oPC))
    {
       //No selective message or has power to see all messages, get out of here
       if(!FB_FA_SELECTIVE_MESSAGING || md_GetHasPowerMaster(MD_PR_SAM, oPC, sDatabaseID)) return sMessage;
       //Message ranks will be between { }, get the first set
       int nStart = FindSubString(sMessage, ": {"); //after the name
       int nEnd = -1;
       if(nStart != -1) //Has a start
         nEnd = FindSubString(sMessage, "}", nStart);
                      //No End so return
       if(nEnd == -1) return sMessage;                //Start after {. not before :
       string sMesRank = GetSubString(sMessage, nStart + 3, nEnd - 3 - nStart);

       if (FindSubString(md_FAGetRankName(sDatabaseID, IntToString(fbFAGetRank(sDatabaseID, oPC))), sMesRank) == -1) return "";
    }

    // Otherwise return the message
    return sMessage;
}
//----------------------------------------------------------------
// Removes nMessage from the database and reloads nFaction's messages.
void fbFARemoveMessage(string sDatabaseID, int nMessage)
{
    string sMessage = IntToString(nMessage);


    // Load the message and faction in memory
    string sMessageText = GetLocalString(miDAGetCacheObject(DATABASE_PREFIX+sDatabaseID),
                                         "MD_FA_MESSAGE_"+sMessage);


    // Remove the message from the module
    // @@@ Mith - not sure why this is necessary since we reload below.
   /* DeleteLocalString(miDAGetCacheObject(fbFAGetFactionName(nFaction)),
                      "FB_FA_MESSAGE_"+sFaction+"_"+sMessage); */

    // Remove the message from the database
    SQLExecDirect("DELETE FROM md_fa_messages WHERE faction_id='"+sDatabaseID+
        "' AND message='"+SQLEncodeSpecialChars(sMessageText)+"'");


    fbFALoadMessages(sDatabaseID);
}
//----------------------------------------------------------------
// Returns the number of active messages for nFaction.
int fbFAGetMessageCount(string sDatabaseID)
{
    int nCount = GetLocalInt(miDAGetCacheObject(DATABASE_PREFIX+sDatabaseID),
                             "MD_FA_MESSAGECOUNT");

    if (!nCount) nCount = fbFALoadMessages(sDatabaseID);

    return (nCount -1);
}
//----------------------------------------------------------------
// Sets the number of active messages for nFaction to nAmount
void fbFASetMessageCount(string sDatabaseID, int nAmount)
{
    SetLocalInt(miDAGetCacheObject(DATABASE_PREFIX+sDatabaseID),
                "MD_FA_MESSAGECOUNT",
                nAmount + 1);
}
//----------------------------------------------------------------
void fbFACheckMessages(object oPC, int nStart = 1, int nEnd = 50)
{
  object oModule = GetModule();
  int nNumFactions = GetLocalInt(oModule, "MD_FA_HIGHEST");
  int nCount;
  string sFaction;
  if(nEnd > nNumFactions)
    nEnd = nNumFactions;
  for(nCount = nStart; nCount <= nEnd; nCount++)
  {
    sFaction = GetLocalString(oModule, "MD_FA_DATABASEID_"+IntToString(nCount));
    if (mdFAInFaction(sFaction, oPC))
    {

      if (fbFAGetMessageCount(sFaction) > 0)
        DelayCommand(6.0, SendMessageToPC(oPC,
         "There are active messages in the " + fbFAGetFactionNameDatabaseID(sFaction) + " faction.  Use -factions " +
         "to check them."));
    }

  }

  if(nCount < nNumFactions)
    DelayCommand(0.1, fbFACheckMessages(oPC, nEnd+1, nEnd+50));
}
//----------------------------------------------------------------
void md_UpdateMemberTimestamp(object oPC)
{
  SQLExecDirect("UPDATE md_fa_members SET timestamp='"+ IntToString(md_CreateTimestamp(MD_FA_MEMBER_LIMIT)) +
                "' WHERE pc_id='" + fbFAGetPCID(oPC) +"' AND NOT is_OwnerRank='1'");
}
//----------------------------------------------------------------
void md_UpdateFactionTimestamp(string sDatabaseID)
{
  string sNation = md_GetFacNation(sDatabaseID);

  string sPrefix;
  if(sNation != "")
  {
    sNation = miCZGetName(sNation);
    sPrefix = CHILD_PREFIX;
  }

  if(sNation == fbFAGetFactionNameDatabaseID(sDatabaseID)) return; //Nations don't have timestamps
  object oCache = miDAGetCacheObject(DATABASE_PREFIX+sDatabaseID);
  if(GetLocalInt(oCache, "MD_FAC_TIME") == 0) return; //factions w/o timestamp will continue not to have one

  int nTimestamp = md_CreateTimestamp(MD_FA_FACTION_LIMIT);

  SetLocalInt(oCache, "MD_FAC_TIME", nTimestamp);

  string sTimestamp = IntToString(nTimestamp);

  SQLExecDirect("UPDATE md_fa_factions SET timestamp='"+ sTimestamp +
                "' WHERE id='"+sDatabaseID+
                "'");

  //And update the ranks timestamp
  //if(sNation != "")
   // SQLExecDirect("UPDATE fb_fa_members SET timestamp='"+ sTimestamp +
   //               "' WHERE pcid='" + SQLEncodeSpecialChars(sFaction) +"' AND faction='"+
    //              SQLEncodeSpecialChars(SETTLEMENT_PREFIX + sNation) +
    //              "'");
}
//----------------------------------------------------------------
int md_CreateTimestamp(int nTime)
{
  if(FB_FA_USE_REAL_TIME)
    nTime = gsTIGetGameTimestamp(nTime);

  return nTime + gsTIGetActualTimestamp();
}
//----------------------------------------------------------------
int md_GetFactionTime(string sDatabaseID)
{
  return GetLocalInt(miDAGetCacheObject(DATABASE_PREFIX+sDatabaseID), "MD_FAC_TIME");
}
//----------------------------------------------------------------
void md_FactionClientEnter(object oPC)
{
  md_UpdateMemberTimestamp(oPC);
  //Can cause TMI, so delay
  DelayCommand(1.0, fbFACheckMessages(oPC));
}
//----------------------------------------------------------------
int md_GetFacPay(string sID, string sDatabaseID)
{
  return GetLocalInt(miDAGetCacheObject(DATABASE_PREFIX+sDatabaseID), "MD_FA_PAY_"+sID);
}
//----------------------------------------------------------------
int md_SetFacPay(string sID, string sDatabase, int nPay, int nPower = MD_PR2_ROS, object oPC=OBJECT_INVALID, int nPayIN=FALSE)
{
  string sLeft = GetStringLeft(sID, 1);


  //Setting an outsider to unpaid, remove from faction
  if(sLeft != "R" && fbFAGetRankByID(sDatabase, sID) == FB_FA_NON_MEMBER && nPay == 0)
  {
    //Will remove if oPC is invalid
    if(!GetIsObjectValid(oPC) || md_GetHasPowerMaster(nPower, oPC, sDatabase, "2"))
    {
      fbFAChangeRankByID(sID, sDatabase, 0);
      return 1;
    }
    return 2;
  }

  //Payins are postivie
  if(nPay < 0 && nPayIN)
    nPay *= -1;
  else if(nPay > 0 && !nPayIN) //Pay outs are negative
    nPay *= -1;

  object oCache = miDAGetCacheObject(DATABASE_PREFIX+sDatabase);


  int nOldPay = GetLocalInt(oCache, "MD_FA_PAY_"+sID);
  //Update the new pay type total
  if(nOldPay > 0) //dues
    SetLocalInt(oCache, "MD_FA_DUE",
      GetLocalInt(oCache, "MD_FA_DUE") - nOldPay);
  else if(nOldPay < 0)
    SetLocalInt(oCache, "MD_FA_SAL",
      GetLocalInt(oCache, "MD_FA_SAL") - nOldPay);


  //Update the new pay type total
  if(nPay > 0) //dues
    SetLocalInt(oCache, "MD_FA_DUE",
      GetLocalInt(oCache, "MD_FA_DUE") + nPay);
  else if(nPay < 0)
    SetLocalInt(oCache, "MD_FA_SAL",
      GetLocalInt(oCache, "MD_FA_SAL") + nPay);


  SetLocalInt(oCache, "MD_FA_PAY_"+sID, nPay);

  if(sLeft == "R")
    SQLExecStatement("UPDATE md_fa_ranks " +
                  "SET pay=?" +
                  " WHERE id=?", IntToString(nPay), GetStringRight(sID, GetStringLength(sID) - 1));
  else
    SQLExecStatement("UPDATE md_fa_members SET pay=? " +
                  " WHERE pc_id=? AND faction_id=?",
                  IntToString(nPay), sID, sDatabase);

  return FALSE;
}
//----------------------------------------------------------------
int md_GetFacPayTotal(string sDatabaseID, string sType="SAL")
{
  return GetLocalInt(miDAGetCacheObject(DATABASE_PREFIX+sDatabaseID), "MD_FA_"+sType);
}
//----------------------------------------------------------------
string md_GetnNthOutsiderID(string sDatabaseID, int nNth, string sList="IN")
{
  return GetLocalString(miDAGetCacheObject(DATABASE_PREFIX+sDatabaseID), "MD_FA_P"+sList+"_"+IntToString(nNth));
}
//-------------------------------------------------------------
//these groups of functions handle the salary and due collecting
void _DoMonthlyDueST(string sID, string sDatabaseID)
{
  SQLExecStatement("SELECT pc_id,pay FROM md_fa_members WHERE faction_id = '" +
                   SQLEncodeSpecialChars(sDatabaseID) +
                   "' AND pay > '0'");

  string sNID = "N"+sID;
  string sTOID;
  int nPay;
  while(SQLFetch())
  {
    sTOID = SQLGetData(1);
    nPay = StringToInt(SQLGetData(2));
    //to not interfere when it does sql calls
    DelayCommand(0.1, gsFITransferFromTo(sTOID, sNID, nPay));
  }

  SQLExecStatement("SELECT f.id,r.pay FROM md_fa_factions AS f INNER JOIN md_fa_ranks AS r ON " +
                   "f.name = CONCAT('"+CHILD_PREFIX+"', r.name) " +
                   "WHERE r.pay > '0' AND r.faction_id = '"+sDatabaseID+"'");

  while(SQLFetch())
  {
    sTOID = "F"+SQLGetData(1);
    nPay = StringToInt(SQLGetData(2));
    //to not interfere when it does sql calls
    DelayCommand(0.1, gsFITransferFromTo(sTOID, sNID, nPay));
  }


}
//----------------------------------------------------------------
void _DoMonthlySalaryST(string sID, string sDatabaseID)
{
  SQLExecStatement("SELECT pc_id,pay FROM md_fa_members WHERE faction_id = '" +
                   SQLEncodeSpecialChars(sDatabaseID) +
                   "' AND pay < '0'");

  string sNID = "N"+sID;
  string sTOID;
  int nPay;
  while(SQLFetch())
  {
    sTOID = SQLGetData(1);
    nPay = StringToInt(SQLGetData(2)) * -1;
    //to not interfere when it does sql calls
    DelayCommand(0.1, gsFITransferFromTo(sNID, sTOID, nPay));
  }

  SQLExecStatement("SELECT f.id,r.pay FROM md_fa_factions AS f INNER JOIN md_fa_ranks AS r ON " +
                   "f.name = CONCAT('"+CHILD_PREFIX+"', r.name) " +
                   "WHERE r.pay < '0' AND r.faction_id = '"+sDatabaseID+"'");

  while(SQLFetch())
  {
    sTOID = "F"+SQLGetData(1);
    nPay = StringToInt(SQLGetData(2)) * -1;
    //to not interfere when it does sql calls
    DelayCommand(0.1, gsFITransferFromTo(sNID, sTOID, nPay));
  }
}
//----------------------------------------------------------------
void _DoMonthlyDue(string sDatabaseID)
{
  SQLExecStatement("SELECT pc_id,pay FROM md_fa_members WHERE faction_id = '" +
                   SQLEncodeSpecialChars(sDatabaseID) +
                   "' AND pay > '0'");

  sDatabaseID = "F"+sDatabaseID;
  string sPCID;
  int nPay;
  while(SQLFetch())
  {
    sPCID = SQLGetData(1);
    nPay = StringToInt(SQLGetData(2));
    //to not interfere when it does sql calls
    DelayCommand(0.1, gsFITransferFromTo(sPCID, sDatabaseID, nPay));
  }
}
//----------------------------------------------------------------
void _DoMonthlySalary(string sDatabaseID)
{
  SQLExecStatement("SELECT pc_id,pay FROM md_fa_members WHERE faction_id = '" +
                   SQLEncodeSpecialChars(sDatabaseID) +
                   "' AND pay < '0'");

  sDatabaseID = "F"+sDatabaseID;
  string sPCID;
  int nPay;
  while(SQLFetch())
  {
    sPCID = SQLGetData(1);
    nPay = StringToInt(SQLGetData(2)) * -1;
    //to not interfere when it does sql calls
    DelayCommand(0.1, gsFITransferFromTo(sDatabaseID, sPCID, nPay));
  }
}
//----------------------------------------------------------------
void DoMonthlySalary()
{
  if(miXFGetCurrentServer() != SERVER_UNDERDARK) return;

  //do settlements factions first
  SQLExecStatement("SELECT nation,id FROM md_fa_factions WHERE name LIKE '"+SETTLEMENT_PREFIX+"%'");

  string sNation;
  string sFactionID;
  while(SQLFetch())
  {
    sNation = SQLGetData(1);
    sFactionID = SQLGetData(2);
    //This will do the due
    DelayCommand(0.1, _DoMonthlyDueST(sNation, sFactionID));
    //this will do  the salary
    DelayCommand(0.2, _DoMonthlySalaryST(sNation, sFactionID));
  }

  SQLExecStatement("SELECT id FROM md_fa_factions WHERE name NOT LIKE '"+SETTLEMENT_PREFIX+"%'");

  //Every other faction
  while(SQLFetch())
  {
    sFactionID = SQLGetData(1);
    //This will do the due, do this after the settlements are done
    DelayCommand(0.3, _DoMonthlyDue(sFactionID));
    //this will do  the salary
    DelayCommand(0.4, _DoMonthlySalary(sFactionID));
  }
}
//----------------------------------------------------------------
string md_GetDatabaseID(string sName)
{
  return GetLocalString(GetModule(), "MD_FA_"+sName);
}
//----------------------------------------------------------------
//Caches tax
string md_SHLoadFacTax(object oShop = OBJECT_SELF)
{
  object oArea = GetArea(oShop);
  string sSHID = GetLocalString(oShop, "GS_CLASS")+
                 IntToString(GetLocalInt(oShop, "GS_INSTANCE"));
  string sTax = GetLocalString(oArea, VAR_FTAX+sSHID);

  if(sTax == "")
  {
    sTax = miDAGetKeyedValue("gs_quarter", sSHID, "faction_tax", "row_key");

    if(sTax == "") sTax = "0";
    SetLocalString(oArea, VAR_FTAX+sSHID, sTax);
  }

  return sTax;
}
//----------------------------------------------------------------
//caches ids
string md_SHLoadFacID(object oShop=OBJECT_SELF)
{
  object oModule = GetModule(); //changed from getarea because quarters can spread across multiple areas
  string sSHID = GetLocalString(oShop, "GS_CLASS")+
                 IntToString(GetLocalInt(oShop, "GS_INSTANCE"));
  string sID = GetLocalString(oModule, VAR_FID+sSHID);

  if(sID == "")
  {
    sID = miDAGetKeyedValue("gs_quarter", sSHID, "faction_id", "row_key");

    if(sID == "") sID = "NONE";
    SetLocalString(oModule, VAR_FID+sSHID, sID);
  }

  return sID;

}
//----------------------------------------------------------------
//Caches abilities
int md_SHLoadFacABL(int nABL, object oShop=OBJECT_SELF)
{
  object oArea = GetArea(oShop);
  string sSHID = GetLocalString(oShop, "GS_CLASS")+
                 IntToString(GetLocalInt(oShop, "GS_INSTANCE"));
  int nAABL = GetLocalInt(oArea, VAR_FAB+sSHID) - 1;

  if(nAABL == -1)
  {
    nAABL = StringToInt(miDAGetKeyedValue("gs_quarter", sSHID, "faction_ability", "row_key"));
    SetLocalInt(oArea, VAR_FAB+sSHID, nAABL+1);
  }

  return nAABL & nABL;

}
//----------------------------------------------------------------
/*int md_BountyMultiplier(object oDefeated, string sNation)
{
    int nBountyM = 0;
    string sFaction = GetLocalString(GetModule(), "MD_FA_"+miCZGetName(sNation));
    //Major settlement powers
    //Exile
    if(md_GetHasPowerSettlement(MD_PR2_EXL, oDefeated, sFaction, "2"))
         nBountyM = 50;
    //Withdrawal
    if(md_GetHasPowerSettlement(MD_PR_WDG, oDefeated, sFaction))
        nBountyM += 50;

    //Make/cease war
    if(md_GetHasPowerSettlement(MD_PR2_WAR, oDefeated, sFaction, "2"))
        nBountyM += 50;

    //Lesser settlement powers that involve those outside the settlement
    //Remove exile
    if(md_GetHasPowerSettlement(MD_PR2_RME, oDefeated, sFaction, "2"))
        nBountyM += 25;

    //Trade
    if(md_GetHasPowerSettlement(MD_PR2_SUT, oDefeated, sFaction, "2"))
        nBountyM += 25;

    //Use this so they don't get the unranked faction's power by accident
    int nFaction = mdFAInFaction(sFaction, oDefeated);
    //If they have any of the salary powers, as this is effectively a delayed withdrawal
    //Child factions cannot have these powers (through the settlement anyways), so only master is used
    if(nFaction && (md_GetHasPowerMaster(MD_PR_GSL, oDefeated, sFaction) ||
        md_GetHasPowerMaster(MD_PR2_AOS, oDefeated, sFaction, "2") ||
        md_GetHasPowerMaster(MD_PR2_SOS, oDefeated, sFaction, "2") ||
        md_GetHasPowerMaster(MD_PR2_ROS, oDefeated, sFaction, "2") ||
        md_GetHasPowerMaster(MD_PR2_SRS, oDefeated, sFaction, "2")))
            nBountyM += 25;

    //Inter-settlement powers that have little impact on those outside the settlement
    //Give power to ranks
    if(md_GetHasPowerSettlement(MD_PR_GPR, oDefeated, sFaction))
        nBountyM += 2;

    //Give power to members
    if(md_GetHasPowerSettlement(MD_PR_GPM, oDefeated, sFaction))
        nBountyM += 2;

    //Has power to change ranks
    if(nFaction && md_GetHasPowerMaster(MD_PR_CHR, oDefeated, sFaction))
        nBountyM += 2;

    //Set dues from ranks
    if(nFaction && md_GetHasPowerMaster(MD_PR2_SRD, oDefeated, sFaction, "2"))
         nBountyM += 2;

    //Revoke housing
    if(md_GetHasPowerSettlement(MD_PR2_RVH, oDefeated, sFaction, "2"))
        nBountyM += 2;

    //Revoke shop
    if(md_GetHasPowerSettlement(MD_PR2_RVS, oDefeated, sFaction, "2"))
        nBountyM += 2;

    //Modify Taxes
    if(md_GetHasPowerSettlement(MD_PR2_CHT, oDefeated, sFaction, "2"))
        nBountyM += 2;

    //Modify sell/buy prices
    if(md_GetHasPowerSettlement(MD_PR2_RSB, oDefeated, sFaction, "2"))
        nBountyM += 2;

    //Revoke citizenships
    if(md_GetHasPowerSettlement(MD_PR2_RVC, oDefeated, sFaction, "2"))
        nBountyM += 2;

     if(nBountyM > 100)
        nBountyM = 100;
     else if(nBountyM <= 0)
        nBountyM = 1;

    return nBountyM;
}
//----------------------------------------------------------------
int md_FactionsAtWar(object oOffense, object oDefense, string sIgnoreNat="0", int nPay = FALSE)
{
    //oOffense will also be the victor within gs_m_death
    string sDefense = GetLocalString(oDefense, VAR_NATION);
    miCZLoadNation(sDefense); //make sure nation is loaded before sql calls
    string sDID = gsPCGetPlayerID(oDefense);
    string sOID = gsPCGetPlayerID(oOffense);
    //exclude if they're covered due to citizenship,                                                                                                                                                                                                                                                   //we ignore if offense is banished from the aggresive faction
    SQLExecStatement("SELECT War.nation_def FROM micz_war As War INNER JOIN md_fa_factions As Fac ON War.nation_agg = Fac.nation INNER JOIN md_fa_members AS Mem ON Fac.id = Mem.faction_id LEFT JOIN micz_banish AS Ban ON War.nation_agg = Ban.nation AND Mem.pc_id = Ban.pc_id WHERE Mem.pc_id=? AND Mem.pc_id <> Ban.pc_id AND War.nation_def<>? GROUP BY War.nation_def", sOID, sIgnoreNat);

    string sNationDef;
    int x = 0;
    int nCitizenOnly;
    string sPrep = "SELECT Fac.nation FROM md_fa_factions As Fac INNER JOIN md_fa_members As Mem ON Mem.faction_id=Fac.id WHERE (";
    while(SQLFetch())
    {
        sNationDef = SQLGetData(1);

        if(sNationDef == sDefense)
        {
            if(nPay)
                nCitizenOnly = TRUE;
            else
                return TRUE;
        }
        //ignore if dead pc is banished from the settlement from the settlement they are defending
        if(!miCZGetBanished(sNationDef, sDID))
        {
            if(x >= 1)
                sPrep += " OR ";

            sPrep += "Fac.nation="+sNationDef;
            x++;
       }

    }

    if(x == 0) return FALSE; //nation isn't at war or pc isn't part of a faction


    sPrep += ") AND Mem.Pc_id=? GROUP BY Fac.nation";

    SQLExecStatement(sPrep, gsPCGetPlayerID(oDefense));

    if(nPay) //pay out bounties
    {
        int nBalance;
        int nBounty;
        string sNation;
        x = 0;
        int nBountyM;

        while(SQLFetch())
        {
            sNation = SQLGetData(1);
            if(sNation == sDefense) nCitizenOnly = FALSE;
            SetLocalString(oDefense, "md_fa_nation"+IntToString(++x), sNation);
        }

        if(nCitizenOnly)
        {
            nBounty = 100 * GetHitDice(oDefense);
            nBalance = gsFIGetAccountBalance("N" + sDefense);
            if(miCZGetIsLeader(oDefense, sDefense)) nBountyM = 100;
            nBounty *=  nBountyM;

            if (nBounty > nBalance) nBounty = nBalance;
            gsFIDraw(oOffense, nBounty, "N" + sDefense);
        }

        int y;
        for(y = 1; y <= x; y++)
        {
            sNation = GetLocalString(oDefense, "md_fa_nation"+IntToString(y));

            if(sNation != "" || sNation != "0")
            {
                nBounty = 100 * GetHitDice(oDefense);
                nBalance = gsFIGetAccountBalance("N" + sNation);
                if(miCZGetIsLeader(oDefense, sNation)) nBountyM = 100;
                else nBountyM = md_BountyMultiplier(oDefense, sNation);
                nBounty *=  nBountyM;

                if (nBounty > nBalance) nBounty = nBalance;
                gsFIDraw(oOffense, nBounty, "N" + sNation);
            }


            DeleteLocalString(oDefense, "md_fa_nation"+IntToString(y));
        }
    }
    return SQLFetch();
} */
int miCZGetHasAuthority(string sLeaderID, string sCitizenID, string sNation, int nOverride=FALSE)
{
   //Cannot act against owning faction
   object oNation = miCZLoadNation(sNation);
   int x;
   for(x = 1; x <= GetLocalInt(oNation, VAR_NUM_LEADERS); x++)
   {
      if(fbFAGetIsOwningRankByID(GetLocalString(oNation, VAR_CURRENT_LEADER+IntToString(x)+"F"), sCitizenID))
        return FALSE;

   }

  //You can never act against a vassal master
  if(miCZGetIsMasterByID(sCitizenID, sNation))
    return FALSE;

  //You can never act against a leader unless if you're a master
  if (!miCZGetIsMasterByID(sLeaderID, sNation) &&  miCZGetIsLeaderByID(sCitizenID, sNation))
    return FALSE;
  //The master cannot act against anyone other than a leader unless if the override is set
  if(miCZGetIsMasterByID(sLeaderID, sNation) && !nOverride && !miCZGetIsLeaderByID(sCitizenID, sNation))
    return FALSE;
  //can't act against landed nobles
  SQLExecStatement("SELECT m.is_Noble FROM md_fa_members AS m INNER JOIN md_fa_factions AS f ON f.id=m.faction_id WHERE f.nation=? AND f.type=? AND m.is_Noble=1 AND m.pc_id=?", sNation, IntToString(0x40000000), sCitizenID);

  return !SQLFetch();
}
int GetFactionType(string sFactionID)
{
    object oCache = miDAGetCacheObject(DATABASE_PREFIX+sFactionID);
    int nType = GetLocalInt(oCache, "FAC_TYPE");
    if(nType == 0)
    {
        SQLExecStatement("SELECT type FROM md_fa_factions WHERE id=?", sFactionID);

        if(SQLFetch())
        {
            nType = StringToInt(SQLGetData(1)) + 1;
            SetLocalInt(oCache, "FAC_TYPE", nType);
        }
    }


    return nType - 1;
}
//void main() {}
