//::///////////////////////////////////////////////
//:: Circle of Healing: Heartbeat
//:: NW_S0_HealCircc
//:://////////////////////////////////////////////
/*
// Positive energy spreads out in all directions
// from the point of origin, curing 1d8 points of
// damage plus 1 point per caster level (maximum +30)
// to nearby living allies.
//
// Like cure spells, healing circle damages undead in
// its area rather than curing them.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 14, 2016
//:://////////////////////////////////////////////

#include "nw_i0_spells"
#include "mi_inc_spells"
#include "inc_healer"
#include "mi_inc_class"

int GetIsPureHealer(object oCaster);

void main()
{
    int nCurrentProcs = GetLocalInt(OBJECT_SELF, "CoHProcs") + 1;
    SetLocalInt(OBJECT_SELF, "CoHProcs", nCurrentProcs);

    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_20);
    effect eKill;
    effect eVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
    object oCaster = GetAreaOfEffectCreator();
    object oTarget;
    int nCasterLevel = GetAoECasterLevel();
    int nHP;
    int nMetaMagic = AR_GetMetaMagicFeat();
    int nModify;
    float fDelay;
    float fRadius = RADIUS_SIZE_LARGE;
    location lSource = GetLocation(OBJECT_SELF);

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lSource);
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lSource);

    while(GetIsObjectValid(oTarget))
    {
        fDelay = GetRandomDelay();
        if((GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD) || (gsSUGetSubRaceByName(GetSubRace(oTarget)) == GS_SU_SPECIAL_VAMPIRE))
        {
            if(!GetIsReactionTypeFriendly(oTarget, oCaster) || (gsSUGetSubRaceByName(GetSubRace(oTarget)) == GS_SU_SPECIAL_VAMPIRE))
            {
                SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_HEALING_CIRCLE));
                if(!MyResistSpell(oCaster, oTarget, fDelay))
                {
                    nModify = d8() + nCasterLevel;
                    if(nMetaMagic == METAMAGIC_MAXIMIZE)
                    {
                        nModify = 8 + nCasterLevel;
                    }
                    else
                    {
                        nModify = EmpowerSpell(nModify, FEAT_HEALING_DOMAIN_POWER);
                    }
                    if(MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, oCaster, fDelay))
                    {
                        nModify /= 2;
                    }
                    eKill = EffectDamage(nModify, DAMAGE_TYPE_POSITIVE);
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
            }
        }
        else
        {
            if(!GetIsReactionTypeHostile(oTarget, oCaster) || GetFactionEqual(oTarget, oCaster))
            {
                SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_HEALING_CIRCLE, FALSE));
                nHP = d8() + nCasterLevel;
                if(nMetaMagic == METAMAGIC_MAXIMIZE)
                {
                    nHP = 8 + nCasterLevel;
                }
                else
                {
                    nHP = EmpowerSpell(nHP, FEAT_HEALING_DOMAIN_POWER);
                }
                DelayCommand(fDelay, ApplyHealToObject(nHP, oTarget, oCaster));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_M), oTarget));
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lSource);
    }

    if(nCurrentProcs >= 3)
    {
        DestroyObject(OBJECT_SELF, 1.2);
    }
}
