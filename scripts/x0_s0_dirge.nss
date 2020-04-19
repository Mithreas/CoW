//::///////////////////////////////////////////////
//:: Dirge
//:: x0_s0_dirge.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures within the AoE take 2 points of Strength
    and Dexterity ability score damage.
    Lasts 1 round/level
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 2002
//:://////////////////////////////////////////////

#include "x0_i0_spells"
#include "inc_customspells"

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

    //--------------------------------------------------------------------------
    // Make sure this aura is only active once
    //--------------------------------------------------------------------------
    RemoveSpellEffects(GetSpellId(), OBJECT_SELF, GetSpellTargetObject());


    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_MOB_CIRCGOOD, "x0_s0_dirgeEN", "x0_s0_dirgeHB", "x0_s0_dirgeEX");
    int nDuration = AR_GetCasterLevel(OBJECT_SELF);
	if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_EVOCATION, OBJECT_SELF)) nDuration += 2;
    int nMetaMagic = AR_GetMetaMagicFeat();
    effect eImpact = EffectVisualEffect(257);
    effect eCaster = EffectVisualEffect(VFX_DUR_BARD_SONG);

    effect eFNF = EffectVisualEffect(VFX_FNF_SOUND_BURST);
    //Apply the FNF to the spell location
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eFNF, GetLocation(OBJECT_SELF));


    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetLocation(OBJECT_SELF));
    //Make sure duration does no equal 0
    if (nDuration < 1)
    {
        nDuration = 1;
    }
    //Check Extend metamagic feat.
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
       nDuration = nDuration *2;    //Duration is +100%
    }
    //Create an instance of the AOE Object using the Apply Effect function

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, OBJECT_SELF, RoundsToSeconds(nDuration));
}


