#include "inc_spells"
#include "inc_spell"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget = GetSpellTargetObject();
    effect eEffect;
    int nSpell     = GetSpellId();
    int nDC        = AR_GetSpellSaveDC();
    int nValue     = 0;

    //raise event
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
	
    //affection check
    if (! gsSPGetIsAffected(GS_SP_TYPE_HARMFUL, OBJECT_SELF, oTarget)) return;

    //resistance check
    if (gsSPResistSpell(OBJECT_SELF, oTarget, nSpell)) return;

    switch (Random(6))
    {
    case 0: nValue = DISEASE_BLINDING_SICKNESS; break;
    case 1: nValue = DISEASE_CACKLE_FEVER;      break;
    case 2: nValue = DISEASE_FILTH_FEVER;       break;
    case 3: nValue = DISEASE_MINDFIRE;          break;
    case 4: nValue = DISEASE_RED_ACHE;          break;
    case 5: nValue = DISEASE_SHAKES;            break;
    case 6: nValue = DISEASE_SLIMY_DOOM;        break;
    }

    //apply
    eEffect = EffectDisease(nValue);

    gsSPApplyEffect(
        oTarget,
        eEffect,
        nSpell,
        GS_SP_DURATION_PERMANENT);
}
