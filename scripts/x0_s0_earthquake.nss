//::///////////////////////////////////////////////
//:: Earthquake
//:: X0_S0_Earthquake
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
// Ground shakes. 1d6 damage, max 10d6
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 22 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs May 01, 2003

//::  UPDATE Mars 12. 2017, ActionReplay:
//::  Earthquake now deals 1d6 / Caster Level, max 30d6 at Level 30
//::  Save vs Reflex against knockdown for Half a Round
//::  EDIT:  Summons using Earthquake (Looking at you Earth Monolith) will not hurt allies

#include "X0_I0_SPELLS"
#include "inc_customspells"
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


    //Declare major variables

    object oCaster = OBJECT_SELF;
    int nCasterLvl = AR_GetCasterLevel(oCaster);
    int nMetaMagic = AR_GetMetaMagicFeat();
    int nDamage;
    float fDelay;
    float nSize =  RADIUS_SIZE_COLOSSAL;
    effect eExplode = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_NATURE);
    effect eDam;
    effect eShake = EffectVisualEffect(356);
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();
    //Limit Caster level for the purposes of damage
    if (nCasterLvl > 30)
    {
        nCasterLvl = 30;
    }
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, OBJECT_SELF, RoundsToSeconds(6));

    //Apply epicenter explosion on caster
    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, GetLocation(OBJECT_SELF));

    int isSummon = GetIsObjectValid(GetMaster(OBJECT_SELF)) && !GetIsPC(OBJECT_SELF);
    int spellTargetSelection = isSummon ? SPELL_TARGET_SELECTIVEHOSTILE : SPELL_TARGET_STANDARDHOSTILE;

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, nSize, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, spellTargetSelection, OBJECT_SELF))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_EARTHQUAKE));
            //Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
            // Earthquake does not allow spell resistance
            //if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
            {

                nDamage = MaximizeOrEmpower(6, nCasterLvl,  AR_GetMetaMagicFeat());
                //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion. (Don't bother for caster)
                if (oTarget != oCaster)
                {
                    nDamage = AR_GetReflexAdjustedDamage(nDamage, oTarget, AR_GetSpellSaveDC(), SAVING_THROW_TYPE_ALL);
                }
                //Set the damage effect
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING);
                // * caster can't be affected by the spell
                if( (nDamage > 0) && (oTarget != oCaster))
                {

                    // Apply effects to the currently selected target.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    //This visual effect is applied to the target object not the location as above.  This visual effect
                    //represents the flame that erupts on the target not on the ground.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));

                    //::  Reflex Save or fall prone for Half a Round
                    if ( !MySavingThrow(SAVING_THROW_REFLEX, oTarget, AR_GetSpellSaveDC()) ) {
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oTarget, 3.0));
                    }
                }
             }
        }

        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, nSize, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}





