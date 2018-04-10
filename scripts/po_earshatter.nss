#include "ar_sys_poison"

/*
  Ear Shatter
  Initial       100% vulnerability to Sonic, d10 Sonic Damage, Deaf 2 Rounds
  Secondary     d8 + d6 Sonic Damage, d6 scalable with Assassin Level
  DC            16
*/

void secondaryEffect();

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

    //::  Initial Effect
    if( !arPOGetIsPoisoned(oSpellTarget) &&
        !MySavingThrow(SAVING_THROW_FORT, oSpellTarget, nDC, SAVING_THROW_TYPE_POISON) &&
        !GetIsImmune(oSpellTarget, IMMUNITY_TYPE_POISON) ) {

        effect ePoi  = EffectDamageImmunityDecrease(DAMAGE_TYPE_SONIC, 100);
               ePoi  = EffectLinkEffects( ePoi, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE) );
        effect eDmg  = EffectLinkEffects( EffectDamage(d10(), DAMAGE_TYPE_SONIC), EffectVisualEffect(VFX_IMP_BLIND_DEAF_M) );
        effect eDeaf = EffectLinkEffects( EffectDeaf(), EffectVisualEffect(VFX_IMP_HEAD_SONIC) );

        arPONotifyTarget(oSpellTarget);

        //::  Tagged Poison Effect
        ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, ePoi, oSpellTarget, 0.0, EFFECT_TAG_POISON);

        DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oSpellTarget));
        DelayCommand(0.15, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeaf, oSpellTarget, RoundsToSeconds(2)));
        DelayCommand(60.0, secondaryEffect());
    }
}

void secondaryEffect() {
    object oItem        = GetSpellCastItem();
    object oSpellTarget = GetSpellTargetObject();
    object oSpellOrigin = OBJECT_SELF;
    int nDC             = arPOGetPoisonDC(oItem) + arPOGetClassDC(oSpellOrigin);

    if ( arPOGetIsPoisoned(oSpellTarget) && !MySavingThrow(SAVING_THROW_FORT, oSpellTarget, nDC, SAVING_THROW_TYPE_POISON) && !GetIsImmune(oSpellTarget, IMMUNITY_TYPE_POISON) ) {
        int nLevel = arPOGetClassDC(oSpellOrigin);
        if (nLevel < 1) nLevel = 1;

        effect eDmg  = EffectLinkEffects( EffectDamage(d8() + d6(nLevel), DAMAGE_TYPE_SONIC), EffectVisualEffect(VFX_IMP_BLIND_DEAF_M) );

        arPONotifyTarget(oSpellTarget, TRUE, "");
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oSpellTarget);
    }
}
