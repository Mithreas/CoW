#include "inc_customspells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget = GetSpellTargetObject();
    effect eEffect;
    int nSpell     = GetSpellId();
    int nMetaMagic = AR_GetMetaMagicFeat();
    int nDC        = AR_GetSpellSaveDC();
    int nValue     = 0;

    //raise event
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));

    //affection check
    if (gsSPGetIsAffected(GS_SP_TYPE_HARMFUL, OBJECT_SELF, oTarget))
    {

        //resistance check
        if (! gsSPResistSpell(OBJECT_SELF, oTarget, nSpell))
        {
            if (gsSPSavingThrow(OBJECT_SELF, oTarget, nSpell, nDC, SAVING_THROW_FORT))
            {
                nValue  = gsSPGetDamage(6, 10, nMetaMagic);
                eEffect = EffectDamage(nValue, DAMAGE_TYPE_DIVINE);
            }
            else
            {
                eEffect = EffectDeath();
            }

            //apply
            eEffect =
                EffectLinkEffects(
                    EffectVisualEffect(VFX_IMP_DESTRUCTION),
                    eEffect);

            gsSPApplyEffect(oTarget, eEffect, nSpell);
        }
    }
}
