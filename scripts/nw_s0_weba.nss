//::///////////////////////////////////////////////
//:: Web: On Enter
//:: NW_S0_WebA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a mass of sticky webs that cling to
    and entangle targets who fail a Reflex Save
    Those caught can make a new save every
    round.  Movement in the web is 1/5 normal.
    The higher the creatures Strength the faster
    they move within the web.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 8, 2001
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "inc_customspells"
#include "inc_spells"

int GetHasWebImmunity(object oCreature)
{
  object oHide = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
  if (!GetIsObjectValid(oHide)) return FALSE;
  
  itemproperty iProp = GetFirstItemProperty(oHide);
  while (GetIsItemPropertyValid(iProp))
  {
    if (GetItemPropertyType(iProp) == ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL &&
	    GetItemPropertyCostTableValue(iProp) == IP_CONST_IMMUNITYSPELL_WEB)
		return TRUE;
   
    iProp = GetNextItemProperty(oHide);
  }
  
  return FALSE;
}

void main()
{

    //Declare major variables
    effect eWeb = EffectEntangle();
    effect eVis = EffectVisualEffect(VFX_DUR_WEB);
    effect eLink = EffectLinkEffects(eWeb, eVis);
    object oTarget = GetEnteringObject();
    int nDC = GetSpellSaveDC();

	if (oTarget == GetAreaOfEffectCreator())
	{
	  // Casters are immune to their own Web spell. 		  
	  return;
	}	

    if(GetAoEId(OBJECT_SELF) == SPELL_GREATER_SHADOW_CONJURATION_WEB)
    {
        nDC = AdjustSpellDCForSpellSchool(nDC, SPELL_SCHOOL_ILLUSION, SPELL_WEB, GetAreaOfEffectCreator());
    }
		
    // * the lower the number the faster you go
    int nSlow = 65 - (GetAbilityScore(oTarget, ABILITY_STRENGTH)*2);
    if (nSlow <= 0)
    {
        nSlow = 1;
    }

    if (nSlow > 99)
    {
        nSlow = 99;
    }

    effect eSlow = EffectMovementSpeedDecrease(nSlow);
	
	if(!GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget) &&
	   (GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL) != TRUE)  && 
		!GetIsImmune(oTarget, IMMUNITY_TYPE_ENTANGLE) && 
		!GetHasWebImmunity(oTarget))
	{
		//Fire cast spell at event for the target
		SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_WEB));
		//Spell resistance check

		//Make a Fortitude Save to avoid the effects of the entangle.
		if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC))
		{
			//Entangle effect and Web VFX impact
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1));
		}
		
		//Slow down the creature within the Web
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSlow, oTarget);
   }

}
