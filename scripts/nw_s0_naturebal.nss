//::///////////////////////////////////////////////
//:: Natures Balance
//:: NW_S0_NatureBal.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Reduces the SR of all enemies by 1d4 per 5 caster
    levels for 1 round per 3 caster levels. Also heals
    all friends for 3d8 + Caster Level
    Radius is 15 feet from the caster.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: June 22, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: ActionReplay, 24/03/2017

/*
    Applies a Lesser Spell breach on targets in the AoE
    Greater Breach with Focuses
*/
#include "inc_spells"
#include "X0_I0_SPELLS"
#include "inc_customspells"

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
    effect eHeal;
    effect eVis = EffectVisualEffect(VFX_IMP_HEALING_L);
    effect eSR;
    effect eVis2 = EffectVisualEffect(VFX_IMP_BREACH);
    effect eNature = EffectVisualEffect(VFX_FNF_NATURES_BALANCE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    int nRand, nNumDice;
    int nCasterLevel = AR_GetCasterLevel(OBJECT_SELF);
    //Determine spell duration as an integer for later conversion to Rounds, Turns or Hours.
    int nDuration = nCasterLevel/3;
    int nMetaMagic = AR_GetMetaMagicFeat();
    float fDelay;
    //Set off fire and forget visual
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eNature, GetLocation(OBJECT_SELF));
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;   //Duration is +100%
    }

    nNumDice = nCasterLevel / 5;
    if(nNumDice == 0)
    {
        nNumDice = 1;
    }




    //::  Increase AOE Size with Focuses and Breach Strength
    int nBreachTotal    = 2;
    int nBreachSR       = 3;
    float fAOESize      = RADIUS_SIZE_LARGE;

    if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION, OBJECT_SELF)) {             //::  Epic
        fAOESize = RADIUS_SIZE_GARGANTUAN;
        nBreachTotal    = 3;
        nBreachSR       = 5;
    }
    else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION, OBJECT_SELF)) {     //::  Greater
        fAOESize = RADIUS_SIZE_HUGE;
        nBreachTotal    = 3;
        nBreachSR       = 4;
    }

    //Cycle through the targets within the spell shape until an invalid object is captured.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fAOESize, GetLocation(OBJECT_SELF), FALSE);
    while(GetIsObjectValid(oTarget))
    {
        fDelay = GetRandomDelay();
        //Check to see how the caster feels about the targeted object
        if(!GetIsEnemy(oTarget))
        {
              //Fire cast spell at event for the specified target
              SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NATURES_BALANCE, FALSE));
              nRand = d8(3) + nCasterLevel;
              //Enter Metamagic conditions
              if (nMetaMagic == METAMAGIC_MAXIMIZE)
              {
                 nRand = 24 + nCasterLevel;//Damage is at max
              }
              else if (nMetaMagic == METAMAGIC_EMPOWER)
              {
                 nRand = nRand + nRand/2; //Damage/Healing is +50%
              }
              eHeal = EffectHeal(nRand);
              //Apply heal effects
              DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget));
              DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        }
        else if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NATURES_BALANCE));
            if(!GetIsReactionTypeFriendly(oTarget))
            {
                //Check for saving throw
                if (!MySavingThrow(SAVING_THROW_WILL, oTarget, AR_GetSpellSaveDC()))
                {
                      nRand = d4(nNumDice);
                      //Enter Metamagic conditions
                      if (nMetaMagic == METAMAGIC_MAXIMIZE)
                      {
                         nRand = 4 * nNumDice;//Damage is at max
                      }
                      else if (nMetaMagic == METAMAGIC_EMPOWER)
                      {
                         nRand = nRand + (nRand/2); //Damage/Healing is +50%
                      }
                      eSR = EffectSpellResistanceDecrease(nRand);
                      effect eLink = EffectLinkEffects(eSR, eDur);
                      //Apply reduce SR effects
                      DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration)));
                      DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
                }

                //:: Lesser Spell breach always applied
                DelayCommand(fDelay, DoSpellBreach(oTarget, nBreachTotal, nBreachSR, SPELL_LESSER_SPELL_BREACH));
            }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fAOESize, GetLocation(OBJECT_SELF), FALSE);
    }
}

