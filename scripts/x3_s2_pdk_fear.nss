//::///////////////////////////////////////////////
//:: Purple Dragon Knight - Fear ability
//:: x3_s2_pdk_fear.nss
//:://////////////////////////////////////////////
//:: Enemies must make a Will Save
//:: or suffer a PDK / 4 penalty
//:: to AC, AB, saving throws, skill checks,
//:: and 5% Arcane Spell Failure (minimum:
//:: penalty of 1). Mind Immunity does not
//:: block this effect, nor can it be
//:: removed via Restoration.
//:: (Vanguard 7): Penalties are doubled
//:: for the first three rounds.
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: Sept 22, 2005
//:://////////////////////////////////////////////

#include "inc_statuseffect"
#include "inc_tempvars"
#include "inc_class"
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "inc_timelock"

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    int bVanguard = GetLocalInt(gsPCGetCreatureHide(oPC), VAR_PDK) == MI_CL_PDK_VANGUARD;
    int nCL    = GetLevelByClass(CLASS_TYPE_PURPLE_DRAGON_KNIGHT, oPC);
    // int nUsed  = GetLocalInt(oPC, "PDK_FEAR_USES");

    // if (bVanguard && nUsed < nCL)
    // {
    SetRemainingFeatUses(oPC, 1082, 1);
    //  SetTempInt(oPC, "PDK_FEAR_USES", nUsed + 1, TEMP_VARIABLE_EXPIRATION_EVENT_REST);
    //  SendMessageToPC(oPC, "Fear used " + IntToString(nUsed + 1) + " time(s) today.");
    //}

    // Cooldown check.
    if(GetIsTimelocked(OBJECT_SELF, "PDK Fear"))
    {
        TimelockErrorMessage(OBJECT_SELF, "PDK Fear");
        return;
    }

    // The DC of this ability is 10 + PDK Levels + (Intimidate / 3)
    int nDC = 10 + GetLevelByClass(CLASS_TYPE_PURPLE_DRAGON_KNIGHT, OBJECT_SELF) + (GetSkillRank(SKILL_INTIMIDATE, OBJECT_SELF) / 3);
    int nPenalty = GetLevelByClass(CLASS_TYPE_PURPLE_DRAGON_KNIGHT, OBJECT_SELF) / 4;
    if (nPenalty < 1)
        nPenalty = 1;

    float fDelay;// For delay value
    object oTarget;// Target object
    effect eLink; // linked debuff effect
    effect eVanLink; // vanguard linked debuff
    effect eVan; // Additional linked effects from vanguard
    effect eSave = EffectVisualEffect(VFX_IMP_WILL_SAVING_THROW_USE);

    // Apply Impact VFX
    PlayVoiceChat(VOICE_CHAT_BATTLECRY2);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());

    // Get first target in the spell cone
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation(), TRUE);

    // Keep processing targets until no valid ones left
    while(GetIsObjectValid(oTarget))
    {
        if (GetIsEnemy(oTarget))
        {
            fDelay = GetRandomDelay();

            // Cause the SpellCastAt event to be triggered on oTarget
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FEAR));

            if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR) && !GetIsImmune(oTarget, IMMUNITY_TYPE_FEAR, OBJECT_SELF)) {
                // We're no longer using Apply Fear to get around mind immunities.
                eLink = EffectACDecrease(nPenalty);
                eLink = EffectLinkEffects(eLink, EffectSavingThrowDecrease(SAVING_THROW_ALL, nPenalty));
                eLink = EffectLinkEffects(eLink, EffectAttackDecrease(nPenalty));
                eLink = EffectLinkEffects(eLink, EffectSpellFailure(5 * nPenalty));
                eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_PDK_FEAR));
                eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
                eLink = eLink = ExtraordinaryEffect(eLink);
                // Double debuff for 3 rounds if Vanguard
                if (bVanguard) {
                    eVanLink = EffectACDecrease(nPenalty * 2);
                    eVanLink = EffectLinkEffects(eVanLink, EffectSavingThrowDecrease(SAVING_THROW_ALL, nPenalty * 2));
                    eVanLink = EffectLinkEffects(eVanLink, EffectAttackDecrease(nPenalty * 2));
                    eVanLink = EffectLinkEffects(eVanLink, EffectSpellFailure(5 * nPenalty * 2));
                    eVanLink = EffectLinkEffects(eVanLink, EffectVisualEffect(VFX_DUR_PDK_FEAR));
                    eVanLink = EffectLinkEffects(eVanLink, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
                    eVanLink = eVanLink = ExtraordinaryEffect(eVanLink);
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVanLink, oTarget, RoundsToSeconds(3)));
                    DelayCommand(fDelay + 0.1 + RoundsToSeconds(3), ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(7)));
                } else {
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(1)));
                }
            } else {
                // Apply a VFX to show we're OK.
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSave, oTarget));
            }
        }
        //Get next target in the spell cone
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation(), TRUE);
    }

    // 3 min Cooldown, 1.5 min for Vanguards
    if (bVanguard)
        SetTimelock(OBJECT_SELF, FloatToInt(RoundsToSeconds(15)), "PDK Fear", 60, 30);
    else
        SetTimelock(OBJECT_SELF, FloatToInt(TurnsToSeconds(3)), "PDK Fear", 60, 30);

}




/*  OLD CODE
    int nIntensity = GetLocalInt(GetModule(), "STATIC_LEVEL") ? nCL : (nCL / 2);

    // Declare/assign major variables
    object oTarget;// Target object

    //Check to see if the caster has Lasting Impression and increase duration.
    if(GetHasFeat(870))
    {
        nCL *= 10;
    }

    // lingering song
    if(GetHasFeat(424)) // lingering song
    {
        nCL += 5;
    }

    float fDuration = RoundsToSeconds(nCL);
    float fDelay;// For delay value
    effect eSave = EffectVisualEffect(VFX_IMP_WILL_SAVING_THROW_USE);

    // Apply Impact VFX
    PlayVoiceChat(VOICE_CHAT_BATTLECRY2);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());

    // Get first target in the spell cone
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation(), TRUE);

    // Keep processing targets until no valid ones left
    while(GetIsObjectValid(oTarget))
    {
        if (GetIsEnemy(oTarget))
        {
            fDelay = GetRandomDelay();

            // Cause the SpellCastAt event to be triggered on oTarget
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FEAR));

            // Make an opposed concentration check
            // Immunities are checked in ApplyFear.
            if( !GetIsSkillSuccessful(oTarget, SKILL_CONCENTRATION, d20() + GetSkillRank(SKILL_INTIMIDATE, oPC)) )
            {
                //Apply the linked effects and the VFX impact
                DelayCommand(fDelay, ApplyFear(oTarget, nIntensity, fDuration));
            }
            else
            {
                // Apply a VFX to show we're OK.
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSave, oTarget));
            }
        }
        //Get next target in the spell cone
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation(), TRUE);
    }
*/
