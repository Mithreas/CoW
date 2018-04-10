//::///////////////////////////////////////////////
//:: Stonehold
//:: X2_S0_Stnehold
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates an area of effect that will cover the
    creature with a stone shell holding them in
    place.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: December 03, 2002
//:://////////////////////////////////////////////

#include "nw_i0_spells"
#include "x0_i0_spells"
#include "mi_inc_spells"
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


    //Declare major variables
    location lTarget = GetSpellTargetLocation();
    int nDuration = AR_GetCasterLevel(OBJECT_SELF);
    effect eImpact = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_NATURE);
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
    CreateNonStackingPersistentAoE(DURATION_TYPE_TEMPORARY, 42, lTarget, RoundsToSeconds(nDuration));
}

