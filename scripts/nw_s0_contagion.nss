#include "inc_spells"
#include "inc_spell"
#include "inc_state"
void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget = GetSpellTargetObject();
    effect eEffect;
    int nSpell     = GetSpellId();
    int nValue     = 0;

    //raise event
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));

    // Check for BG version of the spell.
    if (!GetIsObjectValid(GetSpellCastItem()) && nSpell == 613)
    {
        // Restore feat use.
        IncrementRemainingFeatUses(OBJECT_SELF, FEAT_CONTAGION);
		gsSTDoCasterDamage(OBJECT_SELF, 10);
	}	
		
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
