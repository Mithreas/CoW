//::///////////////////////////////////////////////
//:: Mass Heal
//:: [NW_S0_MasHeal.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Heals all friendly targets within 10ft to full
//:: unless they are undead.
//:: If undead they reduced to 1d4 HP.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 11, 2001
//:://////////////////////////////////////////////

#include "nw_i0_spells"
#include "inc_customspells"
#include "inc_healer"
#include "inc_class"

int GetIsHealerSpell();

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
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
  effect eKill;
  effect eVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
  effect eHeal;
  effect eStrike = EffectVisualEffect(VFX_FNF_LOS_HOLY_10);
  int nTouch, nModify, nDamage, nHeal;
  int nMetaMagic = AR_GetMetaMagicFeat();
  float fDelay;
  // Pure healers gain a scaling radius upward to twice that of the standard size at level 30.
  float fRadius = GetIsHealerSpell() ? RADIUS_SIZE_MEDIUM + RADIUS_SIZE_MEDIUM / 30 * GetHitDice(OBJECT_SELF) : RADIUS_SIZE_MEDIUM;
  location lLoc =  GetSpellTargetLocation();
  int nCasterLevel = AR_GetCasterLevel(OBJECT_SELF);

  if(nCasterLevel > 30)
    nCasterLevel = 30;

  int nMax = EmpowerSpell(150 + nCasterLevel * 5, FEAT_HEALING_DOMAIN_POWER);

  //Apply VFX area impact
  ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eStrike, lLoc);
  //Get first target in spell area
  object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lLoc);
  while(GetIsObjectValid(oTarget))
  {
      fDelay = GetRandomDelay();
      //Check to see if the target is an undead
      if ((GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD && !GetIsReactionTypeFriendly(oTarget)) || (gsSUGetSubRaceByName(GetSubRace(oTarget)) == GS_SU_SPECIAL_VAMPIRE))
      {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MASS_HEAL));
            //Make a touch attack
            nTouch = TouchAttackRanged(oTarget);
            if (nTouch > 0)
            {
                if (!GetIsReactionTypeFriendly(oTarget) || (gsSUGetSubRaceByName(GetSubRace(oTarget)) == GS_SU_SPECIAL_VAMPIRE))
                {
                    //Make an SR check
                    if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
                    {
                        //Roll damage
                        nModify = d4();
                        //make metamagic check
                        if (nMetaMagic == METAMAGIC_MAXIMIZE)
                        {
                            nModify = 1;
                        }
                        //Detemine the damage to inflict to the undead
                        nDamage =  GetCurrentHitPoints(oTarget) - nModify;
                        if(nDamage > nMax)
                            nDamage = nMax;
                        //Set the damage effect
                        eKill = EffectDamage(nDamage, DAMAGE_TYPE_POSITIVE);
                        //Apply the VFX impact and damage effect
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oTarget));
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    }
                 }
            }
      }
      else
      {
            //Make a faction check
            if(!GetIsEnemy(oTarget) && GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MASS_HEAL, FALSE));

                //Apply the VFX impact and heal effect
                DelayCommand(fDelay, ApplyHealToObject(nMax, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_G), oTarget));
            }
      }
      //Get next target in the spell area
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lLoc);
   }
}

int GetIsHealerSpell()
{
    return GetIsHealer(OBJECT_SELF) && !GetIsObjectValid(GetSpellCastItem());
}
