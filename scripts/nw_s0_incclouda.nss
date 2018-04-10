//::///////////////////////////////////////////////
//:: Incendiary Cloud
//:: NW_S0_IncCloud.nss
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
//:: March 2003: Removed movement speed penalty
#include "X0_I0_SPELLS"
#include "mi_inc_spells"
#include "inc_generic"

void main()
{

    //Declare major variables
    int nMetaMagic = AR_GetMetaMagicFeat();
    int nDamage;
    effect eDam;
    object oTarget;
    //Declare and assign personal impact visual effect.
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
   // effect eSpeed = EffectMovementSpeedDecrease(50);
    effect eVis2 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = eVis2; //EffectLinkEffects(eSpeed, eVis2);
    float fDelay;
    //Capture the first target object in the shape.
    oTarget = GetEnteringObject();
    //Declare the spell shape, size and the location.
    if (!GetIsCorpse(oTarget) && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_INCENDIARY_CLOUD));
        //Make SR check, and appropriate saving throw(s).
        if(!MyResistSpell(GetAreaOfEffectCreator(), oTarget, fDelay))
        {
            fDelay = GetRandomDelay(0.5, 2.0);
            //Roll damage.
            nDamage = d6(4 + AR_GetCasterLevel(GetAreaOfEffectCreator()) / 2);
            //Enter Metamagic conditions
               /*if (nMetaMagic == METAMAGIC_MAXIMIZE)
                {
                   nDamage = 24;//Damage is at max
                }
                if (nMetaMagic == METAMAGIC_EMPOWER)
                {
                     nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
                }*/
            //Adjust damage for Reflex Save, Evasion and Improved Evasion
            nDamage = AR_GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE, GetAreaOfEffectCreator());
            // Apply effects to the currently selected target.
            eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
            if(nDamage > 0)
            {
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBlindness(), oTarget, RoundsToSeconds(1) + 1.0));
        }
       // ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSpeed, oTarget);
    }
}
