//::///////////////////////////////////////////////
//:: Sunbeam
//:: s_Sunbeam.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:: All creatures in the beam are struck blind and suffer 4d6 points of damage. (A successful
//:: Reflex save negates the blindness and reduces the damage by half.) Creatures to whom sunlight
//:: is harmful or unnatural suffer double damage.
//::
//:: Undead creatures caught within the ray are dealt 1d6 points of damage per caster level
//:: (maximum 20d6), or half damage if a Reflex save is successful. In addition, the ray results in
//:: the total destruction of undead creatures specifically affected by sunlight if they fail their saves.
//:://////////////////////////////////////////////
//:: Created By: Keith Soleski
//:: Created On: Feb 22, 2001
//:://////////////////////////////////////////////
//:: Last Modified By: Keith Soleski, On: March 21, 2001
//:: VFX Pass By: Preston W, On: June 25, 2001

#include "X0_I0_SPELLS"
#include "inc_spells"
#include "mi_inc_spells"
#include "x2_i0_spells"


const string INFERNO_VAR = "AR_SUNBEAMINF_DUR";

void RunImpact(object oTarget, object oCaster, int nMetaMagic);
void ApplyInfernoToTarget(object oTarget, int nMetaMagic, int bIsAffected);


void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check mi_inc_spells.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    int nMetaMagic = AR_GetMetaMagicFeat();
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
    effect eVis2 = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
    effect eStrike = EffectVisualEffect(VFX_FNF_SUNBEAM);
    effect eDam;
    effect eBlind = EffectBlindness();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eBlind, eDur);
    eLink = EffectLinkEffects(eBlind, eDur);

    int nCasterLevel= AR_GetCasterLevel(OBJECT_SELF);
    int nClass = GetLastSpellCastClass();
    int isDruid = nClass == CLASS_TYPE_DRUID;
    int nDices = nCasterLevel;
    int nDamage;
    int nOrgDam;
    int nMax;
    float fDelay;
    int nBlindLength = 3;
    int nNumTargets = 0;

    //::  Limit caster level to 10 if Druid, else just the regular 20
    int nMaxDice = isDruid ? 10 : 20;
    if (nDices > nMaxDice) {
        nDices = nMaxDice;
    }

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eStrike, GetSpellTargetLocation());
    //Get the first target in the spell area
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetSpellTargetLocation());
    while(GetIsObjectValid(oTarget))
    {
        // Make a faction check
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            fDelay = GetRandomDelay(1.0, 2.0);

            //::  If already affected by Inferno or previous Sunbeam, cancel out Inferno then.
            int bIsAffected = GetHasSpellEffect(GetSpellId(), oTarget) || GetHasSpellEffect(SPELL_COMBUST, oTarget) || GetHasSpellEffect(SPELL_SUNBEAM, oTarget);

            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SUNBEAM));

            //Make an SR check
            if ( ! MyResistSpell(OBJECT_SELF, oTarget, 1.0))
            {
                //Check if the target is an undead
                if ((GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD) || (gsSUGetSubRaceByName(GetSubRace(oTarget)) == GS_SU_SPECIAL_VAMPIRE))
                {
                    //Roll damage and save
                    nDamage = d6(nDices);
                    nMax = 6;
                }
                else
                {
                    //Roll damage and save
                    nDamage = d6(3);
                    nOrgDam = nDamage;
                    nMax = 6;
                    nDices = 3;
                    //Get the adjusted damage due to Reflex Save, Evasion or Improved Evasion
                }

                //Do metamagic checks
                if (nMetaMagic == METAMAGIC_MAXIMIZE)
                {
                    nDamage = nMax * nDices;
                }
                if (nMetaMagic == METAMAGIC_EMPOWER)
                {
                    nDamage = nDamage + (nDamage/2);
                }

                //Check that a reflex save was made.
                if(MySavingThrow(SAVING_THROW_REFLEX, oTarget, AR_GetSpellSaveDC(), SAVING_THROW_TYPE_DIVINE, OBJECT_SELF, 1.0) == 0)
                {
                    if ( isDruid && GetIsReactionTypeHostile(oTarget, OBJECT_SELF) && ++nNumTargets < 8 ) //::  Max 8 Targets, lets not go crazy here
                        DelayCommand(0.8, AssignCommand(OBJECT_SELF, ApplyInfernoToTarget(oTarget, nMetaMagic, bIsAffected)));

                    DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nBlindLength)));
                }
                else
                {
                    nDamage = AR_GetReflexAdjustedDamage(nDamage, oTarget, 0, SAVING_THROW_TYPE_DIVINE);
                }
                //Set damage effect
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_DIVINE);
                if(nDamage > 0)
                {
                    //Apply the damage effect and VFX impact
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                }
            }
        }
        //Get the next target in the spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetSpellTargetLocation());
    }
}


void ApplyInfernoToTarget(object oTarget, int nMetaMagic, int bIsAffected) {
    if ( bIsAffected ) {
        FloatingTextStrRefOnCreature(100775, OBJECT_SELF, FALSE);
        return;
    }

    if ( !GetIsReactionTypeHostile(oTarget, OBJECT_SELF) ) {
        return;
    }

    //::  VFX
    int nDuration = AR_GetCasterLevel(OBJECT_SELF);
    effect eDur = EffectVisualEffect(498);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, RoundsToSeconds(nDuration));
    SetLocalInt(oTarget, INFERNO_VAR, nDuration);

    object oSelf = OBJECT_SELF;
    RunImpact(oTarget, oSelf, nMetaMagic);
}

void RunImpact(object oTarget, object oCaster, int nMetaMagic)
{
    //--------------------------------------------------------------------------
    // Check if the spell has expired
    //--------------------------------------------------------------------------
    int nRoundsLeft = GetLocalInt(oTarget, INFERNO_VAR);
    if ( !GetIsObjectValid(oCaster) ||
         !GetIsObjectValid(oTarget) ||
          GetIsDead(oCaster) ||
          GetIsDead(oTarget) ||
          nRoundsLeft <= 0 ||
          GetArea(oTarget) != GetArea(oCaster) ) {
        DeleteLocalInt(oTarget, INFERNO_VAR);
        return;
    }
    SetLocalInt(oTarget, INFERNO_VAR, nRoundsLeft - 1);

    if (GetIsDead(oTarget) == FALSE)
    {
        //----------------------------------------------------------------------
        // Calculate Damage
        //----------------------------------------------------------------------
        //::  With Transmutation Greater or Epic damage is changed as 1d6/4 Caster Level
        int nDices = 2;
        if ( GetHasFeat(FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION, oCaster) || GetHasFeat(FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION, oCaster) ) {
            int nCasterLevel = AR_GetCasterLevel(oCaster);
            nDices = nCasterLevel / 4;
        }

        int nDamage = MaximizeOrEmpower(6, nDices, nMetaMagic);
        effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
        effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
        eDam = EffectLinkEffects(eVis, eDam);
        ApplyEffectToObject (DURATION_TYPE_INSTANT, eDam, oTarget);

        DelayCommand(6.0f, RunImpact(oTarget, oCaster, nMetaMagic));
    }
}
