//::///////////////////////////////////////////////
//:: Elemental Swarm
//:: NW_S0_EleSwarm.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spell creates a conduit from the caster
    to the elemental planes.  The first elemental
    summoned is a 24 HD Air elemental.  Whenever an
    elemental dies it is replaced by the next
    elemental in the chain Air, Earth, Water, Fire
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 30, 2001

#include "inc_spells"
#include "inc_customspells"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check inc_customspells.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    int bTierIncrease = (GetHasFeat(FEAT_ANIMAL_DOMAIN_POWER) || GetHasFeat(FEAT_GREATER_SPELL_FOCUS_CONJURATION));
    int nMetaMagic = AR_GetMetaMagicFeat();
    int nCasterLevel = AR_GetCasterLevel(OBJECT_SELF);
    int nDuration = AR_GetCasterLevel(OBJECT_SELF);
    nDuration = 24;
    effect eSummon;
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);
    //Check for metamagic duration
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2;  //Duration is +100%
    }

    SummonSwarm(OBJECT_SELF, CreateSummonGroup(1,
        bTierIncrease ? "nw_s_airelder" : "nw_s_airgreat", bTierIncrease ? "nw_s_earthelder" : "nw_s_earthgreat",
        bTierIncrease ? "nw_s_fireelder" : "nw_s_firegreat", bTierIncrease ? "nw_s_waterelder" : "nw_s_watergreat"), HoursToSeconds(nDuration));
}

