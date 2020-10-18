//::///////////////////////////////////////////////
//:: Elemental Shape
//:: NW_S2_ElemShape
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Allows the Druid to change into elemental forms.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 22, 2002
//:://////////////////////////////////////////////
//:: Modified By: Deva Winblood
//:: Modified Date: January 15th-16th, 2008
//:://////////////////////////////////////////////
/*
    Modified to insure no shapeshifting spells are castable upon
    mounted targets.  This prevents problems that can occur due
    to dismounting after shape shifting, or other issues that can
    occur due to preserved appearances getting out of synch.

    This can additional check can be disabled by setting the variable
    X3_NO_SHAPESHIFT_SPELL_CHECK to 1 on the module object.  If this
    variable is set then this script will function as it did prior to
    this modification.

*/

#include "inc_zombie"
#include "inc_common"
#include "x2_inc_itemprop"
#include "x3_inc_horse"

const int POLYMORPH_TYPE_MONOLITH_FIRE_ELEMENTAL    = 129;
const int POLYMORPH_TYPE_MONOLITH_WATER_ELEMENTAL   = 130;
const int POLYMORPH_TYPE_MONOLITH_EARTH_ELEMENTAL   = 131;
const int POLYMORPH_TYPE_MONOLITH_AIR_ELEMENTAL     = 132;


void main()
{
    //Declare major variables
    int nSpell = GetSpellId();
    object oTarget = GetSpellTargetObject();

    // Check for zombification.
    if (fbZGetIsZombie(oTarget))
    {
      if (GetIsPC(oTarget))
      {
        FloatingTextStringOnCreature("You decide you would rather eat some brains instead.", oTarget, FALSE);
      }
      return;
    }

    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
    effect ePoly;
    int nPoly;
    int nDuration = GetLevelByClass(CLASS_TYPE_DRUID); //GetCasterLevel(OBJECT_SELF);
    int bElder = FALSE;
    int bMonol = FALSE;
    int nTier  = 1;
	
    if (!GetLocalInt(GetModule(),"X3_NO_SHAPESHIFT_SPELL_CHECK"))
    { // check to see if abort due to being mounted
        if (HorseGetIsMounted(oTarget))
        { // abort
            if (GetIsPC(oTarget)) FloatingTextStrRefOnCreature(111982,oTarget,FALSE);
            return;
        } // abort
    } // check to see if abort due to being mounted


    if(GetLevelByClass(CLASS_TYPE_DRUID) >= 28) {
        bMonol = TRUE;
    }
    else if(GetLevelByClass(CLASS_TYPE_DRUID) >= 20) {
        bElder = TRUE;
    }

	//-----------------------------------------------------------------
    // Check for attunement (formed via a pact with a spirit). 
	// Strength currently unused here but pulled for future expansion.
	// If attuned, you can't transform to the opposite elemental. 
    //-----------------------------------------------------------------
    object oHide = gsPCGetCreatureHide(OBJECT_SELF);
    int nAttunement = 0;
    int nStrength = 0;
    if (GetIsObjectValid(oHide)) 
    {
      nAttunement = GetLocalInt(oHide, "ATTUNEMENT");
	  nStrength = GetLocalInt(oHide, "ATTUNEMENT_STRENGTH");
    }
    else
    {
      nAttunement = GetLocalInt(OBJECT_SELF, "ATTUNEMENT");
	  nStrength = GetLocalInt(OBJECT_SELF, "ATTUNEMENT_STRENGTH");
    }

    //::  Remove Auras
    gsSPRemoveEffect(OBJECT_SELF, 761, OBJECT_SELF);    //::  Hellfire Aura
    gsSPRemoveEffect(OBJECT_SELF, 196, OBJECT_SELF);    //::  Aura of Cold
    gsSPRemoveEffect(OBJECT_SELF, 202, OBJECT_SELF);    //::  Aura of Stun

    //::  Determine Polymorph subradial type
    //::  Level 16+ Druid (Huge Elementals)
    if( bElder == FALSE && bMonol == FALSE )
    {
        nTier = 1;
        if(nSpell == 397)
        {
            nPoly = POLYMORPH_TYPE_HUGE_FIRE_ELEMENTAL;
			if (nAttunement == SPELL_SCHOOL_EVOCATION) nPoly = POLYMORPH_TYPE_ELDER_FIRE_ELEMENTAL;
			if (nAttunement == SPELL_SCHOOL_TRANSMUTATION) nPoly = POLYMORPH_TYPE_ELDER_WATER_ELEMENTAL;
        }
        else if (nSpell == 398)
        {
            nPoly = POLYMORPH_TYPE_HUGE_WATER_ELEMENTAL;
			if (nAttunement == SPELL_SCHOOL_TRANSMUTATION) nPoly = POLYMORPH_TYPE_ELDER_WATER_ELEMENTAL;
			if (nAttunement == SPELL_SCHOOL_EVOCATION) nPoly = POLYMORPH_TYPE_ELDER_FIRE_ELEMENTAL;
        }
        else if (nSpell == 399)
        {
            nPoly = POLYMORPH_TYPE_HUGE_EARTH_ELEMENTAL;
			if (nAttunement == SPELL_SCHOOL_ENCHANTMENT) nPoly = POLYMORPH_TYPE_ELDER_EARTH_ELEMENTAL;
			if (nAttunement == SPELL_SCHOOL_ILLUSION) nPoly = POLYMORPH_TYPE_ELDER_AIR_ELEMENTAL;
        }
        else if (nSpell == 400)
        {
            nPoly = POLYMORPH_TYPE_HUGE_AIR_ELEMENTAL;
			if (nAttunement == SPELL_SCHOOL_ILLUSION) nPoly = POLYMORPH_TYPE_ELDER_AIR_ELEMENTAL;
			if (nAttunement == SPELL_SCHOOL_ENCHANTMENT) nPoly = POLYMORPH_TYPE_ELDER_EARTH_ELEMENTAL;
        }
    }
    //::  Level 20+ Druid (Ancient Elementals)
    else if( bElder )
    {
        nTier = 2;
        if(nSpell == 397)
        {
            nPoly = POLYMORPH_TYPE_ELDER_FIRE_ELEMENTAL;
        }
        else if (nSpell == 398)
        {
            nPoly = POLYMORPH_TYPE_ELDER_WATER_ELEMENTAL;
        }
        else if (nSpell == 399)
        {
            nPoly = POLYMORPH_TYPE_ELDER_EARTH_ELEMENTAL;
        }
        else if (nSpell == 400)
        {
            nPoly = POLYMORPH_TYPE_ELDER_AIR_ELEMENTAL;
        }
    }
    //::  Level 28+ Druid (Monolithic Elementals)
    else {
        nTier = 3;
        if(nSpell == 397)
        {
            nPoly = POLYMORPH_TYPE_MONOLITH_FIRE_ELEMENTAL;
            SetLocalInt(OBJECT_SELF, "TAIL_APPEARANCE", 344);
        }
        else if (nSpell == 398)
        {
            nPoly = POLYMORPH_TYPE_MONOLITH_WATER_ELEMENTAL;
            SetLocalInt(OBJECT_SELF, "TAIL_APPEARANCE", 346);
        }
        else if (nSpell == 399)
        {
            nPoly = POLYMORPH_TYPE_MONOLITH_EARTH_ELEMENTAL;
            SetLocalInt(OBJECT_SELF, "TAIL_APPEARANCE", 338);
        }
        else if (nSpell == 400)
        {
            nPoly = POLYMORPH_TYPE_MONOLITH_AIR_ELEMENTAL;
            SetLocalInt(OBJECT_SELF, "TAIL_APPEARANCE", 340);
        }
    }

    int nTimeout = GetLocalInt(OBJECT_SELF, "ESHAPE_TIMEOUT");
	if (GetIsPC(OBJECT_SELF) && gsTIGetActualTimestamp() > nTimeout)
	{
	  SetLocalInt(OBJECT_SELF, "ESHAPE_TIMEOUT", gsTIGetActualTimestamp() + 15*60);
	  
      switch (nPoly)
	  {
	    case POLYMORPH_TYPE_HUGE_WATER_ELEMENTAL:
	    case POLYMORPH_TYPE_ELDER_WATER_ELEMENTAL:
	    case POLYMORPH_TYPE_MONOLITH_WATER_ELEMENTAL:
	      miDVGivePoints(OBJECT_SELF, ELEMENT_WATER, 10.0f);
		  break;
	    case POLYMORPH_TYPE_HUGE_EARTH_ELEMENTAL:
	    case POLYMORPH_TYPE_ELDER_EARTH_ELEMENTAL:
	    case POLYMORPH_TYPE_MONOLITH_EARTH_ELEMENTAL:
	      miDVGivePoints(OBJECT_SELF, ELEMENT_EARTH, 10.0f);
		  break;
	    case POLYMORPH_TYPE_HUGE_FIRE_ELEMENTAL:
	    case POLYMORPH_TYPE_ELDER_FIRE_ELEMENTAL:
	    case POLYMORPH_TYPE_MONOLITH_FIRE_ELEMENTAL:
	      miDVGivePoints(OBJECT_SELF, ELEMENT_FIRE, 10.0f);
		  break;
	    case POLYMORPH_TYPE_HUGE_AIR_ELEMENTAL:
	    case POLYMORPH_TYPE_ELDER_AIR_ELEMENTAL:
	    case POLYMORPH_TYPE_MONOLITH_AIR_ELEMENTAL:
	      miDVGivePoints(OBJECT_SELF, ELEMENT_AIR, 10.0f);
		  break;
	  }
    }
	
    ePoly = EffectPolymorphEx(nPoly, FALSE, OBJECT_SELF);
    ePoly = ExtraordinaryEffect(ePoly);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_ELEMENTAL_SHAPE, FALSE));

    int bWeapon = StringToInt(Get2DAString("polymorph","MergeW",nPoly)) == 1;
    int bArmor  = StringToInt(Get2DAString("polymorph","MergeA",nPoly)) == 1;
    int bItems  = StringToInt(Get2DAString("polymorph","MergeI",nPoly)) == 1;

    object oWeaponOld = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
    object oArmorOld = GetItemInSlot(INVENTORY_SLOT_CHEST,OBJECT_SELF);
    object oRing1Old = GetItemInSlot(INVENTORY_SLOT_LEFTRING,OBJECT_SELF);
    object oRing2Old = GetItemInSlot(INVENTORY_SLOT_RIGHTRING,OBJECT_SELF);
    object oAmuletOld = GetItemInSlot(INVENTORY_SLOT_NECK,OBJECT_SELF);
    object oCloakOld  = GetItemInSlot(INVENTORY_SLOT_CLOAK,OBJECT_SELF);
    object oBootsOld  = GetItemInSlot(INVENTORY_SLOT_BOOTS,OBJECT_SELF);
    object oBeltOld = GetItemInSlot(INVENTORY_SLOT_BELT,OBJECT_SELF);
    object oHelmetOld = GetItemInSlot(INVENTORY_SLOT_HEAD,OBJECT_SELF);
    object oShield    = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,OBJECT_SELF);
    if (GetIsObjectValid(oShield))
    {
        if (GetBaseItemType(oShield) !=BASE_ITEM_LARGESHIELD &&
            GetBaseItemType(oShield) !=BASE_ITEM_SMALLSHIELD &&
            GetBaseItemType(oShield) !=BASE_ITEM_TOWERSHIELD)
        {
            oShield = OBJECT_INVALID;
        }
    }

    //--------------------------------------------------------------------------
    // Arelith edit - save off the current creature skin so we can apply
    // properties across.
    //--------------------------------------------------------------------------
    object oSubraceHide = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oTarget);

    //Apply the VFX impact and effects
    ClearAllActions(); // prevents an exploit
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, OBJECT_SELF, HoursToSeconds(nDuration));

    if ( bMonol ) {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_NATURES_BALANCE), OBJECT_SELF);

        if ( nPoly == POLYMORPH_TYPE_MONOLITH_EARTH_ELEMENTAL) {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SCREEN_SHAKE), OBJECT_SELF);
        }
        else if ( nPoly == POLYMORPH_TYPE_MONOLITH_FIRE_ELEMENTAL) {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_FIRESTORM), OBJECT_SELF);
        }
        else if ( nPoly == POLYMORPH_TYPE_MONOLITH_AIR_ELEMENTAL) {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1), OBJECT_SELF);
        }
    }

    object oWeaponNew = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
    object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR,OBJECT_SELF);

    if (bWeapon)
    {
            IPWildShapeCopyItemProperties(oWeaponOld,oWeaponNew, TRUE);
    }
    if (bArmor)
    {
        IPWildShapeCopyItemProperties(oHelmetOld,oArmorNew);
        IPWildShapeCopyItemProperties(oArmorOld,oArmorNew);
        IPWildShapeCopyItemProperties(oShield,oArmorNew);
    }
    if (bItems)
    {
        IPWildShapeCopyItemProperties(oRing1Old,oArmorNew);
        IPWildShapeCopyItemProperties(oRing2Old,oArmorNew);
        IPWildShapeCopyItemProperties(oAmuletOld,oArmorNew);
        IPWildShapeCopyItemProperties(oCloakOld,oArmorNew);
        IPWildShapeCopyItemProperties(oBootsOld,oArmorNew);
        IPWildShapeCopyItemProperties(oBeltOld,oArmorNew);
    }


    //--------------------------------------------------------------------------
    // Arelith edit - transfer variables and properties from current hide.
    //--------------------------------------------------------------------------
    gsCMCopyPropertiesAndVariables(oSubraceHide, oArmorNew);
}
