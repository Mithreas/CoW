#include "inc_customspells"
#include "inc_warlock"
#include "inc_spellsword"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget     = GetSpellTargetObject();
    location lLocation = GetSpellTargetLocation();
    effect eEffect     = EffectVisualEffect(VFX_IMP_HEAD_SONIC);
    int nSpell         = GetSpellId();
    int nCasterLevel   = AR_GetCasterLevel(OBJECT_SELF);
    if (nCasterLevel > 5) nCasterLevel = 5;
    // Addition by Mithreas - give a bonus to dispel checks based on abjuration
    // focuses.
    nCasterLevel += GetSpellDCModifiers(OBJECT_SELF, SPELL_SCHOOL_ABJURATION);
    int nHarmful       = FALSE;

    //visual effect
    ApplyEffectAtLocation(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_FNF_LOS_NORMAL_20),
        lLocation);

    if (GetIsObjectValid(oTarget))
    {
        if (!GetIsReactionTypeFriendly(oTarget) &&
            !miWADoWarlockAttack(OBJECT_SELF, oTarget, nSpell, FALSE))
          return;

        // Modify DC for target's arcane defense feats.
        if (GetHasFeat(FEAT_ARCANE_DEFENSE_ABJURATION, oTarget)) nCasterLevel -= 2;

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
        eEffect   = EffectLinkEffects(eEffect, EffectDispelMagicAll(nCasterLevel));
        gsSPApplyEffect(oTarget, eEffect, nSpell);
    }
    else
    {
        int nType = OBJECT_TYPE_SPELLTARGET | OBJECT_TYPE_AREA_OF_EFFECT;
        oTarget   = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocation, FALSE, nType);

        while (GetIsObjectValid(oTarget))
        {
            switch (GetObjectType(oTarget))
            {
            case OBJECT_TYPE_AREA_OF_EFFECT:
                gsSPDispelAreaOfEffect(OBJECT_SELF, oTarget, 25 + nCasterLevel);
                break;

            default:
                 // Modify DC for target's arcane defense feats.
                if (GetHasFeat(FEAT_ARCANE_DEFENSE_ABJURATION, oTarget)) nCasterLevel -= 2;

                // Modify DC if target has at least 21 paladin levels.
                if (GetLevelByClass(CLASS_TYPE_PALADIN, oTarget) > 20) nCasterLevel -=3;

                effect eEffect2 = EffectLinkEffects(eEffect, EffectDispelMagicBest(nCasterLevel));
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
