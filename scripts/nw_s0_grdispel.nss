#include "inc_customspells"
#include "inc_warlock"
#include "inc_spellsword"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget     = GetSpellTargetObject();
    location lLocation = GetSpellTargetLocation();
    effect eEffect     = EffectVisualEffect(VFX_IMP_BREACH);
    int nSpell         = GetSpellId();
    int nCasterLevel   = AR_GetCasterLevel(OBJECT_SELF);

    if (nCasterLevel > 22) nCasterLevel = 2;
    // Addition by Mithreas - give a bonus to dispel checks based on abjuration
    // focuses.
    // nCasterLevel += GetSpellDCModifiers(OBJECT_SELF, SPELL_SCHOOL_ABJURATION);

    // New calculation: +1 for SF and GSF, +2 for ESF
    if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ABJURATION)) nCasterLevel += 4;
    else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ABJURATION)) nCasterLevel += 2;
    else if (GetHasFeat(FEAT_SPELL_FOCUS_ABJURATION)) nCasterLevel += 1;

    int nHarmful       = FALSE;

    //visual effect
    ApplyEffectAtLocation(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_FNF_DISPEL_GREATER),
        lLocation);

    if (GetIsObjectValid(oTarget))
    {
        if (!GetIsReactionTypeFriendly(oTarget) &&
            !miWADoWarlockAttack(OBJECT_SELF, oTarget, nSpell, FALSE))
          return;

        // Modify DC for target's arcane defense feats.
        if (GetHasFeat(FEAT_ARCANE_DEFENSE_ABJURATION, oTarget)) nCasterLevel -= 2;

        // Modify DC if target has at least 21 paladin levels.
        if (GetLevelByClass(CLASS_TYPE_PALADIN, oTarget) > 20) nCasterLevel -=3;

        // Add Harper Scout CL
        nCasterLevel -= (GetLevelByClass(CLASS_TYPE_HARPER, oTarget));		
		
        //raise event
        nHarmful  = ! GetIsReactionTypeFriendly(oTarget);
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, nHarmful));

        //apply
        eEffect   = EffectLinkEffects(eEffect, EffectDispelMagicAll(nCasterLevel));
        gsSPApplyEffect(oTarget, eEffect, nSpell);
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
                gsSPDispelAreaOfEffect(OBJECT_SELF, oTarget, 75 + nCasterLevel);
                break;

            default:

                nDC = nCasterLevel;

                 // Modify DC for target's arcane defense feats.
                if (GetHasFeat(FEAT_ARCANE_DEFENSE_ABJURATION, oTarget)) nDC -= 2;

                // Modify DC if target has at least 21 paladin levels.
                if (GetLevelByClass(CLASS_TYPE_PALADIN, oTarget) > 20) nDC -=3;

                effect eEffect2 = EffectLinkEffects(eEffect, EffectDispelMagicBest(nDC));

                //raise event
                nHarmful = ! GetIsReactionTypeFriendly(oTarget);
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, nHarmful));

                //apply
                gsSPApplyEffect(oTarget, eEffect2, nSpell);
            }

            oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocation, FALSE, nType);
        }
    }
}