//::///////////////////////////////////////////////
//:: Mind Fog
//:: NW_S0_MindFog.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a bank of fog that lowers the Will save
    of all creatures within who fail a Will Save by
    -10.  Affect lasts for 2d6 rounds after leaving
    the fog
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 1, 2001
//:://////////////////////////////////////////////

#include "mi_inc_spells"
//Edited by Morderon October 24, 2010.
//Added ASF for warlocks
//Added mdSetAOECreatedByWarlock
//Changed duration calculation for warlocks
#include "md_inc_spell"
#include "mi_inc_warlock"
#include "inc_spells"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
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

    //Declare major variables including Area of Effect Object
    location lTarget = GetSpellTargetLocation();
    int nDuration;
    int nMetaMagic = AR_GetMetaMagicFeat();
    object oItem = GetSpellCastItem();
    object oCaster = OBJECT_SELF;

    if (GetIsObjectValid(oItem) && GetTag(oItem) == TAG_WARLOCK_STAFF)
    {
      // ASF. Morderon Added, noticed it was missing
      if (miWAArcaneSpellFailure(oCaster)) return;
      nDuration = 2 + miWAGetCasterLevel(oCaster) / 2;
    }
    else
    {
      nDuration = 2 + AR_GetCasterLevel(oCaster) / 2;
    }

    if (nDuration == 0)
    {
      nDuration = 1;
    }

    //Check Extend metamagic feat.
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
       nDuration = nDuration *2;    //Duration is +100%
    }

    effect eImpact = EffectVisualEffect(262);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);
    //Create an instance of the AOE Object using the Apply Effect function
    CreateNonStackingPersistentAoE(DURATION_TYPE_TEMPORARY, AOE_PER_FOGMIND, lTarget, RoundsToSeconds(nDuration));

    mdSetAOECreatedByWarlock(oItem, lTarget, oCaster);
}

