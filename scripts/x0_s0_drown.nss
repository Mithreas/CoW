//::///////////////////////////////////////////////
//:: Drown
//:: [X0_S0_Drown.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    if the creature fails a FORT throw.
    Does not work against Undead, Constructs, or Elementals.

January 2003:
 - Changed to instant kill the target.
May 2003:
 - Changed damage to 90% of current HP, instead of instant kill.

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 26 2002
//:://////////////////////////////////////////////
//:: Last Update By: Andrew Nobbs May 01, 2003

#include "nw_i0_spells"
#include "mi_inc_spells"
#include "inc_spells"

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


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = AR_GetCasterLevel(OBJECT_SELF);
    int nDam = GetCurrentHitPoints(oTarget);
    //Set visual effect
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
    effect eDam;
    //Check faction of target
    if(GetIsReactionTypeHostile(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 437));
        //Make SR Check
        if(!MyResistSpell(OBJECT_SELF, oTarget))
        {
            // * certain racial types are immune
            if ((GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT)
                &&(GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
                &&(GetRacialType(oTarget) != RACIAL_TYPE_ELEMENTAL))
            {
                //Make a fortitude save
                if(!MySavingThrow(SAVING_THROW_FORT, oTarget, AR_GetSpellSaveDC()))
                {
                    nDam = FloatToInt(nDam * 0.9);
                    eDam = EffectDamage(nDam, DAMAGE_TYPE_BLUDGEONING);
                    //Apply the VFX impact and damage effect
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);

                }

                //::  Always deals 2d10 + 5 Damage, even if failing
                float fDelay = GetRandomDelay(0.8, 1.4);
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d10(2) + 5, DAMAGE_TYPE_BLUDGEONING), oTarget));
            }
        }
    }
}





