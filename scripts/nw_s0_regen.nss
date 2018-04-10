//::///////////////////////////////////////////////
//:: Regenerate
//:: NW_S0_Regen
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Grants the selected target 6 HP of regeneration
    every round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 22, 2001
//:://////////////////////////////////////////////

#include "mi_inc_spells"
#include "inc_healer"
#include "x0_i0_spells"

// Handler for the recursive regenerate code. Heals the PC each round.
void Regenerate(object oTarget, object oCaster, int nCasterLevel, int nRegenerateId, int nOverhealLimit);
// Returns the "Id" of the current regenerate spell. Used to determine when the recursive
// regeneration script should quit firing due to the application of a new spell.
int GetRegenerateId(object oTarget);
// Sets the "Id" of the current regenerate spell. Used to determine when the recursive
// regeneration script should quit firing due to the application of a new spell.
void SetRegenerateId(object oTarget, int nId);

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
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
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_NATURE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    int nMeta = AR_GetMetaMagicFeat();
    int nLevel = AR_GetCasterLevel(OBJECT_SELF);
    int nDuration = nLevel;
    // Used to differentiate new castings of regenerate.
    int nRegenerateId = GetModuleTime();
    int nOverhealLimit = GetIsObjectValid(GetSpellCastItem()) ? 0 : GetOverhealLimit(OBJECT_SELF, GetLastSpellCastClass());
    //Meta-Magic Checks
    if (nMeta == METAMAGIC_EXTEND)
    {
        nDuration *= 2;

    }
    // Prevent stacking.
    RemoveEffectsFromSpell(oTarget, GetSpellId());
    RemoveEffectsFromSpell(oTarget, SPELL_MONSTROUS_REGENERATION);
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_REGENERATE, FALSE));
    //Apply effects and VFX
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, TurnsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    SetRegenerateId(oTarget, nRegenerateId);
    DelayCommand(6.0, Regenerate(oTarget, OBJECT_SELF, nLevel, nRegenerateId, nOverhealLimit));
}

//::///////////////////////////////////////////////
//:: Regenerate
//:://////////////////////////////////////////////
/*
    Handler for the recursive regenerate code.
    Heals the PC each round.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 13, 2016
//:://////////////////////////////////////////////
void Regenerate(object oTarget, object oCaster, int nCasterLevel, int nRegenerateId, int nOverhealLimit)
{
    int nHeal = 4 + nCasterLevel / 6;

    if(!GetIsObjectValid(oTarget) || GetRegenerateId(oTarget) != nRegenerateId) return;
    if(!GetIsObjectValid(oCaster))
    {
        // If the caster is absent, this won't function correctly. Just remove the effect.
        RemoveEffectsFromSpell(oTarget, SPELL_REGENERATE);
        SetRegenerateId(oTarget, 0);
        return;
    }
    if(!GetHasSpellEffect(SPELL_REGENERATE, oTarget))
    {
        // The spell has been dispelled.
        SetRegenerateId(oTarget, 0);
        return;
    }
    ApplyHealToObject(nHeal, oTarget, oCaster, nOverhealLimit);
    DelayCommand(6.0, Regenerate(oTarget, oCaster, nCasterLevel, nRegenerateId, nOverhealLimit));
}

//::///////////////////////////////////////////////
//:: GetRegenerateId
//:://////////////////////////////////////////////
/*
    Returns the "Id" of the current regenerate
    spell. Used to determine when the recursive
    regeneration script should quit firing
    due to the application of a new spell.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 13, 2016
//:://////////////////////////////////////////////
int GetRegenerateId(object oTarget)
{
    return GetLocalInt(oTarget, "RegenerateId");
}

//::///////////////////////////////////////////////
//:: SetRegenerateId
//:://////////////////////////////////////////////
/*
    Sets the "Id" of the current regenerate
    spell. Used to determine when the recursive
    regeneration script should quit firing
    due to the application of a new spell.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 13, 2016
//:://////////////////////////////////////////////
void SetRegenerateId(object oTarget, int nId)
{
    if(nId <= 0)
    {
        DeleteLocalInt(oTarget, "RegenerateId");
    }
    else
    {
        SetLocalInt(oTarget, "RegenerateId", nId);
    }
}
