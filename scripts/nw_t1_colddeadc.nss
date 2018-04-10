//::///////////////////////////////////////////////
//:: Deadly Frost Trap
//:: NW_T1_ColdDeadC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Strikes the entering object with a blast of
    cold for 8d4 damage. Fortitude save to avoid
    being paralyzed for 4 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 16th , 2001
//:://////////////////////////////////////////////
#include "nw_i0_spells"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();
    effect eDam = EffectDamage(d4(8), DAMAGE_TYPE_COLD);
    effect eParal = EffectParalyze();
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
    effect eFreeze = EffectVisualEffect(VFX_DUR_BLUR);
    effect eLink = EffectLinkEffects(eParal, eFreeze);
    if (GetTrapDetectedBy(OBJECT_SELF, oTarget))
    {
      // Workaround to the "you triggered a trap" message you can't disable...
      SendMessageToPC(oTarget, "...but you saw it, so were able to avoid it.");
      return;
    }

    if(!MySavingThrow(SAVING_THROW_FORT,oTarget, 15, SAVING_THROW_TYPE_TRAP))
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(4));
    }

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}

