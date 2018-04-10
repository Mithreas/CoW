//::///////////////////////////////////////////////
//:: Cloud of Bewilderment
//:: X2_S0_CldBewld
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    A cone of noxious air goes forth from the caster.
    Enemies in the area of effect are stunned and blinded
    1d6 rounds. Foritude save negates effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: November 04, 2002
//:://////////////////////////////////////////////

#include "nw_i0_spells"
#include "x0_i0_spells"
#include "mi_inc_spells"
#include "mi_inc_warlock"
#include "inc_spells"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-07-07 by Georg Zoeller
  If you want to make changes to all spells,
  check mi_inc_spells.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook
    object oTarget = GetSpellTargetObject();
    if (GetIsObjectValid(oTarget) && !GetIsReactionTypeFriendly(oTarget))
    {
      miWADoWarlockAttack(OBJECT_SELF, oTarget, GetSpellId());
      // Don't return if we miss - just throw the cloud down normally.
    }

    //Declare major variables
    location lTarget = GetSpellTargetLocation();
    int nDuration = AR_GetCasterLevel(OBJECT_SELF);
    effect eImpact = EffectVisualEffect(VFX_IMP_DUST_EXPLOSION);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);
    if (nDuration < 1)
    {
        nDuration = 1;
    }
    int nMetaMagic = AR_GetMetaMagicFeat();
    //Make metamagic check for extend
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;   //Duration is +100%
    }
    //Create the AOE object at the selected location
    CreateNonStackingPersistentAoE(DURATION_TYPE_TEMPORARY, 39, lTarget, RoundsToSeconds(nDuration));
}

