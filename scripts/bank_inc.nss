//::////////////////////////////////////////////////////
//::
//:: Scarface's Persistent Banking System   - Include -
//::
//::////////////////////////////////////////////////////

//:: CONSTANTS

/*
   Set the maximum amount of items allowed to be stored per player.
   Set the max amount of items allowed to be stored by players.
   * NOTE * If you are NOT using an external DB like MYSQL, I suggest that
   you do not set this to more than 30 otherwise it will most likey cause horrible server lag
*/
const int MAX_ITEMS = 60;

/*
   Set how many warnings the player will have for trying to steal from chests
   already in use before being teleported/killed.
*/
const int WARNING = 3;

/*
   Do you want the player to be sent to jail for trying to steal from a chests
   already in use? if TRUE then set the waypoint TAG to jump the thief to, if
   set to FALSE then the player will be killed instead.
*/
const int SEND_TO_JAIL = FALSE;
const string JAIL_WAYPOINT = "WP_TAG";

////////////////////////////////////////////////////////////////////////////////
//::
//:: FOR ADVANCED USERS ONLY !!!!
//::
////////////////////////////////////////////////////////////////////////////////
/*
  These option are for NWNX/APS using a MYSQL/SQLITE database. If you are just
  using a standard bioware database then you do NOT need to adjust these
  settings.
*/

const int NWNX_APS_ENABLED = TRUE;       // Set to TRUE if you want to use
                                         // NWNX/APS with MYSQL/SQLITE, or FALSE
                                         // to use standard Bioware database.
const string OBJECT_TABLE = "pwobjectdata"; // Object table sName.
                                         //
const string INTEGER_TABLE = "pwbankdata";   // Integer table sName.
