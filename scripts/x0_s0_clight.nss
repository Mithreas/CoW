#include "gs_inc_iprop"
#include "gs_inc_spell"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget = GetSpellTargetObject();
    int nSpell     = GetSpellId();

    //affection check
    if (! gsSPGetIsAffected(GS_SP_TYPE_BENEFICIAL_SELECTIVE, OBJECT_SELF, oTarget)) return;

    //raise event
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));

    //apply to item
    if (GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
    {
        if (gsIPGetIsValid(oTarget, ITEM_PROPERTY_LIGHT))
        {
            itemproperty ipProperty = ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_BRIGHT,
                                                        IP_CONST_LIGHTCOLOR_WHITE);
            gsIPAddItemProperty(oTarget, ipProperty, 86400.0, TRUE);
        }

        return;
    }

    //apply
    ApplyEffectToObject(
        DURATION_TYPE_PERMANENT,
        SupernaturalEffect(
            EffectLinkEffects(
                EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
                EffectVisualEffect(VFX_DUR_LIGHT_WHITE_20))),
        oTarget);
}



