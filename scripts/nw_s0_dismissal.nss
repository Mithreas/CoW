//::///////////////////////////////////////////////
//:: Dismissal
//:: NW_S0_Dismissal.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All summoned creatures within 30ft of caster
    make a save and SR check or be banished
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 22, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001

#include "gs_inc_flag"
#include "X0_I0_SPELLS"
#include "inc_customspells"
#include "inc_warlock"
#include "inc_statuseffect"
#include "inc_spells"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check inc_customspells.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook
    object oTarget = GetSpellTargetObject();
    if (GetIsObjectValid(oTarget) && !GetIsReactionTypeFriendly(oTarget))
    {
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DISMISSAL));
      if (!miWADoWarlockAttack(OBJECT_SELF, oTarget, GetSpellId())) return;
    }

    // Set the area no-summon flag for 30s.
    gsFLTemporarilySetAreaFlag("OVERRIDE_SUMMONS", 30, OBJECT_SELF, TRUE, "Summon warding");

    //Declare major variables
    object oMaster;
    effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_EVIL_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
    int nSpellDC;
    int nCasterLevel = AR_GetCasterLevel(OBJECT_SELF);
    //Get the first object in the are of effect
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetSpellTargetLocation());
    while(GetIsObjectValid(oTarget))
    {
        //does the creature have a master.
        oMaster = GetMaster(oTarget);
        //Is that master valid and is he an enemy
        if(GetIsObjectValid(oMaster) && spellsIsTarget(oMaster,SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF ))
        {
            //Is the creature a summoned associate
            if(GetAssociate(ASSOCIATE_TYPE_SUMMONED, oMaster) == oTarget ||
               GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oMaster) == oTarget ||
               GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oMaster) == oTarget )
            {
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DISMISSAL));
                //Determine correct save
                nSpellDC = AR_GetSpellSaveDC() + 6;
                //Make SR and will save checks
                if (!MyResistSpell(OBJECT_SELF, oTarget) && !MySavingThrow(SAVING_THROW_WILL, oTarget, nSpellDC))
                {
                     //Apply the VFX and delay the destruction of the summoned monster so
                     //that the script and VFX can play.
                     ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                     DestroyObject(oTarget, 0.5);
                }
            }
        }
        //::  For player Outsiders
        else if ( GetIsPC(oTarget) && !GetIsReactionTypeFriendly(oTarget) ) {
            int nSubRace        = gsSUGetSubRaceByName(GetSubRace(oTarget));
            int bPlayerOutsider = nSubRace == GS_SU_SPECIAL_IMP || nSubRace == GS_SU_SPECIAL_RAKSHASA;

            //::  Imps & Rakshasa
            if (bPlayerOutsider) {
                nSpellDC = AR_GetSpellSaveDC() + 3;
                //Make SR and will save checks
                if (!MyResistSpell(OBJECT_SELF, oTarget) && !MySavingThrow(SAVING_THROW_WILL, oTarget, nSpellDC))
                {
                     ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                     ApplyFear(oTarget, 8, RoundsToSeconds(nCasterLevel/2));
                }
            }

            // Planetouched
            int bPlaneTouched = nSubRace == GS_SU_PLANETOUCHED_AASIMAR || nSubRace == GS_SU_PLANETOUCHED_TIEFLING;
            if (bPlaneTouched) {
                nSpellDC = AR_GetSpellSaveDC();

                // Debuffs don't stack
                if (GetHasSpellEffect(SPELL_DISMISSAL, oTarget) == TRUE)
                {
                    RemoveSpellEffects(SPELL_DISMISSAL, OBJECT_SELF, oTarget);
                }

                if (!MyResistSpell(OBJECT_SELF, oTarget) && !MySavingThrow(SAVING_THROW_WILL, oTarget, nSpellDC))
                {
                    if (!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, OBJECT_SELF))
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oTarget, 12.0);
                }

                // Start building the linked effects for the debuff.
                effect eLink;
                eLink = EffectLinkEffects(eLink, EffectAttackDecrease(1));
                eLink = EffectLinkEffects(eLink, EffectSavingThrowDecrease(SAVING_THROW_ALL, 1));
                eLink = EffectLinkEffects(eLink, EffectACDecrease(1));
                eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));

                // Apply debuff and visual effect
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nCasterLevel));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_ODD), oTarget);
            }
        }

        //Get next creature in the shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }
}
