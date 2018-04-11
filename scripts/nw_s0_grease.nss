 //::///////////////////////////////////////////////
//:: Grease
//:: NW_S0_Grease.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creatures entering the zone of grease must make
    a reflex save or fall down.  Those that make
    their save have their movement reduced by 1/2.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 1, 2001
//:://////////////////////////////////////////////

#include "inc_customspells"
#include "inc_warlock"
#include "inc_spells"

void main()
{

#include "inc_spells"

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
    object oTarget = GetSpellTargetObject();
    if (GetIsObjectValid(oTarget) && !GetIsReactionTypeFriendly(oTarget))
    {
      miWADoWarlockAttack(OBJECT_SELF, oTarget, GetSpellId());
      // Don't return if we miss - just throw the cloud down normally.
    }

    //Declare major variables including Area of Effect Object
    location lTarget = GetSpellTargetLocation();
    int nDuration = 2 + AR_GetCasterLevel(OBJECT_SELF) / 3;
    effect eImpact = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_GREASE);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);
    int nMetaMagic = AR_GetMetaMagicFeat();
    //Check Extend metamagic feat.
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
       nDuration = nDuration *2;    //Duration is +100%
    }
    //Create an instance of the AOE Object using the Apply Effect function
    CreateNonStackingPersistentAoE(DURATION_TYPE_TEMPORARY, AOE_PER_GREASE, lTarget, RoundsToSeconds(nDuration));
}
