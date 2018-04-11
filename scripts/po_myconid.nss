#include "ar_sys_poison"

/*
  Poison Myconid Rot
  Causes Burrow Maggots & 2 + d6 + Assassin Level/2 Acid Damage, Fort DC 20
*/

void main()
{
    //::  The item casting triggering this spellscript
    object oItem = GetSpellCastItem();
    //::  On a weapon: The one being hit. On an armor: The one hitting the armor
    object oSpellTarget = GetSpellTargetObject();
    //::  On a weapon: The one wielding the weapon. On an armor: The one wearing an armor
    object oSpellOrigin = OBJECT_SELF;
    //::  The DC oSpellTarget has to make or face the consequences!
    int nDC = arPOGetPoisonDC(oItem) + arPOGetClassDC(oSpellOrigin);

    //::  Lets do something mean!
    if( !arPOGetIsPoisoned(oSpellTarget) && !MySavingThrow(SAVING_THROW_FORT, oSpellTarget, nDC, SAVING_THROW_TYPE_POISON) && !GetIsImmune(oSpellTarget, IMMUNITY_TYPE_POISON) ) {
        int nLevel      = arPOGetClassDC(oSpellOrigin);
        effect eDisease = EffectDisease(DISEASE_BURROW_MAGGOTS);
        effect eDmg     = EffectDamage(2 + d6() + nLevel/2, DAMAGE_TYPE_ACID);
        effect eVis     = EffectVisualEffect(VFX_IMP_POISON_L);

        //::  Damage
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectLinkEffects(eVis, eDmg), oSpellTarget);

        //::  Burrow Maggots
        RemoveAndReapplyNEP(oSpellTarget);
        DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDisease, oSpellTarget));
    }
}
