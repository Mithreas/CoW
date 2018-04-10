//::///////////////////////////////////////////////
//:: Energy Drain
//:: NW_S0_EneDrain.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Target loses 2d4 levels.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
#include "nw_i0_spells"
#include "inc_spells"
#include "mi_inc_spells" 

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


    //Declare major variables
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = AR_GetMetaMagicFeat();
    int nDrain = d4(2);
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
    	nDrain = 8;//Damage is at max
    }
    else if (nMetaMagic == METAMAGIC_EMPOWER)
    {
    	nDrain = nDrain + (nDrain/2); //Damage/Healing is +50%
    }
    effect eDrain = EffectNegativeLevel(nDrain);
    eDrain = SupernaturalEffect(eDrain);
	if(!GetIsReactionTypeFriendly(oTarget))
	{
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ENERGY_DRAIN));
        if(!MyResistSpell(OBJECT_SELF, oTarget))
        {
            if(!MySavingThrow(SAVING_THROW_FORT, oTarget, AR_GetSpellSaveDC(), SAVING_THROW_TYPE_NEGATIVE))
            {
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDrain, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
    }
}

