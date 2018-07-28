/* CRAFT library by Gigaschatten, cut down for Anemoi crafting */

#include "cnr_recipe_utils"
#include "inc_iprop"

//void main() {}

const int GS_CR_FL_MAX_ITEM_VALUE     = 100000;

int gsCRGetRacialCraftingBonus(object oPC, int nSkill);
// Uses item base type, material and property type to return the appropriate craft skill
// NB: currently set up for FL only.
int gsCRGetCraftSkillByItemType(object oItem, int bMundaneProperty);
// Get the multiplier for nMaterial.  Materials have a mundane and a magical
// multiplier that determine how easy they are to improve by mundane or magical
// means.
int gsCRGetMaterialMultiplier(int nMaterial, int bMundaneProperty = TRUE);
// Return the skill bonus for any bonus (gem) properties on the item.  e.g.
// an amethyst ring gives you +3 to your effective skill while adding properties
// to the ring. 
int gsCRGetMaterialSkillBonus(object oItem);
// Used to adjust the actual value of an item based on the PC's craft skill,
// and the item's material.
float gsCRGetCraftingCostMultiplier(object oPC, object oItem, itemproperty ip);
// Returns TRUE if nIP is permitted on oItem.  On FL, adds restrictions based
// on material.
int gsCRGetIsValid(object oItem, int nProperty);
// Returns TRUE if an essence application attempt was successful.  On FL, this
// can fail if the material isn't magically attuned enough.
int gsCRGetEssenceApplySuccess(object oItem);
// Returns the base gold cost of an item based on its material property.
// Used for the FL crafting system to disregard base cost when assessing the
// item value cap.
int gsCRGetMaterialBaseValue(object oItem);

//----------------------------------------------------------------

//------------------------------------------------------------------------------
int gsCRGetCraftSkillByItemType(object oItem, int bMundaneProperty)
{
  int nType = GetBaseItemType(oItem);
  int nRetVal = CNR_TRADESKILL_JEWELRY; // Default to jewelry

  switch (nType)
  {
    case BASE_ITEM_ARMOR:
      nRetVal = CNR_TRADESKILL_ARMOR_CRAFTING;
      break;
    case BASE_ITEM_LARGESHIELD:
    case BASE_ITEM_TOWERSHIELD:
    case BASE_ITEM_SMALLSHIELD:
      nRetVal = (bMundaneProperty ? CNR_TRADESKILL_ARMOR_CRAFTING : CNR_TRADESKILL_INVESTING);
	  break;
    case BASE_ITEM_ARROW:
    case BASE_ITEM_BOLT:
    case BASE_ITEM_HEAVYCROSSBOW:
    case BASE_ITEM_LIGHTCROSSBOW:
    case BASE_ITEM_LONGBOW:
    case BASE_ITEM_MAGICSTAFF:
    case BASE_ITEM_QUARTERSTAFF:
    case BASE_ITEM_SHORTBOW:
      nRetVal = (bMundaneProperty ? CNR_TRADESKILL_WOOD_CRAFTING : CNR_TRADESKILL_IMBUING);
      break;
    case BASE_ITEM_BASTARDSWORD:
    case BASE_ITEM_BATTLEAXE:
    case BASE_ITEM_BRACER:
    case BASE_ITEM_BULLET:
    case BASE_ITEM_CLUB:
    case BASE_ITEM_DAGGER:
    case BASE_ITEM_DART:
    case BASE_ITEM_DIREMACE:
    case BASE_ITEM_DOUBLEAXE:
    case BASE_ITEM_DWARVENWARAXE:
    case BASE_ITEM_GREATAXE:
    case BASE_ITEM_GREATSWORD:
    case BASE_ITEM_HALBERD:
    case BASE_ITEM_HANDAXE:
    case BASE_ITEM_HEAVYFLAIL:
    case BASE_ITEM_HELMET:
    case BASE_ITEM_KAMA:
    case BASE_ITEM_KATANA:
    case BASE_ITEM_KUKRI:
    case BASE_ITEM_LIGHTFLAIL:
    case BASE_ITEM_LIGHTHAMMER:
    case BASE_ITEM_LIGHTMACE:
    case BASE_ITEM_LONGSWORD:
    case BASE_ITEM_MORNINGSTAR:
    case BASE_ITEM_RAPIER:
    case BASE_ITEM_SCIMITAR:
    case BASE_ITEM_SCYTHE:
    case BASE_ITEM_SHORTSPEAR:
    case BASE_ITEM_SHORTSWORD:
    case BASE_ITEM_SHURIKEN:
    case BASE_ITEM_SICKLE:
    case BASE_ITEM_THROWINGAXE:
    case BASE_ITEM_TRIDENT:
    case BASE_ITEM_TWOBLADEDSWORD:
    case BASE_ITEM_WARHAMMER:
      nRetVal = (bMundaneProperty ? CNR_TRADESKILL_WEAPON_CRAFTING : CNR_TRADESKILL_IMBUING);
      break;
    case BASE_ITEM_BELT:
    case BASE_ITEM_BOOTS:
    case BASE_ITEM_CLOAK:
    case BASE_ITEM_GLOVES:
    case BASE_ITEM_SLING:
    case BASE_ITEM_WHIP:
      nRetVal = (bMundaneProperty ? CNR_TRADESKILL_TAILORING: CNR_TRADESKILL_INVESTING);
      break;
	case BASE_ITEM_RING:
	case BASE_ITEM_AMULET:
	  nRetVal = (bMundaneProperty ? CNR_TRADESKILL_JEWELRY : CNR_TRADESKILL_INVESTING);
	  break;
  }

  return nRetVal;
}
//------------------------------------------------------------------------------
int gsCRGetMaterialMultiplier(int nMaterial, int bMundaneProperty = TRUE)
{
  int nMaterialBonus = 1;

  if (bMundaneProperty)
  {
    switch (nMaterial)
    {
      case 3: // bronze
      case 13: // silver
      case 17: // hide
      case 36: // wool
      case 38: // ironwood
        nMaterialBonus = 2;
        break;
      case 9: // iron
      case 20: // wyvern
      case 21: // dragonhides
      case 22:
      case 23:
      case 24:
      case 25:
      case 26:
      case 27:
      case 28: // dragonhide (red)
      case 29:
      case 30: // dragonhides
      case 31: // leather
      case 39: // duskwood
        nMaterialBonus = 3;
        break;
      case 11: // mithril
      case 15: // steel
      case 32: // ankheg (scale)
      case 40: // duskwood from Zalantar
        nMaterialBonus = 4;
        break;

    }
  }
  else
  {
    switch (nMaterial)
    {
      case 13: // silver
      case 32: // ankheg (scale)
      case 36: // wool
      case 38: // ironwood
        nMaterialBonus = 2;
        break;
      case 8: // gold
      case 11: // mithril
      case 20: // wyvern
      case 21: // dragonhides
      case 22:
      case 23:
      case 24:
      case 25:
      case 26:
      case 27:
      case 28: // dragonhide (red)
      case 29:
      case 35: // silk
      case 30: // dragonhides
      case 39: // duskwood
      case 40: // duskwood from Zalantar
        nMaterialBonus = 3;
        break;
    }
  }

  return nMaterialBonus;
}
//------------------------------------------------------------------------------
int gsCRGetMaterialSkillBonus(object oItem)
{
  int nMaterial = gsIPGetBonusMaterialType(oItem);
  int nBonus    = 0;
  
  switch (nMaterial)
  {
    case 61: // Fire Agate
	case 65: // Greenstone
	case 68: // Malachite
	  nBonus = 1;
	  break;
	case 54: // Aventurine
	case 70: // Phenalope
	  nBonus = 2;
	  break;
	case 53: // Amethyst
	case 63: // Fluorspar
	  nBonus = 3;
	  break;
	case 52: // Alexandrite
	case 64: // Garnet
	  nBonus = 4;
	  break;
	case 75: // Topaz
	  nBonus = 5; 
	  break;
	case 73: // Sapphire
	  nBonus = 6;
	  break;
	case 62: // Fire Opal
	  nBonus = 7;
	  break;
	case 59: // Diamond
	  nBonus = 8;
	  break;
	case 72: // Ruby
	  nBonus = 9;
	  break;
	case 60: // Emerald
	  nBonus = 6;
	  break;
  }
  
  return nBonus;
}

//------------------------------------------------------------------------------
float gsCRGetCraftingCostMultiplier(object oPC, object oItem, itemproperty ip)
{  
  int nMaterial = gsIPGetMaterialType(oItem);
  int nMundaneProperty = gsIPGetIsMundaneProperty(GetItemPropertyType(ip), GetItemPropertySubType(ip));
  int nMaterialBonus = gsCRGetMaterialMultiplier(nMaterial, nMundaneProperty);

  // Scale cost by craft skill level and item type.
  int nXP = CnrGetTradeskillXPByType(oPC, gsCRGetCraftSkillByItemType(oItem, nMundaneProperty));
  int nSkill = CnrDetermineTradeskillLevel(nXP);
  if (nSkill < 3) nSkill = 3;
  
  // Bonus material.
  nSkill += gsCRGetMaterialSkillBonus(oItem);

  float fMiscBonus = 1.0f;

  if (nMaterial == 7 && nMundaneProperty)  // Darksteel, Ondaran
  {
    fMiscBonus = 0.5f;  // Make mundane work twice as expensive.  
  }
 
  // Higher grade materials can be improved more easily.  Higher skill PCs
  // can improve items more easily.  With 15 skill and a master quality item
  // (x4) you can get to 120,000gp value rather than the usual 10,000.
  // With 5 skill and item quality 1, your value is unchanged.
  return (5.0 / (IntToFloat(nMaterialBonus) * IntToFloat(nSkill) * fMiscBonus));
}

int gsCRGetIsValid(object oItem, int nProperty)
{
  if (!GetLocalInt(GetModule(), "STATIC_LEVEL"))
  {
    return gsIPGetIsValid(oItem, nProperty);
  }
  else
  {
    // Note - use this code for more fine grained control over which properties go on
	// which items.  Need to replace the values in itempropsdef.2da with bitwise flags
	// per craft skill.
    int nCraftSkill = gsCRGetCraftSkillByItemType(oItem, gsIPGetIsMundaneProperty(nProperty, 0));
    int nRestriction = gsIPGetIsValid(oItem, nProperty);

    // The restriction in the 2da file is a bitwise flag.
    int nFlag = 0;
    switch (nCraftSkill)
    {
      case CNR_TRADESKILL_COOKING:
	  case CNR_TRADESKILL_CHEMISTRY:
        nFlag = 1;
        break;
      case CNR_TRADESKILL_WOOD_CRAFTING:
      case CNR_TRADESKILL_JEWELRY:
        nFlag = 2;
        break;
      case CNR_TRADESKILL_WEAPON_CRAFTING:
      case CNR_TRADESKILL_ARMOR_CRAFTING:
        nFlag = 4;
        break;
      case CNR_TRADESKILL_ENCHANTING:
	  case CNR_TRADESKILL_IMBUING:
	  case CNR_TRADESKILL_INVESTING:
        nFlag = 8;
        break;
      case CNR_TRADESKILL_TAILORING:
        nFlag = 16;
        break;
    }

    return (nRestriction & nFlag);
  }
}
//------------------------------------------------------------------------------
int gsCRGetEssenceApplySuccess(object oItem)
{
  int nMultiplier = gsCRGetMaterialMultiplier(gsIPGetMaterialType(oItem), FALSE);

  if (d3() <= nMultiplier) return TRUE;

  return FALSE;
}
//------------------------------------------------------------------------------
int gsCRGetMaterialBaseValue(object oItem)
{
  int nMaterial = gsIPGetMaterialType(oItem);
  int nBaseCost = 0;

  switch (nMaterial)
  {
      case 3: // bronze
        nBaseCost = 0;
        break;
      case 8: // gold
        nBaseCost = 15000;
        break;
      case 9: // iron
        nBaseCost = 2000;
        break;
      case 11: // mithril
        nBaseCost = 25000;
        break;
      case 13: // silver
        nBaseCost = 7000;
        break;
      case 15: // steel
        nBaseCost = 6000;
        break;
      case 17: // hide
        nBaseCost = 2000;
        break;
      case 20: // wyvern
      case 21: // dragonhides
      case 22:
      case 23:
      case 24:
      case 25:
      case 26:
      case 27:
      case 28: // dragonhide (red)
      case 29:
      case 30: // dragonhides
        nBaseCost = 20000;
        break;
      case 31: // leather
        nBaseCost = 7000;
        break;
      case 32: // ankheg (scale)
        nBaseCost = 20000;
        break;
      case 35: // silk
        nBaseCost = 7000;
        break;
      case 36: // wool
        nBaseCost = 2000;
        break;
      case 38: // ironwood
        nBaseCost = 6500;
        break;
      case 39: // duskwood
      case 40: // duskwood from Zalantar
        nBaseCost = 18000;
        break;

  }

  return nBaseCost;
}

