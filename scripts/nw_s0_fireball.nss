//::///////////////////////////////////////////////
//:: Fireball
//:: NW_S0_Fireball
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// A fireball is a burst of flame that detonates with
// a low roar and inflicts 1d6 points of damage per
// caster level (maximum of 10d6) to all creatures
// within the area. Unattended objects also take
// damage. The explosion creates almost no pressure.
*/
//:://////////////////////////////////////////////
//:: Created By: Noel Borstad
//:: Created On: Oct 18 , 2000
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 6, 2001
//:: Last Updated By: AidanScanlan, On: April 11, 2001
//:: Last Updated By: Preston Watamaniuk, On: May 25, 2001
#include "inc_spells"
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
    effect eExplode = EffectVisualEffect(VFX_FNF_FIREBALL);
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    effect eDam;
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();
    int bStaticLevel   = GetLocalInt(GetModule(), "STATIC_LEVEL");
    int nDC = AR_GetSpellSaveDC();

    if(GetSpellId() == SPELL_SHADES_FIREBALL)
    {
        nDC = AdjustSpellDCForSpellSchool(nDC, SPELL_SCHOOL_ILLUSION);
    }
    //Limit Caster level for the purposes of damage
    if (nCasterLvl > 10)
    {
        nCasterLvl = 10;
    }
	if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_EVOCATION, OBJECT_SELF)) nCasterLvl += 2;
    //Apply the fireball explosion at the location captured above.
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            if((GetSpellId() == 341) || GetSpellId() == 58)
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FIREBALL));
                //Get the distance between the explosion and the target to calculate delay
                fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
                if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
                {
                    //Roll damage for each target
                    nDamage = d6(bStaticLevel ? 2*nCasterLvl : nCasterLvl);
                    //Resolve metamagic
                    if (nMetaMagic == METAMAGIC_MAXIMIZE)
                    {
                        nDamage = (bStaticLevel ? 12 : 6) * nCasterLvl;
                    }
                    else if (nMetaMagic == METAMAGIC_EMPOWER)
                    {
                       nDamage = nDamage + nDamage / 2;
                    }
                    //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                    nDamage = AR_GetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_FIRE);
                    //Set the damage effect
                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                    if(nDamage > 0)
                    {
                        // Apply effects to the currently selected target.
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                        //This visual effect is applied to the target object not the location as above.  This visual effect
                        //represents the flame that erupts on the target not on the ground.
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    }
                 }
             }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}

