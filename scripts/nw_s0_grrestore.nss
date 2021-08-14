//::///////////////////////////////////////////////
//:: Greater Restoration
//:: NW_S0_GrRestore.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Removes all negative effects of a temporary nature
    and all permanent effects of a supernatural nature
    from the character. Does not remove the effects
    relating to Mind-Affecting spells or movement alteration.
    Heals target for 5d8 + 1 point per caster level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001

#include "x2_inc_spellhook"
#include "inc_respawn"
#include "inc_statuseffect"
#include "inc_subrace"
#include "inc_timelock"
#include "inc_effecttags"
#include "inc_effect"

// return TRUE if the effect created by a supernatural force and can't be dispelled by spells
int GetIsSupernaturalCurse(effect eEff);

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    if(GetIsTimelocked(OBJECT_SELF, "Greater Restoration"))
    {
        TimelockErrorMessage(OBJECT_SELF, "Greater Restoration");
        return;
    }
    SetTimelock(OBJECT_SELF, 240, "Greater Restoration");

    //Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eVisual = EffectVisualEffect(VFX_IMP_RESTORATION_GREATER);

    effect eBad = GetFirstEffect(oTarget);
    //Search for negative effects
    while(GetIsEffectValid(eBad))
    {
        if (sepREGetIsDeathEffect(eBad, oTarget) && !GetIsDM(OBJECT_SELF))
        {
            // Skip over the death effect
            // eBad = GetNextEffect(oTarget);
        }
        else if (sepREGetIsDeathEffect(eBad, oTarget) && GetIsDM(OBJECT_SELF))
        {
            // Kill the respawn penalty and print the values.
            int i1, i2, i3, i4;
            i1 = GetLocalInt(sepRESaveItem(oTarget), "GS_RESPAWN_DRAIN");
            i2 = GetLocalInt(sepRESaveItem(oTarget), "GS_RESPAWN_DRAIN_AMT");
            i3 = GetLocalInt(sepRESaveItem(oTarget), "GS_RESPAWN_DRAIN_TIMESTAMP");
            i4 = gsTIGetActualTimestamp();

            SendMessageToPC(OBJECT_SELF, "Respawn drain detected. These values will likely be needed for debugging, please hand these to a dev: " +
            "Drain value = " + IntToString(i1) + " Drain amt value = " + IntToString(i2) + " Drain Timestamp = " + IntToString(i3) +
            " Current Timestamp = " + IntToString(i4));

            DeleteLocalInt(sepRESaveItem(oTarget), "GS_RESPAWN_DRAIN");
            DeleteLocalInt(sepRESaveItem(oTarget), "GS_RESPAWN_DRAIN_AMT");
            DeleteLocalInt(sepRESaveItem(oTarget), "GS_RESPAWN_DRAIN_TIMESTAMP");

            SendMessageToPC(OBJECT_SELF, "Drain values have been removed from the target (which means in subsequent hours they shouldn't get a drain). Removing negative effects...");
            RemoveEffect(oTarget, eBad);
            SendMessageToPC(OBJECT_SELF, "Were all the drains removed? If so, great. If not, please include that in the hand-off to the devs as that's important to know");
        }
        else if (GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_AC_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_ATTACK_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_SAVING_THROW_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_SKILL_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_BLINDNESS ||
            GetEffectType(eBad) == EFFECT_TYPE_DEAF ||
            GetEffectType(eBad) == EFFECT_TYPE_CURSE ||
            GetEffectType(eBad) == EFFECT_TYPE_DISEASE ||
            GetEffectType(eBad) == EFFECT_TYPE_POISON ||
            GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
            GetEffectType(eBad) == EFFECT_TYPE_CHARMED ||
            GetEffectType(eBad) == EFFECT_TYPE_DOMINATED ||
            GetEffectType(eBad) == EFFECT_TYPE_DAZED ||
            GetEffectType(eBad) == EFFECT_TYPE_CONFUSED ||
            GetEffectType(eBad) == EFFECT_TYPE_FRIGHTENED ||
            GetEffectType(eBad) == EFFECT_TYPE_NEGATIVELEVEL ||
            GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
            GetEffectType(eBad) == EFFECT_TYPE_SLOW ||
            GetEffectType(eBad) == EFFECT_TYPE_STUNNED ||
            GetEffectType(eBad) == EFFECT_TYPE_CUTSCENEIMMOBILIZE )
        {
            //Remove effect if it is negative.
            if(!GetIsSupernaturalCurse(eBad))
                RemoveEffect(oTarget, eBad);
        }
        //::  Custom Poisons
        else if ( GetIsTaggedEffect(eBad, EFFECT_TAG_POISON) ) {
            RemoveTaggedEffects(oTarget, EFFECT_TAG_POISON);
        }

        eBad = GetNextEffect(oTarget);
    }
    if((GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD) &&  (gsSUGetSubRaceByName(GetSubRace(oTarget)) != GS_SU_SPECIAL_VAMPIRE))
    {
        //Apply the VFX impact and effects
        int nHeal = GetMaxHitPoints(oTarget) - GetCurrentHitPoints(oTarget);
        effect eHeal = EffectHeal(nHeal);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
    }
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_GREATER_RESTORATION, FALSE));

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);
}

int GetIsSupernaturalCurse(effect eEff)
{
    object oCreator = GetEffectCreator(eEff);
    if(GetTag(oCreator) == "q6e_ShaorisFellTemple")
        return TRUE;
    if(GetIsTaggedEffect(eEff, EFFECT_TAG_MOUNTED))
        return TRUE;
    return FALSE;
}
