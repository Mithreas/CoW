#include "ar_sys_poison"

/*
  Eyeblast
  Initial       Blindness 3 Rounds
  Secondary     Blindness 1 Round/Level (Level of Poisoner)
  DC            22
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

        effect eDurLink = EffectLinkEffects( EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE), EffectBlindness() );

        arPONotifyTarget(oSpellTarget);

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDurLink, oSpellTarget, RoundsToSeconds(5));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BLIND_DEAF_M), oSpellTarget);

        //::  Tagged Poison Effect
        ApplyTaggedEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE), oSpellTarget, 65.0, EFFECT_TAG_POISON);

        DelayCommand(60.0, secondaryEffect());
    }
}

void secondaryEffect() {
    object oItem        = GetSpellCastItem();
    object oSpellTarget = GetSpellTargetObject();
    object oSpellOrigin = OBJECT_SELF;
    int nDC             = arPOGetPoisonDC(oItem) + arPOGetClassDC(oSpellOrigin);

    if ( !GetIsDead(oSpellTarget) && arPOGetIsPoisoned(oSpellTarget) &&
         !MySavingThrow(SAVING_THROW_FORT, oSpellTarget, nDC, SAVING_THROW_TYPE_POISON) &&
         !GetIsImmune(oSpellTarget, IMMUNITY_TYPE_POISON) ) {

        effect eDurLink = EffectLinkEffects( EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE), EffectBlindness() );
        int nLevel = GetHitDice(oSpellOrigin);

        arPONotifyTarget(oSpellTarget, TRUE, "");

        ApplyTaggedEffectToObject(DURATION_TYPE_TEMPORARY, eDurLink, oSpellTarget, RoundsToSeconds(nLevel), EFFECT_TAG_POISON);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BLIND_DEAF_M), oSpellTarget);
    }
}
