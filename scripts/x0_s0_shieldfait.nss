//::///////////////////////////////////////////////
//:: Shield of Faith
//:: x0_s0_ShieldFait.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
 +2 deflection AC bonus, +1 every 6 levels (max +5)
 Duration: 1 turn/level
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: September 6, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:
#include "nw_i0_spells"

#include "mi_inc_spells" 

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
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
    int nMetaMagic = AR_GetMetaMagicFeat();
    int nCasterLvl = AR_GetCasterLevel(OBJECT_SELF);
    
    int nValue = 2 + (nCasterLvl)/6;
    if (nValue > 5)
     nValue = 5; // * Max of 5
    
    effect eAC = EffectACIncrease(nValue, AC_DEFLECTION_BONUS);

    effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR);
    effect eLink = EffectLinkEffects(eAC, eDur);

    int nDuration = AR_GetCasterLevel(OBJECT_SELF); // * Duration 1 turn/level
     if (nMetaMagic == METAMAGIC_EXTEND)	//Duration is +100%
    {
         nDuration = nDuration * 2;
    }

    //Fire spell cast at event for target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 421, FALSE));
    //Apply VFX impact and bonus effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));

}
