/*
  inc_tells

  This is possibly the oddest library I have ever written.  Its purpose is to
  give players greater control over who they receive Tells from in game.

  The concept is that you can have a 'blacklist' of people who cannot send you
  Tells, or a 'whitelist' of people who can (blocking everyone else). This
  builds on the situationally useful -notells function to provide a much more
  detailed level of control.

  The settings are stored on the creature hide for persistence.
*/
#include "inc_pc"
#include "inc_database"

// Returns the object representing the player whose name begins with sName. If
// no player is found, returns OBJECT_INVALID.
object miTEGetPlayerFromName(string sName);

// Adds oBlocked to oBlockedBy's blocked list and removes them from oBlockedBy's
// whitelist.
void miTEBlockPlayer(object oBlockedBy, object oBlocked);

// Removes oBlocked from oBlockedBy's whitelist and adds them to oBlockedBy's
// blacklist.
void miTEUnblockPlayer(object oUnblockedBy, object oBlocked);

// Sets whether this player is blocking everyone by default or not.  If bState
// is true then only players on oPlayer's whitelist will be able to contact
// them.  If bState is false, then only players on oPlayer's blacklist will NOT
// be able to talk to them,
void miTESetNoTellState(int bState, object oPlayer = OBJECT_SELF);

// Removes all players from oPlayer's whitelist.
void miTEClearWhitelist(object oPlayer = OBJECT_SELF);

// Removes all players from oPlayer's blacklist.
void miTEClearBlacklist(object oPlayer = OBJECT_SELF);

// Returns TRUE if oPlayer is barred from sending Tells to oBlockedBy, FALSE
// otherwise.
int miTEGetIsPlayerBlocked(object oBlockedBy, object oPlayer = OBJECT_SELF);

// Returns TRUE if oPlayer is blocked from sending and receiving Tells, FALSE
// otherwise. See miTESetTellsDisabled(object, int).
int miTEGetTellsDisabled(object oPlayer);

// Toggle disabling of the Tell and Notell systems entirely. If disabled, a
// player cannot send/receive Tells to/from other players, or make use of the
// Notells system to whitelist people. This is a persistent setting given by DMs
// to players who have a problem separating OOC from IC.
void miTESetTellsDisabled(object oPlayer, int nDisable = TRUE);


const string WHITELIST = "MI_WHITELIST";
const string BLACKLIST = "MI_BLACKLIST";
const string NOTELLS   = "MI_TELLS_OFF";

object miTEGetPlayerFromName(string sName)
{
  object oPlayer = GetFirstPC();
  object oTarget = OBJECT_INVALID;
  while (GetIsObjectValid(oPlayer))
  {
    if (GetStringLeft (GetName(oPlayer), GetStringLength(sName)) == sName)
    {
      oTarget = oPlayer;
    }
    oPlayer = GetNextPC();
  }

  return oTarget;
}

void miTEBlockPlayer(object oBlockedBy, object oBlocked)
{
  string sPlayer = ":" + GetName(oBlocked) + ":";
  string sBlacklist = GetLocalString(gsPCGetCreatureHide(oBlockedBy), BLACKLIST);

  if (FindSubString(sBlacklist, sPlayer) == -1)
    SetLocalString(gsPCGetCreatureHide(oBlockedBy), BLACKLIST, sBlacklist + sPlayer);

  string sWhitelist = GetLocalString(gsPCGetCreatureHide(oBlockedBy), WHITELIST);
  int index = FindSubString(sWhitelist, sPlayer);
  if (index > -1)
  {
    // Example of excise logic:
    // :1234::456::12345: length=5 index=6
    // substr(0,6) = :1234:
    // substr(11, 18-11) = :12345:
    int length = GetStringLength(sPlayer);
    sWhitelist = GetSubString(sWhitelist, 0, index) +
      GetSubString(sWhitelist,
                   index + length,
                   GetStringLength(sWhitelist) - index - length);
    SetLocalString(gsPCGetCreatureHide(oBlockedBy), WHITELIST, sWhitelist);
  }
}

void miTEUnblockPlayer(object oUnblockedBy, object oBlocked)
{
  string sPlayer = ":" + GetName(oBlocked) + ":";
  string sWhitelist = GetLocalString(gsPCGetCreatureHide(oUnblockedBy), WHITELIST);

  if (FindSubString(sWhitelist, sPlayer) == -1)
    SetLocalString(gsPCGetCreatureHide(oUnblockedBy), WHITELIST, sWhitelist + sPlayer);

  string sBlacklist = GetLocalString(gsPCGetCreatureHide(oUnblockedBy), BLACKLIST);
  int index = FindSubString(sBlacklist, sPlayer);
  if (index > -1)
  {
    int length = GetStringLength(sPlayer);
    sBlacklist = GetSubString(sBlacklist, 0, index) +
      GetSubString(sBlacklist,
                   index + length,
                   GetStringLength(sBlacklist) - index - length);
    SetLocalString(gsPCGetCreatureHide(oUnblockedBy), BLACKLIST, sBlacklist);
  }
}

void miTESetNoTellState(int bState, object oPlayer = OBJECT_SELF)
{
  SetLocalInt(gsPCGetCreatureHide(oPlayer), NOTELLS, bState);
}

void miTEClearWhitelist(object oPlayer = OBJECT_SELF)
{
  DeleteLocalString(gsPCGetCreatureHide(oPlayer), WHITELIST);
}

void miTEClearBlacklist(object oPlayer = OBJECT_SELF)
{
  DeleteLocalString(gsPCGetCreatureHide(oPlayer), BLACKLIST);
}

int miTEGetIsPlayerBlocked(object oBlockedBy, object oPlayer = OBJECT_SELF)
{
  int bNoTells      = GetLocalInt(gsPCGetCreatureHide(oBlockedBy), NOTELLS);
  string sWhitelist = GetLocalString(gsPCGetCreatureHide(oBlockedBy), WHITELIST);
  string sBlacklist = GetLocalString(gsPCGetCreatureHide(oBlockedBy), BLACKLIST);
  return
   (bNoTells && FindSubString(sWhitelist, GetName(oPlayer)) == -1 ) ||
   (!bNoTells && FindSubString(sBlacklist, GetName(oPlayer)) > -1);
}

int miTEGetTellsDisabled(object oPlayer)
{
  string sCDKey = GetPCPublicCDKey(oPlayer);
  object oCache = GetModule();
  int nDisabled = GetLocalInt(oCache, "TELL_DISABLED_" + sCDKey);
  if (!nDisabled)
  {
    nDisabled = StringToInt(miDAGetKeyedValue("gs_player_data", sCDKey, "tells", "cdkey"));

    // Save another trip to the database.
    if (!nDisabled)
    {
      nDisabled = -1;
    }

    SetLocalInt(oCache, "TELL_DISABLED_" + sCDKey, nDisabled);
  }

  return (nDisabled == 1);
}

void miTESetTellsDisabled(object oPlayer, int nDisable = TRUE)
{
  string sCDKey = GetPCPublicCDKey(oPlayer);
  SetLocalInt(GetModule(), "TELL_DISABLED_" + sCDKey, (nDisable ? 1 : -1));
  miDASetKeyedValue("gs_player_data", sCDKey, "tells", IntToString(nDisable), "cdkey");
}

//void main(){}
