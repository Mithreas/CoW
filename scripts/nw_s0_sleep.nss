//::///////////////////////////////////////////////
//:: Sleep
//:: NW_S0_Sleep
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Sleeps 1d4+CL hit dice of enemy creatures for 
	3 rounds + 1 per CL.
	
	If CL < 4 CL is treated as 4.
	
	Max hit dice affected is the CL of the caster 
	(changed from default 5). 
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: March 7 , 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: VFX Pass By: Preston W, On: June 25, 2001

#include "X0_I0_SPELLS"
#include "inc_spells"
#include "inc_customspells"
#include "inc_warlock"

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
    object oTarget = GetSpellTargetObject();
    object oLowest;
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
    effect eSleep =  EffectSleep();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_SLEEP);
    int nCasterLevel = AR_GetCasterLevel(OBJECT_SELF);
	
	if (nCasterLevel < 4) nCasterLevel = 4;

    effect eLink = EffectLinkEffects(eSleep, eMind);
    eLink = EffectLinkEffects(eLink, eDur);

     // * Moved the linking for the ZZZZs into the later code
     // * so that they won't appear if creature immune

    int bContinueLoop;
    int nHD = nCasterLevel + d4();
    int nMetaMagic = AR_GetMetaMagicFeat();
    int nCurrentHD;
    int bAlreadyAffected;
    int nMax = nCasterLevel;// maximum hd creature affected
    int nLow;
    int nDuration = AR_GetCasterLevel(OBJECT_SELF);
    int nScaledDuration;
    nDuration = 3 + nDuration;
		
	if (GetIsObjectValid(oTarget) && !GetIsReactionTypeFriendly(oTarget))
	{
	  if (!miWADoWarlockAttack(OBJECT_SELF, oTarget, GetSpellId())) return; 
	}

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
    string sSpellLocal = "BIOWARE_SPELL_LOCAL_SLEEP_" + ObjectToString(OBJECT_SELF);
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
        nHD = nCasterLevel + 4;//Damage is at max
    }
    if (nMetaMagic == METAMAGIC_EMPOWER)
    {
        nHD = nHD + (nHD/2); //Damage/Healing is +50%
    }
    else if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;   //Duration is +100%
    }
    nDuration += 2;
    //Get the first target in the spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetSpellTargetLocation());
    //If no valid targets exists ignore the loop
    if (GetIsObjectValid(oTarget))
    {
        bContinueLoop = TRUE;
    }
    // The above checks to see if there is at least one valid target.
    while ((nHD > 0) && (bContinueLoop))
    {
        nLow = nMax;
        bContinueLoop = FALSE;
        //Get the first creature in the spell area
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetSpellTargetLocation());
        while (GetIsObjectValid(oTarget))
        {
            //Make faction check to ignore allies
            if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)
                && GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT && GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
            {
                //Get the local variable off the target and determined if the spell has already checked them.
                bAlreadyAffected = GetLocalInt(oTarget, sSpellLocal);
                if (!bAlreadyAffected)
                {
                     //Get the current HD of the target creature
                     nCurrentHD = GetHitDice(oTarget);
                     //Check to see if the HD are lower than the current Lowest HD stored and that the
                     //HD of the monster are lower than the number of HD left to use up.
                     if(nCurrentHD < nLow && nCurrentHD <= nHD && nCurrentHD <= nMax)
                     {
                         nLow = nCurrentHD;
                         oLowest = oTarget;
                         bContinueLoop = TRUE;
                     }
                }
            }
            //Get the next target in the shape
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
        }
        //Check to see if oLowest returned a valid object
        if(oLowest != OBJECT_INVALID)
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oLowest, EventSpellCastAt(OBJECT_SELF, SPELL_SLEEP));
            //Make SR check
            if (!MyResistSpell(OBJECT_SELF, oLowest))
            {
                //Make Fort save
                if(!MySavingThrow(SAVING_THROW_WILL, oLowest, AR_GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oLowest);
                    if (GetIsImmune(oLowest, IMMUNITY_TYPE_SLEEP) == FALSE)
                    {
                        effect eLink2 = EffectLinkEffects(eLink, eVis);
                        nScaledDuration = GetScaledDuration(nDuration, oLowest);
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oLowest, RoundsToSeconds(nScaledDuration));
                    }
                    else
                    // * even though I am immune apply just the sleep effect for the immunity message
                    {
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSleep, oLowest, RoundsToSeconds(nDuration));
                    }

                }
            }
        }
        //Set a local int to make sure the creature is not used twice in the pass.  Destroy that variable in
        //.3 seconds to remove it from the creature
        SetLocalInt(oLowest, sSpellLocal, TRUE);
        DelayCommand(0.5, SetLocalInt(oLowest, sSpellLocal, FALSE));
        DelayCommand(0.5, DeleteLocalInt(oLowest, sSpellLocal));
        //Remove the HD of the creature from the total
        nHD = nHD - GetHitDice(oLowest);
        oLowest = OBJECT_INVALID;
    }
}
