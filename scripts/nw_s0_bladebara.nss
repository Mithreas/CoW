#include "inc_customspells"
#include "inc_generic"

void main()
{
    object oCaster   = GetAreaOfEffectCreator();
    object oTarget   = GetEnteringObject();
    effect eEffect;
    int nSpell       = gsSPGetSpellID();
    int nCasterLevel = AR_GetCasterLevel(oCaster);
    if (nCasterLevel > 20) nCasterLevel = 20;
	if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_EVOCATION, oCaster)) nCasterLevel += 2;
    int nMetaMagic   = AR_GetMetaMagicFeat();
    int nDC          = GetSpellSaveDC();
    int nValue       = gsSPGetDamage(nCasterLevel, 6, nMetaMagic);

    //affection check
    if (GetIsCorpse(oTarget) || ! gsSPGetIsAffected(GS_SP_TYPE_HARMFUL, oCaster, oTarget)) return;
    
    //raise event
    SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpell));

    //resistance check
    if (gsSPResistSpell(oCaster, oTarget, nSpell)) return;

    //saving throw check
    nValue = AR_GetReflexAdjustedDamage(nValue, oTarget, nDC, SAVING_THROW_TYPE_NONE, oCaster);

    if (nValue > 0)
    {
        //apply
        eEffect = EffectDamage(nValue, DAMAGE_TYPE_SLASHING);
        gsSPApplyEffect(oTarget, eEffect, nSpell);
    }
    else
    {
        gsC2AdjustSpellEffectiveness(nSpell, oTarget, FALSE);
    }
}

