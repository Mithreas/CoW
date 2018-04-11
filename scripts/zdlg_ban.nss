/*
  Name: zdlg_ban
  Author: Fireboar
  Description: Used by DMs as an interface to manage bans
*/
#include "fb_inc_chatutils"
#include "gs_inc_pc"
#include "inc_log"
#include "zdlg_include_i"

const string HELP0 = "Here are the possible actions you can take with bans. Some may not be available unless there is a soul inside the cage. Others will only work when there is exactly one soul in the cage.";
const string HELP1 = "Retrieve ban: Allows you to speak a player name, IP address or CD key and remove the appropriate player ban from the cage. The item is placed in the inventory of the cage, and nothing is saved until you commit the ban.";
const string HELP2 = "Commit ban: Any ban that you retrieve will remain unchanged until you commit it. Once committed, the ban will be saved and disappear from the cage. You can retrieve it again to make further changes.";
const string HELP3 = "Rollback ban: If you make a change to a ban then decide that the change was unnecessary, you can Rollback the ban. This is like committing, except it doesn't save anything, it just removes the soul from the cage.";
const string HELP4 = "Rename ban: Bans by default are given the player name of the first account banned. If this turns out to be a group of players that you would like to identify in some other way, you can use this to give the soul a nickname. You can even use this name to retrieve a ban.";
const string HELP5 = "Combine ban: Requires 2 or more souls in the cage. This combines the souls into one, so you manage them all together. Note that there is currently no way to undo this action except manually.";
const string HELP6 = "Unenforce ban: Frees any souls currently in the cage by unbanning them. The soul is then transferred to your inventory. If you are unlikely to ban this individual in the future, you should put it in the trash. Otherwise, you can later reinstate the ban by replacing the soul and using the Commit Ban option.";
const string HELP7 = "Steps to a ban:\n1) Catch the villain's soul.\n2) Drop them in the ban cage.\n3) Choose 'Commit ban'.";

const string MAIN_OPTIONS = "MAIN_OPTIONS";
const string BAN_OPTIONS = "BAN_OPTIONS";
const string HELP_OPTIONS = "HELP_OPTIONS";

const string DLG_HELP      = "PAGE_HELP";

const string VAR_DESCRIPTION = "VAR_DESCRIPTION";
const string VAR_ID          = "VAR_ID";
const string VAR_LOCK        = "VAR_LOCK";
const string VAR_STAGE       = "VAR_STAGE";
const string VAR_USEIP       = "VAR_USEIP";

// Creates the item representing the ban with ID sID on oTarget. While the other
// params are not strictly necessary, they are included to save a query being
// executed twice.
void fbCreateBanItem(object oTarget, string sID, int nUseIP, string sDesc)
{
  object oItem = CreateItemOnObject("gs_item018", oTarget, 1, "GS_BA_" + sID);
  SetName(oItem, sDesc);
  SetLocalInt(oItem, "BAN_USEIP", nUseIP);
  SetLocalString(oItem, "BAN_ID", sID);

  // Grab all keys, names and IPs associated
  SQLExecStatement("SELECT n.bn_id, n.bn_type, n.bn_data FROM fb_ban_nodes AS " +
   "n INNER JOIN fb_ban_links AS l ON l.bl_node=n.bn_id WHERE l.bl_group=? " +
   "ORDER BY n.bn_type ASC, n.bn_data ASC", sID);

  string sType;
  string sLastType;
  string sData;
  string sCount;
  int nCount = 0;
  string sDescription = "Details about the ban " + sDesc + ":\n";
  while (SQLFetch())
  {
    sType = SQLGetData(2);
    if (sType != sLastType)
    {
      if (sLastType != "")
      {
        SetLocalInt(oItem, "BAN_" + sLastType + "_COUNT", nCount);
      }
      sLastType = sType;
      nCount    = 0;
      if (sType == "0") // CD key
      {
        sDescription += "\nCD Keys:\n";
      }
      else if (sType == "1") // Player name
      {
        sDescription += "\nPlayer Accounts:\n";
      }
      else if (sType == "2") // IP
      {
        sDescription += "\nIP Addresses:\n";
      }
    }

    sData  = SQLGetData(3);
    sCount = IntToString(nCount);
    SetLocalString(oItem, "BAN_" + sType + "_" + sCount, SQLGetData(1));
    SetLocalString(oItem, "BAN_DATA_" + sType + "_" + sCount, sData);
    sDescription += sData + "\n";
    nCount++;
  }

  if (sType != "")
  {
    SetLocalInt(oItem, "BAN_" + sType + "_COUNT", nCount);
  }

  SetDescription(oItem, sDescription);
  SetIdentified(oItem, TRUE);
}

// Performs the [Retrieve Ban] action. Moved to a separate method because it is
// called twice.
void fbRetrieveBan(object oPC, object oSelf)
{
  string sText = chatGetLastMessage(oPC);
  int bLock = GetLocalInt(oPC, VAR_LOCK);
  int nUseIP;
  string sID;
  string sDesc;

  // No text, and we're not just confirming.
  if (sText == "" && !bLock)
  {
    SendMessageToPC(oPC, "Please speak a player name, CD key, IP address or nickname before selecting this option.");
    return;
  }
  // Got text. This must override bLock.
  else if (sText != "")
  {
    SQLExecStatement("SELECT g.bg_id, g.bg_useip, g.bg_lock, g.bg_description" +
     " FROM fb_ban_nodes AS n INNER JOIN fb_ban_links AS l ON (n.bn_id =" +
     " l.bl_node) INNER JOIN fb_ban_groups AS g ON (g.bg_id = l.bl_group)" +
     " WHERE n.bn_data = ? OR g.bg_description = ?", sText, sText);

    if (SQLFetch())
    {
      string sLockedBy = SQLGetData(3);
      sID = SQLGetData(1);
      if (sLockedBy != "")
      {
        // Special case: it's the current DM who checked it out
        if (sLockedBy == GetName(oPC))
        {
          if (GetIsObjectValid(GetItemPossessedBy(oPC, "GS_BA_" + sID)) ||
           GetIsObjectValid(GetItemPossessedBy(oSelf, "GS_BA_" + sID)))
          {
            SendMessageToPC(oPC, "Either you are holding that soul, or it is in this cage at the moment. Whatever the case, you do not need to retrieve it again.");
            return;
          }
          else
          {
            nUseIP = StringToInt(SQLGetData(2));
            sDesc = SQLGetData(3);
          }
        }
        else
        {
          SetLocalInt(oPC, VAR_LOCK, TRUE);
          SetLocalInt(oPC, VAR_USEIP, StringToInt(SQLGetData(2)));
          SetLocalString(oPC, VAR_ID, sID);
          SetLocalString(oPC, VAR_DESCRIPTION, SQLGetData(3));
          SendMessageToPC(oPC, "WARNING: This soul has been locked by " + sLockedBy + ", meaning that they started to change it and then didn't save. This could either mean that the DM wasn't careful, or that they are still doing something with it. If you know that this isn't the case, click Retrieve Ban again.");
          return;
        }
      }
      else
      {
        nUseIP = StringToInt(SQLGetData(2));
        sDesc  = SQLGetData(4);
      }
    }
    else
    {
      SendMessageToPC(oPC, "That soul does not seem to exist in the ban cage.");
      return;
    }
  }
  // No text, but we were just confirming.
  else
  {
    nUseIP = GetLocalInt(oPC, VAR_USEIP);
    sID    = GetLocalString(oPC, VAR_ID);
    sDesc  = GetLocalString(oPC, VAR_DESCRIPTION);
    DeleteLocalInt(oPC, VAR_LOCK);
    DeleteLocalInt(oPC, VAR_USEIP);
    DeleteLocalString(oPC, VAR_ID);
    DeleteLocalString(oPC, VAR_DESCRIPTION);
  }

  fbCreateBanItem(oSelf, sID, nUseIP, sDesc);
  SQLExecStatement("UPDATE fb_ban_groups SET bg_lock=? WHERE bg_id=?",
   GetName(oPC), sID);
  SendMessageToPC(oPC, sDesc + " has been retrieved.");
}

void Init()
{
  object oPC = GetPcDlgSpeaker();

  // When there container is empty
  if (GetElementCount(MAIN_OPTIONS) == 0)
  {
    AddStringElement("<c þ >[Retrieve Ban]</c>", MAIN_OPTIONS);
    AddStringElement("<cþþ >[Help]</c>", MAIN_OPTIONS);
    AddStringElement("<cþ  >[Leave]</c>", MAIN_OPTIONS);
  }

  if (GetElementCount(BAN_OPTIONS) == 0)
  {
    AddStringElement("<c þ >[Retrieve Ban]</c>", BAN_OPTIONS);
    AddStringElement("<c þ >[Commit Ban]</c>", BAN_OPTIONS);
    AddStringElement("<c þ >[Rollback Ban]</c>", BAN_OPTIONS);
    AddStringElement("<c þ >[Rename Ban]</c>", BAN_OPTIONS);
    AddStringElement("<c þ >[Combine Ban]</c>", BAN_OPTIONS);
    AddStringElement("<c þ >[Unenforce Ban]</c>", BAN_OPTIONS);
    AddStringElement("<cþþ >[Help]</c>", BAN_OPTIONS);
    AddStringElement("<cþ  >[Leave]</c>", BAN_OPTIONS);
  }

  if (GetElementCount(HELP_OPTIONS) == 0)
  {
    AddStringElement("<c þ >[Retrieve Ban]</c>", HELP_OPTIONS);
    AddStringElement("<c þ >[Commit Ban]</c>", HELP_OPTIONS);
    AddStringElement("<c þ >[Rollback Ban]</c>", HELP_OPTIONS);
    AddStringElement("<c þ >[Rename Ban]</c>", HELP_OPTIONS);
    AddStringElement("<c þ >[Combine Ban]</c>", HELP_OPTIONS);
    AddStringElement("<c þ >[Unenforce Ban]</c>", HELP_OPTIONS);
    AddStringElement("<cþ  >[Back]</c>", HELP_OPTIONS);
  }
}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oPC = GetPcDlgSpeaker();
  object oSelf = OBJECT_SELF; // GetNpcDlgSpeaker might be a good idea for perf

  if (!GetIsDM(oPC))
  {
    EndDlg();
    return;
  }

  chatClearLastMessage(oPC);

  if (sPage == "")
  {
    if (GetIsObjectValid(GetFirstItemInInventory(oSelf)) &&
        !GetLocalInt(OBJECT_SELF, "deleting"))
    {
      SetDlgPrompt("Here you can choose various things to do with the ban(s) " +
       "in the cage. Choose the Help option for instructions.");
      SetDlgResponseList(BAN_OPTIONS);
      SetDlgPageInt(GetIsObjectValid(GetNextItemInInventory(oSelf)) + 1);
    }
    else
    {
      SetDlgPrompt("Here you can retrieve a ban to work with: simply speak the " +
       "name, CD key, IP or nickname of a banned individual. Choose the Help " +
       "option for instructions.");
      SetDlgResponseList(MAIN_OPTIONS);
      SetDlgPageInt(0);
      DeleteLocalInt(OBJECT_SELF, "deleting");
    }
  }
  else if (sPage == DLG_HELP)
  {
    int nStage = GetLocalInt(oPC, VAR_STAGE);
    switch (nStage)
    {
    case 0:
      SetDlgPrompt(HELP0 + "\n\n" + HELP7);
      break;
    case 1:
      SetDlgPrompt(HELP1);
      break;
    case 2:
      SetDlgPrompt(HELP2);
      break;
    case 3:
      SetDlgPrompt(HELP3);
      break;
    case 4:
      SetDlgPrompt(HELP4);
      break;
    case 5:
      SetDlgPrompt(HELP5);
      break;
    case 6:
      SetDlgPrompt(HELP6);
      break;
    }

    SetDlgResponseList(HELP_OPTIONS);
  }
}

void HandleSelection()
{
  // This is the function that handles each page's responses
  string sPage   = GetDlgPageString();
  object oPC     = GetPcDlgSpeaker();
  object oSelf   = OBJECT_SELF;
  int nSelection = GetDlgSelection();
  int nItems     = GetDlgPageInt();

  if (sPage == "")
  {
    if (nItems == 0)
    {
      switch (nSelection)
      {
      case 0: // [Retrieve Ban]
        fbRetrieveBan(oPC, oSelf);
        break;
      case 1: // [Help]
        SetDlgPageString(DLG_HELP);
        break;
      case 2: // [Leave]
        EndDlg();
        break;
      }
    }
    else
    {
      switch (nSelection)
      {
      case 0: // [Retrieve Ban]
        fbRetrieveBan(oPC, oSelf);
        break;
      case 1: // [Commit Ban]
      {
        object oItem = GetFirstItemInInventory(oSelf);
        string sID, sDesc;
        while (GetIsObjectValid(oItem))
        {
          sID   = GetLocalString(oItem, "BAN_ID");
          sDesc = GetName(oItem);
          if (sID != "")
          {
            SQLExecStatement("UPDATE fb_ban_groups SET bg_useip=?, bg_lock=null, " +
             "bg_description=? WHERE bg_id=?", IntToString(GetLocalInt(oItem,
             "BAN_USEIP")), sDesc, sID);

            // Write queries can be expensive so we just list the changes as
            // local strings from SQLPrepareStatement on the item.
            int nChanges = GetLocalInt(oItem, "BAN_CHANGES");
            int nI       = 0;
            for (; nI < nChanges; nI++)
            {
              SQLExecDirect(GetLocalString(oItem, "BAN_CHANGES_" + IntToString(nI)));
            }

            SendMessageToPC(oPC, sDesc + " has been saved.");

            // Don't interfere with the while loop until it's finished
            ActionDoCommand(DestroyObject(oItem));
            SetLocalInt(OBJECT_SELF, "deleting", 1);
          }
          // Must have unenforced the ban causing it to lose its ID - or this
          // is a new ban.
          else if (GetResRef(oItem) == "gs_item018")
          {
            string sTimestamp = IntToString(gsTIGetActualTimestamp());
            SQLExecStatement("INSERT INTO fb_ban_groups(bg_timestamp, " +
             "bg_useip, bg_description) VALUES(?, ?, ?)", sTimestamp,
             IntToString(GetLocalInt(oItem, "BAN_USEIP")), sDesc);

            SQLExecStatement("SELECT bg_id FROM fb_ban_groups WHERE bg_timestamp=? " +
             "ORDER BY bg_id DESC LIMIT 1", sTimestamp);
            SQLFetch();
            sID = SQLGetData(1);

            int nI = 0;
            int nJ = 0;
            int nCount;
            string sI;
            string sJ;
            string sValues;
            for (; nI < 3; nI++)
            {
              sI = IntToString(nI);
              nCount = GetLocalInt(oItem, "BAN_" + sI + "_COUNT");
              for (nJ = 0; nJ < nCount; nJ++)
              {
                sJ = IntToString(nJ);
                if (sValues != "")
                {
                  sValues += ", ";
                }
                sValues += SQLPrepareStatement("(?, ?)", GetLocalString(oItem,
                 "BAN_" + sI + "_" + sJ), sID);
              }
            }

            if (sValues == "")
            {
              // New ban, so no variables set up.  Set them up now, and
              // create the status information.
              string sCDKey = GetLocalString(oItem, "GS_BA_CDKEY");
              string sPCID  = GetLocalString(oItem, "GS_BA_PNAME");
              string sPCIP  = GetLocalString(oItem, "GS_BA_IP");
              object oBanned = gsPCGetPlayerByCDKey(sCDKey);

              // Insert the individual CD key and player name bans
              SQLExecStatement("INSERT INTO fb_ban_nodes (bn_type, bn_data)"
               + " VALUES (0,?), (1,?), (2,?)", sCDKey, sPCID, sPCIP);

              // Retrieve the IDs for the three rows we just added, which will
              // have been automatically assigned
              SQLExecStatement("SELECT bn_id FROM fb_ban_nodes WHERE bn_data=? "
               + "AND bn_type=0 ORDER BY bn_id DESC LIMIT 1", sCDKey);
              SQLFetch();
              string sID_1 = SQLGetData(1);

              SQLExecStatement("SELECT bn_id FROM fb_ban_nodes WHERE bn_data=? "
               + "AND bn_type=1 ORDER BY bn_id DESC LIMIT 1", sPCID);
              SQLFetch();
              string sID_2 = SQLGetData(1);

              SQLExecStatement("SELECT bn_id FROM fb_ban_nodes WHERE bn_data=? "
               + "AND bn_type=2 ORDER BY bn_id DESC LIMIT 1", sPCIP);
              SQLFetch();
              string sID_3 = SQLGetData(1);

              // Specify the rows we'll have to add to the links table, linking
              // the ID of each row to the ID of the ban group.
              sValues += SQLPrepareStatement("(?, ?), (?, ?), (?, ?)",
               sID_1, sID, sID_2, sID, sID_3, sID);

              if (GetIsObjectValid(oBanned))
              {
                BootPC(oBanned);
              }
            }

            SQLExecDirect("INSERT INTO fb_ban_links(bl_node, bl_group) VALUES " + sValues);

            SendMessageToPC(oPC, sDesc + " is now banned.");

            // Don't interfere with the while loop until it's finished
            ActionDoCommand(DestroyObject(oItem));
            SetLocalInt(OBJECT_SELF, "deleting", 1);
          }

          oItem = GetNextItemInInventory(oSelf);
        }
        break;
      }
      case 2: // [Rollback Ban]
      {
        object oItem = GetFirstItemInInventory(oSelf);
        string sID;
        while (GetIsObjectValid(oItem))
        {
          sID = GetLocalString(oItem, "BAN_ID");
          if (sID != "")
          {
            SQLExecStatement("UPDATE fb_ban_groups SET bg_lock=null WHERE bg_id=?", sID);
            SendMessageToPC(oPC, GetName(oItem) + " has been rolled back.");

            // Don't interfere with the while loop until it's finished
            ActionDoCommand(DestroyObject(oItem));
            SetLocalInt(OBJECT_SELF, "deleting", 1);
          }

          oItem = GetNextItemInInventory(oSelf);
        }
        break;
      }
      case 3: // [Rename Ban]
      {
        if (nItems > 1)
        {
          SendMessageToPC(oPC, "You can only do this with one soul in the cage. Please remove the others.");
          return;
        }

        string sText = chatGetLastMessage(oPC);
        if (sText == "")
        {
          SendMessageToPC(oPC, "Please speak the new name first.");
          return;
        }

        object oItem = GetFirstItemInInventory(oSelf);
        if (GetIsObjectValid(oItem))
        {
          SetName(oItem, sText);
          SendMessageToPC(oPC, "This soul has been given a new nickname successfully.");
        }
        break;
      }
      case 4: // [Combine Ban]
      {
        if (nItems == 1)
        {
          SendMessageToPC(oPC, "You can only do this when there is more than one soul in the cage.");
          return;
        }

        object oMaster = GetFirstItemInInventory(oSelf);
        object oJoin   = GetNextItemInInventory(oSelf);
        int nChanges   = GetLocalInt(oMaster, "BAN_CHANGES");
        string sID     = GetLocalString(oMaster, "BAN_ID");
        int nUseIP     = GetLocalInt(oMaster, "BAN_USEIP") * 2;
        string sJoinID;
        while (GetIsObjectValid(oJoin))
        {
          sJoinID = GetLocalString(oJoin, "BAN_ID");
          SetLocalString(oMaster, "BAN_CHANGES_" + IntToString(nChanges),
           SQLPrepareStatement("UPDATE fb_ban_links SET bl_group=? WHERE bl_group=?",
           sID, sJoinID));
          SetLocalString(oMaster, "BAN_CHANGES_" + IntToString(nChanges + 1),
           SQLPrepareStatement("DELETE FROM fb_ban_groups WHERE bg_id=?",
           sJoinID));
          nChanges += 2;

          if (nUseIP == 0 && GetLocalInt(oJoin, "BAN_USEIP"))
          {
            nUseIP = 1;
          }

          // Don't interfere with the while loop until it's finished
          ActionDoCommand(DestroyObject(oJoin));
        }

        // If the IP was not being used in the master, but is in one of the joinees
        if (nUseIP == 1)
        {
          SetLocalInt(oMaster, "BAN_USEIP", 1);
        }

        SetDescription(oMaster, GetDescription(oMaster) + "\n\nNOTE: This information is scheduled to change because of a 'combine' action.");

        SendMessageToPC(oPC, "Combination complete. Remember, you MUST commit your changes for this to have effect. Also, you may want to consider giving this soul a new nickname, since the name of the first soul in the soul cage is always used by default.");
        break;
      }
      case 5: // [Unenforce Ban]
      {
        object oItem = GetFirstItemInInventory(oSelf);
        string sID;
        while (GetIsObjectValid(oItem))
        {
          // We are only actually unlinking the ban: the actual data (IPs etc)
          // are still retained. It's more straightforward and easier to
          // reimplement the ban.
          sID = GetLocalString(oItem, "BAN_ID");
          SQLExecStatement("DELETE FROM fb_ban_groups WHERE bg_id=?", sID);
          SQLExecStatement("DELETE FROM fb_ban_links WHERE bl_group=?", sID);
          DeleteLocalString(oItem, "BAN_ID");

          SendMessageToPC(oPC, "The ban on " + GetName(oItem) + " has been unenforced. To reinstate it, choose [Commit Ban] with this soul in the cage.");
          AssignCommand(oSelf, ActionGiveItem(oItem, oPC));

          oItem = GetNextItemInInventory(oSelf);
        }

        break;
      }
      case 6: // [Help]
        SetDlgPageString(DLG_HELP);
        break;
      case 7: // [Leave]
        EndDlg();
        break;
      }
    }
  }
  else if (sPage == DLG_HELP)
  {
    int nStage = GetLocalInt(oPC, VAR_STAGE);
    if (nSelection == 6)
    {
      DeleteLocalInt(oPC, VAR_STAGE);
      SetDlgPageString("");
    }
    else
    {
      SetLocalInt(oPC, VAR_STAGE, nSelection + 1);
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
