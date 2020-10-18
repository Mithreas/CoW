//::///////////////////////////////////////////////
//:: Purple Dragon Knight - Final Stand
//:: x3_s2_pdk_stand.nss
//:://////////////////////////////////////////////
//:: Add temporary hitpoints to friends in spell
//:: sphere.  Increase allies' AC to equal
//:: knight's.
//::
//:: Knights Protector can use this an extra 1/day.
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: Sept 22, 2005
//:://////////////////////////////////////////////
#include "inc_class"
#include "inc_timelock"
#include "inc_effect"

void main()
{

    SetRemainingFeatUses(OBJECT_SELF, 1084, 1);
    // Cooldown check.
    if(GetIsTimelocked(OBJECT_SELF, "Final Stand"))
    {
        TimelockErrorMessage(OBJECT_SELF, "Final Stand");
        return;
    }

    //Declare main variables.
    object oPC = OBJECT_SELF;
    int bVanguard   = GetLocalInt(gsPCGetCreatureHide(oPC), VAR_PDK) == MI_CL_PDK_VANGUARD;
    int bValiant    = GetLocalInt(gsPCGetCreatureHide(oPC), VAR_PDK) == MI_CL_PDK_VALIANT;
    int bProtector  = GetLocalInt(gsPCGetCreatureHide(oPC), VAR_PDK) == MI_CL_PDK_PROTECTOR;
	
	int nCL = GetLocalInt(gsPCGetCreatureHide(oPC), "FL_LEVEL") /5;
    if (nCL < GetLevelByClass(CLASS_TYPE_PURPLE_DRAGON_KNIGHT, oPC))
	{
	  nCL = GetLevelByClass(CLASS_TYPE_PURPLE_DRAGON_KNIGHT, oPC);
	}
	else if (nCL > 10)
	{
	  nCL = 10;
	}
	
    int nUsed       = GetLocalInt(oPC, "PDK_FSTAND_USES");
    int nHP;
    effect eVis     = EffectVisualEffect(VFX_IMP_PDK_GENERIC_HEAD_HIT);
    float fPercent;
    object oWard    = GetLocalObject(oPC, "PDKWard");
    int bWarded     = FALSE;
    effect eAOE, eLink;
    effect eImmobile = EffectLinkEffects(EffectCutsceneImmobilize(), EffectVisualEffect(VFX_DUR_PDK_FEAR));

    if (GetIsObjectValid(oWard) == TRUE && GetHasFeatEffect(FEAT_PDK_SHIELD, oWard) == TRUE)
        bWarded = TRUE;

    // Final stand path bonuses only occur at 10 PDK levels.
    if (nCL < 10) {
        bVanguard = FALSE;
        bValiant = FALSE;
        bProtector = FALSE;
    }

    if (bProtector) {
        // We're going to apply a special protector effect.
        // Let's prepare it ahead of time.
        eLink = EffectDamageReduction(5, DAMAGE_POWER_PLUS_TEN);
        eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, 20));
        eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 20));
        eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 20));
        eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 20));
        eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC, 20));
        eLink = ExtraordinaryEffect(eLink);
    }

    // VfX originating in PDK
    DelayCommand(0.8, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PDK_GENERIC_PULSE), oPC));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PDK_FINAL_STAND), oPC);

    // Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF), TRUE, OBJECT_TYPE_CREATURE);

    // Cycle through the targets within the spell shape until you run out of targets.
    while (GetIsObjectValid(oTarget))
    {
        if(GetIsNeutral(oTarget) || GetIsFriend(oTarget)) {
            // Amount healed is 1d8 x PDK levels + 1d8 per 5% missing health.
            fPercent = (100.0 - IntToFloat(GetCurrentHitPoints(oTarget)) / IntToFloat(GetMaxHitPoints(oTarget)) * 100.0) / 5.0;
            nHP = d8(nCL) + d8(FloatToInt(fPercent));

            // Empower for Ward
            if (bWarded == TRUE && oTarget == oWard)
                nHP = FloatToInt(IntToFloat(nHP) * 1.5);

            // Apply Healing, do VfX effect
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHP), oTarget);
            DelayCommand(0.9, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));

            if (bValiant)
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectRegenerate(10, 6.0)), oTarget, TurnsToSeconds(1));

            if (bProtector)
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink,  oTarget, TurnsToSeconds(1));

        } else if (GetIsEnemy(oTarget) && bVanguard) {
            if (!GetIsImmune(oTarget, IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE))
                DelayCommand(0.9, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eImmobile, oTarget, RoundsToSeconds(1)));
        }
        //Get next target in the spell cone
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation(), TRUE);
    }

    // Cooldown
    SetTimelock(OBJECT_SELF, FloatToInt(TurnsToSeconds(3)), "Final Stand", 60, 30);
}

/* Old Aura attempts at implementation
    // Valiants get a 10 regen aura for 1 turn.
    if (bValiant) {
        // Make sure to apply this effect to the PDK
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectRegenerate(10, 6.0), oPC, TurnsToSeconds(1));

        eAOE = EffectAreaOfEffect(AOE_MOB_CIRCLAW,"ent_regenaura", "","");
        eAOE = ExtraordinaryEffect(eAOE);
        SetLocalInt(oPC, "REGEN_AURA_AMOUNT", 10);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eAOE, oPC, TurnsToSeconds(1));
    }

    // Protectors grant an aura of 20% immunity resist, and 5/- DR
    if (bProtector) {
        // Make sure to apply this effect to the PDK
        eLink = EffectDamageReduction(5, DAMAGE_POWER_PLUS_TEN);
        eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, 20));
        eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 20));
        eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 20));
        eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 20));
        eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC, 20));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(1));

        eAOE = EffectAreaOfEffect(AOE_MOB_PROTECTION,"ent_finalstand", "","");
        eAOE = ExtraordinaryEffect(eAOE);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eAOE, oPC, TurnsToSeconds(1));
    }
*/

/* OLD CODE
    int nPercent = 50 + (nCL / 2) * 5;

    if (GetCurrentHitPoints(oPC) >= GetMaxHitPoints(oPC) / 2)
    {
        FloatingTextStringOnCreature("You must be under half health to use this ability.", oPC, FALSE);
        SetRemainingFeatUses(oPC, 1084, 1);
        return;
    }

    if (bProtector && nUsed < nCL)
    {
      SetRemainingFeatUses(oPC, 1084, 1);
      SetTempInt(oPC, "PDK_FSTAND_USES", nUsed + 1, TEMP_VARIABLE_EXPIRATION_EVENT_REST);
      SendMessageToPC(oPC, "Final Stand used " + IntToString(nUsed + 1) + " time(s) today.");
    }

    //Check to see if the caster has Lasting Impression and increase duration.
    if(GetHasFeat(870))
    {
        nCL *= 10;
    }

    // lingering song
    if(GetHasFeat(424)) // lingering song
    {
        nCL += 5;
    }

    float fDuration = RoundsToSeconds(nCL);

    int nTHP = 2 * nCL;
    effect eHP = EffectTemporaryHitpoints(nTHP);// Increase hit points
    eHP = ExtraordinaryEffect(eHP);// Make effect ExtraOrdinary
    effect eVis = EffectVisualEffect(VFX_IMP_PDK_GENERIC_HEAD_HIT);// Get VFX

    DelayCommand(0.8, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PDK_GENERIC_PULSE), oPC));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PDK_FINAL_STAND), oPC);

    // Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF), TRUE, OBJECT_TYPE_CREATURE);

    // Cycle through the targets within the spell shape until you run out of targets.
    while (GetIsObjectValid(oTarget))
    {
        nHP = (GetMaxHitPoints(oTarget) - GetCurrentHitPoints(oTarget)) * nPercent / 100;

        if(oTarget == OBJECT_SELF)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHP), oTarget);
            DelayCommand(0.9, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oTarget, fDuration);

        }
        else if(GetIsNeutral(oTarget) || GetIsFriend(oTarget))
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHP), oTarget);

            DelayCommand(0.9, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oTarget, fDuration);
        }

        // Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF), TRUE, OBJECT_TYPE_CREATURE);
    }
*/
