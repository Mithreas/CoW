//::///////////////////////////////////////////////
//:: Aura of Fear On Enter
//:: NW_S1_DragFearA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the aura of the creature the player
    must make a will save or be struck with fear because
    of the creatures presence.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 25, 2001
//:: LastUpdated: 24, Oct 2003, GeorgZ
//:://////////////////////////////////////////////

#include "nw_i0_spells"
#include "inc_generic"
#include "inc_math"
#include "inc_statuseffect"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();

    int nHD = GetHitDice(GetAreaOfEffectCreator()) + GetBonusHitDice(GetAreaOfEffectCreator());
    int nIntensity = GetLocalInt(GetAreaOfEffectCreator(), "AURA_LESSER_FEAR") ? INTENSITY_STANDARD_SCALING : INTENSITY_STANDARD;

    int nDC =     GetDragonFearDC(nHD);//10 + GetHitDice(GetAreaOfEffectCreator())/3;

    int nDuration = GetScaledDuration(nHD, oTarget);
    //--------------------------------------------------------------------------
    // Capping at 20
    //--------------------------------------------------------------------------
    if (nDuration > 20)
    {
        nDuration = 20;
    }

    if(GetIsEnemy(oTarget, GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELLABILITY_AURA_FEAR));
        //Make a saving throw check
        if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR))
        {
            ApplyFear(oTarget, nIntensity, RoundsToSeconds(nDuration));
        }
    }
}
