//::///////////////////////////////////////////////
//:: [Harm]
//:: [NW_S0_Harm.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Reduces target to 1d4 HP on successful touch
//:: attack.  If the target is undead it is healed.
//:://////////////////////////////////////////////
//:: Created By: Keith Soleski
//:: Created On: Jan 18, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: Aug 1, 2001
//:: Last Update: Georg Zoeller On: Oct 10, 2004
//:://////////////////////////////////////////////

#include "nw_i0_spells"
#include "mi_inc_spells"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
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
    object oTarget = GetSpellTargetObject();
    if (GetObjectType(oTarget) == OBJECT_TYPE_DOOR) return;
    // Self Harm uses HD as the caster level
    int nCasterLevel = (GetSpellId() == 759) ? GetHitDice(OBJECT_SELF) + GetBonusHitDice(OBJECT_SELF) : AR_GetCasterLevel(OBJECT_SELF);
    int nDamage, nHeal;
    int nMetaMagic = AR_GetMetaMagicFeat();
    int nTouch = TouchAttackMelee(oTarget);
    effect eVis = EffectVisualEffect(246);
    effect eVis2 = EffectVisualEffect(VFX_IMP_HEALING_G);
    effect eHeal, eDam;
    int nMax = nCasterLevel * (GetKnowsFeat(FEAT_DEATH_DOMAIN_POWER, OBJECT_SELF) ? 15 : 10);

    //Check that the target is undead
    if ((GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD) || (gsSUGetSubRaceByName(GetSubRace(oTarget)) == GS_SU_SPECIAL_VAMPIRE))
    {
        //Figure out the amount of damage to heal
        nHeal = GetMaxHitPoints(oTarget) - GetCurrentHitPoints(oTarget);
        if (nHeal > nMax)
        {
          nHeal = nMax;
        }

        //Set the heal effect
        eHeal = EffectHeal(nHeal);
        //Apply heal effect and VFX impact
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HARM, FALSE));
    }
    else if (nTouch != FALSE)  //GZ: Fixed boolean check to work in NWScript. 1 or 2 are valid return numbers from TouchAttackMelee
    {
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HARM));
            if (!MyResistSpell(OBJECT_SELF, oTarget))
            {
                nDamage = GetCurrentHitPoints(oTarget) - d4(1);

                //Check for metamagic
                if (nMetaMagic == METAMAGIC_MAXIMIZE)
                {
                    nDamage = GetCurrentHitPoints(oTarget) - 1;
                }

                if (nDamage > nMax)
                {
                  nDamage = nMax;
                }

                eDam = EffectDamage(nDamage,DAMAGE_TYPE_NEGATIVE);
                //Apply the VFX impact and effects
                DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
    }
}
