#include "ar_sys_poison"

/*
  Elemental Rime
  Initial       1d4 Dex, 40% vulnerability to fire, d12 Fire Damage
  Secondary     1d4 Con, 6 + d6 Fire Damage, d6 scalable with Assassin Level
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

        effect ePoi  = EffectLinkEffects( EffectAbilityDecrease(ABILITY_DEXTERITY, d4()), EffectDamageImmunityDecrease(DAMAGE_TYPE_FIRE, 40) );
               ePoi  = EffectLinkEffects( ePoi, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE) );
        effect eDmg  = EffectLinkEffects( EffectDamage(d12(), DAMAGE_TYPE_FIRE), EffectVisualEffect(VFX_IMP_FLAME_M) );


        arPONotifyTarget(oSpellTarget);

        //::  Tagged Poison Effect
        RemoveAndReapplyNEP(oSpellTarget);
        AssignCommand(oSpellTarget, _arPOStackPoisonPenalty(oSpellTarget, ePoi));
        DelayCommand(0.15, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oSpellTarget));
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


        int nLevel   = arPOGetClassDC(oSpellOrigin);
        effect eCon  = EffectAbilityDecrease(ABILITY_CONSTITUTION, d4());
        effect eDur  = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
        effect eDmg  = EffectLinkEffects( EffectDamage(6 + d6(nLevel), DAMAGE_TYPE_FIRE), EffectVisualEffect(VFX_IMP_FLAME_M) );


        arPONotifyTarget(oSpellTarget, TRUE, "");

        RemoveAndReapplyNEP(oSpellTarget);
        AssignCommand(oSpellTarget, _arPOStackPoisonPenalty(oSpellTarget, EffectLinkEffects(eDur, eCon)));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oSpellTarget);
    }
}
