// mi_inc_xfer
// Cross server transfer library by Mithreas
//
// Relies on parameters from the 2da file, read in gs_m_load.
//
// Current list of transfer points and waypoint tags (use same tag on both sides):
//  On server enter, if on wrong server                        (no tag)
//  Portal from Jhared's to Old Stonehold                      (mi_xfer_1)
//  Entrance to the Dwarvern Halls from the Dark Spires peak   (mi_xfer_2)
//  Entrance to the Stinger Caves from the Underpassages       (mi_xfer_3)
//  Entrance to the Crystal Path from Minmir Caves             (mi_xfer_4)
//  Entrance to the Burning Spires from RDI                    (mi_xfer_5)
//  Entrance to the Abyss from Urdlen's Wake                   (mi_xfer_6)
//  Transition between Death areas                             (mi_xfer_7)
//  Transition from Light Keep to Baator                       (mi_xfer_8)
//  Transition between portal chambers under Stonehold         (mi_xfer_9)
//  Transition between Brog kinstone mine and the Svirf mines  (mi_xfer_10)
//  Transition between Gnomish Shipyard and Svirf              (mi_xfer_11)
//
//  Transition from Bramble Woods Trade Route to Mayfields     (mi_xfer_90)
//  Transition from Western Outskirts to Lowland Swamps        (mi_xfer_91)
//  Transition from Eastern Shoreline to Traders Route         (mi_xfer_92)
//  Transition from Eastern Shoreline to Foothills             (mi_xfer_93)
//  Transition from Eastern Shoreline caves to Foothills       (mi_xfer_94)
//  Transition from Cordor Docks to Crow's Nest docks          (mi_xfer_95)
//  Transition from Shadow Docks to Shadovar Trade Post        (mi_xfer_96)
//  Transition from Bramble Woods to Cave o/t Mound            (mi_xfer_97)
//  Transition from Underpassages to Lowland Swamps            (mi_xfer_98)
//  Transition from Kobold Mines to Collapsed Mine             (mi_xfer_99)
//
//  Transition from Cordor Merchant District to Cordor Docks   (mi_xfer_89)
//  Transition from Cordor Temple District to Cordor Docks     (mi_xfer_88)
//
// Current list of one-way transfer points' waypoint tags
//  Skull Crags (Expedition)                                   (mi_xfer_704)
//  Jungle Ruins (Expedition)                                  (mi_xfer_705)
//  Minmir (Expedition)                                        (mi_xfer_706)
//  Sibayad (Docks) (Expedition/Cordor Ferry)                  (mi_xfer_707)
//  Dark Spires (Expedition)                                   (mi_xfer_708)
//  Sencliff (Cordor Ferry)                                    (mi_xfer_709)
//  Arcane Tower (Cordor Caravan)                              (mi_xfer_710)
//
//  Sibayad (Coast) Hidden Cove Exit                           (mi_xfer 711)
//
//  Rayne's Landing (Smuggler)                                 (mi_xfer_712)
//  Skull Crags (Smuggler)                                     (mi_xfer_713)
//  Crow's Nest (Smuggler)                                     (mi_xfer_714)
//  Bitter Coast (Smuggler)                                    (mi_xfer_715)
//  Minmir Coast (Smuggler)                                    (mi_xfer_716)
//  Cordor Cultural District                                   (mi_xfer_717)
//  Sibayad (Coast) (Smuggler)                                 (mi_xfer_718)
//
//
//
// Other cross-server transfers (one-way)
//  Astrolabe                                                  (wt_astro_start)
//

/* Uses the following database tables:
   mixf_serverinfo
   - server VARCHAR(32)
   - address VARCHAR(64)
   - vaultster VARCHAR(64)
   - pw VARCHAR(32)
   - dmpw VARCHAR (32)

   mixf_currentplayers
   - pcid VARCHAR(96)
   - server VARCHAR(32)
   - visiblename VARCHAR(64)
   - reachable BOOLEAN DEFAULT TRUE

   mixf_messages
   - pcid VARCHAR(96)
   - server VARCHAR(32)
   - type VARCHAR(32)
   - message TEXT
*/
#include "gs_inc_effect"
#include "gs_inc_pc"
#include "gs_inc_respawn"
#include "inc_summons"
#include "mi_inc_database"
#include "x0_i0_position"
const string MESSENGERS = "MESSENGERS"; // For logging
const string VAR_SERVER_NAME = "SERVER_NAME";

// IMPORTANT - if you add to this list, add a case to gs_inc_container to
// make the tags for the GS_INVENTORY containers unique for the new server.
// SERVER_UNDERDARK now includes Cordor.

// update Dunshine 20-9-2015, changed the value of SERVER_CORDOR to "2" to make it the same as the SERVER_UNDERDARK
// so any scripts involving the SERVER_CORDOR constant will now use the value of the combined server for this.
// old: const string SERVER_CORDOR = "3"; //Deprecated
const string SERVER_CORDOR = "2";   //same as underdark

const string SERVER_ISLAND = "1"; //surface
const string SERVER_UNDERDARK = "2"; //same as cordor
const string SERVER_PREHISTORY = "4";
const string SERVER_ARENA = "5";
const string SERVER_DISTSHORES = "8"; //Distant shores

const string MESSAGE_TYPE_SPEEDY = "XFER_MSG_SPEEDY";
const string MESSAGE_TYPE_GOBLIN = "XFER_MSG_GOBLIN";
const string MESSAGE_TYPE_HERALD = "XFER_MSG_HERALD";
const string MESSAGE_TYPE_IMAGE  = "XFER_MSG_IMAGE";
const string MESSAGE_TYPE_DMC    = "XFER_MSG_DM_CHANNEL";
const string MESSAGE_TYPE_TELL   = "XFER_MSG_TELL";  // TBD.

// Possible server states.
const int MI_XF_STATE_NOT_FOUND      = -1;
const int MI_XF_STATE_DOWN           = 0;
const int MI_XF_STATE_CRASHED        = 1;
const int MI_XF_STATE_REBOOT_CRASH   = 2;
const int MI_XF_STATE_REBOOT         = 3;
const int MI_XF_STATE_LIMBO          = 4;
const int MI_XF_STATE_RECOVERY       = 5;
const int MI_XF_STATE_SIG_REBOOT     = 6;
const int MI_XF_STATE_REQUEST_REBOOT = 7;
const int MI_XF_STATE_UP             = 8;

// Returns the name of the current server (should be one of the SERVER_*
// constants if the module is properly configured).
string miXFGetCurrentServer();
// Returns the human-readable name of sServer.
string miXFGetServerName(string sServer);
// Returns the state code of sServer. If sServer is not given, the current
// server is used.
int miXFGetState(string sServer = "");
// Sets the state code of sServer to nState. Normally only useful for setting
// the state of the current server.
void miXFSetState(int nState, string sServer = "");
// Sends a message of type sType to sPCID on sServer (SERVER_*)
void miXFSendMessage(string sPCID, string sServer, string sMessage, string sType);
// Delivers sMessage, playing the appropriate animations based on message type.
void miXFDeliverMessage(string sPCID, string sMessage, string sType);
// Check the database for active messages for this server and deliver them.
void miXFProcessMessages();
// Registers that oPC is playing on this server
void miXFRegisterPlayer(object oPC);
// Updates the player's visible name with this name
void miXFUpdatePlayerName(object oPC, string name);
// Updates the player's reachable state
void miFXUpdatePlayerReachable(object oPC, int state);
// Unregisters oPC from this server
void miXFUnregisterPlayer(object oPC);
// Used at startup - unregister all players on sServer (SERVER_*)
void miXFUnregisterAll();
// Portal oPC to sServer (SERVER_*).  Go to sTargetWaypoint. If sTargetWaypoint
// is set, we'll set the PC's saved position to 1,1,1 so that the other server
// knows not to send us back or jump them to their last known location.
void miXFDoPortal(object oPC, string sServer, string sTargetWaypoint = "");
// Returns a formatted text string showing who is logged on.
string miXFGetPlayerList();
// Marks the server as active.
void miXFRespond();

void _miXFDoPortal(object oPC, string sAddress, string sPassword)
{
  // Re-enabling portal-ing.
  // SendMessageToPC(oPC, "Portalling disabled for now.");

  if (!GetIsObjectValid(GetArea(oPC)))
  {
    DelayCommand(1.0, _miXFDoPortal(oPC, sAddress, sPassword));
  }
  else
  {
    SendMessageToPC(oPC, "Portalling...");
    DeleteLocalInt(oPC, "GS_ENABLED");
    DeleteLocalLocation(oPC, "GS_LOCATION");
    ActivateAssociateCooldowns(oPC);
    ActivatePortal(oPC, sAddress, sPassword, "", TRUE);
  }
}
//------------------------------------------------------------------------------
void _XFJumpToTarget(object oPC, object oTarget)
{
    AssignCommand(oPC, ClearAllActions(TRUE));
    AssignCommand(oPC, ActionJumpToObject(oTarget));
    AssignCommand(oPC, ActionDoCommand(SetCommandable(TRUE)));
    AssignCommand(oPC, SetCommandable(FALSE));
}
//------------------------------------------------------------------------------
string miXFGetCurrentServer()
{
  return GetLocalString(GetModule(), VAR_SERVER_NAME);
}
//------------------------------------------------------------------------------
string miXFGetServerName(string sServer)
{
  switch (StringToInt(sServer))
  {
    case 1:
      return "Arelith Surface";
    case 2:
      return "Cities and Planes";
    case 3:
      return "Cordor";
    case 4:
      return "Prehistory";
    case 5:
      return "Test";
  }
  return sServer;
}
//------------------------------------------------------------------------------
int miXFGetState(string sServer = "")
{
  if (sServer == "")
  {
    sServer = miXFGetCurrentServer();
  }

  string sResult = miDAGetKeyedValue("nwn.web_server", sServer, "state");

  if (sResult == "")
  {
    return MI_XF_STATE_NOT_FOUND;
  }

  return StringToInt(sResult);
}
//------------------------------------------------------------------------------
void miXFSetState(int nState, string sServer = "")
{
  if (sServer == "")
  {
    sServer = miXFGetCurrentServer();
  }

  miDASetKeyedValue("nwn.web_server", sServer, "state", IntToString(nState));
}
//------------------------------------------------------------------------------
void miXFDoPortal(object oPC, string sServer, string sTargetWaypoint = "")
{
  int bDM = GetIsDM(oPC);

  // Don't allow jumps between FL and main servers.
  if (sServer == "4" || miXFGetCurrentServer() == "4")
  {
    SendMessageToPC(oPC, "Tried to transfer between FL and regular servers.  Please report!");
    return;
  }
  else if (sServer == "3")
  {
    // Septire - We're merging the UD and Cordor servers, any existing references to the Cordor server
    // instead goes to the Underdark server, now named Cities and Planes.
    // This change was requested by Irongron so all existing server transitions to Cordor don't need to be revisited.
    sServer = "2";
  }
  // If sServer matches the current server, there's no need to do the portal. Just jump the player to their destination.
  else if (sServer == miXFGetCurrentServer())
  {
    // dunshine, check for Gender Change portals, since we do want to relog on the same server in that case
    if (GetLocalInt(oPC, "GVD_GENDER_CHANGE_PORTAL") != 1) {
      _XFJumpToTarget(oPC, GetObjectByTag(sTargetWaypoint));
      return;
    } else {
      DeleteLocalInt(oPC, "GVD_GENDER_CHANGE_PORTAL");
    }
  }

  // Save the destination on the PC's inventory item before exporting the char
  // (in PortalPC). Unpolymorph the creature first though or their creature
  // skin will be wrong.
  if (!bDM)
  {
    gsFXRemoveEffect(oPC, OBJECT_INVALID, EFFECT_TYPE_POLYMORPH);
    object oHide = gsPCGetCreatureHide(oPC);

    if (sTargetWaypoint != "")
    {
      SetLocalString(oHide, "DEST_WP", sTargetWaypoint);
      Log("ENTER", "Setting DEST_WP for " + GetName(oPC) + " to " + sTargetWaypoint);
    }

    // dunshine: handle lasso captures
    object oCapture = GetLocalObject(oPC, "gvd_lasso_capture");
    if (oCapture != OBJECT_INVALID) {
      // store resref, tag, name and HP of captured creature on PC hide, so we can retrieve it on the other server
      SetLocalString(oHide, "gvd_xfer_lasso_resref", GetResRef(oCapture));
      SetLocalString(oHide, "gvd_xfer_lasso_tag", GetTag(oCapture));
      SetLocalString(oHide, "gvd_xfer_lasso_name", GetName(oCapture));
      SetLocalInt(oHide, "gvd_xfer_lasso_hp", GetCurrentHitPoints(oCapture));
      SetLocalInt(oHide, "gvd_xfer_lasso_timestamp", GetLocalInt(oCapture, "gvd_lasso_timestamp"));
    } else {
      // shouldn't be necessary, but just to make sure
      DeleteLocalString(oHide, "gvd_xfer_lasso_resref");
      DeleteLocalString(oHide, "gvd_xfer_lasso_tag");
      DeleteLocalString(oHide, "gvd_xfer_lasso_name");
      DeleteLocalInt(oHide, "gvd_xfer_lasso_hp");
      DeleteLocalInt(oHide, "gvd_xfer_lasso_timestamp");
    }

    ExportSingleCharacter(oPC);
  }

  int nState      = miXFGetState(sServer);
  string sMessage = "";
  switch (nState)
  {
    case MI_XF_STATE_NOT_FOUND:
      sMessage = "((Error: Target server does not exist.))";
      break;
    case MI_XF_STATE_DOWN:
    case MI_XF_STATE_CRASHED:
      sMessage = "The way is blocked. ((OOC Note: The target server is down.))";
      break;
    case MI_XF_STATE_REBOOT_CRASH:
    case MI_XF_STATE_REBOOT:
    case MI_XF_STATE_LIMBO:
    case MI_XF_STATE_RECOVERY:
      if (!bDM) sMessage = "The way is blocked. ((OOC Note: The target server is not accepting players yet.))";
      break;
    case MI_XF_STATE_SIG_REBOOT:
    case MI_XF_STATE_REQUEST_REBOOT:
      if (!bDM) sMessage = "The way is blocked. ((OOC Note: The target server is just about to restart.))";
      break;
    case MI_XF_STATE_UP:
      break;
  }

  if (sMessage == "")
  {
    // Check that the server isn't full from here, unless oPC is a DM in which
    // case it doesn't matter.
    SQLExecStatement("SELECT CONCAT(s.pub_address, ':', s.port_nwn), o." +
     (bDM ? "dmpassword" : "playerpassword") + " FROM nwn.web_server AS s LEFT JOIN " +
     "nwn.web_server_settings AS o ON s.settings=o.id WHERE s.sid = ?" +
     (!bDM ? " AND o.maxclients > s.curr_players" : ""), sServer);

    if (!SQLFetch())
    {
      sMessage = "The way is blocked. ((OOC Note: The target server is full.))";
    }
    else
    {
      string sAddress  = SQLGetData(1);
      string sPassword = SQLGetData(2);
      Log("ENTER", "Portalling " + GetName(oPC) + " to server " + sServer + " using address " + sAddress);

      if (!GetIsDM(oPC))
      {
        SQLExecStatement("UPDATE gs_pc_data SET modified_server=? WHERE id=?",
         sServer, gsPCGetPlayerID(oPC));
      }

      sMessage = "Sending you to the " + sAddress + " server.";
      DelayCommand(0.5, _miXFDoPortal(oPC, sAddress, sPassword));
    }
  }

  if (sMessage != "")
  {
    SendMessageToPC(oPC, sMessage);
  }
}
// -----------------------------------------------------------------------------
void miXFSendMessage(string sPCID, string sServer, string sMessage, string sType)
{
  if (sPCID == "")
  {
    SQLExecStatement("INSERT INTO mixf_messages (server, message, type) VALUES (?,?,?)",
                     sServer, sMessage, sType);
  }
  else
  {
    SQLExecStatement("INSERT INTO mixf_messages (pcid, server, message, type) VALUES (?,?,?,?)",
                     sPCID, sServer, sMessage, sType);
  }
}
// -----------------------------------------------------------------------------
void miXFDeliverMessage(string sPCID, string sMessage, string sType)
{
  if (sType == MESSAGE_TYPE_SPEEDY || sType == MESSAGE_TYPE_GOBLIN || sType == MESSAGE_TYPE_HERALD)
  {
    string sResRef;
    if (sType == MESSAGE_TYPE_SPEEDY)
        sResRef = "mi_runner";
    else if (sType == MESSAGE_TYPE_HERALD)
        sResRef = "darrow_herald";
    else
        sResRef = "mi_gob_runner";


    object oTarget = gsPCGetPlayerByID(sPCID);
    if (!GetIsObjectValid(oTarget))
    {
      Error (MESSENGERS, "Could not find " + sPCID + " to deliver message.");
    }
    else
    {
      // string sResRef = bSpeedy ? "mi_runner" : "mi_gob_runner";
      object oRunner = CreateObject(OBJECT_TYPE_CREATURE,
                                    sResRef,
                                    GetAheadLocation(oTarget),
                                    TRUE);
      // For lag reasons, assign all delayed commands to the module and
      // don't use actionspeakstring.
      AssignCommand(GetModule(), DelayCommand(1.0, AssignCommand(oRunner, TurnToFaceObject(oTarget, oRunner))));
      AssignCommand(GetModule(), DelayCommand(1.0, AssignCommand(oRunner, SpeakString("*Runs up breathlessly*"))));
      AssignCommand(GetModule(), DelayCommand(3.0, AssignCommand(oRunner, SpeakString(sMessage))));
      AssignCommand(GetModule(), DelayCommand(10.0, AssignCommand(oRunner, SpeakString("*Dashes off*"))));
      AssignCommand(GetModule(), DelayCommand(11.0, DestroyObject(oRunner)));

      AssignCommand(GetModule(), DelayCommand(10.5, SendMessageToPC(oTarget, "The message was: " + sMessage)));
    }
  }
  else if (sType == MESSAGE_TYPE_IMAGE)
  {
    object oTarg = gsPCGetPlayerByID(sPCID);

    if (!GetIsObjectValid(oTarg))
    {
      Error (MESSENGERS, "Could not find " + sPCID + " to deliver message.");
    }
    else
    {
      object oGhost = CreateObject(OBJECT_TYPE_CREATURE,
                                   "mixf_ghost",
                                   GetAheadLocation(oTarg),
                                   TRUE);
      AssignCommand(GetModule(), DelayCommand(1.1, AssignCommand(oGhost, SetFacingPoint(GetPosition(oTarg)))));
      AssignCommand(GetModule(), DelayCommand(1.5, AssignCommand(oGhost, ActionSpeakString(
       "*A ghostly ball appears before you, shrouded in magic. It speaks.*"))));

      AssignCommand(GetModule(), DelayCommand(3.5, AssignCommand(oGhost, ActionSpeakString(sMessage))));
      AssignCommand(GetModule(), DelayCommand(9.5, AssignCommand(oGhost, ActionSpeakString(
                      "*As mysteriously as it appeared, the vision vanishes.*"))));
      AssignCommand(GetModule(), DelayCommand(10.0, DestroyObject(oGhost)));
      AssignCommand(GetModule(), DelayCommand(10.5, SendMessageToPC(oTarg, "The message was: " + sMessage)));
    }
  }
  else if (sType == MESSAGE_TYPE_DMC)
  {
    // Message is written in fb_inc_chat and includes PC name and server name.
    SendMessageToAllDMs(sMessage);
  }
  else
  {
    Error (MESSENGERS, "Unrecognised message type: " + sType);
  }
}
// -----------------------------------------------------------------------------
void miXFProcessMessages()
{
  string sServer = miXFGetCurrentServer();

  // Moved this earlier in the method to prevent breakage when there are too many messages.
  DelayCommand(1.0f, SQLExecStatement("DELETE FROM mixf_messages WHERE server=?", sServer));

  SQLExecStatement("SELECT pcid,message,type FROM mixf_messages WHERE server=?", sServer);
  while (SQLFetch())
  {
    miXFDeliverMessage(SQLGetData(1), SQLGetData(2), SQLGetData(3));
  }
}
// -----------------------------------------------------------------------------
void miXFRegisterPlayer(object oPC)
{
  string sServer = miXFGetCurrentServer();
  if (GetIsDM(oPC))
  {
    SQLExecStatement("UPDATE nwn.web_server SET curr_dms=curr_dms+1 WHERE sid=?", sServer);
  }
  else
  {
    SQLExecStatement("INSERT INTO nwn.mixf_currentplayers (pcid, server, visiblename,reachable) VALUES (?,?,?,TRUE)",
                     gsPCGetPlayerID(oPC), sServer, GetName(oPC));
    SQLExecStatement("UPDATE nwn.web_server SET curr_players=curr_players+1 WHERE sid=?", sServer);
    SetLocalInt(oPC, "Reachable", TRUE);
  }
  SetLocalInt(oPC, "MI_XF_REGISTERED", TRUE);
}
// -----------------------------------------------------------------------------
void miXFUpdatePlayerName(object oPC, string name)
{
  string server = miXFGetCurrentServer();
  if (GetIsDM(oPC))
  {
    return;
  }

  SQLExecStatement("UPDATE mixf_currentplayers SET visiblename=? WHERE server=? AND pcid=?", name, server, gsPCGetPlayerID(oPC));
}
// -----------------------------------------------------------------------------
void miFXUpdatePlayerReachable(object oPC, int state)
{
  string server = miXFGetCurrentServer();
  if (GetIsDM(oPC))
  {
    return;
  }
  SQLExecStatement("UPDATE mixf_currentplayers SET reachable=" + ((state) ? ("TRUE") : ("FALSE")) + " WHERE server=? AND pcid=?", server, gsPCGetPlayerID(oPC));
  SetLocalInt(oPC, "Reachable", state);
}
// -----------------------------------------------------------------------------
void miXFUnregisterPlayer(object oPC)
{
  // Avoid unregistering someone twice.
  if (!GetLocalInt(oPC, "MI_XF_REGISTERED")) return;

  string sServer = miXFGetCurrentServer();
  if (GetIsDM(oPC))
  {
    SQLExecStatement("UPDATE nwn.web_server SET curr_dms=curr_dms-1 WHERE sid=?", sServer);
  }
  else
  {
    SQLExecStatement("DELETE FROM nwn.mixf_currentplayers WHERE pcid=? AND server=?",
                     gsPCGetPlayerID(oPC), sServer);
    SQLExecStatement("UPDATE nwn.web_server SET curr_players=curr_players-1 WHERE sid=?", sServer);
  }
  SetLocalInt(oPC, "MI_XF_REGISTERED", FALSE);
}
// -----------------------------------------------------------------------------
void miXFUnregisterAll()
{
  string sServer = miXFGetCurrentServer();
  SQLExecStatement("DELETE FROM nwn.mixf_currentplayers WHERE server=?", sServer);
  SQLExecStatement("UPDATE nwn.web_server SET curr_players=0, curr_dms=0 WHERE sid=?", sServer);
}
// -----------------------------------------------------------------------------
string miXFGetPlayerList()
{
  SQLExecStatement("SELECT p.name, c.server FROM nwn.mixf_currentplayers AS c INNER JOIN" +
   " gs_pc_data AS p ON p.id = c.pcid ORDER BY c.server, p.name");
  string sPlayerList = "<c999>Player list:</c>";
  string sCurrentServer;
  string sServerList;
  int nPlayers   = 0;
  int bContinue  = SQLFetch();
  string sServer = bContinue ? SQLGetData(2) : "";

  // Iterate over each server.
  while (bContinue)
  {
    // Iterate over each player.
    do
    {
      sServerList += "\n" + SQLGetData(1) + " (" + sServer + ")";
      nPlayers++;
      bContinue = SQLFetch();
      if (bContinue)
      {
        sCurrentServer = SQLGetData(2);
      }
    } while (bContinue && sCurrentServer == sServer);

    // Dump the list we've just built into sPlayerList together with a header.
    sPlayerList += "\n==== " + (
      (sServer == SERVER_ISLAND) ? "Surface" :
      (sServer == SERVER_UNDERDARK) ? "Cities and Planes" :
      (sServer == SERVER_DISTSHORES) ? "Distant Shores" :
      "") + " (" + IntToString(nPlayers) + "/96) ====" + sServerList;

    sServerList = "";
    sServer     = sCurrentServer;
    nPlayers    = 0;
  }

  return sPlayerList;
}
// -----------------------------------------------------------------------------
void miXFRespond()
{
  SQLExecStatement("UPDATE nwn.web_server SET response=UNIX_TIMESTAMP() WHERE sid=?",
   miXFGetCurrentServer());
}
