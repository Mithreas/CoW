//::///////////////////////////////////////////////
//:: Evards Black Tentacles
//:: NW_S0_Evards.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures within the AoE take 2d6 acid damage
    per round and upon entering if they fail a Fort Save
    or their movement is halved.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 20, 2001


#include "mi_inc_spells"
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


    //Declare major variables including Area of Effect Object
    location lTarget = GetSpellTargetLocation();
    int nDuration = AR_GetCasterLevel(OBJECT_SELF) / 2;
    int nMetaMagic = AR_GetMetaMagicFeat();
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
    CreateNonStackingPersistentAoE(DURATION_TYPE_TEMPORARY, AOE_PER_EVARDS_BLACK_TENTACLES, lTarget, RoundsToSeconds(nDuration));
}
