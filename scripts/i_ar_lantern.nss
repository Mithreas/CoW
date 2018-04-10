#include "ar_spellmatrix"

void main()
{
    object oActivator  = GetItemActivator();
    //object oTarget     = GetItemActivatedTarget();
    //location lLocation = GetItemActivatedTargetLocation();

    effect eSpellVFX   = EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION);
    effect eEff1       = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);

    location lTarget   = GetLocation(oActivator);

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSpellVFX, lTarget);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eEff1, lTarget);
    DelayCommand(4.0, _arSummonDemon("ar_djinni", lTarget));
}
