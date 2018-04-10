/*
  zz_factions_i

  This conversation script is invoked from the virtual console and uses the z-
  dialog framework. Its purpose is to allow folks tomanage any of the factions
  that they belong to.

  Now a include file used in zz_co_factions and zz_co_nation.
  zz_co_nation is called through the conversation for settlement cordinators

  Differences:
  zz_co_nation, creates a faction when a rank is created
  zz_co_nation, likewise, disbands the faction when the rank is removed
  Nations and their child factions can not be disbanded. Normal factions can.
  Nations can not be left through the -factions conversation
  Nations going through the -factions only show the OOC powers

  If other scripts use this include, they will match zz_co_nations rules
  NOT zz_co_factions

  Pages:
    Main - selects faction if PC has multiple factions, or falls through to...
    Select Action - change member rank, add member, remove member,
                    send message, view all messages, remove message,
                    destroy faction.
                    (Actions only show if permitted).
    View Members - selection screen for rank change/removal
    Enter New Rank - for change rank action
    Find Member - for adding a new member
    View Messages - selection screen for message review & deletion
    Enter New Message - for send message action
    Done - confirmation screen for all actions (returns to Main).

    n.b. DMs are considered to be members of all factions with full ownership
    privileges.

  Modifications to the original made by Fireboar to export it to the ZZ-Dialog
  framework. The reason for doing this is to make use of the OnReset function
  to remove some nasty bugs that were creeping in.
*/

#include "fb_inc_chatutils"
#include "mi_inc_factions"
#include "mi_log"
//#include "x0_i0_position"
#include "zzdlg_main_inc"

//this should be the faction script called by -factions
//options appear or don't appear depending if this script is
//set
const string FACTION_SCRIPT         = "zz_co_factions";
//Pages and lists
const string PAGE_MAIN              = "FAC_FACTIONS";
const string PAGE_ACTION            = "FAC_ACTIONS";
const string PAGE_RANK_ACTIONS      = "FAC_RANKS_A";
const string PAGE_MEMBER_ACTIONS    = "FAC_MEMBERS_A";
const string PAGE_CONFIRM           = "PAGE_FAC_CONFIRM";
const string PAGE_NAMES             = "PAGE_FAC_NAMES";
const string PAGE_GIVE_POWERS       = "PAGE_FAC_POWERS";
const string PAGE_VIEW_MEMBERS      = "PAGE_FAC_MEMBERS";
const string PAGE_VIEW_RANKS        = "PAGE_FAC_RANKS";
const string LIST_IDS               = "LIST_FAC_ID";
const string LIST_MEMBER_IDS        = "LIST_FAC_MEM_ID";
const string LIST_OUT_DUE           = "LIST_FAC_OUTD";
const string LIST_OUT_SAL           = "LIST_FAC_OUTS";
const string PAGE_MESSAGES          = "PAGE_FAC_MESSAGES";
const string PAGE_SELF              = "PAGE_FAC_DUE";
const string PAGE_OUT_DUES          = "PAGE_FAC_OUT_DUES";
const string PAGE_OUT_SAL           = "PAGE_FAC_OUT_SAL";
const string PAGE_OUT_DUES_ACT      = "PAGE_FAC_OUT_DUE_ACT";
const string PAGE_OUT_SAL_ACT       = "PAGE_FAC_OUT_SAL_ACT";
const string PAGE_ADD_OUTSIDER      = "PAGE_FAC_ADD_OUT";
const string PAGE_PAY_PERSONAL      = "PAGE_FAC_PAY_PERSONAL";
const string PAGE_PAY_PER_LIST_S    = "PAGE_FAC_PAY_LIST_S";
const string PAGE_PAY_PER_LIST_D    = "PAGE_FAC_PAY_LIST_D";
const string PAGE_FACTION_LIST      = "PAGE_FACTION_LIST";
const string PAGE_NATION_LEADER     = "PAGE_NATION_LEADER";
const string PAGE_PLEASE_WAIT       = "PAGE_PLEASE_WAIT";


//Response strings
const string ADD_MEMBER             = "Add Member (Speak name before selecting)";
const string REMOVE_MEMBER          = "Remove Member";
const string LEAVE_FACTION          = "Leave Faction";
const string CREATE_RANK            = "Create Rank (Speak name before selecting)";
const string RENAME_RANK            = "Rename Rank (Speak new name before selecting)";
const string CHANGE_RANK            = "Change Rank";
const string REMOVE_RANK            = "Remove Rank";
const string GIVE_POWERS            = "Set Powers";
const string VIEW_RANKS             = "View Ranks";
const string VIEW_MEMBERS           = "View Members";
const string SET_SALARY             = "Set Salary (Speak amount before selecting)";
const string SET_DUE                = "Set Due (Speak amount before selecting)";
const string SALARIES_DUES          = "Salaries and Dues";
const string ADD_OUTSIDER           = "Pay Salary to Outsider (Speak name before selecting)";
const string VIEW_OUT_DUES          = "View Outsiders Paying Dues";
const string VIEW_OUT_SAL           = "View Outsiders Paying Salary.";
const string REMOVE_OUTSIDER        = "Remove Outsider";
//Not set up to use SetText below this point.
const string REFRESH_FACTION        = "Refresh Faction. (Can only be done once per minute.)";
const string DISBAND_FACTION        = "Disband Faction";
const string MESSAGE                = "Messages";
const string CREATE_MESSAGE         = "[Create Message]";
const string VIEW_FAC_DUE           = "[View Factions Recieving a Due]";
const string VIEW_FAC_SAL           = "[View Factions Paying me a Salary]";
const string PAY_DUE                = "Speak the due you wish to pay. [Then Select]";
//Below this point are also pages
const string SETTLEMENT_POWERS      = "Settlement powers.";
const string FACTION_MANAGEMENT     = "Faction management powers.";
const string NATION_MANAGE          = "Nation management powers.";
const string NATION_POWERS          = "Nation powers.";
const string SET_NATION             = "Give nation powers.";
const string MESSAGE_POWERS         = "OOC message powers.";
const string BANK_POWERS            = "Bank powers.";
const string NATION_BANK            = "Nation bank powers.";
const string NAT_FIXTURE            = "Nation fixture powers.";
const string FIXT_POWERS            = "Fixture powers.";
const string SHOP_POWERS            = "Shop and Quarter powers.";
const string NATION_SHOP            = "Nation shop powers.";

//Local Variables
const string VAR_FACTION            = "VAR_FAC_FACTION";
const string VAR_MEMBER             = "VAR_FAC_MEMBER";
const string VAR_RANK               = "VAR_FAC_RANKS";
const string VAR_PAGE               = "VAR_FAC_PAGE";
const string VAR_ACTIONS            = "VAR_FAC_ACTIONS";
const string VAR_CREATE             = "VAR_FAC_CREATEM";
const string VAR_MESSAGE            = "VAR_FAC_MESSAGE";
const string VAR_PAY                = "VAR_FAC_PAY";
//Other actions:
const string REMOVE_OUTSIDER_SAL    = "REMOVE_OUTSIDER_SAL";
const string REMOVE_OUTSIDER_DUE    = "REMOVE_OUTSIDER_DUE";
const string ACTION_REMOVE_MES      = "FAC_REM_MES";
const string ADD_OUTSIDER_PAY       = "FAC_OUT_PAY";
const string SET_SALARY_S           = "FAC_SALARY_PAGE_S";
const string SET_SALARY_D           = "FAC_SALARY_PAGE_D";


//Should be called in each OnInit().
void Fac_OnInit();
//To be run if you want to change the responses for some response
//strings See above.
void _SetText(string sVar, string sText);
string _GetText(string sVar);
//Gets the prompt for a page, should be defined in each script.
string GetPrompt(string sPage);
//Anything that needs a confirmation passes through here
//Should be defined in each script, sets up the prompts
string onConfirmation();
//Adds the due/sal totals to the prompt, if oPC has the power
string FactionTotals(int nVDues, int nVSal, string sList = "1");


//OnPageInt fuction prototypes:
//Loads factions
string onMainPage();
//Sets up non-member, non-rank specifiction actions
void onAction();
//Displays members, also lists member actions
void onMembers();
//Displays ranks
//Returns true when changing ranks
int onRanks();
//Displays major power types, also lists power subtypes
void onGivePower();
//Displays Power types for nations
string onGiveNatPower();
//Displays a list of factions and the pay the player is recieving from them
string onViewFactionPay(string sPage, int nPayIN=TRUE);
//Displays a list of factions
string onFactionList();

//OnSelection fuction prototypes:
//Handles creating a faction and faction selection
void onMainPageS();
//Handles non-specific action selection
void onActionS();
//Handles member selection
void onMembersS();
//Handles actions against specific members
void onMembersAS(string sLPage = PAGE_MEMBER_ACTIONS);
//Handles any action that requires a confirmation
void onConfirmationS();
//handles the selection of ranks
void onRanksS();
//Handles selection of powers of faction management type
void onFactionManagementS(int nNation = FALSE);
//Handles actions specific against a rank
void onRankAS();
//Handles the selection of settlement powers.
void onSettlementPowerS(int nNation = FALSE);
//Handles create messages and on message selection.
void onMessageS();
//Handles selection of message powers
void onMsgPS();
//Handles selection of bank powers
void onBankPowerS(int nNation = FALSE);
//Handles selection of Salary And Due (View outsiders and add outsider)
void onSalDueS();
//Handles the response selection for outsider actions
void onOutsiderAS(string sPage, string sActionSal, string sActionRem);
//Handles toggleing of fixture powers
void onFixtureS(int nNation=FALSE);
//Handles toggleing of shop powers
void onShopS(int nNation=FALSE);

//Other functions
//Called when the main page is being called
//and the lists/variables need to be prepared
//for a new faction selection
//If zz_co_nation will end the conversation and start the default NPC conversation
void ChangePageToMain();
void _RefreshOutsiderList(int nOut = 1);
void _ListRankActions(string sFaction, object oPC);
void _ListMemberActions(string sFaction, object oPC);
void _RefreshFactionList(object oPC, int nStart=1, int nEnd=50);
/////////////////////////////////////////////////////
//Readies a confirmation option and changes the page
void _ConfirmationSetupnHelper(string sAction, string sPage)
{
  dlgSetPlayerDataString(VAR_ACTIONS, sAction);
  dlgSetPlayerDataString(VAR_PAGE, sPage);
  dlgChangePage(PAGE_CONFIRM);
}
void _TakeWrit(object oPC, string sDatabaseID, int nPower, string sList = "1", int nTakeWrit=FALSE)
{
  //We always take a writ if sID is a leader
  string sLeader = dlgGetPlayerDataString(VAR_MEMBER);
  if(md_GetFacNation(sDatabaseID) != "" &&
     (md_GetHasWrit(oPC, sDatabaseID, nPower, sList) == 3 ||
     (sLeader != "" && GetIsNationLeaderByIDFromCache(sLeader, sDatabaseID))))
  {
    object oWrit = GetItemPossessedBy(oPC, "micz_writ_sgn");
    if(GetIsObjectValid(oWrit)) gsCMReduceItem(oWrit);
    dlgClearResponseList(PAGE_MEMBER_ACTIONS);
    dlgClearResponseList(PAGE_RANK_ACTIONS);
  }
}
// Also called when new ranks/members are being selected
void CleanPowerPages()
{
  dlgClearResponseList(SET_NATION);
  dlgClearResponseList(PAGE_GIVE_POWERS);
}
//Also called when the page is going back
//to the main menu, readies the conversation
//for the next faction selection
void CleanPages()
{
  //dlgClearResponseList(PAGE_MAIN);
  dlgClearResponseList(PAGE_ACTION);
  dlgClearResponseList(PAGE_RANK_ACTIONS);
  dlgClearResponseList(PAGE_MEMBER_ACTIONS);
  dlgClearResponseList(PAGE_VIEW_MEMBERS);
  dlgClearResponseList(PAGE_VIEW_RANKS);
  dlgClearResponseList(PAGE_NAMES);
  dlgClearResponseList(LIST_IDS);
  dlgClearResponseList(LIST_MEMBER_IDS);
  dlgClearResponseList(LIST_OUT_DUE);
  dlgClearResponseList(LIST_OUT_SAL);
  dlgClearResponseList(SETTLEMENT_POWERS);
  dlgClearResponseList(FACTION_MANAGEMENT);
  dlgClearResponseList(NATION_POWERS);
  dlgClearResponseList(NATION_MANAGE);
  dlgClearResponseList(PAGE_MESSAGES);
  dlgClearResponseList(MESSAGE_POWERS);
  dlgClearResponseList(BANK_POWERS);
  dlgClearResponseList(NATION_BANK);
  dlgClearResponseList(PAGE_OUT_DUES);
  dlgClearResponseList(PAGE_OUT_SAL);
  dlgClearResponseList(PAGE_ADD_OUTSIDER);
  dlgClearResponseList(PAGE_OUT_DUES_ACT);
  dlgClearResponseList(PAGE_OUT_SAL_ACT);
  dlgClearResponseList(SALARIES_DUES);
  dlgClearResponseList(PAGE_FACTION_LIST);
  dlgClearResponseList(FIXT_POWERS);
  dlgClearResponseList(NAT_FIXTURE);
  dlgClearResponseList(SHOP_POWERS);
  dlgClearResponseList(NATION_SHOP);
  CleanPowerPages();
}
void Cleanup()
{
  CleanPages();
  dlgClearResponseList(PAGE_NATION_LEADER);
  dlgClearResponseList(PAGE_CONFIRM);
  dlgClearResponseList(PAGE_SELF);
  dlgClearResponseList(PAGE_PAY_PERSONAL);
  dlgClearResponseList(PAGE_PAY_PER_LIST_S);
  dlgClearResponseList(PAGE_PAY_PER_LIST_D);
  dlgClearResponseList(LIST_IDS+"0");
  dlgClearResponseList(LIST_IDS+"1");
  dlgClearPlayerDataString(VAR_FACTION);
  dlgClearPlayerDataString(VAR_MEMBER);
  dlgClearPlayerDataString(VAR_PAGE);
  dlgClearPlayerDataString(VAR_ACTIONS);
  dlgClearPlayerDataString(VAR_RANK);
  dlgClearPlayerDataString(VAR_MESSAGE);
  dlgClearPlayerDataInt(VAR_MESSAGE);
  dlgClearPlayerDataInt(VAR_CREATE);
  dlgClearPlayerDataInt(VAR_RANK);
  dlgClearPlayerDataInt(VAR_PAY);
}

void OnContinue(string sPage, int nContinuePage)
{
}
string _CreatePowerPrompt(string sType)
{
  dlgActivatePreservePageNumberOnSelection();
  string sPrompt = "Which " + sType + " powers do you want to give (or take) from ";
  string sID = dlgGetPlayerDataString(VAR_MEMBER);
  if(sID != "")
    sPrompt += fbFAGetNameFromID(sID);
  else
  {
    int nRank = dlgGetPlayerDataInt(VAR_RANK);
    if(nRank)
    {
      string sFaction = dlgGetPlayerDataString(VAR_FACTION);
      sPrompt += md_FAGetRankName(sFaction, md_FAGetNthRankID(sFaction, nRank));
    }
    else
      sPrompt += "your faction";
  }
  return sPrompt += "? ((Powers in green are already applied. Powers in red are not applied.))";

}

void OnPageInit(string sPage)
{
  string sPrompt;
  // This is the function that sets up the prompts for each page.

  if(sPage == PAGE_MAIN)
  {
    DeleteLocalInt(dlgGetSpeakingPC(), "MD_FAC_MAIN");
    sPrompt = onMainPage();
  }
  else
  {
    dlgActivateResetResponse(DLG_DEFAULTLABEL_RESET, DLG_DEFAULT_TXT_ACTION_COLOR);
    //onRanks must be called when getting the prompts
    if(sPage == PAGE_PLEASE_WAIT)
    {
      object oPC = dlgGetSpeakingPC();
      dlgClearResponseList(PAGE_MAIN);
      _RefreshFactionList(oPC);
      sPrompt = "Please wait..";
    }
    else if(sPage == PAGE_ACTION)
        onAction();
    else if(sPage == PAGE_VIEW_MEMBERS)
        onMembers();
    else if(sPage == PAGE_GIVE_POWERS)
      onGivePower();
    //Below this point do not have to be called to set prompts
    else if(sPage == PAGE_CONFIRM)
      sPrompt = onConfirmation();
    else if(sPage == PAGE_NAMES || sPage == PAGE_ADD_OUTSIDER)
      sPrompt = "Who do you mean?";
    else if(sPage == SETTLEMENT_POWERS || sPage == NATION_POWERS)
      sPrompt = _CreatePowerPrompt("Settlement");
    else if(sPage == SET_NATION)
      sPrompt = onGiveNatPower();
    else if(sPage == NATION_MANAGE)
      sPrompt = _CreatePowerPrompt("Settlement management");
    else if(sPage == FACTION_MANAGEMENT)
      sPrompt = _CreatePowerPrompt("Management");
    else if(sPage == PAGE_MESSAGES)
      sPrompt = "Below are the OOC messages of the faction. The most recent is first. " +
                "Remove messages by clicking them. Type {Rank or Part of Rank} at start of message to show " +
                "the message to only those with that rank. Owners can see all messages.";
    else if(sPage == MESSAGE_POWERS)
    {
      sPrompt = _CreatePowerPrompt("OOC messages");
    }
    else if(sPage == BANK_POWERS || sPage == NATION_BANK)
      sPrompt = _CreatePowerPrompt("bank");
    else if(sPage == PAGE_SELF)
    {
      string sMember = dlgGetPlayerDataString(VAR_MEMBER);
      string sFaction = dlgGetPlayerDataString(VAR_FACTION);
      sPrompt = "Which task would you like to perform for yourself.";
      int nPay = md_GetFacPay(sMember, sFaction);

      if(nPay != 0)
      {
         sPrompt += "\n\n";
         if(nPay > 0)
           sPrompt += "Current Due: " + IntToString(nPay);
         else
         {
           nPay *= -1;
           sPrompt += "Current Salary: " + IntToString(nPay);
         }
      }
      dlgClearResponseList(PAGE_SELF);
      //Nation leaders need a writ to change their rank
      //Child factions and usual owners can change their rank without needing  a writ
      int nWrit = md_GetHasWrit(dlgGetSpeakingPC(), sFaction, 0);
      int nLeader = GetIsNationLeaderByIDFromCache(sMember, sFaction);
      if(nWrit == 3 || nWrit == 1 || (fbFAGetIsOwningRankByID(sFaction, sMember) && !nLeader))
        dlgAddResponse(PAGE_SELF, _GetText(CHANGE_RANK));

      if(nLeader)
        dlgAddResponse(PAGE_SELF, _GetText(GIVE_POWERS));
      //I'm going to allow nation leaders to change their own powers too, provided they have a writ
      //And salaries
      if(nWrit == 3 || nWrit == 1)
        dlgAddResponse(PAGE_SELF, _GetText(SET_SALARY));


      dlgAddResponse(PAGE_SELF, PAY_DUE);

    }
    else if(sPage == PAGE_OUT_DUES)
    {
      object oPC = dlgGetSpeakingPC();
      string sFaction = dlgGetPlayerDataString(VAR_FACTION);

      if(!GetElementCount(PAGE_OUT_DUES, oPC))
        _RefreshOutsiderList(0);

      if(!GetElementCount(PAGE_OUT_DUES_ACT, oPC))
      {
        int nWrit = md_GetHasWrit(oPC, sFaction, MD_PR2_SOS, "2");
        if(md_GetHasPowerMaster(MD_PR2_ROD, oPC, sFaction, "2"))
          dlgAddResponse(PAGE_OUT_DUES_ACT, _GetText(REMOVE_OUTSIDER));
        if(nWrit == 1 || nWrit == 3 || (nWrit == 2 && md_GetHasPowerMaster(MD_PR2_SOS, oPC, sFaction, "2")))
          dlgAddResponse(PAGE_OUT_DUES_ACT, _GetText(SET_SALARY));
        else if(!nWrit)
          SendMessageToPC(oPC, "You need a valid writ to pay out salaries.");
      }
    }
    else if(sPage == PAGE_OUT_SAL)
    {
      object oPC = dlgGetSpeakingPC();
      string sFaction = dlgGetPlayerDataString(VAR_FACTION);
      if(!GetElementCount(PAGE_OUT_SAL, oPC))
        _RefreshOutsiderList();

      if(!GetElementCount(PAGE_OUT_SAL_ACT, oPC))
      {
        int nWrit = md_GetHasWrit(oPC, sFaction, MD_PR2_ROS, "2");
        if(nWrit == 1 || nWrit == 3 || (nWrit == 2 && md_GetHasPowerMaster(MD_PR2_ROS, oPC, sFaction, "2")))
          dlgAddResponse(PAGE_OUT_SAL_ACT, _GetText(REMOVE_OUTSIDER));
        else if(!nWrit)
          SendMessageToPC(oPC, "You need a valid writ to remove an outsider being paid a salary.");
        nWrit = md_GetHasWrit(oPC, sFaction, MD_PR2_SOS, "2");
        if(nWrit == 1 || nWrit == 3 || (nWrit == 2 && md_GetHasPowerMaster(MD_PR2_SOS, oPC, sFaction, "2")))
          dlgAddResponse(PAGE_OUT_SAL_ACT, _GetText(SET_SALARY));
        else if(!nWrit)
          SendMessageToPC(oPC, "You need a valid writ to change an outsiders salary.");

      }
    }
    else if(sPage == PAGE_PAY_PERSONAL)
      sPrompt = "Select an action:";
    else if(sPage == PAGE_PAY_PER_LIST_S)
      sPrompt = onViewFactionPay(sPage, FALSE);
    else if(sPage == PAGE_PAY_PER_LIST_D)
      sPrompt = onViewFactionPay(sPage);
    else if(sPage == PAGE_FACTION_LIST)
      sPrompt = onFactionList();
    else if(sPage == NAT_FIXTURE || sPage == FIXT_POWERS)
      sPrompt =  _CreatePowerPrompt("fixture");
    else if(sPage == SHOP_POWERS || sPage == NATION_SHOP)
      sPrompt = _CreatePowerPrompt("shop");
    else if(sPage == PAGE_NATION_LEADER)
    {
      string sMember = dlgGetPlayerDataString(VAR_MEMBER);
      string sFaction = dlgGetPlayerDataString(VAR_FACTION);

      int nPay = md_GetFacPay(sMember, sFaction);
      sPrompt = "Which task would you like to perform on fellow councilor, " +
                 gsPCGetPlayerName(sMember) + "? Remember you need a writ for any task.";
      if(nPay != 0)
      {
         sPrompt += "\n\n";
         if(nPay > 0)
           sPrompt += "Current Due: " + IntToString(nPay);
         else
         {
           nPay *= -1;
           sPrompt += "Current Salary: " + IntToString(nPay);
         }
      }
      dlgClearResponseList(PAGE_NATION_LEADER);
      int nWrit = md_GetHasWrit(dlgGetSpeakingPC(), sFaction, 0);
      if(nWrit == 3)
      {
        dlgAddResponse(PAGE_NATION_LEADER, _GetText(REMOVE_MEMBER));
        dlgAddResponse(PAGE_NATION_LEADER, _GetText(CHANGE_RANK));
        dlgAddResponse(PAGE_NATION_LEADER, _GetText(SET_SALARY));
      }

      dlgAddResponse(PAGE_NATION_LEADER, _GetText(GIVE_POWERS));
    }
    else if(sPage == PAGE_MEMBER_ACTIONS)
    {

      //If for whatever reason the list is blank, create it
      object oPC = dlgGetSpeakingPC();
      if(!GetElementCount(sPage, dlgGetSpeakingPC()))
        _ListMemberActions(dlgGetPlayerDataString(VAR_FACTION), oPC);
    }
    else if(sPage == PAGE_RANK_ACTIONS)
    {
      //If For whatever reason the list is blank, create it.
      object oPC = dlgGetSpeakingPC();
      if(!GetElementCount(sPage, oPC))
        _ListRankActions(dlgGetPlayerDataString(VAR_FACTION), oPC);
    }
  }

  if(sPrompt == "")
  {
    sPrompt = GetPrompt(sPage);
    if(sPage == PAGE_MEMBER_ACTIONS || sPage == PAGE_OUT_DUES_ACT
       || sPage == PAGE_OUT_SAL_ACT || sPage == PAGE_RANK_ACTIONS)
       {
         string sMember = dlgGetPlayerDataString(VAR_MEMBER);
         string sFaction = dlgGetPlayerDataString(VAR_FACTION);
         if(sMember == "")
           sMember = "R"+md_FAGetNthRankID(sFaction, dlgGetPlayerDataInt(VAR_RANK));
         int nPay = md_GetFacPay(sMember, sFaction);

         if(nPay != 0)
         {
           sPrompt += "\n\n";
           if(nPay > 0)
             sPrompt += "Current Due: " + IntToString(nPay);
           else
           {
             nPay *= -1;
             sPrompt += "Current Salary: " + IntToString(nPay);
           }
         }
       }
  }

  dlgSetPrompt(sPrompt);
  dlgSetActiveResponseList(sPage);
}

void OnSelection(string sPage)
{

  if (sPage == PAGE_MAIN)
    onMainPageS();
  else if (sPage == PAGE_ACTION)
    onActionS();
  else if(sPage == PAGE_VIEW_MEMBERS)
    onMembersS();
  else if(sPage == PAGE_MEMBER_ACTIONS)
    onMembersAS();
  else if(sPage == PAGE_CONFIRM)
    onConfirmationS();
  else if(sPage == PAGE_VIEW_RANKS)
    onRanksS();
  else if(sPage == PAGE_GIVE_POWERS || sPage == SET_NATION)
    dlgChangePage(dlgGetSelectionName());
  else if(sPage == FACTION_MANAGEMENT)
    onFactionManagementS();
  else if(sPage == PAGE_RANK_ACTIONS)
    onRankAS();
  else if(sPage == PAGE_NAMES)
  {
    dlgSetPlayerDataString(VAR_MEMBER, GetStringElement(dlgGetSelectionIndex(), LIST_IDS, dlgGetSpeakingPC()));
    _ConfirmationSetupnHelper(ADD_MEMBER, PAGE_ACTION);
  }
  else if(sPage == PAGE_ADD_OUTSIDER)
  {
    dlgSetPlayerDataString(VAR_MEMBER, GetStringElement(dlgGetSelectionIndex(), LIST_IDS, dlgGetSpeakingPC()));
    _ConfirmationSetupnHelper(ADD_OUTSIDER, SALARIES_DUES);
  }
  else if(sPage == SETTLEMENT_POWERS)
    onSettlementPowerS();
  else if(sPage == NATION_MANAGE)
    onFactionManagementS(TRUE);
  else if(sPage == NATION_POWERS)
    onSettlementPowerS(TRUE);
  else if(sPage == PAGE_MESSAGES)
    onMessageS();
  else if(sPage == MESSAGE_POWERS)
    onMsgPS();
  else if(sPage == BANK_POWERS)
    onBankPowerS();
  else if(sPage == NATION_BANK)
    onBankPowerS(TRUE);
  else if(sPage == PAGE_SELF)
  {
    string sResponse = dlgGetSelectionName();
    if(sResponse == PAY_DUE)
    {
      object oPC = dlgGetSpeakingPC();
      string sID = gsPCGetPlayerID(oPC);
      string sFaction = dlgGetPlayerDataString(VAR_FACTION);
      if(md_GetFacPay(sID, sFaction) < 0) //Salary
        _ConfirmationSetupnHelper(PAGE_SELF, PAGE_SELF);
      else
      {
        dlgClearResponseList(PAGE_VIEW_MEMBERS);
        md_SetFacPay(sID, sFaction, StringToInt(chatGetLastMessage(oPC)), MD_PR2_ROS, OBJECT_INVALID, TRUE);
      }
    }
    else
      onMembersAS(PAGE_SELF);
  }
  else if(sPage == SALARIES_DUES)
    onSalDueS();
  else if(sPage == PAGE_OUT_SAL)
  {
    object oPC = dlgGetSpeakingPC();
    string sFaction = dlgGetPlayerDataString(VAR_FACTION);
    string sID = GetStringElement(dlgGetSelectionIndex(), LIST_OUT_SAL, oPC);
    if(!GetElementCount(PAGE_OUT_SAL_ACT, oPC))
      SendMessageToPC(oPC, "You have no powers to act against this individual");
    else if(fbFAGetRankByID(sFaction, sID) != FB_FA_NON_MEMBER)
      SendMessageToPC(oPC, "This person is either removed or is now an official part of the faction");
    else
    {
      dlgSetPlayerDataString(VAR_MEMBER, sID);
      dlgChangePage(PAGE_OUT_SAL_ACT);
    }
  }
  else if(sPage == PAGE_OUT_DUES)
  {
    object oPC = dlgGetSpeakingPC();
    string sFaction = dlgGetPlayerDataString(VAR_FACTION);
    string sID = GetStringElement(dlgGetSelectionIndex(), LIST_OUT_DUE, oPC);
    if(!GetElementCount(PAGE_OUT_DUES_ACT, oPC))
      SendMessageToPC(oPC, "You have no powers to act against this individual");
    else if(fbFAGetRankByID(sFaction, sID) != FB_FA_NON_MEMBER)
      SendMessageToPC(oPC, "This person is either removed or is now an official part of the faction");
    else
    {
      dlgSetPlayerDataString(VAR_MEMBER, sID);
      dlgChangePage(PAGE_OUT_DUES_ACT);
    }
  }
  else if(sPage == PAGE_OUT_DUES_ACT)
    onOutsiderAS(PAGE_OUT_DUES, SET_SALARY_D, REMOVE_OUTSIDER_DUE);
  else if(sPage == PAGE_OUT_SAL_ACT)
    onOutsiderAS(PAGE_OUT_SAL, SET_SALARY_S, REMOVE_OUTSIDER_SAL);
  else if(sPage == PAGE_PAY_PERSONAL)
  {
    if(dlgGetSelectionIndex() == 0) //due
      dlgChangePage(PAGE_PAY_PER_LIST_D);
    else   //salary
      dlgChangePage(PAGE_PAY_PER_LIST_S);
  }
  else if(sPage == PAGE_PAY_PER_LIST_D)
  {
    int nIndex = dlgGetSelectionIndex();
    if(nIndex == 0) //add faction
      dlgChangePage(PAGE_FACTION_LIST);
    else
    {
      object oPC = dlgGetSpeakingPC();
      md_SetFacPay(fbFAGetPCID(oPC), GetStringElement(nIndex - 1, LIST_IDS+"1", oPC), StringToInt(chatGetLastMessage(oPC)), MD_PR2_ROS, OBJECT_INVALID, TRUE);
      dlgClearResponseList(PAGE_PAY_PER_LIST_D);
    }
  }
  else if(sPage == PAGE_PAY_PER_LIST_S)
  {
    dlgSetPlayerDataString(VAR_FACTION, GetStringElement(dlgGetSelectionIndex() , LIST_IDS+"0", dlgGetSpeakingPC()));
    _ConfirmationSetupnHelper(PAGE_PAY_PER_LIST_S, PAGE_PAY_PER_LIST_S);
  }
  else if(sPage == PAGE_FACTION_LIST)
  {
    dlgSetPlayerDataString(VAR_FACTION, GetStringElement(dlgGetSelectionIndex(), LIST_IDS, dlgGetSpeakingPC()));
    _ConfirmationSetupnHelper(PAGE_FACTION_LIST, PAGE_PAY_PER_LIST_D);
  }
  else if(sPage == NAT_FIXTURE)
    onFixtureS(TRUE);
  else if(sPage == FIXT_POWERS)
    onFixtureS();
  else if(sPage == NATION_SHOP)
    onShopS(TRUE);
  else if(sPage == SHOP_POWERS)
    onShopS();
  else if(sPage == PAGE_NATION_LEADER)
    onMembersAS(PAGE_NATION_LEADER);
}
void OnAbort(string sPage)
{
    Cleanup();
}
void OnEnd(string sPage)
{
    Cleanup();
}
void OnReset(string sPage)
{

   string sLPage = dlgGetPlayerDataString(VAR_PAGE);
   string sID = dlgGetPlayerDataString(VAR_MEMBER);
   dlgDeactivatePreservePageNumberOnSelection();
   // This method handles what happens when the player selects an option.
   if(sPage == PAGE_ACTION)
    ChangePageToMain();
   else if(sPage == PAGE_VIEW_MEMBERS
           || sPage == PAGE_NAMES
           || sPage == PAGE_MESSAGES
           || sPage == SALARIES_DUES)
   {
     dlgChangePage(PAGE_ACTION);
   }
   else if(sPage == PAGE_PAY_PERSONAL)
     ChangePageToMain();
   else if(sPage == PAGE_FACTION_LIST)
     dlgChangePage(PAGE_PAY_PER_LIST_D);
   else if(sPage == PAGE_PAY_PER_LIST_S || sPage == PAGE_PAY_PER_LIST_D)
     dlgChangePage(PAGE_PAY_PERSONAL);
   else if(sPage == FACTION_MANAGEMENT ||
           sPage == SETTLEMENT_POWERS ||
           sPage == MESSAGE_POWERS ||
           sPage == BANK_POWERS ||
           sPage == FIXT_POWERS ||
           sPage == SHOP_POWERS)
     dlgChangePage(PAGE_GIVE_POWERS);
   else if(sPage == PAGE_RANK_ACTIONS)
     dlgChangePage(PAGE_VIEW_RANKS);
   else if(sPage == PAGE_MEMBER_ACTIONS || sPage == PAGE_SELF || sPage == PAGE_NATION_LEADER)
     dlgChangePage(PAGE_VIEW_MEMBERS);
   else if(sPage == NATION_MANAGE ||
           sPage == NATION_POWERS ||
           sPage == NATION_BANK ||
           sPage == NAT_FIXTURE ||
           sPage == NATION_SHOP)
     dlgChangePage(SET_NATION);
   else if(sPage == PAGE_OUT_DUES_ACT)
     dlgChangePage(PAGE_OUT_DUES);
   else if(sPage == PAGE_OUT_SAL_ACT)
     dlgChangePage(PAGE_OUT_SAL);
   else if(sPage == PAGE_OUT_DUES || sPage == PAGE_OUT_SAL || sPage == PAGE_ADD_OUTSIDER)
     dlgChangePage(SALARIES_DUES);
   else if(sPage == SET_NATION && GetElementCount(PAGE_GIVE_POWERS, dlgGetSpeakingPC()))
     dlgChangePage(PAGE_GIVE_POWERS);
   else if(sPage == PAGE_VIEW_RANKS && gsPCGetPlayerID(dlgGetSpeakingPC()) == dlgGetPlayerDataString(VAR_MEMBER))
   {
     dlgChangePage(PAGE_SELF);
     dlgClearPlayerDataString(VAR_PAGE);
   }
   else if(sPage == PAGE_VIEW_RANKS && sID != "" && GetIsNationLeaderByIDFromCache(sID, dlgGetPlayerDataString(VAR_FACTION)))
   {
     dlgChangePage(PAGE_NATION_LEADER);
     dlgClearPlayerDataString(VAR_PAGE);
   }
   else if(sLPage != "")
   {
     if(sPage == PAGE_CONFIRM && dlgGetPlayerDataString(VAR_ACTIONS) == MD_FA_OWNER_RANK)
       dlgSetPlayerDataString(VAR_PAGE, PAGE_MEMBER_ACTIONS);
     else
       dlgClearPlayerDataString(VAR_PAGE);

     dlgChangePage(sLPage);
   }
   else if(sPage == PAGE_VIEW_RANKS)
     dlgChangePage(PAGE_ACTION);
   else
     ChangePageToMain();

}

void Fac_OnInit()
{
  dlgClearResponseList(PAGE_CONFIRM);
  dlgAddResponse(PAGE_CONFIRM, "Yes.");
  dlgAddResponse(PAGE_CONFIRM, "No.");


  dlgClearResponseList(PAGE_PAY_PERSONAL);
  dlgAddResponseAction(PAGE_PAY_PERSONAL, VIEW_FAC_DUE);
  dlgAddResponseAction(PAGE_PAY_PERSONAL, VIEW_FAC_SAL);

  //dlgActivatePreservePageNumberOnSelection();
  dlgActivateEndResponse("[Done]", txtBlue);
  dlgChangeLabelNext(DLG_DEFAULTLABEL_NEXT, DLG_DEFAULT_TXT_ACTION_COLOR);
  dlgChangeLabelPrevious(DLG_DEFAULTLABEL_PREV, DLG_DEFAULT_TXT_ACTION_COLOR);

}
//Internal/Helper functions
///////////////////////////////////////////////////////
//Called when I need to clear lists and vairables and change
//to the main page
void ChangePageToMain()
{
  object oPC = dlgGetSpeakingPC();
  if(GetLocalString(oPC, DLG_CURRENT_SCRIPT) == FACTION_SCRIPT)
  {
    CleanPages();
    dlgChangePage(PAGE_PLEASE_WAIT);
  }
  else
  {
    dlgEndDialog();
    ActionStartConversation(oPC);
  }
}
///////////////////////////////////////////////////////
//Sets the text to be retrived by _GetText.
void _SetText(string sVar, string sText)
{
  dlgSetSpeakeeDataString(sVar, sText);
}
///////////////////////////////////////////////////////
string FactionTotals(int nVDues, int nVSal, string sList = "1")
{
  string sFaction = dlgGetPlayerDataString(VAR_FACTION);
  int nPay;
  string sResponse;
  object oPC = dlgGetSpeakingPC();
  if(md_GetHasPowerMaster(nVSal, oPC, sFaction, sList))
  {
    nPay = md_GetFacPayTotal(sFaction);

    if(nPay != 0)
      sResponse = "\n\nTotal Salary: " + IntToString(nPay * -1);
  }

  if(md_GetHasPowerMaster(nVDues, oPC, sFaction, sList))
  {
    nPay = md_GetFacPayTotal(sFaction, "DUE");

    if(nPay != 0)
      sResponse += "\n\nTotal Due: " + IntToString(nPay);
  }

  return sResponse;
}
///////////////////////////////////////////////////////
//Get the text from the variable, if there is no text inside the variable
//return the variable.
string _GetText(string sVar)
{
  string sText = dlgGetSpeakeeDataString(sVar);
  if(sText == "")
    sText = sVar;

  return sText;
}
///////////////////////////////////////////////////////
//Creates the faction list
void _RefreshFactionList(object oPC, int nStart = 1, int nEnd = 50)
{

  // Create list of factions for this PC here.  Cycle through factions and see
  // if PC is a member of any of them?
  object oModule = GetModule();
  int nNumFactions;
  int nCount;
  string sFaction;
  string sID = fbFAGetPCID(oPC);


  nNumFactions = GetLocalInt(oModule, "MD_FA_HIGHEST");
  if(nEnd > nNumFactions)
    nEnd = nNumFactions;
  for(nCount = nStart; nCount <= nEnd; nCount++)
  {
    sFaction = GetLocalString(oModule, "MD_FA_DATABASEID_"+IntToString(nCount));
    if (mdFAInFaction(sFaction, oPC))
    {
      Trace(PAGE_MAIN, "PC " + GetName(oPC) + " is a member of " + sFaction);
      dlgAddResponse(PAGE_MAIN, fbFAGetFactionNameDatabaseID(sFaction)); // DO NOT USE FORMATTING so we can map back to ID
    }
  }

  if(nCount < nNumFactions)
    DelayCommand(0.1, _RefreshFactionList(oPC, nEnd+1, nEnd+50));
  else
  {
    dlgAddResponseAction(PAGE_MAIN, "[View Faction Pay]");
    dlgAddResponseAction(PAGE_MAIN, "[Create new faction]");
    SetLocalInt(oPC, "MD_FAC_MAIN", 1);
    AssignCommand(oPC, ActionStartConversation(oPC, " ", TRUE, TRUE));
    DelayCommand(0.1, _dlgStart(oPC, oPC, "zz_co_factions", TRUE, TRUE, TRUE));
  }

}

////////////////////////////////////////////////////////
//Creates the member list
void _RefreshMemberList(string sFaction, object oPC)
{
  int nCount;
  string sID;
  string sRank;
  string sResponse;
  int nPay;
  int nPSal = md_GetHasPowerMaster(MD_PR_VMS, oPC, sFaction);
  int nPDue = md_GetHasPowerMaster(MD_PR_VMD, oPC, sFaction);
  int nVRank = md_GetHasPowerMaster(MD_PR_VRK, oPC, sFaction);
  string sPID = gsPCGetPlayerID(oPC);
  dlgClearResponseList(PAGE_VIEW_MEMBERS);
  dlgClearResponseList(LIST_MEMBER_IDS);
  Trace(ZDIALOG, "Setting up faction member list.");


  //Use SQL
  SQLExecDirect("SELECT gs.id, gs.name, md.is_OwnerRank FROM md_fa_members AS md INNER JOIN gs_pc_data AS gs " +
                "ON md.pc_id=gs.id WHERE md.faction_id='"+sFaction+"' AND (md.rank_id!='1' OR md.rank_id IS NULL) ORDER BY md.is_OwnerRank DESC");

 // SQLExecDirect("SELECT pc_id,faction_id,is_OwnerRank FROM md_fa_members ORDER BY is_OwnerRank DESC");


  while(SQLFetch())
  {
    sID = SQLGetData(1);
    dlgAddResponse(LIST_MEMBER_IDS, sID);
    sResponse = SQLGetData(2);
    if(SQLGetData(3) == "1")
      sResponse += " [Owner]";

    if(nVRank)
      sResponse += " ("+md_FAGetRankName(sFaction, IntToString(fbFAGetRankByID(sFaction, sID)))+")";

    nPay = md_GetFacPay(sID, sFaction);
    //Salary
    if(nPay < 0 && (nPSal || sID == sPID)) //always see your own pay
    {
      nPay *= -1;
      sResponse += " (" + txtYellow + IntToString(nPay) + "</c>)";
    } //Dues
    else if(nPay > 0 && (nPDue || sID == sPID)) //always see your own pay
      sResponse += " (" + txtWhite + IntToString(nPay) + "</c>)";


    dlgAddResponse(PAGE_VIEW_MEMBERS, sResponse);
  }

}

/////////////////////////////////////////////////
//As above, but for ranks
void _RefreshRankList(string sFaction, object oPC)
{
  int nCount;
  string sRank;
  int nVDues;
  int nVSal;
  //only for nation conversation
  if(GetLocalString(oPC, DLG_CURRENT_SCRIPT)  != FACTION_SCRIPT &&
    dlgGetPlayerDataString(VAR_PAGE) != PAGE_MEMBER_ACTIONS)
  {
    nVDues = md_GetHasPowerMaster(MD_PR_VRD, oPC, sFaction);
    nVSal = md_GetHasPowerMaster(MD_PR_VRS, oPC, sFaction);
  }
  int nPay;
  int nMax = md_FaRankCount(sFaction);
  dlgClearResponseList(PAGE_VIEW_RANKS);

  //Only show option  for rank changes
  //Don't show if a settlement (or it's child) was selected
  //Owner couldn't be choosen
  if(md_GetFacNation(sFaction) == ""
     && dlgGetPlayerDataString(VAR_PAGE) == PAGE_MEMBER_ACTIONS
     && fbFAGetIsOwningRank(sFaction, oPC) && !fbFAGetIsOwningRankByID(sFaction, dlgGetPlayerDataString(VAR_MEMBER)))
       dlgAddResponse(PAGE_VIEW_RANKS, MD_FA_OWNER_RANK);

  dlgAddResponse(PAGE_VIEW_RANKS, MD_FA_MEMBER_RANK);

  for (nCount = 1; nCount <= nMax; nCount++) // This list is 1-based.
  {
    sRank = md_FAGetNthRankID(sFaction, nCount);
    nPay = md_GetFacPay("R"+sRank, sFaction);
    sRank = md_FAGetRankName(sFaction, sRank);
    if(nPay > 0 && nVDues)
      sRank += " ("+txtWhite+IntToString(nPay)+"</c>)";
    else if(nPay < 0 && nVSal)
    {
      nPay *= -1;
      sRank += " ("+txtYellow+IntToString(nPay)+"</c>)";
    }

    if(sRank != "")
      dlgAddResponse(PAGE_VIEW_RANKS, sRank);

  }
}
/////////////////////////////////////////////////
//Refreshes the outsider list, stype is in or out
void _RefreshOutsiderList(int nOut = 1)
{

  int nPay;
  string sResponse;
  string sFaction = dlgGetPlayerDataString(VAR_FACTION);
  object oPC = dlgGetSpeakingPC();
  int nPSal = md_GetHasPowerMaster(MD_PR2_VAS, oPC, sFaction, "2");
  int nPDue = md_GetHasPowerMaster(MD_PR2_VAD, oPC, sFaction, "2");
  string sPage = PAGE_OUT_DUES;
  string sListID = LIST_OUT_DUE;
  string sSign = ">";
  if(nOut)
  {
    sPage = PAGE_OUT_SAL;
    sListID = LIST_OUT_SAL;
    sSign = "<";
  }
  dlgClearResponseList(sPage);
  dlgClearResponseList(sListID);

  SQLExecDirect("SELECT gs.id, gs.name, md.pay FROM md_fa_members AS md INNER JOIN gs_pc_data AS gs " +
                "ON md.pc_id=gs.id WHERE md.faction_id='"+sFaction+"' AND md.rank_id='1' AND md.pay"+sSign+"'0'");


  while(SQLFetch())
  {
    nPay = StringToInt(SQLGetData(3));
    //Salary
    if(nPay < 0 && nPSal)
    {
      nPay *= -1;
      sResponse = " (" + txtYellow + IntToString(nPay) + "</c>)";
    } //Dues
    else if(nPay > 0 && nPDue)
      sResponse = " (" + txtWhite + IntToString(nPay) + "</c>)";
    else
      sResponse = "";

    dlgAddResponse(sPage, SQLGetData(2) + sResponse);
    dlgAddResponse(sListID, SQLGetData(1));
  }

}
///////////////////////////////////////////////////////////
//Helper function, checks to see if oPC has the power
//then checks to see if sID has the power as well
//if both checks are successful, adds the option as green
//if only the PC has it, adds the option as red.
//If the PC does not have it, it's not added at all
void _DisplayPowerGreenOrRed(int nPower, string sResponse, object oPC, string sID, string sFaction, string sPage, int nPTG, int nView, string sList = "1", int nNation = FALSE)
{
  string sView;

  //Check to see if they have the power first, and the power to give powers
  if(md_GetHasPowerMaster(nPower, oPC, sFaction, sList, nNation) && nPTG)
    sView = "";
  else if(nView)
    sView = "{View} ";
  else
    return; //No powers to view or give this power

  string sColor;

  if(md_GetHasPowerByID(nPower, sID, sFaction, sList, nNation))
    sColor = txtGreen;
  else
    sColor = txtRed;

  dlgAddResponseAction(sPage, sView+sResponse, sColor);

}
//Sets up non-nation power list.
void _SetUpPowerList(object oPC, string sID, string sFaction, string sPage = "ALL")
{
  string sScript = GetLocalString(oPC, DLG_CURRENT_SCRIPT);
  int nPTG;
  int nView;
  //Get if they have to give
  if(dlgGetPlayerDataString(VAR_MEMBER) == "")
  {
    nPTG = md_GetHasPowerMaster(MD_PR_GPR, oPC, sFaction);
    nView = md_GetHasPowerMaster(MD_PR_VPR, oPC, sFaction);
  }
  else
  {
    nPTG = md_GetHasPowerMaster(MD_PR_GPM, oPC, sFaction);
    nView = md_GetHasPowerMaster(MD_PR_VPM, oPC, sFaction);
  }
  //Only show if it's called through the nation conversation or if
  //Or if it's not a nation faction
  //Only show if faction has a time stamp - catches castles
  if((miCZGetName(md_GetFacNation(sFaction)) != fbFAGetFactionNameDatabaseID(sFaction) && md_GetFactionTime(sFaction) > 0) ||
     sScript != FACTION_SCRIPT)
  {
    if(sPage == "ALL" || sPage == FACTION_MANAGEMENT)
    {
      dlgClearResponseList(FACTION_MANAGEMENT);
      _DisplayPowerGreenOrRed(MD_PR_VAM, MD_PRS_VAM, oPC, sID, sFaction, FACTION_MANAGEMENT, nPTG, nView);
      _DisplayPowerGreenOrRed(MD_PR_VRK, MD_PRS_VRK, oPC, sID, sFaction, FACTION_MANAGEMENT, nPTG, nView);
      _DisplayPowerGreenOrRed(MD_PR_RNRA, MD_PRS_RNRA, oPC, sID, sFaction, FACTION_MANAGEMENT, nPTG, nView);
      _DisplayPowerGreenOrRed(MD_PR_RNR, MD_PRS_RNR, oPC, sID, sFaction, FACTION_MANAGEMENT, nPTG, nView);
      _DisplayPowerGreenOrRed(MD_PR_ADR, MD_PRS_ADR, oPC, sID, sFaction, FACTION_MANAGEMENT, nPTG, nView);
      _DisplayPowerGreenOrRed(MD_PR_RMR, MD_PRS_RMR, oPC, sID, sFaction, FACTION_MANAGEMENT, nPTG, nView);
      _DisplayPowerGreenOrRed(MD_PR_GPM, MD_PRS_GPM, oPC, sID, sFaction, FACTION_MANAGEMENT, nPTG, nView);
      _DisplayPowerGreenOrRed(MD_PR_GPR, MD_PRS_GPR, oPC, sID, sFaction, FACTION_MANAGEMENT, nPTG, nView);
      _DisplayPowerGreenOrRed(MD_PR_CHR, MD_PRS_CHR, oPC, sID, sFaction, FACTION_MANAGEMENT, nPTG, nView);
      _DisplayPowerGreenOrRed(MD_PR_REC, MD_PRS_REC, oPC, sID, sFaction, FACTION_MANAGEMENT, nPTG, nView);
      _DisplayPowerGreenOrRed(MD_PR_RMM, MD_PRS_RMM, oPC, sID, sFaction, FACTION_MANAGEMENT, nPTG, nView);
      _DisplayPowerGreenOrRed(MD_PR_IMM, MD_PRS_IMM, oPC, sID, sFaction, FACTION_MANAGEMENT, nPTG, nView);
      _DisplayPowerGreenOrRed(MD_PR_VPM, MD_PRS_VPM, oPC, sID, sFaction, FACTION_MANAGEMENT, nPTG, nView);
      _DisplayPowerGreenOrRed(MD_PR_VPR, MD_PRS_VPR, oPC, sID, sFaction, FACTION_MANAGEMENT, nPTG, nView);
      //OOC power, Don't show for nation conversation
      if(sScript == FACTION_SCRIPT)
        _DisplayPowerGreenOrRed(MD_PR_REF, MD_PRS_REF, oPC, sID, sFaction, FACTION_MANAGEMENT, nPTG, nView);
    }

    if(sPage == "ALL" || sPage == BANK_POWERS)
    {
      dlgClearResponseList(BANK_POWERS);
      _DisplayPowerGreenOrRed(MD_PR_CKB, MD_PRS_CKB, oPC, sID, sFaction, BANK_POWERS, nPTG, nView);
      _DisplayPowerGreenOrRed(MD_PR_WDG, MD_PRS_WDG, oPC, sID, sFaction, BANK_POWERS, nPTG, nView);
      _DisplayPowerGreenOrRed(MD_PR_GSL, MD_PRS_GSL, oPC, sID, sFaction, BANK_POWERS, nPTG, nView);
      _DisplayPowerGreenOrRed(MD_PR_VMS, MD_PRS_VMS, oPC, sID, sFaction, BANK_POWERS, nPTG, nView);
      _DisplayPowerGreenOrRed(MD_PR_VMD, MD_PRS_VMD, oPC, sID, sFaction, BANK_POWERS, nPTG, nView);
      _DisplayPowerGreenOrRed(MD_PR_VOD, MD_PRS_VOD, oPC, sID, sFaction, BANK_POWERS, nPTG, nView);

      _DisplayPowerGreenOrRed(MD_PR2_VOS, MD_PRS_VOS, oPC, sID, sFaction, BANK_POWERS, nPTG, nView, "2");
      _DisplayPowerGreenOrRed(MD_PR2_VAS, MD_PRS_VAS, oPC, sID, sFaction, BANK_POWERS, nPTG, nView, "2");
      _DisplayPowerGreenOrRed(MD_PR2_VAD, MD_PRS_VAD, oPC, sID, sFaction, BANK_POWERS, nPTG, nView, "2");
      _DisplayPowerGreenOrRed(MD_PR2_SOS, MD_PRS_SOS, oPC, sID, sFaction, BANK_POWERS, nPTG, nView, "2");
      _DisplayPowerGreenOrRed(MD_PR2_AOS, MD_PRS_AOS, oPC, sID, sFaction, BANK_POWERS, nPTG, nView, "2");
      _DisplayPowerGreenOrRed(MD_PR2_ROD, MD_PRS_ROD, oPC, sID, sFaction, BANK_POWERS, nPTG, nView, "2");
      _DisplayPowerGreenOrRed(MD_PR2_ROS, MD_PRS_ROS, oPC, sID, sFaction, BANK_POWERS, nPTG, nView, "2");


      if(sScript != FACTION_SCRIPT && GetFactionType(sFaction) != FAC_BROKER)
      {
        _DisplayPowerGreenOrRed(MD_PR_VRS, MD_PRS_VRS, oPC, sID, sFaction, BANK_POWERS, nPTG, nView);
        _DisplayPowerGreenOrRed(MD_PR_VRD, MD_PRS_VRD, oPC, sID, sFaction, BANK_POWERS, nPTG, nView);
        _DisplayPowerGreenOrRed(MD_PR2_SRS, MD_PRS_SRS, oPC, sID, sFaction, BANK_POWERS, nPTG, nView, "2");
        _DisplayPowerGreenOrRed(MD_PR2_SRD, MD_PRS_SRD, oPC, sID, sFaction, BANK_POWERS, nPTG, nView, "2");
      }
    }

    if(sPage == "ALL" || sPage == FIXT_POWERS)
    {
      dlgClearResponseList(FIXT_POWERS);
      _DisplayPowerGreenOrRed(MD_PR_RNF, MD_PRS_RNF, oPC, sID, sFaction, FIXT_POWERS, nPTG, nView);
      _DisplayPowerGreenOrRed(MD_PR_TDM, MD_PRS_TDM, oPC, sID, sFaction, FIXT_POWERS, nPTG, nView);
    }
    //Only show for nation conversation
    if(sScript != FACTION_SCRIPT &&
      (sPage == "ALL" || sPage == SETTLEMENT_POWERS))
    {
      dlgClearResponseList(SETTLEMENT_POWERS);
      _DisplayPowerGreenOrRed(MD_PR2_EXL, MD_PRS_EXL, oPC, sID, sFaction, SETTLEMENT_POWERS, nPTG, nView, "2");
      _DisplayPowerGreenOrRed(MD_PR2_RME, MD_PRS_RME, oPC, sID, sFaction, SETTLEMENT_POWERS, nPTG, nView, "2");
      _DisplayPowerGreenOrRed(MD_PR2_RVH, MD_PRS_RVH, oPC, sID, sFaction, SETTLEMENT_POWERS, nPTG, nView, "2");
      _DisplayPowerGreenOrRed(MD_PR2_RVS, MD_PRS_RVS, oPC, sID, sFaction, SETTLEMENT_POWERS, nPTG, nView, "2");
      _DisplayPowerGreenOrRed(MD_PR2_CHT, MD_PRS_CHT, oPC, sID, sFaction, SETTLEMENT_POWERS, nPTG, nView, "2");
      _DisplayPowerGreenOrRed(MD_PR2_RSB, MD_PRS_RSB, oPC, sID, sFaction, SETTLEMENT_POWERS, nPTG, nView, "2");
      _DisplayPowerGreenOrRed(MD_PR2_SUT, MD_PRS_SUT, oPC, sID, sFaction, SETTLEMENT_POWERS, nPTG, nView, "2");
      _DisplayPowerGreenOrRed(MD_PR2_WAR, MD_PRS_WAR, oPC, sID, sFaction, SETTLEMENT_POWERS, nPTG, nView, "2");
      _DisplayPowerGreenOrRed(MD_PR2_LIC, MD_PRS_LIC, oPC, sID, sFaction, SETTLEMENT_POWERS, nPTG, nView, "2");
      _DisplayPowerGreenOrRed(MD_PR2_RVC, MD_PRS_RVC, oPC, sID, sFaction, SETTLEMENT_POWERS, nPTG, nView, "2");
      _DisplayPowerGreenOrRed(MD_PR2_LIE, MD_PRS_LIE, oPC, sID, sFaction, SETTLEMENT_POWERS, nPTG, nView, "2");
    }

    if(sPage == "ALL" || sPage == SHOP_POWERS)
    {
      dlgClearResponseList(SHOP_POWERS);
      _DisplayPowerGreenOrRed(MD_PR_SSF, MD_PRS_SSF, oPC, sID, sFaction, SHOP_POWERS, nPTG, nView);
      _DisplayPowerGreenOrRed(MD_PR_PIS, MD_PRS_PIS, oPC, sID, sFaction, SHOP_POWERS, nPTG, nView);
      _DisplayPowerGreenOrRed(MD_PR_RIS, MD_PRS_RIS, oPC, sID, sFaction, SHOP_POWERS, nPTG, nView);
      _DisplayPowerGreenOrRed(MD_PR2_SPR, MD_PRS_SPR, oPC, sID, sFaction, SHOP_POWERS, nPTG, nView, "2");
      _DisplayPowerGreenOrRed(MD_PR2_SCP, MD_PRS_SCP, oPC, sID, sFaction, SHOP_POWERS, nPTG, nView, "2");
      _DisplayPowerGreenOrRed(MD_PR2_SCI, MD_PRS_SCI, oPC, sID, sFaction, SHOP_POWERS, nPTG, nView, "2");
      _DisplayPowerGreenOrRed(MD_PR2_KEY, MD_PRS_KEY, oPC, sID, sFaction, SHOP_POWERS, nPTG, nView, "2");
      _DisplayPowerGreenOrRed(MD_PR2_CAP, MD_PRS_CAP, oPC, sID, sFaction, SHOP_POWERS, nPTG, nView, "2");
    }
  }
  else //Not called through the nation script and is a nation
  {
    //The ooc powers for nations
    if(sPage == "ALL" || sPage == FACTION_MANAGEMENT)
    {
      dlgClearResponseList(FACTION_MANAGEMENT);
      _DisplayPowerGreenOrRed(MD_PR_REF, MD_PRS_REF, oPC, sID, sFaction, FACTION_MANAGEMENT, nPTG, nView);
    }
  }

  //OOC powers, only show in -factions conversation
  if(sScript == FACTION_SCRIPT && (sPage == "ALL" || sPage == MESSAGE_POWERS))
  {
    dlgClearResponseList(MESSAGE_POWERS);
    _DisplayPowerGreenOrRed(MD_PR_VFM, MD_PRS_VFM, oPC, sID, sFaction, MESSAGE_POWERS, nPTG, nView);
    _DisplayPowerGreenOrRed(MD_PR_CFM, MD_PRS_CFM, oPC, sID, sFaction, MESSAGE_POWERS, nPTG, nView);
    _DisplayPowerGreenOrRed(MD_PR_RMS, MD_PRS_RMS, oPC, sID, sFaction, MESSAGE_POWERS, nPTG, nView);
    _DisplayPowerGreenOrRed(MD_PR_SAM, MD_PRS_SAM, oPC, sID, sFaction, MESSAGE_POWERS, nPTG, nView);
  }
}
///////////////////////////////////////////////////////////////////////////////////////
//Only runs for child factions, allows child factions to pass on settlement powers
void _SetUpPowerListST(object oPC, string sID, string sFaction, string sPage = "ALL")
{
  //Get if they have the power to give
  int nPTG;
  int nView;
  if(dlgGetPlayerDataString(VAR_MEMBER) == "")
  {
    nPTG = md_GetHasPowerMaster(MD_PR_GPR, oPC, sFaction, "1", TRUE);
    nView = md_GetHasPowerMaster(MD_PR_VPR, oPC, sFaction, "1", TRUE);
  }
  else
  {
    nPTG = md_GetHasPowerMaster(MD_PR_GPM, oPC, sFaction, "1", TRUE);
    nView = md_GetHasPowerMaster(MD_PR_VPM, oPC, sFaction, "1", TRUE);
  }
  //Faction management powers, only give power
  if(sPage == "ALL" || sPage == NATION_MANAGE)
  {
     dlgClearResponseList(NATION_MANAGE);
     _DisplayPowerGreenOrRed(MD_PR_GPM, MD_PRS_GPM, oPC, sID, sFaction, NATION_MANAGE, nPTG, nView, "1", TRUE);
     _DisplayPowerGreenOrRed(MD_PR_GPR, MD_PRS_GPR, oPC, sID, sFaction, NATION_MANAGE, nPTG, nView, "1", TRUE);
     _DisplayPowerGreenOrRed(MD_PR_VPM, MD_PRS_VPM, oPC, sID, sFaction, NATION_MANAGE, nPTG, nView, "1", TRUE);
     _DisplayPowerGreenOrRed(MD_PR_VPR, MD_PRS_VPR, oPC, sID, sFaction, NATION_MANAGE, nPTG, nView, "1", TRUE);
  }

  if(sPage == "ALL" || sPage == NATION_POWERS)
  {
    dlgClearResponseList(NATION_POWERS);
    _DisplayPowerGreenOrRed(MD_PR2_EXL, MD_PRS_EXL, oPC, sID, sFaction, NATION_POWERS, nPTG, nView, "2", TRUE);
    _DisplayPowerGreenOrRed(MD_PR2_RME, MD_PRS_RME, oPC, sID, sFaction, NATION_POWERS, nPTG, nView, "2", TRUE);
    _DisplayPowerGreenOrRed(MD_PR2_RVH, MD_PRS_RVH, oPC, sID, sFaction, NATION_POWERS, nPTG, nView, "2", TRUE);
    _DisplayPowerGreenOrRed(MD_PR2_RVS, MD_PRS_RVS, oPC, sID, sFaction, NATION_POWERS, nPTG, nView, "2", TRUE);
    _DisplayPowerGreenOrRed(MD_PR2_CHT, MD_PRS_CHT, oPC, sID, sFaction, NATION_POWERS, nPTG, nView, "2", TRUE);
    _DisplayPowerGreenOrRed(MD_PR2_RSB, MD_PRS_RSB, oPC, sID, sFaction, NATION_POWERS, nPTG, nView, "2", TRUE);
    _DisplayPowerGreenOrRed(MD_PR2_SUT, MD_PRS_SUT, oPC, sID, sFaction, NATION_POWERS, nPTG, nView, "2", TRUE);
    _DisplayPowerGreenOrRed(MD_PR2_WAR, MD_PRS_WAR, oPC, sID, sFaction, NATION_POWERS, nPTG, nView, "2", TRUE);
    _DisplayPowerGreenOrRed(MD_PR2_LIC, MD_PRS_LIC, oPC, sID, sFaction, NATION_POWERS, nPTG, nView, "2", TRUE);
    _DisplayPowerGreenOrRed(MD_PR2_RVC, MD_PRS_RVC, oPC, sID, sFaction, NATION_POWERS, nPTG, nView, "2", TRUE);
    _DisplayPowerGreenOrRed(MD_PR2_LIE, MD_PRS_LIE, oPC, sID, sFaction, NATION_POWERS, nPTG, nView, "2", TRUE);
  }

  if(sPage == "ALL" || sPage == NATION_BANK)
  {
    dlgClearResponseList(NATION_BANK);
    _DisplayPowerGreenOrRed(MD_PR_CKB, MD_PRS_CKB, oPC, sID, sFaction, NATION_BANK, nPTG, nView, "1", TRUE);
    _DisplayPowerGreenOrRed(MD_PR_WDG, MD_PRS_WDG, oPC, sID, sFaction, NATION_BANK, nPTG, nView, "1", TRUE);
   // _DisplayPowerGreenOrRed(MD_PR_GSL, MD_PRS_GSL, oPC, sID, sFaction, NATION_BANK, nPTG, nView, "1", TRUE);
  }

  if(sPage == "ALL" || sPage == NAT_FIXTURE)
  {
    dlgClearResponseList(NAT_FIXTURE);
    _DisplayPowerGreenOrRed(MD_PR_RNF, MD_PRS_RNF, oPC, sID, sFaction, NAT_FIXTURE, nPTG, nView, "1", TRUE);
    _DisplayPowerGreenOrRed(MD_PR_TDM, MD_PRS_TDM, oPC, sID, sFaction, NAT_FIXTURE, nPTG, nView, "1", TRUE);
  }

  if(sPage == "ALL" || sPage == NATION_SHOP)
  {
    dlgClearResponseList(NATION_SHOP);
    _DisplayPowerGreenOrRed(MD_PR_SSF, MD_PRS_SSF, oPC, sID, sFaction, NATION_SHOP, nPTG, nView, "1", TRUE);
    _DisplayPowerGreenOrRed(MD_PR_PIS, MD_PRS_PIS, oPC, sID, sFaction, NATION_SHOP, nPTG, nView, "1", TRUE);
    _DisplayPowerGreenOrRed(MD_PR_RIS, MD_PRS_RIS, oPC, sID, sFaction, NATION_SHOP, nPTG, nView, "1", TRUE);
    _DisplayPowerGreenOrRed(MD_PR2_SPR, MD_PRS_SPR, oPC, sID, sFaction, NATION_SHOP, nPTG, nView, "2", TRUE);
    _DisplayPowerGreenOrRed(MD_PR2_SCP, MD_PRS_SCP, oPC, sID, sFaction, NATION_SHOP, nPTG, nView, "2", TRUE);
    _DisplayPowerGreenOrRed(MD_PR2_SCI, MD_PRS_SCI, oPC, sID, sFaction, NATION_SHOP, nPTG, nView, "2", TRUE);
    _DisplayPowerGreenOrRed(MD_PR2_KEY, MD_PRS_KEY, oPC, sID, sFaction, NATION_SHOP, nPTG, nView, "2", TRUE);
    _DisplayPowerGreenOrRed(MD_PR2_CAP, MD_PRS_CAP, oPC, sID, sFaction, NATION_SHOP, nPTG, nView, "2", TRUE);
  }
}
///////////////////////////////////////////////////////////////////////
//Toggle, returns TRUE if the ability is on after toggle.
//Turns off/on the ability depending on the flag.
int _ToggleAbility(int nPower, string sID, string sFaction, string sList = "1", int nNation = FALSE)
{
  int nFlag = !md_GetHasPowerByID(nPower, sID, sFaction, sList, nNation);

  md_SetPower(nPower, sID, sFaction, nFlag, sList, nNation);

  return nFlag;
}
///////////////////////////////////////////////////////////
//Inits the member action reponses
void _ListMemberActions(string sFaction, object oPC)
{
  dlgClearResponseList(PAGE_MEMBER_ACTIONS);
  int nWrit = md_GetHasWrit(oPC, sFaction, MD_PR_RMM);
  if(nWrit == 1 || nWrit == 3 || (nWrit == 2 && md_GetHasPowerMaster(MD_PR_RMM, oPC, sFaction)))
    dlgAddResponse(PAGE_MEMBER_ACTIONS, _GetText(REMOVE_MEMBER));
  else if(!nWrit)
    SendMessageToPC(oPC, "You need a valid writ to remove a member.");
  if(md_GetHasPowerMaster(MD_PR_GPM, oPC, sFaction) || md_GetHasPowerMaster(MD_PR_VPM, oPC, sFaction))
    dlgAddResponse(PAGE_MEMBER_ACTIONS, _GetText(GIVE_POWERS));
  else if(md_GetHasPowerMaster(MD_PR_GPM, oPC, sFaction, "1", TRUE) || md_GetHasPowerMaster(MD_PR_VPM, oPC, sFaction, "1", TRUE))
    dlgAddResponse(PAGE_MEMBER_ACTIONS, SET_NATION);
  nWrit = md_GetHasWrit(oPC, sFaction, MD_PR_CHR);
  if(nWrit == 1 || nWrit == 3 || (nWrit == 2 && md_GetHasPowerMaster(MD_PR_CHR, oPC, sFaction)))
    dlgAddResponse(PAGE_MEMBER_ACTIONS, _GetText(CHANGE_RANK));
  else if(!nWrit)
    SendMessageToPC(oPC, "You need a valid writ to change the rank.");
  nWrit = md_GetHasWrit(oPC, sFaction, MD_PR_GSL);
  if(nWrit == 1 || nWrit == 3 || (nWrit == 2 && md_GetHasPowerMaster(MD_PR_GSL, oPC, sFaction)))
    dlgAddResponse(PAGE_MEMBER_ACTIONS, _GetText(SET_SALARY));
  else if(!nWrit)
    SendMessageToPC(oPC, "You need a valid writ to pay out salaries.");
}
void _ListRankActions(string sFaction, object oPC)
{
  int nWrit = md_GetHasWrit(oPC, sFaction, MD_PR_RMR);
  //Rank powers, this is here so I can get the Element count in onRanksS
  //Have to do it this way instead of using element count
  //because of rename ranks
  dlgClearResponseList(PAGE_RANK_ACTIONS);
  //Rename rank (specific) is added later
  if(nWrit == 1 || nWrit == 3 || (nWrit == 2 && md_GetHasPowerMaster(MD_PR_RMR, oPC, sFaction)))
    dlgAddResponse(PAGE_RANK_ACTIONS, _GetText(REMOVE_RANK));
  else if(!nWrit)
    SendMessageToPC(oPC, "Need a valid writ to remove a rank.");
  if(md_GetHasPowerMaster(MD_PR_GPR, oPC, sFaction) || md_GetHasPowerMaster(MD_PR_VPR, oPC, sFaction))
    dlgAddResponse(PAGE_RANK_ACTIONS, _GetText(GIVE_POWERS));
  else if(md_GetHasPowerMaster(MD_PR_GPR, oPC, sFaction, "1", TRUE) || md_GetHasPowerMaster(MD_PR_VPR, oPC, sFaction, "1", TRUE))
    dlgAddResponse(PAGE_RANK_ACTIONS, SET_NATION);
   //Only show for nation conversation
  if(GetLocalString(oPC, DLG_CURRENT_SCRIPT) != FACTION_SCRIPT)
  {
    nWrit = md_GetHasWrit(oPC, sFaction, MD_PR2_SRS, "2");
    if(nWrit == 1 || nWrit == 3 || (nWrit == 2 && md_GetHasPowerMaster(MD_PR2_SRS, oPC, sFaction, "2")))
      dlgAddResponse(PAGE_RANK_ACTIONS, _GetText(SET_SALARY));
    else if(!nWrit)
      SendMessageToPC(oPC, "Need a valid writ to give a rank a salary.");
    nWrit = md_GetHasWrit(oPC, sFaction, MD_PR2_SRD, "2");
    if(nWrit == 1 || nWrit == 3 || (nWrit == 2 && md_GetHasPowerMaster(MD_PR2_SRD, oPC, sFaction, "2")))
      dlgAddResponse(PAGE_RANK_ACTIONS, _GetText(SET_DUE));
    else if(!nWrit)
      SendMessageToPC(oPC, "Need a valid writ to give a rank a due.");
  }
  //Rename rank must be at the bottom of the list
  if(md_GetHasPowerMaster(MD_PR_RNRA, oPC, sFaction))
    dlgAddResponse(PAGE_RANK_ACTIONS, _GetText(RENAME_RANK));
}
/////////////////////////////////////////////////////////////\
//Error messages for when ranks/factions fail to create
void _ErrorMessages(object oPC, int nError)
{
  if (nError == 3)
  {
    SendMessageToPC(oPC, "You must enter a name before pressing add.");
  }
  else if (nError == 0)
  {
    SendMessageToPC(oPC, "Created successfully.");
  }
  else if (nError == 1)
  {
    SendMessageToPC(oPC, "Can not be created due to prior existance");
    // Replay current page.
  }
  else if (nError == 2)
  {
    SendMessageToPC(oPC, "That name was too long.  50 characters max.");
      // Replay current page.
  }
  else if(nError == 4)
  {
    SendMessageToPC(oPC, "Rank names cannot be purely numeric.");
  }

}
////////////////////////////////////////////////////////////
int _CreateFaction(object oPC, string sFaction, object oTarget, string sPrefix = "", string sNation = "", int nType=0)
{
  int nFaction = fbFACreateFaction(sFaction, oTarget, sPrefix, sNation, nType);
  _ErrorMessages(oPC, nFaction);
  return nFaction;
}
/////////////////////////////////////////////////////////////////////
//Refresh messages
void _RefreshMessages(string sFaction, object oPC)
{

  dlgClearResponseList(PAGE_MESSAGES);
  dlgClearResponseList(LIST_IDS);
  //First response is create message
  if(md_GetHasPowerMaster(MD_PR_CFM, oPC, sFaction))
  {
    dlgAddResponseAction(PAGE_MESSAGES, CREATE_MESSAGE);
    dlgSetPlayerDataInt(VAR_CREATE, 1);
  }
  int nCount;
  string sMsg;
  for(nCount = fbFAGetMessageCount(sFaction); nCount > 0; nCount--)
  {
    sMsg = fbFAGetMessageByID(sFaction, nCount, oPC);
    if(sMsg != "")
    {
      dlgAddResponseAction(PAGE_MESSAGES, sMsg, txtWhite);
      AddIntElement(nCount, LIST_IDS, oPC);
    }
  }

}
/////////////////////////////////////////////////////////////////////
void _NameList(string sAction, string sPage, string sList=PAGE_NAMES)
{
  dlgClearResponseList(sList);
  dlgClearResponseList(LIST_IDS);
  string sID;
  string sName;
  int nCount;
  int bExists;
  object oPC = dlgGetSpeakingPC();

  SQLExecStatement("SELECT id, name FROM gs_pc_data WHERE name LIKE ? " +
       "ORDER BY modified DESC LIMIT 10", "%" + chatGetLastMessage(oPC) + "%");

  // Parse results into LIST_NAMES & LIST_IDS.
  while (SQLFetch())
  {
     sID = SQLGetData(1);
     sName = SQLGetData(2);
     bExists = FALSE;

     for (nCount = 0; nCount < GetElementCount(sList, oPC); nCount++)
     {
       if (GetStringElement(nCount, sList, oPC) == sName) bExists = TRUE;
     }

     if (!bExists)
     {
       dlgAddResponse(sList, sName);
       dlgAddResponse(LIST_IDS, sID);
     }
  }

  if (GetElementCount(sList, oPC) == 0)
  {
    SendMessageToPC(oPC, "Player not found, please speak the character's name (or a few letters) before choosing an option.");
    return;
  }
  else if (GetElementCount(sList, oPC) == 1)
  {
    dlgSetPlayerDataString(VAR_MEMBER, GetStringElement(0, LIST_IDS, oPC));
    _ConfirmationSetupnHelper(sAction, sPage);
  }
  else
    dlgChangePage(sList);
}
/////////////////////////////////////////////////////////////////////
//End internal functions
///////////////////////////////////////////////////////////////
//OnInit functions
//////////////////////////////
string onMainPage()
{
  object oPC = dlgGetSpeakingPC();
  chatClearLastMessage(oPC);
  //_RefreshFactionList(oPC);
  if(GetElementCount(PAGE_MAIN, oPC) == 2) // Expose Create option only.
    return "You aren't a member of any factions.";
  else
    return "Select which faction you want to manage, or speak the name " +
           "of the faction you wish to create and press Add.";

}
////////////////////////////////////////////////////////////////
void onAction()
{

  object oPC = dlgGetSpeakingPC();
  string sFaction = dlgGetPlayerDataString(VAR_FACTION);

  //Doing it this way instead, should cut down processing
  if(!GetElementCount(PAGE_ACTION, oPC))
  {
    if(md_GetHasPowerMaster(MD_PR_VAM, oPC, sFaction))
      dlgAddResponse(PAGE_ACTION, _GetText(VIEW_MEMBERS));
    if(md_GetHasPowerMaster(MD_PR_VRK, oPC, sFaction))
      dlgAddResponse(PAGE_ACTION, _GetText(VIEW_RANKS));
    string sScript = GetLocalString(oPC, DLG_CURRENT_SCRIPT);
    //These ones don't show if the faction is a nation faction, except in the nation conversation
    string sNation = miCZGetName(md_GetFacNation(sFaction));
    if((fbFAGetFactionNameDatabaseID(sFaction) !=  sNation && md_GetFactionTime(sFaction) > 0 ) || sScript != FACTION_SCRIPT)
    {
      if(md_GetHasPowerMaster(MD_PR_REC, oPC, sFaction))
        dlgAddResponse(PAGE_ACTION, _GetText(ADD_MEMBER));
      if(md_GetHasPowerMaster(MD_PR_ADR, oPC, sFaction))
        dlgAddResponse(PAGE_ACTION, _GetText(CREATE_RANK));

      if(!GetElementCount(SALARIES_DUES, oPC))
      {
        int nWrit = md_GetHasWrit(oPC, sFaction, MD_PR2_AOS, "2");
        if(md_GetHasPowerMaster(MD_PR_VOD, oPC, sFaction))
          dlgAddResponse(SALARIES_DUES, _GetText(VIEW_OUT_DUES));
        if(md_GetHasPowerMaster(MD_PR2_VOS, oPC, sFaction, "2"))
          dlgAddResponse(SALARIES_DUES, _GetText(VIEW_OUT_SAL));
        if(nWrit == 1 || nWrit == 3 || (nWrit == 2 && md_GetHasPowerMaster(MD_PR2_AOS, oPC, sFaction, "2")))
          dlgAddResponse(SALARIES_DUES, _GetText(ADD_OUTSIDER));
        else if(!nWrit)
          SendMessageToPC(oPC, "You need a writ to pay out salaries through the nation's account");
      }

      if(GetElementCount(SALARIES_DUES, oPC))
        dlgAddResponse(PAGE_ACTION, _GetText(SALARIES_DUES));

    }
    if(sScript == FACTION_SCRIPT)
    {
      if(md_GetHasPowerMaster(MD_PR_VFM, oPC, sFaction))
      {
        _RefreshMessages(sFaction, oPC);

        if(GetElementCount(PAGE_MESSAGES, oPC))
          dlgAddResponse(PAGE_ACTION, MESSAGE);
      }

      if(md_GetHasPowerMaster(MD_PR_REF, oPC, sFaction))
        dlgAddResponse(PAGE_ACTION, REFRESH_FACTION);
    }
    //Disband faction if owner, leave faction if not.
    //Can not disband nation factions or child factions
    int nOwner = fbFAGetIsOwningRank(sFaction, oPC);
    string sFactionName = fbFAGetFactionNameDatabaseID(sFaction);
    if(sNation == ""  && nOwner)
      dlgAddResponse(PAGE_ACTION, DISBAND_FACTION);
    //Show in the nation conversation, but only if they have nnon owner rank
    //Show in the child faction, but only if they have non-owner rank
    //Show in all normal factions
    else if(!nOwner)
      dlgAddResponse(PAGE_ACTION, _GetText(LEAVE_FACTION));

  }

}
////////////////////////////////////////////////////////
void onMembers()
{

  string sFaction = dlgGetPlayerDataString(VAR_FACTION);
  object oPC = dlgGetSpeakingPC();
  md_dlgRecoverPageNumber();
  //Member Powers, this is here so I can get the element
  //count in onMembersS()
  if(!GetElementCount(PAGE_MEMBER_ACTIONS, oPC))
    _ListMemberActions(sFaction, oPC);

  if(!GetElementCount(PAGE_VIEW_MEMBERS, oPC))
    _RefreshMemberList(sFaction, oPC);


}
//////////////////////////////////////////////////////
int onRanks()
{

  object oPC = dlgGetSpeakingPC();
  int nRankChange = dlgGetPlayerDataString(VAR_PAGE) == PAGE_MEMBER_ACTIONS;
  string sFaction = dlgGetPlayerDataString(VAR_FACTION);


  if(!nRankChange)
  {
    dlgClearPlayerDataString(VAR_MEMBER);
    _ListRankActions(sFaction, oPC);
  }


  //Have to do this each time, different entry depending on
  //if they're changing ranks or not.
  _RefreshRankList(sFaction, oPC);

  //This page is also displayed when members are changing
  //ranks, this if handles the prompt
  return nRankChange;

}

/////////////////////////////////////////////////////////////////////////
void onGivePower()
{
  object oPC = dlgGetSpeakingPC();

  //Give powers will only have a list if one of it's sub-lists does
  if(!GetElementCount(PAGE_GIVE_POWERS, oPC))
  {
    string sID = dlgGetPlayerDataString(VAR_MEMBER);
    string sFaction = dlgGetPlayerDataString(VAR_FACTION);
    int nPower;
    if(sID != "")
      nPower = MD_PR_GPM;
    else
    {
       int nRank = dlgGetPlayerDataInt(VAR_RANK);
       if(nRank)
          sID = "R"+md_FAGetNthRankID(sFaction, nRank);
       else
          sID = "F";

       nPower = MD_PR_GPR;
    }

    _SetUpPowerList(oPC, sID, sFaction);

    if(GetElementCount(FACTION_MANAGEMENT, oPC))
      dlgAddResponse(PAGE_GIVE_POWERS, FACTION_MANAGEMENT);

    if(GetElementCount(MESSAGE_POWERS, oPC))
      dlgAddResponse(PAGE_GIVE_POWERS, MESSAGE_POWERS);

    if(GetElementCount(BANK_POWERS, oPC))
      dlgAddResponse(PAGE_GIVE_POWERS, BANK_POWERS);

    if(GetElementCount(SHOP_POWERS, oPC))
      dlgAddResponse(PAGE_GIVE_POWERS, SHOP_POWERS);

    if(GetElementCount(FIXT_POWERS, oPC))
      dlgAddResponse(PAGE_GIVE_POWERS, FIXT_POWERS);

    if(GetFactionType(sFaction) != FAC_BROKER)
    {
      if(GetElementCount(SETTLEMENT_POWERS, oPC))
        dlgAddResponse(PAGE_GIVE_POWERS, SETTLEMENT_POWERS);
      else if(md_GetHasPowerMaster(nPower, oPC, sFaction, "1", TRUE) && fbFAGetFactionNameDatabaseID(sFaction) != miCZGetName(md_GetFacNation(sFaction)) && md_GetFactionTime(sFaction) > 0)
        dlgAddResponse(PAGE_GIVE_POWERS, SET_NATION);
    }
  }


}
/////////////////////////////////////////////////////////////////////////
string onGiveNatPower()
{
  object oPC = dlgGetSpeakingPC();

  //Give powers will only have a list if one of it's sub-lists does
  //Nation manage must always have a list
  if(!GetElementCount(SET_NATION, oPC))
  {
    string sID = dlgGetPlayerDataString(VAR_MEMBER);
    string sFaction = dlgGetPlayerDataString(VAR_FACTION);
    if(sID == "")
    {
        int nRank = dlgGetPlayerDataInt(VAR_RANK);
        if(nRank)
          sID = "R"+md_FAGetNthRankID(sFaction, nRank);
        else
          sID = "F";
    }
    _SetUpPowerListST(oPC, sID, sFaction);

    if(GetElementCount(NATION_MANAGE, oPC))
      dlgAddResponse(SET_NATION, NATION_MANAGE);

    if(GetElementCount(NATION_BANK, oPC))
      dlgAddResponse(SET_NATION, NATION_BANK);

    if(GetElementCount(NATION_SHOP, oPC))
      dlgAddResponse(SET_NATION, NATION_SHOP);

    if(GetElementCount(NAT_FIXTURE, oPC))
      dlgAddResponse(SET_NATION, NAT_FIXTURE);

    if(GetElementCount(NATION_POWERS, oPC))
      dlgAddResponse(SET_NATION, NATION_POWERS);
  }

  return "Which powers would you like to give this individual for our nation?";
}
//////////////////////////////////////////////////////////////
string onViewFactionPay(string sPage, int nPayIN=TRUE)
{
  if(!GetElementCount(sPage, dlgGetSpeakingPC()))
  {

    if(nPayIN) //Place the add a faction to pay up top
      dlgAddResponseAction(sPage, "[Speak faction to pay due to, then select]");

    string idList = LIST_IDS+IntToString(nPayIN);
    dlgClearResponseList(idList);
    object oModule = GetModule();
    int nCount;
    string sID = fbFAGetPCID(dlgGetSpeakingPC());
    int nPay;
    string sFaction;
    int nNumFactions;
    int nTotalPay;
    //Now loop through the factions

    //Every Faction
    nNumFactions = GetLocalInt(oModule, "MD_FA_HIGHEST");
    for(nCount =  1; nCount <= nNumFactions; nCount++)
    {
      sFaction = GetLocalString(oModule, "MD_FA_DATABASEID_"+IntToString(nCount));
      nPay = md_GetFacPay(sID, sFaction);
      if(nPay > 0 && nPayIN)
      {
        nTotalPay += nPay;
        dlgAddResponse(sPage, fbFAGetFactionNameDatabaseID(sFaction) + " ("+IntToString(nPay)+")");
        dlgAddResponse(idList, sFaction);
      }
      else if(nPay < 0 && !nPayIN)
      {
        nPay *= -1;
        nTotalPay += nPay;
        dlgAddResponse(sPage, fbFAGetFactionNameDatabaseID(sFaction) + " ("+IntToString(nPay)+")");
        dlgAddResponse(idList, sFaction);
      }
    }
    dlgSetPlayerDataString(sPage, IntToString(nTotalPay));
  }
  if(nPayIN)
    return "Current viewing faction due list. Current due total: " + dlgGetPlayerDataString(PAGE_PAY_PER_LIST_D) +
           "\nTo change the due payment for a faction, speak the new due and click the faction.";
  else
    return "Currently viewing faction salary list. Current salary total: " + dlgGetPlayerDataString(PAGE_PAY_PER_LIST_S);
}
////////////////////////////////////////////////////////////////////////
string onFactionList()
{
  dlgClearResponseList(PAGE_FACTION_LIST);
  dlgClearResponseList(LIST_IDS);
  SQLExecStatement("SELECT id,name FROM md_fa_factions WHERE name like '%"+
                   SQLEncodeSpecialChars(chatGetLastMessage(dlgGetSpeakingPC())) +
                   "%' LIMIT 10");

  string sName;
  while(SQLFetch())
  {
    sName = SQLGetData(2);
    if(FindSubString(sName, SETTLEMENT_PREFIX) == 0)
      sName = GetStringRight(sName, GetStringLength(sName) - GetStringLength(SETTLEMENT_PREFIX));
    else if(FindSubString(sName, CHILD_PREFIX) == 0)
      sName = GetStringRight(sName, GetStringLength(sName) - GetStringLength(CHILD_PREFIX));

    dlgAddResponse(PAGE_FACTION_LIST, sName);
    dlgAddResponse(LIST_IDS, SQLGetData(1));
  }

  return "Select a faction to pay a due to:";
}
////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////
//End onInit functions
//////////////////////////////////////////////////
//Start onSelection Functions
///////////////////////////////////////////////
void onMainPageS()
{
  object oPC = dlgGetSpeakingPC();
  int nSelection = dlgGetSelectionIndex();
  int nCount = GetElementCount(PAGE_MAIN, oPC);
  if(nSelection ==  nCount - 1)
  {
    string sFaction = chatGetLastMessage(oPC);
    if(FindSubString(sFaction, SETTLEMENT_PREFIX) == 0 ||
       FindSubString(sFaction, CHILD_PREFIX) == 0)
      SendMessageToPC(oPC, "You cannot use that prefix.");
    else
    {
      int nFaction = _CreateFaction(oPC, sFaction, oPC);
      if(nFaction == 0)
      {
        dlgSetPlayerDataString(VAR_FACTION, GetLocalString(GetModule(), "MD_FA_"+sFaction));
        dlgChangePage(PAGE_ACTION);
      }
    }
  }
  else if(nSelection == nCount - 2)
    dlgChangePage(PAGE_PAY_PERSONAL);
  else
  {
    string sFaction = dlgGetSelectionName();
    sFaction = GetLocalString(GetModule(), "MD_FA_"+sFaction);
    //ByID used because it doesn't check for DMs
    if(fbFAGetIsOwningRankByID(sFaction, fbFAGetPCID(oPC)))
      md_UpdateFactionTimestamp(sFaction);

    dlgSetPlayerDataString(VAR_FACTION, sFaction);
    dlgChangePage(PAGE_ACTION);
  }
}
///////////////////////////////////////////////////////////////////////////
void onActionS()
{
  string sResponse = dlgGetSelectionName();
  if(sResponse == _GetText(ADD_MEMBER))
  {
    _NameList(ADD_MEMBER, PAGE_ACTION);
  }
  else if(sResponse == _GetText(CREATE_RANK))
  {
    dlgSetPlayerDataString(VAR_RANK, chatGetLastMessage(dlgGetSpeakingPC()));
    _ConfirmationSetupnHelper(CREATE_RANK, PAGE_ACTION);
  }
  else if(sResponse == _GetText(VIEW_MEMBERS))
    dlgChangePage(PAGE_VIEW_MEMBERS);
  else if(sResponse == _GetText(VIEW_RANKS))
    dlgChangePage(PAGE_VIEW_RANKS);
  else if(sResponse == _GetText(LEAVE_FACTION))
  {
    object oPC = dlgGetSpeakingPC();
    SQLExecStatement("SELECT r.pc_id FROM micz_rank AS r INNER JOIN md_fa_members AS m ON m.pc_id=r.pc_id AND r.fac_id=m.faction_id WHERE r.fac_id=? AND r.pc_id=?", dlgGetPlayerDataString(VAR_FACTION), gsPCGetPlayerID(oPC));
    if(SQLFetch())
    {
        SendMessageToPC(oPC, "You cannot leave a faction as leader of a settlement. If you wish to leave the settlement resign your leadership position.");
        return;
    }
    _ConfirmationSetupnHelper(LEAVE_FACTION, PAGE_ACTION);
  }
  else if(sResponse == DISBAND_FACTION)
  {
    SQLExecStatement("SELECT r.pc_id FROM micz_rank AS r INNER JOIN md_fa_members AS m ON r.fac_id=m.faction_id WHERE r.fac_id=?", dlgGetPlayerDataString(VAR_FACTION));
    if(SQLFetch())
    {
        SendMessageToPC(dlgGetSpeakingPC(), "You cannot disbane a faction tied to a settlement. If you wish to leave the settlement resign your leadership position.");
        return;
    }
    _ConfirmationSetupnHelper(DISBAND_FACTION, PAGE_ACTION);
  }
  else if(sResponse == MESSAGE)
    dlgChangePage(PAGE_MESSAGES);
  else if(sResponse == REFRESH_FACTION)
  {
    int nSuccess = md_faRefreshFaction(dlgGetPlayerDataString(VAR_FACTION));
    if(nSuccess)
      CleanPages();
    else
      SendMessageToPC(dlgGetSpeakingPC(), "The faction has been too recently refreshed.");
  }
  else if(sResponse == _GetText(SALARIES_DUES))
    dlgChangePage(SALARIES_DUES);
}
//////////////////////////////////////////////////////////////////
void onMembersS()
{
  object oPC = dlgGetSpeakingPC();

  int nSelection = dlgGetSelectionIndex() + 1;
  string sFaction = dlgGetPlayerDataString(VAR_FACTION);
  int nOwnerCount = md_FaOwnerCount(sFaction);
  string sID = GetStringElement(nSelection - 1, LIST_MEMBER_IDS, oPC);
  int nRank = fbFAGetRankByID(sFaction, sID);

  string sPCID = gsPCGetPlayerID(oPC);
  //Don't go to this page when selecting yourself in the faction script as a nation faction
  if((sPCID == sID || sPCID == fbFAGetNthOwnerID(sFaction, nSelection)) && (miCZGetName(md_GetFacNation(sFaction)) != fbFAGetFactionNameDatabaseID(sFaction) ||
      GetLocalString(oPC, DLG_CURRENT_SCRIPT) != FACTION_SCRIPT))
  {
    CleanPowerPages();
    dlgSetPlayerDataString(VAR_MEMBER, sID);
    md_dlgSavePageNumber();
    dlgChangePage(PAGE_SELF);        //catchers the rest of the owners
  }
  //Leaders can act against leaders
  else if(GetIsNationLeaderByIDFromCache(sID, sFaction) && GetIsNationLeaderByIDFromCache(gsPCGetPlayerID(dlgGetSpeakingPC()), sFaction))
  {
    dlgSetPlayerDataString(VAR_MEMBER, sID);
    CleanPowerPages();
    md_dlgSavePageNumber();
    dlgChangePage(PAGE_NATION_LEADER);
  }
  else if(nSelection <= nOwnerCount || fbFAGetIsOwningRankByID(sFaction, sID) && !GetIsNationLeaderByIDFromCache(sPCID, sFaction))
    SendMessageToPC(oPC, "You have selected an owner and have no permission to " +
                         "act modify him/her.");
  else if(!GetElementCount(PAGE_MEMBER_ACTIONS, oPC))
    SendMessageToPC(oPC, "You have no power to modify members");
  else if(nRank == 0 || nRank == FB_FA_OWNER_RANK || nRank == FB_FA_NON_MEMBER)
    SendMessageToPC(oPC, "The member has been removed (or promoted to owner) from the faction. This entry will be removed on reset.");
  else if((md_GetHasPowerByID(MD_PR_IMM, sID, sFaction) || md_GetHasPowerByID(MD_PR_IMM, "R"+IntToString(nRank), sFaction) ||
           md_GetHasPowerByID(MD_PR_IMM, "F", sFaction)) && !fbFAGetIsOwningRank(sFaction, oPC))
    SendMessageToPC(oPC, "This member can only be modified by owners.");
  else
  {
    dlgSetPlayerDataString(VAR_MEMBER, sID);
    CleanPowerPages();
    //Go directly to give powers for nations during the faction script
    //If you have the power to give powers~
    if(GetLocalString(oPC, DLG_CURRENT_SCRIPT) == FACTION_SCRIPT &&
       fbFAGetFactionNameDatabaseID(sFaction) == miCZGetName(md_GetFacNation(sFaction)))
    {
      if(md_GetHasPower(MD_PR_GPM, oPC, sFaction) || md_GetHasPowerMaster(MD_PR_VPM, oPC, sFaction))
      {
        dlgSetPlayerDataString(VAR_PAGE, PAGE_VIEW_MEMBERS);
        dlgChangePage(PAGE_GIVE_POWERS);
      }
      else
       SendMessageToPC(oPC, "You have no power to modify members");
    }
    else
    {
      md_dlgSavePageNumber();
      dlgChangePage(PAGE_MEMBER_ACTIONS);
    }
  }

}
/////////////////////////////////////////////////////////////
void onMembersAS(string sLPage=PAGE_MEMBER_ACTIONS)
{
  string sResponse = dlgGetSelectionName();


  //Get the last option, either leave or disband faction
  if(sResponse == _GetText(REMOVE_MEMBER))
  {

    SQLExecStatement("SELECT r.pc_id FROM micz_rank AS r INNER JOIN md_fa_members AS m ON m.pc_id=r.pc_id AND r.fac_id=m.faction_id WHERE r.fac_id=? AND r.pc_id=?", dlgGetPlayerDataString(VAR_FACTION), dlgGetPlayerDataString(VAR_MEMBER));
    if(SQLFetch())
    {
        SendMessageToPC(dlgGetSpeakingPC(), "You cannot remove a leader of a settlement. If you wish to remove this member replace them first through the settlement cordinator.");
        return;
    }
    _ConfirmationSetupnHelper(REMOVE_MEMBER, sLPage);
  }
  else if(sResponse == _GetText(CHANGE_RANK))
  {                                  //Don't change this one
    dlgSetPlayerDataString(VAR_PAGE, PAGE_MEMBER_ACTIONS);
    dlgChangePage(PAGE_VIEW_RANKS);
  }
  else if(sResponse == _GetText(GIVE_POWERS))
  {
    dlgSetPlayerDataString(VAR_PAGE, sLPage);
    dlgChangePage(PAGE_GIVE_POWERS);
  }
  else if(sResponse == SET_NATION)
  {
   dlgSetPlayerDataString(VAR_PAGE, sLPage);
   dlgChangePage(SET_NATION);
  }
  else if(sResponse == _GetText(SET_SALARY))
  {
    //Remove a writ if adjusting salary.
    //Placed down here because removing a member takes a writ
    //Only take it if this is the nation's conversation
    string sFaction = dlgGetPlayerDataString(VAR_FACTION);
    string sID =  dlgGetPlayerDataString(VAR_MEMBER);
    _TakeWrit(dlgGetSpeakingPC(), sFaction, MD_PR_GSL);
    md_SetFacPay(sID, sFaction, StringToInt(chatGetLastMessage(dlgGetSpeakingPC())));
    //To make sure the members refresh
    dlgClearResponseList(PAGE_VIEW_MEMBERS);
  }
}
////////////////////////////////////////////////////////////
void onConfirmationS()
{
  int nSelection = dlgGetSelectionIndex();
  string sAction = dlgGetPlayerDataString(VAR_ACTIONS);
  if(nSelection == 0) //Yes
  {
    string sFaction = dlgGetPlayerDataString(VAR_FACTION);
    object oPC = dlgGetSpeakingPC();

    if(sAction == REMOVE_MEMBER)
    {
       string sID = dlgGetPlayerDataString(VAR_MEMBER);
       SQLExecStatement("SELECT is_Noble FROM md_fa_members INNER JOIN md_fa_factions ON id=faction_id WHERE is_Noble=1 AND type=? AND faction_id=? AND pc_id=?", IntToString(FAC_NATION), sFaction, sID);
       if(SQLFetch())
       {
         SendMessageToPC(oPC, "Cannot remove nobles from main nation factions.");
         return;
       }
       _TakeWrit(oPC, sFaction, MD_PR_RMM);
       int nPay = md_GetFacPay(sID, sFaction);
       dlgClearResponseList(PAGE_VIEW_MEMBERS);
       if(nPay == 0)
       {
         fbFAChangeRankByID(sID, sFaction, 0);
         dlgChangePage(PAGE_VIEW_MEMBERS);
       }
       else if(nPay < 0) //salary
       {
         dlgClearResponseList(PAGE_OUT_SAL);
         //Demote to outsider regardless
         fbFAChangeRankByID(sID, sFaction,  FB_FA_NON_MEMBER);
         if(md_GetHasPowerMaster(MD_PR2_ROS, oPC, sFaction, "2"))
         {
           _ConfirmationSetupnHelper(REMOVE_OUTSIDER_SAL, PAGE_VIEW_MEMBERS);
           return; //so it doesn't delete above page
         }

       }
       else if(nPay > 0)
       {
         //Demote to outsider
         dlgClearResponseList(PAGE_OUT_DUES);
         fbFAChangeRankByID(sID, sFaction,  FB_FA_NON_MEMBER);
         if(md_GetHasPowerMaster(MD_PR2_ROD, oPC, sFaction, "2"))
         {
           _ConfirmationSetupnHelper(REMOVE_OUTSIDER_DUE, PAGE_VIEW_MEMBERS);
           return;
         }

       }

    }
    else if(sAction == CREATE_RANK)
    {
      string sRank = dlgGetPlayerDataString(VAR_RANK);
      int nRank = 0;
      int nTimestamp = 0;
      //For nations, create the faction
      if(GetLocalString(oPC, DLG_CURRENT_SCRIPT) != FACTION_SCRIPT && GetFactionType(sFaction) != FAC_BROKER)
      {
         //Special exceptions
         nRank = _RankErrors(sRank, sFaction);
         if(!nRank)
           nRank = _CreateFaction(oPC, sRank, OBJECT_INVALID, CHILD_PREFIX, fbFAGetFactionNameDatabaseID(sFaction), FAC_DIVISION);

         if(!nRank)
           nTimestamp = md_CreateTimestamp(MD_FA_FACTION_LIMIT);
      }
      if(nRank == 0)
        nRank = md_FaAddRank(sRank, sFaction, nTimestamp);

      _ErrorMessages(oPC, nRank);

      dlgChangePage(PAGE_ACTION);
    }
    else if(sAction == DISBAND_FACTION)
    {
      fbFARemoveFaction(sFaction);
      //Clean up variables and lists for next use
      ChangePageToMain();
    }
    else if(sAction == LEAVE_FACTION)
    {
      fbFAChangeRank(oPC, sFaction, 0);
      //CLean up variables and lists for next use
      ChangePageToMain();
    }
    else if(sAction == REMOVE_RANK)
    {
      int nRank = dlgGetPlayerDataInt(VAR_RANK);
      //Need to get srank now to remove faction of (if it happens)
      //It won't be there in a second.
      //Have to get the rank name before removing it
      //For nations, remove the faction
      if(GetLocalString(oPC, DLG_CURRENT_SCRIPT) != FACTION_SCRIPT && GetFactionType(sFaction) != FAC_BROKER)
      {
        string sRankName = md_FAGetRankName(sFaction, md_FAGetNthRankID(sFaction, nRank));
        fbFARemoveFaction(GetLocalString(GetModule(), "MD_FA_"+sRankName), CHILD_PREFIX);
      }
      int nSuccess = md_FaRemoveRank(nRank, sFaction);
      if(nSuccess)
      {
        dlgClearResponseList(PAGE_VIEW_MEMBERS);
        dlgChangePage(PAGE_VIEW_RANKS);

        _TakeWrit(oPC, sFaction, MD_PR_RMR);
      }
      else
      {
        SendMessageToPC(oPC, "You've tried to remove a reserved rank.");
        dlgChangePage(PAGE_RANK_ACTIONS);
      }
    }
    else if(sAction == ADD_MEMBER)
    {
      string sNewMember = dlgGetPlayerDataString(VAR_MEMBER);

      int nSuccess = fbFAAddMemberByID(sNewMember, sFaction);
      if(nSuccess)
      {
        dlgClearResponseList(PAGE_VIEW_MEMBERS);
        SendMessageToPC(oPC, "New member added successfully.");
      }
      else
        SendMessageToPC(oPC, "That character is already a member.");

      dlgChangePage(PAGE_ACTION);
    }
    else if(sAction == CREATE_MESSAGE)
    {
      int nSuccess = fbFACreateMessage(dlgGetPlayerDataString(VAR_MESSAGE), sFaction, oPC);
      if(nSuccess == 1)
        SendMessageToPC(oPC, "Cannot add blank string");
      else if(nSuccess == 2)
        SendMessageToPC(oPC, "Message to long.");
      else if(!nSuccess)
        _RefreshMessages(sFaction, oPC);

      dlgChangePage(PAGE_MESSAGES);
    }
    else if(sAction ==  ACTION_REMOVE_MES)
    {
      fbFARemoveMessage(sFaction, dlgGetPlayerDataInt(VAR_MESSAGE));
      _RefreshMessages(sFaction, oPC);
      dlgChangePage(PAGE_MESSAGES);
    }
    else if(sAction == REMOVE_OUTSIDER_SAL)
    {
      _TakeWrit(oPC, sFaction, MD_PR2_ROS, "2");
      fbFAChangeRankByID(dlgGetPlayerDataString(VAR_MEMBER), sFaction, 0);
      dlgChangePage(dlgGetPlayerDataString(VAR_PAGE));
    }
    else if(sAction == REMOVE_OUTSIDER_DUE)
    {
      fbFAChangeRankByID(dlgGetPlayerDataString(VAR_MEMBER), sFaction, 0);
      dlgChangePage(dlgGetPlayerDataString(VAR_PAGE));
    }
    else if(sAction == PAGE_SELF)
    {
      md_SetFacPay(fbFAGetPCID(oPC), sFaction, StringToInt(chatGetLastMessage(oPC)), MD_PR2_ROS, OBJECT_INVALID, TRUE);
      dlgClearResponseList(PAGE_VIEW_MEMBERS);
      dlgChangePage(PAGE_SELF);
    }
    else if(sAction == ADD_OUTSIDER)
    {
      dlgSetPlayerDataInt(VAR_PAY, StringToInt(chatGetLastMessage(oPC)));
      _ConfirmationSetupnHelper(ADD_OUTSIDER_PAY, SALARIES_DUES);
      return;
    }
    else if(sAction == ADD_OUTSIDER_PAY)
    {
      int nError = md_FA_AddOutsider(dlgGetPlayerDataString(VAR_MEMBER), sFaction, dlgGetPlayerDataInt(VAR_PAY), FALSE);
      if(nError == 1)
        SendMessageToPC(oPC, "Cannot add outsider with 0 pay");
      else if(nError == 2)
        SendMessageToPC(oPC, "That character is already a member");
      else if(nError == 0)
        _TakeWrit(oPC, sFaction, MD_PR2_AOS, "2");

      dlgClearResponseList(PAGE_OUT_SAL);
      dlgChangePage(SALARIES_DUES);
    }
    else if(sAction == SET_SALARY_D)
    {
      _TakeWrit(oPC, sFaction, MD_PR2_SOS, "2");
      md_SetFacPay(dlgGetPlayerDataString(VAR_MEMBER), sFaction, StringToInt(chatGetLastMessage(oPC)), MD_PR2_ROD, oPC);
      dlgClearResponseList(PAGE_OUT_DUES);
      dlgClearResponseList(PAGE_OUT_SAL);
      dlgChangePage(PAGE_OUT_DUES_ACT);
    }
    else if(sAction == SET_SALARY_S)
    {
      _TakeWrit(oPC, sFaction, MD_PR2_SOS, "2");
      md_SetFacPay(dlgGetPlayerDataString(VAR_MEMBER), sFaction, StringToInt(chatGetLastMessage(oPC)), MD_PR2_ROS, oPC);
      dlgClearResponseList(PAGE_OUT_SAL);
      dlgChangePage(PAGE_OUT_SAL_ACT);
    }
    else if(sAction == PAGE_PAY_PER_LIST_S)
    {
      md_SetFacPay(fbFAGetPCID(oPC), sFaction, StringToInt(chatGetLastMessage(oPC)), MD_PR2_ROS, OBJECT_INVALID, TRUE);
      dlgClearResponseList(PAGE_PAY_PER_LIST_S);
      dlgClearResponseList(PAGE_PAY_PER_LIST_D);
      dlgChangePage(PAGE_PAY_PER_LIST_S);
    }
    else if(sAction == PAGE_FACTION_LIST)
    {
      int nError = md_FA_AddOutsider(fbFAGetPCID(oPC), sFaction, StringToInt(chatGetLastMessage(oPC)), TRUE);
      if(nError == 2)
        md_SetFacPay(fbFAGetPCID(oPC), sFaction, StringToInt(chatGetLastMessage(oPC)), MD_PR2_ROS, OBJECT_INVALID, TRUE);

      dlgClearResponseList(PAGE_PAY_PER_LIST_D);
      dlgChangePage(PAGE_PAY_PER_LIST_D);
    }
    else if(sAction == MD_FA_OWNER_RANK)
    {
      fbFAChangeRankByID(dlgGetPlayerDataString(VAR_MEMBER), sFaction, FB_FA_OWNER_RANK);
      dlgSetPlayerDataString(VAR_PAGE, PAGE_MEMBER_ACTIONS);
      dlgClearResponseList(PAGE_VIEW_MEMBERS);
      dlgChangePage(PAGE_VIEW_RANKS);
      return;
    }

  }
  else if(sAction == MD_FA_OWNER_RANK)
  {
    dlgSetPlayerDataString(VAR_PAGE, PAGE_MEMBER_ACTIONS);
    dlgChangePage(PAGE_VIEW_RANKS);
    return;
  }
  else //no
    dlgChangePage(dlgGetPlayerDataString(VAR_PAGE));

  dlgClearPlayerDataString(VAR_PAGE);
}
//////////////////////////////////////////////////////
void onRanksS()
{
  object oPC = dlgGetSpeakingPC();
  int nIndex = dlgGetSelectionIndex();
  string sFaction = dlgGetPlayerDataString(VAR_FACTION);
  string sResponse = dlgGetSelectionName();

  //Perform the member rank change
  if(dlgGetPlayerDataString(VAR_PAGE) == PAGE_MEMBER_ACTIONS)
  {
    string sID = dlgGetPlayerDataString(VAR_MEMBER);
    int nRankID;
    int nRankCount = md_FaRankCount(sFaction);
    int nElementCount = GetElementCount(PAGE_VIEW_RANKS, oPC);
    if(sResponse == MD_FA_OWNER_RANK)
    {
      _ConfirmationSetupnHelper(MD_FA_OWNER_RANK, PAGE_VIEW_RANKS);
      return;
    }
    else if(sResponse == MD_FA_MEMBER_RANK)
      nRankID = FB_FA_MEMBER_RANK;
    else
      nRankID = StringToInt(md_FAGetNthRankID(sFaction, nIndex - (nElementCount - nRankCount - 1)));
    //Do not do anything if the character already
    //belongs to the rank, or the rank is an removed rank
    if(nRankID != fbFAGetRankByID(sFaction, sID) && sResponse != MD_FAC_RANK_REMOVED)
    {
      _TakeWrit(oPC, sFaction, MD_PR_CHR);
      fbFAChangeRankByID(sID, sFaction, nRankID);
      dlgClearResponseList(PAGE_VIEW_MEMBERS);
    }
  }
  else
  {
    string sRankID =  md_FAGetNthRankID(sFaction, nIndex);
    int nElementCount = GetElementCount(PAGE_RANK_ACTIONS, oPC);
    string sRenameRank = _GetText(RENAME_RANK);
    if(md_GetHasPowerMaster(MD_PR_RNR, oPC, sFaction)
       && StringToInt(sRankID) == fbFAGetRankByID(sFaction, fbFAGetPCID(oPC)) //get non-vassal or owner rank for this, if availble
       && GetStringElement(nElementCount-1, PAGE_RANK_ACTIONS, oPC) != sRenameRank)
       {
         nElementCount++;
         dlgAddResponse(PAGE_RANK_ACTIONS, sRenameRank);
       }

    //Have no power to modify the ranks AND do not have the ability to view members
    if(!nElementCount)
      SendMessageToPC(oPC, "You have no power to modify ranks");
    else if(sResponse == MD_FAC_RANK_REMOVED)
      SendMessageToPC(oPC, "That rank was removed and this entry will be removed on reset.");
    else if(((sResponse == MD_FA_MEMBER_RANK && md_GetHasPowerByID(MD_PR_IMM, "F", sFaction)) || md_GetHasPowerByID(MD_PR_IMM, "R"+sRankID, sFaction)) && !fbFAGetIsOwningRank(sFaction, oPC))
      SendMessageToPC(oPC, "You must be an owner to modify that rank");
    else
    {
      dlgSetPlayerDataInt(VAR_RANK, nIndex);
      CleanPowerPages();
      if((GetLocalString(oPC, DLG_CURRENT_SCRIPT) == FACTION_SCRIPT &&
         fbFAGetFactionNameDatabaseID(sFaction) == miCZGetName(md_GetFacNation(sFaction))) || sResponse == MD_FA_MEMBER_RANK)
      {
        if(md_GetHasPower(MD_PR_GPR, oPC, sFaction) || md_GetHasPowerMaster(MD_PR_VPR, oPC, sFaction))
        {
          dlgSetPlayerDataString(VAR_PAGE, PAGE_VIEW_RANKS);
          dlgChangePage(PAGE_GIVE_POWERS);
        }
        else if(md_GetHasPower(MD_PR_GPR, oPC, sFaction, "1", TRUE) || md_GetHasPowerMaster(MD_PR_VPR, oPC, sFaction, "1", TRUE))
        {
          dlgSetPlayerDataString(VAR_PAGE, PAGE_VIEW_RANKS);
          dlgChangePage(SET_NATION);
        }
        else
          SendMessageToPC(oPC, "You have no power to modify ranks.");
      }
      else
        dlgChangePage(PAGE_RANK_ACTIONS);
    }
  }
}
//////////////////////////////////////////////////////////
//Verify's a writ, should only be used in the give power functions
//Returns the same values as md_GetHasWrit
int _VerifyWrit(object oPC, string sFaction, int nPower, int nPower2, string sList = "1", int nNation=FALSE)
{
  //When used against a leader, require a writ ALWAYS
  object oWrit;
  string sLeader = dlgGetPlayerDataString(VAR_MEMBER);
  if(sLeader != "" && GetIsNationLeaderByIDFromCache(sLeader, sFaction))
  {
    //They don't have it
    oWrit = GetItemPossessedBy(oPC, "micz_writ_sgn");
    if(GetIsObjectValid(oWrit))
    {
      dlgClearResponseList(PAGE_MEMBER_ACTIONS);
      dlgClearResponseList(PAGE_RANK_ACTIONS);
      gsCMReduceItem(oWrit);
      return 3; //they have  a writ
    }
    else
      return 0; //they don't have a writ
  }
  string sNation2 = md_GetFacNation(sFaction);

  //Check to see if they have the power, if they have it continue through the script
  //to see if they have the other power
  int nWrit = md_GetHasWrit(oPC, sFaction, nPower, "1", nNation);
  if(nWrit == 3)
  {
    dlgClearResponseList(PAGE_MEMBER_ACTIONS);
    dlgClearResponseList(PAGE_RANK_ACTIONS);
    oWrit = GetItemPossessedBy(oPC, "micz_writ_sgn");
    gsCMReduceItem(oWrit);
  }
  if(nWrit != 1) return nWrit;
  string sID = gsPCGetPlayerID(oPC);
  //Check to see how many leaders, nations with 1 leader have no need for writs!
  string sNation = md_GetFacNation(sFaction);
  if(sNation != "")
  {
    if(GetLocalInt(miCZLoadNation(sNation), VAR_NUM_LEADERS) == 1)
      return 1;
    string sFName = fbFAGetFactionNameDatabaseID(sFaction);
    string sNName = miCZGetName(sNation);
    sNation = md_GetDatabaseID(sNName);
    //If doing stuff on the nation power list.. it doesn't matter
    if(sFName != sNName && sFName == md_FAGetRankName(sNation, IntToString(fbFAGetRankByID(sNation, sID))) && !nNation)
        return TRUE;
  }

  //Now check if they have the power from list 2, only nation leaders should of made it
  //this far
  if(md_GetHasPowerByID(nPower2, sID, sFaction, sList, nNation) ||
     md_GetHasPowerByID(nPower2, "F", sFaction, sList, nNation) ||
     md_GetHasPowerByID(nPower2, "R"+IntToString(fbFAGetRankByID(sFaction, sID)), sFaction, sList, nNation))
     return 1;

  //They don't have it
  oWrit = GetItemPossessedBy(oPC, "micz_writ_sgn");
  if(GetIsObjectValid(oWrit))
  {
    dlgClearResponseList(PAGE_MEMBER_ACTIONS);
    dlgClearResponseList(PAGE_RANK_ACTIONS);
    gsCMReduceItem(oWrit);
    return 3; //they have  a writ
  }
  else
    return 0; //they don't have a writ
}
//////////////////////////////////////////////////////////
//The only powers this gives for nations is give powers member and ranks
//If view members/ranks (normal) is removed the corresping give powers ((settlement) are also removed
void onFactionManagementS(int nNation = FALSE)
{
  string sResponse = dlgGetSelectionName();
  object oPC = dlgGetSpeakingPC();
  string sID = dlgGetPlayerDataString(VAR_MEMBER);
  string sFaction = dlgGetPlayerDataString(VAR_FACTION);
  int nPower = MD_PR_GPM;

  if(sID == "")
  {
    nPower = MD_PR_GPR;
    int nRank = dlgGetPlayerDataInt(VAR_RANK);
    if(nRank)
      sID = "R"+md_FAGetNthRankID(sFaction, nRank);
    else
      sID = "F";
  }



  int nTakeWrit = FALSE;
  int nFlag;
  if(sResponse == MD_PRS_VAM)
  {
    nFlag = _ToggleAbility(MD_PR_VAM, sID, sFaction, "1", nNation);

  /*  if(!nFlag)
    {
      //View members was removed, remove both the nation and the normal faction giving powers
      md_SetPower(MD_PR_GPM, sID, sFaction, FALSE, "1", TRUE);
      md_SetPower(MD_PR_GPM, sID, sFaction, FALSE, "1", FALSE);
      md_SetPower(MD_PR_VPM, sID, sFaction, FALSE, "1", TRUE);
      md_SetPower(MD_PR_VPM, sID, sFaction, FALSE, "1", FALSE);
      md_SetPower(MD_PR_CHR | MD_PR_RMM | MD_PR_VMS | MD_PR_GSL | MD_PR_VMD
                  , sID, sFaction, FALSE, "1", nNation);
      if(!nNation) //Changes here can have an effect on the settlement power list
      {
        _SetUpPowerListST(oPC, sID, sFaction, NATION_MANAGE);
        _SetUpPowerList(oPC, sID, sFaction, BANK_POWERS);
      }
    }  */
  }
  else if(sResponse ==  MD_PRS_VRK)
  {
    nFlag = _ToggleAbility(MD_PR_VRK, sID, sFaction, "1", nNation);

   /* if(!nFlag)
    {
      //View ranks was removed, remove both the nation and the normal faction giving powers
      md_SetPower(MD_PR_GPR, sID, sFaction, FALSE, "1", TRUE);
      md_SetPower(MD_PR_GPR, sID, sFaction, FALSE, "1", FALSE);
      md_SetPower(MD_PR_VPR, sID, sFaction, FALSE, "1", TRUE);
      md_SetPower(MD_PR_VPR, sID, sFaction, FALSE, "1", FALSE);
      md_SetPower(MD_PR_CHR | MD_PR_RMR | MD_PR_RNR | MD_PR_RNRA |
                  MD_PR_VRS | MD_PR_VRD
                  , sID, sFaction, FALSE, "1", nNation);
      md_SetPower(MD_PR2_SRS | MD_PR2_SRD, sID, sFaction, FALSE, "2");
      if(!nNation) //Changes here can have an effect on the settlement power list
      {
        _SetUpPowerListST(oPC, sID, sFaction, NATION_MANAGE);
        _SetUpPowerList(oPC, sID, sFaction, BANK_POWERS);
      }
    } */
  }
  else if(sResponse == MD_PRS_RNRA)
  {
    nFlag = _ToggleAbility(MD_PR_RNRA, sID, sFaction, "1", nNation);

    if(nFlag)
      md_SetPower(MD_PR_VRK, sID, sFaction, TRUE, "1", nNation);
  }
  else if(sResponse == MD_PRS_RNR)
  {
    nFlag = _ToggleAbility(MD_PR_RNR, sID, sFaction, "1", nNation);

    if(nFlag)
      md_SetPower(MD_PR_VRK, sID, sFaction, TRUE, "1", nNation);
  }
  else if(sResponse == MD_PRS_ADR )
    _ToggleAbility(MD_PR_ADR, sID, sFaction, "1", nNation);
  else if(sResponse == MD_PRS_RMR)
  {
    nTakeWrit = _VerifyWrit(oPC, sFaction, nPower, MD_PR_RMR, "1", nNation);
    if(!nTakeWrit) return;
    nFlag = _ToggleAbility(MD_PR_RMR, sID, sFaction, "1", nNation);
    if(nFlag)
      md_SetPower(MD_PR_VRK, sID, sFaction, TRUE, "1", nNation);
  }
  else if(sResponse == MD_PRS_GPM )
  {
    nTakeWrit = _VerifyWrit(oPC, sFaction, nPower, MD_PR_GPM, "1", nNation);
    if(!nTakeWrit) return;
    nFlag = _ToggleAbility(MD_PR_GPM, sID, sFaction, "1", nNation);
    if(nFlag) //Always give normal version
      md_SetPower(MD_PR_VAM, sID, sFaction);

  }
  else if(sResponse == MD_PRS_GPR)
  {
    nTakeWrit = _VerifyWrit(oPC, sFaction, nPower, MD_PR_GPR, "1", nNation);
    if(!nTakeWrit) return;
    nFlag = _ToggleAbility(MD_PR_GPR, sID, sFaction, "1", nNation);
    if(nFlag)//Always give normal version
      md_SetPower(MD_PR_VRK, sID, sFaction);
  }
  else if(sResponse == MD_PRS_CHR)
  {
    nTakeWrit = _VerifyWrit(oPC, sFaction, nPower, MD_PR_CHR);
    if(!nTakeWrit) return;
    nFlag = _ToggleAbility(MD_PR_CHR, sID, sFaction, "1", nNation);
    if(nFlag)
    {
      md_SetPower(MD_PR_VRK | MD_PR_VAM, sID, sFaction, TRUE, "1", nNation);
    }
  }
  else if(sResponse == MD_PRS_REC)
    _ToggleAbility(MD_PR_REC, sID, sFaction, "1", nNation);
  else if(sResponse == MD_PRS_RMM)
  {
    nTakeWrit = _VerifyWrit(oPC, sFaction, nPower, MD_PR_RMM, "1", nNation);
    if(!nTakeWrit) return;
    nFlag = _ToggleAbility(MD_PR_RMM, sID, sFaction, "1", nNation);
    if(nFlag)
      md_SetPower(MD_PR_VAM, sID, sFaction, TRUE, "1", nNation);
  }
  else if(sResponse == MD_PRS_REF)
    _ToggleAbility(MD_PR_REF, sID, sFaction, "1", nNation);
  else if(sResponse == MD_PRS_IMM)
    _ToggleAbility(MD_PR_IMM, sID, sFaction, "1", nNation);
  else if(sResponse == MD_PRS_VPM)
  {
    nFlag = _ToggleAbility(MD_PR_VPM, sID, sFaction, "1", nNation);

    if(nFlag) //Always give normal version
      md_SetPower(MD_PR_VAM, sID, sFaction);
  }
  else if(sResponse == MD_PRS_VPR)
  {
    nFlag = _ToggleAbility(MD_PR_VPR, sID, sFaction, "1", nNation);

    if(nFlag) //Always give normal version
      md_SetPower(MD_PR_VRK, sID, sFaction);
  }

  //Powers changed, so reset the list
  if(nNation)
    _SetUpPowerListST(oPC, sID, sFaction, NATION_MANAGE);

  _SetUpPowerList(oPC, sID, sFaction, FACTION_MANAGEMENT);
}
//////////////////////////////////////////////////////////
void onRankAS()
{
  string sResponse = dlgGetSelectionName();
  //Clear the member, it will mess us up later~
  if(sResponse == _GetText(RENAME_RANK))
  {
    object oPC = dlgGetSpeakingPC();
    string sSpeak = chatGetLastMessage(oPC);
    int nRank = dlgGetPlayerDataInt(VAR_RANK);
    string sFaction = dlgGetPlayerDataString(VAR_FACTION);
    string sRankName = md_FAGetRankName(sFaction, md_FAGetNthRankID(sFaction, nRank));
    int nSuccess;
    //Handle the nation addition, have to rename the faction too
    if(GetLocalString(oPC, DLG_CURRENT_SCRIPT) != FACTION_SCRIPT && GetFactionType(sFaction) != FAC_BROKER)
    {
        //This likely will put quite a bit of strain
        //on the system, so stop executing if done recently
        int nTime = gsTIGetActualTimestamp();

        if(nTime < GetLocalInt(OBJECT_SELF, "MD_FAC_RENAMETL"))
        {
          SendMessageToPC(oPC, "You cannot perform that task. Try again in 60 seconds.");
          return;
        }
        nSuccess = _RankErrors(sSpeak, sFaction);
        if(!nSuccess)
        {
          nSuccess = md_FaRenameFaction(sSpeak, GetLocalString(GetModule(), "MD_FA_"+sRankName), CHILD_PREFIX);
          if(!nSuccess)
            SetLocalInt(OBJECT_SELF, "MD_FAC_RENAMETL", nTime + 60); //wait sixty seconds for another attempt
        }


    }
    if(!nSuccess)
      nSuccess = md_FaRenameRank(nRank, sFaction, sSpeak);

    _ErrorMessages(oPC, nSuccess);
  }
  else if(sResponse == _GetText(REMOVE_RANK))
    _ConfirmationSetupnHelper(REMOVE_RANK, PAGE_RANK_ACTIONS);
  else if(sResponse == _GetText(GIVE_POWERS))
  {
    dlgSetPlayerDataString(VAR_PAGE, PAGE_RANK_ACTIONS);
    dlgChangePage(PAGE_GIVE_POWERS);
  }
  else if(sResponse == SET_NATION)
  {
    dlgSetPlayerDataString(VAR_PAGE, PAGE_RANK_ACTIONS);
    dlgChangePage(SET_NATION);
  }
  else if(sResponse == _GetText(SET_SALARY))
  {
    string sFaction = dlgGetPlayerDataString(VAR_FACTION);
    _TakeWrit(dlgGetSpeakingPC(), sFaction, MD_PR2_SRS, "2");
    md_SetFacPay("R"+md_FAGetNthRankID(sFaction,dlgGetPlayerDataInt(VAR_RANK)), sFaction, StringToInt(chatGetLastMessage(dlgGetSpeakingPC())));
  }
  else if(sResponse == _GetText(SET_DUE))
  {
    string sFaction = dlgGetPlayerDataString(VAR_FACTION);
    _TakeWrit(dlgGetSpeakingPC(), sFaction, MD_PR2_SRD, "2");
    md_SetFacPay("R"+md_FAGetNthRankID(sFaction,dlgGetPlayerDataInt(VAR_RANK)), sFaction, StringToInt(chatGetLastMessage(dlgGetSpeakingPC())), MD_PR2_ROS, OBJECT_INVALID, TRUE);
  }

}
//////////////////////////////////////////////////////////
void onSettlementPowerS(int nNation = FALSE)
{
  string sResponse = dlgGetSelectionName();
  object oPC = dlgGetSpeakingPC();
  string sID = dlgGetPlayerDataString(VAR_MEMBER);
  string sFaction = dlgGetPlayerDataString(VAR_FACTION);
  int nPower = MD_PR_GPM;

  if(sID == "")
  {
    nPower = MD_PR_GPR;
    int nRank = dlgGetPlayerDataInt(VAR_RANK);
    if(nRank)
      sID = "R"+md_FAGetNthRankID(sFaction, nRank);
    else
      sID = "F";
  }

  int nTakeWrit = FALSE;
  int nFlag;

  if(sResponse == MD_PRS_LIC)
    _ToggleAbility(MD_PR2_LIC, sID, sFaction, "2", nNation);
  else if(sResponse == MD_PRS_LIE)
    _ToggleAbility(MD_PR2_LIE, sID, sFaction, "2", nNation);
  else if(sResponse == MD_PRS_EXL)
  {
    nTakeWrit = _VerifyWrit(oPC, sFaction, nPower, MD_PR2_EXL, "2", nNation);
    if(!nTakeWrit) return;
    _ToggleAbility(MD_PR2_EXL, sID, sFaction, "2", nNation);
  }
  else if(sResponse ==  MD_PRS_RME)
  {
    nTakeWrit = _VerifyWrit(oPC, sFaction, nPower, MD_PR2_RME, "2", nNation);
    if(!nTakeWrit) return;
    _ToggleAbility(MD_PR2_RME, sID, sFaction, "2", nNation);
  }
  else if(sResponse == MD_PRS_RVH)
  {
    nTakeWrit = _VerifyWrit(oPC, sFaction, nPower, MD_PR2_RVH, "2", nNation);
    if(!nTakeWrit) return;
    _ToggleAbility(MD_PR2_RVH, sID, sFaction, "2", nNation);
  }
  else if(sResponse == MD_PRS_RVS)
  {
    nTakeWrit = _VerifyWrit(oPC, sFaction, nPower, MD_PR2_RVS, "2", nNation);
    if(!nTakeWrit) return;
    _ToggleAbility(MD_PR2_RVS, sID, sFaction, "2", nNation);
  }
  else if(sResponse == MD_PRS_CHT)
  {
    nTakeWrit = _VerifyWrit(oPC, sFaction, nPower, MD_PR2_CHT, "2", nNation);
    if(!nTakeWrit) return;
    _ToggleAbility(MD_PR2_CHT, sID, sFaction, "2", nNation);
  }
  else if(sResponse == MD_PRS_RSB)
  {
    nTakeWrit = _VerifyWrit(oPC, sFaction, nPower, MD_PR2_RSB, "2", nNation);
    if(!nTakeWrit) return;
    _ToggleAbility(MD_PR2_RSB, sID, sFaction, "2", nNation);
  }
  else if(sResponse == MD_PRS_SUT)
  {
    nTakeWrit = _VerifyWrit(oPC, sFaction, nPower, MD_PR2_SUT, "2", nNation);
    if(!nTakeWrit) return;
    _ToggleAbility(MD_PR2_SUT, sID, sFaction, "2", nNation);
  }
  else if(sResponse == MD_PRS_WAR)
  {
    nTakeWrit = _VerifyWrit(oPC, sFaction, nPower, MD_PR2_WAR, "2", nNation);
    if(!nTakeWrit) return;
    _ToggleAbility(MD_PR2_WAR, sID, sFaction, "2", nNation);
  }
  else if(sResponse == MD_PRS_RVC)
  {
    nTakeWrit = _VerifyWrit(oPC, sFaction, nPower, MD_PR2_RVC, "2", nNation);
    if(!nTakeWrit) return;
    _ToggleAbility(MD_PR2_RVC, sID, sFaction, "2", nNation);
  }

  //Powers changed, so reset the list
  if(nNation)
    _SetUpPowerListST(oPC, sID, sFaction, NATION_POWERS);
  else
    _SetUpPowerList(oPC, sID, sFaction, SETTLEMENT_POWERS);
}
//////////////////////////////////////////////////////////
void onMessageS()
{
  string sResponse = dlgGetSelectionName();
  object oPC = dlgGetSpeakingPC();

  if(sResponse == CREATE_MESSAGE)
  {
    dlgSetPlayerDataString(VAR_MESSAGE, GetStringLeft(chatGetLastMessage(oPC), 400));
    _ConfirmationSetupnHelper(CREATE_MESSAGE, PAGE_MESSAGES);
  }
  else if(!md_GetHasPowerMaster(MD_PR_RMS, oPC, dlgGetPlayerDataString(VAR_FACTION)))
    SendMessageToPC(oPC, "You do not have the power to remove messages.");
  else
  {
    dlgSetPlayerDataString(VAR_MESSAGE, sResponse);
    dlgSetPlayerDataInt(VAR_MESSAGE, GetIntElement(dlgGetSelectionIndex() - dlgGetPlayerDataInt(VAR_CREATE), LIST_IDS, oPC));
    _ConfirmationSetupnHelper(ACTION_REMOVE_MES, PAGE_MESSAGES);
  }

}
//////////////////////////////////////////////////////////
void onMsgPS()
{
  string sResponse = dlgGetSelectionName();
  string sID = dlgGetPlayerDataString(VAR_MEMBER);
  string sFaction = dlgGetPlayerDataString(VAR_FACTION);
  if(sID == "")
  {
    int nRank = dlgGetPlayerDataInt(VAR_RANK);
    if(nRank)
      sID = "R"+md_FAGetNthRankID(sFaction, nRank);
    else
      sID = "F";
  }

  int nFlag;
  if(sResponse == MD_PRS_VFM)
  {
    nFlag = _ToggleAbility(MD_PR_VFM, sID, sFaction);

   /* if(!nFlag)
    {
      md_SetPower(MD_PR_CFM | MD_PR_RMS | MD_PR_SAM, sID, sFaction, FALSE);
    } */
  }
  else
  {
    if(sResponse ==  MD_PRS_CFM)
      nFlag = _ToggleAbility(MD_PR_CFM, sID, sFaction);
    else if(sResponse == MD_PRS_RMS)
      nFlag = _ToggleAbility(MD_PR_RMS, sID, sFaction);
    else if(sResponse == MD_PRS_SAM)
      nFlag = _ToggleAbility(MD_PR_SAM, sID, sFaction);

    if(nFlag)
       md_SetPower(MD_PR_VFM, sID, sFaction);
  }
  _SetUpPowerList(dlgGetSpeakingPC(), sID, sFaction, MESSAGE_POWERS);
}
//////////////////////////////////////////////////////////
void onBankPowerS(int nNation = FALSE)
{
  string sResponse = dlgGetSelectionName();
  string sID = dlgGetPlayerDataString(VAR_MEMBER);
  string sFaction = dlgGetPlayerDataString(VAR_FACTION);
  object oPC = dlgGetSpeakingPC();
  int nPower = MD_PR_GPM;

  if(sID == "")
  {
    nPower = MD_PR_GPR;
    int nRank = dlgGetPlayerDataInt(VAR_RANK);
    if(nRank)
      sID = "R"+md_FAGetNthRankID(sFaction, nRank);
    else
      sID = "F";
  }

  int nTakeWrit = FALSE;
  int nFlag;
  if(sResponse == MD_PRS_CKB)
  {
    nFlag = _ToggleAbility(MD_PR_CKB, sID, sFaction, "1", nNation);

   /* if(!nFlag)
      md_SetPower(MD_PR_WDG, sID, sFaction, FALSE, "1", nNation);*/
  }
  else if(sResponse ==  MD_PRS_GSL)
  {
    nTakeWrit = _VerifyWrit(oPC, sFaction, nPower, MD_PR_GSL, "1", nNation);
    if(!nTakeWrit) return;
    nFlag = _ToggleAbility(MD_PR_GSL, sID, sFaction, "1", nNation);
    if(nFlag)
    {
      md_SetPower(MD_PR_VAM | MD_PR_VMS, sID, sFaction);
      _SetUpPowerList(oPC, sID, sFaction, FACTION_MANAGEMENT);
    }
  }
  else if(sResponse == MD_PRS_WDG)
  {
    nTakeWrit = _VerifyWrit(oPC, sFaction, nPower, MD_PR_WDG, "1", nNation);
    if(!nTakeWrit) return;
    nFlag = _ToggleAbility(MD_PR_WDG, sID, sFaction, "1", nNation);

    if(nFlag)
      md_SetPower(MD_PR_CKB, sID, sFaction, TRUE, "1", nNation);
  }
  else if(sResponse == MD_PRS_VMS)
  {
    nFlag = _ToggleAbility(MD_PR_VMS, sID, sFaction, "1", nNation);

    if(nFlag)
    {
      md_SetPower(MD_PR_VAM, sID, sFaction);
      _SetUpPowerList(oPC, sID, sFaction, FACTION_MANAGEMENT);
    }
    /*else if(!nFlag)
    {
      md_SetPower(MD_PR_GSL, sID, sFaction, FALSE, "1", nNation);
    }*/
  }
  else if(sResponse == MD_PRS_VRS)
  {
    nFlag = _ToggleAbility(MD_PR_VRS, sID, sFaction, "1", nNation);
    if(nFlag)
    {
      md_SetPower(MD_PR_VRK, sID, sFaction);
      _SetUpPowerList(oPC, sID, sFaction, FACTION_MANAGEMENT);
    }
    /*if(!nFlag)
    {
       md_SetPower(MD_PR2_SRS, sID, sFaction, FALSE, "2");
    } */
  }
  else if(sResponse == MD_PRS_VMD)
  {
    nFlag = _ToggleAbility(MD_PR_VMD, sID, sFaction, "1", nNation);

    if(nFlag)
    {
      md_SetPower(MD_PR_VAM, sID, sFaction);
      _SetUpPowerList(oPC, sID, sFaction, FACTION_MANAGEMENT);
    }
  }
  else if(sResponse == MD_PRS_VRD)
  {
    nFlag = _ToggleAbility(MD_PR_VRD, sID, sFaction, "1", nNation);
    if(nFlag)
    {
      md_SetPower(MD_PR_VRK, sID, sFaction);
      _SetUpPowerList(oPC, sID, sFaction, FACTION_MANAGEMENT);
    }
   /* if(!nFlag)
    {
       md_SetPower(MD_PR2_SRD, sID, sFaction, FALSE, "2");
    }  */
  }
  else if(sResponse == MD_PRS_VOD)
  {
    nFlag = _ToggleAbility(MD_PR_VOD, sID, sFaction, "1", nNation);
    if(!nFlag)
    {
      md_SetPower(MD_PR2_VAD | MD_PR2_ROD, sID, sFaction, FALSE, "2", nNation);
    }
  }
  else if(sResponse == MD_PRS_VOS)
  {
    nFlag = _ToggleAbility(MD_PR2_VOS, sID, sFaction, "2", nNation);
   /* if(!nFlag)
    {
      md_SetPower(MD_PR2_VAS | MD_PR2_ROS | MD_PR2_AOS | MD_PR2_SOS, sID, sFaction, FALSE, "2", nNation);
    } */
  }
  else if(sResponse == MD_PRS_VAS)
  {
    nFlag = _ToggleAbility(MD_PR2_VAS, sID, sFaction, "2", nNation);
    if(nFlag)
      md_SetPower(MD_PR2_VOS, sID, sFaction, TRUE, "2", nNation);

   /* if(!nFlag)
    {
      md_SetPower(MD_PR2_SOS | MD_PR2_AOS, sID, sFaction, FALSE, "2", nNation);
    } */
  }
  else if(sResponse == MD_PRS_VAD)
  {
    nFlag = _ToggleAbility(MD_PR2_VAD, sID, sFaction, "2", nNation);
    if(nFlag)
      md_SetPower(MD_PR_VOD, sID, sFaction, TRUE, "1", nNation);
  }
  else if(sResponse == MD_PRS_SOS)
  {
    nTakeWrit = _VerifyWrit(oPC, sFaction, nPower, MD_PR2_SOS, "2", nNation);
    if(!nTakeWrit) return;
    nFlag = _ToggleAbility(MD_PR2_SOS, sID, sFaction, "2", nNation);
    if(nFlag)
    {
      md_SetPower(MD_PR2_VOS | MD_PR2_VAS, sID, sFaction, TRUE, "2", nNation);
    }
   /* if(!nFlag)
      md_SetPower(MD_PR2_AOS, sID, sFaction, FALSE, "2", nNation);*/
  }
  else if(sResponse == MD_PRS_AOS)
  {
    nTakeWrit = _VerifyWrit(oPC, sFaction, nPower, MD_PR2_AOS, "2", nNation);
    if(!nTakeWrit) return;
    nFlag = _ToggleAbility(MD_PR2_AOS, sID, sFaction, "2", nNation);

    if(nFlag)
    {
      md_SetPower(MD_PR2_VOS | MD_PR2_VAS | MD_PR2_SOS, sID, sFaction, TRUE, "2", nNation);
    }
  }
  else if(sResponse == MD_PRS_ROD)
  {
    nFlag = _ToggleAbility(MD_PR2_ROD, sID, sFaction, "2", nNation);

    if(nFlag)
      md_SetPower(MD_PR_VOD, sID, sFaction, TRUE, "1", nNation);
  }
  else if(sResponse == MD_PRS_ROS)
  {
    nTakeWrit = _VerifyWrit(oPC, sFaction, nPower, MD_PR2_ROS, "2", nNation);
    if(!nTakeWrit) return;
    nFlag = _ToggleAbility(MD_PR2_ROS, sID, sFaction, "2", nNation);
    if(nFlag)
      md_SetPower(MD_PR2_VOS, sID, sFaction, TRUE, "2", nNation);

  }
  else if(sResponse == MD_PRS_SRS)
  {
    nTakeWrit = _VerifyWrit(oPC, sFaction, nPower, MD_PR2_SRS, "2", nNation);
    if(!nTakeWrit) return;
    nFlag = _ToggleAbility(MD_PR2_SRS, sID, sFaction, "2", nNation);
    if(nFlag)
    {
      md_SetPower(MD_PR_VRS, sID, sFaction, TRUE, "1", nNation);
      md_SetPower(MD_PR_VRK, sID, sFaction);
      _SetUpPowerList(oPC, sID, sFaction, FACTION_MANAGEMENT);
    }
  }
  else if(sResponse == MD_PRS_SRD)
  {
    nTakeWrit = _VerifyWrit(oPC, sFaction, nPower, MD_PR2_SRD, "2", nNation);
    if(!nTakeWrit) return;
    nFlag = _ToggleAbility(MD_PR2_SRD, sID, sFaction, "2", nNation);
    if(nFlag)
    {
      md_SetPower(MD_PR_VRD, sID, sFaction, TRUE, "1", nNation);
      md_SetPower(MD_PR_VRK, sID, sFaction);
      _SetUpPowerList(oPC, sID, sFaction, FACTION_MANAGEMENT);
    }
  }

  if(nNation)
    _SetUpPowerListST(oPC, sID, sFaction, NATION_BANK);
  else
    _SetUpPowerList(oPC, sID, sFaction, BANK_POWERS);
}
//////////////////////////////////////////////////////////
void onSalDueS()
{
  string sResponse = dlgGetSelectionName();
  if(sResponse == _GetText(VIEW_OUT_DUES))
    dlgChangePage(PAGE_OUT_DUES);
  else if(sResponse == _GetText(VIEW_OUT_SAL))
    dlgChangePage(PAGE_OUT_SAL);
  else if(sResponse == _GetText(ADD_OUTSIDER))
    _NameList(ADD_OUTSIDER, SALARIES_DUES, PAGE_ADD_OUTSIDER);
}
//////////////////////////////////////////////////////////
void onOutsiderAS(string sPage, string sActionSal, string sActionRem)
{
  string sResponse = dlgGetSelectionName();
  dlgClearResponseList(sPage);
  if(sResponse == _GetText(REMOVE_OUTSIDER))
    _ConfirmationSetupnHelper(sActionRem, sPage);
  else if(sResponse == _GetText(SET_SALARY))
  {
    string sID = dlgGetPlayerDataString(VAR_MEMBER);
    string sFaction = dlgGetPlayerDataString(VAR_FACTION);
    int nPay = md_GetFacPay(sID, sFaction);
    if(nPay > 0) //paying a due
     _ConfirmationSetupnHelper(sActionSal, sPage);
    else
    {
      object oPC = dlgGetSpeakingPC();
      _TakeWrit(oPC, sFaction, MD_PR2_SOS, "2");
      md_SetFacPay(sID, sFaction, StringToInt(chatGetLastMessage(oPC)), MD_PR2_ROS, oPC);
    }
  }
}
//////////////////////////////////////////////////////////
void onFixtureS(int nNation=FALSE)
{
  string sResponse = dlgGetSelectionName();
  string sID = dlgGetPlayerDataString(VAR_MEMBER);
  string sFaction = dlgGetPlayerDataString(VAR_FACTION);
  object oPC = dlgGetSpeakingPC();
  if(sID == "")
  {
    int nRank = dlgGetPlayerDataInt(VAR_RANK);
    if(nRank)
      sID = "R"+md_FAGetNthRankID(sFaction, nRank);
    else
      sID = "F";
  }

  if(sResponse == MD_PRS_RNF)
    _ToggleAbility(MD_PR_RNF, sID, sFaction, "1", nNation);
  else if(sResponse == MD_PRS_TDM)
    _ToggleAbility(MD_PR_TDM, sID, sFaction, "1", nNation);

  if(nNation)
    _SetUpPowerListST(oPC, sID, sFaction, NAT_FIXTURE);
  else
    _SetUpPowerList(oPC, sID, sFaction, FIXT_POWERS);
}
//////////////////////////////////////////////////////////
void onShopS(int nNation=FALSE)
{
  string sResponse = dlgGetSelectionName();
  string sID = dlgGetPlayerDataString(VAR_MEMBER);
  string sFaction = dlgGetPlayerDataString(VAR_FACTION);
  object oPC = dlgGetSpeakingPC();
  if(sID == "")
  {
    int nRank = dlgGetPlayerDataInt(VAR_RANK);
    if(nRank)
      sID = "R"+md_FAGetNthRankID(sFaction, nRank);
    else
      sID = "F";
  }
  int nFlag = FALSE;
  if(sResponse == MD_PRS_SSF)
    _ToggleAbility(MD_PR_SSF, sID, sFaction, "1", nNation);
  else if(sResponse == MD_PRS_PIS)
    nFlag = _ToggleAbility(MD_PR_PIS, sID, sFaction, "1", nNation);
  else if(sResponse == MD_PRS_RIS)
    nFlag = _ToggleAbility(MD_PR_RIS, sID, sFaction, "1", nNation);
  else if(sResponse == MD_PRS_SPR)
    nFlag = _ToggleAbility(MD_PR2_SPR, sID, sFaction, "2", nNation);
  else if(sResponse == MD_PRS_SCP)
    nFlag = _ToggleAbility(MD_PR2_SCP, sID, sFaction, "2", nNation);
  else if(sResponse == MD_PRS_SCI)
    nFlag = _ToggleAbility(MD_PR2_SCI, sID, sFaction, "2", nNation);
  else if(sResponse == MD_PRS_KEY)
    _ToggleAbility(MD_PR2_KEY, sID, sFaction, "2", nNation);
  else if(sResponse == MD_PRS_CAP)
    _ToggleAbility(MD_PR2_CAP, sID, sFaction, "2", nNation);

  if(nFlag)
    md_SetPower(MD_PR_SSF, sID, sFaction, TRUE, "1", nNation);

  if(nNation)
    _SetUpPowerListST(oPC, sID, sFaction, NATION_SHOP);
  else
    _SetUpPowerList(oPC, sID, sFaction, SHOP_POWERS);
}
