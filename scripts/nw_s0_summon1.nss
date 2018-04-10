//::///////////////////////////////////////////////
//:: Summon Monster I
//:: NW_S0_Summon1
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons a dire badger to fight for the character
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12 , 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 25, 2001

#include "mi_inc_spells"
#include "mi_inc_spllswrd"
void main()
{

    /*
      Spellcast Hook Code
      Added 2003-06-23 by GeorgZ
      If you want to make changes to all spells,
      check mi_inc_spells.nss to find out more

    */

        if (!X2PreSpellCastCode())
        {
        // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
            return;
        }

    // End of Spell Cast Hook

	if(miSSGetIsSpellsword(OBJECT_SELF))
	{
		SendMessageToPC(OBJECT_SELF,"You may not summon a creature");
		return;
	}
	
    //Declare major variables
    int nMetaMagic = AR_GetMetaMagicFeat();
    int nDuration = AR_GetCasterLevel(OBJECT_SELF);
    effect eSummon = EffectSummonCreature("NW_S_badgerdire");
    if(GetHasFeat(FEAT_ANIMAL_DOMAIN_POWER))
    {
        eSummon = EffectSummonCreature("NW_S_BOARDIRE");
    }

    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
    //Make metamagic check for extend
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;   //Duration is +100%
    }
    //Apply the VFX impact and summon effect
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), TurnsToSeconds(nDuration));
}

