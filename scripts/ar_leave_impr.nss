#include "gs_inc_respawn"

void _arJumpBackToStoredLoc(object oTarget, location lLoc);

void main()
{
    object oPC = GetPCSpeaker();
    location lReturnLoc = GetLocalLocation(oPC, "AR_STORED_LOCATION");

    if (  GetIsObjectValid( GetAreaFromLocation(lReturnLoc)) ) {
        DelayCommand (2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_GATE), GetLocation(oPC)));
        DelayCommand (4.0, _arJumpBackToStoredLoc(oPC, lReturnLoc) );
    }
    //::  No Valid return location, return PC to respawn location
    else if ( GetIsPC(oPC) ) {
        location lRespawn = gsREGetRespawnLocation(oPC);

        //::  Safety check
        if (  GetIsObjectValid( GetAreaFromLocation(lRespawn)) ) {
            AssignCommand(oPC, ClearAllActions(TRUE));
            AssignCommand(oPC, JumpToLocation(lRespawn));
        }
        //::  Otherwise report to DMs a player is stuck in Imprisonment
        else SendMessageToAllDMs( "WARNING: " + GetName(oPC, TRUE) + " is stuck in the 'Imprisonment' area, no valid return location found.  Please try and help this player ASAP!");
    }
}

void _arJumpBackToStoredLoc(object oTarget, location lLoc) {
    DeleteLocalLocation(oTarget, "AR_STORED_LOCATION");
    DeleteLocalInt(oTarget, "AR_DENY_IMPRISONMENT");

    AssignCommand(oTarget, ClearAllActions(TRUE));
    AssignCommand(oTarget, JumpToLocation(lLoc));
}
