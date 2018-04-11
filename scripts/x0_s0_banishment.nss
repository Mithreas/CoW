//::///////////////////////////////////////////////
//:: Banishment
//:: x0_s0_banishment.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All summoned creatures within 30ft of caster
    make a save and SR check or be banished
    + As well any Outsiders being must make a
    save and SR check or be banished (up to
    2 HD creatures / level can be banished)
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 22, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001

#include "gs_inc_flag"
#include "X0_I0_SPELLS"
#include "inc_spells"
#include "inc_customspells"
#include "inc_xfer"


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


    //Declare major variables
    object oMaster;
    effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_EVIL_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
    int nSpellDC;
    //Get the first object in the are of effect
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetSpellTargetLocation());

    // * the pool is the number of hit dice of creatures that can be banished
    int nPool = 2* AR_GetCasterLevel(OBJECT_SELF);

    // Set the area no-summon flag for 60s.
    gsFLTemporarilySetAreaFlag("OVERRIDE_SUMMONS", 60, OBJECT_SELF, TRUE, "Summon warding");

    while(GetIsObjectValid(oTarget))
    {
        //does the creature have a master.
        oMaster = GetMaster(oTarget);
        if (oMaster == OBJECT_INVALID)
        {
            oMaster = OBJECT_SELF;  // TO prevent problems with invalid objects
                                    // passed into GetAssociate
        }

        // * BK: Removed the master check, only applys to Dismissal not banishment
        //Is that master valid and is he an enemy
       // if(GetIsObjectValid(oMaster) && GetIsEnemy(oMaster))
        {
            // * Is the creature a summoned associate
            // * or is the creature an outsider
            // * and is there enough points in the pool
            if(
               (GetAssociate(ASSOCIATE_TYPE_SUMMONED, oMaster) == oTarget ||
               GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oMaster) == oTarget ||
               GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oMaster) == oTarget ) ||
               (GetRacialType((oTarget)) == RACIAL_TYPE_OUTSIDER) ||
               (GetRacialType((oTarget)) == RACIAL_TYPE_ELEMENTAL) &&
               (nPool > 0)
               )
            {
                // * March 2003. Added a check so that 'friendlies' will not be
                // * unsummoned.
                if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
                {
                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 430));
                    //Determine correct save
                    nSpellDC = AR_GetSpellSaveDC();// + 6;
                    // * Must be enough points in the pool to destroy target
                    if (nPool >= GetHitDice(oTarget))
                    // * Make SR and will save checks
                    if (!MyResistSpell(OBJECT_SELF, oTarget) && !MySavingThrow(SAVING_THROW_WILL, oTarget, nSpellDC))
                    {
                         //Apply the VFX and delay the destruction of the summoned monster so
                         //that the script and VFX can play.

                         nPool = nPool - GetHitDice(oTarget);
                         ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));
                         if (CanCreatureBeDestroyed(oTarget) == TRUE)
                         {
                            //bugfix: Simply destroying the object won't fire it's OnDeath script.
                            //Which is bad when you have plot-specific things being done in that
                            //OnDeath script... so lets kill it.
                            effect eKill = EffectDamage(GetCurrentHitPoints(oTarget));
                            //just to be extra-sure... :)
                            effect eDeath = EffectDeath(FALSE, FALSE);
                            DelayCommand(0.25, ApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oTarget));
                            DelayCommand(0.25, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));

                            DestroyObject(oTarget, 0.3);
                         }
                    }
                } // rep check
            }
            //::  Player Outsiders, Caster unaffected.
            else if ( GetIsPC(oTarget) && !GetIsReactionTypeFriendly(oTarget) && oTarget != OBJECT_SELF) {
                int nSubRace        = gsSUGetSubRaceByName(GetSubRace(oTarget));
                int bPlayerOutsider = nSubRace == GS_SU_SPECIAL_IMP;

                //::  Imps
                if (bPlayerOutsider && nPool >= GetHitDice(oTarget) ) {
                    nSpellDC = AR_GetSpellSaveDC();

                    if (!MyResistSpell(OBJECT_SELF, oTarget) && !MySavingThrow(SAVING_THROW_WILL, oTarget, nSpellDC))
                    {
                        nPool = nPool - GetHitDice(oTarget);
                        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_GATE), GetLocation(oTarget));

                        //::  Port to Baator
                        miXFDoPortal(oTarget, SERVER_UNDERDARK, "MI_TARGET_C_HOOF");
                    }
                }

                //:: Planetouched
                int bPlaneTouched = nSubRace == GS_SU_PLANETOUCHED_AASIMAR || nSubRace  == GS_SU_PLANETOUCHED_TIEFLING;
                if (bPlaneTouched) {
                    nSpellDC = AR_GetSpellSaveDC();

                    // Debuffs don't stack
                    if (GetHasSpellEffect(SPELL_BANISHMENT, oTarget) == TRUE)
                    {
                        RemoveSpellEffects(SPELL_BANISHMENT, OBJECT_SELF, oTarget);
                    }

                    if (!MyResistSpell(OBJECT_SELF, oTarget) && !MySavingThrow(SAVING_THROW_WILL, oTarget, nSpellDC))
                    {
                        if (!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, OBJECT_SELF))
                            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oTarget, 24.0);
                    }

                    // Start building the linked effects for the debuff.
                    effect eLink;
                    eLink = EffectLinkEffects(eLink, EffectAttackDecrease(2));
                    eLink = EffectLinkEffects(eLink, EffectSavingThrowDecrease(SAVING_THROW_ALL, 2));
                    eLink = EffectLinkEffects(eLink, EffectACDecrease(2));
                    eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));

                    // Apply debuff and visual effect
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(AR_GetCasterLevel(OBJECT_SELF)));
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_ODD), oTarget);
                }
            }
        }
        //Get next creature in the shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }
}


