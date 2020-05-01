#include "inc_customspells"
#include "inc_spellsword"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget     = GetSpellTargetObject();
    location lLocation = GetSpellTargetLocation();
    effect eEffect1;
    effect eEffect2    =
        ExtraordinaryEffect(
            EffectLinkEffects(
                EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE),
                EffectSpellResistanceDecrease(10)));
    effect eVisual1    = EffectVisualEffect(VFX_IMP_HEAD_ODD);
    effect eVisual2    = EffectVisualEffect(VFX_IMP_BREACH);
    float fDuration    = RoundsToSeconds(10);
    int nSpell         = GetSpellId();
    int nCasterLevel   = AR_GetCasterLevel(OBJECT_SELF);
    if (nCasterLevel > 22) nCasterLevel = 22;
    // Addition by Mithreas - give a bonus to dispel checks based on abjuration
    // focuses, and give a penalty if the target has arcane defense.
    // Addition by Mithreas - give a bonus to dispel checks based on abjuration
    // focuses.
    nCasterLevel += GetSpellDCModifiers(OBJECT_SELF, SPELL_SCHOOL_ABJURATION);

    int nHarmful       = FALSE;

    //visual effect
    ApplyEffectAtLocation(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_FNF_DISPEL_DISJUNCTION),
        lLocation);

    if (GetIsObjectValid(oTarget))
    {
        // Modify DC for target's arcane defense feats.
        if (GetHasFeat(FEAT_ARCANE_DEFENSE_ABJURATION, oTarget)) nCasterLevel -= GetSpellDCModifiers(oTarget, SPELL_SCHOOL_ABJURATION);

        // Modify DC if target is Spellsword
        if (miSSGetIsSpellsword(oTarget)) nCasterLevel -=3;

        // Modify DC if target has at least 21 paladin levels.
        if (GetLevelByClass(CLASS_TYPE_PALADIN, oTarget) > 20) nCasterLevel -=3;

        // Add Harper Scout CL
        nCasterLevel -= (GetLevelByClass(CLASS_TYPE_HARPER, oTarget));			
		
		// Add bonus CL.
		nCasterLevel -= (AR_GetCasterLevelBonus(oTarget));
		
        //raise event
        nHarmful  = ! GetIsReactionTypeFriendly(oTarget);
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, nHarmful));

        //apply
		if (nCasterLevel < 1) nCasterLevel = 1;
        eEffect1  = EffectLinkEffects(eVisual1, EffectDispelMagicAll(nCasterLevel));
        gsSPApplyEffect(oTarget, eEffect1, nSpell);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual2, oTarget);
        DoSpellBreach(oTarget, 6, 0, GetSpellId());
        // gsSPApplySpellBreach(oTarget, 6);
        gsSPApplyEffect(oTarget, eEffect2, nSpell, fDuration);
    }
    else
    {
        int nType = OBJECT_TYPE_SPELLTARGET | OBJECT_TYPE_AREA_OF_EFFECT;
        oTarget   = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocation, FALSE, nType);
              int nDC;

        while (GetIsObjectValid(oTarget))
        {
            switch (GetObjectType(oTarget))
            {
            case OBJECT_TYPE_AREA_OF_EFFECT:
                gsSPDispelAreaOfEffect(OBJECT_SELF, oTarget);
                break;

            default:

                nDC = nCasterLevel;
                // Modify DC for target's arcane defense feats.
                if (GetHasFeat(FEAT_ARCANE_DEFENSE_ABJURATION, oTarget)) nDC -= 2;

                // Modify DC if target has at least 21 paladin levels.
                if (GetLevelByClass(CLASS_TYPE_PALADIN, oTarget) > 20) nDC -=3;

                effect eEffect3  = EffectDispelMagicBest(nDC);
                eEffect3  = EffectLinkEffects(eVisual1, EffectLinkEffects(eEffect3, eEffect3));

                //raise event
                nHarmful = ! GetIsReactionTypeFriendly(oTarget);
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, nHarmful));

                //apply
                gsSPApplyEffect(oTarget, eEffect3, nSpell);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual2, oTarget);
                DoSpellBreach(oTarget, 2, 0, GetSpellId());
                // gsSPApplySpellBreach(oTarget, 2);
                gsSPApplyEffect(oTarget, eEffect2, nSpell, fDuration);
            }

            oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocation, FALSE, nType);
        }
    }
}
