/*
  Mith's Crafting System v1.0
*/
#include "inc_log"
const string CRAFTING = "M_CRAFTING"; // For logging.

// Tags
// Base ingredients
const string IRONWOOD  = "x2_it_cmat_ironw"; // Ironwood Planks
const string DRA_BLOOD = "NW_IT_MSMLMISC17"; // Dragon's Blood
const string FRY_DUST  = "NW_IT_MSMLMISC19"; // Fairy Blood
const string ALC_FIRE  = "X1_WMGRENADE002";  // Alchemist's Fire
const string ACD_FLSK  = "X1_WMGRENADE001";  // Acid Flask
const string HLY_WTR   = "X1_WMGRENADE005";  // Holy Water
const string THNDRSTNE = "X1_WMGRENADE007";  // Thunderstone
const string SPDR_VEN  = "x2_it_poison037";  // Deadly spider venom

// Intermediate components
const string POT_PERS  = "mcrft_potpers"; // Potion of Persistency
const string WYRM_INK  = "mcrft_wyrmink"; // Wyrm Ink
const string IWD_SCRL  = "mcrft_iwdscrl"; // Ironwood Scroll
const string IMB_SCRL  = "mcrft_imbscrl"; // Imbued Scroll

// Gemstones - for high level enchanting.
const string EMERALD   = "NW_IT_GEM012";  // Emerald
const string RUBY      = "NW_IT_GEM006";  // Ruby
const string DIAMOND   = "NW_IT_GEM005";  // Diamond

// Final results
const string NZEL      = "mcraft_nzel";   // Normal scroll of enchant armor.
const string NDAI      = "mcraft_ndai";   // Normal scroll of enchant weapon.
const string BZEL      = "mcraft_bzel";   // Perfect scroll of enchant armor.
const string BDAI      = "mcraft_bdai";   // Perfect scroll of enchant weapon.
const string FIREBATH  = "mcraft_fbath";  // Salve of firebath.
const string ACIDBATH  = "mcraft_abath";  // Salve of acidbath.
const string THUNBATH  = "mcraft_sbath";  // Salve of soundbite.
const string HOLYBATH  = "mcraft_hbath";  // Salve of Holiness.

//------------------------------------------------------------------------------
// Removes nNumToRemove items from the PC's inventory and decrements the count.
//------------------------------------------------------------------------------
void RemoveItems(string sTag, int nNumToRemove = 1);

//------------------------------------------------------------------------------
// Adds nNumToAdd items to the count and create them on the PC. Note - this
// will only work if resref == tag.
//------------------------------------------------------------------------------
void AddItems(string sTag, int nNumToAdd = 1);

//------------------------------------------------------------------------------
// Returns True if the PC has at least nNum of the item with tag sTag.
//------------------------------------------------------------------------------
int CheckItems(string sTag, int nNum = 1);

//------------------------------------------------------------------------------
// Wrapper for FloatingTextStringOnCreature(sMessage, GetPCSpeaker()).
//------------------------------------------------------------------------------
void Message(string sMessage);

//------------------------------------------------------------------------------
// Wrapper for FloatingTextStringOnCreature(sMessage, GetItemActivator()).
//------------------------------------------------------------------------------
void Message2(string sMessage);

//------------------------------------------------------------------------------
// Wrapper for determining if the PC has the feat in question.
//------------------------------------------------------------------------------
int HasFeat(int nFeat);

//------------------------------------------------------------------------------
// You should implement this method in anything that enhances items, to use the
// specific properties of the enchantment you want to use.
//------------------------------------------------------------------------------
void Enhance(object oItem, int nEnhancement);

//------------------------------------------------------------------------------
// You should implement this method in anything that enhances items, to specify
// the order in which enhancement levels should be applied.
//------------------------------------------------------------------------------
int GetNextEnhancementLevel(itemproperty iprp);

//------------------------------------------------------------------------------
// Adds enhancements in simple order 1-10.
//------------------------------------------------------------------------------
int AddedEnhancement(object oItem, itemproperty iprp);

//------------------------------------------------------------------------------
// Adds enhancements in damage order.
//------------------------------------------------------------------------------
int AddedDamageEnhancement(object oItem, itemproperty iprp);

//------------------------------------------------------------------------------
// Removes one item from a stack.
//------------------------------------------------------------------------------
void DestroyStackedObject(object oItem);

void CreateItemOnObjectReturnsVoid(string sItemTemplate, object oTarget=OBJECT_SELF, int nStackSize=1)
{
   CreateItemOnObject(sItemTemplate, oTarget, nStackSize);
}

void DestroyStackedObject(object oItem)
{
  int nStackSize = GetNumStackedItems(oItem);
  object oCreature = GetItemPossessor(oItem);
  string sResRef = GetResRef(oItem);

  Trace(CRAFTING, "  DestroyStackedObject params: " + GetName(oCreature)
        + " " + sResRef + " " + IntToString(nStackSize));
  DestroyObject(oItem);

  if (nStackSize > 1)
  {
    // DestroyObject happens after this script completes. So we have to delay
    // creation of the remaining stack.
    DelayCommand(0.1, CreateItemOnObjectReturnsVoid(sResRef, oCreature, nStackSize - 1));
  }
}

void RemoveItems(string sTag, int nNumToRemove = 1)
{
  Trace(CRAFTING, "Removing " + IntToString(nNumToRemove) + " x " + sTag);
  object oPC = GetPCSpeaker();
  int nCurrentNum = GetLocalInt(oPC, sTag);
  nCurrentNum = nCurrentNum - nNumToRemove;
  SetLocalInt(oPC, sTag, nCurrentNum);

  int nRemoved = 0;
  object oItem = GetFirstItemInInventory(oPC);

  while ((nRemoved < nNumToRemove) && (oItem != OBJECT_INVALID))
  {
    if (GetTag(oItem) == sTag)
    {
      DestroyObject(oItem);
      nRemoved++;
    }

    oItem = GetNextItemInInventory(oPC);
  }
}

void AddItems(string sTag, int nNumToAdd = 1)
{
  Trace(CRAFTING, "Adding " + IntToString(nNumToAdd) + " x " + sTag);
  object oPC = GetPCSpeaker();
  int nCurrentNum = GetLocalInt(oPC, sTag);
  nCurrentNum = nCurrentNum + nNumToAdd;
  SetLocalInt(oPC, sTag, nCurrentNum);

  CreateItemOnObject(sTag, oPC, nNumToAdd);
}

int CheckItems(string sTag, int nNum = 1)
{
  Trace(CRAFTING, " CheckItems called. Looking for " + IntToString(nNum) + " " + sTag);
  int nNumFound = GetLocalInt(GetPCSpeaker(), sTag);
  int nRetval = (nNumFound > (nNum -1));

  Trace(CRAFTING, " Returning from CheckItems with value: " + IntToString(nRetval));
  return nRetval;
}

void Message(string sMessage)
{
  FloatingTextStringOnCreature(sMessage, GetPCSpeaker());
}

void Message2(string sMessage)
{
  FloatingTextStringOnCreature(sMessage, GetItemActivator());
}

int HasFeat(int nFeat)
{
  int nRetval = GetHasFeat(nFeat, GetPCSpeaker());

  Trace(CRAFTING, " Returning from HasFeat with value: " + IntToString(nRetval));
  return nRetval;
}

int AddedEnhancement(object oItem, itemproperty iprp)
{
  object oPC = GetItemPossessor(oItem);

  int nEnhancement = GetNextEnhancementLevel(iprp);

  // Add additional costs here.
  switch (nEnhancement)
  {
    case 1:
    case 2:
    case 3:
    case 4:
    case 5:
    case 6:
    case 7:
      Enhance(oItem, nEnhancement);
      break;
    // Need emerald to reach next level.
    case 8:
    {
      object oEmerald = GetItemPossessedBy(oPC, EMERALD);
      if (oEmerald == OBJECT_INVALID)
      {
        Message2("You need an Emerald to focus enchantment of this magnitude.");
        return 0;
      }
      else
      {
        DestroyStackedObject(oEmerald);
        Enhance(oItem, nEnhancement);
      }

      break;
      }
      // Need ruby to reach next level.
      case 9:
      {
        object oRuby = GetItemPossessedBy(oPC, RUBY);

        if (oRuby == OBJECT_INVALID)
        {
          Message2("You need a Ruby to focus enchantment of this magnitude.");
          return 0;
        }
        else
        {
          DestroyStackedObject(oRuby);
          Enhance(oItem, nEnhancement);
        }

        break;
      }
      // Need diamond to reach highest level.
      case 10:
      {
      object oDiamond = GetItemPossessedBy(oPC, DIAMOND);
      if (oDiamond == OBJECT_INVALID)
      {
        Message2("You need a Diamond to focus enchantment of this magnitude.");
        return 0;
      }
      else
      {
        DestroyStackedObject(oDiamond);
        Enhance(oItem, nEnhancement);
      }

      break;
    }
    case -1:
      Message2("You cannot enchant this item further.");
      return 0;
  }

  return 1;
}

int AddedDamageEnhancement(object oItem, itemproperty iprp)
{
  object oPC = GetItemPossessor(oItem);

  int nEnhancement = GetNextEnhancementLevel(iprp);

  // Add additional costs here.
  switch (nEnhancement)
  {
    case IP_CONST_DAMAGEBONUS_1:
    case IP_CONST_DAMAGEBONUS_2:
    case IP_CONST_DAMAGEBONUS_1d4:
    case IP_CONST_DAMAGEBONUS_3:
    case IP_CONST_DAMAGEBONUS_1d6:
    case IP_CONST_DAMAGEBONUS_4:
    case IP_CONST_DAMAGEBONUS_1d8:
      Enhance(oItem, nEnhancement);
      break;
    // Need emerald to reach next level.
    case IP_CONST_DAMAGEBONUS_5:
    {
      object oEmerald = GetItemPossessedBy(oPC, EMERALD);
      if (oEmerald == OBJECT_INVALID)
      {
        Message2("You need an Emerald to focus enchantment of this magnitude.");
        return 0;
      }
      else
      {
        DestroyStackedObject(oEmerald);
        Enhance(oItem, nEnhancement);
      }

      break;
    }
    // Need ruby to reach next level.
    case IP_CONST_DAMAGEBONUS_1d10:
    {
      object oRuby = GetItemPossessedBy(oPC, RUBY);

      if (oRuby == OBJECT_INVALID)
      {
        Message2("You need a Ruby to focus enchantment of this magnitude.");
        return 0;
      }
      else
      {
        DestroyStackedObject(oRuby);
        Enhance(oItem, nEnhancement);
      }

      break;
    }
    // Need diamond to reach highest level.
    case IP_CONST_DAMAGEBONUS_2d6:
    {
      object oDiamond = GetItemPossessedBy(oPC, DIAMOND);
      if (oDiamond == OBJECT_INVALID)
      {
        Message2("You need a Diamond to focus enchantment of this magnitude.");
        return 0;
      }
      else
      {
        DestroyStackedObject(oDiamond);
        Enhance(oItem, nEnhancement);
      }

      break;
    }
    case -1:
      Message2("You cannot enchant this item further.");
      return 0;
  }

  return 1;
}
