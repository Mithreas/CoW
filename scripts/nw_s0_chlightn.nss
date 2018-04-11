#include "inc_spells"
#include "inc_warlock"
#include "inc_customspells"

void main()
{

    if (gsSPGetOverrideSpell()) return;

/* Warlock override code */
    object oItem = GetSpellCastItem();
    if (GetIsObjectValid(oItem) && GetTag(oItem) == TAG_WARLOCK_STAFF)
    {
      // This is a warlock casting the spell.  Override, override...
      object oTarget = GetSpellTargetObject();
      object oCaster = OBJECT_SELF;

      // ASF.
      if (miWAArcaneSpellFailure(oCaster)) return;

      int nCasterLevel = miWAGetCasterLevel(oCaster) + 1; // to round up
      int nDam;
      //int nDam = d6 (nCasterLevel / 2); Not used
      float fDelay = 0.2;
      //Might as well store it since it's used multiple times
      int nDamType = miWAGetDamageType(oCaster);
      int nBeam = miWAGetBeamVFX(oCaster);
      effect eIVis = EffectVisualEffect(miWAGetImpactVFX(oCaster));

      if(GetIsReactionTypeHostile(oTarget))
      {
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_ELDRITCH_BLAST));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            EffectVisualEffect(miWAGetCastingVFX(oCaster)),
                            oCaster, 1.7);

        // Roll to hit.
        if (!TouchAttackRanged(oTarget))
        {
          // Miss! Play miss effect.
          ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                              EffectBeam(nBeam, oCaster, BODY_NODE_HAND, TRUE),
                              oTarget, 1.7);
          return;
        }

        if(!miWAResistSpell(oCaster, oTarget))
        {
          nDam = d6(nCasterLevel / 2);

          if (GetLocalInt(GetModule(), "STATIC_LEVEL") && nCasterLevel > 9)
          {
            // FL override - damage goes up by 1 not 1d6 every 2 levels.
            nDam = d6(4) + (nCasterLevel/2 - 4);
          }

          ApplyEffectToObject(DURATION_TYPE_INSTANT,
                              EffectDamage(nDam, nDamType),
                              oTarget);

          ApplyEffectToObject(DURATION_TYPE_INSTANT,
                              eIVis,
                              oTarget);

          miWADoStatusEffect(nDamType, oTarget, oCaster);
        }

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            EffectBeam(nBeam, oCaster, BODY_NODE_HAND),
                            oTarget, 0.4);
      }
      else
      {
        miWADoStatusEffect(nDamType, oTarget, oCaster, TRUE);
      }


      // Next target - whether primary was friendly or hostile..
      object oTargetPrevious   = oTarget;
      location lLocation = GetLocation(oTarget);
      object oNextTarget  = GetFirstObjectInShape(SHAPE_SPHERE,
                                                  RADIUS_SIZE_COLOSSAL,
                                                  lLocation,
                                                  TRUE,
                                                  OBJECT_TYPE_CREATURE);
      while (GetIsObjectValid(oNextTarget))
      {
       if (oNextTarget != oTarget)
       {
        if(gsSPGetIsAffected(GS_SP_TYPE_HARMFUL_SELECTIVE, OBJECT_SELF, oNextTarget))
        {

          // Roll to hit.
          if (!TouchAttackRanged(oNextTarget))
          {
            // Miss! Play miss effect.
            DelayCommand(fDelay,
              ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                                  EffectBeam(nBeam, oTargetPrevious, BODY_NODE_CHEST, TRUE),
                                  oNextTarget, 1.7));
            return;
          }

          if(!miWAResistSpell(oCaster, oNextTarget))
          {
            nDam = d6(nCasterLevel / 2);

            if (GetLocalInt(GetModule(), "STATIC_LEVEL") && nCasterLevel > 9)
            {
              // FL override - damage goes up by 1 not 1d6 every 2 levels.
              nDam = d6(4) + (nCasterLevel/2 - 4);
            }

            DelayCommand(fDelay,
              ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                  EffectDamage(nDam, nDamType),
                                  oNextTarget));

            DelayCommand(fDelay,
              ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                  eIVis,
                                  oNextTarget));

            DelayCommand(fDelay,
              miWADoStatusEffect(nDamType, oNextTarget, oCaster));
          }
        }
        else
        {
          miWADoStatusEffect(nDamType, oNextTarget, oCaster, TRUE);
        }
       }

       DelayCommand(fDelay,
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                                EffectBeam(nBeam, oTargetPrevious, BODY_NODE_CHEST),
                                oNextTarget, 0.4));

       oTargetPrevious = oNextTarget;
       fDelay += 0.2;

       oNextTarget = GetNextObjectInShape(SHAPE_SPHERE,
                                          RADIUS_SIZE_COLOSSAL,
                                          lLocation,
                                          TRUE,
                                          OBJECT_TYPE_CREATURE);
      }


      return;
    }

/* End warlock override code */

    object oTargetPrimary   = GetSpellTargetObject();
    object oTargetSecondary = OBJECT_INVALID;
    object oTargetPrevious  = OBJECT_INVALID;
    location lLocation      = GetLocation(oTargetPrimary);
    effect eEffect;
    float fDelay            = 0.0;
    int nSpell              = GetSpellId();
    int nCasterLevel        = AR_GetCasterLevel(OBJECT_SELF);
    if (nCasterLevel > 20) nCasterLevel = 20;
    int nMetaMagic          = AR_GetMetaMagicFeat();
    int nDC                 = AR_GetSpellSaveDC();
    int nValue1             = gsSPGetDamage(nCasterLevel, 6, nMetaMagic);
    int nValue2             = 0;
    int nNth                = 0;

    //affection check
    if (gsSPGetIsAffected(GS_SP_TYPE_HARMFUL_SELECTIVE, OBJECT_SELF, oTargetPrimary))
    {
        //raise event
        SignalEvent(oTargetPrimary, EventSpellCastAt(OBJECT_SELF, nSpell));

        //resistance check
        if (! gsSPResistSpell(OBJECT_SELF, oTargetPrimary, nSpell))
        {
            nValue2 = AR_GetReflexAdjustedDamage(nValue1, oTargetPrimary, nDC, SAVING_THROW_TYPE_ELECTRICITY);

            if (nValue2 > 0)
            {
                //apply
                eEffect =
                    EffectLinkEffects(
                        EffectVisualEffect(VFX_IMP_LIGHTNING_S),
                        EffectDamage(nValue2, DAMAGE_TYPE_ELECTRICAL));

                gsSPApplyEffect(oTargetPrimary, eEffect, nSpell);
            }
            else
            {
                gsC2AdjustSpellEffectiveness(nSpell, oTargetPrimary, FALSE);
            }
        }
    }

    //beam effect
    ApplyEffectToObject(
        DURATION_TYPE_TEMPORARY,
        EffectBeam(VFX_BEAM_LIGHTNING, OBJECT_SELF, BODY_NODE_HAND),
        oTargetPrimary,
        0.4);

    oTargetPrevious   = oTargetPrimary;
    nValue1          /= 2;

    //secondary target
    oTargetSecondary  = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLocation, TRUE, OBJECT_TYPE_SPELLTARGET);

    while (GetIsObjectValid(oTargetSecondary) &&
           nNth < nCasterLevel)
    {
        //affection check
        if (oTargetSecondary != oTargetPrimary &&
            gsSPGetIsAffected(GS_SP_TYPE_HARMFUL_SELECTIVE, OBJECT_SELF, oTargetSecondary) &&
			!GetIsCorpse(oTargetSecondary))
        {
            fDelay          += 0.2;

            //raise event
            SignalEvent(oTargetSecondary, EventSpellCastAt(OBJECT_SELF, nSpell));

            //resistance check
            if (! gsSPResistSpell(OBJECT_SELF, oTargetSecondary, nSpell, fDelay))
            {
                nValue2 = AR_GetReflexAdjustedDamage(nValue1, oTargetSecondary, nDC, SAVING_THROW_TYPE_ELECTRICITY);

                if (nValue2 > 0)
                {
                    //apply
                    eEffect =
                        EffectLinkEffects(
                            EffectVisualEffect(VFX_IMP_LIGHTNING_S),
                            EffectDamage(nValue2, DAMAGE_TYPE_ELECTRICAL));

                    DelayCommand(fDelay, gsSPApplyEffect(oTargetSecondary, eEffect, nSpell));
                }
                else
                {
                    gsC2AdjustSpellEffectiveness(nSpell, oTargetSecondary, FALSE);
                }
            }

            if (GetObjectType(oTargetSecondary) == OBJECT_TYPE_CREATURE) nNth++;

            //beam effect
            DelayCommand(
                fDelay,
                ApplyEffectToObject(
                    DURATION_TYPE_TEMPORARY,
                    EffectBeam(VFX_BEAM_LIGHTNING, oTargetPrevious, BODY_NODE_CHEST),
                    oTargetSecondary,
                    0.4));

            oTargetPrevious  = oTargetSecondary;
            fDelay          += 0.2;
        }

        oTargetSecondary = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLocation, TRUE, OBJECT_TYPE_SPELLTARGET);
    }
}
