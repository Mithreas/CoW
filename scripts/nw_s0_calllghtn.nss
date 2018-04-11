#include "inc_spells"
#include "inc_customspells"
#include "inc_warlock"
#include "inc_weather"

void main()
{
/* Warlock override code */
    object oItem = GetSpellCastItem();
    if (GetIsObjectValid(oItem) && GetTag(oItem) == TAG_WARLOCK_STAFF)
    {
      // This is a warlock casting the spell.  Override, override...
      object oCaster = OBJECT_SELF;

      // ASF.
      if (miWAArcaneSpellFailure(oCaster)) return;

      int nCasterLevel = miWAGetCasterLevel(oCaster) + 1; // +1 for rounding errors.
      int nDam;
      //Mord added, going to be called multiple times, might as well store it.
      effect eVisual = EffectVisualEffect(miWAGetImpactVFX(oCaster));
      //Damage Type too.
      int nDamType = miWAGetDamageType(oCaster);
      //DC too.
      int nDC =  miWAGetSpellDC(oCaster);

      //Get the spell target location as opposed to the spell target.
      location lTarget = GetSpellTargetLocation();

      // Apply casting VFX.
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                          EffectVisualEffect(miWAGetCastingVFX(oCaster)),
                          oCaster, 1.7);

      //Apply the fireball explosion at the location captured above.
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(miWAGetAreaVFX(oCaster)), lTarget);

      //Declare the spell shape, size and the location.  Capture the first target object in the shape.
      object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR);

      //Cycle through the targets within the spell shape until an invalid object is captured.
      while (GetIsObjectValid(oTarget))
      {

        if (gsSPGetIsAffected(GS_SP_TYPE_HARMFUL_SELECTIVE, OBJECT_SELF, oTarget))
        {
          SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_ELDRITCH_BLAST));

          if(!miWAResistSpell(oCaster, oTarget))
          {
            // Allow reflex save for half.
            nDam = d6(nCasterLevel / 2);

            if (GetLocalInt(GetModule(), "STATIC_LEVEL") && nCasterLevel > 9)
            {
              // FL override - damage goes up by 1 not 1d6 every 2 levels.
              nDam = d6(4) + (nCasterLevel/2 - 4);
            }

            nDam = AR_GetReflexAdjustedDamage(nDam,
                                           oTarget,
                                           nDC,
                                           SAVING_THROW_TYPE_ALL,
                                           oCaster);
            if (nDam > 0)
            {
              DelayCommand(0.0, ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                  EffectLinkEffects(eVisual, EffectDamage(nDam, nDamType)),
                                  oTarget));


              //Mord edit: The hostile status effect is now no longer applied if
              //no Damage is dealt due to reflex save
              DelayCommand(0.0, miWADoStatusEffect(nDamType, oTarget, oCaster));
            }

          }
        }
        else
        {
          miWADoStatusEffect(nDamType, oTarget, oCaster, TRUE);
        }

        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR);

      }

      return;
    }
/* End warlock override code */

    if (gsSPGetOverrideSpell()) return;

    object oTarget     = OBJECT_INVALID;
    location lLocation = GetSpellTargetLocation();
    effect eEffect;
    effect eVisual     = EffectVisualEffect(VFX_IMP_LIGHTNING_M);
    float fDelay       = 0.0;
    int nSpell         = GetSpellId();
    int nCasterLevel   = AR_GetCasterLevel(OBJECT_SELF);
    if (nCasterLevel > 10) nCasterLevel = 10;
    int nMetaMagic     = AR_GetMetaMagicFeat();
    int nDC            = AR_GetSpellSaveDC();
    int nValue         = 0;
    object oArea       = GetArea(OBJECT_SELF);

    int nDice = (GetWeather(oArea) == WEATHER_RAIN) ? 10 : 6;

    oTarget            = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLocation, TRUE, OBJECT_TYPE_SPELLTARGET);

    while (GetIsObjectValid(oTarget))
    {
        //affection check
        if (gsSPGetIsAffected(GS_SP_TYPE_HARMFUL_SELECTIVE, OBJECT_SELF, oTarget))
        {
            fDelay = gsSPGetRandomDelay();

            //raise event
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));

            //resistance check
            if (! gsSPResistSpell(OBJECT_SELF, oTarget, nSpell, fDelay))
            {
                nValue = gsSPGetDamage(nCasterLevel, nDice, nMetaMagic);

                //saving throw check
                nValue = AR_GetReflexAdjustedDamage(nValue, oTarget, nDC, SAVING_THROW_TYPE_ELECTRICITY);

                if (nValue > 0)
                {
                    //apply
                    eEffect = EffectLinkEffects(eVisual, EffectDamage(nValue, DAMAGE_TYPE_ELECTRICAL));

                    DelayCommand(fDelay, gsSPApplyEffect(oTarget, eEffect, nSpell));
                }
                else
                {
                    gsC2AdjustSpellEffectiveness(nSpell, oTarget, FALSE);
                }
            }
        }

        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLocation, TRUE, OBJECT_TYPE_SPELLTARGET);
    }

    // Update area weather - chance of causing a storm.
    if (!GetIsAreaInterior(oArea) &&
        GetIsAreaAboveGround(oArea))
    {
      Trace(WEATHER, "Call Lightning cast - seeing if it starts a storm.");
      SetSkyBox(SKYBOX_GRASS_STORM, oArea);
      miWHSetWeather(oArea);
    }
}
