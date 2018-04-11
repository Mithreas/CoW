//::///////////////////////////////////////////////
//:: Flesh to Stone
//:: x0_s0_fleshsto
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
//:: The target freezes in place, standing helpless.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: October 16, 2002
//:://////////////////////////////////////////////
#include "x0_i0_spells"
#include "inc_customspells"
#include "inc_spells"

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


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nCasterLvl = AR_GetCasterLevel(OBJECT_SELF);
    int nDuration = nCasterLvl / 2;

    if(GetMetaMagicFeat() == METAMAGIC_EXTEND)
        nDuration *= 2;

    if (MyResistSpell(OBJECT_SELF,oTarget) <1)
    {
       DoPetrification(nCasterLvl, OBJECT_SELF, oTarget, GetSpellId(), AR_GetSpellSaveDC(), TurnsToSeconds(nDuration));
    }
}


