#include "gs_inc_respawn"
#include "gs_inc_subrace"
#include "inc_backgrounds"
#include "inc_xfer"

void _jumpToTarget(object oPC, object oTarget)
{
    AssignCommand(oPC, ClearAllActions(TRUE));
    AssignCommand(oPC, ActionJumpToObject(oTarget));
    AssignCommand(oPC, ActionDoCommand(gsRESetRespawnLocation()));
    AssignCommand(oPC, ActionDoCommand(SetCommandable(TRUE)));
    AssignCommand(oPC, SetCommandable(FALSE));
}

void main()
{
    object oPC     = GetPCSpeaker();
    int nRace      = gsSUGetSubRaceByName(GetSubRace(oPC));
    string sTag;
    object oTarget;

    // Work out whether we're on the right server for this subrace.
    int bUnderdark      = miXFGetCurrentServer() == SERVER_UNDERDARK;
    int bSurface        = miXFGetCurrentServer() == SERVER_ISLAND;
    int bDistantShores  = miXFGetCurrentServer() == SERVER_DISTSHORES;
    
    int bIsUnderdarker  = gsSUGetIsUnderdarker(nRace);
    int bOutcast        = miBAGetBackground(oPC) == MI_BA_OUTCAST;
    int bSlave          = miBAGetBackground(oPC) == MI_BA_SLAVE;
    int bHaveSlaveBadge = GetIsObjectValid( GetItemPossessedBy(oPC, "gvd_slave_clamp") );
    int nAlternateStart = GetLocalInt(gsPCGetCreatureHide(oPC), "MI_RACIAL_STARTLOC");

  if (nAlternateStart == 3) // Brogendenstein start
  {
    nRace   = GetRacialType(oPC);
    sTag    = "GS_TARGET_RACE_" + IntToString(nRace);
    oTarget = GetWaypointByTag(sTag);

    switch (nRace)
    {
      case 0:  // Dwarf - surface
      case 3:  // Halfling - surface
      {
        if (bSurface) _jumpToTarget(oPC, oTarget);
        else miXFDoPortal(oPC, SERVER_ISLAND, sTag);
      }
      case 2: // Gnome - underdark
      {
        if (bUnderdark) _jumpToTarget(oPC, oTarget);
        else miXFDoPortal(oPC, SERVER_UNDERDARK, sTag);
      }
    }
  }
	else if (nAlternateStart == 1) // Skal start
	{
		if (bDistantShores) _jumpToTarget(oPC, GetWaypointByTag("GS_TARGET_DEFAULT"));
		else {
			sTag = "GS_TARGET_DEFAULT";
			miXFDoPortal(oPC, SERVER_DISTSHORES, sTag);
		}
	}
	else if (nAlternateStart == 2) // Cordor start
	{
		if (bUnderdark) _jumpToTarget(oPC, GetWaypointByTag("GS_TARGET_DEFAULT"));
		else {
			sTag = "GS_TARGET_DEFAULT";
			miXFDoPortal(oPC, SERVER_UNDERDARK, sTag);
		}
	}
  else if (bUnderdark || bSlave || bOutcast)
  {
    //::  Jump to UD server if PC Outcast or Slave, if character is created on Surface server
    if ( (bOutcast || bSlave) && !bUnderdark ) {
      // gsSUGetSubRaceByName() will truncate at (, so Human (Outcast) will just get Human.
      // Since we are having Slaves and Outcasts start in the UD, group them with Orogs for now, arbitrarily chosen.
      // nRace   = GetRacialType(oPC);
      nRace = GS_SU_HALFORC_OROG;
      sTag = "GS_TARGET_SUBRACE_" + IntToString(nRace);
      miXFDoPortal(oPC, SERVER_UNDERDARK, sTag);
      return;
    }
    else if (bOutcast || bSlave)
    {
      // Have Slaves and Outcasts start with Orogs, arbitrarily chosen so they start in UD.
      nRace = GS_SU_HALFORC_OROG;
      oTarget = GetWaypointByTag("GS_TARGET_SUBRACE_" + IntToString(nRace));
    }
    else
    {
      oTarget = GetWaypointByTag("GS_TARGET_SUBRACE_" + IntToString(nRace));
    }

    if (!GetIsObjectValid(oTarget)) oTarget = GetWaypointByTag("GS_TARGET_DEFAULT");

    //::  Give Slave clamp (Only once!)
    if (!bHaveSlaveBadge && bSlave) {
      CreateItemOnObject("gvd_slave_clamp", oPC);
    }

    _jumpToTarget(oPC, oTarget);
  }
  else if ((bSurface || bDistantShores) && bIsUnderdarker)
  {
    // We're on the wrong server.
    sTag = "GS_TARGET_SUBRACE_" + IntToString(nRace);
    miXFDoPortal(oPC, SERVER_UNDERDARK, sTag);
  }
  else
  {
    sTag = "GS_TARGET_DEFAULT";
    miXFDoPortal(oPC, SERVER_UNDERDARK, sTag);
  }
	
}