//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// Global configuration - parameters that affect a number of different module
// systems.
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// The base XP modifier. All XP from hunting and exploration is directly
// proportional to this value.
//
// This value can also be defined in the 2da file (server_config.2da) and if
// set will override the default specified here.
//------------------------------------------------------------------------------
const string GS_XP_BASE_XP_VAR = "GS_XP_BASE_XP";
const int GS_XP_BASE_XP        =    24;

//------------------------------------------------------------------------------
// The XP variance. This value is used during calculation of XP from monster
// kills. A higher variance means that values are more spread out, so you get
// relatively less XP from tough kills and relatively more XP from easy ones
// (as calculated  by comparing challenge ratings). See the XP Calculator
// spreadsheet for a full model.
//------------------------------------------------------------------------------
const string GS_XP_VARIANCE_VAR = "GS_XP_VARIANCE";
const float GS_XP_VARIANCE      = 0.35;

//------------------------------------------------------------------------------
// This variable controls the bonus for low level characters. The model used is
// based on the ratio between PC and NPC levels, and as a result it's very
// steep at low levels. We compensate by increasing the variance by the factor
// listed.
//------------------------------------------------------------------------------
const string GS_XP_VARIANCE_MULTIPLIER_VAR         = "GS_XP_VARIANCE_MULTIPLIER";
const string GS_XP_MAX_PC_LEVEL_FOR_MULTIPLIER_VAR = "GS_XP_MAX_PC_LEVEL_FOR_MULTIPLIER";
const float  GS_XP_VARIANCE_MULTIPLIER            = 1.5;
const int    GS_XP_MAX_PC_LEVEL_FOR_MULTIPLIER    = 6;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// Feature control - the remainder of this file allows you to enable, disable
// and configure specific features.
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Disguise.
// This feature lets a character with bluff or perform change their appearance.
// The number of base ranks (including bonuses from feats and base ability
// score) needed to use this feature is controlled by DISGUISE_THRESHOLD.
//------------------------------------------------------------------------------
const int ALLOW_DISGUISE     = TRUE;
const int DISGUISE_THRESHOLD = 20;

//------------------------------------------------------------------------------
// Tracking.
// This feature lets a character with ranger or harper scout levels determine
// the creatures that spawn in this area's encounters.
//------------------------------------------------------------------------------
const int ALLOW_TRACKING    = TRUE;

//------------------------------------------------------------------------------
// Scrying.
// This feature allows characters with Epic Spell Focus in Divination to scry on
// other characters.
// SCRYING_DURATION is how long (in seconds) the scrying lasts.
// SCRYING_COOLDOWN is how long (in game hours) the "cooldown" is.
//------------------------------------------------------------------------------
const int ALLOW_SCRYING    = TRUE;
const int SCRYING_DURATION = 90;
const int SCRYING_COOLDOWN = 24;

//------------------------------------------------------------------------------
// Send Image.
// This feature allows characters with Epic Spell Focus in Illusion to send an
// image of themselves to other characters and speak a line of text.
// SCRYING_DURATION is how long (in seconds) the sending lasts.
// SCRYING_COOLDOWN is how long (in game hours/10) the "cooldown" is.
//------------------------------------------------------------------------------
const int ALLOW_SENDING = TRUE;
const int SENDING_DURATION = 60;
const int SENDING_COOLDOWN = 240;

//------------------------------------------------------------------------------
// Warding.
// This feature allows characters with Epic Spell Focus in Abjuration to place
// wards that paralyse creatures who enter them for one round.
// The ward lasts for one hour per caster level and the DC is as for a 9th level
// Abjuration spell cast by the caster.
// WARDING_COOLDOWN is the number of game hours/10 the character must wait
// before using this ability again.
//------------------------------------------------------------------------------
const int ALLOW_WARDING    = TRUE;
const int WARDING_COOLDOWN = 240;

//------------------------------------------------------------------------------
// Teleporting.
// This feature allows characters with Epic Spell Focus in Transmutation to
// teleport to a portal they have previously visited, just as if they'd used a
// Portal Lense. Costs 100xp.
// TELEPORT_COOLDOWN is the number of game hours/10 the character must wait
// before using this ability again.
//------------------------------------------------------------------------------
const int ALLOW_TELEPORT    = TRUE;
const int TELEPORT_COOLDOWN = 240;

//------------------------------------------------------------------------------
// Summoning (yoinking).
// This feature allows characters with Epic Spell Focus in Conjuration to summon
// another PC to them.
// The PC gets a pop up conversation asking for their permission.
// YOINKING_COOLDOWN is the number of game hours the character must wait before
//  using this ability again.
//------------------------------------------------------------------------------
const int ALLOW_YOINKING    = TRUE;
const int YOINKING_COOLDOWN = 240;

//------------------------------------------------------------------------------
// No Tells.
// This feature allows a player to turn off receipt of Tells from other players
// (note that DMs will still be able to send Tells to players).
//------------------------------------------------------------------------------
const int ALLOW_NOTELLS   = TRUE;

//------------------------------------------------------------------------------
// Climbing.
// This feature allows a character with enough levels in suitable classes to
// climb up, down or over barriers.
// CLIMBING_DC is the DC of the roll (1d20 + levels in classes + dex mod + str
//  mod).
//------------------------------------------------------------------------------
const int ALLOW_CLIMBING = FALSE;
const int CLIMBING_DC    = 40;

//------------------------------------------------------------------------------
// Change Description.
// This feature allows players to change their character description. Requires
// LETOscript to be available on the server.
//------------------------------------------------------------------------------
const int ALLOW_CHANGE_DESCRIPTION = TRUE;

//------------------------------------------------------------------------------
// Delete Character.
// This feature allows players to delete the character they are currently logged
// in as from their vault. It renames the file to something unusable, so an
// administrator can manually rename the file back to .bic to make the character
// "undeleted".
// Requires LETOscript to be available on the server.
//------------------------------------------------------------------------------
const int ALLOW_DELETE_CHARACTER = TRUE;

//------------------------------------------------------------------------------
// Detect Evil.
// This feature allows clerics and paladins to attempt to detect any evil PCs
// around them. Affected creatures receive a Will save to resist the effect.
//------------------------------------------------------------------------------
const int ALLOW_DETECT_EVIL    = TRUE;

//------------------------------------------------------------------------------
// The Baatezu subrace.
//------------------------------------------------------------------------------
const int ALLOW_BAATEZU = FALSE;

//------------------------------------------------------------------------------
// Whether or not to award exploration XP when a PC enters a new area.
//------------------------------------------------------------------------------
const int ALLOW_EXPLORATION_XP     = FALSE;

//------------------------------------------------------------------------------
// Whether or not to use the weather system.
//------------------------------------------------------------------------------
const int ALLOW_WEATHER     = TRUE;

//------------------------------------------------------------------------------
// Fixture control: Sets how many fixtures are allowed per area
// Set ALLOW to -1 to allow unlimited fixtures per area (disables SAVE_BIO)
// SQL == TRUE && BIO == TRUE  :
//      SQL will be used, with BIO as fallback conversion and redundant backup
// SQL == TRUE && BIO == FALSE :
//      No longer redundant backup, but still fallback conversion.
// SQL == FALSE && BIO == TRUE :
//      SQL disabled, fall back to full use of BIO
// SQL == FALSE && BIO == FALSE:
//      Will make the world static. BIO data will be loaded but never updated
// Best performance with ALLOW = -1, SQL = TRUE, BIO = FALSE
//------------------------------------------------------------------------------
const int ALLOW_MAX_FIXTURES = 60;
const int FIXTURE_SAVE_SQL = TRUE;
const int FIXTURE_SAVE_BIO = FALSE;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// 2da file rows.
//------------------------------------------------------------------------------
const string SERVER_CONFIG_2DA = "server_config";
const string SERVER_CONFIG_2DA_VALUE = "value";

const int SERVER_CONFIG_2DA_SERVER_IP       = 0;
const int SERVER_CONFIG_2DA_SERVER_PASSWORD = 1;
const int SERVER_CONFIG_2DA_SERVER_DM_PASSWORD = 2;
const int SERVER_CONFIG_2DA_SERVER_NAME     = 3;
const int SERVER_CONFIG_2DA_ZOMBIE_MODE     = 4;
const int SERVER_CONFIG_2DA_SERVER_INSTALL  = 5;
const int SERVER_CONFIG_2DA_SERVER_VAULT    = 6;
const int SERVER_CONFIG_2DA_BASE_XP         = 7;
const int SERVER_CONFIG_2DA_XP_VARIANCE     = 8;
const int SERVER_CONFIG_2DA_XP_MULTIPLIER   = 9;
const int SERVER_CONFIG_2DA_XP_LOW_LEVEL_PC = 10;
const int SERVER_CONFIG_2DA_LOGGING_ENABLED = 11;
const int SERVER_CONFIG_2DA_DATABASE_TYPE   = 12;
const int SERVER_CONFIG_2DA_STATIC_LEVEL    = 13;
const int SERVER_CONFIG_2DA_VAULTSTER       = 14;
const int SERVER_CONFIG_2DA_WELCOME         = 15;
const int SERVER_CONFIG_2DA_USE_CASTES      = 16;
const int SERVER_CONFIG_2DA_ALT_MAGIC       = 17;
