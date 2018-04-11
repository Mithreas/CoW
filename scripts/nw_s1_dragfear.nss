//::///////////////////////////////////////////////
//:: Dragon Breath Fear
//:: NW_S1_DragFear
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Calculates the proper DC Save for the
    breath weapon based on the HD of the dragon.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 9, 2001
//:://////////////////////////////////////////////

#include "inc_statuseffect"
#include "nw_i0_spells"
#include "x0_i0_spells"

void main()
{
    //Declare major variables
    int nAge = GetHitDice(OBJECT_SELF) + GetBonusHitDice(OBJECT_SELF);
    int nIntensity = GetLocalInt(OBJECT_SELF, "AURA_LESSER_FEAR") ? INTENSITY_STANDARD_SCALING : INTENSITY_STANDARD;
    int nCount;
    int nDC = GetDragonFearDC(nAge);
    float fDelay;
    object oTarget;

    int nDuration = GetScaledDuration(nAge, oTarget);
    //--------------------------------------------------------------------------
    // Capping at 20
    //--------------------------------------------------------------------------
    if (nDuration > 20)
    {
        nDuration = 20;
    }

    PlayDragonBattleCry();
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 14.0, GetSpellTargetLocation(), TRUE);
    //Get first target in spell area
    while(GetIsObjectValid(oTarget))
    {
        if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget,SPELL_TARGET_SELECTIVEHOSTILE,OBJECT_SELF))
        {
            nCount = GetScaledDuration(GetHitDice(OBJECT_SELF), oTarget);
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_DRAGON_BREATH_FEAR));
            //Determine the effect delay time
            fDelay = GetDistanceBetween(oTarget, OBJECT_SELF)/20;
            //Make a saving throw check
            if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR, OBJECT_SELF, fDelay))
            {
                ApplyFear(oTarget, nIntensity, RoundsToSeconds(nDuration));
            }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 14.0, GetSpellTargetLocation(), TRUE);
    }
}


