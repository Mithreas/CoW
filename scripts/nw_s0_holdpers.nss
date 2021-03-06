//::///////////////////////////////////////////////
//:: Hold Person
//:: NW_S0_HoldPers
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
//:: The target freezes in place, standing helpless.
//:: He is aware and breathes normally but cannot take any physical
//:: actions, even speech. He can, however, execute purely mental actions.
//:: winged creature that is held cannot flap its wings and falls.
//:: A swimmer can't swim and may drown.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Soleski
//:: Created On: Jan 18, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 10, 2001
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update on: 12/19/2010. By Mord. Spell is now mind affecting
#include "nw_i0_spells"
#include "inc_customspells"
#include "inc_warlock"
#include "inc_spells"

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
    object oTarget = GetSpellTargetObject();
    int nCasterLvl = AR_GetCasterLevel(OBJECT_SELF);
    int nMeta = AR_GetMetaMagicFeat();
    int nDuration = nCasterLvl;
    nDuration = GetScaledDuration(nDuration, oTarget);
    effect eParal = EffectParalyze();
    effect eVis = EffectVisualEffect(82);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZED);
    effect eDur3 = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);

    effect eLink = EffectLinkEffects(eDur2, eDur);
    eLink = EffectLinkEffects(eLink, eParal);
    eLink = EffectLinkEffects(eLink, eVis);
    eLink = EffectLinkEffects(eLink, eDur3);

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HOLD_PERSON));
        //Make sure the target is a humanoid
        if  ( gsSPGetIsHumanoid(oTarget) && !miSPGetIsPlayerNonHumanoid(oTarget) )
        {
            //Make SR Check
            if (miWADoWarlockAttack(OBJECT_SELF, oTarget, GetSpellId()))
            {
                //Make Will save
                if (!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, AR_GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    //Make metamagic extend check
                    if (nMeta == METAMAGIC_EXTEND)
                    {
                        nDuration = nDuration * 2;
                    }
                    //Apply paralyze effect and VFX impact
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
                }
            }
        }
    }
}
