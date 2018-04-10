//::///////////////////////////////////////////////
//:: Hold Animal
//:: S_HoldAnim
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
//:: Description: As hold person, except the spell
//:: affects an animal instead. Hold animal does not
//:: work on beasts, magical beasts, or vermin.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Soleski
//:: Created On:  Jan 18, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 10, 2001
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update on: 12/19/2010. By Mord. Spell is now mind affecting
#include "nw_i0_spells"
#include "mi_inc_spells"
#include "inc_spells"

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
    int nCasterLvl = AR_GetCasterLevel(OBJECT_SELF);
    int nMeta = AR_GetMetaMagicFeat();
    int nDuration = nCasterLvl;
    effect eParal = EffectParalyze();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZED);
    effect eDur3 = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);

    effect eLink = EffectLinkEffects(eDur2, eDur);
    eLink = EffectLinkEffects(eLink, eParal);
    eLink = EffectLinkEffects(eLink, eDur3);
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HOLD_ANIMAL));
        //Check racial type
        if (GetRacialType(oTarget) == RACIAL_TYPE_ANIMAL)
        {
            //Make SR check
            if (!MyResistSpell(OBJECT_SELF, oTarget))
            {
                //Make Will Save
                if (!MySavingThrow(SAVING_THROW_WILL, oTarget, AR_GetSpellSaveDC()+4, SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    //Check metamagic extend
                    if (nMeta == METAMAGIC_EXTEND)
                    {
                        nDuration = nDuration * 2;
                    }
                    //Apply paralyze and VFX impact
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
                }
            }
        }
    }
}
