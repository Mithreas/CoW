//::///////////////////////////////////////////////
//:: Purple Dragon Knight - Oath of Wrath
//:: x3_s2_pdk_wrath.nss
//:://////////////////////////////////////////////
//::The target loses 2 AC for 1 turn. Furthermore, unless
//::the PDK is currently being guarded, the PDK is
//::treated as -guarding anyone the enemy would
//::attack for the duration.
//::
//::(Valiant): The PDK’s allies gain 1 + 1 / 5 PDK
//::levels magic damage vs. the target’s racial type for 1 turn.
//::
//::(Vanguard): The target additionally incurs 5%
//::vulnerability to all damage types + 1% / PDK level.
//::
//::(Protector): The target additionally loses
//::1 AB / 5 PDK levels and gains 2% ASF / PDK level.
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: Sept 22, 2005
//:://////////////////////////////////////////////
#include "inc_class"
#include "x2_inc_itemprop"
#include "inc_timelock"

void main()
{
    SetRemainingFeatUses(OBJECT_SELF, 1083, 1);
    // Cooldown check.
    if(GetIsTimelocked(OBJECT_SELF, "Oath of Wrath"))
    {
        TimelockErrorMessage(OBJECT_SELF, "Oath of Wrath");
        return;
    }

    //Declare main variables.
    object oPC = OBJECT_SELF;
    int bVanguard = GetLocalInt(gsPCGetCreatureHide(oPC), VAR_PDK) == MI_CL_PDK_VANGUARD;
    int bValiant  = GetLocalInt(gsPCGetCreatureHide(oPC), VAR_PDK) == MI_CL_PDK_VALIANT;
    int bProtector = GetLocalInt(gsPCGetCreatureHide(oPC), VAR_PDK) == MI_CL_PDK_PROTECTOR;

    object oTarget = GetSpellTargetObject();// Target

	int nCL = GetLocalInt(gsPCGetCreatureHide(oPC), "FL_LEVEL") /5;
    if (nCL < GetLevelByClass(CLASS_TYPE_PURPLE_DRAGON_KNIGHT, oPC))
	{
	  nCL = GetLevelByClass(CLASS_TYPE_PURPLE_DRAGON_KNIGHT, oPC);
	}
	else if (nCL > 10)
	{
	  nCL = 10;
	}
	
    if (oPC == oTarget)
    {
         FloatingTextStringOnCreature("You cannot target yourself using this ability", oPC, FALSE);
         return;
    }
    if (GetIsFriend(oTarget))
    {
         FloatingTextStringOnCreature("You cannot target an ally using this ability", oPC, FALSE);
         return;
    }

    int nRace   = GetRacialType(oTarget);// Get race of target
    int nDamage;
    int nImmunity;
    int nAttack;
    int nASF;
    effect eDamage;
    object oAlly;
    float fDelay;

    // Baseline effect is -2 AC for a turn
    effect eACPen  = EffectACDecrease(2);

    // For vanguard: target additionally gains vulnerability to damage
    if (bVanguard) {
        nImmunity = 5 + nCL;
        eACPen = EffectLinkEffects(eACPen, EffectDamageImmunityDecrease(DAMAGE_TYPE_BLUDGEONING, nImmunity));
        eACPen = EffectLinkEffects(eACPen, EffectDamageImmunityDecrease(DAMAGE_TYPE_SLASHING, nImmunity));
        eACPen = EffectLinkEffects(eACPen, EffectDamageImmunityDecrease(DAMAGE_TYPE_PIERCING, nImmunity));
        eACPen = EffectLinkEffects(eACPen, EffectDamageImmunityDecrease(DAMAGE_TYPE_ACID, nImmunity));
        eACPen = EffectLinkEffects(eACPen, EffectDamageImmunityDecrease(DAMAGE_TYPE_COLD, nImmunity));
        eACPen = EffectLinkEffects(eACPen, EffectDamageImmunityDecrease(DAMAGE_TYPE_ELECTRICAL, nImmunity));
        eACPen = EffectLinkEffects(eACPen, EffectDamageImmunityDecrease(DAMAGE_TYPE_FIRE, nImmunity));
        eACPen = EffectLinkEffects(eACPen, EffectDamageImmunityDecrease(DAMAGE_TYPE_SONIC, nImmunity));
        eACPen = EffectLinkEffects(eACPen, EffectDamageImmunityDecrease(DAMAGE_TYPE_MAGICAL, nImmunity));
        eACPen = EffectLinkEffects(eACPen, EffectDamageImmunityDecrease(DAMAGE_TYPE_NEGATIVE, nImmunity));
        eACPen = EffectLinkEffects(eACPen, EffectDamageImmunityDecrease(DAMAGE_TYPE_POSITIVE, nImmunity));
        eACPen = EffectLinkEffects(eACPen, EffectDamageImmunityDecrease(DAMAGE_TYPE_DIVINE, nImmunity));
    }

    //Protector:  Target loses 1AB / 5 PDK levels, gains 2% ASF / PDK level
    if (bProtector) {
        nAttack = nCL / 5;
        if (nAttack < 1)
            nAttack = 1;
        nASF = nCL * 2;
        eACPen = EffectLinkEffects(eACPen, EffectAttackDecrease(nAttack));
        eACPen = EffectLinkEffects(eACPen, EffectSpellFailure(nASF));
    }

    // Apply effect to bad guy
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eACPen), oTarget, TurnsToSeconds(1));

    // Set local variables for inc_combat to hook into
    SetLocalObject(oTarget, "PDKWrath", OBJECT_SELF);
    SetLocalInt(oTarget, "WrathTimeStamp", GetModuleTime());

    // Valiant applies bonus to nearby allies against the target's race
    if (bValiant) {

        // Create 'versus racial type' effect
        nDamage = IPGetDamageBonusConstantFromNumber(1 + (nCL / 5));
        eDamage = EffectDamageIncrease(nDamage, DAMAGE_TYPE_MAGICAL);
        eDamage = VersusRacialTypeEffect(eDamage, nRace);

        // Get first target
        oAlly = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
        // Keep processing while oAlly is valid
        while(GetIsObjectValid(oAlly))
        {
            if(GetIsNeutral(oAlly) || GetIsFriend(oAlly)) {
                fDelay = GetRandomDelay();
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eDamage), oAlly, TurnsToSeconds(1)));
                if (oPC != oAlly)
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PDK_GENERIC_HEAD_HIT), oAlly));
            }
            // Select the next target within the spell shape.
            oAlly = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF), TRUE, OBJECT_TYPE_CREATURE);

        }
    }

    // apply fx
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PDK_OATH), oPC);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PDK_WRATH), oTarget);

    // Cooldown
    SetTimelock(OBJECT_SELF, FloatToInt(TurnsToSeconds(3)), "Oath of Wrath", 60, 30);
}


    // OLD CODE
    // int nDur    = nCL;// Duration
    // int nBonus  = (GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE) - 10) / 2;// Base INT mod.
    // int nDamage = nBonus;
    // if (nDamage > 5) nDamage += 10; // DAMAGE_* constants are structured oddly.

    // effect eAttack = EffectAttackIncrease(nBonus);// Increase attack
    // effect eDamage = EffectDamageIncrease(nDamage, DAMAGE_TYPE_BLUDGEONING);// Increase damage
/*
    // Apply effects to caster
    if (bVanguard && nBonus > 0)
    {
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAttack, oPC, HoursToSeconds(nDur));
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDamage, oPC, HoursToSeconds(nDur));
    }

    // Apply effect to bad guy
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eACPen, oTarget, RoundsToSeconds(nDur));

    // apply fx
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PDK_OATH), oPC);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PDK_WRATH), oTarget);
*/
