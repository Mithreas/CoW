//::///////////////////////////////////////////////
//:: Lay_On_Hands
//:: NW_S2_LayOnHand.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The Paladin is able to heal his Chr Bonus times
    his level.

    Arelith-Specific changes:  Cooldown of 10 min
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 15, 2001
//:: Updated On: Oct 20, 2003
//:://////////////////////////////////////////////
#include "nw_i0_spells"
#include "inc_pc"
#include "inc_state"
#include "inc_timelock"
#include "inc_zombie"

void main()
{
    // Check for zombification.
    if (fbZGetIsZombie(OBJECT_SELF))
    {
      if (GetIsPC(OBJECT_SELF))
      {
        FloatingTextStringOnCreature("This ability usually hurts undead. While interesting in the name of science, using it right now might not be such a good idea.", OBJECT_SELF, FALSE);
      }
      return;
    }

    // Restore feat use.
    IncrementRemainingFeatUses(OBJECT_SELF, FEAT_LAY_ON_HANDS);

    // Cooldown check.
    if(GetIsTimelocked(OBJECT_SELF, "Lay on Hands"))
    {
        TimelockErrorMessage(OBJECT_SELF, "Lay on Hands");
        return;
    }

    object oTarget = GetSpellTargetObject();
    int nChr = GetAbilityModifier(ABILITY_CHARISMA);
    if (nChr < 1)
    {
        nChr = 1;
    }
    int nLevel = GetLocalInt(gsPCGetCreatureHide(OBJECT_SELF), "FL_LEVEL") /5;
	if (nLevel < 5) nLevel = 5;

    //--------------------------------------------------------------------------
    // Caluclate the amount to heal, min is 1 hp
    //--------------------------------------------------------------------------
    int nHeal = nLevel * nChr;
    if(nHeal <= 0)
    {
        nHeal = 1;
    }
    effect eHeal = EffectHeal(nHeal);
    effect eVis = EffectVisualEffect(VFX_IMP_HEALING_M);
    effect eVis2 = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
    effect eDam;
    int nTouch;

    //--------------------------------------------------------------------------
    // A paladine can use his lay on hands ability to damage undead creatures
    // having undead class levels qualifies as undead as well
    //--------------------------------------------------------------------------
    if(GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD || GetLevelByClass(CLASS_TYPE_UNDEAD,oTarget)  || gsSUGetSubRaceByName(GetSubRace(oTarget)) == GS_SU_SPECIAL_VAMPIRE)
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_LAY_ON_HANDS));
        //Make a ranged touch attack
        nTouch = TouchAttackMelee(oTarget,TRUE);

        if(nTouch > 0)
        {
                     if(nTouch == 2)
                            nHeal *= 2;

                     SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_LAY_ON_HANDS));
            eDam = EffectDamage(nHeal, DAMAGE_TYPE_DIVINE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
        }
    }
    else
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_LAY_ON_HANDS, FALSE));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }

    // Set Cooldown to 10 minutes (10 turns).  Refresh reminder every 2m, final reminder at 30 seconds.
    SetTimelock(OBJECT_SELF, FloatToInt(TurnsToSeconds(10)), "Lay on Hands", 120, 30);
	gsSTDoCasterDamage(OBJECT_SELF, 5); 

}

