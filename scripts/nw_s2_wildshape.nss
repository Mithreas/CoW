//::///////////////////////////////////////////////
//:: Wild Shape
//:: NW_S2_WildShape
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Allows the Druid to change into animal forms.

    Updated: Sept 30 2003, Georg Z.
      * Made Armor merge with druid to make forms
        more useful.

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
#include "inc_divination"
#include "inc_zombie"
#include "inc_totem"
#include "x2_inc_itemprop"
#include "x3_inc_horse"
#include "inc_disguise"

const int POLYMORPH_TYPE_TOTEM_5 = 107;
const int POLYMORPH_TYPE_TOTEM_6 = 108;
const int POLYMORPH_TYPE_TOTEM_7 = 109;
const int POLYMORPH_TYPE_TOTEM_8 = 110;
const int POLYMORPH_TYPE_TOTEM_9 = 111;
const int POLYMORPH_TYPE_TOTEM_10 = 112;
const int POLYMORPH_TYPE_TOTEM_11 = 113;
const int POLYMORPH_TYPE_TOTEM_12 = 114;
const int POLYMORPH_TYPE_TOTEM_13 = 115;
const int POLYMORPH_TYPE_TOTEM_14 = 116;
const int POLYMORPH_TYPE_TOTEM_15 = 117;

const int POLYMORPH_TYPE_DRAGON_5 = 118;
const int POLYMORPH_TYPE_DRAGON_6 = 119;
const int POLYMORPH_TYPE_DRAGON_7 = 120;
const int POLYMORPH_TYPE_DRAGON_8 = 121;
const int POLYMORPH_TYPE_DRAGON_9 = 122;
const int POLYMORPH_TYPE_DRAGON_10 = 123;
const int POLYMORPH_TYPE_DRAGON_11 = 124;
const int POLYMORPH_TYPE_DRAGON_12 = 125;
const int POLYMORPH_TYPE_DRAGON_13 = 126;
const int POLYMORPH_TYPE_DRAGON_14 = 127;
const int POLYMORPH_TYPE_DRAGON_15 = 128;

void main()
{
    //Declare major variables
    int nSpell = GetSpellId();
    object oTarget = OBJECT_SELF;
    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
    effect ePoly;
    int nPoly;
    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = GetLevelByClass(CLASS_TYPE_DRUID);

	if (GetLocalInt(GetModule(), "STATIC_LEVEL"))
	{
      nDuration = GetLocalInt(gsPCGetCreatureHide(OBJECT_SELF), "FL_LEVEL");
	}
	
    // Check for zombification.
    if (fbZGetIsZombie(oTarget))
    {
      if (GetIsPC(oTarget))
      {
        FloatingTextStringOnCreature("You decide you would rather eat some brains instead.", oTarget, FALSE);
      }
      return;
    }

    if (!GetLocalInt(GetModule(),"X3_NO_SHAPESHIFT_SPELL_CHECK"))
    { // check to see if abort due to being mounted
        if (HorseGetIsMounted(oTarget))
        { // abort
            if (GetIsPC(oTarget)) FloatingTextStrRefOnCreature(111982,oTarget,FALSE);
            return;
        } // abort
    } // check to see if abort due to being mounted
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }
	
    int nTimeout = GetLocalInt(OBJECT_SELF, "WATER_TIMEOUT");
	if (GetIsPC(OBJECT_SELF) && gsTIGetActualTimestamp() > nTimeout)
	{
      miDVGivePoints(OBJECT_SELF, ELEMENT_WATER, 8.0);
	  SetLocalInt(OBJECT_SELF, "WATER_TIMEOUT", gsTIGetActualTimestamp() + 15*60);
	}  

    //Determine Polymorph subradial type
    if(nSpell == 401)
    {
        nPoly = POLYMORPH_TYPE_BROWN_BEAR;
        if (nDuration >= 12)
        {
            nPoly = POLYMORPH_TYPE_DIRE_BROWN_BEAR;
        }
    }
    else if (nSpell == 402)
    {
        nPoly = POLYMORPH_TYPE_PANTHER;
        if (nDuration >= 12)
        {
            nPoly = POLYMORPH_TYPE_DIRE_PANTHER;
        }
    }
    else if (nSpell == 403)
    {
        nPoly = POLYMORPH_TYPE_WOLF;

        if (nDuration >= 12)
        {
            nPoly = POLYMORPH_TYPE_DIRE_WOLF;
        }
    }
    else if (nSpell == 404)
    {
        nPoly = POLYMORPH_TYPE_BOAR;
        if (nDuration >= 12)
        {
            nPoly = POLYMORPH_TYPE_DIRE_BOAR;
        }
    }
    else if (nSpell == 405)
    {
        nPoly = POLYMORPH_TYPE_BADGER;
        if (nDuration >= 12)
        {
            nPoly = POLYMORPH_TYPE_DIRE_BADGER;
        }
    }

    int nTotem = miTOGetTotemAnimalTailNumber(OBJECT_SELF);
    if (nTotem)
    {
      int nLevel = GetLevelByClass(CLASS_TYPE_DRUID);
      if (!nLevel) nLevel = GetHitDice(OBJECT_SELF);

      nLevel += miTOGetTotemBonus(OBJECT_SELF);

      if (nLevel < 8)
      {
        nPoly = POLYMORPH_TYPE_TOTEM_5;
      }
      else if (nLevel < 10)
      {
        nPoly = POLYMORPH_TYPE_TOTEM_6;
      }
      else if (nLevel < 12)
      {
        nPoly = POLYMORPH_TYPE_TOTEM_7;
      }
      else if (nLevel < 14)
      {
        nPoly = POLYMORPH_TYPE_TOTEM_8;
      }
      else if (nLevel < 16)
      {
        nPoly = POLYMORPH_TYPE_TOTEM_9;
      }
      else if (nLevel < 18)
      {
        nPoly = POLYMORPH_TYPE_TOTEM_10;
      }
      else if (nLevel < 20)
      {
        nPoly = POLYMORPH_TYPE_TOTEM_11;
      }
      else if (nLevel < 22)
      {
        nPoly = POLYMORPH_TYPE_TOTEM_12;
      }
      else if (nLevel < 24)
      {
        nPoly = POLYMORPH_TYPE_TOTEM_13;
      }
      else if (nLevel < 26)
      {
        nPoly = POLYMORPH_TYPE_TOTEM_14;
      }
      else
      {
        nPoly = POLYMORPH_TYPE_TOTEM_15;
      }

      if (nTotem > 321 && nTotem < 335)
      {
        // Dragon forms have to use a different polymorph.
        nPoly += 11;
      }
    }

    ePoly = EffectPolymorphEx(nPoly);
    ePoly = ExtraordinaryEffect(ePoly);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_WILD_SHAPE, FALSE));

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
    object oGlovesOld  = GetItemInSlot(INVENTORY_SLOT_ARMS,OBJECT_SELF);
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

    if (nDuration)
    {
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, OBJECT_SELF, HoursToSeconds(nDuration));
    }
    else
    {
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, OBJECT_SELF);
    }

    object oWeaponNew = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
    object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR,OBJECT_SELF);

    if (bWeapon)
    {
        IPWildShapeCopyItemProperties(oWeaponOld,oWeaponNew, TRUE);
    }
    if (bArmor)
    {
        IPWildShapeCopyItemProperties(oShield,oArmorNew);
        IPWildShapeCopyItemProperties(oHelmetOld,oArmorNew);
        IPWildShapeCopyItemProperties(oArmorOld,oArmorNew);
    }
    if (bItems)
    {
        IPWildShapeCopyItemProperties(oRing1Old,oArmorNew);
        IPWildShapeCopyItemProperties(oRing2Old,oArmorNew);
        IPWildShapeCopyItemProperties(oAmuletOld,oArmorNew);
        IPWildShapeCopyItemProperties(oCloakOld,oArmorNew);
        IPWildShapeCopyItemProperties(oBootsOld,oArmorNew);
        IPWildShapeCopyItemProperties(oGlovesOld,oArmorNew);
        IPWildShapeCopyItemProperties(oBeltOld,oArmorNew);
    }

    //--------------------------------------------------------------------------
    // Arelith edit - transfer variables and properties from current hide.
    //--------------------------------------------------------------------------
    gsCMCopyPropertiesAndVariables(oSubraceHide, oArmorNew);

    if (nTotem)
    {
      // don't set the tail here - set it in the OnEquip event (otherwise
      // it's lost when the polymorph is reapplied, e.g. on save).
      SetLocalInt(OBJECT_SELF, "TAIL_APPEARANCE", nTotem);
      //SetCreatureTailType(nTotem, OBJECT_SELF);
      SetLocalInt(oArmorNew, MI_TOTEM, GetLocalInt(oSubraceHide, MI_TOTEM));
      if (GetGender(OBJECT_SELF) == GENDER_FEMALE) {
        SetPortraitResRef(OBJECT_SELF, GetTotemSummonPortrait(GetTotem(OBJECT_SELF, FALSE)));
        UpdatePortraitInDB(OBJECT_SELF, GetPortraitResRef(OBJECT_SELF));
      }
    }
}
