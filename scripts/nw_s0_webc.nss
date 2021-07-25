//::///////////////////////////////////////////////
//:: Web: Heartbeat
//:: NW_S0_WebC.nss
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
#include "inc_state"

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
    object oTarget;
    int nDC = GetSpellSaveDC();

    if(GetAoEId(OBJECT_SELF) == SPELL_GREATER_SHADOW_CONJURATION_WEB)
    {
        nDC = AdjustSpellDCForSpellSchool(nDC, SPELL_SCHOOL_ILLUSION, SPELL_WEB, GetAreaOfEffectCreator());
    }	

    //Spell resistance check
    oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget))
    {
		if (oTarget == GetAreaOfEffectCreator())
		{
		  // Casters are immune to their own Web spell. 		  
		}	
        else if(!GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget) && 
		        (GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL) != TRUE) && 
				!GetIsImmune(oTarget, IMMUNITY_TYPE_ENTANGLE) && 
				!GetHasWebImmunity(oTarget))
        {
			//Fire cast spell at event for the target
			SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_WEB));
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_WEB));

			//Make a Fortitude Save to avoid the effects of the entangle.
			if(!/*Reflex Save*/ MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC))
			{
				//Entangle effect and Web VFX impact
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWeb, oTarget, RoundsToSeconds(1));
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, RoundsToSeconds(1));
				
				// Anemoi: drain stamina.
				SendMessageToPC(oTarget, "Struggling in the web is exhausting!");
				gsSTAdjustState(GS_ST_STAMINA, -10.0f, oTarget);
			}
			else
			{
				SendMessageToPC(oTarget, "You battle through the web.");
				gsSTAdjustState(GS_ST_STAMINA, -5.0f, oTarget);
			}

        }
        oTarget = GetNextInPersistentObject();
    }
}
