/*
  Name: zdlg_bank
  Author: Mithreas
  Description: Replaces gs_cfi_* to handle banks.

  - withdraw
   - enter amount
  - deposit
   - enter amount
  - transfer
   - enter name
    - select name
     - enter amount
  - leave


  Z-Dialog methods:
    AddStringElement - used to build up replies as a list.
    SetDlgPrompt - sets the NPC text to use
    SetDlgResponseList - sets the responses up
    S/GetDlgPageString - gets the current page
    GetPcDlgSpeaker = GetPCSpeaker
    GetDlgSelection - gets user selection (index of the response list)
*/
#include "inc_log"
#include "inc_zdlg"
#include "inc_finance"
#include "inc_house_check"
#include "inc_listener"
#include "inc_factions"

const string MAIN_MENU = "MAIN_BANK_MENU";
const string AMOUNT_MENU = "AMOUNT_BANK_MENU";
const string TRANSFER_MENU = "TRANSFER_BANK_MENU";
const string SELECT_MENU = "SELECT_BANK_MENU";
const string FACTION_MENU = "BANK_FAC_MENU";
const string FACTION_OPTIONS = "BANK_FAC_OPT";

const string MAIN_OPTIONS = "MAIN_BANK_OPTIONS";
const string NO_OPTIONS   = "NO_OPTIONS";
const string CONFIRM_OPTIONS = "CONFIRM_OPTIONS";
const string ACCOUNTS = "BANK_ACCOUNTS";
const string ACCOUNT_NAMES = "BANK_ACCOUNT_NAMES";

const string VAR_ID = "VAR_BANK_ID";
const string VAR_FACTION = "VAR_BANK_FAC";
const string VAR_ACTION = "VAR_BANK_ACTION";
const string VAR_ACCOUNT = "VAR_BANK_ACCOUNT";
const string VAR_ACCOUNT_NAME = "VAR_BANK_ACCOUNT_NAME";


void _RefreshFactionList(object oPC, int nStart = 1, int nEnd = 50)
{
  // Create list of factions for this PC here.  Cycle through factions and see
  // if PC is a member of any of them?
  object oModule = GetModule();
  int nNumFactions;
  int nCount;
  string sFaction;
  string sName;
  //Every faction
  nNumFactions = GetLocalInt(oModule, "MD_FA_HIGHEST");
  if(nEnd > nNumFactions)
    nEnd = nNumFactions;
  for(nCount = nStart; nCount <= nEnd; nCount++)
  {
    sFaction = GetLocalString(oModule, "MD_FA_DATABASEID_"+IntToString(nCount));
    sName = fbFAGetFactionNameDatabaseID(sFaction);
    if (md_GetHasPowerBank(MD_PR_CKB, oPC, sFaction) &&  sName != miCZGetName(md_GetFacNation(sFaction)))
    {
      AddStringElement(sName, FACTION_MENU); // DO NOT USE FORMATTING so we can map back to ID
    }
  }
  if(nCount <= nNumFactions)
    DelayCommand(0.1,  _RefreshFactionList(oPC, nEnd + 1, nEnd + 50));
  else //last page
    AddStringElement("<cþ  >[Back]</c>", FACTION_MENU);
}

void Init()
{
  object oPC = GetPcDlgSpeaker();
  string sID = GetLocalString(oPC, "BANK_OVERRIDE_ID");
  DeleteLocalString(oPC, "BANK_OVERRIDE_ID");

  if (sID == "") sID = gsPCGetPlayerID(oPC);
  
  SetLocalString(OBJECT_SELF, VAR_ID, sID);
  DeleteList(FACTION_MENU);
  DelayCommand(0.1, _RefreshFactionList(oPC));

  if (GetElementCount(CONFIRM_OPTIONS) == 0)
  {
    AddStringElement("<c þ >[Continue]</c>", CONFIRM_OPTIONS);
    AddStringElement("<cþ  >[Back]</c>", CONFIRM_OPTIONS);
  }

  //Nations have different responses
  if(GetStringLeft(sID, 1) == "N")
  {
    string sName = miCZGetName(GetStringRight(sID, GetStringLength(sID) - 1));
    SetLocalString(OBJECT_SELF, VAR_FACTION, sName);

    DeleteList(FACTION_OPTIONS);
    AddStringElement("<c þ >[Deposit]</c>", FACTION_OPTIONS);
    if(md_GetHasPowerSettlement(MD_PR_WDG, oPC, GetLocalString(GetModule(), "MD_FA_"+sName)))
    {
      AddStringElement("<c þ >[Withdraw]</c>", FACTION_OPTIONS);
      AddStringElement("<c þ >[Transfer]</c>", FACTION_OPTIONS);
    }
    AddStringElement("<cþ  >[Leave]</c>", FACTION_OPTIONS);
    SetDlgPageString(FACTION_OPTIONS);
  }
  else if (GetElementCount(MAIN_OPTIONS) == 0)
  {
    //Delete it now and create it if needed
    AddStringElement("<c þ >[Withdraw]</c>", MAIN_OPTIONS);
    AddStringElement("<c þ >[Deposit]</c>", MAIN_OPTIONS);
    AddStringElement("<c þ >[Transfer]</c>", MAIN_OPTIONS);
    AddStringElement("<c þ >[Factions]</c>", MAIN_OPTIONS);
    AddStringElement("<cþ  >[Leave]</c>", MAIN_OPTIONS);
    SetDlgPageString("");
  }
  
  if (GetElementCount(NO_OPTIONS) == 0)
  {
    AddStringElement("<cþ  >[Leave]</c>", NO_OPTIONS);
  }
}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();
  object oSelf = OBJECT_SELF;
  int nCurrentBalance = gsFIGetAccountBalance(GetLocalString(oSelf, VAR_ID));
  string sAction = GetLocalString(oSelf, VAR_ACTION);

  if (sPage == "")
  {
    // Check whether this banker is restricted to city factions.
    if (GetLocalInt(OBJECT_SELF, "city_factions_only"))
    {
	  SetDlgPrompt("You have no business here.  Kindly leave.\n\n" +
	  "<c þ >[Only city factions may use this bank.]</c>");
      SetDlgResponseList(NO_OPTIONS);
    }
  
    DeleteLocalString(oSelf, VAR_ACCOUNT);
    DeleteLocalString(oSelf, VAR_ACCOUNT_NAME);
    SetDlgPrompt("<c þ >[Current balance: " + IntToString(nCurrentBalance) +
     "]</c>\n\nYou can have a loan of up to 1000 gold from the bank.");
    SetDlgResponseList(MAIN_OPTIONS);
  }
  else if (sPage == AMOUNT_MENU)
  {
    string sDestName = GetLocalString(oSelf, VAR_ACCOUNT_NAME);
    SetDlgPrompt("<c þ >[Please speak the amount to " + sAction +
    " then press Continue to " + sAction + " it" +
    (sDestName == "" ? "" : " to " + sDestName) + "]</c>");
    SetDlgResponseList(CONFIRM_OPTIONS, oSelf);
  }
  else if (sPage == TRANSFER_MENU)
  {
    SetDlgPrompt("<c þ >[Please speak the name of the recipient.  They need " +
    "not be logged in, but you must spell the name correctly!  To pay into " +
    "a settlement's account, use its name (e.g. Cordor).]</c>");
    SetDlgResponseList(CONFIRM_OPTIONS, oSelf);
  }
  else if (sPage == SELECT_MENU)
  {
    SetDlgPrompt("<c þ >[Please select the recipient from the following list " +
     "(up to 10 results displayed; for more type in more of the name).]</c>");
    SetDlgResponseList(ACCOUNT_NAMES, oSelf);
  }
  else if(sPage == FACTION_MENU)
  {
    SetDlgPrompt("<c þ >[Please select a faction from the following list]</c>");
    //Initilize, don't do it again until conversation restarts
  //  if(!GetElementCount(FACTION_MENU))
    //  _RefreshFactionList(oPC);
    SetDlgResponseList(FACTION_MENU, oSelf);
  }
  else if(sPage == FACTION_OPTIONS)
  {
    SetDlgPrompt("<c þ >[Current balance in " + GetLocalString(oSelf, VAR_FACTION) + ": " + IntToString(nCurrentBalance) +
                 "]</c>\n\nYou can have a loan of up to 1000 gold from the bank.");

    SetDlgResponseList(FACTION_OPTIONS, oSelf);
  }
  else
  {
    SendMessageToPC(oPC, "You've found a bug. Oops! Please report it.");
  }
}

void HandleSelection()
{
  // This is the function that sets up the prompts for each page.
  string sPage   = GetDlgPageString();
  int nSelection = GetDlgSelection();
  object oSelf   = OBJECT_SELF;
  object oPC     = GetPcDlgSpeaker();
  string sID     = GetLocalString(oSelf, VAR_ID);
  int nCurrentBalance = gsFIGetAccountBalance(sID);
  string sAction = GetLocalString(oSelf, VAR_ACTION);

  if (sPage == "")
  {
    switch (nSelection)
    {
      case 0:
        SetLocalString(oSelf, VAR_ACTION, "withdraw");
        SetDlgPageString(AMOUNT_MENU);
        break;
      case 1:
        SetLocalString(oSelf, VAR_ACTION, "deposit");
        SetDlgPageString(AMOUNT_MENU);
        break;
      case 2:
        SetLocalString(oSelf, VAR_ACTION, "transfer");
        SetDlgPageString(TRANSFER_MENU);
        break;
      case 3:
        SetDlgPageString(FACTION_MENU);
        break;
      case 4:
        EndDlg();
        break;
    }
  }
  else if (sPage == AMOUNT_MENU)
  {
    string sAlt = GetStringLeft(sID, 1);
    if (nSelection)
    {
      //Going back to faction options
      if(sAlt == "F" || sAlt == "N")
        SetDlgPageString(FACTION_OPTIONS);
      else
        SetDlgPageString("");
      return;
    }

    int nAmount = StringToInt(gsLIGetLastMessage(oPC));

    if (sAction == "withdraw")
    {
      if (nAmount > (nCurrentBalance + 1000)) nAmount = nCurrentBalance + 1000;
      gsFIDraw(oPC, nAmount, sID);

      if(sAlt == "N")//remove a writ if it's the nation account
      {
        if(md_GetHasWrit(oPC, md_GetDatabaseID(miCZGetName(GetStringRight(sID, GetStringLength(sID) - 1))), MD_PR_WDG) == 3)
        {
          object oWrit = GetItemPossessedBy(oPC, "micz_writ_sgn");
          if (GetIsObjectValid(oWrit))
          {
            SpeakString("*takes a writ, checks it over, and removes it.*");
            gsCMReduceItem(oWrit);
          }
        }
      }
      else if(sAlt == "F")
      {
        if(md_GetHasWrit(oPC, GetStringRight(sID, GetStringLength(sID) - 1), MD_PR_WDG) == 3)
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
    else if (sAction == "deposit")
    {
      if (nAmount > GetGold(oPC)) nAmount = GetGold(oPC);
      gsFIPayIn(oPC, nAmount, sID);
    }
    else
    {
      //if (nAmount > GetGold(oPC)) nAmount = GetGold(oPC);
      string sAccount = GetLocalString(oSelf, VAR_ACCOUNT);
      // NB - the AssignCommand below means that the balance will be wrong in
      // the next (but only the next) viewing of the bank balance in this convo.
      AssignCommand(oPC, gsFITransferFromTo(sID, sAccount, nAmount));
    }

    if(sAlt == "F" || sAlt == "N")
      SetDlgPageString(FACTION_OPTIONS);
    else
      SetDlgPageString("");
    return;
  }
  else if (sPage == TRANSFER_MENU)
  {
    DeleteList(ACCOUNTS);
    DeleteList(ACCOUNT_NAMES);

    if (nSelection == 0)
    {
      string sSearch = "%" + gsLIGetLastMessage(oPC) + "%";

      string sName;
      string sMyKey = GetPCPublicCDKey(oPC);
      int nLimit    = 10;

      // Search for nations... but not the current one, if we're being a nation,
      // otherwise we get a nasty exploit.
      SQLExecStatement("SELECT id, name FROM micz_nations WHERE name LIKE ? AND id != ? LIMIT " +
        IntToString(nLimit), sSearch, (GetStringLeft(sID, 1) == "N") ?
        GetStringRight(sID, GetStringLength(sID) - 1) : "DUMMY");

      while (SQLFetch())
      {
        sName = SQLGetData(2);
        Trace(BANK, "Got matching nation: " + sName);

        AddStringElement("N" + SQLGetData(1), ACCOUNTS);
        AddStringElement("<c þ >[Settlement: " + sName + "]</c>", ACCOUNT_NAMES);
        nLimit--;
      }

      // Search for PCs, excluding those owned by the same CD key as oPC (to
      // prevent muling of gold).
      SQLExecStatement("SELECT id, name FROM gs_pc_data WHERE name LIKE ? AND keydata != ? LIMIT " +
        IntToString(nLimit), sSearch, GetLocalString(oPC, "CDKEY_ID"));

      while (SQLFetch())
      {
        sName = SQLGetData(2);
        Trace(BANK, "Got matching PC: " + sName);

        AddStringElement(SQLGetData(1), ACCOUNTS);
        AddStringElement("<c þ >[" + sName + "]</c>", ACCOUNT_NAMES);
        nLimit--;
      }

      SQLExecStatement("SELECT id,name FROM md_fa_factions WHERE name LIKE ? AND id != ? AND name NOT LIKE ? LIMIT " +
        IntToString(nLimit), sSearch, (GetStringLeft(sID, 1) == "F") ?
        GetStringRight(sID, GetStringLength(sID) - 1) : "DUMMY", SETTLEMENT_PREFIX+"%");

      while (SQLFetch())
      {
        sName = SQLGetData(2);
        Trace(BANK, "Got matching faction: " + sName);

        if(FindSubString(sName, CHILD_PREFIX) == 0)
          sName = GetStringRight(sName, GetStringLength(sName) - GetStringLength(CHILD_PREFIX));

        AddStringElement("F" + SQLGetData(1), ACCOUNTS);

        AddStringElement("<c þ >[Faction: " + sName + "]</c>", ACCOUNT_NAMES);

      }

      AddStringElement("<cþ  >[Back]</c>", ACCOUNT_NAMES);
      SetDlgPageString(SELECT_MENU);
    }
    else
    {
      string sAlt = GetStringLeft(sID, 1);
      if(sAlt == "F" || sAlt == "N")
        SetDlgPageString(FACTION_OPTIONS);
      else
        SetDlgPageString("");
    }
  }
  else if (sPage == SELECT_MENU)
  {
    // check for back option
    if (nSelection == GetElementCount(ACCOUNT_NAMES) - 1)
    {
      SetDlgPageString(TRANSFER_MENU);
    }
    else
    {
      string sID = GetStringElement(nSelection, ACCOUNTS);
      SetLocalString(oSelf, VAR_ACCOUNT, sID);
      SetLocalString(oSelf, VAR_ACCOUNT_NAME, gsPCGetPlayerName(sID));
      SetDlgPageString(AMOUNT_MENU);
    }
  }
  else if(sPage == FACTION_MENU)
  {
    //Back option
    if(nSelection + 1 == GetElementCount(FACTION_MENU, oSelf))
    {
      SetLocalString(oSelf, VAR_ID, gsPCGetPlayerID(oPC));
      SetDlgPageString("");
    }
    else
    {
      string sFaction = GetStringElement(nSelection, FACTION_MENU);
      SetLocalString(oSelf, VAR_FACTION, sFaction);
      sFaction = GetLocalString(GetModule(), "MD_FA_"+sFaction);
      SetLocalString(oSelf, VAR_ID, "F"+sFaction);

      DeleteList(FACTION_OPTIONS);
      AddStringElement("<c þ >[Deposit]</c>", FACTION_OPTIONS);
      if(md_GetHasPowerBank(MD_PR_WDG, oPC, sFaction))
      {
        md_UpdateFactionTimestamp(sFaction);
        AddStringElement("<c þ >[Withdraw]</c>", FACTION_OPTIONS);
        AddStringElement("<c þ >[Transfer]</c>", FACTION_OPTIONS);
      }
      AddStringElement("<cþ  >[Back]</c>", FACTION_OPTIONS);
      SetDlgPageString(FACTION_OPTIONS);
    }

  }
  else if(sPage == FACTION_OPTIONS)
  {
    //Back
    if(nSelection + 1 == GetElementCount(FACTION_OPTIONS, oSelf))
    {
      if(GetStringLeft(sID, 1) == "F")
        SetDlgPageString(FACTION_MENU);
      else
        EndDlg();
    }
    else
    {
      switch(nSelection)
      {
        case 0:
          SetLocalString(oSelf, VAR_ACTION, "deposit");
          SetDlgPageString(AMOUNT_MENU);
          break;
        case 1:
          SetLocalString(oSelf, VAR_ACTION, "withdraw");
          SetDlgPageString(AMOUNT_MENU);
          break;
        case 2:
          SetLocalString(oSelf, VAR_ACTION, "transfer");
          SetDlgPageString(TRANSFER_MENU);
          break;
      }
    }
  }
  else
  {
    SendMessageToPC(oPC, "You've found a bug. Oops! Please report it.");
  }
}

void main()
{
  // Don't change this method unless you understand Z-dialog.
  int nEvent = GetDlgEventType();
  Trace(ZDIALOG, "Called zdlg_bank with event... " + IntToString(nEvent));
  switch (nEvent)
  {
    case DLG_INIT:
      Init();
      break;
    case DLG_PAGE_INIT:
      PageInit();
      break;
    case DLG_SELECTION:
      HandleSelection();
      break;
    case DLG_ABORT:
    case DLG_END:
      break;
  }
}
