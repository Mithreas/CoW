//::///////////////////////////////////////////////
//:: Fox's Cunning
//:: NW_S0_FoxCunng
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Raises targets Int by 1d4+1
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 15, 2001
//:://////////////////////////////////////////////

#include "inc_customspells"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
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
    object oTarget = GetSpellTargetObject();
    effect eRaise;
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    int nMetaMagic = AR_GetMetaMagicFeat();
    int nRaise = 4;
    int nDuration = AR_GetCasterLevel(OBJECT_SELF);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FOXS_CUNNING, FALSE));

    // Transmutation Buff: add +1 from GSF, +2 from ESF
    int nTransmutation = 0;
    if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION, OBJECT_SELF))
        nTransmutation++;
    if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION, OBJECT_SELF))
        nTransmutation++;

    // Check for Shifter version of the spell.
    if (!GetIsObjectValid(GetSpellCastItem()) && GetSpellId() == 859)
    {
        // Restore feat use.
        IncrementRemainingFeatUses(OBJECT_SELF, 1152);
		gsSTDoCasterDamage(OBJECT_SELF, 5);
        miDVGivePoints(OBJECT_SELF, ELEMENT_WATER, 3.0);
	}	

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
        nRaise = 4;//Damage is at max
    }
    else if (nMetaMagic == METAMAGIC_EMPOWER)
    {
        nRaise = nRaise + (nRaise/2); //Damage/Healing is +50%
    }
    else if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }

    // Apply transmutation after metamagic.
    nRaise = nRaise + nTransmutation;

    //Set Adjust Ability Score effect
    eRaise = EffectAbilityIncrease(ABILITY_INTELLIGENCE, nRaise);
    effect eLink = EffectLinkEffects(eRaise, eDur);

    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

    // Add user-friendly feedback.
    if (GetIsPC(OBJECT_SELF))
        SendMessageToPC(OBJECT_SELF, "Intelligence increased by " + IntToString(nRaise) + ".");
}
