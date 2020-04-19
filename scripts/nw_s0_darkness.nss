#include "inc_customspells"
#include "inc_spells"
#include "inc_timelock"
void main()
{
    if (gsSPGetOverrideSpell()) return;

    location lLocation = GetSpellTargetLocation();
    int nSpell         = GetSpellId();
    int nCasterLevel   = AR_GetCasterLevel(OBJECT_SELF);

    // Addition by Mithreas - set caster level for spells cast using subrace
    // abilities. --[
    object oItem = GetSpellCastItem();
    if (GetIsObjectValid(oItem) && GetTag(oItem) == "GS_SU_ABILITY")
    {
      nCasterLevel = GetHitDice(GetItemPossessor(oItem));
    }
    // ]-- end addition.
	
	if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_EVOCATION, OBJECT_SELF)) nCasterLevel += 2;

    // Assassin: 2m cooldown, add Ultravision at level 13
    // Considers feat used if there is no cast item, and the caster level is the same as the assassin's class levels.
    if (!GetIsObjectValid(oItem) && GetLevelByClass(CLASS_TYPE_ASSASSIN, OBJECT_SELF) == nCasterLevel)
    {
        // Restore feat use.
        IncrementRemainingFeatUses(OBJECT_SELF, FEAT_PRESTIGE_DARKNESS);
        // Cooldown check.
        if(GetIsTimelocked(OBJECT_SELF, "Assassin Darkness"))
        {
            TimelockErrorMessage(OBJECT_SELF, "Assassin Darkness");
            return;
        }
        SetTimelock(OBJECT_SELF, FloatToInt(TurnsToSeconds(2)), "Assassin Darkness", 60, 30);

        if (GetLevelByClass(CLASS_TYPE_ASSASSIN, OBJECT_SELF) >= 13)
        {
            effect eUVEffect = EffectLinkEffects(EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), EffectLinkEffects(EffectVisualEffect(VFX_DUR_ULTRAVISION), EffectLinkEffects(EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT), EffectUltravision())));
            gsSPApplyEffect(OBJECT_SELF, eUVEffect, SPELL_DARKVISION, HoursToSeconds(nCasterLevel));
        }
    }

    int nMetaMagic     = AR_GetMetaMagicFeat();
    int nDuration      = nCasterLevel;

    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    //apply
    CreateNonStackingPersistentAoE(DURATION_TYPE_TEMPORARY, AOE_PER_DARKNESS, lLocation, RoundsToSeconds(nDuration));

    //trigger spell cast at event
    object oTarget = GetSpellTargetObject();
    if (GetIsObjectValid(oTarget))
    {
      object oCaster = OBJECT_SELF;
      SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_DARKNESS, FALSE));
    }

}
