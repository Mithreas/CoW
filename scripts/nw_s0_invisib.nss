#include "inc_customspells"
#include "inc_text"
#include "inc_timelock"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget   = GetSpellTargetObject();
    effect eEffect;
    int nSpell       = GetSpellId();
    int nCasterLevel = AR_GetCasterLevel(OBJECT_SELF);
    // Addition by Mithreas - set caster level for spells cast using subrace
    // abilities. --[
    object oItem = GetSpellCastItem();
    if (GetIsObjectValid(oItem) && GetTag(oItem) == "GS_SU_ABILITY")
    {
      // Svirfs use caster level = char level. Duergar get caster level = twice
      // char level.
      object oPC = GetItemPossessor(oItem);
      if (GetSubRace(oPC) == GS_T_16777264)
      {
        nCasterLevel = 2 * GetHitDice(oPC);
      }
      else
      {
        nCasterLevel = GetHitDice(oPC);
      }
    }
    // ]-- end addition.

    // Assassin: 2m cooldown, add Exp. Retreat at level 15
    // Considers feat used if there is no cast item, and the caster level is the same as the assassin's class levels.
    if (!GetIsObjectValid(oItem) && GetLevelByClass(CLASS_TYPE_ASSASSIN, OBJECT_SELF) == nCasterLevel)
    {
        // Restore feat use.
        IncrementRemainingFeatUses(OBJECT_SELF, FEAT_PRESTIGE_INVISIBILITY_1);
        // Cooldown check.
        if(GetIsTimelocked(OBJECT_SELF, "Assassin Invisibility"))
        {
            TimelockErrorMessage(OBJECT_SELF, "Assassin Invisibility");
            return;
        }
        SetTimelock(OBJECT_SELF, FloatToInt(TurnsToSeconds(2)), "Assassin Invisibility", 60, 30);

        if (GetLevelByClass(CLASS_TYPE_ASSASSIN, OBJECT_SELF) >= 15)
        {
            if (GetHasSpellEffect(SPELL_HASTE, OBJECT_SELF) == TRUE) return; // does nothing if caster already has haste
            if (GetHasSpellEffect(SPELL_EXPEDITIOUS_RETREAT, OBJECT_SELF) == TRUE) return; // does nothing if caster already has Expeditious Retreat
            effect eFast = EffectLinkEffects(EffectMovementSpeedIncrease(150), EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFast, OBJECT_SELF, RoundsToSeconds(nCasterLevel));
        }
    }


    int nMetaMagic   = AR_GetMetaMagicFeat();
    int nDuration    = nCasterLevel;

    //raise event
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));

    //affection check
    if (! gsSPGetIsAffected(GS_SP_TYPE_BENEFICIAL, OBJECT_SELF, oTarget)) return;

    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    //apply
    eEffect =
        EffectLinkEffects(
            EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
            EffectInvisibility(INVISIBILITY_TYPE_NORMAL));

    gsSPApplyEffect(
        oTarget,
        eEffect,
        nSpell,
        RoundsToSeconds(nDuration)); //1 round per level instead of 1 turn per level
}
