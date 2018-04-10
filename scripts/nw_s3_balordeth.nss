#include "nw_i0_spells"

void main()
{
    location lLocation = GetLocation(OBJECT_SELF);
    effect eVisual     = EffectVisualEffect(VFX_IMP_FLAME_M);
    effect eEffect     = EffectVisualEffect(VFX_FNF_FIREBALL);
    float fDelay       = 0.0;
    int nType          = OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE;
    int nDamage        = 0;

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eEffect, lLocation);

    object oObject = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLocation, TRUE, nType);

    while (GetIsObjectValid(oObject))
    {
        SignalEvent(oObject, EventSpellCastAt(OBJECT_SELF, SPELL_FIREBALL));

        fDelay = GetDistanceBetweenLocations(lLocation, GetLocation(oObject)) / 20.0;

        if (! MyResistSpell(OBJECT_SELF, oObject, fDelay))
        {
            nDamage = GetReflexAdjustedDamage(50, oObject, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE);

            if(nDamage > 0)
            {
                eEffect = EffectLinkEffects(eVisual, EffectDamage(nDamage, DAMAGE_TYPE_FIRE));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oObject));
            }
        }

        oObject = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLocation, TRUE, nType);
    }

    ExecuteScript("gs_ai_death", OBJECT_SELF);
}

