// Transfers a character between servers.  Use as onclick event (including
// OnAreaTransitionClick).
//
// Object with this script must have a variable "DEST_WP" set up with the
// string value of the waypoint the character should be ported to on arrival.
// mi_inc_xfer contains a current list of these.
//
// The object should also have SERVER_NAME set up to point to the correct server
// (see mi_inc_xfer for allowed values).  If blank, it will be defaulted
// sensibly - in practise it currently only needs setting for transitions from
// the main isle into Cordor.
#include "mi_inc_xfer"
void main()
{
  object oPC = GetClickingObject();
  if (!GetIsObjectValid(oPC)) oPC = GetLastUsedBy();
  if (!GetIsObjectValid(oPC)) oPC = GetPCSpeaker();
  if (!GetIsObjectValid(oPC) && GetIsPC(OBJECT_SELF)) oPC = OBJECT_SELF;

  if (GetIsPossessedFamiliar(oPC))
  {
    SendMessageToPC(oPC, "Familiars can't transition between servers. Sorry.");
    return;
  }

  string sWP = GetLocalString(OBJECT_SELF, "DEST_WP");
  string sServer = GetLocalString(OBJECT_SELF, "TARGET_SERVER");

  if (sServer == "")
  {
    string sCurrentServer = GetLocalString(GetModule(), VAR_SERVER_NAME);

    if (sCurrentServer == SERVER_UNDERDARK)
    {
      sServer = SERVER_ISLAND;
    }
    else if (sCurrentServer == SERVER_ISLAND)
    {
      sServer = SERVER_UNDERDARK;
    }
    else if (sCurrentServer == SERVER_DISTSHORES)
    {
      sServer = SERVER_UNDERDARK;
    }
    else  // SERVER_CORDOR
    {
      sServer = SERVER_ISLAND;
    }
  }

  // temp logging to detect a bug with crossing servers in the death area, before respawning increasing the time-out, seems something is iffy about the times or variables between the two servers
  WriteTimestampedLogEntry("RESPAWN DEBUG: BEFORE PORTAL, SERVER = " + miXFGetCurrentServer()  + ", PC = " + GetName(oPC) + ", GS_DEATH_TIMEOUT = " + IntToString(gsTIGetGameTimestamp(GetLocalInt(GetModule(), "GS_DEATH_TIMEOUT"))) + ", GS_DEATH_TIMESTAMP = " + IntToString(GetLocalInt(gsPCGetCreatureHide(oPC), "GS_DEATH_TIMESTAMP")) + ", gsTIGetActualTimestamp = " + IntToString(gsTIGetActualTimestamp()));

  miXFDoPortal(oPC, sServer, sWP);
}
