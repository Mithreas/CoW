#include "inc_customspells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget   = GetSpellTargetObject();
    int nSpell       = GetSpellId();
    int nCasterLevel = AR_GetCasterLevel(OBJECT_SELF);
    int nMetaMagic   = AR_GetMetaMagicFeat();
    int nDuration    = nCasterLevel;

    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    //raise event
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));

    //affection check
    if (! gsSPGetIsAffected(GS_SP_TYPE_BENEFICIAL, OBJECT_SELF, oTarget)) return;

    // We're changing this to be an AoE Buff Spell
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF), TRUE, OBJECT_TYPE_CREATURE);

    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MINOR), EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));

    // Defenses against Evil
    eLink = EffectLinkEffects(eLink, VersusAlignmentEffect(EffectACIncrease(2, AC_DEFLECTION_BONUS), ALIGNMENT_ALL, ALIGNMENT_GOOD));
    eLink = EffectLinkEffects(eLink, VersusAlignmentEffect(EffectSavingThrowIncrease(SAVING_THROW_ALL, 2), ALIGNMENT_ALL, ALIGNMENT_GOOD));
    eLink = EffectLinkEffects(eLink, VersusAlignmentEffect(EffectSavingThrowIncrease(SAVING_THROW_WILL, 4), ALIGNMENT_ALL, ALIGNMENT_GOOD));
    // Defenses against Neutral
    eLink = EffectLinkEffects(eLink, VersusAlignmentEffect(EffectACIncrease(2, AC_DEFLECTION_BONUS), ALIGNMENT_ALL, ALIGNMENT_NEUTRAL));
    eLink = EffectLinkEffects(eLink, VersusAlignmentEffect(EffectSavingThrowIncrease(SAVING_THROW_ALL, 1), ALIGNMENT_ALL, ALIGNMENT_NEUTRAL));
    eLink = EffectLinkEffects(eLink, VersusAlignmentEffect(EffectSavingThrowIncrease(SAVING_THROW_WILL, 2), ALIGNMENT_ALL, ALIGNMENT_NEUTRAL));

    while (GetIsObjectValid(oTarget))
    {
        if(GetIsNeutral(oTarget) || GetIsFriend(oTarget)) {
            // Add safeguard against self-stacking.
            RemoveEffectsFromSpell(oTarget, nSpell);
            DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration)));
        }

        //Get next target in the spell cone
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF), TRUE);
    }

}


/*
    //apply
    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_IMP_EVIL_HELP),
        oTarget);
    ApplyEffectToObject(
        DURATION_TYPE_TEMPORARY,
        EffectLinkEffects(
            EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
            EffectLinkEffects(
                EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MINOR),
                EffectAreaOfEffect(AOE_MOB_CIRCEVIL))),
        oTarget,
        HoursToSeconds(nDuration));  */
