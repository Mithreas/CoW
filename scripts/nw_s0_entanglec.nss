//::///////////////////////////////////////////////
//:: Entangle
//:: NW_S0_EntangleC.NSS
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the AOE the target must make
    a reflex save or be entangled by vegitation
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 30, 2001
//:://////////////////////////////////////////////
//::Updated Aug 14, 2003 Georg: removed some artifacts
#include "X0_I0_SPELLS"
#include "inc_customspells"
#include "inc_state"

int GetIsEntangled(object oCreature);

void main()
{

    //Declare major variables
    effect eHold = EffectEntangle();
    effect eEntangle = EffectVisualEffect(VFX_DUR_ENTANGLE);
    //Link Entangle and Hold effects
    effect eLink = EffectLinkEffects(eHold, eEntangle);
    object oCreator;
    int bValid;

    object oTarget = GetFirstInPersistentObject();

    while(GetIsObjectValid(oTarget))
    {  // SpawnScriptDebugger();
        if(!GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget) &&(GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL) != TRUE) )
        {
            if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ENTANGLE));
                //Make SR check
                if(!GetIsEntangled(oTarget))
                {
                    //if(!MyResistSpell(GetAreaOfEffectCreator(), oTarget))
                    //{
                        //Make reflex save
                        if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, GetSpellSaveDC()))
                        {
                           //Apply linked effects
                           ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2));
                        }
                    //}
                }
				
				if (!GetIsImmune(oTarget, IMMUNITY_TYPE_ENTANGLE)) gsSTAdjustState(GS_ST_STAMINA, -5.0f, oTarget);
            }
        }
        //Get next target in the AOE
        oTarget = GetNextInPersistentObject();
    }
}

int GetIsEntangled(object oCreature)
{
    effect eEffect = GetFirstEffect(oCreature);

    while(GetIsEffectValid(eEffect))
    {
        if(GetEffectType(eEffect) == EFFECT_TYPE_ENTANGLE && GetEffectSpellId(eEffect) == SPELL_ENTANGLE)
            return TRUE;
         eEffect = GetNextEffect(oCreature);
    }
    return FALSE;
}
