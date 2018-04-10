//::///////////////////////////////////////////////
//:: Strong Acid Splash Trap
//:: NW_T1_SplshStrC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Strikes the entering object with a blast of
    cold for 5d8 damage. Reflex save to take
    1/2 damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 16th , 2001
//:://////////////////////////////////////////////
#include "nw_i0_spells"

void main()
{
    if (GetTrapDetectedBy(OBJECT_SELF, GetEnteringObject()))
    {
      // Workaround to the "you triggered a trap" message you can't disable...
      SendMessageToPC(GetEnteringObject(), "...but you saw it, so were able to avoid it.");
      return;
    }
    //Declare major variables
    object oTarget = GetEnteringObject();
    int nDamage = d8(5);
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);

    nDamage = GetReflexAdjustedDamage(nDamage, oTarget, 17, SAVING_THROW_TYPE_TRAP);

    eDam = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}

