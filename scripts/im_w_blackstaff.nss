//:://////////////////////////////////////////////
//:: Blackstaff
//:: im_w_blackstaff
//:://////////////////////////////////////////////
/*
  Casting this spell on a melee weapon will grant it an on-hit effect
  that does the following:

- On a striking a creature, that creature must make a Will save
  or receive a cumulative 5% vulnerability to magic damage, and
  a cumulative 10% vulnerability to elemental damage.
- Magic vulnerability caps at 50%.  Elemental damage vulnerability
  caps at 100%.
- The duration of the effect is 6 rounds, and is refreshed upon
  every successful application.

*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

#include "inc_effecttags"
#include "NW_I0_SPELLS"
#include "x0_i0_spells"

void main()
{
    // the target being hit by the weapon.
    object oSpellTarget = GetSpellTargetObject();

    // the wielder of the weapon
    object oSpellOrigin = OBJECT_SELF;

    // the weapon itself
    object oItem = GetSpellCastItem();

    // First check to make sure the Blackstaff effect is still active
    effect eDurEffect = GetFirstEffect(oSpellOrigin);
    int bActive = FALSE;
    while (GetIsEffectValid(eDurEffect))
    {
        if (GetEffectSpellId(eDurEffect) == SPELL_BLACKSTAFF)
            bActive = TRUE;
        eDurEffect = GetNextEffect(oSpellOrigin);
    }

    // Blackstaff is no longer active on the caster.
    if (!bActive) {
        // Clear out all On-Hit Blackstaff parameters on the weapon
        if (GetLocalString(oItem, "RUN_ON_HIT_1") == "im_w_blackstaff")
            SetLocalString(oItem, "RUN_ON_HIT_1", "");
        if (GetLocalString(oItem, "RUN_ON_HIT_2") == "im_w_blackstaff")
            SetLocalString(oItem, "RUN_ON_HIT_2", "");
        if (GetLocalString(oItem, "RUN_ON_HIT_3") == "im_w_blackstaff")
            SetLocalString(oItem, "RUN_ON_HIT_3", "");

        // Then exit
        return;
    }

    // Get DC.  Base is 10 + spell level (8)
    int nDC = 18;

    // Kludge.  Get primary casting stat bonus
    if (GetLevelByClass(CLASS_TYPE_WIZARD, oSpellOrigin))
        nDC += GetAbilityModifier(ABILITY_INTELLIGENCE, oSpellOrigin);
    else if (GetLevelByClass(CLASS_TYPE_SORCERER, oSpellOrigin))
        nDC += GetAbilityModifier(ABILITY_CHARISMA, oSpellOrigin);

    // Transmutation Foci
    if (GetHasFeat(FEAT_SPELL_FOCUS_TRANSMUTATION, oSpellOrigin))
        nDC += 2;
    if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION, oSpellOrigin))
        nDC += 2;
    if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION , oSpellOrigin))
        nDC += 2;

    // Continue only if the target fails the saving throw
    if (MySavingThrow(SAVING_THROW_WILL, oSpellTarget, nDC))
       return;

    // Keep track of the number of times Blackstaff has struck the target
    int nBlackstaffHits = 1;
    int bHasHit = FALSE;

    // Now clear out previous iterations of Blackstaff on target
    effect eEffect = GetFirstEffect(oSpellTarget);
    while (GetIsEffectValid(eEffect))
    {
        if (GetIsTaggedEffect(eEffect, EFFECT_TAG_BLACKSTAFF)) {
              RemoveEffect(oSpellTarget, eEffect);
              bHasHit = TRUE;
        }
        eEffect = GetNextEffect(oSpellTarget);
    }

    // Update hits if an old Blackstaff effect was cleared out, otherwise start the count at 1
    if (bHasHit) {
              nBlackstaffHits = GetLocalInt(oItem, "BLACKSTAFF_HITS") + 1;
              SetLocalInt(oItem, "BLACKSTAFF_HITS", nBlackstaffHits);
    } else {
              SetLocalInt(oItem, "BLACKSTAFF_HITS", 1);
    }

    if (nBlackstaffHits > 10) {
        nBlackstaffHits = 10;
        // A combat log message when the vulnerabilities hit max.
        SendMessageToPC(oSpellOrigin, "Blackstaff impacts have made the target fully vulnerable to magical and elemental energies!");
    }

    // 5% magic per hit, 10% element per hit
    int nNewMagic = nBlackstaffHits * 5;
    int nNewElem = nBlackstaffHits * 10;

    // Package everything into a linked effect.
    effect eLink = EffectDamageImmunityDecrease(DAMAGE_TYPE_MAGICAL, nNewMagic);
    eLink = EffectLinkEffects(eLink, EffectDamageImmunityDecrease(DAMAGE_TYPE_COLD, nNewElem));
    eLink = EffectLinkEffects(eLink, EffectDamageImmunityDecrease(DAMAGE_TYPE_FIRE, nNewElem));
    eLink = EffectLinkEffects(eLink, EffectDamageImmunityDecrease(DAMAGE_TYPE_ELECTRICAL, nNewElem));
    eLink = EffectLinkEffects(eLink, EffectDamageImmunityDecrease(DAMAGE_TYPE_SONIC, nNewElem));
    eLink = EffectLinkEffects(eLink, EffectDamageImmunityDecrease(DAMAGE_TYPE_ACID, nNewElem));

    // VFX it up
    eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_AURA_PULSE_GREY_BLACK));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_MIND), oSpellTarget);

    // 6 round duration
    ApplyTaggedEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oSpellTarget, RoundsToSeconds(6), EFFECT_TAG_BLACKSTAFF);
}
