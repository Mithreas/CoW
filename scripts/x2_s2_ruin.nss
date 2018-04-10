//::///////////////////////////////////////////////
//:: Greater Ruin
//:: X2_S2_Ruin
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
// The caster deals 35d6 damage to a single target
   fort save for half damage
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 18, 2002
//:://////////////////////////////////////////////

#include "x2_I0_SPELLS"
#include "x2_inc_spellhook"
#include "x0_I0_SPELLS"
void main()
{

    /*
      Spellcast Hook Code
      Added 2003-06-20 by Georg
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more

    */

        if (!X2PreSpellCastCode())
        {
        // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
            return;
        }

    // End of Spell Cast Hook
		
	// Shadow mages cannot cast evocation spells (except Darkness).
    if (GetIsShadowMage(OBJECT_SELF))
    {
      SendMessageToPC (OBJECT_SELF, "The Shadow Weave does not support Evocation spells (except Darkness).");
      return;
    }
	
    //Declare major variables
    object oTarget = GetSpellTargetObject();


    float fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
    float fDelay = fDist/(3.0 * log(fDist) + 2.0);

    int nBacklash = GetHasFeat(FEAT_EPIC_SPELL_FOCUS_EVOCATION) ? 0 : d6(30);

    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        //Roll damage
        int nDam = d6(45)+10;
        //Set damage effect

        effect eDam = EffectDamage(nDam, DAMAGE_TYPE_POSITIVE, DAMAGE_POWER_PLUS_TWENTY);
        ApplyEffectAtLocation (DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SCREEN_SHAKE), GetLocation(oTarget));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(487), oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_BLOOD_CRT_RED), oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_BONE_MEDIUM), oTarget);
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));

        if(nBacklash)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nBacklash), OBJECT_SELF);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY), OBJECT_SELF);
        }
    }
}
