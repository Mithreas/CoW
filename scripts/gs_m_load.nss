#include "__server_config"
#include "fb_inc_chatalias"
#include "fb_inc_chatutils"
#include "gs_inc_ambience"
#include "gs_inc_container"
#include "gs_inc_time"
#include "gs_inc_worship"
#include "inc_loot"
#include "mi_inc_ranks"
#include "mi_inc_database"
#include "mi_inc_divinatio"
#include "mi_inc_factions"
#include "mi_inc_xfer"
#include "nwnx_admin"
#include "nwnx_alts"
#include "nwnx_chat"
#include "nwnx_events"
#include "nwnx_alts"
#include "gs_inc_area"
#include "inc_landbroker"

void DropPassword()
{
    NWNX_Administration_ClearPlayerPassword();

    string curServer = miXFGetCurrentServer();
    SQLExecStatement("SELECT state from nwn.web_server WHERE sid=?", curServer);

    if (SQLFetch())
    {
        int STATE_RECOVERY = 5;
        int STATE_UP = 8;

        if (StringToInt(SQLGetData(1)) == STATE_RECOVERY) // Waiting for password to drop
        {
            SQLExecStatement("UPDATE nwn.web_server SET state=? WHERE sid=?", IntToString(STATE_UP), curServer);
        }
    }
}

void md_DoWeaponSpecific()
{
    SetWeaponIsMonkWeapon(BASE_ITEM_QUARTERSTAFF, 1);
    SetWeaponIsMonkWeapon(BASE_ITEM_SHURIKEN, 1);
    SetWeaponFinesseSize(BASE_ITEM_QUARTERSTAFF, CREATURE_SIZE_MEDIUM);
    SetWeaponFinesseSize(BASE_ITEM_KATANA, CREATURE_SIZE_MEDIUM);
    SetWeaponFinesseSize(BASE_ITEM_RAPIER, CREATURE_SIZE_MEDIUM);
    //SetWeaponOverwhelmingCriticalFeat(BASE_ITEM_TRIDENT, FEAT_EPIC_OVERWHELMING_CRITICAL_TRIDENT);
    //SetWeaponFocusFeat(BASE_ITEM_TRIDENT, FEAT_WEAPON_FOCUS_TRIDENT);
    //SetWeaponEpicFocusFeat(BASE_ITEM_TRIDENT, FEAT_EPIC_WEAPON_FOCUS_TRIDENT);
   // SetWeaponSpecializationFeat(BASE_ITEM_TRIDENT, FEAT_WEAPON_SPECIALIZATION_TRIDENT);
   // SetWeaponEpicSpecializationFeat(BASE_ITEM_TRIDENT, FEAT_EPIC_WEAPON_SPECIALIZATION_TRIDENT);
   // SetWeaponImprovedCriticalFeat(BASE_ITEM_TRIDENT, FEAT_IMPROVED_CRITICAL_TRIDENT);
   // SetWeaponOfChoiceFeat(BASE_ITEM_TRIDENT, FEAT_WEAPON_OF_CHOICE_TRIDENT);
}

void LoadJewelryChest()
{
    string sTag = "mo_jeweltreas";
    object oChest = GetObjectByTag(sTag);
    int nLimit = GetLocalInt(oChest, "GS_LIMIT");

    if (! nLimit) nLimit = GS_LIMIT_DEFAULT;
    gsCOLoad(sTag, oChest, nLimit);
    SetLocalInt(oChest, "GS_ENABLED", TRUE);

}

void MigrateBioDB2MySQL_ContainerData(string sContainer) {

  // just convert all to uppercase, since the biodb are all in lowercase, and we don't know the exact name, gs_inc_container will be updated to use uppercase as well for mysql
  sContainer = GetStringUpperCase(sContainer);
 
  // logging
  WriteTimestampedLogEntry("BIODB MIGRATION CONTAINER START: " + sContainer);

  int nLimit = 20;
  string sNth        = "";
  int nNth           = 0;
  location lTarget = GetStartingLocation();
  object oItem;
  string sSQL;
  
  for (nNth = 1; nNth <= nLimit; nNth++)
  {
    sNth = IntToString(nNth);

    if (GetCampaignInt("GS_CO_" + sContainer, "SLOT_" + sNth))
    {
      // create the object at starting location
      oItem = RetrieveCampaignObject("GS_CO_" + sContainer, "OBJECT_" + sNth, lTarget);

      // succes?
      if (oItem != OBJECT_INVALID) {
        WriteTimestampedLogEntry("BIODB MIGRATION CONTAINER ITEM CREATED: " + GetTag(oItem));

        // store in mysql
		
		// check for inventory containers, they need a prefix
		if (GetStringLeft(sContainer, 12) == "GS_INVENTORY") {
          sSQL = "INSERT INTO gs_container_data (container_id, item_number, item, is_base64) VALUES" + "('DS_" + sContainer + "','" + sNth + "',?, '1')";
		} else {
          sSQL = "INSERT INTO gs_container_data (container_id, item_number, item, is_base64) VALUES" + "('" + sContainer + "','" + sNth + "',?, '1')";
		}
        NWNX_SQL_PrepareQuery(sSQL);
        NWNX_SQL_PreparedObjectFull(0, oItem);
		if (NWNX_SQL_ExecutePreparedQuery()) {
          WriteTimestampedLogEntry("BIODB MIGRATION CONTAINER ITEM STORED IN MYSQL: " + GetTag(oItem));
		} else {
          WriteTimestampedLogEntry("BIODB MIGRATION CONTAINER ITEM NOT STORED IN MYSQL: " + GetTag(oItem));
		}
		
		DestroyObject(oItem);
	  
	  }
	  
    }
  }
		
  // logging
  WriteTimestampedLogEntry("BIODB MIGRATION CONTAINER DONE: " + sContainer);

}


void MigrateBioDB2MySQL_ContainerRunner(string sServerName) {

  // first check if migration is already executed
  string sMigrationDone = miDAGetKeyedValue("gs_system", "cont_done_" + sServerName, "value");

  if (sMigrationDone != "") return;
  
  // hardcoded list of player containers on DS
  
  MigrateBioDB2MySQL_ContainerData("ar_chest_bwbunker");
  MigrateBioDB2MySQL_ContainerData("bodybag");
  MigrateBioDB2MySQL_ContainerData("skallodecomcrate");
  MigrateBioDB2MySQL_ContainerData("skallonghshops_0");
  MigrateBioDB2MySQL_ContainerData("skallonghshops_1");
  MigrateBioDB2MySQL_ContainerData("skallonghshops_2");
  MigrateBioDB2MySQL_ContainerData("skallonghshops_3");
  MigrateBioDB2MySQL_ContainerData("skallonghshops_4");
  MigrateBioDB2MySQL_ContainerData("skallonghshops_5");
  MigrateBioDB2MySQL_ContainerData("skalodgestore0");
  MigrateBioDB2MySQL_ContainerData("skalodgestore10");
  MigrateBioDB2MySQL_ContainerData("skalodgestore11");
  MigrateBioDB2MySQL_ContainerData("skalodgestore12");
  MigrateBioDB2MySQL_ContainerData("skalodgestore13");
  MigrateBioDB2MySQL_ContainerData("skalodgestore14");
  MigrateBioDB2MySQL_ContainerData("skalodgestore15");
  MigrateBioDB2MySQL_ContainerData("skalodgestore16");
  MigrateBioDB2MySQL_ContainerData("skalodgestore17");
  MigrateBioDB2MySQL_ContainerData("skalodgestore18");
  MigrateBioDB2MySQL_ContainerData("skalodgestore19");
  MigrateBioDB2MySQL_ContainerData("skalodgestore1");
  MigrateBioDB2MySQL_ContainerData("skalodgestore20");
  MigrateBioDB2MySQL_ContainerData("skalodgestore2");
  MigrateBioDB2MySQL_ContainerData("skalodgestore3");
  MigrateBioDB2MySQL_ContainerData("skalodgestore4");
  MigrateBioDB2MySQL_ContainerData("skalodgestore5");
  MigrateBioDB2MySQL_ContainerData("skalodgestore6");
  MigrateBioDB2MySQL_ContainerData("skalodgestore7");
  MigrateBioDB2MySQL_ContainerData("skalodgestore8");
  MigrateBioDB2MySQL_ContainerData("skalodgestore9");
  MigrateBioDB2MySQL_ContainerData("skaltempshop_1");
  MigrateBioDB2MySQL_ContainerData("skaltempshop_2");
  MigrateBioDB2MySQL_ContainerData("skalvilplayhouse1store");
  MigrateBioDB2MySQL_ContainerData("skalvilplayhouse2store");
  MigrateBioDB2MySQL_ContainerData("gs_sh_604800");
  MigrateBioDB2MySQL_ContainerData("gs_sh_skallonghshops");
  MigrateBioDB2MySQL_ContainerData("gs_sh_skaltempshop");

  MigrateBioDB2MySQL_ContainerData("gs_inventory_1");
  MigrateBioDB2MySQL_ContainerData("gs_inventory_2");
  MigrateBioDB2MySQL_ContainerData("gs_inventory_3");
  MigrateBioDB2MySQL_ContainerData("gs_inventory_4");
  MigrateBioDB2MySQL_ContainerData("gs_inventory_5");
  MigrateBioDB2MySQL_ContainerData("gs_inventory_6");
  MigrateBioDB2MySQL_ContainerData("gs_inventory_7");
  MigrateBioDB2MySQL_ContainerData("gs_inventory_8");
  MigrateBioDB2MySQL_ContainerData("gs_inventory_9");
  MigrateBioDB2MySQL_ContainerData("gs_inventory_10");
  MigrateBioDB2MySQL_ContainerData("gs_inventory_11");
  MigrateBioDB2MySQL_ContainerData("gs_inventory_12");
  MigrateBioDB2MySQL_ContainerData("gs_inventory_13");
  MigrateBioDB2MySQL_ContainerData("gs_inventory_14");
  MigrateBioDB2MySQL_ContainerData("gs_inventory_15");
  MigrateBioDB2MySQL_ContainerData("gs_inventory_16");
  MigrateBioDB2MySQL_ContainerData("gs_inventory_17");
  MigrateBioDB2MySQL_ContainerData("gs_inventory_18");
  MigrateBioDB2MySQL_ContainerData("gs_inventory_19");
  MigrateBioDB2MySQL_ContainerData("gs_inventory_20");
  MigrateBioDB2MySQL_ContainerData("gs_inventory_21");
  MigrateBioDB2MySQL_ContainerData("gs_inventory_22");
  MigrateBioDB2MySQL_ContainerData("gs_inventory_23");
  MigrateBioDB2MySQL_ContainerData("gs_inventory_24");
  MigrateBioDB2MySQL_ContainerData("gs_inventory_25");
  MigrateBioDB2MySQL_ContainerData("gs_inventory_26");
  MigrateBioDB2MySQL_ContainerData("gs_inventory_27");
  MigrateBioDB2MySQL_ContainerData("gs_inventory_28");
  MigrateBioDB2MySQL_ContainerData("gs_inventory_29");
    
  MigrateBioDB2MySQL_ContainerData("gs_inventory_armor");
  MigrateBioDB2MySQL_ContainerData("gs_inventory_armor_unique");
  MigrateBioDB2MySQL_ContainerData("gs_inventory_book");
  MigrateBioDB2MySQL_ContainerData("gs_inventory_drow_book");
  MigrateBioDB2MySQL_ContainerData("gs_inventory_junk");
  MigrateBioDB2MySQL_ContainerData("gs_inventory_player");
  MigrateBioDB2MySQL_ContainerData("gs_inventory_treausure");
  MigrateBioDB2MySQL_ContainerData("gs_inventory_treasure_unique");
  MigrateBioDB2MySQL_ContainerData("gs_inventory_tres_book");
  MigrateBioDB2MySQL_ContainerData("gs_inventory_weapon");
  MigrateBioDB2MySQL_ContainerData("gs_inventory_weapon_unique");
  
  // migration done, keep track in gs_system
  miDASetKeyedValue("gs_system", "cont_done_" + sServerName, "value", "done");
	
}


void MigrateBioDB2MySQL_Encounters(string sServerName, int iAreaStart, int iAreaEnd) {

  // bio db variables
  string sDatabase;
  string sNth;
  int nNth;

  // mysql field variables
  int iAreaID;
  string sType;
  string sName;
  string sResRef;
  float fRating;
  int iChance;
  string sLocation;

  int iArea = 1;

  // logging
  WriteTimestampedLogEntry("BIODB MIGRATION: Starting next chunk.");

  // loop through all areas
  object oArea = GetFirstArea();

  while ((oArea != OBJECT_INVALID) && (iArea <= iAreaEnd)) {

    if (iArea < iAreaStart) {
      // skip

    } else {

      // migrate any encounter variables in BioDB for this area to MySQL

      // make sure Area vars are loaded, so we can use the Area ID
      gvd_LoadAreaVars(oArea);

      // get area ID
      iAreaID = gvd_GetAreaID(oArea);

      // init encounter vars for BioDB
      sDatabase = "GS_EN_" + GetTag(oArea);

      // migrate general area variables for encounters
      iChance = GetCampaignInt(sDatabase, "CHANCE");
      fRating = GetCampaignFloat(sDatabase, "RATING");

      // use the generic gvd_area_vars table for this
      if (iChance != 0) {
        gvd_SetAreaInt(oArea, "CHANCE", iChance);
      }
      if (fRating != 0.0f) {
        gvd_SetAreaFloat(oArea, "RATING", fRating);
      }

      // migrate night encounters
      sType = "Night";
      sLocation = "";

      for (nNth = 1; nNth <= 15; nNth++)
      {
        sNth = IntToString(nNth);

        sName = SQLEncodeSpecialChars(GetCampaignString(sDatabase, "NAME_" + sNth + "N"));
        sResRef = SQLEncodeSpecialChars(GetCampaignString(sDatabase, "RESREF_" + sNth + "N"));
        fRating = GetCampaignFloat(sDatabase, "RATING_" + sNth + "N");
        iChance = GetCampaignInt(sDatabase, "CHANCE_" + sNth + "N");

        // only migrate if there is at least a resref available
        if (sResRef != "") {

          SQLExecDirect("INSERT INTO gvd_encounter (area_id, type, resref, name, rating, chance, location) VALUES (" + IntToString(iAreaID) + ",'" + sType + "','" + sResRef + "','" + sName + "'," + FloatToString(fRating) + "," + IntToString(iChance) + ",'" + sLocation + "')");

        }

      }

      // migrate day encounters
      sType = "Day";
      sLocation = "";

      for (nNth = 1; nNth <= 15; nNth++)
      {
        sNth = IntToString(nNth);

        sName = SQLEncodeSpecialChars(GetCampaignString(sDatabase, "NAME_" + sNth));
        sResRef = SQLEncodeSpecialChars(GetCampaignString(sDatabase, "RESREF_" + sNth));
        fRating = GetCampaignFloat(sDatabase, "RATING_" + sNth);
        iChance = GetCampaignInt(sDatabase, "CHANCE_" + sNth);

        // only migrate if there is at least a resref available
        if (sResRef != "") {

          SQLExecDirect("INSERT INTO gvd_encounter (area_id, type, resref, name, rating, chance, location) VALUES (" + IntToString(iAreaID) + ",'" + sType + "','" + sResRef + "','" + sName + "'," + FloatToString(fRating) + "," + IntToString(iChance) + ",'" + sLocation + "')");

        }

      }

      // migrate boss encounters
      sType = "Boss";
      iChance = 100;

      sDatabase = "GS_BO_" + GetTag(oArea);

      for (nNth = 1; nNth <= 5; nNth++)
      {
        sNth = IntToString(nNth);

        sName = SQLEncodeSpecialChars(GetCampaignString(sDatabase, "NAME_" + sNth));
        sResRef = SQLEncodeSpecialChars(GetCampaignString(sDatabase, "RESREF_" + sNth));
        fRating = GetCampaignFloat(sDatabase, "RATING_" + sNth);
        sLocation = APSLocationToString(gsLOGetDBLocation(sDatabase, "LOCATION_" + sNth));

        // only migrate if there is at least a resref available
        if (sResRef != "") {

          SQLExecDirect("INSERT INTO gvd_encounter (area_id, type, resref, name, rating, chance, location) VALUES (" + IntToString(iAreaID) + ",'" + sType + "','" + sResRef + "','" + sName + "'," + FloatToString(fRating) + "," + IntToString(iChance) + ",'" + sLocation + "')");

        }

      }

      // logging
      WriteTimestampedLogEntry("BIODB MIGRATION: Encounters for Area " + GetName(oArea) + " on server " + sServerName + " migrated to MySQL.");

    }

    // next area
    iArea = iArea + 1;
    oArea = GetNextArea();

  }

  // done?
  if (oArea == OBJECT_INVALID) {
    // migration done, keep track in gs_system
    miDASetKeyedValue("gs_system", "encdone_" + sServerName, "value", "done");

    // logging
    WriteTimestampedLogEntry("BIODB MIGRATION: Encounter migration done.");

  } else {
    // nope, next chunk
    DelayCommand(5.0f, MigrateBioDB2MySQL_Encounters(sServerName, iAreaEnd + 1, iAreaEnd + 25));

  }

}

void MigrateBioDB2MySQL_EncountersRunner(string sServerName) {

  // first check if migration is already executed
  string sMigrationDone = miDAGetKeyedValue("gs_system", "encdone_" + sServerName, "value");

  if (sMigrationDone != "") return;

  // first chunk
  MigrateBioDB2MySQL_Encounters(sServerName, 1, 25);

}


void MigrateBioDB2MySQL_Placeables(string sServerName, int iAreaStart, int iAreaEnd) {

  // bio db variables
  string sDatabase;
  string sNth;
  int nNth;

  // mysql field variables
  int iAreaID;
  string sType;
  string sName;
  string sResRef;
  string sLocation;

  int iArea = 1;

  // logging
  WriteTimestampedLogEntry("BIODB MIGRATION: PLACEABLES: Starting next chunk.");

  // loop through all areas
  object oArea = GetFirstArea();

  while ((oArea != OBJECT_INVALID) && (iArea <= iAreaEnd)) {

    if (iArea < iAreaStart) {
      // skip

    } else {

      // migrate any placeables variables in BioDB for this area to MySQL

      // make sure Area vars are loaded, so we can use the Area ID
      gvd_LoadAreaVars(oArea);

      // get area ID
      iAreaID = gvd_GetAreaID(oArea);

      // init placeable vars for BioDB
      sDatabase = "GS_PL_" + GetTag(oArea);

      // migrate placeables
      for (nNth = 1; nNth <= 20; nNth++)
      {
        sNth = IntToString(nNth);

        sName = SQLEncodeSpecialChars(GetCampaignString(sDatabase, "NAME_" + sNth));
        sResRef = SQLEncodeSpecialChars(GetCampaignString(sDatabase, "RESREF_" + sNth));
        sLocation = APSLocationToString(Location(oArea, GetCampaignVector(sDatabase, "POSITION_" + sNth), GetCampaignFloat(sDatabase, "FACING_" + sNth)));

        // only migrate if there is at least a resref available
        if (sResRef != "") {

          SQLExecDirect("INSERT INTO gvd_placeable (area_id, resref, name, location) VALUES (" + IntToString(iAreaID) + ",'" + sResRef + "','" + sName + "','" + sLocation + "')");

        }

      }

      // logging
      WriteTimestampedLogEntry("BIODB MIGRATION: Placeables for Area " + GetName(oArea) + " on server " + sServerName + " migrated to MySQL.");

    }

    // next area
    iArea = iArea + 1;
    oArea = GetNextArea();

  }

  // done?
  if (oArea == OBJECT_INVALID) {
    // migration done, keep track in gs_system
    miDASetKeyedValue("gs_system", "pldone_" + sServerName, "value", "done");

    // logging
    WriteTimestampedLogEntry("BIODB MIGRATION: Placeable migration done.");

  } else {
    // nope, next chunk
    DelayCommand(5.0f, MigrateBioDB2MySQL_Placeables(sServerName, iAreaEnd + 1, iAreaEnd + 25));

  }

}

void MigrateBioDB2MySQL_PlaceableRunner(string sServerName) {

  // first check if migration is already executed
  string sMigrationDone = miDAGetKeyedValue("gs_system", "pldone_" + sServerName, "value");

  if (sMigrationDone != "") return;

  // first chunk
  MigrateBioDB2MySQL_Placeables(sServerName, 1, 25);

}



void main()
{
    //time
    SetLocalInt(OBJECT_SELF, "GS_YEAR", GetCalendarYear());

    string sTimestamp = miDAGetKeyedValue("gs_system", "time", "value");

    WriteTimestampedLogEntry("Module Load Timestamp: " + IntToString(gsTIGetActualTimestamp()));
    WriteTimestampedLogEntry("Current Timestamp: " + sTimestamp);
    int nTimestamp = StringToInt(sTimestamp);
    WriteTimestampedLogEntry("Parsed: " + IntToString(nTimestamp));

    if (nTimestamp)
    {
      gsTISetTime(nTimestamp);

      SetLocalInt(OBJECT_SELF, "GS_LAST_YEAR", GetCalendarYear());
      SetLocalInt(OBJECT_SELF, "GS_LAST_MONTH", GetCalendarMonth());
      SetLocalInt(OBJECT_SELF, "GS_DAY", GetCalendarDay());
      SetLocalInt(OBJECT_SELF, "GS_HOUR", GetTimeHour());

      SetLocalInt(OBJECT_SELF, "MI_RESET_TIME", nTimestamp);
    }
    else
    {
      // Something has gone badly wrong!  We don't have a time stored in the
      // database.  This must mean that we've lost database access which
      // is going to cause us a lot of pain.  Set a flag that will:
      // * boot all PCs who try and join
      // * warn DMs that the database is screwed.
      // See gs_m_enter for details.
      SetLocalInt(OBJECT_SELF, "MI_DATABASE_SCREWED", TRUE);
    }

    //restart timeout
    int nTimeout   = GetLocalInt(OBJECT_SELF, "GS_RESTART_TIMEOUT");

    if (nTimeout)
    {
        nTimeout = nTimestamp + gsTIGetGameTimestamp(nTimeout);
        SetLocalInt(OBJECT_SELF, "GS_RESTART_TIMEOUT", nTimeout);
    }

    //Early initialisation for GS_SEQUENCER, for use by gsCMGetCacheItem
    //Must run before ambience initialisation
    object oSequencer = GetObjectByTag("GS_SEQUENCER");
    ExecuteScript("gs_vfx008", oSequencer);

    //spellscript
    SetLocalString(OBJECT_SELF, "X2_S_UD_SPELLSCRIPT", "gs_spellscript");

    //ambience
    gsAMInitialize();

    chatInitAliases();

    // Added by Mithreas - load module specific properties from config 2da.
    string sServerName     = Get2DAString(SERVER_CONFIG_2DA,
                                          SERVER_CONFIG_2DA_VALUE,
                                          SERVER_CONFIG_2DA_SERVER_NAME);

    string sServerIP       = Get2DAString(SERVER_CONFIG_2DA,
                                          SERVER_CONFIG_2DA_VALUE,
                                          SERVER_CONFIG_2DA_SERVER_IP);

    string sServerPassword = Get2DAString(SERVER_CONFIG_2DA,
                                          SERVER_CONFIG_2DA_VALUE,
                                          SERVER_CONFIG_2DA_SERVER_PASSWORD);

    string sDMPassword     = Get2DAString(SERVER_CONFIG_2DA,
                                          SERVER_CONFIG_2DA_VALUE,
                                          SERVER_CONFIG_2DA_SERVER_DM_PASSWORD);

    string sServerVault    = Get2DAString(SERVER_CONFIG_2DA,
                                          SERVER_CONFIG_2DA_VALUE,
                                          SERVER_CONFIG_2DA_SERVER_VAULT);

    int nBaseXP            = StringToInt(
                             Get2DAString(SERVER_CONFIG_2DA,
                                          SERVER_CONFIG_2DA_VALUE,
                                          SERVER_CONFIG_2DA_BASE_XP));

    float fXPVariance      = StringToFloat(
                             Get2DAString(SERVER_CONFIG_2DA,
                                          SERVER_CONFIG_2DA_VALUE,
                                          SERVER_CONFIG_2DA_XP_VARIANCE));

    float fXPMultiplier   =  StringToFloat(
                             Get2DAString(SERVER_CONFIG_2DA,
                                          SERVER_CONFIG_2DA_VALUE,
                                          SERVER_CONFIG_2DA_XP_MULTIPLIER));

    int nXPMaxLevelForBonus = StringToInt(
                              Get2DAString(SERVER_CONFIG_2DA,
                                           SERVER_CONFIG_2DA_VALUE,
                                           SERVER_CONFIG_2DA_XP_LOW_LEVEL_PC));

    int nLoggingEnabled     = StringToInt(
                              Get2DAString(SERVER_CONFIG_2DA,
                                           SERVER_CONFIG_2DA_VALUE,
                                           SERVER_CONFIG_2DA_LOGGING_ENABLED));

    string sVaultster = Get2DAString(SERVER_CONFIG_2DA,
                                           SERVER_CONFIG_2DA_VALUE,
                                           SERVER_CONFIG_2DA_VAULTSTER);

    int nZombies            = StringToInt(
                              Get2DAString(SERVER_CONFIG_2DA,
                                           SERVER_CONFIG_2DA_VALUE,
                                           SERVER_CONFIG_2DA_ZOMBIE_MODE));

    string sWelcomeMessage = Get2DAString(SERVER_CONFIG_2DA,
                                           SERVER_CONFIG_2DA_VALUE,
                                           SERVER_CONFIG_2DA_WELCOME);

    int nStaticLevel       = StringToInt(
                              Get2DAString(SERVER_CONFIG_2DA,
                                           SERVER_CONFIG_2DA_VALUE,
                                           SERVER_CONFIG_2DA_STATIC_LEVEL));

    int nUseCastes       = StringToInt(
                              Get2DAString(SERVER_CONFIG_2DA,
                                           SERVER_CONFIG_2DA_VALUE,
                                           SERVER_CONFIG_2DA_USE_CASTES));

    int nUseAltMagic     = StringToInt(
                              Get2DAString(SERVER_CONFIG_2DA,
                                           SERVER_CONFIG_2DA_VALUE,
                                           SERVER_CONFIG_2DA_ALT_MAGIC));

    // Inherit defaults from __server_config
    if (nBaseXP == 0) nBaseXP = GS_XP_BASE_XP;
    if (fXPVariance == 0.0) fXPVariance = GS_XP_VARIANCE;
    if (fXPMultiplier == 0.0) fXPMultiplier = GS_XP_VARIANCE_MULTIPLIER;
    if (nXPMaxLevelForBonus == 0) nXPMaxLevelForBonus = GS_XP_MAX_PC_LEVEL_FOR_MULTIPLIER;

    // Apply settings to module.
    object oMod = GetModule();
    SetLocalString(oMod, VAR_SERVER_NAME, sServerName);
    SetLocalString(oMod, "DS_LETOSCRIPT_PORTAL_IP", sServerIP);
    SetLocalString(oMod, "DS_LETOSCRIPT_PORTAL_PASSWORD", sServerPassword);
    SetLocalString(oMod, "DS_LETOSCRIPT_DM_PASSWORD", sDMPassword);
    SetLocalString(oMod, "DS_LETOSCRIPT_NWNPATH", sServerVault);
    SetLocalInt(oMod, GS_XP_BASE_XP_VAR, nBaseXP);
    SetLocalFloat(oMod, GS_XP_VARIANCE_VAR, fXPVariance);
    SetLocalFloat(oMod, GS_XP_VARIANCE_MULTIPLIER_VAR, fXPMultiplier);
    SetLocalInt(oMod, GS_XP_MAX_PC_LEVEL_FOR_MULTIPLIER_VAR, nXPMaxLevelForBonus);
    SetLocalString(oMod, "VAULTSTER_ADDRESS", sVaultster);
    SetLocalInt(oMod, "ZOMBIE_MODE", nZombies);
    SetLocalString(oMod, "WELCOME_MESSAGE", sWelcomeMessage);
    SetLocalInt(oMod, "STATIC_LEVEL", nStaticLevel);
    SetLocalInt(oMod, "USE_CASTES", nUseCastes);
    SetLocalInt(oMod, "USE_ALT_MAGIC", nUseAltMagic);
    //::kirito - horse mod
    SetLocalInt(oMod, "X3_NO_MOUNTED_COMBAT_FEAT ", TRUE);

    // dunshine, grab playerpassword and save it as a variable for use later in gs_run_reboot
    SetLocalString(oMod, "GVD_SERVER_PASSWORD", NWNX_Administration_GetPlayerPassword());

    if (nLoggingEnabled) SetLocalInt(oMod, "MI_DEBUG", 1);
    else SetLocalInt(oMod, "MI_DEBUG", 0);
    SetMaxHenchmen(2);

    // Mark the server as up.
    SQLExecStatement("UPDATE nwn.web_server SET state=5, startup=UNIX_TIMESTAMP(), " +
     "curr_players=0, curr_dms=0 WHERE sid=?", miXFGetCurrentServer());

    // Added by Mithreas - initialize ranks, faction, playerlist, divination and deity systems --[
    // Delayed to avoid TMI issues.
    DelayCommand(0.5, LoadJewelryChest());
    DelayCommand(1.0, miXFUnregisterAll());
    DelayCommand(2.0, miRAInitialize());
    DelayCommand(3.0, fbFALoadFactions());
    DelayCommand(4.0, miDVShuffleDeck());
    DelayCommand(5.0, gsWOSetup());
    DelayCommand(6.0, md_DoWeaponSpecific());
    DelayCommand(7.0, LoadLandBroker());
    // ]--

    NWNX_Chat_RegisterChatScript("ar_chat");

    NWNX_Events_SubscribeEvent("NWNX_ON_ADD_ASSOCIATE_BEFORE", "evt_assoc_add");
    NWNX_Events_SubscribeEvent("NWNX_ON_REMOVE_ASSOCIATE_BEFORE", "evt_assoc_rem");
    NWNX_Events_SubscribeEvent("NWNX_ON_ENTER_STEALTH_BEFORE", "evt_stealth_ent");
    NWNX_Events_SubscribeEvent("NWNX_ON_EXIT_STEALTH_BEFORE", "evt_stealth_exit");
    NWNX_Events_SubscribeEvent("NWNX_ON_EXAMINE_OBJECT_BEFORE", "evt_examine_bef");
    NWNX_Events_SubscribeEvent("NWNX_ON_EXAMINE_OBJECT_AFTER", "evt_examine_aft");
    NWNX_Events_SubscribeEvent("NWNX_ON_MODE_ON", "evt_mode_on");
    NWNX_Events_SubscribeEvent("NWNX_ON_MODE_OFF", "evt_mode_off");
    NWNX_Events_SubscribeEvent("NWNX_ON_USE_ITEM_AFTER", "evt_useitem_aft");
    NWNX_Events_SubscribeEvent("NWNX_ON_DM_SET_EXP", "evt_dmsetexp");
    NWNX_Events_SubscribeEvent("NWNX_ON_DM_GIVE_GOLD", "evt_dmgivegold");
    NWNX_Events_SubscribeEvent("NWNX_ON_CLIENT_DISCONNECT_BEFORE", "evt_dc_bef");
	NWNX_Events_SubscribeEvent("NWNX_ON_USE_FEAT_BEFORE", "evt_ft_bef");
    NWNX_Events_SubscribeEvent("NWNX_ON_USE_FEAT_AFTER", "evt_ft_aft");

    SetStealthHIPSCallback("evt_hips");

    InitialiseLootSystem();

    // Dunshine migrate BioDB to MySQL (in chunks to prevent TMIs)
    // executed, no longer necessary: DelayCommand(10.0, MigrateBioDB2MySQL_EncountersRunner(sServerName));
    // executed, no longer necessary: DelayCommand(10.0, MigrateBioDB2MySQL_PlaceableRunner(sServerName));
	
	if (sServerName == SERVER_DISTSHORES) {
	  MigrateBioDB2MySQL_ContainerRunner(sServerName);
	}

    DelayCommand(300.0, DropPassword());
}
