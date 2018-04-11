#include "ar_sys_poison"

/*
  Poison Cave Terror
  Initial       Confusion 2 Rounds
  Secondary     Confusion 1 Round/Level
  DC            20
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

    //::  Lets do something mean!
    if( !arPOGetIsPoisoned(oSpellTarget) && !MySavingThrow(SAVING_THROW_FORT, oSpellTarget, nDC, SAVING_THROW_TYPE_POISON) && !GetIsImmune(oSpellTarget, IMMUNITY_TYPE_POISON) ) {
        //::  Initial is Mind-Affecting
        if ( !GetIsImmune(oSpellTarget, IMMUNITY_TYPE_MIND_SPELLS) ) {
            effect eDurLink = EffectLinkEffects( EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED), EffectConfused() );
            effect eLink    = EffectLinkEffects( EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE), eDurLink );

            arPONotifyTarget(oSpellTarget);

            //::  Tagged Poison Effect
            ApplyTaggedEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE), oSpellTarget, 65.0, EFFECT_TAG_POISON);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oSpellTarget, RoundsToSeconds(2));

            DelayCommand(60.0, secondaryEffect());
        }
    }
}

void secondaryEffect() {
    object oItem        = GetSpellCastItem();
    object oSpellTarget = GetSpellTargetObject();
    object oSpellOrigin = OBJECT_SELF;
    int nDC             = arPOGetPoisonDC(oItem) + arPOGetClassDC(oSpellOrigin);

    if ( arPOGetIsPoisoned(oSpellTarget) && !MySavingThrow(SAVING_THROW_FORT, oSpellTarget, nDC, SAVING_THROW_TYPE_POISON) && !GetIsImmune(oSpellTarget, IMMUNITY_TYPE_POISON) ) {
        if ( !GetIsImmune(oSpellTarget, IMMUNITY_TYPE_MIND_SPELLS) ) {
            effect eDurLink = EffectLinkEffects( EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED), EffectConfused() );
            effect eLink    = EffectLinkEffects( EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE), eDurLink );
            int nLevel      = GetHitDice(oSpellOrigin);

            arPONotifyTarget(oSpellTarget, TRUE, "");

            ApplyTaggedEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE), oSpellTarget, RoundsToSeconds(nLevel), EFFECT_TAG_POISON);
        }
    }
}
