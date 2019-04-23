/*
  Spellsword Imbue Weapon Ability - Electric
*/

#include "inc_spellsword"
#include "x2_I0_SPELLS"
#include "inc_customspells"
#include "inc_spells"

//missile storm function
void ki_DoMissileStorm(int nD4Dice, int nCap, int nSpell, int nMIRV = VFX_IMP_MIRV, int nVIS = VFX_IMP_MAGBLUE, int nDAMAGETYPE = DAMAGE_TYPE_MAGICAL, int nONEHIT = FALSE, int nReflexSave = FALSE, int nSaveDC=100);

void main()
{
    int bFeedback = FALSE;

    //::  The item casting triggering this spellscript
    object oItem = GetSpellCastItem();
    //::  On a weapon: The one being hit. On an armor: The one hitting the armor
    object oSpellTarget = GetSpellTargetObject();
    //::  On a weapon: The one wielding the weapon. On an armor: The one wearing an armor
    object oSpellOrigin = OBJECT_SELF;
    //::  The DC oSpellTarget has to make or face the consequences!
    int nWizard = GetLevelByClass(CLASS_TYPE_WIZARD, oSpellOrigin);

    if(bFeedback) SendMessageToPC(oSpellOrigin, "SS_IM_W entered");

    int nSaveDC = GetLocalInt(gsPCGetCreatureHide(oSpellOrigin), "SS_IM_W_DC_ELEC");
    int nSpellGroup = 1 + (nSaveDC - (10 + nWizard))/2;
	int nTimer = GetLocalInt(gsPCGetCreatureHide(oSpellOrigin), "SS_IM_W_TM_ELEC") + 2*10;

    object oTargetPrimary   = GetSpellTargetObject();
    //object oTargetSecondary = OBJECT_INVALID;
    //object oTargetPrevious  = OBJECT_INVALID;
    location lLocation      = GetLocation(oTargetPrimary);
    //effect eEffect;
    //float fDelay            = 0.0;
    int nSpell              = 999;
    int nMaxTargets         = 1 + nSpellGroup;
    //int nDC                 = nSaveDC;
    //int nValue1             = d4(nWizard/5 + nSpellGroup); // damage
	int nDice				= nWizard/5 + nSpellGroup;
    //int nValue2             = nValue1; //0;
    //int nNth                = 0;

	if (gsTIGetActualTimestamp() > nTimer)
	{
		SetLocalInt(oSpellOrigin, "SS_IM_W_TM_ELEC", gsTIGetActualTimestamp());
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d4(nDice), DAMAGE_TYPE_ELECTRICAL), oTargetPrimary);
		//ki_DoMissileStorm(nDice, nMaxTargets, nSpell, VFX_IMP_MIRV_ELECTRIC, VFX_IMP_LIGHTNING_S, DAMAGE_TYPE_ELECTRICAL, TRUE, TRUE, nSaveDC);
	}


//    oTargetPrevious  = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLocation, TRUE, OBJECT_TYPE_CREATURE);
//    oTargetSecondary = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLocation, TRUE, OBJECT_TYPE_CREATURE);
//
//
//    while (GetIsObjectValid(oTargetSecondary) && spellsIsTarget(oTargetSecondary, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) &&
//           nNth < nMaxTargets)
//    {
//        //affection check
//        if (oTargetSecondary != oSpellOrigin)// &&
//            //gsSPGetIsAffected(GS_SP_TYPE_HARMFUL_SELECTIVE, OBJECT_SELF, oTargetSecondary))
//        {
//            fDelay          += 0.2;
//
//            //raise event
//            //SignalEvent(oTargetSecondary, EventSpellCastAt(OBJECT_SELF, nSpell));
//
//            //resistance check
//            if (!ReflexSave(oSpellTarget, nSaveDC, SAVING_THROW_TYPE_ELECTRICITY))
//            {
//                //apply
//                eEffect =
//                    EffectLinkEffects(
//                        EffectVisualEffect(VFX_IMP_LIGHTNING_S),
//                        EffectDamage(nValue2, DAMAGE_TYPE_ELECTRICAL));
//
//                DelayCommand(fDelay, gsSPApplyEffect(oTargetSecondary, eEffect, nSpell));
//            }
//
//            if (GetObjectType(oTargetSecondary) == OBJECT_TYPE_CREATURE) nNth++;
//
//            //beam effect
//            DelayCommand(
//                fDelay,
//                ApplyEffectToObject(
//                    DURATION_TYPE_TEMPORARY,
//                    EffectBeam(VFX_BEAM_LIGHTNING, oTargetPrevious, BODY_NODE_CHEST),
//                    oTargetSecondary,
//                    0.4));
//
//            oTargetPrevious  = oTargetSecondary;
//            fDelay          += 0.2;
//        }
//
//        oTargetSecondary = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLocation, TRUE, OBJECT_TYPE_SPELLTARGET);
//    }

    return;
}


//::///////////////////////////////////////////////
//:: ki_DoMissileStorm
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Fires a volley of missiles around the area
    of the object selected.

    Each missiles (nD4Dice)d4 damage.
    There are casterlevel missiles (to a cap as specified)
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Stolen By: Kirito
//:: Created On: July 31, 2002
//:://////////////////////////////////////////////
//:: Modified March 14 2003: Removed the option to hurt chests/doors
//::  was potentially causing bugs when no creature targets available.
//:: Modified December 6, 2017: added nSaveDC and set damage to D4
void ki_DoMissileStorm(int nD4Dice, int nCap, int nSpell, int nMIRV = VFX_IMP_MIRV, int nVIS = VFX_IMP_MAGBLUE, int nDAMAGETYPE = DAMAGE_TYPE_MAGICAL, int nONEHIT = FALSE, int nReflexSave = FALSE, int nSaveDC=100)
{
    object oTarget = OBJECT_INVALID;
//    int nCasterLvl = AR_GetCasterLevel(OBJECT_SELF);
//    int nDamage = 0;
    int nMetaMagic = AR_GetMetaMagicFeat();
    int nCnt = 1;
    effect eMissile = EffectVisualEffect(nMIRV);
    effect eVis = EffectVisualEffect(nVIS);
    float fDist = 0.0;
    float fDelay = 0.0;
    float fDelay2, fTime;
    location lTarget = GetSpellTargetLocation(); // missile spread centered around caster
    int nMissiles = nCap; //nCasterLvl;

    if (nMissiles > nCap)
    {
        nMissiles = nCap;
    }

        /* New Algorithm
            1. Count # of targets
            2. Determine number of missiles
            3. First target gets a missile and all Excess missiles
            4. Rest of targets (max nMissiles) get one missile
       */
    int nEnemies = 0;

    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget) )
    {
        // * caster cannot be harmed by this spell
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && (oTarget != OBJECT_SELF))
        {
            // GZ: You can only fire missiles on visible targets
            // If the firing object is a placeable (such as a projectile trap),
            // we skip the line of sight check as placeables can't "see" things.
            if ( ( GetObjectType(OBJECT_SELF) == OBJECT_TYPE_PLACEABLE ) ||
                   GetObjectSeen(oTarget,OBJECT_SELF))
            {
                nEnemies++;
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
     }

     if (nEnemies == 0) return; // * Exit if no enemies to hit
     int nExtraMissiles = nMissiles / nEnemies;

     // April 2003
     // * if more enemies than missiles, need to make sure that at least
     // * one missile will hit each of the enemies
     if (nExtraMissiles <= 0)
     {
        nExtraMissiles = 1;
     }

     // by default the Remainder will be 0 (if more than enough enemies for all the missiles)
     int nRemainder = 0;

     if (nExtraMissiles >0)
        nRemainder = nMissiles % nEnemies;

     if (nEnemies > nMissiles)
        nEnemies = nMissiles;

    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget) && nCnt <= nEnemies)
    {
        // * caster cannot be harmed by this spell
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) &&
           (oTarget != OBJECT_SELF) &&
           (( GetObjectType(OBJECT_SELF) == OBJECT_TYPE_PLACEABLE ) ||
           (GetObjectSeen(oTarget,OBJECT_SELF))))
        {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));

                // * recalculate appropriate distances
                fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
                fDelay = fDist/(3.0 * log(fDist) + 2.0);

                // Firebrand.
                // It means that once the target has taken damage this round from the
                // spell it won't take subsequent damage
                if (nONEHIT == TRUE)
                {
                    nExtraMissiles = 1;
                    nRemainder = 0;
                }

                int i = 0;
                for (i=1; i <= nExtraMissiles + nRemainder; i++)
        				{
					//Roll damage
					int nDam = d4(nD4Dice);

					// Jan. 29, 2004 - Jonathan Epp
					// Reflex save was not being calculated for Firebrand
     if (ReflexSave(oTarget, nSaveDC, SAVING_THROW_TYPE_ELECTRICITY))
     					{
					   nDam = 0;//AR_GetReflexAdjustedDamage(nDam, oTarget, nSaveDC, SAVING_THROW_TYPE_ELECTRICITY);
     					}

					fTime = fDelay;
					fDelay2 += 0.1;
					fTime += fDelay2;

					effect eDam = EffectDamage(nDam, nDAMAGETYPE);
					//Apply the MIRV and damage effect
					DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget));
					DelayCommand(fDelay2, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));
					DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
    				}
                nCnt++;// * increment count of missiles fired
                nRemainder = 0;
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }

}
