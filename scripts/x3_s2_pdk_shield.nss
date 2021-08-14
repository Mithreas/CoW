//::///////////////////////////////////////////////
//:: Purple Dragon Knight - Heroic Shield
//:: x3_s2_pdk_shield.nss
//:://////////////////////////////////////////////
//:: HEROIC SHIELD (COOLDOWN: 1 HOUR)
//:: The PDK designates a target as her Ward.
//:: The Ward gains 5% + 1% / 2 PDK levels immunity
//:: to all damage types, as well as 1/+1 DR.
//:: Additionally, the PDK -guards the Ward with
//:: twice the standard guard radius. The Ward does
//:: not count against the PDK's usual guard cap
//:: (i.e. the PDK can guard one target via -guard and her ward).
//:: Using Heroic Shield on a Ward functions as a toggle,
//:: enabling/disabling -guard functionality on the active Ward.
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:://////////////////////////////////////////////

#include "inc_class"
#include "x0_i0_spells"
#include "inc_rename"
#include "inc_timelock"

void main()
{
    //Declare main variables.
    object oPC         = OBJECT_SELF;
    int bValiant       = GetLocalInt(gsPCGetCreatureHide(oPC), VAR_PDK) == MI_CL_PDK_VALIANT;
    object oTarget     = GetSpellTargetObject();
    object oLastTarget = GetLocalObject(oPC, "PDKShieldTracking");
    object oWard       = GetLocalObject(oPC, "PDKWard");
    object oWarded     = GetLocalObject(oTarget, "PDKWarded");
    string sName       = "";

	int nCL = GetLocalInt(gsPCGetCreatureHide(oPC), "FL_LEVEL") /5;
    if (nCL < GetLevelByClass(CLASS_TYPE_PURPLE_DRAGON_KNIGHT, oPC))
	{
	  nCL = GetLevelByClass(CLASS_TYPE_PURPLE_DRAGON_KNIGHT, oPC);
	}
	else if (nCL > 10)
	{
	  nCL = 10;
	}
	
    // Restore feat use.
    IncrementRemainingFeatUses(OBJECT_SELF, FEAT_PDK_SHIELD);

    if (oPC == oTarget)
    {
        FloatingTextStringOnCreature("You cannot aid yourself using this ability.", oPC, FALSE);
        return;
    }
    if (!GetIsFriend(oTarget))
    {
        FloatingTextStringOnCreature("You cannot aid someone unless they are in your party.", oPC, FALSE);
        return;
    }
    if (GetArea(oPC) != GetArea(oTarget) || GetDistanceBetween(oPC,oTarget) > 10.0f)
    {
        FloatingTextStringOnCreature("You need to be near your ally to use this ability.", oPC, FALSE);
        return;
    }
    // We are toggling the guard functionality.
    // Do this only if the Heroic Shield Effect is currently active on the target.
    if (GetIsObjectValid(oWard) == TRUE && oWard == oTarget && GetHasFeatEffect(FEAT_PDK_SHIELD, oTarget) == TRUE) {
        sName = GetIsPC(oTarget) ? svGetPCNameOverride(oTarget) : GetName(oTarget);

        if (!GetIsObjectValid(oWarded) || oWarded != oPC) {
            SendMessageToPC(oPC, "You are again guarding " + sName + " from danger.");
            SetLocalObject(oTarget, "PDKWarded", oPC);
        } else {
            SendMessageToPC(oPC, "You are no longer guarding " + sName + ".");
            SetLocalObject(oTarget, "PDKWarded", OBJECT_INVALID);
        }
        return;
    }

    // Cooldown check.
    if(GetIsTimelocked(OBJECT_SELF, "Heroic Shield"))
    {
        TimelockErrorMessage(OBJECT_SELF, "Heroic Shield");
        return;
    }

    // Clear last target variables.
    if (oLastTarget != oTarget)
    {
        RemoveEffectsFromSpell(oLastTarget, GetSpellId());
        if (GetIsObjectValid(oLastTarget))
            SetLocalObject(oLastTarget, "PDKWarded", OBJECT_INVALID);
    }

    // Set local variables
    SetLocalObject(oPC, "PDKWard", oTarget);
    SetLocalObject(oPC, "PDKShieldTracking", oTarget);
    SetLocalObject(oTarget, "PDKWarded", oPC);
    oWard = oTarget;

    // No stack!
    RemoveEffectsFromSpell(oTarget, GetSpellId());

    // Start building the buff.
    // 5% immunity to all damage + 1% per 2 pdk levels.
    int nImmunity = 5 + nCL / 2;
    effect eLink = EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, nImmunity);
    eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, nImmunity));
    eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, nImmunity));
    eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, nImmunity));
    eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, nImmunity));
    eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, nImmunity));
    eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, nImmunity));
    eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC, nImmunity));
    eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_MAGICAL, nImmunity));
    eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE, nImmunity));
    eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_POSITIVE, nImmunity));
    eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_DIVINE, nImmunity));

    // 1/+1 DR
    eLink = EffectLinkEffects(eLink, EffectDamageReduction(1, DAMAGE_POWER_PLUS_ONE));

    // Visual cues
    eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_NEUTRAL));
    effect eVFX = EffectVisualEffect(VFX_IMP_PDK_HEROIC_SHIELD);

    // Make the linked effects extraordinary
    eLink = ExtraordinaryEffect(eLink);	
	
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(12));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oTarget);

    // 5 minute Cooldown
    SetTimelock(OBJECT_SELF, 300, "Heroic Shield", 120, 60);

}


    /* OLD PDK CODE
    int nBABBonus = GetBaseAttackBonus(oPC) - GetBaseAttackBonus(oTarget);

    effect eBonus = EffectSkillIncrease(SKILL_DISCIPLINE, GetLevelByClass(CLASS_TYPE_PURPLE_DRAGON_KNIGHT, oPC));
    eBonus        = EffectLinkEffects(EffectVisualEffect(VFX_DUR_CESSATE_NEUTRAL), eBonus);
    eBonus        = EffectLinkEffects(EffectVisualEffect(VFX_DUR_AURA_PULSE_ORANGE_WHITE), eBonus);

    if (nBABBonus > 0)
    {
      eBonus = EffectLinkEffects(EffectAttackIncrease(nBABBonus), eBonus);
    }

    if (bValiant)
    {
      eBonus = EffectLinkEffects(EffectHaste(), eBonus);
    }

    effect eVFX = EffectVisualEffect(VFX_IMP_PDK_HEROIC_SHIELD);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonus, oTarget, HoursToSeconds(1));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oTarget);
    SetLocalObject(oPC, "PDKHeroicTracking", oTarget);
    */
