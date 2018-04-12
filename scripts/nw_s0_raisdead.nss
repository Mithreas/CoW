#include "inc_spell"
#include "inc_healer"
#include "inc_class"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget = GetSpellTargetObject();
    int nSpell     = GetSpellId();

    //raise event
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));

    //apply
    if(GetIsDead(oTarget))
    {
        ApplyResurrection(oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RAISE_DEAD), oTarget);
    }
    else if(GetIsHealer(OBJECT_SELF) && GetIsPC(oTarget) && !GetIsObjectValid(GetSpellCastItem()))
    {
        ApplyLifeline(oTarget);
    }
}

