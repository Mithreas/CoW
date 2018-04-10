//#include "mi_inc_warlock"
#include "mi_inc_spells"
//Edited by Morderon on October 23, 2010.
//Added ASF for warlocks
//And mdSetAOECreatedByWarlock
// Peppermint, 2-5-2016; Warlock code removed, as new warlocks no longer have this spell.
// Also added non-stacking AoE hook (though it does nothing except store the AoE's id for now).
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

  effect eAOE      = EffectAreaOfEffect(AOE_PER_WALLFIRE);
  location lTarget = GetSpellTargetLocation();
  object oItem     = GetSpellCastItem();
  object oCaster   = OBJECT_SELF;
  int nDuration;

  nDuration = AR_GetCasterLevel(oCaster) / 2;


  if (nDuration == 0)
  {
      nDuration = 1;
  }

  // Check for metamagic
  if (AR_GetMetaMagicFeat() == METAMAGIC_EXTEND)
  {
    nDuration = nDuration * 2;   //Duration is +100%
  }

  // Create the Area of Effect Object declared above.
  CreateNonStackingPersistentAoE(DURATION_TYPE_TEMPORARY, AOE_PER_WALLFIRE, lTarget, RoundsToSeconds(nDuration));
}
