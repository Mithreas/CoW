/*
 * inc_favsoul
 *
 * Favored Soul related library.
 *
 * Favored Soul is a path for Bards.
 * - Lose Bard Song (and Curse Song etc)
 * - gain Arcane Spell Failure reduction (can cast in armor and shield)
 * - gain Turn Undead
 * - Religious class - needs to follow deity alignment restrictions
 * - Gain Raise Dead as a subrace ability.
 */
#include "gs_inc_pc"
#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"

// Returns TRUE if the PC has the Favored Soul subclass/path.
int miFSGetIsFavoredSoul(object oPC);
// Apply favored soul abilities.
void miFSApplyFavoredSoul(object oPC);
// Add ASF reduction property to oItem (used OnEquip)
void miFSApplyASFReduction(object oItem);
// Remove ASF reduction property from oItem (used OnEquip)
void miFSRemoveASFReduction(object oItem);

const string VAR_FAV_SOUL = "MI_FS_IS_FAV_SOUL";

int miFSGetIsFavoredSoul(object oPC)
{
  object oHide = gsPCGetCreatureHide(oPC);
  return GetLocalInt(oHide, VAR_FAV_SOUL);
}
//----------------------------------------------------------------------------------------------
void miFSApplyFavoredSoul(object oPC)
{
  if (!miFSGetIsFavoredSoul(oPC)) return;

  // Remove bard song feats.
  NWNX_Creature_RemoveFeat(oPC, FEAT_BARD_SONGS);
  NWNX_Creature_RemoveFeat(oPC, 355);
  NWNX_Creature_RemoveFeat(oPC, 356);
  NWNX_Creature_RemoveFeat(oPC, 357);
  NWNX_Creature_RemoveFeat(oPC, 358);
  NWNX_Creature_RemoveFeat(oPC, 359);
  NWNX_Creature_RemoveFeat(oPC, 360);
  NWNX_Creature_RemoveFeat(oPC, 361);
  NWNX_Creature_RemoveFeat(oPC, 362);
  NWNX_Creature_RemoveFeat(oPC, 363);
  NWNX_Creature_RemoveFeat(oPC, 364);
  NWNX_Creature_RemoveFeat(oPC, 365);
  NWNX_Creature_RemoveFeat(oPC, 366);
  NWNX_Creature_RemoveFeat(oPC, 367);
  NWNX_Creature_RemoveFeat(oPC, 368);
  NWNX_Creature_RemoveFeat(oPC, 369);
  NWNX_Creature_RemoveFeat(oPC, 370);
  NWNX_Creature_RemoveFeat(oPC, 371);
  NWNX_Creature_RemoveFeat(oPC, 372);
  NWNX_Creature_RemoveFeat(oPC, 373);
  
  NWNX_Creature_RemoveFeat(oPC, 197); // Bardic knowledge

  // Add Turn Undead - doesn't work without client side override.
  //if (!GetKnowsFeat(FEAT_TURN_UNDEAD, oPC)) AddKnownFeat(oPC, FEAT_TURN_UNDEAD, GetHitDice(oPC));

  object oItem = GetItemPossessedBy(oPC, "GS_SU_ABILITY");
  if (GetIsObjectValid(oItem))
  {
        IPSafeAddItemProperty(oItem,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_RAISE_DEAD_9,
                                              IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE),
                        0.0f);
  }
}
//----------------------------------------------------------------------------------------------
void miFSApplyASFReduction(object oItem)
{
  int nReduction = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_20_PERCENT;
  if (miFSGetIsFavoredSoul(GetItemPossessor(oItem))) nReduction = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_50_PERCENT;

  switch (GetBaseItemType(oItem))
  {
    case BASE_ITEM_ARMOR:
	case BASE_ITEM_TOWERSHIELD:
	case BASE_ITEM_LARGESHIELD:
	case BASE_ITEM_SMALLSHIELD:
	{
	  IPSafeAddItemProperty(oItem,
                            ItemPropertyArcaneSpellFailure(nReduction),
                            72000.0f);	// 30 hours  
	  break;
	}
  }
  
  return;
}
//----------------------------------------------------------------------------------------------
void miFSRemoveASFReduction(object oItem)
{
  switch (GetBaseItemType(oItem))
  {
    case BASE_ITEM_ARMOR:
	case BASE_ITEM_TOWERSHIELD:
	case BASE_ITEM_LARGESHIELD:
	case BASE_ITEM_SMALLSHIELD:
	{
      itemproperty iprop = GetFirstItemProperty(oItem);
	  
	  while (GetIsItemPropertyValid(iprop))
	  {
	    if (GetItemPropertyType(iprop) == ITEM_PROPERTY_ARCANE_SPELL_FAILURE &&
		    GetItemPropertyDurationType(iprop) == DURATION_TYPE_TEMPORARY)
		{
		  RemoveItemProperty(oItem, iprop);
		}		
		
		iprop = GetNextItemProperty(oItem);
	  }
	  
	  break;
	}
  }
  
  return;
}
//----------------------------------------------------------------------------------------------
