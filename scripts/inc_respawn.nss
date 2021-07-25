/* RESPAWN Library by Gigaschatten */

//void main() {}

#include "inc_location"
#include "inc_pc"
#include "inc_subrace"
#include "inc_time"
#include "inc_effect"

const int GS_ABILITY_DECREASE_BASE  = 6;
const int GS_RESPAWN_RECOVERY_HOURS = 2;

//set current position of oPC as respawn location
void gsRESetRespawnLocation(object oPC = OBJECT_SELF);
//return respawn location of oPC
location gsREGetRespawnLocation(object oPC = OBJECT_SELF);

// Remove all Temporary Supernatural Ability Decreases on oPC
void sepREClearAbilityDrains(object oPC);
// Returns the item to store the Drain variables onto.
object sepRESaveItem(object oPC);
// Applies a drain of nDrain onto player's ability scores. Base scores cannot drop below 6. nDrain is typically the return from _sepRECalulateNewDrain().
void sepREApplyRespawnDrains(object oPC, int nDrain);
// Creates a new death penalty, sets drains to max (based on level), disables prays temporarily, alerts oUsedBy with messages.
void sepREApplyNewDeathPenalty(object oUsedBy);
// Determine the new Drain quantity, called by sepREProcessHeartbeat
int _sepRECalculateNewDrain(object oPC);
// Heartbeat update for Drains, calls sepRECalculateNewDrain().
void sepREProcessHeartbeat(object oPC);
// Determine if the effect is a respawn penalty. Used in some spell scripts like Restoration, Lesser Restoration, Greater Restoration
int sepREGetIsDeathEffect(effect eBad, object oPC);

// dunshine: Creates a new subdual penalty, disables prays temporarily, alerts oUsedBy with messages.
void gvdREApplyNewSubdualPenalty(object oUsedBy);


void gsRESetRespawnLocation(object oPC = OBJECT_SELF)
{
    string sPlayerID = gsPCGetPlayerID(oPC);

    if (sPlayerID != "")
    {
        miDASetKeyedValue("gs_pc_data", sPlayerID, "respawn_location", APSLocationToString(GetLocation(oPC)));
        SetLocalLocation(oPC, "GS_RESPAWN", GetLocation(oPC));
    }
}
//----------------------------------------------------------------
location gsREGetRespawnLocation(object oPC = OBJECT_SELF)
{
    string sPlayerID = gsPCGetPlayerID(oPC);

    if (sPlayerID != "")
    {
        // Set up in gs_m_enter by the call to gsPCCacheValues.
        location lLocation = GetLocalLocation(oPC, "GS_RESPAWN");
        if (GetIsObjectValid(GetAreaFromLocation(lLocation))) return lLocation;

        if (gsSUGetIsUnderdarker(gsSUGetSubRaceByName(GetSubRace(oPC))))
        {
          object oObject     = GetObjectByTag("GS_TARGET_RESPAWN_UD");
          if (GetIsObjectValid(oObject))                        return GetLocation(oObject);
        }
        object oObject     = GetObjectByTag("GS_TARGET_RESPAWN");
        if (GetIsObjectValid(oObject))                        return GetLocation(oObject);

        oObject            = GetObjectByTag("GS_TARGET_START");
        if (GetIsObjectValid(oObject))                        return GetLocation(oObject);
    }

    return Location(OBJECT_INVALID, Vector(), 0.0);
}
//------------------------------------------------------------------------------
// Remove all self-inflicted Supernatural Ability Decreases on oPC. Called periodically when drain updates.
void sepREClearAbilityDrains(object oPC)
{
    // dunshine: use tagged effect to easily remove the correct effects:
    RemoveTaggedEffects(oPC, EFFECT_TAG_DEATH);

    /*
    effect fx = GetFirstEffect(oPC);

    while(GetIsEffectValid(fx))
    {
        if ((GetEffectType(fx) == EFFECT_TYPE_ABILITY_DECREASE) &&
            (GetEffectSubType(fx) == SUBTYPE_SUPERNATURAL) &&
			(GetEffectCreator(fx) == oPC)
			)
        {
            RemoveEffect(oPC, fx);
        }
        fx = GetNextEffect(oPC);
    }
    // All temporary Supernatural ability drains removed.
    */

    return;
}

//-----------------------------------------------------------------------------
object sepRESaveItem(object oPC)
{
    object oReturn = gsPCGetCreatureHide(oPC);
       return oReturn;
}
//-----------------------------------------------------------------------------
void sepREApplyRespawnDrains(object oPC, int nDrain)
{
    effect eStr, eDex, eCon, eWis, eCha, eInt, eLink;
    int nStr, nDex, nCon, nWis, nCha, nInt;

    // Get Base Ability Scores of oPC
    nStr = GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE);
    nDex = GetAbilityScore(oPC, ABILITY_DEXTERITY, TRUE);
    nCon = GetAbilityScore(oPC, ABILITY_CONSTITUTION, TRUE);
    nInt = GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE);
    nWis = GetAbilityScore(oPC, ABILITY_WISDOM, TRUE);
    nCha = GetAbilityScore(oPC, ABILITY_CHARISMA, TRUE);

    // Calculate amount to drain the player by. Value is capped so their abilities cannot drop below ABILITY_DECREASE_BASE
    // If Base Strength - Penalty is less than 6, then the /penalty/ is Base strength - 6. Otherwise it is Base Strength - Penalty.
    nStr = (nStr - nDrain < GS_ABILITY_DECREASE_BASE) ? nStr - GS_ABILITY_DECREASE_BASE : nDrain;
    nDex = (nDex - nDrain < GS_ABILITY_DECREASE_BASE) ? nDex - GS_ABILITY_DECREASE_BASE : nDrain;
    nCon = (nCon - nDrain < GS_ABILITY_DECREASE_BASE) ? nCon - GS_ABILITY_DECREASE_BASE : nDrain;
    nInt = (nInt - nDrain < GS_ABILITY_DECREASE_BASE) ? nInt - GS_ABILITY_DECREASE_BASE : nDrain;
    nWis = (nWis - nDrain < GS_ABILITY_DECREASE_BASE) ? nWis - GS_ABILITY_DECREASE_BASE : nDrain;
    nCha = (nCha - nDrain < GS_ABILITY_DECREASE_BASE) ? nCha - GS_ABILITY_DECREASE_BASE : nDrain;

    // Declare Effects
    eStr = EffectAbilityDecrease(ABILITY_STRENGTH, nStr);
    eDex = EffectAbilityDecrease(ABILITY_DEXTERITY, nDex);
    eCon = EffectAbilityDecrease(ABILITY_CONSTITUTION, nCon);
    eInt = EffectAbilityDecrease(ABILITY_INTELLIGENCE, nInt);
    eWis = EffectAbilityDecrease(ABILITY_WISDOM, nWis);
    eCha = EffectAbilityDecrease(ABILITY_CHARISMA, nCha);

    // Link all effects
    eLink = EffectLinkEffects(eLink, eStr);
    eLink = EffectLinkEffects(eLink, eDex);
    // no con damage on subdual to prevent repeating deaths with low HP
    if (GetLocalInt(sepRESaveItem(oPC), "GS_RESPAWN_DRAIN_SUBDUAL") == 0) {
      eLink = EffectLinkEffects(eLink, eCon);
    }
    eLink = EffectLinkEffects(eLink, eInt);
    eLink = EffectLinkEffects(eLink, eWis);
    eLink = EffectLinkEffects(eLink, eCha);

    // Make Supernatural effect
    eLink = SupernaturalEffect(eLink);

    // Apply, dunshine: changed to tagged effect for convenience
    ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC, HoursToSeconds(GS_RESPAWN_RECOVERY_HOURS)*10, EFFECT_TAG_DEATH);
    return;
}
//----------------------------------------------------------------------------------------------------
void sepREApplyNewDeathPenalty(object oUsedBy)
{
    int nDrainLevelGrouping        = 3;
    int GS_WO_TIMEOUT_FAVOR        = 10800; // 3 hours game time. This is a copy from inc_worship as it is not a const.
    int nTimestamp                 = gsTIGetActualTimestamp();
    string sDeity                  = GetDeity(oUsedBy);

    // Ignore characters below level 6.
    if (GetHitDice(oUsedBy) < 6) return;

    // Disable pray 6 hours
    SetLocalInt(oUsedBy, "GS_WO_TIMEOUT_FAVOR", nTimestamp + 2*GS_WO_TIMEOUT_FAVOR);

    // PC alerts
    if (sDeity == "")
    {
        SendMessageToPC(oUsedBy, "You have lost the favour of the gods for a short while. If you have a change of faith and decide to start praying to them, " +
        " then you will need to wait a little while before they will hear your prayers.");
    }
    else
    {
        SendMessageToPC(oUsedBy, "The divine power of " + sDeity + " has restored you. It will be some time before you can call upon " + sDeity + " again.");
    }

}
//---------------------------------------------------------------------------------------------------
int _sepRECalculateNewDrain(object oPC)
{
        // Declare major variables
        object oSave = sepRESaveItem(oPC);
        int nTimeout;

        // check for subdual drain first
        if (GetLocalInt(oSave, "GS_RESPAWN_DRAIN_SUBDUAL") != 0) {
          // subdual always lasts 12 minutes real-life and will half after 6 minutes
          nTimeout = gsTIGetGameTimestamp(360);
        } else {
          nTimeout = 3600 * GS_RESPAWN_RECOVERY_HOURS; // Recovery ticks every.... (60 seconds * 60 minutes/game hour) x 2 game hour
        }

        int bIsDrainedSurface 	= GetLocalInt(oSave, "GS_RESPAWN_DRAIN_SURFACE");
	    int bIsDrainedCordor	= GetLocalInt(oSave, "GS_RESPAWN_DRAIN_CANDP");
        int nDrain 				= GetLocalInt(oSave, "GS_RESPAWN_DRAIN_AMT");
        int nTimestamp 			= GetLocalInt(oSave, "GS_RESPAWN_DRAIN_TIMESTAMP");
        int nActual 			= gsTIGetActualTimestamp();
        int nDiff				= abs(nTimestamp - nActual);
		string nCurrentServer = GetLocalString(GetModule(), "SERVER_NAME"); //Shameless copy of miXFGetCurrentServer() to avoid circular dependency.
		int bIsDrained = (nCurrentServer == "1") ? bIsDrainedSurface : bIsDrainedCordor;


		if ((bIsDrainedSurface && !bIsDrainedCordor && bIsDrained)||
			(!bIsDrainedSurface && bIsDrainedCordor && bIsDrained))
		{
			return -2;
		}
        if (!bIsDrained)
        {
            return -1;
        }
        // Not time for refresh
        if (nDiff < nTimeout)
        {
            return -1;
        }
        // Time for refresh
        else
        {
            // Calculate new drain amount
            if (GetLocalInt(oSave, "GS_RESPAWN_DRAIN_SUBDUAL") != 0) {
              if (GetLocalInt(oSave, "GS_RESPAWN_DRAIN_SUBDUAL") == 1) {
                SetLocalInt(oSave, "GS_RESPAWN_DRAIN_SUBDUAL", 2);
                nDrain = 5;
              } else {
                DeleteLocalInt(oSave, "GS_RESPAWN_DRAIN_SUBDUAL");
                nDrain = 0;
              }
            } else {
              nDrain = nDrain - nDiff / nTimeout;
            }

            // Drain expires
            if (nDrain == 0)
            {
                // Signal removal message.
                return 0;
            }
            // Drain has expired but PC still flagged as drained, could happen if they remain logged out for a long time.
            else if ((nDrain < 0)&&(bIsDrained))
            {
                // Signal removal message.
                return 0;
            }
            // Drained value is negative
            else if (nDrain < 0)
            {
				            // Silently remove drains
                return -2;
            }
            // Still drained.
            else
            {
                // Update variables
                SetLocalInt(oSave, "GS_RESPAWN_DRAIN_AMT", nDrain);
                SetLocalInt(oSave, "GS_RESPAWN_DRAIN_TIMESTAMP", nActual);
                return nDrain;
            }
        }
    return -3; // Error capture
}
//----------------------------------------------------------------------------------------------------
void sepREProcessHeartbeat(object oPC)
{

    int nNewDrain = _sepRECalculateNewDrain(oPC);
    string nCurrentServer = GetLocalString(GetModule(), "SERVER_NAME"); //Shameless copy of miXFGetCurrentServer() to avoid circular dependency.
    object oSave = sepRESaveItem(oPC);

    // Is drained
    if ((nNewDrain >= 0)||(nNewDrain == -2))
    {
        // Drain has ended this hour, remove all penalties and do not re-apply.
        if (nNewDrain == 0 || nNewDrain == -2)
        {
			// Be sure to remove the drain flag only from the server we're currently on, so it will be deleted on the other server
			// and lasting effects removed
            AssignCommand(oPC, sepREClearAbilityDrains(oPC));
			if (nCurrentServer == "1")
            {
				DeleteLocalInt(oSave, "GS_RESPAWN_DRAIN_SURFACE");
            }
			else if (nCurrentServer == "2" || nCurrentServer == "3")
            {
				DeleteLocalInt(oSave, "GS_RESPAWN_DRAIN_CANDP");
            }	
            DeleteLocalInt(oSave, "GS_RESPAWN_DRAIN_AMT");
            DeleteLocalInt(oSave, "GS_RESPAWN_DRAIN_TIMESTAMP");
            DeleteLocalInt(oSave, "GS_RESPAWN_DRAIN_SUBDUAL");
			if (nNewDrain == 0) SendMessageToPC(oPC, "You have fully recovered!");
        }

        // Drain is ongoing, re-apply fresh drains.
        else if (nNewDrain > 0)
        {
            // Clear any existing Ability Drains
            AssignCommand(oPC, sepREClearAbilityDrains(oPC));
            DelayCommand(0.1, AssignCommand(oPC, sepREApplyRespawnDrains(oPC, nNewDrain)));
            if (GetLocalInt(oSave, "GS_RESPAWN_DRAIN_SUBDUAL") != 0) {
              DelayCommand(0.5, SendMessageToPC(oPC, "You are recovering from the effects of unconsciousness. You should be fully recovered in about "+ IntToString(nNewDrain*10) + " minutes"));
            } else {
              DelayCommand(0.5, SendMessageToPC(oPC, "You are recovering from the effects of death. You should be fully recovered in about "+ IntToString(nNewDrain*GS_RESPAWN_RECOVERY_HOURS) + " hour(s)"));
            }
        }
    }
    else if (nNewDrain == -1)
    	{
		      //Not drained on this server, so do nothing.
    	}
    return;
}
//--------------------------------------------------------------------------------------------------
int sepREGetIsDeathEffect(effect eBad, object oPC)
{
    // dunshine: use tagged effects to determine this now
    return GetIsTaggedEffect(eBad, EFFECT_TAG_DEATH);

    /*
    object oCreator = GetEffectCreator(eBad);
    int bSelfCast = (oCreator == oPC);
    int bMatchesProfile = (GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE);
    int bMatchesProfile2 = (GetEffectSubType(eBad) == SUBTYPE_SUPERNATURAL);
    int bMatchesProfile3 = (GetEffectSpellId(eBad) == -1);
    if (bSelfCast&&bMatchesProfile&&bMatchesProfile2 && bMatchesProfile3) return TRUE;
    return FALSE;
    */
}


void gvdREApplyNewSubdualPenalty(object oUsedBy)
{
    int nDrainLevelGrouping        = 3;
    int nTimestamp                 = gsTIGetActualTimestamp();
    string sDeity                  = GetDeity(oUsedBy);

    // calculate 12 minutes to gametime
    int iDur = gsTIGetGameTimestamp(720);

    // Disable pray 12 minutes
    SetLocalInt(oUsedBy, "GS_WO_TIMEOUT_FAVOR", nTimestamp + iDur);

    // PC alerts
    if (sDeity == "")
    {
        SendMessageToPC(oUsedBy, "You have lost the favour of the gods for a short while. If you have a change of faith and decide to start praying to them, " +
        " then you will need to wait a little while before they will hear your prayers.");
    }
    else
    {
        SendMessageToPC(oUsedBy, "The divine power of " + sDeity + " has kept you alive. It will be some time before you can call upon " + sDeity + " again.");
    }
    SendMessageToPC(oUsedBy, "It will take a while for your strength to fully return to you.");

    // Calculate Drain Penalty, always start with a flat -10 on all abilities, this will lower to zero in 12 RL minutes
    int nPenalty = 10;

    // Store values on player
    object oSave = sepRESaveItem(oUsedBy);
    SetLocalInt(oSave, "GS_RESPAWN_DRAIN_SURFACE", 1);
    SetLocalInt(oSave, "GS_RESPAWN_DRAIN_CANDP", 1);
    SetLocalInt(oSave, "GS_RESPAWN_DRAIN_TIMESTAMP", nTimestamp);
    SetLocalInt(oSave, "GS_RESPAWN_DRAIN_AMT", nPenalty);
    SetLocalInt(oSave, "GS_RESPAWN_DRAIN_SUBDUAL", 1);

    // Apply
    sepREApplyRespawnDrains(oUsedBy, nPenalty);

}
