//::///////////////////////////////////////////////
//:: Cloud of Bewilderment
//:: X2_S0_CldBewldC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    A cone of noxious air goes forth from the caster.
    Enemies in the area of effect are stunned and blinded
    1d6 rounds. Foritude save negates effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: November 04, 2002
//:://////////////////////////////////////////////

#include "nw_i0_spells"
#include "x0_i0_spells"
#include "inc_customspells"

void main()
{

    //Declare major variables
    int nRounds;
    effect eBlind;

    effect eVis = EffectVisualEffect(VFX_DUR_BLIND);
    effect eFind;
    object oTarget;
    object oCreator;
    float fDelay;

    //--------------------------------------------------------------------------
    // GZ 2003-Oct-15
    // When the caster is no longer there, all functions calling
    // GetAreaOfEffectCreator will fail. Its better to remove the barrier then
    //--------------------------------------------------------------------------
    if (!GetIsObjectValid(GetAreaOfEffectCreator()))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }


    //Get the first object in the persistant area
    oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CLOUD_OF_BEWILDERMENT));
            //Make a SR check
            if(!MyResistSpell(GetAreaOfEffectCreator(), oTarget))
            {
                if (!GetHasSpellEffect(SPELL_CLOUD_OF_BEWILDERMENT,oTarget))
                {
					nRounds = d6(1);
					fDelay = GetRandomDelay(0.75, 1.75);
					//Apply the VFX impact and linked effects
					eBlind = AnemoiEffectBlindness(oTarget);
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oTarget, RoundsToSeconds(nRounds)));
 
                }
            }
        }
        //Get next target in spell area
        oTarget = GetNextInPersistentObject();
    }
}
