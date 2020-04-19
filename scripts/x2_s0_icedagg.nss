//::///////////////////////////////////////////////
//:: Ice Dagger
//:: X2_S0_IceDagg
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// You create a dagger shapped piece of ice that
// flies toward the target and deals 1d4 points of
// cold damage per level (maximum od 5d4)
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 25 , 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs, 02/06/2003

#include "nw_i0_spells"    
#include "inc_customspells" 
#include "inc_spells"

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
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLvl = AR_GetCasterLevel(oCaster);
    int nMetaMagic = AR_GetMetaMagicFeat();
    int nDamage;
    float fDelay;
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
    effect eDam;
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();
    //Limit Caster level for the purposes of damage
    if (nCasterLvl > 5)
    {
        nCasterLvl = 5;
    }
	if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_EVOCATION, OBJECT_SELF)) nCasterLvl += 2;
    if(!GetIsReactionTypeFriendly(oTarget))
   	{
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        //Get the distance between the explosion and the target to calculate delay
        fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
        if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
   	    {
            //Roll damage for each target
            nDamage = d4(nCasterLvl);
            //Resolve metamagic
       	    if (nMetaMagic == METAMAGIC_MAXIMIZE)
            {
                nDamage = 4 * nCasterLvl;
            }
   	        else if (nMetaMagic == METAMAGIC_EMPOWER)
            {
                nDamage = nDamage + nDamage / 2;
            }
            //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
            nDamage = AR_GetReflexAdjustedDamage(nDamage, oTarget, AR_GetSpellSaveDC(), SAVING_THROW_TYPE_COLD);
            //Set the damage effect
            eDam = EffectDamage(nDamage, DAMAGE_TYPE_COLD);
            if(nDamage > 0)
            {
                // Apply effects to the currently selected target.
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                //This visual effect is applied to the target object not the location as above.  This visual effect
                //represents the flame that erupts on the target not on the ground.
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
        }
    }
}

