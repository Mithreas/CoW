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

    switch(GetSpellId())
    {
        case SPELL_ANIMATE_DEAD:
            ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectSummonCreature(GetUndeadStreamBlueprint(OBJECT_SELF, GetUndeadSummonerTier()),
                VFX_FNF_SUMMON_UNDEAD), lLocation, HoursToSeconds(nDuration));
            break;
        case 623: // Pale Master Animate Dead
            SummonSwarm(OBJECT_SELF, CreateSummonGroup(2, GetUndeadStreamBlueprint(OBJECT_SELF, GetUndeadSummonerTier())), HoursToSeconds(nDuration), VFX_FNF_SUMMON_UNDEAD);
            ScheduleSummonCooldown(OBJECT_SELF, 180, "Animate Dead", FEAT_ANIMATE_DEAD);
	        gsSTDoCasterDamage(OBJECT_SELF, 5);
            break;
    }
}



