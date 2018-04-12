#include "inc_spell"

void main()
{
    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();
    effect eEffect;
    int nSpell     = gsSPGetSpellID();

    // Escape for DMs
    if(GetIsDM(oTarget) == TRUE && GetIsDMPossessed(oTarget) == FALSE)
    {
        return;
    }

    if (oTarget == oCaster)
    {
        //raise event
        SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpell, FALSE));

        //apply
        eEffect =
            EffectLinkEffects(
                EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
                EffectInvisibility(INVISIBILITY_TYPE_DARKNESS));
    }
    else
    {
        //affection check
        if (! gsSPGetIsAffected(GS_SP_TYPE_HARMFUL, oCaster, oTarget)) return;
        
        //raise event
        SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpell, FALSE));

        //resistance check
        if (gsSPResistSpell(oCaster, oTarget, nSpell)) return;

        //apply
        eEffect =
            EffectLinkEffects(
                EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE),
                EffectDarkness());
    }

    gsSPApplyEffect(oTarget, eEffect, nSpell, GS_SP_DURATION_PERMANENT);
}
