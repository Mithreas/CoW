//::///////////////////////////////////////////////
//:: Polymorph Self
//:: NW_S0_PolySelf.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The PC is able to changed their form to one of
    several forms.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 21, 2002
//:://////////////////////////////////////////////

#include "inc_combat"
#include "inc_common"
#include "inc_customspells"

const int SPELL_POLYMORPH_OTHER = 865;

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

    //Declare major variables
    int nSpell = GetSpellId();
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
    effect ePoly;
    int nPoly;
    int nMetaMagic = AR_GetMetaMagicFeat();
    int nDuration = AR_GetCasterLevel(OBJECT_SELF);
	int bHostile = !GetIsReactionTypeFriendly(oTarget, OBJECT_SELF);
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }
	
	if (GetLocalInt(oTarget, "onspawn_freeze"))
	{
	    FloatingTextStringOnCreature("You cannot polymorph a statue.", OBJECT_SELF);
		return;
	}
	else if (GetPlotFlag(oTarget) == TRUE)
	{
	    FloatingTextStringOnCreature("Some creatures cannot be polymorphed.", OBJECT_SELF);
		return;
	}
	
    int nTimeout = GetLocalInt(OBJECT_SELF, "WATER_TIMEOUT");
	if (GetIsPC(OBJECT_SELF) && gsTIGetActualTimestamp() > nTimeout)
	{
      miDVGivePoints(OBJECT_SELF, ELEMENT_WATER, 8.0);
	  SetLocalInt(OBJECT_SELF, "WATER_TIMEOUT", gsTIGetActualTimestamp() + 15*60);
	}  	
	
	// Additional Stamina cost - polymorphing is exhausting. 
	gsSTDoCasterDamage(OBJECT_SELF, 7);

    // Save for hostile.
	if (bHostile)
	{
	  if (GetIsReactionTypeNeutral(oTarget, OBJECT_SELF))
	  {
	    SetIsTemporaryEnemy(OBJECT_SELF, oTarget, TRUE, 180.0f);
		AssignCommand(oTarget, gsCBDetermineCombatRound(OBJECT_SELF));
	  }
	  
	  if (MyResistSpell(OBJECT_SELF,oTarget) ||
	      MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC()))
	  {
	    // Saved!
		return;
	  }
	  
	  if (gsC2GetHasEffect(EFFECT_TYPE_POLYMORPH, oTarget, TRUE))
	  {
	    FloatingTextStringOnCreature("You cannot polymorph a polymorphed enemy.", OBJECT_SELF);
		return;
	  }
	}
	
	//Determine Polymorph subradial type
    if(nSpell == 866)
    {
        nPoly = POLYMORPH_TYPE_DIRE_BROWN_BEAR;
    }
    else if (nSpell == 867)
    {
        nPoly = POLYMORPH_TYPE_WOLF;
    }
    else if (nSpell == 868)
    {
        nPoly = POLYMORPH_TYPE_CHICKEN;
    }
    else if (nSpell == 869)
    {
        nPoly = 134; //POLYMORPH_TYPE_RAT;
    }
    else if (nSpell == 870)
    {
        nPoly = POLYMORPH_TYPE_PENGUIN;
    }
    ePoly = EffectPolymorphEx(nPoly, bHostile, oTarget);
		
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_POLYMORPH_OTHER, FALSE));

    //--------------------------------------------------------------------------
    // Arelith edit - save off the current creature skin so we can apply
    // properties across.
    //--------------------------------------------------------------------------
    object oSubraceHide = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oTarget);

    //Apply the VFX impact and effects
    AssignCommand(oTarget, ClearAllActions()); // prevents an exploit
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	if (bHostile)
	{
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oTarget, RoundsToSeconds(nDuration));
	}
	else
	{
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oTarget, HoursToSeconds(nDuration));
	}
    //--------------------------------------------------------------------------
    // Arelith edit - transfer variables and properties from current hide.
    //--------------------------------------------------------------------------
    object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oTarget);
    gsCMCopyPropertiesAndVariables(oSubraceHide, oArmorNew);
}

