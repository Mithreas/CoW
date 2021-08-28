//::///////////////////////////////////////////////
//:: Haste
//:: NW_S0_Haste.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gives the targeted creature one extra partial
    action per round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 29, 2001
//:://////////////////////////////////////////////
// Modified March 2003: Remove Expeditious Retreat effects

#include "x0_i0_spells"
#include "inc_math"
#include "inc_timelock"
#include "inc_customspells"
#include "inc_warlock"

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
    object oTarget = GetSpellTargetObject();
    object oCaster = OBJECT_SELF;
    int nDuration = AR_GetCasterLevel(OBJECT_SELF);

    if (oCaster != oTarget && miWAGetIsWarlock(oCaster) &&
        !GetIsObjectValid(GetSpellCastItem()) && GetLastSpellCastClass() == CLASS_TYPE_BARD)
    {
        // Warlocks can haste a maximum of one other target.
        if (GetIsTimelocked(OBJECT_SELF, "Warlock Haste"))
        {
            TimelockErrorMessage(OBJECT_SELF, "Warlock Haste");
            return;
        }
        else
        {
            object oLastTarget = GetLocalObject(oCaster, "WARLOCK_LastHasteTarget");

            if (GetHasSpellEffect(SPELL_HASTE, oLastTarget) == TRUE)
            {
                RemoveSpellEffects(SPELL_HASTE, OBJECT_SELF, oLastTarget);
            }

            SetLocalObject(oCaster, "WARLOCK_LastHasteTarget", oTarget);
            SetTimelock(OBJECT_SELF, MinInt(10, nDuration - 1) * 6, "Warlock Haste", 30, 6);
        }
    }

    if (GetHasSpellEffect(SPELL_EXPEDITIOUS_RETREAT, oTarget) == TRUE)
    {
        RemoveSpellEffects(SPELL_EXPEDITIOUS_RETREAT, OBJECT_SELF, oTarget);
    }

    if (GetHasSpellEffect(647, oTarget) == TRUE)
    {
        RemoveSpellEffects(647, OBJECT_SELF, oTarget);
    }

    if (GetHasSpellEffect(SPELL_MASS_HASTE, oTarget) == TRUE)
    {
        RemoveSpellEffects(SPELL_MASS_HASTE, OBJECT_SELF, oTarget);
    }

    // Check for Shifter version of the spell.
    if (!GetIsObjectValid(GetSpellCastItem()) && GetSpellId() == 862)
    {
        // Restore feat use.
        IncrementRemainingFeatUses(OBJECT_SELF, 1155);
		gsSTDoCasterDamage(OBJECT_SELF, 10);
        miDVGivePoints(OBJECT_SELF, ELEMENT_WATER, 3.0);
	}	


    effect eHaste = EffectHaste();
    effect eVis = EffectVisualEffect(VFX_IMP_HASTE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eHaste, eDur);


    int nMetaMagic = AR_GetMetaMagicFeat();
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HASTE, FALSE));
    //Check for metamagic extension
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2;  //Duration is +100%
    }
    // Apply effects to the currently selected target.
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}


