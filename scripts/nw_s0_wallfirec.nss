//::///////////////////////////////////////////////
//:: Wall of Fire: Heartbeat
//:: NW_S0_WallFireA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Person within the AoE take 4d6 fire damage
    per round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////

//#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
//Edited by Morderon on October 23, 2010.
//Warlock DCs should now be computed correctly.
#include "gs_inc_spell"
#include "inc_spells"
#include "inc_generic"
#include "inc_customspells"
void main()
{

    //Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    int nCasterLevel = AR_GetCasterLevel(GetAreaOfEffectCreator());
    int nDamage;
    effect eDam;
    object oTarget;
    object oCaster = GetAreaOfEffectCreator();
    //Declare and assign personal impact visual effect.
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    int nDC = GetSpellSaveDC();

    if(GetAoEId(OBJECT_SELF) == SPELL_SHADES_WALL_OF_FIRE)
    {
        nDC = AdjustSpellDCForSpellSchool(nDC, SPELL_SCHOOL_ILLUSION, SPELL_WALL_OF_FIRE, GetAreaOfEffectCreator());
    }
    //Capture the first target object in the shape.

    //--------------------------------------------------------------------------
    // GZ 2003-Oct-15
    // When the caster is no longer there, all functions calling
    // GetAreaOfEffectCreator will fail. Its better to remove the barrier then
    //--------------------------------------------------------------------------
    if (!GetIsObjectValid(oCaster))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

    oTarget = GetFirstInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Declare the spell shape, size and the location.
    while(GetIsObjectValid(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_WALL_OF_FIRE));

        if ((GetResRef(oTarget) != "gs_placeable016") && !GetIsCorpse(oTarget) && gsSPGetIsAffected(GS_SP_TYPE_HARMFUL_SELECTIVE, oCaster, oTarget) && !(GetIsDM(oTarget) || GetIsDMPossessed(oTarget)))
        {
            //Make SR check, and appropriate saving throw(s).
            if(!ResistSpell(oCaster, oTarget))
            {
                //Roll damage.
                nDamage = d6(2) + nCasterLevel;
                //Enter Metamagic conditions
                if (nMetaMagic == METAMAGIC_MAXIMIZE)
                {
                   nDamage = 12 + nCasterLevel;//Damage is at max
                }
                if (nMetaMagic == METAMAGIC_EMPOWER)
                {
                     nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
                }
                if(GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
                {
                    nDamage *= 2;
                }
                //nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_FIRE);
                if(nDamage > 0)
                {
                    // Apply effects to the currently selected target.
                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 1.0);
                }
            }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}
