//::///////////////////////////////////////////////
//:: Healing Circle
//:: NW_S0_HealCirc
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// Positive energy spreads out in all directions
// from the point of origin, curing 1d8 points of
// damage plus 1 point per caster level (maximum +20)
// to nearby living allies.
//
// Like cure spells, healing circle damages undead in
// its area rather than curing them.
*/
//:://////////////////////////////////////////////
//:: Created By: Noel Borstad
//:: Created On: Oct 18,2000
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: Aug 1, 2001

#include "nw_i0_spells"
#include "inc_class"
#include "inc_customspells"
#include "inc_healer"
#include "inc_spells"

int GetIsHealerSpell();

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
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
  object oTarget;
  int nCasterLvl = AR_GetCasterLevel(OBJECT_SELF);
  int nDamagen, nModify, nHP;
  int nMetaMagic = AR_GetMetaMagicFeat();
  effect eKill;
  effect eHeal;
  effect eVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
  effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_20);
  float fDelay;
  float fRadius = GetIsHealerSpell() ? RADIUS_SIZE_LARGE + RADIUS_SIZE_LARGE / 30 * GetHitDice(OBJECT_SELF) : RADIUS_SIZE_LARGE;

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
    //Get first target in shape
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetSpellTargetLocation());
    while (GetIsObjectValid(oTarget))
    {
        fDelay = GetRandomDelay();
        //Check if racial type is undead
        if ((GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD ) || (gsSUGetSubRaceByName(GetSubRace(oTarget)) == GS_SU_SPECIAL_VAMPIRE))
        {
            if(!GetIsReactionTypeFriendly(oTarget) || (gsSUGetSubRaceByName(GetSubRace(oTarget)) == GS_SU_SPECIAL_VAMPIRE))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HEALING_CIRCLE));
                //Make SR check
                if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
                {
                    nModify = d8() + nCasterLvl;
                    //Make metamagic check
                    if (nMetaMagic == METAMAGIC_MAXIMIZE)
                    {
                        nModify = 8 + nCasterLvl;
                    }
                    else
                    {
                        nModify = EmpowerSpell(nModify, FEAT_HEALING_DOMAIN_POWER); //Damage/Healing is +50%
                    }

                    //Make Fort save
                    if (MySavingThrow(SAVING_THROW_FORT, oTarget, AR_GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
                    {
                        nModify /= 2;
                    }

                    //Set damage effect
                    eKill = EffectDamage(nModify, DAMAGE_TYPE_POSITIVE);
                    //Apply damage effect and VFX impact
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
            }
        }
        else
        {
            // * May 2003: Heal Neutrals as well
            if(!GetIsReactionTypeHostile(oTarget) || GetFactionEqual(oTarget))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HEALING_CIRCLE, FALSE));
                nHP = d8() + nCasterLvl;
                //Enter Metamagic conditions
                if (nMetaMagic == METAMAGIC_MAXIMIZE)
                {
                    nHP = 8 + nCasterLvl;//Damage is at max
                }
                else
                {
                    nHP = EmpowerSpell(nHP, FEAT_HEALING_DOMAIN_POWER); //Damage/Healing is +50%
                }
                //Apply heal effect and VFX impact
                DelayCommand(fDelay, ApplyHealToObject(nHP, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_M), oTarget));
            }
        }
        //Get next target in the shape
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetSpellTargetLocation());
    }
    CreateNonStackingPersistentAoE(DURATION_TYPE_TEMPORARY, 38, GetLocation(OBJECT_SELF), 20.0, "null", "nw_s0_healcircc", "null", SPELL_HEALING_CIRCLE, OBJECT_SELF,
        GET_LAST_SPELL_CAST_CLASS, BLUEPRINT_STATIC_VFX, "Circle of Healing");
}

int GetIsHealerSpell()
{
    return GetIsHealer(OBJECT_SELF) && !GetIsObjectValid(GetSpellCastItem());
}
