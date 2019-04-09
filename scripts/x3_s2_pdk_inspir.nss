//::///////////////////////////////////////////////
//:: Purple Dragon Knight - Inspire Courage
//:: x3_s2_pdk_inspir.nss
//:://////////////////////////////////////////////
//:: Increase attack, damage, saving throws to
//:: friends in area of spell.
//::
//:: Knights Valiant can use this once per CL per
//:: day extra (+1 if they have Inspire 2).
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: Sept 22, 2005
//:://////////////////////////////////////////////

#include "inc_tempvars"
#include "inc_class"
#include "x0_i0_spells"
#include "inc_respawn"
#include "inc_statuseffect"

void main()
{
    //Declare main variables.
    object oPC    = OBJECT_SELF;
    // int bValiant  = GetLocalInt(gsPCGetCreatureHide(oPC), VAR_PDK) == MI_CL_PDK_VALIANT;
    int bProtector = GetLocalInt(gsPCGetCreatureHide(oPC), VAR_PDK) == MI_CL_PDK_PROTECTOR;
	int nCL = GetLocalInt(gsPCGetCreatureHide(oPC), "FL_LEVEL") /5;
    if (nCL < GetLevelByClass(CLASS_TYPE_PURPLE_DRAGON_KNIGHT, oPC))
	{
	  nCL = GetLevelByClass(CLASS_TYPE_PURPLE_DRAGON_KNIGHT, oPC);
	}
	else if (nCL > 10)
	{
	  nCL = 10;
	}
	
    int nUsed     = GetLocalInt(oPC, "PDK_INSPIRE_USES");
    int nDuration = 10;

    // if (bValiant && (nUsed < nCL || (nUsed == nCL && GetHasFeat(1086, oPC))) )
    // {

    // New cooldown system, always refresh feat uses
    if (GetHasFeat(1086, oPC))
        SetRemainingFeatUses(oPC, 1086, 1);
    else
        SetRemainingFeatUses(oPC, 1085, 1);

    //   SetTempInt(oPC, "PDK_INSPIRE_USES", nUsed + 1, TEMP_VARIABLE_EXPIRATION_EVENT_REST);
    //  SendMessageToPC(oPC, "Inspire used " + IntToString(nUsed + 1) + " time(s) today.");
    // }

    if (GetHasEffect(EFFECT_TYPE_SILENCE,OBJECT_SELF))
    {
     // Not useable when silenced. Floating text to user
        FloatingTextStrRefOnCreature(85764,OBJECT_SELF);
        return;
    }

    // Cooldown check.
    if(GetIsTimelocked(OBJECT_SELF, "Inspire Courage"))
    {
        TimelockErrorMessage(OBJECT_SELF, "Inspire Courage");
        return;
    }

    // Declare variables ahead of the loop.
    object oWard = GetLocalObject(oPC, "PDKWard");
    float fDelay;
    int nSaves = 2;
    if (bProtector)
        nSaves = 4;
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, nSaves, SAVING_THROW_TYPE_ALL);
    eSave = EffectLinkEffects(eSave, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
    effect eImpact = EffectVisualEffect(VFX_IMP_PDK_GENERIC_HEAD_HIT);// Get VFX
    effect eBad;
    int nImmunity = 5 + GetLevelByClass(CLASS_TYPE_PURPLE_DRAGON_KNIGHT, oPC) / 2;
    effect eLink;

    // Instant VfX
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PDK_INSPIRE_COURAGE), OBJECT_SELF);
    DelayCommand(0.8, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PDK_GENERIC_PULSE), OBJECT_SELF));


    // Get first target
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));

    // Keep processing while oTarget is valid
    while(GetIsObjectValid(oTarget))
    {
        if(GetIsNeutral(oTarget) || GetIsFriend(oTarget)) {
            fDelay = GetRandomDelay();
            // Remove fear!
            RemoveFearEffects(oTarget, FEAR_EFFECT_TYPE_ANY, VFX_IMP_REMOVE_CONDITION);
            // Apply Saving Throws
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eSave), oTarget, TurnsToSeconds(1)));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget));

            // While loops in while loops.  Fun.
            if (bProtector == TRUE && nCL >= 7) {
                eBad = GetFirstEffect(oTarget);

                //Search for negative effects
                while(GetIsEffectValid(eBad))
                {
                    if (sepREGetIsDeathEffect(eBad, oTarget) || GetIsFearEffect(eBad))
                    {
                        // Skip over the death effect
                        // eBad = GetNextEffect(oTarget);
                    }
                    else if (GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE ||
                            GetEffectType(eBad) == EFFECT_TYPE_AC_DECREASE ||
                            GetEffectType(eBad) == EFFECT_TYPE_ATTACK_DECREASE ||
                            GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_DECREASE ||
                            GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
                            GetEffectType(eBad) == EFFECT_TYPE_SAVING_THROW_DECREASE ||
                            GetEffectType(eBad) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
                            GetEffectType(eBad) == EFFECT_TYPE_SKILL_DECREASE ||
                            GetEffectType(eBad) == EFFECT_TYPE_BLINDNESS ||
                            GetEffectType(eBad) == EFFECT_TYPE_DEAF ||
                            GetEffectType(eBad) == EFFECT_TYPE_CONFUSED ||
                            GetEffectType(eBad) == EFFECT_TYPE_DAZED ||
                            GetEffectType(eBad) == EFFECT_TYPE_STUNNED ||
                            GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
                            GetEffectType(eBad) == EFFECT_TYPE_NEGATIVELEVEL ||
                            GetEffectType(eBad) == EFFECT_TYPE_CUTSCENEIMMOBILIZE )
                    {
                        //Remove effect if it is negative.
                        RemoveEffect(oTarget, eBad);
                    }
                    eBad = GetNextEffect(oTarget);
                }
                if (GetIsObjectValid(oWard) == TRUE && oWard == oTarget && GetHasFeatEffect(FEAT_PDK_SHIELD, oTarget) == TRUE) {
                    eLink = EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, nImmunity);
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
                    DelayCommand(fDelay + 0.1, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSave, oTarget, TurnsToSeconds(1)));
                }
            }
            else
            {
                if (GetIsObjectValid(oWard) == TRUE && oWard == oTarget && GetHasFeatEffect(FEAT_PDK_SHIELD, oTarget) == TRUE)
                {
                    eBad = GetFirstEffect(oTarget);

                    //Search for negative effects
                    while(GetIsEffectValid(eBad))
                    {
                        if (sepREGetIsDeathEffect(eBad, oTarget) || GetIsFearEffect(eBad))
                        {
                            // Skip over the death effect
                            // eBad = GetNextEffect(oTarget);
                        }
                        else if (GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE ||
                                GetEffectType(eBad) == EFFECT_TYPE_AC_DECREASE ||
                                GetEffectType(eBad) == EFFECT_TYPE_ATTACK_DECREASE ||
                                GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_DECREASE ||
                                GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
                                GetEffectType(eBad) == EFFECT_TYPE_SAVING_THROW_DECREASE ||
                                GetEffectType(eBad) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
                                GetEffectType(eBad) == EFFECT_TYPE_SKILL_DECREASE ||
                                GetEffectType(eBad) == EFFECT_TYPE_BLINDNESS ||
                                GetEffectType(eBad) == EFFECT_TYPE_DEAF ||
                                GetEffectType(eBad) == EFFECT_TYPE_CONFUSED ||
                                GetEffectType(eBad) == EFFECT_TYPE_DAZED ||
                                GetEffectType(eBad) == EFFECT_TYPE_STUNNED ||
                                GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
                                GetEffectType(eBad) == EFFECT_TYPE_NEGATIVELEVEL ||
                                GetEffectType(eBad) == EFFECT_TYPE_CUTSCENEIMMOBILIZE )
                        {
                            //Remove effect if it is negative, break loop.
                            RemoveEffect(oTarget, eBad);
                            break;
                        }
                        eBad = GetNextEffect(oTarget);
                    }
                }
            }
        }
        // Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF), TRUE, OBJECT_TYPE_CREATURE);
    }

    // Whew.

    // 3 min Cooldown, 1.5 min for Protectors
    if (bProtector)
        SetTimelock(OBJECT_SELF, FloatToInt(RoundsToSeconds(15)), "Inspire Courage", 60, 30);
    else
        SetTimelock(OBJECT_SELF, FloatToInt(TurnsToSeconds(3)), "Inspire Courage", 60, 30);
}


/* OLD CODE
    //Check to see if the caster has Lasting Impression and increase duration.
    if(GetHasFeat(870))
    {
        nDuration *= 10;
    }

    // lingering song
    if(GetHasFeat(424)) // lingering song
    {
        nDuration += 5;
    }

    float fDuration = RoundsToSeconds(nDuration);
    int nCha      = GetAbilityModifier(ABILITY_CHARISMA, oPC);

    effect eAttack = EffectAttackIncrease(1);// Attack effect increased
    effect eDamage = EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_BLUDGEONING);// Increased damage effect
    effect eLink = EffectLinkEffects(eAttack, eDamage);// link effects

    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, nCha, SAVING_THROW_TYPE_ALL);// Saving throw increase
    eLink = EffectLinkEffects(eLink, eSave);// link in saving throw
    eLink = ExtraordinaryEffect(eLink);// make effects ExtraOrdinary

    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);// Get VFX
    eLink = EffectLinkEffects(eLink, eDur);// link VFXs

    effect eImpact = EffectVisualEffect(VFX_IMP_PDK_GENERIC_HEAD_HIT);// Get VFX

    // Apply effect at location
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PDK_INSPIRE_COURAGE), OBJECT_SELF);
    DelayCommand(0.8, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PDK_GENERIC_PULSE), OBJECT_SELF));

    // Get first target
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));

    // Keep processing while oTarget is valid
    while(GetIsObjectValid(oTarget))
    {
         // * GZ Oct 2003: If we are silenced, we can not benefit from bard song
         if (!GetHasEffect(EFFECT_TYPE_SILENCE,oTarget) && !GetHasEffect(EFFECT_TYPE_DEAF,oTarget))
         {
            if(oTarget == OBJECT_SELF)
            {
                // oTarget is caster, apply effects
                DelayCommand(0.9, ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget));
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eLink), oTarget, fDuration);

            }
            else if(GetIsNeutral(oTarget) || GetIsFriend(oTarget))
            {
                // oTarget is a friend, apply effects
                DelayCommand(0.9, ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget));
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
            }
        }

        // Get next object in the sphere
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }
*/
