// Second Wind feat for Fighters.
#include "inc_timelock"
#include "inc_state"

void main()
{
	int  nFighter = GetLevelByClass(CLASS_TYPE_FIGHTER);

    if(GetIsTimelocked(OBJECT_SELF, "Second Wind"))
    {
        TimelockErrorMessage(OBJECT_SELF, "Second Wind");
        return;
    }
	
    int nHP = 10 * nFighter;
	
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectLinkEffects(EffectHeal(nHP), EffectVisualEffect(VFX_IMP_HEAD_HEAL)), OBJECT_SELF);
	gsSTDoCasterDamage(OBJECT_SELF, nHP);
    SetTimelock(OBJECT_SELF, 15 * 60, "Second Wind", 600, 60);
}