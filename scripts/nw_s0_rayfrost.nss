//::///////////////////////////////////////////////
//:: Ray of Frost
//:: [NW_S0_RayFrost.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
    If the caster succeeds at a ranged touch attack
    the target takes 1d4 damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: feb 4, 2001
//:://////////////////////////////////////////////
//:: Bug Fix: Andrew Nobbs, April 17, 2003
//:: Notes: Took out ranged attack roll.
//:://////////////////////////////////////////////

#include "mi_inc_warlock"
#include "nw_i0_spells"
#include "mi_inc_spells"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check mi_inc_spells.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

/* Warlock override code */
    object oItem = GetSpellCastItem();
    if (GetIsObjectValid(oItem) && GetTag(oItem) == TAG_WARLOCK_STAFF)
    {
      // This is a warlock casting the spell.  Override, override...
      object oTarget = GetSpellTargetObject();
      object oCaster = OBJECT_SELF;

      // ASF.
      if (miWAArcaneSpellFailure(oCaster)) return;

      int nCasterLevel = miWAGetCasterLevel(oCaster) + 1; // for rounding errors
      int nDam = d6 (nCasterLevel / 2);

      if (GetLocalInt(GetModule(), "STATIC_LEVEL") && nCasterLevel > 9)
      {
        // FL override - damage goes up by 1 not 1d6 every 2 levels.
        nDam = d6(4) + (nCasterLevel/2 - 4);
      }

      if(!GetIsReactionTypeFriendly(oTarget))
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
                              EffectBeam(miWAGetBeamVFX(oCaster), oCaster, BODY_NODE_HAND, TRUE),
                              oTarget, 1.7);
          return;
        }

        if(!miWAResistSpell(oCaster, oTarget))
        {
          ApplyEffectToObject(DURATION_TYPE_INSTANT,
                              EffectDamage(nDam, miWAGetDamageType(oCaster)),
                              oTarget);

          ApplyEffectToObject(DURATION_TYPE_INSTANT,
                              EffectVisualEffect(miWAGetImpactVFX(oCaster)),
                              oTarget);

          miWADoStatusEffect(miWAGetDamageType(oCaster), oTarget, oCaster);
        }
      }
      else
      {
        miWADoStatusEffect(miWAGetDamageType(oCaster), oTarget, oCaster, TRUE);
      }

      ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                          EffectBeam(miWAGetBeamVFX(oCaster), oCaster, BODY_NODE_HAND),
                          oTarget, 1.7);

      return;
    }
/* End warlock override code */

    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = AR_GetMetaMagicFeat();
    int nCasterLevel = AR_GetCasterLevel(OBJECT_SELF);
    int nDam = d4(1) + 1;
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
    effect eRay = EffectBeam(VFX_BEAM_COLD, OBJECT_SELF, BODY_NODE_HAND);

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RAY_OF_FROST));
        eRay = EffectBeam(VFX_BEAM_COLD, OBJECT_SELF, BODY_NODE_HAND);
        //Make SR Check
        if(!MyResistSpell(OBJECT_SELF, oTarget))
        {
            //Enter Metamagic conditions
            if (nMetaMagic == METAMAGIC_MAXIMIZE)
            {
                nDam = 5 ;//Damage is at max
            }
            else if (nMetaMagic == METAMAGIC_EMPOWER)
            {
                nDam = nDam + nDam/2; //Damage/Healing is +50%
            }
            //Set damage effect
            eDam = EffectDamage(nDam, DAMAGE_TYPE_COLD);
            //Apply the VFX impact and damage effect
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
        }
    }
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7);
}
