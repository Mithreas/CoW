//::///////////////////////////////////////////////
//:: Summon Monster IX
//:: NW_S0_Summon9
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons a elder elemental to fight for the character
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 25, 2001

#include "inc_customspells"
#include "inc_spellsword"
void main()
{

     /*
      Spellcast Hook Code
      Added 2003-06-23 by GeorgZ
      If you want to make changes to all spells,
      check inc_customspells.nss to find out more

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
    effect eSummon;
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);
    int nRoll = d4();
    switch (nRoll)
    {
        case 1:
            eSummon = EffectSummonCreature("NW_S_AIRELDER");
        break;

        case 2:
            eSummon = EffectSummonCreature("NW_S_WATERELDER");
        break;

        case 3:
            eSummon = EffectSummonCreature("NW_S_EARTHELDER");
        break;

        case 4:
            eSummon = EffectSummonCreature("NW_S_FIREELDER");
        break;
    }
    //Make metamagic check for extend
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;   //Duration is +100%
    }
    //Apply the VFX impact and summon effect
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), TurnsToSeconds(nDuration));
}
