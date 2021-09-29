//::///////////////////////////////////////////////
//:: Zenorian Combat
//:: ZEN_CBR_FERADETH
//:: (c) 2000-2006 CNSDEV (http://cnsdev.dk)
//:://////////////////////////////////////////////
/*
    Calls the end of combat script every round.
*/
//:://////////////////////////////////////////////
//:: Created By: cns (cns@cnsdev.dk)
//:: Created On: Feb 21, 2006
//:://////////////////////////////////////////////
#include "NW_I0_GENERIC"
#include "inc_generic"

object GetRandomPartyMember1(object oPC)
{
    // Don't run this command if oPC isNOT a PC!
    if (!GetIsPC(oPC)) { return oPC; }

    int nPartyMembers = 1;
    object oPartyMember = GetFirstFactionMember(oPC, FALSE);
    SetLocalObject(OBJECT_SELF, "TARGET0", oPartyMember);

    while (GetIsObjectValid(oPartyMember) == TRUE)
    {
        oPartyMember = GetNextFactionMember(oPC, FALSE);
        if (oPartyMember != OBJECT_INVALID && (GetArea(oPartyMember) == GetArea(OBJECT_SELF)))
        {
            SetLocalObject(OBJECT_SELF, "TARGET" + IntToString(nPartyMembers), oPartyMember);
            //DEBUG SpeakString("Adding " + GetName(oPartyMember) + " to the target list.");
            nPartyMembers++;
        }
    }

    int nDice = Random(nPartyMembers);
    //DEBUG SpeakString("Chose:" + GetName(GetLocalObject(OBJECT_SELF, "TARGET" + IntToString(nDice))));
    object oTarget = GetLocalObject(OBJECT_SELF, "TARGET" + IntToString(nDice));
    if (oTarget == OBJECT_INVALID) { return oPC; }
    return oTarget;
}

object GetRandomPartyMember(object oPC, int nOption=0)
{
// nOption=1: Returns the target with the lowest amount of Healthpoints

    int nAttackers = 1;
    object oAttacker = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, 0, CREATURE_TYPE_IS_ALIVE, TRUE);
    object oLowest = oAttacker;
    SetLocalObject(OBJECT_SELF, "TARGET0", oAttacker);

    while (GetIsObjectValid(oAttacker) == TRUE)
    {
        oAttacker = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, nAttackers, CREATURE_TYPE_IS_ALIVE, TRUE);
        if (oAttacker != OBJECT_INVALID && (GetArea(oAttacker) == GetArea(OBJECT_SELF)))
        {
            SetLocalObject(OBJECT_SELF, "TARGET" + IntToString(nAttackers), oAttacker);
            //DEBUGSpeakString("Adding " + GetName(oAttacker) + " to the target list.");
            if ((nOption=1) && (GetCurrentHitPoints(oAttacker)>GetCurrentHitPoints(oLowest))) oLowest = oAttacker;
            nAttackers++;
        }
    }

    int nDice = Random(nAttackers);
    //DEBUGSpeakString("Chose:" + GetName(GetLocalObject(OBJECT_SELF, "TARGET" + IntToString(nDice))));
    object oTarget = GetLocalObject(OBJECT_SELF, "TARGET" + IntToString(nDice));
    if (nOption=1) { return oLowest; }
    else if (oTarget == OBJECT_INVALID) { return oPC; }
    return oTarget;
}

void Reset()
{
    effect eHeal = EffectHeal(GetMaxHitPoints(OBJECT_SELF));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, OBJECT_SELF);
    //DEBUG: SpeakString("lol you lose!");
}

void AI_STEALTH_CORE(object oTarget=OBJECT_INVALID, int nAppear=0)
{
    // Get current target
    object oTank = GetAttackTarget(OBJECT_SELF);
    // Create effects.
    effect eStealth = EffectEthereal();
    effect eGhostMode = EffectCutsceneGhost();
    effect vSmoke = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);

    if ((oTarget != OBJECT_INVALID && oTarget != oTank) && (nAppear!=1))
    {

        // Stop attacking
        ClearAllActions();

        // Apply effects to SELF.
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStealth, OBJECT_SELF, 6.0);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, vSmoke, GetLocation(OBJECT_SELF));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eGhostMode, OBJECT_SELF);

        ActionJumpToObject(oTarget);
        DelayCommand(1.0, ActionAttack(oTarget));
    }
    else
    {
        RemoveEffect(OBJECT_SELF, eStealth);
    }
}

void AI_SPIT_CORE(object oTarget=OBJECT_INVALID)
{
    // Make sure we don't have any stealth effect up.
    AI_STEALTH_CORE(OBJECT_INVALID, 1);

    // Create Damage Effect
    float fDistance = GetDistanceToObject(oTarget);
    int nDamage = FloatToInt(fDistance)*10;
    effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_ACID);

    // Create projectile effect.
    ActionCastFakeSpellAtObject(SPELL_ACID_SPLASH, oTarget, PROJECTILE_PATH_TYPE_HOMING);

    // Apply Damage
    DelayCommand(1.0+(fDistance*0.10)/2, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
}

void _MakeHenchman(object oMaster, object oHench)
{
	// Set default henchman event handlers.
	SetEventScript(oHench, EVENT_SCRIPT_CREATURE_ON_HEARTBEAT, "nw_ch_ac1");
	SetEventScript(oHench, EVENT_SCRIPT_CREATURE_ON_NOTICE, "nw_ch_ac2");
	SetEventScript(oHench, EVENT_SCRIPT_CREATURE_ON_SPELLCASTAT, "nw_ch_acb");
	SetEventScript(oHench, EVENT_SCRIPT_CREATURE_ON_MELEE_ATTACKED, "nw_ch_ac5");
	SetEventScript(oHench, EVENT_SCRIPT_CREATURE_ON_DAMAGED, "nw_ch_ac6");
	SetEventScript(oHench, EVENT_SCRIPT_CREATURE_ON_DISTURBED, "nw_ch_ac8");
	SetEventScript(oHench, EVENT_SCRIPT_CREATURE_ON_END_COMBATROUND, "nw_ch_ac3");
	SetEventScript(oHench, EVENT_SCRIPT_CREATURE_ON_DIALOGUE, "nw_ch_ac4");
	SetEventScript(oHench, EVENT_SCRIPT_CREATURE_ON_SPAWN_IN, "nw_ch_ac9");
	SetEventScript(oHench, EVENT_SCRIPT_CREATURE_ON_RESTED, "");
	SetEventScript(oHench, EVENT_SCRIPT_CREATURE_ON_DEATH, "nw_ch_ac7");
	SetEventScript(oHench, EVENT_SCRIPT_CREATURE_ON_USER_DEFINED_EVENT, "nw_ch_acd");
	SetEventScript(oHench, EVENT_SCRIPT_CREATURE_ON_BLOCKED_BY_DOOR, "nw_ch_ace");

    // Add as henchman.
    AddHenchman(oMaster, oHench);
}

object AI_DOM_CORE(object oTarget=OBJECT_INVALID, int nTerminate=0)
{
    ///////////////////////////////////////////////////////////
    // If AI dosn't find a dominated target or the dominated
    // target is dead, create a new one + all the eyecandy that
    // goes along with the whole procedure!
    ///////////////////////////////////////////////////////////
    object oDominated = GetLocalObject(OBJECT_SELF, "zen_copy");
    if ((oDominated == OBJECT_INVALID) || (GetIsDead(oDominated) == TRUE))
    {
        // Make sure our target isn't dead or unavailible.
        if ((oTarget == OBJECT_INVALID) || (GetIsDead(oTarget) == TRUE))
        {
            return OBJECT_INVALID;
        }

        // Create visual effect(s).
        effect vRedRing = EffectVisualEffect(VFX_COM_BLOOD_CRT_RED);
        effect vTimeStop = EffectVisualEffect(VFX_FNF_TIME_STOP);
        effect vSummon = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_2);

        // Make boss stop attacking PC
        ClearAllActions();

        // Create Dominate Dummy
        object oDominated = CopyObject(oTarget, GetLocation(oTarget), OBJECT_SELF, "zen_copy");

        // Apply visualeffect (?) to target.
        ApplyEffectToObject(DURATION_TYPE_INSTANT, vRedRing, oTarget);

        // Apply visualeffect and speech to self.
        ApplyEffectToObject(DURATION_TYPE_INSTANT, vTimeStop, OBJECT_SELF);
        SpeakString("*" + GetName(OBJECT_SELF) + " eyes " + GetName(oTarget) + "*");

        // Apply visualeffect to the dummy (?)
        DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, vSummon, oDominated));

        // Handle all the practical things with our new minion.
        // Faction, Commandable flag, looting etc.
        ChangeFaction(oDominated, OBJECT_SELF);

        SetCommandable(TRUE, oDominated);
        SetLootable(oDominated, FALSE);
        AssignCommand(oDominated, SetIsDestroyable(FALSE, FALSE, FALSE));

        // Add dominated as henchman to OBJECT_SELF.
        _MakeHenchman(OBJECT_SELF, oDominated);
		
		// no drops
		SetInventoryDroppable(oDominated, 0);

		// Work around the fact that clones can be disarmed by giving them +150 discipline.
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillIncrease(SKILL_DISCIPLINE, 150), oDominated);

        // Save the dominated target so we can find it later.
        SetLocalObject(OBJECT_SELF, "zen_copy", oDominated);
		
        // Execute henchman script on dominated so it dosn't linger.
        DelayCommand(3.0, ExecuteScript("nw_ch_ac3", oDominated));
    }
    ///////////////////////////////////////////////////////////
    // If AI does infact find something living under it's control
    // and the flag nTerminate is TRUE then we blow the shit...
    // but first we move the minion to target and THEN detonate!
    // HAhhahaahhahah <- evil laugh!
    ///////////////////////////////////////////////////////////
    else if (nTerminate == 1)
    {
        // Create visual effect(s).
        effect vGore = EffectVisualEffect(VFX_COM_CHUNK_RED_LARGE);
        effect eDeath = EffectDeath(FALSE, FALSE);
        effect eGlow = EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MAJOR);
        effect eRed = EffectVisualEffect(VFX_DUR_PARALYZED);

        // Locate low HP target and move to it.
        AssignCommand(oDominated, ClearAllActions());
        AssignCommand(oDominated, ActionMoveToObject(oTarget, TRUE));
        //DEBUG: AssignCommand(oDominated, SpeakString("moving to: " + GetName(oTarget)));

        // Get distance between minion and target.
        float fDistance = GetDistanceBetween(oDominated, oTarget);
        // Apply the effect to our minion, with the appropriate delay.
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGlow, oDominated);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRed, oDominated);
        DelayCommand(fDistance, ApplyEffectToObject(DURATION_TYPE_INSTANT, vGore, oDominated));
        DelayCommand(fDistance, ExecuteScript("zen_explode_s", oDominated));
        DelayCommand(fDistance, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oDominated));
        //DestroyObject(oDominated);
    }
return oDominated;
}

object TargetManagement()
{
    object oTarget;
    // Target Management and Attack Management
    if (GetAttackTarget(OBJECT_SELF) == OBJECT_INVALID)
    {
        oTarget = GetNearestEnemy(OBJECT_SELF);
        ActionAttack(oTarget);
    }
    else
    {
        oTarget = GetAttackTarget(OBJECT_SELF);
        SetLocalObject(OBJECT_SELF, "CURRENT_TARGET", oTarget);
    }

    // Check if out of range and do ranged if that is the case!
    if ((GetCurrentAction(OBJECT_SELF) == ACTION_ATTACKOBJECT) && (GetDistanceToObject(oTarget) > 3.5))
    {
        ClearAllActions();
        AI_SPIT_CORE(oTarget);
        //DEBUG: SpeakString("out of range");
    }

    return oTarget;
}

void AI_MINION_CORE(object oTarget, object oMaster)
{
    // Get oMaster HP percentage
    float fMaxHP = IntToFloat(GetMaxHitPoints(oMaster));
    float fCurHP = IntToFloat(GetCurrentHitPoints(oMaster));
    int nHitpoints = FloatToInt((fCurHP/fMaxHP)*100);
    if (nHitpoints < 20)
    {
        ClearAllActions();
        TalentHeal();
        //SpeakString("I should heal my master now!" + IntToString(nHitpoints));
        return;
    }

    DetermineCombatRound();

    //ActionAttack(oTarget);
}

void main()
{
    //DetermineCombatRound();

    //Get Combat Information.
    // - oTarget = Nearest Target
    // - oMinion = Current Minion
    // - isInCombat = TRUE if in Combat, FALSE if not.
    object oMinion = AI_DOM_CORE();
    object oTarget = TargetManagement();
    int isInCombat = GetIsInCombat(OBJECT_SELF);

    ///////////////////////////////////////////////
    // THRESHOLDS
    ///////////////////////////////////////////////
    // thClone = AI_DOM_CORE (Copy)
    int thClone = GetLocalInt(OBJECT_SELF, "thClone");
    if (!thClone)
    {
        thClone = 3;
        SetLocalInt(OBJECT_SELF, "thClone", thClone);
    }
    ///////////////////////////////////////////////
    // thKill = AI_DOM_CORE (Terminate)
    int thKill = GetLocalInt(OBJECT_SELF, "thKill");
    if (!thKill)
    {
        thKill = 8;
        SetLocalInt(OBJECT_SELF, "thKill", thKill);
    }
    ///////////////////////////////////////////////
    // thVanish = AI_STEALTH_CORE (Vanish)
    int thVanish = GetLocalInt(OBJECT_SELF, "thVanish");
    if (!thVanish)
    {
        thVanish = 11;
        SetLocalInt(OBJECT_SELF, "thVanish", thVanish);
    }
    ///////////////////////////////////////////////

    // Get CombatRound / SetCombatRound!
    int nRound = GetLocalInt(OBJECT_SELF, "COMBAT_ROUND");
    SetLocalInt(OBJECT_SELF, "COMBAT_ROUND", nRound+1);
    //DEBUGSpeakString("Mod(" + IntToString(nRound) + "), thClone: " + IntToString(nRound%thClone) + ", thKill: " + IntToString(nRound%thKill) + ", thVanish: " + IntToString(nRound%thVanish));

    // If out of combat, reset encounter.
    if (!isInCombat)
    {
        Reset();
    }

    if (nRound != 0)
    {
        if (nRound%thClone == 0)
        {
            if ((oMinion == OBJECT_INVALID) || GetIsDead(oMinion))
            {
                AI_DOM_CORE(GetRandomPartyMember(oTarget));
            }
        }
        else if (nRound%thKill == 0)
        {
            if (oMinion != OBJECT_INVALID)
            {
                AI_DOM_CORE(oTarget,1);
            }
        }
        else if (nRound%thVanish == 0)
        {
            AI_STEALTH_CORE(GetRandomPartyMember(oTarget));
        }
        else
        {
        TargetManagement();
        }
     }

    // Run combatround for minion/copy/whatever.
    if (oMinion != OBJECT_INVALID)
    {
        AssignCommand(oMinion, AI_MINION_CORE(oTarget, OBJECT_SELF));
    }

    // ClearAllActions();
}




