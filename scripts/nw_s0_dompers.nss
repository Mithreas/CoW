//::///////////////////////////////////////////////
//:: [Dominate Person]
//:: [NW_S0_DomPers.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save or the target is dominated for 1 round
//:: per caster level.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 29, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 6, 2001
//:: Last Updated By: Preston Watamaniuk, On: April 10, 2001
//:: VFX Pass By: Preston W, On: June 20, 2001
#include "inc_spells"
#include "mi_inc_spells"
#include "mi_inc_warlock"
#include "nw_i0_spells"

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
    effect eDom = EffectDominated();
    eDom = GetScaledEffect(eDom, oTarget);
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    //Link duration effects
    effect eLink = EffectLinkEffects(eMind, eDom);
    eLink = EffectLinkEffects(eLink, eDur);

    effect eVis = EffectVisualEffect(VFX_IMP_DOMINATE_S);
    int nMetaMagic = AR_GetMetaMagicFeat();
    int nCasterLevel = AR_GetCasterLevel(OBJECT_SELF);
    int nDuration = 2 + nCasterLevel/3;
    nDuration = GetScaledDuration(nDuration, oTarget);
    int nDC =  AR_GetSpellSaveDC();

    object oItem = GetSpellCastItem();
    if (GetIsObjectValid(oItem) && GetTag(oItem) == TAG_WARLOCK_STAFF)
    {
      object oCaster = OBJECT_SELF;
      nDuration = miWAGetCasterLevel(oCaster);
      nDC = miWAGetSpellDC(oCaster) + GetSpellDCModifiers(oCaster, SPELL_SCHOOL_ENCHANTMENT);
    }


    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DOMINATE_PERSON, FALSE));
    //Make sure the target is a humanoid
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        if  ( gsSPGetIsHumanoid(oTarget) && !miSPGetIsPlayerNonHumanoid(oTarget) )
        {
           //Make SR Check
           if (!MyResistSpell(OBJECT_SELF, oTarget))
           {
                //Make Will Save
                if (!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, 1.0))
                {
                    //Check for metamagic extension
                    if (nMetaMagic == METAMAGIC_EXTEND)
                    {
                        nDuration = nDuration * 2;
                    }
                    //Apply linked effects and VFX impact
                    DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration)));
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
            }
        }
    }
}
