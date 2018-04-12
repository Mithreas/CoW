//::///////////////////////////////////////////////
//:: Mind Fog: On Enter
//:: NW_S0_MindFogA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a bank of fog that lowers the Will save
    of all creatures within who fail a Will Save by
    -10.  Affect lasts for 2d6 rounds after leaving
    the fog
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 1, 2001
//:://////////////////////////////////////////////

//#include "X0_I0_SPELLS"
#include "inc_customspells"
#include "inc_warlock"
void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();
    effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    // effect eLower = EffectSavingThrowDecrease(SAVING_THROW_WILL, 10);
    effect eLink;
    int bValid = FALSE;
    float fDelay = GetRandomDelay(1.0, 2.2);
    object oCaster = GetAreaOfEffectCreator();
    int nWillDamage = d6(2);



    if (gsSPGetIsAffected(GS_SP_TYPE_HARMFUL_SELECTIVE, oCaster, oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MIND_FOG));

        //Make SR check
        effect eAOE = GetFirstEffect(oTarget);
        if(GetHasSpellEffect(SPELL_MIND_FOG, oTarget))
        {
            while (GetIsEffectValid(eAOE))
            {
                //If the effect was created by the Mind_Fog then remove it
                if (GetEffectSpellId(eAOE) == SPELL_MIND_FOG && oCaster == GetEffectCreator(eAOE))
                {
                    if(GetEffectType(eAOE) == EFFECT_TYPE_SAVING_THROW_DECREASE)
                    {
                        RemoveEffect(oTarget, eAOE);
                        bValid = TRUE;
                    }
                }
                //Get the next effect on the creation
                eAOE = GetNextEffect(oTarget);
            }
        //Check if the effect has been put on the creature already.  If no, then save again
        //If yes, apply without a save.
        }
        if(bValid == FALSE)
        {
            if(!(miWAGetIsWarlock(oCaster) ? miWAResistSpell(oCaster, oTarget) : MyResistSpell(oCaster, oTarget)))
            {
                if(!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oCaster))
                {
                    if(MySavingThrow(SAVING_THROW_WILL, 
					                 oTarget, 
									 miWAGetIsWarlock(oCaster) ? miWAGetSpellDC(oCaster) + GetSpellDCModifiers(oCaster, SPELL_SCHOOL_ENCHANTMENT) : GetSpellSaveDC(), 
									 SAVING_THROW_TYPE_MIND_SPELLS))
                    {
                        nWillDamage /= 2;
                    }
                    else
                    {
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDazed(), oTarget, RoundsToSeconds(1)));
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DAZED_S), oTarget));
                    }
                    SetLocalInt(oTarget, "SP_MIND_FOG_DMG", nWillDamage);
                    eLink = EffectLinkEffects(eVis, EffectSavingThrowDecrease(SAVING_THROW_WILL, nWillDamage));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget));
                }
            }
        }
        else
        {
            if ( GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oCaster) == FALSE )
            {
                //Apply VFX impact and lowered save effect
                eLink = EffectLinkEffects(eVis, EffectSavingThrowDecrease(SAVING_THROW_WILL, GetLocalInt(oTarget, "SP_MIND_FOG_DMG")));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
            }
        }
    }
}
