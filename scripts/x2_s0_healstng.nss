//::///////////////////////////////////////////////
//:: Healing Sting
//:: X2_S0_HealStng
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    You inflict 1d6 +1 point per level damage to
    the living creature touched and gain an equal
    amount of hit points. You may not gain more
    hit points then your maximum with the Healing
    Sting.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 19, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: ActionReplay, 24/03/2017

/*
    Deals 1d6 + 1 Damage / 2 Caster Levels
    Capped at 20 Caster Levels
    Max Dmg: 10d6 + 10 = 70 Damage

    Heals the caster for the amount of Damage.
    If healing goes beyond Maximum HP and target dies, all excess damage
    is applied as Temp. HP for 1 Hour / 2 Caster Levels
*/

#include "nw_i0_spells"
#include "inc_customspells"
#include "inc_spells"

void AddOverHeal(object oTarget, int nTempHP, int nDuration) {
    if ( GetIsObjectValid(oTarget) == FALSE || GetIsDead(oTarget) ) {
        RemoveTempHitPoints();

        effect eTempHP  = EffectTemporaryHitpoints(nTempHP);
        effect eDur     = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eLinkTmp = EffectLinkEffects(eTempHP, eDur);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinkTmp, OBJECT_SELF, HoursToSeconds(nDuration));
    }
}

void main()
{

/*
  Spellcast Hook Code
  Added 2003-07-07 by Georg Zoeller
  If you want to make changes to all spells,
  check inc_customspells.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nCasterLvl = AR_GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = AR_GetMetaMagicFeat();

    if ( nCasterLvl > 20 ) nCasterLvl = 20;

    int nBonus      = nCasterLvl / 2;
    int nDamage     = d6(nBonus) + nBonus;
    int nDuration   = nCasterLvl / 2;   //::  Duration not capped at 20

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration *= 2;
    }
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
        nDamage = (6 * nBonus) + nBonus;
    }
    else if (nMetaMagic == METAMAGIC_EMPOWER)
    {
         nDamage += nDamage / 2;
    }

    //Declare effects
    effect eHeal    = EffectHeal(nDamage);
    effect eVs      = EffectVisualEffect(VFX_IMP_HEALING_M);
    effect eLink    = EffectLinkEffects(eVs,eHeal);

    effect eDamage  = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
    effect eVis     = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eLink2   = EffectLinkEffects(eVis,eDamage);

    //::  Calculate Temporary HP
    int nTempHP = 0;
    //:: GetCurrentHitPoints also reports Temporary Hitpoints which lead to strange behaviour. Cap CurrentHP to Max HP if it exceeds.
    int nHP = GetCurrentHitPoints(OBJECT_SELF) > GetMaxHitPoints(OBJECT_SELF) ? GetMaxHitPoints(OBJECT_SELF) : GetCurrentHitPoints(OBJECT_SELF);
    if ( nHP + nDamage > GetMaxHitPoints(OBJECT_SELF) ) {
        nTempHP = (nHP + nDamage) - GetMaxHitPoints(OBJECT_SELF);
    }

    if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {
        if(!GetIsReactionTypeFriendly(oTarget) &&
            GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD &&
            GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT &&
            !GetHasSpellEffect(SPELL_NEGATIVE_ENERGY_PROTECTION, oTarget))
        {
           //Signal spell cast at event

            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            //Spell resistance
            if(!MyResistSpell(OBJECT_SELF, oTarget))
            {
                //::  Remove Saving Throw
                //if(!MySavingThrow(SAVING_THROW_FORT, oTarget, AR_GetSpellSaveDC(), SAVING_THROW_TYPE_NEGATIVE))
                {
                    //Apply effects to target and caster
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink2, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, OBJECT_SELF);

                    //::  Overflown HP Temp Boost
                    //::  But only if the target died, we check that
                    //::  in the wrapper.
                    if (nTempHP > 0) {
                        DelayCommand(0.5, AssignCommand(OBJECT_SELF, AddOverHeal(oTarget, nTempHP, nDuration)) );
                    }

                    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
                }
            }
        }
    }
}
