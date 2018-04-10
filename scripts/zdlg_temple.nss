/*
  Name: zdlg_temple
  Author: ActionReplay, Mith converted to Z-Dialog from Gigaschatten's legacy convo.
  Date: 08 Mars 2014
  Description: Modified version of Quarter management script for UD Temples. Uses Z-Dialog.

  Z-Dialog methods:
    AddStringElement - used to build up replies as a list.
    SetDlgPrompt - sets the NPC text to use
    SetDlgResponseList - sets the responses up
    S/GetDlgPageString - gets the current page
    GetPcDlgSpeaker = GetPCSpeaker
    GetDlgSelection - gets user selection (index of the response list)

  Tree:
  - Owner
   - Release
   - Manage security
    - Replace locks
    - Manage locks
     - Increase DC
     - Decrease DC
     - Reinforce door
     - Lighten door
    - Trap door
     - Increase DC
     - Decrease DC
     - Increase strength
     - Decrease strength
    - Create key
    - Make public
   - Manage quarter
    - Rename
   - Set for sale
   - Leave
  - Owned
   - Release
   - Take over
   - Leave
  - Unowned
   - Take over
   - Leave

  Future - footman, butler

  Quarter table definition - see gs_inc_quarter

  On init
  - if needed, load from db
  - check how much rent due, if >0
   - subtract from resource count
   - subtract from owner's bank account
   - due rent = 1/100 of value per game month
  - Sale price = 1/2 value

*/
#include "__server_config"
#include "gs_inc_listener"
#include "gs_inc_quarter"
#include "gs_inc_time"
#include "zdlg_include_i"
#include "mi_inc_factions"

//------------------------------------------------------------------------------
// Set up some constants to use for list and variable names.
//------------------------------------------------------------------------------

const string OWNER_MENU   = "owner_options";
const string SECURITY_PAGE = "security_page";
const string SECURITY_MENU = "security_menu";
const string LOCK_PAGE = "lock_page";
const string TRAP_PAGE = "trap_page";
const string LOCK_TRAP_MENU = "lock_trap_menu";
const string QUARTER_PAGE = "quarter_page";
const string QUARTER_MENU = "quarter_menu";
const string NON_OWNER_MENU  = "non_owner_menu";
const string BUY_QUARTER_PAGE = "buy_quarter_page";
const string CONFIRM_MENU = "confirm_menu";
const string ABANDON_PAGE = "abandon_page";
const string REPLACE_LOCKS_PAGE = "replace_locks_page";
const string FACTION_LIST = "faction_list";
const string PAGE_DB_LIST = "db_list";


void Init()
{
  Trace(QUARTER, "Initialising quarter sign conversation.");
  // This method is called once, at the start of the conversation.
  object oPC = GetPcDlgSpeaker();
  object oQuarter = OBJECT_SELF;

  gsQUPayTax(oQuarter);

  // Options for confirming or cancelling. These are static so we can set them
  // up once.
  if (GetElementCount(OWNER_MENU) == 0)
  {
    AddStringElement("<c þ >[Release Temple]</c>", OWNER_MENU);
    AddStringElement("<c þ >[Manage Security]</c>", OWNER_MENU);
    AddStringElement("<c þ >[Manage Temple]</c>", OWNER_MENU);
    AddStringElement("<c þ >[Put Temple Up For Sale]</c>", OWNER_MENU);
    AddStringElement("<c þ >[Assign Faction. Speak part of name before selecting.]</c>", OWNER_MENU);
    AddStringElement("<cþ  >[Done]</c>", OWNER_MENU);
  }

  if (GetElementCount(SECURITY_MENU) == 0)
  {
    int nValue = GetLocalInt(oQuarter, "GS_COST");
    AddStringElement("<c þ >[Replace Locks]</c> <cþ  >[Cost: " + IntToString(nValue/10) + " gold]</c>", SECURITY_MENU);
    AddStringElement("<c þ >[Manage Locks]</c>", SECURITY_MENU);
    AddStringElement("<c þ >[Manage Traps]</c>", SECURITY_MENU);
    AddStringElement("<c þ >[Create Key]</c>", SECURITY_MENU);
    AddStringElement("<c þ >[Toggle Public]", SECURITY_MENU);
    AddStringElement("<cþ  >[Back]</c>", SECURITY_MENU);
  }

  if (GetElementCount(LOCK_TRAP_MENU) == 0)
  {
    int nCost = GetLocalInt(oQuarter, "GS_COST") / 100;
    AddStringElement("<c þ >[Increase DC]</c> <cþ  >(Cost: " + IntToString(nCost) + ")</c>", LOCK_TRAP_MENU);
    AddStringElement("<c þ >[Decrease DC]</c>", LOCK_TRAP_MENU);
    AddStringElement("<c þ >[Increase Strength]</c>  <cþ  >(Cost: " + IntToString(nCost) + ")</c>", LOCK_TRAP_MENU);
    AddStringElement("<c þ >[Decrease Strength]</c>", LOCK_TRAP_MENU);
    AddStringElement("<cþ  >[Back]</c>", LOCK_TRAP_MENU);
  }

  if (GetElementCount(QUARTER_MENU) == 0)
  {
    AddStringElement("<c þ >[Rename]</c> (Speak the new name before selecting)", QUARTER_MENU);
    AddStringElement("<c þ >[Set Deity]</c> (Speak the new name of the Deity before selecting)", QUARTER_MENU);
    AddStringElement("<cþ  >[Back]</c>", QUARTER_MENU);
  }

  DeleteList(NON_OWNER_MENU); // Dynamic - varies per speaker.
  string sNation = miCZGetBestNationMatch(GetLocalString(GetArea(OBJECT_SELF), VAR_NATION));
  if (sNation == "")
  {
    string sNation = miCZGetBestNationMatch(GetLocalString(oQuarter, VAR_NATION));
  }

  object oModule = GetModule();
  string sNationName = miCZGetName(sNation);
  string sFactionID = md_GetDatabaseID(sNationName);
  int nOverride = md_GetHasPowerSettlement(MD_PR2_RVH, oPC, sFactionID, "2");

  if (GetIsDM(oPC) ||
      (sNation != "" &&
       nOverride &&
       miCZGetHasAuthority(gsPCGetPlayerID(oPC),gsQUGetOwnerID(oQuarter), sNation, nOverride))
     )
    AddStringElement("<c þ >[Release Temple]</c>", NON_OWNER_MENU);
  if (gsQUGetIsAvailable(oQuarter))
    AddStringElement("<c þ >[Buy Temple]</c> (Cost: " +
      IntToString(GetLocalInt(oQuarter, "GS_COST")/2) + ")", NON_OWNER_MENU);
  if(!gsQUGetIsAvailable(oQuarter) && md_GetHasPowerShop(MD_PR2_KEY, oPC, md_SHLoadFacID(oQuarter), "2"))
    AddStringElement("<c þ >[Create Key]</c>", NON_OWNER_MENU);
  AddStringElement("<cþ  >[Done]</c>", NON_OWNER_MENU);

  if (GetElementCount(CONFIRM_MENU) == 0)
  {
    AddStringElement("<c þ >[OK]</c>", CONFIRM_MENU);
    AddStringElement("<cþ  >[Cancel]</c>", CONFIRM_MENU);
  }
}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();
  object oQuarter = OBJECT_SELF;

  if (sPage == "")
  {
    // Is the PC the owner of the quarter?
    if (gsQUGetIsOwner(oQuarter, oPC))
    {
      int nTimeout = GetLocalInt(oQuarter, "GS_TIMEOUT");
      string sPrompt = "This is your Temple. " + (gsQUGetIsForSale(oQuarter) ?
       "It is currently up for sale." : "It is not currently for sale.") +
       "\n\nYour tax bill is currently " + IntToString(gsQUGetTaxAmount(oQuarter)) +
       " gold per game month. " +
       "\n\nYou can customise your Temple " +
       "by placing fixtures in it.  Most Temples also have one or more chests " +
       "in which to permanently store items.  Remember to open a locked door on your quarter " +
       "once every " + IntToString(nTimeout/86400) + " days, " +
       IntToString(gsTIGetHour(nTimeout)) + " hours and " +
       IntToString(gsTIGetMinute(nTimeout)) + " (realtime) or other players " +
       "may take it over.  Your Temple will also become available if you " +
       "run out of money in your bank account for paying rent. " +
       "If you want to share the Temple with someone, " +
       "create a key for them.  Or you can make your Temple available for " +
       "everyone to enter.";
      string sFName = fbFAGetFactionNameDatabaseID(md_SHLoadFacID());
      if(sFName != "")
        sPrompt += " This Temple is associated with faction " + sFName + ".";
      SetDlgPrompt(sPrompt);
      SetDlgResponseList(OWNER_MENU, OBJECT_SELF);
    }
    else if (gsQUGetIsVacant(oQuarter))
    {
      int clericLevel = GetLevelByClass(CLASS_TYPE_CLERIC, oPC);
      //::  Only 8 or more leveled Clerics can buy quarter
      if (clericLevel < 8) {
        SetDlgPrompt( "Only an experienced Cleric can maintain this Temple." );
        EndDlg();
        return;
      }

      SetDlgPrompt("This Temple is currently unoccupied.\n\n" +
      "If you own a quarter, you have to pay tax.  Tax for this quarter " +
      "is " + IntToString(GetLocalInt(oQuarter, "GS_COST") / 100 ) + " gold per " +
      "game month, plus a surcharge for any improvements that are made.");
      SetDlgResponseList(NON_OWNER_MENU, OBJECT_SELF);
    }
    else
    {
      SetDlgPrompt("This quarter is currently owned by " +
        gsQUGetOwnerName(oQuarter) + ".\n\n" +
      "If you own a quarter, you have to pay tax.  Tax for this quarter " +
      "is " + IntToString(GetLocalInt(oQuarter, "GS_COST") / 100 ) + " gold per " +
      "game month, plus a surcharge for any improvements that are made.");
      SetDlgResponseList(NON_OWNER_MENU, OBJECT_SELF);
    }
  }
  else if (sPage == SECURITY_PAGE)
  {
    SetDlgPrompt("The options below let you control access to your Temple.\n\n" +
    (gsQUGetIsPublic(oQuarter) ? "Your Temple is currently open to the public." :
    "Your Temple is currently open only to you and those with valid keys."));
    SetDlgResponseList(SECURITY_MENU, OBJECT_SELF);
  }
  else if (sPage == LOCK_PAGE)
  {
    SetDlgPrompt("The options below let you change the strength of your lock. " +
    "Note that tougher locks cost more and increase the rent on your Temple." +
    "\n\nCurrent lock DC: " + IntToString(gsQUGetLockDC(oQuarter)) +
    "\nCurrent lock strength: " + IntToString(gsQUGetLockStrength(oQuarter))
    );
    SetDlgResponseList(LOCK_TRAP_MENU, OBJECT_SELF);
  }
  else if (sPage == TRAP_PAGE)
  {
    SetDlgPrompt("he options below let you set a trap on your door. " +
    "Note that tougher traps cost more and increase the tax on your Temple." +
    "\n\nCurrent trap DC: " + IntToString(gsQUGetTrapDC(oQuarter)) +
    "\nCurrent trap strength: " + IntToString(gsQUGetTrapStrength(oQuarter))
    );
    SetDlgResponseList(LOCK_TRAP_MENU, OBJECT_SELF);
  }
  else if (sPage == QUARTER_PAGE)
  {
    SetDlgPrompt("Maintenance options for your Temple.");
    SetDlgResponseList(QUARTER_MENU, OBJECT_SELF);
  }
  else if (sPage == BUY_QUARTER_PAGE)
  {
    SetDlgPrompt("Are you sure?  Once you have bought this Temple, you will " +
    "have to pay tax regularly.  Tax will be deducted automatically from your " +
    "bank account, and if you have no gold left the quarter will go up for " +
    "sale.  Tax for this Temple is "+ IntToString(GetLocalInt(oQuarter, "GS_COST") / 100 ) +
    " gold per game month, plus a surcharge for any improvements that are made.");
    SetDlgResponseList(CONFIRM_MENU, OBJECT_SELF);
  }
  else if (sPage == ABANDON_PAGE)
  {
    SetDlgPrompt("Are you sure you want to release the Temple?");
    SetDlgResponseList(CONFIRM_MENU, OBJECT_SELF);
  }
  else if (sPage == REPLACE_LOCKS_PAGE)
  {
    SetDlgPrompt("Replacing the locks will make all existing keys invalid. " +
     "Do you want to continue?");
    SetDlgResponseList (CONFIRM_MENU, OBJECT_SELF);
  }
  else if(sPage == FACTION_LIST)
  {
    SetDlgPrompt("Select a faction.");
    SQLExecStatement("SELECT id,name FROM md_fa_factions WHERE name LIKE ? LIMIT 8", //limit 8 so it doesn't go over  a page
       "%" + chatGetLastMessage(oPC) + "%");

    DeleteList(FACTION_LIST);
    DeleteList(PAGE_DB_LIST);
    AddStringElement("[Remove Faction]", FACTION_LIST);
    string sName;
    while (SQLFetch())
    {
       sName =  SQLGetData(2);

       if(FindSubString(sName, CHILD_PREFIX) == 0 || FindSubString(sName, SETTLEMENT_PREFIX) == 0)
         sName = GetStringRight(sName, GetStringLength(sName) - GetStringLength(CHILD_PREFIX));

       AddStringElement(SQLGetData(1), PAGE_DB_LIST);

       AddStringElement(sName, FACTION_LIST);

    }
    AddStringElement("<cþ  >[Back]</c>", FACTION_LIST);
    AddStringElement("<cþ  >[Done]</c>", FACTION_LIST);
    SetDlgResponseList (FACTION_LIST);
  }
  else
  {
    SendMessageToPC(oPC,
                    "You've found a bug. How embarassing. Please report it.");
    EndDlg();
  }
}

void HandleSelection()
{
  // This method handles what happens when the player selects an option.
  int selection   = GetDlgSelection();
  object oPC      = GetPcDlgSpeaker();
  string sPage    = GetDlgPageString();
  object oQuarter = OBJECT_SELF;

  if (sPage == "")
  {
    if (gsQUGetIsOwner(oQuarter, oPC))
    {
      switch (selection)
      {
      case 0: // Release
        sPage = ABANDON_PAGE;
        break;
      case 1: // Security
        sPage = SECURITY_PAGE;
        break;
      case 2: // Quarter
        sPage = QUARTER_PAGE;
        break;
      case 3: // Toggle for sale
        gsQUSetIsForSale(oQuarter, !gsQUGetIsForSale(oQuarter));
        break;
      case 4: //faction list!
        sPage = FACTION_LIST;
        break;
      case 5: // Leave
        EndDlg();
        break;
     }
    }
    else
    {
      string sNation = miCZGetBestNationMatch(GetLocalString(GetArea(OBJECT_SELF), VAR_NATION));

      object oModule = GetModule();
      string sNationName = miCZGetName(sNation);
      string sFactionID = md_GetDatabaseID(sNationName);
      int nOverride = md_GetHasPowerSettlement(MD_PR2_RVH, oPC, sFactionID, "2");
      if ((selection ==  0) &&
          (GetIsDM(oPC) ||
           (sNation != "" &&
            nOverride &&
            miCZGetHasAuthority(gsPCGetPlayerID(oPC),gsQUGetOwnerID(oQuarter), sNation, nOverride)))) // Release
        sPage = ABANDON_PAGE;
      else if (gsQUGetIsAvailable(oQuarter) &&
               (selection == 0 ||
                (selection == 1 &&
                 (GetIsDM(oPC) ||
                  (sNation != "" &&
                   nOverride &&
       miCZGetHasAuthority(gsPCGetPlayerID(oPC),gsQUGetOwnerID(oQuarter), sNation, nOverride))))
                )
              ) // Buy
        sPage = BUY_QUARTER_PAGE;
      else if(GetStringElement(selection, NON_OWNER_MENU) == "<c þ >[Create Key]</c>")
        gsQUCreateKey(oQuarter, oPC);
      else // Leave
        EndDlg();
    }
  }
  else if (sPage == SECURITY_PAGE)
  {
    switch (selection)
    {
      case 0:   // Replace locks
        sPage = REPLACE_LOCKS_PAGE;
        break;
      case 1:   // Manage locks
        sPage = LOCK_PAGE;
        break;
      case 2:   // Manage traps
        sPage = TRAP_PAGE;
        break;
      case 3:   // Create key
        gsQUCreateKey(oQuarter, oPC);
        break;
      case 4:   // Toggle Public
        gsQUSetIsPublic(oQuarter, !gsQUGetIsPublic(oQuarter));
        break;
      case 5:    // Back
        sPage = "";
        break;
    }
  }
  else if (sPage == LOCK_PAGE)
  {
    int nCost = GetLocalInt(oQuarter, "GS_COST") / 100;
    switch (selection)
    {
      case 0:   // Increase DC
        if (GetGold(oPC) < nCost)SendMessageToPC(oPC, "You don't have enough gold.");
        else
        {
          gsQUSetLockDC(oQuarter, gsQUGetLockDC(oQuarter) + 3);
          TakeGoldFromCreature(nCost, oPC, TRUE);
        }
        break;
      case 1:   // Decrease DC
        gsQUSetLockDC(oQuarter, gsQUGetLockDC(oQuarter) - 3);
        break;
      case 2:   // Increase strength
        if (GetGold(oPC) < nCost) SendMessageToPC(oPC, "You don't have enough gold.");
        else
        {
          gsQUSetLockStrength(oQuarter, gsQUGetLockStrength(oQuarter) + 1);
          TakeGoldFromCreature(nCost, oPC, TRUE);
        }
        break;
      case 3:   // Decrease strength
        gsQUSetLockStrength(oQuarter, gsQUGetLockStrength(oQuarter) - 1);
        break;
      case 4:   // Go back
        sPage = SECURITY_PAGE;
        break;
    }
  }
  else if (sPage == TRAP_PAGE)
  {
    int nCost = GetLocalInt(oQuarter, "GS_COST") / 100;
    switch (selection)
    {
      case 0:   // Increase DC
        if (GetGold(oPC) < nCost) SendMessageToPC(oPC, "You don't have enough gold.");
        else
        {
          gsQUSetTrapDC(oQuarter, gsQUGetTrapDC(oQuarter) + 3);
          TakeGoldFromCreature(nCost, oPC, TRUE);
        }
        break;
      case 1:   // Decrease DC
        gsQUSetTrapDC(oQuarter, gsQUGetTrapDC(oQuarter) - 3);
        break;
      case 2:   // Increase strength
        if (GetGold(oPC) < nCost) SendMessageToPC(oPC, "You don't have enough gold.");
        else
        {
          gsQUSetTrapStrength(oQuarter, gsQUGetTrapStrength(oQuarter) + 1);
          TakeGoldFromCreature(nCost, oPC, TRUE);
        }
        break;
      case 3:   // Decrease strength
        gsQUSetTrapStrength(oQuarter, gsQUGetTrapStrength(oQuarter) - 1);
        break;
      case 4:   // Go back
        sPage = SECURITY_PAGE;
        break;
    }
  }
  else if (sPage == QUARTER_PAGE)   //::  TEMPLE SPECIFIC STUFF HERE
  {
    switch (selection)
    {
      case 0:  // Rename
        gsQUSetName(oQuarter, gsLIGetLastMessage(oPC));
        break;
      case 1:  //::  Store deity
        arQUSetDeity(oQuarter, gsLIGetLastMessage(oPC));
        break;
      case 2:  // Go back
        sPage = "";
        break;
    }
  }
  else if (sPage == BUY_QUARTER_PAGE)
  {
    switch (selection)
    {
      case 0:   // Do it
      {
        int nCost       = GetLocalInt(oQuarter, "GS_COST") / 2;
        int nTimeout    = GetLocalInt(oQuarter, "GS_TIMEOUT");

        if (nCost > GetGold(oPC))
        {
          SendMessageToPC(oPC, "You don't have enough gold!");
          break;
        }

        if (nCost > 0)
        {
          string sID  = gsQUGetOwnerID(oQuarter);
          if (sID == "")
          {
            sID = miCZGetBestNationMatch(GetLocalString(GetArea(oQuarter), VAR_NATION));
            if(sID == "")
              sID = "DUMMY";
            else
              sID = "N"+sID;
          }
          AssignCommand(oPC, gsFITransfer(sID, nCost));
        }

        gsQUSetOwner(oQuarter, oPC, nTimeout);
        gsQUReset(oQuarter);
        sPage = "";
        break;
      }
      case 1:   // Cancel
        sPage = "";
        break;
    }
  }
  else if (sPage == ABANDON_PAGE)
  {
    string sOwner;
    object oWrit;
    switch (selection)
    {
       case 0:   // Do it
        sOwner = gsQUGetOwnerID(OBJECT_SELF);
        LeaderLog(GetPCSpeaker(), "Released Temple owned by " + sOwner);
        //For writs: if the owner of the quarter isn't the same as the one releasing the quarter, take a writ
        if(sOwner != gsPCGetPlayerID(oPC) &&
           md_GetHasWrit(oPC, md_GetDatabaseID(miCZGetName(miCZGetBestNationMatch(GetLocalString(GetArea(OBJECT_SELF), VAR_NATION)))),
           MD_PR2_RVH, "2") == 3)
        {
          oWrit = GetItemPossessedBy(oPC, "micz_writ_sgn");
          if (GetIsObjectValid(oWrit)) gsCMReduceItem(oWrit);
        }
        gsQUAbandon(oQuarter);
        EndDlg();
        break;
      case 1:   // Cancel
        sPage = "";
        break;
    }
  }
  else if (sPage == REPLACE_LOCKS_PAGE)
  {
    switch (selection)
    {
      case 0:   // Do it
      {
        int nCost       = GetLocalInt(oQuarter, "GS_COST") / 10;
        int nTimeout    = GetLocalInt(oQuarter, "GS_TIMEOUT");

        if (nCost > 0)
        {
          if (GetGold(oPC) < nCost)
          {
            SendMessageToPC (oPC, "You don't have enough gold");
            break;
          }
          else
          {
            TakeGoldFromCreature(nCost, oPC, TRUE);
          }
        }

        gsQUSetOwner(oQuarter, oPC, nTimeout);
        sPage = SECURITY_PAGE;
        break;
      }
      case 1:   // Cancel
        sPage = SECURITY_PAGE;
        break;
    }
  }
  else if(sPage == FACTION_LIST)
  {

    string sSHID = GetLocalString(oQuarter, "GS_CLASS")+
                   IntToString(GetLocalInt(oQuarter, "GS_INSTANCE"));

    int nElementCount = GetElementCount(FACTION_LIST);

    if(selection == 0)
    {
      SQLExecStatement("UPDATE gs_quarter SET faction_id=NULL WHERE row_key='"+
                     sSHID+"'");
      SetLocalString(GetModule(), VAR_FID+sSHID, "NONE");
    }
    else if(selection == nElementCount - 1)//Done
    {
        EndDlg();
    }
    else if(selection != nElementCount - 2)
    {
      string sID = GetStringElement(selection-1, PAGE_DB_LIST);
      miDASetKeyedValue("gs_quarter", sSHID, "faction_id", sID, "row_key");

      SetLocalString(GetModule(), VAR_FID+sSHID, sID);


    }
     sPage = "";
  }

  SetDlgPageString(sPage);
}

void main()
{
  // Never (ever ever) change this method. Got that? Good.
  int nEvent = GetDlgEventType();
  Trace(ZDIALOG, "Running zdlg_temple script");
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
