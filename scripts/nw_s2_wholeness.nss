//::///////////////////////////////////////////////
//:: Wholeness of Body
//:: NW_S2_Wholeness
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The monk is able to heal twice his level in HP
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 14, 2001
//:://////////////////////////////////////////////
#include "inc_state"
#include "inc_worship"

void main()
{
    if(GetIsTimelocked(OBJECT_SELF, "Wholeness of Body"))
    {
        TimelockErrorMessage(OBJECT_SELF, "Wholeness of Body");
        return;
    }
	
    //Declare major variables
    int nLevel = GetLevelByClass(CLASS_TYPE_MONK, OBJECT_SELF) * 2;
    effect eHeal = EffectHeal(nLevel);
    effect eVis = EffectVisualEffect(VFX_IMP_HEALING_M);
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_WHOLENESS_OF_BODY, FALSE));
    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, OBJECT_SELF);
	
	// Stamina, timelock and restore ability.
	gsSTDoCasterDamage(OBJECT_SELF, 5);
    SetTimelock(OBJECT_SELF, 5 * 60, "Wholeness of Body", 180, 60);
    IncrementRemainingFeatUses(OBJECT_SELF, FEAT_WHOLENESS_OF_BODY);
	if (gsWOGetAspect(gsWOGetDeityByName(GetDeity(OBJECT_SELF))) & ASPECT_HEARTH_HOME) gsSTAdjustState(GS_ST_PIETY, 0.5);
}