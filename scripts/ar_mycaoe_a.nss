/*
    Myconid Death AoE
    Will damage targets if entering the AoE, Fort Save.
*/

#include "ar_spellmatrix"

void main()
{
    object oCaster  = GetAreaOfEffectCreator();
    object oTarget  = GetEnteringObject();
    int nDC         = 10 + GetHitDice(oCaster) / 2;
    int nDmg        = d6(2);

    effect eSpellVFX = EffectVisualEffect(VFX_IMP_ACID_S);
    effect eDamage   = EffectDamage(nDmg, DAMAGE_TYPE_ACID);

    if ( GetIsReactionTypeHostile(oTarget) && !MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_POISON, GetAreaOfEffectCreator()) ) {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectLinkEffects(eSpellVFX, eDamage), oTarget);
    }
}
