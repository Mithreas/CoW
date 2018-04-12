/*
    Random Polymorph AoE Spell
    Will randomly Polymorph on HB
*/

#include "inc_spellmatrix"
#include "inc_spells"

void main()
{
    object oCaster  = GetAreaOfEffectCreator();
    object oTarget  = GetFirstInPersistentObject();
    int nDC         = ar_GetCustomSpellDC(oCaster, SPELL_SCHOOL_EVOCATION, 5);
    float nDuration = RoundsToSeconds(2);

    effect eSpellVFX = EffectVisualEffect(VFX_IMP_POLYMORPH);
    effect ePoly;

    switch (d6()) {
        case 1:
        ePoly = EffectPolymorphEx(POLYMORPH_TYPE_CHICKEN, TRUE, oTarget);
        break;
        case 2:
        ePoly = EffectPolymorphEx(POLYMORPH_TYPE_PIXIE, TRUE, oTarget);
        break;
        case 3:
        ePoly = EffectPolymorphEx(POLYMORPH_TYPE_BADGER, TRUE, oTarget);
        break;
        case 4:
        ePoly = EffectPolymorphEx(POLYMORPH_TYPE_ZOMBIE, TRUE, oTarget);
        break;
        case 5:
        ePoly = EffectPolymorphEx(POLYMORPH_TYPE_PENGUIN, TRUE, oTarget);
        break;
        case 6:
        ePoly = EffectPolymorphEx(POLYMORPH_TYPE_COW, TRUE, oTarget);
        break;
    }


    while(GetIsObjectValid(oTarget))
    {
        if ( !ar_GetSpellImmune(oCaster, oTarget) ) {
            if ( !MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NONE, GetAreaOfEffectCreator()) ) {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectLinkEffects(eSpellVFX, ePoly), oTarget, nDuration);
            }
        }

        oTarget = GetNextInPersistentObject();
    }
}
