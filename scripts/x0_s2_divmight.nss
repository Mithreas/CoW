//::///////////////////////////////////////////////
//:: Divine Might
//:: x0_s2_divmight.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Up to (turn undead amount) per day the character may add his Charisma bonus to all
    weapon damage for a number of rounds equal to the Charisma bonus.

    MODIFIED JULY 3 2003
    + Won't stack
    + Set it up properly to give correct + to hit (to a max of +20)

    MODIFIED SEPT 30 2003
    + Made use of new Damage Constants

    Arelith-Specific: (Paladins/BGs): 1.5x dmg when wielding a 2H weapon
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: Sep 13 2002
//:://////////////////////////////////////////////

#include "inc_generic"
#include "inc_item"
#include "inc_iprop"
#include "inc_pc"
#include "inc_worship"
#include "x0_i0_spells"
#include "x2_inc_itemprop"
#include "inc_effecttags"

void main()
{

    if (!GetHasFeat(FEAT_TURN_UNDEAD, OBJECT_SELF))
    {
        SendMessageToPC(OBJECT_SELF, GetStringByStrRef(40550));
        return;
    }

    float fPiety = gsWOGetPiety(OBJECT_SELF);

    if (fPiety < 1.0f) {
        FloatingTextStringOnCreature("You are not pious enough for your god to grant you this ability.", OBJECT_SELF, FALSE);
        return;
    } else {
        gsWOAdjustPiety(OBJECT_SELF, -1.0f);
    }


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nLevel = GetCasterLevel(OBJECT_SELF);
    effect eEffect;

    effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    int nCharismaBonus = GetAbilityModifier(ABILITY_CHARISMA);

    if (nCharismaBonus>0) {
		// This method's return values work for both DAMAGE_BONUS* and IP_CONST_DAMAGE*.
        int nDamage1 = IPGetDamageBonusConstantFromNumber(nCharismaBonus);
		object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
		if (!GetIsObjectValid(oWeapon)) oWeapon = GetItemInSlot(INVENTORY_SLOT_ARMS);
		if (!GetIsObjectValid(oWeapon)) return;

		IPSafeAddItemProperty(oWeapon,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_DIVINE, nDamage1), RoundsToSeconds(nCharismaBonus), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING ,FALSE,FALSE, "div_might");
		
		object oSecondWeapon = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
		if (GetIsObjectValid(oSecondWeapon) && oSecondWeapon != oWeapon)
		{
			IPSafeAddItemProperty(oSecondWeapon,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_DIVINE, nDamage1), RoundsToSeconds(nCharismaBonus), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING ,FALSE,FALSE, "div_might");
		}
		
        effect eLink = eDur;
        eLink = SupernaturalEffect(eLink);

        // * Do not allow this to stack
		// Unnecessary now that this is applied as a weapon property but clean up any old VFX :)
		eEffect = GetFirstEffect(OBJECT_SELF);
		while (GetIsEffectValid(eEffect))
		{
			if (GetEffectSpellId(eEffect) == SPELL_DIVINE_MIGHT || GetIsTaggedEffect(eEffect, EFFECT_TAG_DIVINE_MIGHT))
				RemoveEffect(OBJECT_SELF, eEffect);
			eEffect = GetNextEffect(OBJECT_SELF);
		}

        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DIVINE_MIGHT, FALSE));

        //Apply Link and VFX effects to the target
        ApplyTaggedEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nCharismaBonus), EFFECT_TAG_DIVINE_MIGHT);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }

    // DecrementRemainingFeatUses(OBJECT_SELF, FEAT_TURN_UNDEAD);  -- Don't do this, stamina drain instead
    gsSTDoCasterDamage(OBJECT_SELF, 5);
}



