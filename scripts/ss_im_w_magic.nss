/*
  Spellsword Imbue Weapon Ability - MAGIC
*/

#include "inc_spellsword"
#include "inc_customspells"

void main()
{
    int bFeedback = FALSE;

    //::  The item casting triggering this spellscript
    object oItem = GetSpellCastItem();
    //::  On a weapon: The one being hit. On an armor: The one hitting the armor
    object oSpellTarget = GetSpellTargetObject();
    //::  On a weapon: The one wielding the weapon. On an armor: The one wearing an armor
    object oSpellOrigin = OBJECT_SELF;
    //::  The DC oSpellTarget has to make or face the consequences!
    int nWizard = GetLevelByClass(CLASS_TYPE_WIZARD, oSpellOrigin);

    if(bFeedback) SendMessageToPC(oSpellOrigin, "SS_IM_W entered");

    int nSaveDC = GetLocalInt(gsPCGetCreatureHide(oSpellOrigin), "SS_IM_W_DC_MAGIC");
    int nSpellGroup = 1 + (nSaveDC - (10 + nWizard))/2;
	int nTimer = GetLocalInt(gsPCGetCreatureHide(oSpellOrigin), "SS_IM_W_TM_MAGIC") + 2;

    //5% chance of casting per spell level group
    if ((d20() <= nSpellGroup)  && (gsTIGetActualTimestamp() > nTimer))
    {
        SetLocalInt(oSpellOrigin, "SS_IM_W_TM_MAGIC", gsTIGetActualTimestamp());
		object oTarget     = oSpellTarget;
        effect eEffect     = EffectVisualEffect(VFX_IMP_BREACH);
        int nCasterLevel   = nWizard;

        if (nCasterLevel > 20) nCasterLevel = 20;
        nCasterLevel += GetSpellDCModifiers(oSpellOrigin, SPELL_SCHOOL_ABJURATION);

        // Addition by Mithreas - give a bonus to dispel checks based on abjuration
        // focuses.
        int nHarmful       = FALSE;

        //visual effect
        ApplyEffectToObject(
            DURATION_TYPE_INSTANT,
            EffectVisualEffect(VFX_FNF_DISPEL),
            oTarget);

        // Modify DC for target's arcane defense feats.
        if (GetHasFeat(FEAT_ARCANE_DEFENSE_ABJURATION, oTarget)) nCasterLevel -= 2;

        // Modify DC if target is Spellsword
        if (miSSGetIsSpellsword(oTarget)) nCasterLevel -=3;

        // Modify DC if target has at least 21 paladin levels.
        if (GetLevelByClass(CLASS_TYPE_PALADIN, oTarget) > 20) nCasterLevel -=3;

        //apply
        eEffect   = EffectLinkEffects(eEffect, EffectDispelMagicAll(nCasterLevel));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(eEffect), oSpellTarget);
    }
    return;
}
