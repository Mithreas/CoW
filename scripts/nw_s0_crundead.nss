#include "inc_spells"
#include "inc_sumstream"
#include "inc_customspells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    location lLocation = GetSpellTargetLocation();
    int nMetaMagic     = AR_GetMetaMagicFeat();
    int nDuration      = 24;

    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    SummonSwarm(OBJECT_SELF, CreateSummonGroup(2, GetUndeadStreamBlueprint(OBJECT_SELF, GetUndeadSummonerTier())), HoursToSeconds(nDuration), VFX_FNF_SUMMON_UNDEAD);
}

