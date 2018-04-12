//::///////////////////////////////////////////////
//:: Associate: End of Combat End
//:: NW_CH_AC3
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Calls the end of combat script every round
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 16, 2001
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Modified By: Deva Winblood
//:: Modified On: Jan 4th, 2008
//:: Added Support for Mounted Combat Feat Support
//:://////////////////////////////////////////////

#include "X0_INC_HENAI"
#include "inc_spell"
#include "inc_associates"
#include "inc_npccooldowns"

void main()
{
    if (!GetLocalInt(GetModule(),"X3_NO_MOUNTED_COMBAT_FEAT"))
    { // set variables on target for mounted combat
        DeleteLocalInt(OBJECT_SELF,"bX3_LAST_ATTACK_PHYSICAL");
        DeleteLocalInt(OBJECT_SELF,"nX3_HP_BEFORE");
        DeleteLocalInt(OBJECT_SELF,"bX3_ALREADY_MOUNTED_COMBAT");
    } // set variables on target for mounted combat

    // UNINTERRUPTIBLE ACTIONS
    if(GetAssociateState(NW_ASC_IS_BUSY)
       || GetAssociateState(NW_ASC_MODE_STAND_GROUND))
    {
        // We're busy, don't do anything
    }
    else if(!GetSpawnInCondition(NW_FLAG_SET_WARNINGS))
    {
        if (GetIsAssociateAIEnabled() || GetIsAssociateAttackTargetInvalid())
        {
            HenchmenCombatRound(OBJECT_INVALID);
        }
    }

    SignalEvent(OBJECT_SELF, EventUserDefined(1003));

    // Check if concentration is required to maintain this creature
    X2DoBreakConcentrationCheck();

    UpdateNPCCooldownAbilities();
}

