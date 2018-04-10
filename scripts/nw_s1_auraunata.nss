//::///////////////////////////////////////////////
//:: Aura of the Unnatural On Enter
//:: NW_S1_AuraMencA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the aura all animals are struck with
    fear.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 25, 2001
//:://////////////////////////////////////////////

#include "nw_i0_spells"
#include "inc_generic"
#include "inc_math"
#include "inc_statuseffect"

void main()
{
    object oTarget = GetEnteringObject();
    int nHD = GetHitDice(GetAreaOfEffectCreator()) + GetBonusHitDice(GetAreaOfEffectCreator());
    int nIntensity = GetLocalInt(GetAreaOfEffectCreator(), "AURA_LESSER_FEAR") ? INTENSITY_STANDARD_SCALING : INTENSITY_STANDARD;

    int nDuration = GetHitDice(GetAreaOfEffectCreator());
    int nRacial = GetRacialType(oTarget);
    int nDC = nHD /3;

    if(GetIsEnemy(oTarget))
    {
        nDuration = (nDuration / 3) + 1;
        //Make a saving throw check
        if(nRacial == RACIAL_TYPE_ANIMAL)
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELLABILITY_AURA_UNNATURAL));
            if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR))
            {
                //Apply the VFX impact and effects
                ApplyFear(oTarget, nIntensity, RoundsToSeconds(nDuration));
            }
        }
    }
}
