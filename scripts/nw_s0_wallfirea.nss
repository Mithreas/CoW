//::///////////////////////////////////////////////
//:: Wall of Fire: On Enter
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
#include "inc_spell"
#include "inc_spells"
#include "inc_generic"
#include "inc_customspells"
void main()
{

    //Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    int nCasterLevel = AR_GetCasterLevel(GetAreaOfEffectCreator());
    effect eDam;
    object oTarget;
    object oCaster = GetAreaOfEffectCreator();
    //Declare and assign personal impact visual effect.
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    int nDC = GetSpellSaveDC();

    //Capture the first target object in the shape.
    oTarget = GetEnteringObject();

    // Escape for DMs
    if(GetIsDM(oTarget) == TRUE && GetIsDMPossessed(oTarget) == FALSE)
    {
        return;
    }

    if(GetIsCorpse(oTarget)) return;

    if(GetAoEId(OBJECT_SELF) == SPELL_SHADES_WALL_OF_FIRE)
    {
        nDC = AdjustSpellDCForSpellSchool(nDC, SPELL_SCHOOL_ILLUSION, SPELL_WALL_OF_FIRE, GetAreaOfEffectCreator());
    }

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_WALL_OF_FIRE));

    if (gsSPGetIsAffected(GS_SP_TYPE_HARMFUL_SELECTIVE, oCaster, oTarget))
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
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
    }
}
