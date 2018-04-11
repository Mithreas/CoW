#include "inc_customspells"
#include "inc_spells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    location lLocation = GetSpellTargetLocation();
    int nCasterLevel   = AR_GetCasterLevel(OBJECT_SELF);
    int nMetaMagic     = AR_GetMetaMagicFeat();
    int nDuration      = nCasterLevel / 3;

    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;
    if (nDuration < 1)                  nDuration  = 1;

    CreateNonStackingPersistentAoE(DURATION_TYPE_TEMPORARY, AOE_PER_DELAY_BLAST_FIREBALL, lLocation, RoundsToSeconds(nDuration));
}


