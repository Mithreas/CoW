//::///////////////////////////////////////////////
//:: Ghostly Visage
//:: NW_S0_MirrImage.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Caster gains 5/+1 Damage reduction and immunity
    to 1st level spells.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2001
//:://////////////////////////////////////////////

#include "inc_customspells"
#include "inc_state"
#include "inc_timelock"

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

    // Assassin: 2m cooldown, Swap for Ethereal Visage at level 11
    object oItem = GetSpellCastItem();
    if (!GetIsObjectValid(oItem) && GetSpellId() == 605)
    {
        // Restore feat use.
        IncrementRemainingFeatUses(OBJECT_SELF, FEAT_PRESTIGE_SPELL_GHOSTLY_VISAGE);
		
        // Cooldown check.
        if(GetIsTimelocked(OBJECT_SELF, "Assassin Visage"))
        {
            TimelockErrorMessage(OBJECT_SELF, "Assassin Visage");
            return;
        }
        SetTimelock(OBJECT_SELF, FloatToInt(TurnsToSeconds(2)), "Assassin Visage", 60, 30);

        if (GetLevelByClass(CLASS_TYPE_ASSASSIN, OBJECT_SELF) >= 8)
        {
            // Ethereal Visage
            effect eEther = EffectLinkEffects(EffectVisualEffect(VFX_DUR_ETHEREAL_VISAGE), EffectLinkEffects(EffectDamageReduction(20, DAMAGE_POWER_PLUS_THREE), EffectSpellLevelAbsorption(2)));
            eEther = EffectLinkEffects(eEther, EffectLinkEffects(EffectConcealment(25), EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE)));

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEther, OBJECT_SELF, TurnsToSeconds(2));
			gsSTDoCasterDamage(OBJECT_SELF, 8); 
            return;
        }
		
		gsSTDoCasterDamage(OBJECT_SELF, 5); 
    }


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE);
    effect eDam = EffectDamageReduction(5, DAMAGE_POWER_PLUS_ONE);
    effect eSpell = EffectSpellLevelAbsorption(1);
    effect eConceal = EffectConcealment(10);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eDam, eVis);
    eLink = EffectLinkEffects(eLink, eSpell);
    eLink = EffectLinkEffects(eLink, eConceal);
    eLink = EffectLinkEffects(eLink, eDur);
    int nMetaMagic = AR_GetMetaMagicFeat();
    int nDuration = AR_GetCasterLevel(OBJECT_SELF);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_GHOSTLY_VISAGE, FALSE));

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }
    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
}

