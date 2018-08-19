#include "inc_respawn"
#include "inc_subrace"
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
  else if (bUnderdark)
  {

    oTarget = GetWaypointByTag("GS_TARGET_SUBRACE_" + IntToString(nRace));

    if (!GetIsObjectValid(oTarget)) oTarget = GetWaypointByTag("GS_TARGET_DEFAULT");

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
