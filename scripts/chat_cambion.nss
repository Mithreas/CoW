#include "inc_chat"
#include "inc_pc"
#include "x3_inc_string"
#include "inc_effect"

void main()
{

  string params = GetStringLowerCase(chatGetParams(OBJECT_SELF));

  if (gsSUGetSubRaceByName(GetSubRace(OBJECT_SELF)) != GS_SU_SPECIAL_CAMBION) {

    SendMessageToPC(OBJECT_SELF, StringToRGBString("You are not a Cambion!", STRING_COLOR_RED));

  } else {

    chatVerifyCommand(OBJECT_SELF);

    object oHide = gsPCGetCreatureHide(OBJECT_SELF);
       
    // check for situation where shape changing is not allowed first

    // dead?
    if (GetIsDead(OBJECT_SELF) || GetCurrentHitPoints(OBJECT_SELF) <= 0) return;
    // werewolf?
    if (GetCreatureTailType(OBJECT_SELF) == 485) return;


    int iCurrentAppearance = GetAppearanceType(OBJECT_SELF);    
    int iNaturalAppearance = GetLocalInt(oHide, "GVD_NATURAL_APPEARANCE") - 1;
    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);

    ClearAllActions();
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);

    // on first use, store natural appearance on PC Hide
    if (iNaturalAppearance <= 0) {
      // store +1 since Dwarves are 0
      SetLocalInt(oHide, "GVD_NATURAL_APPEARANCE", iCurrentAppearance + 1);
      iNaturalAppearance = iCurrentAppearance;
    }

    // if current is not natural appearance, shift back to natural and be done
    if (iCurrentAppearance != iNaturalAppearance) {
          
      // remove shape effects
      RemoveTaggedEffects(OBJECT_SELF, EFFECT_TAG_MAJORAWARD);

      SetCreatureAppearanceType(OBJECT_SELF, iNaturalAppearance);
      SendMessageToPC(OBJECT_SELF, "You've turned into your natural shape");

    } else {
      // change into one of the different Cambion shapes based on level
      int iLevel = GetHitDice(OBJECT_SELF);

      effect eDamRed;
      effect eSpellResistance;
      effect eRegeneration;
      effect eFireImmunity;
      effect eImmunePoison = EffectImmunity(IMMUNITY_TYPE_POISON);
      effect eLink;

      if (iLevel < 10) {
        // imp
        eDamRed = EffectDamageReduction(5, DAMAGE_POWER_PLUS_ONE);
        eSpellResistance = EffectSpellResistanceIncrease(10);
        eRegeneration = EffectRegenerate(1, 6.0);
        eFireImmunity = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 25);

        SetCreatureAppearanceType(OBJECT_SELF, APPEARANCE_TYPE_IMP);

        SendMessageToPC(OBJECT_SELF, "You've turned into an Imp");

      } else if (iLevel < 20) {
        // osyluth
        eDamRed = EffectDamageReduction(10, DAMAGE_POWER_PLUS_TWO);
        eRegeneration = EffectRegenerate(3, 6.0);
        eSpellResistance = EffectSpellResistanceIncrease(20);
        eFireImmunity = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 50);

        SetCreatureAppearanceType(OBJECT_SELF, APPEARANCE_TYPE_GOLEM_BONE);

        SendMessageToPC(OBJECT_SELF, "You've turned into an Osyluth");

      } else {
        // pit fiend
        eDamRed = EffectDamageReduction(15, DAMAGE_POWER_PLUS_THREE);
        eSpellResistance = EffectSpellResistanceIncrease(32);
        eRegeneration = EffectRegenerate(5, 6.0);
        eFireImmunity = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 100);

        SetCreatureAppearanceType(OBJECT_SELF, APPEARANCE_TYPE_DEVIL);

        SendMessageToPC(OBJECT_SELF, "You've turned into a Pit Fiend");

      }

      // link effects and apply
      eLink = EffectLinkEffects(eImmunePoison, eDamRed);
      eLink = EffectLinkEffects(eSpellResistance, eLink);
      eLink = EffectLinkEffects(eRegeneration, eLink);
      eLink = EffectLinkEffects(eFireImmunity, eLink);
      ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, eLink, OBJECT_SELF, 0.0, EFFECT_TAG_MAJORAWARD);

    }
        
  }

}
