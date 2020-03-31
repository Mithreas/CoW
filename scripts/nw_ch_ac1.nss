//::///////////////////////////////////////////////
//:: Associate: Heartbeat
//:: NW_CH_AC1.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Move towards master or wait for him
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 21, 2001
//:: Updated On: Jul 25, 2003 - Georg Zoeller
//:://////////////////////////////////////////////

#include "x0_inc_henai"
#include "x2_inc_summscale"
#include "x2_inc_spellhook"
#include "x3_inc_horse"
#include "inc_associates"

void _MakeHenchman(object oMaster)
{
	// Set default henchman event handlers.
	SetEventScript(OBJECT_SELF, EVENT_SCRIPT_CREATURE_ON_HEARTBEAT, "nw_ch_ac1");
	SetEventScript(OBJECT_SELF, EVENT_SCRIPT_CREATURE_ON_NOTICE, "nw_ch_ac2");
	SetEventScript(OBJECT_SELF, EVENT_SCRIPT_CREATURE_ON_SPELLCASTAT, "nw_ch_acb");
	SetEventScript(OBJECT_SELF, EVENT_SCRIPT_CREATURE_ON_MELEE_ATTACKED, "nw_ch_ac5");
	SetEventScript(OBJECT_SELF, EVENT_SCRIPT_CREATURE_ON_DAMAGED, "nw_ch_ac6");
	SetEventScript(OBJECT_SELF, EVENT_SCRIPT_CREATURE_ON_DISTURBED, "nw_ch_ac8");
	SetEventScript(OBJECT_SELF, EVENT_SCRIPT_CREATURE_ON_END_COMBATROUND, "nw_ch_ac3");
	SetEventScript(OBJECT_SELF, EVENT_SCRIPT_CREATURE_ON_DIALOGUE, "nw_ch_ac4");
	SetEventScript(OBJECT_SELF, EVENT_SCRIPT_CREATURE_ON_SPAWN_IN, "nw_ch_ac9");
	SetEventScript(OBJECT_SELF, EVENT_SCRIPT_CREATURE_ON_RESTED, "");
	SetEventScript(OBJECT_SELF, EVENT_SCRIPT_CREATURE_ON_DEATH, "nw_ch_ac7");
	SetEventScript(OBJECT_SELF, EVENT_SCRIPT_CREATURE_ON_USER_DEFINED_EVENT, "nw_ch_acd");
	SetEventScript(OBJECT_SELF, EVENT_SCRIPT_CREATURE_ON_BLOCKED_BY_DOOR, "nw_ch_ace");

    // Add as henchman.
    AddHenchman(oMaster);
}

void main()
{   //SpawnScriptDebugger();
   // Addition by Mithreas - if a creature's master is no longer around,
   // remove the creature.
   if (!HorseGetIsAMount(OBJECT_SELF) &&
       !GetIsObjectValid(GetMaster(OBJECT_SELF)))
   {
     // The balor summoned by the Gate spell has this script set even when
     // summoned as a hostile. So exclude it.
     if (!GetLocalInt(OBJECT_SELF, "MI_PERSISTS") &&
         !GetIsEnemy(GetFirstPC(), OBJECT_SELF))
     {
       SpeakString("*Wanders off*");
       SetIsDestroyable(TRUE,FALSE,FALSE);
       DestroyObject(OBJECT_SELF);
     }
     //::  Added by ActionReplay - Special Fix for Recruitable Henchmen
     else if ( GetLocalInt(OBJECT_SELF, "AR_IS_RECRUITED") ) {
        SetLocalInt(OBJECT_SELF, "AR_IS_RECRUITED", FALSE);
        AssignCommand( OBJECT_SELF, ClearAllActions());
        AssignCommand( OBJECT_SELF, SpeakString("Contract complete...") );
        AssignCommand( OBJECT_SELF, ActionJumpToObject( GetObjectByTag("AR_HENCH_WP_" + GetTag(OBJECT_SELF) ) ) );
     }
   }

   // dunshine: quit this function for lassoed creatures, to prevent them from become henchman
   if (GetLocalObject(GetMaster(OBJECT_SELF), "gvd_lasso_capture") == OBJECT_SELF) {
     return;
   }

    // Rangers get to use animal empathy better.
    if (GetAssociateType(OBJECT_SELF) == ASSOCIATE_TYPE_DOMINATED  &&
        (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_ANIMAL ||
         GetRacialType(OBJECT_SELF) == RACIAL_TYPE_BEAST ||
         GetRacialType(OBJECT_SELF) == RACIAL_TYPE_MAGICAL_BEAST))
    {
      object oMaster = GetMaster();

        if (IntToFloat(GetLevelByClass(CLASS_TYPE_RANGER, oMaster)) /
            IntToFloat(GetHitDice(oMaster)) >= 0.75)
        {
          // Convert this dominated creature into a henchman.
          effect eDom = GetFirstEffect(OBJECT_SELF);
          while (GetIsEffectValid(eDom))
          {
            if (GetEffectType(eDom) == EFFECT_TYPE_DOMINATED)
            {
              RemoveEffect(OBJECT_SELF, eDom);
            }

            eDom = GetNextEffect(OBJECT_SELF);
          }

          DelayCommand(0.1, _MakeHenchman(oMaster));
        }
    }

    if (GetIsAssociateAIEnabled() || GetIsAssociateAttackTargetInvalid())
    {
        // If our master is in combat, and we're not, get into combat ourselves.
        if (!GetIsInCombat() && GetIsObjectValid(GetMaster()) &&
               GetIsInCombat(GetMaster()))
        {
            HenchmenCombatRound();
        }
        // Or if our master is in stealth and we are not, start sneaking.
        else if (GetStealthMode(GetMaster()) && !GetStealthMode(OBJECT_SELF))
        {
            SetActionMode(OBJECT_SELF,ACTION_MODE_STEALTH,TRUE);
        }
        // Or if they have left stealth and we haven't, stop sneaking.
        else if (!GetStealthMode(GetMaster()) && GetStealthMode(OBJECT_SELF))
        {
            SetActionMode(OBJECT_SELF,ACTION_MODE_STEALTH,FALSE);
        }
    }
    else
    {
        // We have a valid attack target. Let's make sure associate is attacking it.
        DetermineCombatRound(GetAssociateAttackTarget());
    }

    // GZ: Fallback for timing issue sometimes preventing epic summoned creatures from leveling up to their master's level.
    // There is a timing issue with the GetMaster() function not returning the fof a creature
    // immediately after spawn. Some code which might appear to make no sense has been added
    // to the nw_ch_ac1 and x2_inc_summon files to work around this
    // This code is only run at the first hearbeat
    int nLevel =SSMGetSummonFailedLevelUp(OBJECT_SELF);
    if (nLevel != 0)
    {
        int nRet;
        if (nLevel == -1) // special shadowlord treatment
        {
          SSMScaleEpicShadowLord(OBJECT_SELF);
        }
        else if  (nLevel == -2)
        {
          SSMScaleEpicFiendishServant(OBJECT_SELF);
        }
        else
        {
            nRet = SSMLevelUpCreature(OBJECT_SELF, nLevel, CLASS_TYPE_INVALID);
            if (nRet == FALSE)
            {
                WriteTimestampedLogEntry("WARNING - nw_ch_ac1:: could not level up " + GetTag(OBJECT_SELF) + "!");
            }
        }

        // regardless if the actual levelup worked, we give up here, because we do not
        // want to run through this script more than once.
        SSMSetSummonLevelUpOK(OBJECT_SELF);
    }

    // Check if concentration is required to maintain this creature
    X2DoBreakConcentrationCheck();

    object oMaster = GetMaster();
    if(!GetAssociateState(NW_ASC_IS_BUSY))
    {
        if (GetIsAssociateAIEnabled())
        {
            object oTrap = GetNearestTrapToObject();
            if (bkAttemptToDisarmTrap(oTrap) == TRUE)
            {
                return ;
            } // succesful trap found and disarmed
        }

        if(GetIsObjectValid(oMaster) &&
           GetCurrentAction(OBJECT_SELF) != ACTION_DISABLETRAP &&
           GetCurrentAction(OBJECT_SELF) != ACTION_OPENLOCK &&
           GetCurrentAction(OBJECT_SELF) != ACTION_REST &&
           GetCurrentAction(OBJECT_SELF) != ACTION_ATTACKOBJECT)
        {
            if(!GetIsObjectValid(GetAttackTarget()) &&
               !GetIsObjectValid(GetAttemptedSpellTarget()) &&
               !GetIsObjectValid(GetAttemptedAttackTarget()))
            {
                if(GetDistanceToFollowObject() > ASSOCIATE_FOLLOW_DISTANCE && !GetIsFighting(OBJECT_SELF) && !GetAssociateState(NW_ASC_MODE_STAND_GROUND))
                {
                    if(GetAssociateState(NW_ASC_AGGRESSIVE_STEALTH) || GetAssociateState(NW_ASC_AGGRESSIVE_SEARCH))
                    {
                        if(GetAssociateState(NW_ASC_AGGRESSIVE_SEARCH))
                        {
                            ClearAllActions();
                            ActionUseSkill(SKILL_SEARCH, OBJECT_SELF);
                        }
                    }

                    if(GetIsAssociateAIEnabled() || GetLastAssociateAction(OBJECT_SELF) == ASSOCIATE_COMMAND_FORCE_FOLLOW)
                    {
                        AssociateForceFollow(OBJECT_SELF);
                    }
                }
            }
        }
        // * if I am dominated, ask for some help
        if (GetHasEffect(EFFECT_TYPE_DOMINATED, OBJECT_SELF) == TRUE && GetIsEncounterCreature(OBJECT_SELF) == FALSE)
        {
            SendForHelp();
        }

        SignalEvent(OBJECT_SELF, EventUserDefined(1001));
    }
}
