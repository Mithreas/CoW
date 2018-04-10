//::///////////////////////////////////////////////
//:: Lesser Planar Binding
//:: NW_S0_LsPlanar.nss
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
//:: VFX Pass By: Preston W, On: June 20, 2001
#include "inc_spells"
#include "inc_sumstream"
#include "mi_inc_spells"

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
    if(nDuration == 0)
    {
        nDuration = 1;
    }

    //Check for metamagic extend
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;   //Duration is +100%
    }
    //Check to see if the target is valid
    if (GetIsObjectValid(oTarget))
    {
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_LESSER_PLANAR_BINDING));
            //Check to make sure the target is an outsider
            int bPlayerOutsider = FALSE;
            if ( GetIsPC(oTarget) ) {
                string sSubRace = GetSubRace(oTarget);
                int nSubRace    = gsSUGetSubRaceByName(sSubRace);
                bPlayerOutsider = nSubRace == GS_SU_SPECIAL_IMP || nSubRace == GS_SU_SPECIAL_RAKSHASA;
            }

            if( nRacial == RACIAL_TYPE_OUTSIDER || bPlayerOutsider )
            {
                //Make a will save
                if(!WillSave(oTarget, AR_GetSpellSaveDC()))
                {
                    //Apply the linked effect
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration/2));
                }
            }
        }
    }
    else
    {
        SummonFromStream(OBJECT_SELF, GetSpellTargetLocation(), HoursToSeconds(nDuration), STREAM_TYPE_PLANAR, STREAM_PLANAR_TIER_2,
            nVFX, GetSummonVFXDelay(nVFX));
    }
}

