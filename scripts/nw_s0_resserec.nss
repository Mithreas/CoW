#include "gs_inc_spell"
#include "inc_healer"
#include "mi_inc_class"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget = GetSpellTargetObject();
    int nSpell     = GetSpellId();

    //raise event
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));

    if(GetIsDead(oTarget))
    {
        ApplyResurrection(oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RAISE_DEAD), oTarget);
        ApplyEffectToObject(
            DURATION_TYPE_INSTANT,
            EffectLinkEffects(
                EffectVisualEffect(VFX_IMP_HEALING_X),
                EffectHeal(GetMaxHitPoints(oTarget) + 10)),
            oTarget);
    }
    else if(GetIsHealer(OBJECT_SELF) && GetIsPC(oTarget) && !GetIsObjectValid(GetSpellCastItem()))
    {
        ApplyLifeline(oTarget, 100);
    }

}

