//::///////////////////////////////////////////////
//:: Divine Shield
//:: x0_s2_divshield.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Up to [turn undead] times per day the character may add his Charisma bonus to his armor
    class for a number of rounds equal to the Charisma bonus.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: Sep 13, 2002
//:://////////////////////////////////////////////
#include "x0_i0_spells"
#include "gs_inc_worship"

void main()
{

   if (!GetHasFeat(FEAT_TURN_UNDEAD, OBJECT_SELF))
   {
        SendMessageToPC(OBJECT_SELF, GetStringByStrRef(40550));
        return;
   }

   float fPiety = gsWOGetPiety(OBJECT_SELF);

   if (fPiety < 1.0f)
   {
     FloatingTextStringOnCreature("You are not pious enough for your god to grant you this ability.", OBJECT_SELF, FALSE);
     return;
   }
   else
   {
     gsWOAdjustPiety(OBJECT_SELF, -1.0f);
   }

   // Allowing additional castings to replace/refresh Divine Shield durations
   // if(GetHasFeatEffect(414) == FALSE)
   // {
        //Declare major variables
        object oTarget = GetSpellTargetObject();
        int nLevel = GetCasterLevel(OBJECT_SELF);

        effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

        int nCharismaBonus = GetAbilityModifier(ABILITY_CHARISMA);
        effect eAC = EffectACIncrease(nCharismaBonus);
        effect eLink = EffectLinkEffects(eAC, eDur);
        eLink = SupernaturalEffect(eLink);

         // * Do not allow this to stack
        RemoveEffectsFromSpell(oTarget, GetSpellId());
		      RemoveEffectsFromSpell(OBJECT_SELF, GetSpellId());

        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 474, FALSE));

        //Apply Link and VFX effects to the target
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nCharismaBonus));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

        DecrementRemainingFeatUses(OBJECT_SELF, FEAT_TURN_UNDEAD);
    // }
}



