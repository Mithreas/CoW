//::///////////////////////////////////////////////
//:: Holy Sword
//:: X2_S0_holysword
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Holy Sword is custom-scripted for Arelith.
  The 'Holy Avenger' property is hard-coded, and
  therefore not used.

  Instead, the enhancement bonus and divine damage
  are being recreated through normal effects.  The
  on-hit dispel is done via custom script found in:
  im_w_hs_dispel.nss

  Arelith Specific Changes:
  - On-Hit dispel capped at 20 CL, and is
    improved by +2 for each Abjuration spell focus.
  - Holy Sword may again be cast on enchanted
    weapons.

*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

#include "gs_inc_text"
#include "inc_customspells"
#include "nw_i0_spells"
#include "x2_i0_spells"


void main()
{
    if (!X2PreSpellCastCode())
        return;

    // Weapon to be enchanted
    object oItem   = IPGetTargetedOrEquippedMeleeWeapon();

    // Error feedback
    if (!GetIsObjectValid(oItem)) {
        FloatingTextStrRefOnCreature(83615, OBJECT_SELF, FALSE);
        return;
    }

    // Ignore magic staffs
    if (GetBaseItemType(oItem) == BASE_ITEM_MAGICSTAFF) {
        FloatingTextStrRefOnCreature(83615, OBJECT_SELF, FALSE);
        return;
    }

    // Get caster level and duration.
    int nCL = AR_GetCasterLevel(OBJECT_SELF);

    if(!GetIsObjectValid(GetSpellCastItem()))
    {
        nCL += GetLevelByClass(CLASS_TYPE_DIVINECHAMPION, OBJECT_SELF);
    }

    int nDuration;

    if (AR_GetMetaMagicFeat() == METAMAGIC_EXTEND)
        nDuration = nCL * 2;
    else
        nDuration = nCL;

    // Get whoever holds this weapon.
    object oPossessor = GetItemPossessor(oItem);

    // Apply visual effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_GOOD_HELP), oPossessor);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), oPossessor, RoundsToSeconds(nDuration));
    DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SUPER_HEROISM), oPossessor));

    // Holy swords are shiny.
    IPSafeAddItemProperty(oItem, ItemPropertyVisualEffect(ITEM_VISUAL_HOLY), RoundsToSeconds(nDuration), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);

    // Enhancement Bonus of +5.
    IPSafeAddItemProperty(oItem, ItemPropertyEnhancementBonus(5), RoundsToSeconds(nDuration), X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);

    // 1d6 Divine Damage versus Evil
    IPSafeAddItemProperty(oItem, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGEBONUS_1d6), RoundsToSeconds(nDuration), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);

    // Add 16 SR
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSpellResistanceIncrease(16), oPossessor, RoundsToSeconds(nDuration));

    // Add on-hit dispel script.
	if (GetLevelByClass(CLASS_TYPE_PALADIN, oPossessor)) {
		SetLocalString(oItem, "RUN_ON_HIT_1", "im_w_hs_dispel");
		AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, nCL), oItem, RoundsToSeconds(nDuration));
	}
		
    // Event Signal
    SignalEvent(oPossessor, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
}
