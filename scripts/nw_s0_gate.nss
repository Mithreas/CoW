//::///////////////////////////////////////////////
//:: Gate
//:: NW_S0_Gate.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:: Summons a Balor to fight for the caster.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
//:://////////////////////////////////////////////

#include "inc_sumstream"
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

    int nVFX = GetAlignmentBasedGateVFX();

    SummonFromStream(OBJECT_SELF, GetSpellTargetLocation(), RoundsToSeconds(AR_GetCasterLevel(OBJECT_SELF)), STREAM_TYPE_PLANAR, STREAM_PLANAR_TIER_GATE,
        nVFX, GetSummonVFXDelay(nVFX), FALSE, FALSE, gsWOGetDeityPlanarStream(OBJECT_SELF));
}
