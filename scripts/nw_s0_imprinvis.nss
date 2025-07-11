#include "inc_customspells"
#include "inc_timelock"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget   = GetSpellTargetObject();
    effect eEffect1;
    effect eEffect2;
    int nSpell       = GetSpellId();
    int nCasterLevel = AR_GetCasterLevel(OBJECT_SELF);
    int nMetaMagic   = AR_GetMetaMagicFeat();
    int nDuration    = nCasterLevel;


    // Assassin: 2m cooldown
    // Check for Assassin improved invis (spell ID 608)
    object oItem = GetSpellCastItem();
    if (!GetIsObjectValid(oItem) && nSpell == 608)
    {
        // Restore feat use.
        IncrementRemainingFeatUses(OBJECT_SELF,  FEAT_PRESTIGE_INVISIBILITY_2);
        miDVGivePoints(OBJECT_SELF, ELEMENT_AIR, 3.0);
		
        // Cooldown check.
        if(GetIsTimelocked(OBJECT_SELF, "Assassin Improved Invisibility"))
        {
            TimelockErrorMessage(OBJECT_SELF, "Assassin Improved Invisibility");
            return;
        }
		gsSTDoCasterDamage(OBJECT_SELF, 8);
        SetTimelock(OBJECT_SELF, FloatToInt(TurnsToSeconds(2)), "Assassin Improved Invisibility", 60, 30);
    }

    //raise event
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));

    //affection check
    if (! gsSPGetIsAffected(GS_SP_TYPE_BENEFICIAL, OBJECT_SELF, oTarget)) return;

    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    //apply
    eEffect1 =
        EffectLinkEffects(
            EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
            EffectInvisibility(INVISIBILITY_TYPE_NORMAL));
    eEffect2 =
        EffectLinkEffects(
            EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
            EffectLinkEffects(
                EffectVisualEffect(VFX_DUR_INVISIBILITY),
                EffectConcealment(50)));

    gsSPApplyEffect(
        oTarget,
        eEffect1,
        nSpell,
        RoundsToSeconds(nDuration)); //1 round per level instead of 1 turn per level
    gsSPApplyEffect(
        oTarget,
        eEffect2,
        nSpell,
        TurnsToSeconds(nDuration));
}


