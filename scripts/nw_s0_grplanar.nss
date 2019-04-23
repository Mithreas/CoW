//::///////////////////////////////////////////////
//:: Greater Planar Binding
//:: NW_S0_GrPlanar.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons an outsider dependant on alignment, or
    holds an outsider if the creature fails a save.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
//:://////////////////////////////////////////////
#include "inc_spells"
#include "inc_sumstream"
#include "nw_i0_spells"
#include "inc_customspells"

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
    int nMetaMagic = AR_GetMetaMagicFeat();
    int nCasterLevel = AR_GetCasterLevel(OBJECT_SELF);
    int nDuration = AR_GetCasterLevel(OBJECT_SELF);
    int nVFX = GetAlignmentBasedGateVFX();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZED);
    effect eDur3 = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);

    effect eLink = EffectLinkEffects(eDur, EffectParalyze());
    eLink = EffectLinkEffects(eLink, eDur2);
    eLink = EffectLinkEffects(eLink, eDur3);

    object oTarget = GetSpellTargetObject();
    int nRacial = GetRacialType(oTarget);
    //Check for metamagic extend
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;   //Duration is +100%
    }
    //Check to see if a valid target has been chosen
    if (GetIsObjectValid(oTarget))
    {
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_GREATER_PLANAR_BINDING));
            //Check for racial type
            int bPlayerOutsider = FALSE;
            if ( GetIsPC(oTarget) ) {
                string sSubRace = GetSubRace(oTarget);
                int nSubRace    = gsSUGetSubRaceByName(sSubRace);
                bPlayerOutsider = nSubRace == GS_SU_SPECIAL_IMP || nSubRace == GS_SU_SPECIAL_RAKSHASA;
            }

            if( nRacial == RACIAL_TYPE_OUTSIDER || bPlayerOutsider )
            {
                //Allow will save to negate hold effect
                if(!MySavingThrow(SAVING_THROW_WILL, oTarget, AR_GetSpellSaveDC()+5))
                {
                    //Apply the hold effect
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration/2));
                }
            }
        }
    }
    else
    {
        SummonFromStream(OBJECT_SELF, GetSpellTargetLocation(), TurnsToSeconds(nDuration), STREAM_TYPE_PLANAR, STREAM_PLANAR_TIER_4,
            nVFX, GetSummonVFXDelay(nVFX), FALSE, FALSE, gsWOGetDeityPlanarStream(OBJECT_SELF));
    }
}

