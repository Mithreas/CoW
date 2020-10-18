#include "inc_common"
#include "inc_pc"
#include "inc_respawn"
#include "inc_time"
#include "inc_xp"
#include "inc_xfer"

void main()
{
    object oUsedBy     = GetLastUsedBy();
    if (! GetIsPC(oUsedBy))              return;
    if (GetIsPossessedFamiliar(oUsedBy)) return;

    int nTimeout;
    //rollback int PvPDeath = GetLocalInt(gsPCGetCreatureHide(oUsedBy), "SEP_LAST_DEATH_IS_PVP");

    // temp logging to detect a bug with crossing servers in the death area, before respawning increasing the time-out, seems something is iffy about the times or variables between the two servers
    WriteTimestampedLogEntry("RESPAWN DEBUG: REPAWN ATTEMPT, SERVER = " + miXFGetCurrentServer()  + ", PC = " + GetName(oUsedBy) + ", GS_DEATH_TIMEOUT = " + IntToString(gsTIGetGameTimestamp(GetLocalInt(GetModule(), "GS_DEATH_TIMEOUT"))) + ", GS_DEATH_TIMESTAMP = " + IntToString(GetLocalInt(gsPCGetCreatureHide(oUsedBy), "GS_DEATH_TIMESTAMP")) + ", gsTIGetActualTimestamp = " + IntToString(gsTIGetActualTimestamp()));
 
    nTimeout = gsTIGetGameTimestamp(GetLocalInt(GetModule(), "GS_DEATH_TIMEOUT")) + GetLocalInt(gsPCGetCreatureHide(oUsedBy), "GS_DEATH_TIMESTAMP") - gsTIGetActualTimestamp();

    WriteTimestampedLogEntry("RESPAWN DEBUG: nTimeout = " + IntToString(nTimeout));

    if (nTimeout > 0)
    {
        nTimeout = gsTIGetRealTimestamp(nTimeout);

        FloatingTextStringOnCreature(
            gsCMReplaceString(
                GS_T_16777455,
                IntToString(gsTIGetHour(nTimeout)),
                IntToString(gsTIGetMinute(nTimeout)),
                IntToString(gsTIGetSecond(nTimeout))),
            oUsedBy,
            FALSE);
        return;
    }

    location lLocation = gsREGetRespawnLocation(oUsedBy);
	
    // Check that our location is valid.  If not, try the other server.
	if (!GetIsObjectValid(GetAreaFromLocation(lLocation)))
	{
	  if (miXFGetCurrentServer() == SERVER_ISLAND)
	  {
	    miXFDoPortal(oUsedBy, SERVER_UNDERDARK, "GS_TARGET_DEATH");
	  }
	  else if (miXFGetCurrentServer() == SERVER_UNDERDARK)
	  {	    
	    miXFDoPortal(oUsedBy, SERVER_ISLAND, "GS_TARGET_DEATH");
	  }
	  else if (miXFGetCurrentServer() == SERVER_DISTSHORES)
	  {	    
	    miXFDoPortal(oUsedBy, SERVER_DISTSHORES, "GS_TARGET_DEATH");
	  }
	  else
	  {
	    WriteTimestampedLogEntry("Error, tried to respawn but could not find respawn location: " + GetName(oUsedBy));
	  }
	  return;
	}
	
	if (GetLocalInt(GetAreaFromLocation(lLocation), "DEATH_PLANE"))
	{
	  // PC has set their respawn target within the death plane.  Send them out to the barrow mounds. 
	  lLocation = GetLocation(GetObjectByTag("GS_TARGET_RESPAWN_DEFAULT"));
	}
	
    //penalty
    // Septire - Death Penalty now 10% of what it was, refer to inc_xp
	gsXPApplyDeathPenalty(oUsedBy);
	
	// Septire - New Ability Drain death penalty, refer to inc_respawn
	ExecuteScript("sep_respawn_new", oUsedBy);
	
	// Randomize alignment!
	int nAlignment;
	switch (d4())
	{
	  case 1:
	    nAlignment = GetAlignmentGoodEvil(oUsedBy);
		break;
	  case 2:
	    nAlignment = ALIGNMENT_GOOD;
		break;
	  case 3: 
	    nAlignment = ALIGNMENT_NEUTRAL;
		break;
	  case 4:
	    nAlignment = ALIGNMENT_EVIL;
		break;
	}
	
    //teleport
    switch (nAlignment)
    {
    case ALIGNMENT_GOOD:
    case ALIGNMENT_NEUTRAL:
        gsCMTeleportToLocation(oUsedBy, lLocation, VFX_IMP_HEALING_X);
        break;

    case ALIGNMENT_EVIL:
        gsCMTeleportToLocation(oUsedBy, lLocation, VFX_IMP_HARM);
        break;
    }

    //destroy corpse
    object oCorpse = GetLocalObject(oUsedBy, "GS_CORPSE");

    if (GetIsObjectValid(oCorpse)) DestroyObject(oCorpse);
    DeleteLocalObject(oUsedBy, "GS_CORPSE");
}
