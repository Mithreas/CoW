#include "mi_inc_spells"
#include "inc_spells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    location lLocation = GetSpellTargetLocation();
    int nCasterLevel   = AR_GetCasterLevel(OBJECT_SELF);
    int nMetaMagic     = AR_GetMetaMagicFeat();
    int nDuration      = nCasterLevel / 2;

    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;
    if (nDuration < 1)                  nDuration  = 1;

    //apply
    ApplyEffectAtLocation(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_EVIL),
        lLocation);
    CreateNonStackingPersistentAoE(DURATION_TYPE_TEMPORARY, AOE_PER_FOGKILL, lLocation, RoundsToSeconds(nDuration));
}
