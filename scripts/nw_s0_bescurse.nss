#include "gs_inc_spell"
#include "mi_inc_warlock"
#include "inc_spells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget = GetSpellTargetObject();
    effect eEffect;
    int nSpell     = GetSpellId();
    int nDC        = AR_GetSpellSaveDC();

    //raise event
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
	
    //affection check
    if (! gsSPGetIsAffected(GS_SP_TYPE_HARMFUL, OBJECT_SELF, oTarget)) return;

    //resistance check
    if (! miWADoWarlockAttack(OBJECT_SELF, oTarget, nSpell)) return;

    //saving throw check
    if (gsSPSavingThrow(OBJECT_SELF, oTarget, nSpell, nDC, SAVING_THROW_WILL)) return;

    //apply
    eEffect =
        SupernaturalEffect(
            EffectCurse(2, 2, 2, 2, 2, 2));

    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE),
        oTarget);
    gsSPApplyEffect(
        oTarget,
        eEffect,
        nSpell,
        GS_SP_DURATION_PERMANENT);
}
