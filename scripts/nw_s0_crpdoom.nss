#include "mi_inc_spells"
#include "inc_spells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    location lLocation = GetSpellTargetLocation();
    int nCasterLevel   = AR_GetCasterLevel(OBJECT_SELF);
    int nMetaMagic     = AR_GetMetaMagicFeat();
    int nDuration      = nCasterLevel;

    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    CreateNonStackingPersistentAoE(DURATION_TYPE_TEMPORARY, AOE_PER_CREEPING_DOOM, lLocation, RoundsToSeconds(nDuration));
}
