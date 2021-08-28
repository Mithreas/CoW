//::///////////////////////////////////////////////
//:: [Endurance]
//:: [NW_S0_Endurce.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Gives the target 1d4+1 Constitution.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 31, 2001
//:://////////////////////////////////////////////
#include "inc_customspells"

void main()
{
    /*
      Spellcast Hook Code
      Added 2004-03-08 by Jon (should have been added much sooner, but we somehow missed this one...)
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
    effect eCon;
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    int nCasterLvl = AR_GetCasterLevel(OBJECT_SELF);
    int nModify = 4;
    float fDuration = HoursToSeconds(nCasterLvl);
    int nMetaMagic = AR_GetMetaMagicFeat();
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ENDURANCE, FALSE));

    // Transmutation Buff: add +1 from GSF, +2 from ESF
    int nTransmutation = 0;
    if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION, OBJECT_SELF))
        nTransmutation++;
    if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION, OBJECT_SELF))
        nTransmutation++;

    // Check for Shifter version of the spell.
    if (!GetIsObjectValid(GetSpellCastItem()) && GetSpellId() == 857)
    {
        // Restore feat use.
        IncrementRemainingFeatUses(OBJECT_SELF, 1150);
		gsSTDoCasterDamage(OBJECT_SELF, 5);
        miDVGivePoints(OBJECT_SELF, ELEMENT_WATER, 3.0);
	}	
	
    //Check for metamagic conditions
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
        nModify = 4;
    }
    if (nMetaMagic == METAMAGIC_EMPOWER)
    {
        nModify = FloatToInt( IntToFloat(nModify) * 1.5 );
    }
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        fDuration = fDuration * 2.0;
    }

    nModify = nModify + nTransmutation;

    //Set the ability bonus effect
    eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION,nModify);
    effect eLink = EffectLinkEffects(eCon, eDur);

    //Appyly the VFX impact and ability bonus effect
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

    // Add user-friendly feedback.
    if (GetIsPC(OBJECT_SELF))
        SendMessageToPC(OBJECT_SELF, "Constitution increased by " + IntToString(nModify) + ".");

}
