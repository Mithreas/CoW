/* PC Library by Gigaschatten */
#include "inc_time"
#include "inc_database"
#include "nwnx_admin"
#include "nwnx_player"
//void main() {}

// Database table needs to have the following columns:
/*
   gs_player_data
   row_key             VARCHAR(16)  (stores CD key)
   rp                  TINYINT(2)

   gs_pc_data
   row_key             VARCHAR(64)    (stores PCID)
   bank                INT(11)
   c1                  TINYINT(2)
   c2                  TINYINT(2)
   c3                  TINYINT(2)
   c4                  TINYINT(2)
   c5                  TINYINT(2)
   c6                  TINYINT(2)
   c_timeout           INT(11)
   c_points            TINYINT(2)
   current_location    VARCHAR(64)
   respawn_location    VARCHAR(64)
   subrace_applied     TINYINT(2)
   nation              VARCHAR(64) (see inc_citizen)
   awia                TINYINT(2)

   fb_ban_nodes
   bn_id               INT(11)      (primary key)
   bn_type             TINYINT(1)   (0 = cdkey, 1 = playername, 2 = ip)
   bn_data             VARCHAR(64)  (cdkey/playername/ip)

   fb_ban_groups
   bg_id               INT(11)      (primary key)
   bg_timestamp        INT(11)      (time created)
   bg_useip            TINYINT(1)   (0 = don't enforce IP ban, 1 = do enforce)
   bg_lock             VARCHAR(64)  (null = unlocked, otherwise locked by dm x)
   bg_description      VARCHAR(255) (something meaningful, defaults to the
                                     playername of the first account banned)
   fb_ban_links
   bl_node             INT(11)      (link to fb_ban_nodes)
   bl_group            INT(11)      (link to fb_ban_groups)


   gs_player_map_data
   arearesref          VARCHAR(16)
   pcid                INT(11)
   mapdata             VARCHAR(256)
*/

//return unique id of oPC
string gsPCGetPlayerID(object oPC);
//return old-style unique id of oPC (do not use in new code)
string gsPCGetLegacyID(object oPC);
//returns unique id for migration purposes between 1.69 and EE edition
string gsPCGetMigrationID(object oPC); 
//return unique id of the CD key sCDKey, inserting it if not already recorded
string gsPCGetCDKeyID(string sCDKey);
//return a PC's name from their PC ID
string gsPCGetPlayerName(string sID);
//return player by sID
object gsPCGetPlayerByID(string sID);
//return player by sCDKey
object gsPCGetPlayerByCDKey(string sCDKey);
//return TRUE if sCDKey belongs to sID
int gsPCGetIsPlayerEqual(string sCDKey, string sID);
//return roleplay state of oPC (0-100)
int gsPCGetRolePlay(object oPC);
//set roleplay state of oPC to nState (0-100)
void gsPCSetRolePlay(object oPC, int nState);
// Get the last time this player voted on any PC.
int gsPCGetLastVote(object oPC);
// Set the PC's player's last vote time.
void gsPCSetLastVote(object oPC, int nTimestamp);
//memorize class data of oPC
void gsPCMemorizeClassData(object oPC = OBJECT_SELF);
//return memorized class type at nPosition of oPC
int gsPCGetMemorizedClassType(int nPosition, object oPC = OBJECT_SELF);
//return memorized class level at nPosition of oPC
int gsPCGetMemorizedClassLevel(int nPosition, object oPC = OBJECT_SELF);
// Pre-cache character information to save on database reads later.  Call in
// OnClientEnter.
void gsPCCacheValues(object oPC);
// Save oPC's location in the database as lLocation
void gsPCSavePCLocation(object oPC, location lLocation);
// Retrieve oPC's saved database location
location gsPCGetSavedLocation(object oPC);
// Backs up the PC's current locally saved location
void gsPCBackupPCLocation(object oPC);
// Restores the PC's current locally saved location - retrieve with
// gsPCGetSavedLocation().
void gsPCRestorePCLocation(object oPC);
// Returns TRUE if oPC, sKey, sPlayerName or sIP are banned, FALSE otherwise.
// Only one field is required.
int gsPCGetIsPlayerBanned(object oPC = OBJECT_INVALID, string sKey = "", string sPlayerName = "", string sIP = "");
// Bans a player by account name and/or player name. If bIncludeIP is TRUE, will
// also enforce an IP ban as well. A ban is implemented using as much information
// as has been given, so if only the CD key is valid, the CD key can be banned,
// and other information will be stored if the player tries to log in using this
// key later.
void gsPCBanPlayer(object oPC = OBJECT_INVALID, int bIncludeIP = FALSE, string sKey = "", string sPlayerName = "", string sIP = "");
// Gets the PC's creature hide.  Usually this will be in their CARMOUR slot, but
// not if they're polymorphed.
object gsPCGetCreatureHide(object oPC = OBJECT_SELF);
//return old 1.69 CD key that is tied to the EE (1.74+) CD key sEEKey
string gsPCGetOldCDKey(string sEEKey);
// transfer RPR and Awards from old sCDKey to new sEEKey
void gsPCMigratePlayerData(string sCDKey, string sEEKey);
// Save minimap progress
void gsPCSaveMap(object oPC, object oArea);
// Load minimap progress
void gsPCLoadMap(object oPC, object oArea);

// Get all information for this PC. Stored in MySQL.  Updated every login (as
// might have changed on a different server).
void gsPCCacheValues(object oPC)
{
  // Bank account
  // Craft skills
  // Location
  // Respawn point
  SQLExecStatement("SELECT a.bank, a.c1, a.c2, a.c3, a.c4, a.c5, a.c6, a.c_timeout, " +
    "a.c_points, a.current_location, a.respawn_location, a.subrace_applied, a.nation, " +
    "a.awia, a.subrace, b.id, b.cdkey, b.rp, b.lastvote, a.deleted FROM gs_pc_data AS a LEFT JOIN gs_player_data AS b ON " +
    "b.id = a.keydata WHERE a.id = ? LIMIT 1", gsPCGetPlayerID(oPC));

  if (SQLFetch())
  {

    if(SQLGetData(20) == "1")
    {
        NWNX_Administration_DeletePlayerCharacter(oPC);
        DelayCommand(5.0, JumpToObject(GetWaypointByTag("WP_DELETED"), 0));
        return;
    }
    // entry exists, populate it.
    // No need to make stuff unsafe, all values are tags or numbers
    SetLocalInt(oPC, "GS_FINANCE",     StringToInt(SQLGetData(1)));
    // Craft skills need to be set to -1 if they're 0.
    int skill = 1;
    for (skill = 1; skill <=6; skill++)
    {
      int rank = StringToInt(SQLGetData(skill+1));
      if (rank == 0) rank = -1;
      SetLocalInt(oPC, "GS_CR_SKILL_" + IntToString(skill), rank);
    }
    SetLocalInt(oPC, "GS_CR_CRAFT_TIMEOUT", StringToInt(SQLGetData(8)));
    // Craft points need to be set to -1 if they're 0.
    int points = StringToInt(SQLGetData(9));
    if (points == 0) points = -1;
    SetLocalInt(oPC, "GS_CR_CRAFT_POINTS",  points);
    SetLocalLocation(oPC, "GS_LOCATION",    APSStringToLocation(SQLGetData(10)));
    SetLocalLocation(oPC, "GS_RESPAWN",     APSStringToLocation(SQLGetData(11)));
    SetLocalInt(oPC, "GS_SU_APPLIED",  StringToInt(SQLGetData(12)));
    SetLocalString(oPC, "MI_NATION", SQLGetData(13));
    SetLocalInt(oPC, "MI_AWIA", StringToInt(SQLGetData(14)));

    SetLocalString(oPC, "CDKEY_ID", SQLGetData(16));
    SetLocalString(oPC, "CDKEY_RECORDED", SQLGetData(17));
    SetLocalInt(oPC, "GS_PC_ROLEPLAY", StringToInt(SQLGetData(18)));
    SetLocalInt(oPC, "MI_CZ_LASTVOTE", StringToInt(SQLGetData(19)));

    // Add the PC's race etc.
    ExecuteScript("mi_dv_setup", oPC);

    // Dunshine: cache the explorarion areas for this PC as well

    // make sure the string length returned by group_concat can grow big enough
    SQLExecStatement("SET SESSION group_concat_max_len = 1000000");

    // first for areas (seperate table)
    SQLExecStatement("SELECT group_concat(area_id) FROM gvd_area_pc WHERE pc_id = ?", gsPCGetPlayerID(oPC));

    if (SQLFetch()) {
      // store concatenated string of area id's as variable on the PC 
      SetLocalString(oPC, "GVD_XP_AREAS", "," + SQLGetData(1) + ",");
    }

    // now for the other generic exploration stuff  
    SQLExecStatement("SELECT object_type, group_concat(object_id) FROM gvd_adv_xp_pc WHERE pc_id = ? GROUP BY object_type", gsPCGetPlayerID(oPC));

    while (SQLFetch()) {
      // store concatenated string of object id's as variable on the PC
      SetLocalString(oPC, "GVD_XP_" + SQLGetData(1), "," + SQLGetData(2) + ",");
    }
  }
}
//----------------------------------------------------------------
string gsPCGetPlayerID(object oPC)
{
  // if (!GetIsPC(oPC)) return ""; - can't do this, GetIsPC returns False while a PC is exiting.
  
  string sID = GetLocalString(oPC, "GS_PC_ID");

  // Transfer ID to persistent storage on creature hide if necessary.
  if (GetLocalInt(oPC, "GS_PC_ID_TEMP"))
  {
    object oHide = gsPCGetCreatureHide(oPC);
    if (GetIsObjectValid(oHide))
    {
      SetLocalString(oHide, "GS_PC_ID", sID);
      DeleteLocalInt(oPC, "GS_PC_ID_TEMP");
    }
  }

  if (sID == "" && GetIsObjectValid(oPC) && GetIsPC(oPC) && !GetIsDM(oPC))
  {
    object oHide = gsPCGetCreatureHide(oPC);
    if (!GetIsObjectValid(oHide))
    {
      oHide = oPC;
      SetLocalInt(oPC, "GS_PC_ID_TEMP", TRUE);
    }

    sID = GetLocalString(oHide, "GS_PC_ID");

    // No ID found anywhere - must be a new PC.
    if (sID == "")
    {
      string sCDKey   = GetPCPublicCDKey(oPC);
      string sCDKeyID = gsPCGetCDKeyID(sCDKey);

      // Migration!! Check for missing playername first. --[
      string sLegacyName = GetName(oPC);
      if (GetStringLength(sLegacyName) > 23)
      {
        sLegacyName = GetStringLeft(sLegacyName, 23);
      }

      SQLExecStatement("SELECT a.id FROM gs_pc_data AS a INNER JOIN " +
       "gs_player_data AS b ON a.keydata=b.id WHERE a.name=? AND b.cdkey=? AND " +
       "a.playername IS NULL", sLegacyName, sCDKey);
      if (SQLFetch())
      {
        sID = SQLGetData(1);
        SQLExecStatement("UPDATE gs_pc_data SET name=?, playername=? WHERE id=?",
         GetName(oPC), GetPCPlayerName(oPC), sID);
        SetLocalString(oHide, "GS_PC_ID", sID);
      }
      else
      {

      // ]--

      SQLExecStatement("INSERT INTO gs_pc_data (name, playername, keydata) VALUES (?, ?, ?)",
        GetName(oPC), GetPCPlayerName(oPC), sCDKeyID);

      // Get the ID of the row just inserted.
      SQLExecStatement("SELECT id FROM gs_pc_data ORDER BY id DESC LIMIT 1");
      SQLFetch();
      sID = SQLGetData(1);
      SetLocalString(oHide, "GS_PC_ID", sID);

      // --[
      }
      // ]--
      // Save our changes.
      ExportSingleCharacter(oPC);
    }

    SetLocalString(oPC, "GS_PC_ID", sID);
  }

  return sID;
}
//----------------------------------------------------------------
string gsPCGetLegacyID(object oPC)
{
  if (!GetIsObjectValid(oPC) || !GetIsPC(oPC)) return "";
  return GetStringLeft(GetPCPublicCDKey(oPC, TRUE) + "_" + GetName(oPC), 32);
}

string gsPCGetMigrationID(object oPC) 
{
  if (!GetIsObjectValid(oPC) || !GetIsPC(oPC)) return "";

  SQLExecStatement("SELECT cdkey169 FROM gs_player_data WHERE cdkey=?", GetPCPublicCDKey(oPC, TRUE));
  string sPCID = "";
  
  if (SQLFetch() && SQLGetData(1) != "") {
    sPCID = SQLGetData(1);
    sPCID = GetStringLeft(sPCID + "_" + GetName(oPC), 32);
  } else {
    sPCID = gsPCGetLegacyID(oPC);
  }

  return sPCID; 
}

//----------------------------------------------------------------
string gsPCGetCDKeyID(string sCDKey)
{
  string sStmt = SQLPrepareStatement("SELECT id FROM gs_player_data WHERE cdkey = ?", sCDKey);
  SQLExecStatement(sStmt);

  if (SQLFetch())
  {
    return SQLGetData(1);
  }

  SQLExecStatement("INSERT INTO gs_player_data (cdkey, rp) VALUES (?, 11)", sCDKey);
  SQLExecStatement(sStmt);

  if (SQLFetch())
  {
    return SQLGetData(1);
  }

  return "";
}
//----------------------------------------------------------------
string gsPCGetPlayerName(string sID)
{
  SQLExecStatement("SELECT name FROM gs_pc_data WHERE id = ?", sID);

  if (SQLFetch())
  {
    return SQLGetData(1);
  }

  return "";

// TODO
/*  // Nations don't have a CD key at the beginning of their ID.
  if (FindSubString(sID, "_") == 8)
    return GetStringRight(sID, GetStringLength(sID) - 9);
  else
    return sID;*/
}
//----------------------------------------------------------------
object gsPCGetPlayerByID(string sID)
{
  // Sanity check.
  if (IntToString(StringToInt(sID)) != sID) return OBJECT_INVALID;

  object oPC = GetFirstPC();

  while (GetIsObjectValid(oPC))
  {
      if (gsPCGetPlayerID(oPC) == sID) return oPC;

      oPC = GetNextPC();
  }

  return OBJECT_INVALID;
}
//----------------------------------------------------------------
object gsPCGetPlayerByCDKey(string sCDKey)
{
    object oPC = GetFirstPC();

    while (GetIsObjectValid(oPC))
    {
        if (GetPCPublicCDKey(oPC, TRUE) == sCDKey) return oPC;

        oPC = GetNextPC();
    }

    return OBJECT_INVALID;
}
//----------------------------------------------------------------
int gsPCGetIsPlayerEqual(string sCDKey, string sID)
{
  SQLExecStatement("SELECT 1 FROM gs_pc_data AS a INNER JOIN gs_player_data AS b " +
    "ON a.keydata = b.id WHERE a.id = ? AND b.cdkey = ?", sID, sCDKey);

  return SQLFetch();
}
//----------------------------------------------------------------
int gsPCGetRolePlay(object oPC)
{
  if (GetIsPossessedFamiliar(oPC)) oPC = GetMaster(oPC);
  if (!GetIsPC(oPC) || GetIsDM(oPC) || GetIsDMPossessed(oPC)) return FALSE;

  int nState = GetLocalInt(oPC, "GS_PC_ROLEPLAY");

  // Not saved on the PC - try hitting the database.
  if (!nState)
  {
    string sCDKey = GetPCPublicCDKey(oPC);

    SQLExecStatement("SELECT rp FROM gs_player_data WHERE cdkey = ? LIMIT 1", sCDKey);

    if (SQLFetch())
    {
      nState = StringToInt(SQLGetData(1));
    }
    else
    {
      SQLExecStatement("INSERT INTO gs_player_data (cdkey, rp) VALUES (?, 11)", sCDKey);
      nState = 1;
    }

    SetLocalInt(oPC, "GS_PC_ROLEPLAY", nState);
  }

  return nState - 1;
}
//----------------------------------------------------------------
void gsPCSetRolePlay(object oPC, int nState)
{
  if (GetIsPossessedFamiliar(oPC)) oPC = GetMaster(oPC);
  if (!GetIsPC(oPC) || GetIsDM(oPC) || GetIsDMPossessed(oPC)) return;

  nState += 1;

  if (nState < 1)        nState =   1;
  else if (nState > 101) nState = 101;

  SetLocalInt(oPC, "GS_PC_ROLEPLAY", nState);
  miDASetKeyedValue("gs_player_data", GetLocalString(oPC, "CDKEY_RECORDED"), "rp", IntToString(nState), "cdkey");
}
//----------------------------------------------------------------
int gsPCGetLastVote(object oPC)
{
  if (GetIsPossessedFamiliar(oPC)) oPC = GetMaster(oPC);
  if (!GetIsPC(oPC) || GetIsDM(oPC) || GetIsDMPossessed(oPC)) return 0;

  return GetLocalInt(oPC, "MI_CZ_LASTVOTE");
}
//----------------------------------------------------------------
void gsPCSetLastVote(object oPC, int nTimestamp)
{
  if (GetIsPossessedFamiliar(oPC)) oPC = GetMaster(oPC);
  if (!GetIsPC(oPC) || GetIsDM(oPC) || GetIsDMPossessed(oPC)) return;

  SetLocalInt(oPC, "MI_CZ_LASTVOTE", nTimestamp);
  miDASetKeyedValue("gs_player_data", GetLocalString(oPC, "CDKEY_RECORDED"), "lastvote", IntToString(nTimestamp), "cdkey");
}
//----------------------------------------------------------------
void gsPCMemorizeClassData(object oPC = OBJECT_SELF)
{
    int nClass = GetClassByPosition(1, oPC);
    SetLocalInt(oPC, "GS_PC_CLASS_TYPE_1",  nClass);
    SetLocalInt(oPC, "GS_PC_CLASS_LEVEL_1", GetLevelByClass(nClass, oPC));

    nClass     = GetClassByPosition(2, oPC);
    if (nClass == CLASS_TYPE_INVALID)
    {
        DeleteLocalInt(oPC, "GS_PC_CLASS_TYPE_2");
        DeleteLocalInt(oPC, "GS_PC_CLASS_LEVEL_2");

    }
    else
    {
        SetLocalInt(oPC, "GS_PC_CLASS_TYPE_2",  nClass);
        SetLocalInt(oPC, "GS_PC_CLASS_LEVEL_2", GetLevelByClass(nClass, oPC));

    }

    nClass     = GetClassByPosition(3, oPC);
    if (nClass == CLASS_TYPE_INVALID)
    {
        DeleteLocalInt(oPC, "GS_PC_CLASS_TYPE_3");
        DeleteLocalInt(oPC, "GS_PC_CLASS_LEVEL_3");

    }
    else
    {
        SetLocalInt(oPC, "GS_PC_CLASS_TYPE_3",  nClass);
        SetLocalInt(oPC, "GS_PC_CLASS_LEVEL_3", GetLevelByClass(nClass, oPC));

    }
}
//----------------------------------------------------------------
int gsPCGetMemorizedClassType(int nPosition, object oPC = OBJECT_SELF)
{
    return GetLocalInt(oPC, "GS_PC_CLASS_TYPE_" + IntToString(nPosition));
}
//----------------------------------------------------------------
int gsPCGetMemorizedClassLevel(int nPosition, object oPC = OBJECT_SELF)
{
    return GetLocalInt(oPC, "GS_PC_CLASS_LEVEL_" + IntToString(nPosition));
}
//----------------------------------------------------------------
void gsPCSavePCLocation(object oPC, location lLocation)
{
  miDASetKeyedValue("gs_pc_data", gsPCGetPlayerID(oPC), "current_location", APSLocationToString(lLocation));
  SetLocalLocation(oPC, "GS_LOCATION", lLocation);
}
//----------------------------------------------------------------
location gsPCGetSavedLocation(object oPC)
{
  // Set up in gs_m_enter by the call to gsPCCacheValues.
  return (GetLocalLocation(oPC, "GS_LOCATION"));
}
//----------------------------------------------------------------
void gsPCBackupPCLocation(object oPC)
{
  SetLocalLocation(oPC, "GS_BACKUP_LOCATION", GetLocalLocation(oPC, "GS_LOCATION"));
}
//----------------------------------------------------------------
void gsPCRestorePCLocation(object oPC)
{
  SetLocalLocation(oPC, "GS_LOCATION", GetLocalLocation(oPC, "GS_BACKUP_LOCATION"));
}
//----------------------------------------------------------------
int gsPCGetIsPlayerBanned(object oPC = OBJECT_INVALID, string sKey = "", string sPlayerName = "", string sIP = "")
{
  if (GetIsObjectValid(oPC) && GetIsPC(oPC))
  {
    sKey        = GetPCPublicCDKey(oPC);
    sPlayerName = GetPCPlayerName(oPC);
    sIP         = GetPCIPAddress(oPC);
  }

  // Check if sKey, sPlayerName or sIP exist in the nodes database. We really
  // couldn't care less if it's the right data type or not - sKey and sIP both
  // have fixed formats and if sPlayerName is identical to the key/ip of another
  // banned player... well, obviously they've got to be related somehow. If sIP
  // is listed, also check to see if we enforce IP bans on this person or not.
  SQLExecStatement("SELECT 1 FROM fb_ban_nodes AS n INNER JOIN fb_ban_links AS " +
   "l ON n.bn_id=l.bl_node INNER JOIN fb_ban_groups AS g ON g.bg_id=l.bl_group " +
   "WHERE n.bn_data=? OR n.bn_data=? OR (n.bn_data=? AND g.bg_useip='1')", sKey,
   sPlayerName, sIP);

  return SQLFetch();
}
//----------------------------------------------------------------
string _gsPCBanPlayer(string sType, string sData)
{
  string sSQL = SQLPrepareStatement("SELECT bn_id FROM fb_ban_nodes WHERE " +
   "bn_type=? AND bn_data=?", sType, sData);
  SQLExecDirect(sSQL);
  if (SQLFetch())
  {
    return SQLGetData(1);
  }
  else
  {
    SQLExecStatement("INSERT INTO fb_ban_nodes(bn_type, bn_data) VALUES(?, ?)",
     sType, sData);
    SQLExecDirect(sSQL);
    if (SQLFetch())
    {
      return SQLGetData(1);
    }
  }

  return "";
}
//----------------------------------------------------------------
void gsPCBanPlayer(object oPC = OBJECT_INVALID, int bIncludeIP = FALSE, string sKey = "", string sPlayerName = "", string sIP = "")
{
  if (GetIsObjectValid(oPC) && GetIsPC(oPC))
  {
    sKey        = GetPCPublicCDKey(oPC);
    sPlayerName = GetPCPlayerName(oPC);
    sIP         = GetPCIPAddress(oPC);
  }

  // Save the parser a little work by doing this early.
  sPlayerName = SQLEncodeSpecialChars(sPlayerName);

  string sNodeKey;
  string sNodePlayername;
  string sNodeIP;

  string sSQL;

  // Make sure each part is banned. Don't worry about the IP here - it'll be
  // dealt with in the ban testing code.
  if (sKey != "")
  {
    sNodeKey = _gsPCBanPlayer("0", sKey);
  }
  if (sPlayerName != "")
  {
    sNodePlayername = _gsPCBanPlayer("1", sPlayerName);
  }
  if (sIP != "")
  {
    sNodeIP = _gsPCBanPlayer("2", sIP);
  }

  string sNode  = "";
  string sGroup = "";

  // Find existing groups and form links (usually called by players returning
  // from a ban getting themselves kicked out straight away, but sometimes
  // entries are added to the group too).
  SQLExecStatement("SELECT bl_node, bl_group FROM fb_ban_links WHERE bl_node=?" +
   " OR bl_node=? OR bl_node=? ORDER BY bl_node ASC", sNodeKey, sNodePlayername, sNodeIP);
  while (SQLFetch())
  {
    sNode = SQLGetData(1);
    sSQL  = SQLGetData(2);
    if (sGroup == "")
    {
      sGroup = sSQL;
    }
    else if (sGroup != sSQL)
    {
      SQLExecStatement("UPDATE fb_ban_links SET bl_group=? WHERE bl_group=?",
       sGroup, sSQL);

      // Transfer over use IP status if necessary
      SQLExecStatement("SELECT 1 FROM fb_ban_groups WHERE bg_id=? AND bg_useip='1'",
       sSQL);
      if (SQLFetch())
      {
        SQLExecStatement("UPDATE fb_ban_groups SET bg_useip='1' WHERE bg_id=?",
         sGroup);
      }
    }

    if (sNode == sNodeKey)
    {
      sNodeKey = "";
    }
    if (sNode == sNodePlayername)
    {
      sNodePlayername = "";
    }
    if (sNode == sNodeIP)
    {
      sNodeIP = "";
    }
  }

  // Stop if we're done
  if (sNodeKey == "" && sNodePlayername == "" && sNodeIP == "")
  {
    return;
  }

  // Create a group if needed. This should only be reached in the case of a new
  // ban.
  if (sGroup == "")
  {
    string sTimestamp = IntToString(gsTIGetActualTimestamp());
    SQLExecStatement("INSERT INTO fb_ban_groups(bg_timestamp, bg_useip, bg_description)" +
     " VALUES(?, ?, ?)", sTimestamp, (bIncludeIP ? "1" : "0"), sPlayerName);

    SQLExecStatement("SELECT bg_id FROM fb_ban_groups WHERE bg_timestamp=? " +
     "ORDER BY bg_id DESC LIMIT 1", sTimestamp);
    SQLFetch();
    sGroup = SQLGetData(1);
  }

  if (sNodeKey != "")
  {
    SQLExecStatement("INSERT INTO fb_ban_links(bl_node, bl_group) VALUES(?, ?)",
     sNodeKey, sGroup);
  }
  if (sNodePlayername != "")
  {
    SQLExecStatement("INSERT INTO fb_ban_links(bl_node, bl_group) VALUES(?, ?)",
     sNodePlayername, sGroup);
  }
  if (sNodeIP != "")
  {
    SQLExecStatement("INSERT INTO fb_ban_links(bl_node, bl_group) VALUES(?, ?)",
     sNodeIP, sGroup);
  }
}
//------------------------------------------------------------------------------
object gsPCGetCreatureHide(object oPC = OBJECT_SELF)
{
  if (!GetIsPC(oPC)) return oPC; // Use the NPC themselves for anything that isn't a PC.
  object oHide = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
  object oReturn;
  // Copying this here is a gross hack. 
  string GS_SU_TEMPLATE_PROPERTY      = "gs_item317";

  if (GetTag(oHide) == "GS_SU_PROPERTY")
  {
    SetLocalObject(oPC, "GS_HIDE", oHide);
    oReturn = oHide;
  }
  else if (GetIsObjectValid(GetLocalObject(oPC, "GS_HIDE")))
  {
     oReturn = GetLocalObject (oPC, "GS_HIDE");
  }
  else oReturn = GetItemPossessedBy(oPC, "GS_SU_PROPERTY");
  
  if (!GetIsObjectValid(oReturn))
  {
    oReturn = CreateItemOnObject(GS_SU_TEMPLATE_PROPERTY, oPC);

    if (GetIsObjectValid(oReturn))
    {
        AssignCommand(oPC, ActionEquipItem(oReturn, INVENTORY_SLOT_CARMOUR));
    }
  }
  
  return oReturn;
}

string gsPCGetOldCDKey(string sEEKey) {

  // Dunshine: addded cdkey != as well here, once a playername is tied to both cdkey and eekey and the player updates or changes the eekey
  // in the forum control panel the eekey field will be filled for all records in gs_player_data tied to that playername
  // so both the old 1.69 cdkey and the new 1.74 cdkey records will end up having their eekey field filled.
  // to make sure we only grab the old one and never the current one, we'll exclude eekey being equal to cdkey
  string sStmt = SQLPrepareStatement("SELECT cdkey FROM gs_player_data WHERE (eekey = ?) AND (cdkey != ?)", sEEKey, sEEKey);
  SQLExecStatement(sStmt);

  if (SQLFetch())
  {
    string sCDKey = SQLGetData(1);

    // old cdkey found, check here if we have to transfer RPR and Awards (we do this only once)
    // disable this until we fully migrate regulith to ee, to prevent tracking and updating RPR and Awards on multiple player id's
    // gsPCMigratePlayerData(sCDKey, sEEKey);

    return sCDKey;
  }

  return "";

}

void gsPCMigratePlayerData(string sCDKey, string sEEKey) {

  // check if the migration wasn't done already, eekey field will be filled on the eekey record itself
  // might want to add another field in the db for this later, since people can update the eekey field in the control panel
  // after they've tied playername to eekey, and then the eekey field will be filled as well, without this function
  // triggering the migration
  string sStmt = SQLPrepareStatement("SELECT eekey FROM gs_player_data WHERE (cdkey != ?)", sEEKey);
  SQLExecStatement(sStmt);

  if (SQLFetch()) {
    // eekey field still empty?
    if (SQLGetData(1) == "") {
      // this means migration has not been done, do it now and fill eekey field to make sure it won't be executed again later
      SQLPrepareStatement("UPDATE gs_player_data new INNER JOIN gs_player_data old ON (new.cdkey = old.eekey) SET new.eekey = new.cdkey, new.rp = old.rp, new.tells = old.tells, new.award1 = old.award1, new.award1_5 = old.award1_5, new.award2 = old.award2, new.award3 = old.award3 WHERE (new.cdkey = ?)", sEEKey);
      SQLExecStatement(sStmt);
    }
  }

}

string _gsPCGetMapData(object oPC, object oArea)
{
    SQLExecStatement("SELECT mapdata FROM gs_player_map_data WHERE pcid=? AND arearesref=?", gsPCGetPlayerID(oPC), GetResRef(oArea));
    if (!SQLFetch()) return "";
    return SQLGetData(1);
}

// Save minimap progress
void gsPCSaveMap(object oPC, object oArea)
{
  if (GetIsDM(oPC) || GetIsDMPossessed(oPC) || gsPCGetPlayerID(oPC) == "") return;
  string sMapData = NWNX_Player_GetAreaExplorationState(oPC, oArea);

  if (_gsPCGetMapData(oPC, oArea) == "")
  {  
    SQLExecStatement(SQLPrepareStatement("INSERT INTO gs_player_map_data (pcid, arearesref, mapdata) VALUES (?,?,?)", gsPCGetPlayerID(oPC), GetResRef(oArea), sMapData)); 
  }
  else
  {
    SQLExecStatement(SQLPrepareStatement("UPDATE gs_player_map_data SET mapdata=? WHERE pcid=? AND arearesref=?", sMapData, gsPCGetPlayerID(oPC), GetResRef(oArea))); 
  }
}
// Load minimap progress
void gsPCLoadMap(object oPC, object oArea)
{
  if (GetIsDM(oPC) || GetIsDMPossessed(oPC)) return;
  NWNX_Player_SetAreaExplorationState(oPC, oArea, _gsPCGetMapData(oPC, oArea));
}