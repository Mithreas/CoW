//::///////////////////////////////////////////////
//:: Bolt: Confuse
//:: NW_S1_BltConf
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creature must make a ranged touch attack to hit
    the intended target.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 11 , 2001
//:: Updated On: July 15, 2003 Georg Zoeller - Removed saving throws
//:://////////////////////////////////////////////

#include "nw_i0_spells"
void main()
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nHD = GetHitDice(OBJECT_SELF);
    effect eVis2 = EffectVisualEffect(VFX_IMP_CONFUSION_S);
    effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    effect eBolt = EffectConfused();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eBolt, eDur);
    eLink = EffectLinkEffects(eLink, eVis);
    int nDC = 10 + (nHD/2);
    int nCount = (nHD + 1) / 2;

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_BOLT_CONFUSE));
    //Make a saving throw check
    if (TouchAttackRanged(oTarget))
    {
        if ( GetLocalInt(OBJECT_SELF, "AR_USE_SAVE") ) { //::  AR: If creature is flagged with "AR_USE_SAVE" a DC will apply as well.
            if ( MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS) != 0 ) {
                return;
            }
        }

       //Apply the VFX impact and effects
       ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nCount));
       ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
    }
}
