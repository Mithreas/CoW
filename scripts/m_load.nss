#include "__server_config"
#include "inc_chatalias"
#include "inc_chatutils"
#include "inc_ambience"
#include "inc_container"
#include "inc_time"
#include "inc_worship"
#include "inc_loot"
#include "inc_database"
#include "inc_divination"
#include "inc_factions"
#include "inc_perspeople"
#include "inc_skills"
#include "inc_xfer"
#include "nwnx_admin"
#include "nwnx_alts"
#include "nwnx_chat"
#include "nwnx_events"
#include "nwnx_alts"
#include "inc_area"

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

    // Added by Mithreas - initialize faction, playerlist, divination and deity systems --[
    // Delayed to avoid TMI issues.
    DelayCommand(0.5, LoadJewelryChest());
    DelayCommand(1.0, miXFUnregisterAll());
    DelayCommand(3.0, fbFALoadFactions());
    DelayCommand(4.0, miDVShuffleDeck());
    DelayCommand(5.0, gsWOSetup());
    DelayCommand(6.0, md_DoWeaponSpecific());
	DelayCommand(7.0, miSKInitialise());
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


    // Initialise CNR - this script calls aps_onload too.
    WriteTimestampedLogEntry ("Initialising CNR");
    ExecuteScript("cnr_module_oml", OBJECT_SELF);

    // Initialise the random quests - loading them into the database.
    WriteTimestampedLogEntry ("Initialising random quests");
    DelayCommand(60.0, ExecuteScript("rquest_init", OBJECT_SELF));

    // Initialise the ranks (loading them into the database).
    WriteTimestampedLogEntry ("Initialising ranks");
    ExecuteScript("ranks_init", OBJECT_SELF);

    // Set up persistent people.
    WriteTimestampedLogEntry ("Initialising persistent people");
    SetUpPersistentPeople();	
	
    DelayCommand(150.0, DropPassword());
}
