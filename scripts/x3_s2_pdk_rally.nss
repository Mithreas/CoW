//::///////////////////////////////////////////////
//:: Purple Dragon Knight - Rallying Cry
//:: x3_s2_pdk_rally.nss
//:://////////////////////////////////////////////
//:: Steals aggro from every enemy in range.
//:: Knights Protector can use this unlimited
//:: times per day.
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: Sept 22, 2005
//:://////////////////////////////////////////////

#include "gs_inc_combat"
#include "mi_inc_class"
#include "x0_i0_spells"
#include "inc_timelock"
#include "x2_inc_itemprop"

void main()
{
    object oPC = OBJECT_SELF;

    // int bProtector = GetLocalInt(gsPCGetCreatureHide(oPC), VAR_PDK) == MI_CL_PDK_PROTECTOR;
    // if (bProtector)
    // {
    // Protectors can use this any number of times per day.  So top it back up.
    SetRemainingFeatUses(oPC, 1080, 3);
    // }

    int bValiant  = GetLocalInt(gsPCGetCreatureHide(oPC), VAR_PDK) == MI_CL_PDK_VALIANT;

    if (GetHasEffect(EFFECT_TYPE_SILENCE, OBJECT_SELF))
    {
        // Not useable when silenced. Floating text to user
        FloatingTextStrRefOnCreature(85764, OBJECT_SELF);
        return;
    }

    // Cooldown check.
    if(GetIsTimelocked(OBJECT_SELF, "Rallying Cry"))
    {
        TimelockErrorMessage(OBJECT_SELF, "Rallying Cry");
        return;
    }

    // Apply Knight VFX
    PlayVoiceChat(VOICE_CHAT_BATTLECRY1);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PDK_RALLYING_CRY), OBJECT_SELF);
    DelayCommand(0.8, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PDK_GENERIC_PULSE), OBJECT_SELF));

    effect eImp = EffectVisualEffect(VFX_IMP_AURA_UNEARTHLY);// Target VFX

    // Declare variables ahead of the loop
    float fDelay;
    effect eLink;
    int nAB = 1;
    if (bValiant && GetLevelByClass(CLASS_TYPE_PURPLE_DRAGON_KNIGHT, oPC) > 9)
        nAB = 3;
    else if (bValiant && GetLevelByClass(CLASS_TYPE_PURPLE_DRAGON_KNIGHT, oPC) > 6)
        nAB = 2;

    // Charisma limit
    if (nAB > GetAbilityModifier(ABILITY_CHARISMA))
        nAB = GetAbilityModifier(ABILITY_CHARISMA);
    if (nAB < 1)
        nAB = 1;

    int nDamage = IPGetDamageBonusConstantFromNumber(nAB);

    object oWard = GetLocalObject(oPC, "PDKWard");
    int nWardDmg = IPGetDamageBonusConstantFromNumber(nAB + 2);

    // Get first object in sphere
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    // Keep processing until oTarget is not valid
    while(GetIsObjectValid(oTarget))
    {
         fDelay = GetRandomDelay();

         // If we are deaf or silenced we cannot hear the rallying cry.
         if (!GetHasEffect(EFFECT_TYPE_SILENCE, oTarget) && !GetHasEffect(EFFECT_TYPE_DEAF,oTarget))
         {
            if(GetIsFriend(oTarget))
            {
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eImp, oTarget));
                eLink = EffectAttackIncrease(nAB);

                // Wards get +2 damage
                if (GetIsObjectValid(oWard) == TRUE && oWard == oTarget && GetHasFeatEffect(FEAT_PDK_SHIELD, oTarget) == TRUE)
                    eLink = EffectLinkEffects(eLink, EffectDamageIncrease(nWardDmg, DAMAGE_TYPE_BLUDGEONING));
                else
                    eLink = EffectLinkEffects(eLink, EffectDamageIncrease(nDamage, DAMAGE_TYPE_BLUDGEONING));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eLink), oTarget, TurnsToSeconds(1)));
            }
        }
        // Get next object in the sphere
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }

    // 3 min Cooldown, 1.5 min for Valiants
    if (bValiant)
        SetTimelock(OBJECT_SELF, FloatToInt(RoundsToSeconds(15)), "Rallying Cry", 60, 30);
    else
        SetTimelock(OBJECT_SELF, FloatToInt(TurnsToSeconds(3)), "Rallying Cry", 60, 30);
}


/* OLD CODE
                // oTarget is a hostile, apply effects
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eImp, oTarget));

                if (GetIsPC(oTarget) &&
                    !GetIsSkillSuccessful(oTarget, SKILL_CONCENTRATION, d20() + GetSkillRank(SKILL_INTIMIDATE, oPC)))
                {
                  // Don't interrupt an action, but if the PC isn't mid action, redirect them.
                  if (GetCurrentAction(oTarget) == ACTION_MOVETOPOINT  || GetCurrentAction(oTarget) == ACTION_INVALID)
                  {
                    AssignCommand(oTarget, ClearAllActions(TRUE));
                    AssignCommand(oTarget, ActionAttack(oPC));
                  }
                }
                else
                {
                  gsCBSetAttackTarget(oPC, oTarget);
                }
*/
