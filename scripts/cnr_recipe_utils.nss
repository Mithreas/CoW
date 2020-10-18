/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_recipe_utils
//
//  Desc:  This collection of functions manages the
//         recipe making for CNR.
//
//  Author: David Bobeck 07Dec02
//
/////////////////////////////////////////////////////////

#include "cnr_config_inc"
#include "cnr_persist_inc"
#include "cnr_language_inc"
#include "inc_divination"
#include "inc_iprop"
#include "inc_reputation"
#include "inc_worship"
#include "inc_xp"

int CNR_SELECTIONS_PER_PAGE = 6;
int CNR_CONVO_CRAFTING = TRUE;
int CNR_SILENT_CRAFTING = FALSE;

void CnrRecipePlaySound(int nSkill);
void CnrRecipeDoAnimation(object oPC, object oDevice, int bSuccess);

// Plays an appropriate sound for the skill in question.
void CnrRecipePlaySound(int nSkill)
{
    switch (nSkill)
    {
    case CNR_TRADESKILL_COOKING:
        PlaySound("as_cv_shopjugs1");
        break;
		
    case CNR_TRADESKILL_WOOD_CRAFTING:
        PlaySound("as_cv_sawing1");
        break;


    case CNR_TRADESKILL_INVESTING:
    case CNR_TRADESKILL_JEWELRY:
    case CNR_TRADESKILL_ENCHANTING:
        PlaySound("as_cv_chiseling2");
        break;

    case CNR_TRADESKILL_WEAPON_CRAFTING:
	case CNR_TRADESKILL_ARMOR_CRAFTING:
        PlaySound("as_cv_smithhamr1");
        break;

    case CNR_TRADESKILL_CHEMISTRY:
	case CNR_TRADESKILL_IMBUING:
        PlaySound("al_mg_beaker1");
        break;

    case CNR_TRADESKILL_TAILORING:
        PlaySound("as_na_leafmove1");
        break;
    }
}

/////////////////////////////////////////////////////////
void CnrIncrementStackCount(object oHost, string sStackCountName = "CnrStackCount")
{
  int nStackCount = GetLocalInt(oHost, sStackCountName) + 1;
  SetLocalInt(oHost, sStackCountName, nStackCount);
  //PrintString(sStackCountName + " incremented to " + IntToString(nStackCount));
}

/////////////////////////////////////////////////////////
void CnrDecrementStackCount(object oHost, string sStackCountName = "CnrStackCount")
{
  int nStackCount = GetLocalInt(oHost, sStackCountName) - 1;
  SetLocalInt(oHost, sStackCountName, nStackCount);
  //PrintString(sStackCountName + " decremented to " + IntToString(nStackCount));
}

/////////////////////////////////////////////////////////
void CnrSetStackCount(object oHost, int nStackCount, string sStackCountName = "CnrStackCount")
{
  SetLocalInt(oHost, sStackCountName, nStackCount);
  //PrintString(sStackCountName + " set to " + IntToString(nStackCount));
}

/////////////////////////////////////////////////////////
int CnrGetStackCount(object oHost, string sStackCountName = "CnrStackCount")
{
  int nStackCount = GetLocalInt(oHost, sStackCountName);
  return nStackCount;
}

/////////////////////////////////////////////////////////
void CnrUpdateTopTenCrafters(object oPC, int nTradeskill, int nXP)
{
  object oModule = GetModule();
  string sName = GetName(oPC, TRUE);
  string sKeyToLeaderName;
  string sKeyToLeaderXP;
  string sLeaderName;
  int nLeaderXP;

  int n;

  // First pass - look for PC name in the list
  int nFoundAt = 0; // something safe
  for (n=1; n<11 && nFoundAt==0; n++)
  {
    sKeyToLeaderName = "CnrTradeLeaderName_" + IntToString(nTradeskill) + "_" + IntToString(n);
    sLeaderName = CnrGetPersistentString(oModule, sKeyToLeaderName);

    if (sName == sLeaderName)
    {
      nFoundAt = n;
    }
  }

  // Remove PC name from the list if found
  if (nFoundAt > 0)
  {
    for (n=nFoundAt+1; n<11; n++)
    {
      sKeyToLeaderName = "CnrTradeLeaderName_" + IntToString(nTradeskill) + "_" + IntToString(n);
      sKeyToLeaderXP = "CnrTradeLeaderXP_" + IntToString(nTradeskill) + "_" + IntToString(n);
      sLeaderName = CnrGetPersistentString(oModule, sKeyToLeaderName);
      nLeaderXP = CnrGetPersistentInt(oModule, sKeyToLeaderXP);
      sKeyToLeaderName = "CnrTradeLeaderName_" + IntToString(nTradeskill) + "_" + IntToString(n-1);
      sKeyToLeaderXP = "CnrTradeLeaderXP_" + IntToString(nTradeskill) + "_" + IntToString(n-1);
      CnrSetPersistentString(oModule, sKeyToLeaderName, sLeaderName);
      CnrSetPersistentInt(oModule, sKeyToLeaderXP, nLeaderXP);
    }

    // clear the bottom name
    sKeyToLeaderName = "CnrTradeLeaderName_" + IntToString(nTradeskill) + "_" + IntToString(10);
    CnrSetPersistentString(oModule, sKeyToLeaderName, "");
  }

  // Second Pass - Find where oPC fits into the list
  nFoundAt = 0; // something safe
  for (n=1; n<11 && nFoundAt==0; n++)
  {
    sKeyToLeaderXP = "CnrTradeLeaderXP_" + IntToString(nTradeskill) + "_" + IntToString(n);
    nLeaderXP = CnrGetPersistentInt(oModule, sKeyToLeaderXP);

    if (nXP > nLeaderXP)
    {
      nFoundAt = n;
    }
  }

  // Insert PC name into the list if found
  if (nFoundAt > 0)
  {
    for (n=9; n>nFoundAt; n--)
    {
      sKeyToLeaderName = "CnrTradeLeaderName_" + IntToString(nTradeskill) + "_" + IntToString(n);
      sKeyToLeaderXP = "CnrTradeLeaderXP_" + IntToString(nTradeskill) + "_" + IntToString(n);
      sLeaderName = CnrGetPersistentString(oModule, sKeyToLeaderName);
      nLeaderXP = CnrGetPersistentInt(oModule, sKeyToLeaderXP);
      sKeyToLeaderName = "CnrTradeLeaderName_" + IntToString(nTradeskill) + "_" + IntToString(n+1);
      sKeyToLeaderXP = "CnrTradeLeaderXP_" + IntToString(nTradeskill) + "_" + IntToString(n+1);
      CnrSetPersistentString(oModule, sKeyToLeaderName, sLeaderName);
      CnrSetPersistentInt(oModule, sKeyToLeaderXP, nLeaderXP);
    }

    sKeyToLeaderName = "CnrTradeLeaderName_" + IntToString(nTradeskill) + "_" + IntToString(nFoundAt);
    sKeyToLeaderXP = "CnrTradeLeaderXP_" + IntToString(nTradeskill) + "_" + IntToString(nFoundAt);
    CnrSetPersistentString(oModule, sKeyToLeaderName, sName);
    CnrSetPersistentInt(oModule, sKeyToLeaderXP, nXP);
  }
}

/////////////////////////////////////////////////////////
int CnrDetermineTradeskillLevel(int nXP)
{
  object oModule = GetModule();
  int nLevelXP;
  int n;
  for (n=20; n>=1; n--)
  {
    nLevelXP = GetLocalInt(oModule, "CnrTradeXPLevel" + IntToString(n));
    if (nXP >= nLevelXP)
    {
      return n;
    }
  }
  return 1;
}

//////////////////////////////////////////////////////////////////////
//  nTradeskillType = a unique ID for the tradeskill.
//  sTradeskillName = the display name used by the tradeskill journal.
//  returns: an index to use when configuring crafting
//           devices. (see CnrRecipeSetDeviceTradeskillType)
//////////////////////////////////////////////////////////////////////
int CnrAddTradeskill(int nTradeskillType, string sTradeskillName);
//////////////////////////////////////////////////////////////////////
int CnrAddTradeskill(int nTradeskillType, string sTradeskillName)
{
  object oModule = GetModule();

  int nTradeskillCount = GetLocalInt(oModule, "CnrTradeskillCount") + 1;
  SetLocalInt(oModule, "CnrTradeskillCount", nTradeskillCount);

  string sKeyToTradeskillName = "CnrTradeskillName_" + IntToString(nTradeskillCount);
  SetLocalString(oModule, sKeyToTradeskillName, sTradeskillName);
  string sKeyToTradeskillType = "CnrTradeskillType_" + IntToString(nTradeskillCount);
  SetLocalInt(oModule, sKeyToTradeskillType, nTradeskillType);
  string sKeyToTradeskillIndex = "CnrTradeskillIndex_" + IntToString(nTradeskillType);
  SetLocalInt(oModule, sKeyToTradeskillIndex, nTradeskillCount);

  return nTradeskillCount;
}

/////////////////////////////////////////////////////////
int CnrGetTradeskillCount()
{
  return GetLocalInt(GetModule(), "CnrTradeskillCount");
}

/////////////////////////////////////////////////////////
string CnrGetTradeskillNameByType(int nTradeskillType)
{
  object oModule = GetModule();
  string sName = "Unknown Tradeskill";

  string sKeyToTradeskillIndex = "CnrTradeskillIndex_" + IntToString(nTradeskillType);
  int nTradeskillIndex = GetLocalInt(oModule, sKeyToTradeskillIndex);

  int nTradeskillCount = GetLocalInt(oModule, "CnrTradeskillCount");
  if ((nTradeskillIndex > 0) && (nTradeskillIndex <= nTradeskillCount))
  {
    string sKeyToTradeskillName = "CnrTradeskillName_" + IntToString(nTradeskillIndex);
    sName = GetLocalString(oModule, sKeyToTradeskillName);
  }

  return sName;
}

/////////////////////////////////////////////////////////
string CnrGetTradeskillNameByIndex(int nTradeskillIndex)
{
  object oModule = GetModule();
  string sName = "Unknown Tradeskill";

  int nTradeskillCount = GetLocalInt(oModule, "CnrTradeskillCount");
  if ((nTradeskillIndex > 0) && (nTradeskillIndex <= nTradeskillCount))
  {
    string sKeyToTradeskillName = "CnrTradeskillName_" + IntToString(nTradeskillIndex);
    sName = GetLocalString(oModule, sKeyToTradeskillName);
  }

  return sName;
}

/////////////////////////////////////////////////////////
// this function returns the first object
// found by tag in the inventory of an object
/////////////////////////////////////////////////////////
object CnrGetItemByTag(string sItemTag, object oContainer)
{
  object oItem = GetFirstItemInInventory(oContainer);
  while (oItem != OBJECT_INVALID)
  {
    // found the right item ?
    if (GetTag(oItem) == sItemTag)
    {
      return oItem;
    }

    // found a bag or box?
    if (GetHasInventory(oItem) == TRUE)
    {
      // recursive search
      oItem = CnrGetItemByTag(sItemTag, oItem);
    }

    // next
    oItem = GetNextItemInInventory(oContainer);
  }

  if (GetObjectType(oContainer) == OBJECT_TYPE_CREATURE)
  {
    int nSlot;
    for (nSlot=INVENTORY_SLOT_HEAD; nSlot<=INVENTORY_SLOT_BOLTS; nSlot++)
    {
      oItem = GetItemInSlot(nSlot, oContainer);
      if (oItem != OBJECT_INVALID)
      {
        if (GetTag(oItem) == sItemTag)
        {
          return oItem;
        }
      }
    }
  }

  return OBJECT_INVALID;
}

/////////////////////////////////////////////////////////
// this function returns the first object
// found by ResRef in the inventory of an object
/////////////////////////////////////////////////////////
object CnrGetItemByResRef(string sItemResRef, object oContainer)
{
  object oItem = GetFirstItemInInventory(oContainer);
  while (oItem != OBJECT_INVALID)
  {
    // found the right item ?
    if (GetResRef(oItem) == sItemResRef)
    {
      return oItem;
    }

    // found a bag or box?
    if (GetHasInventory(oItem) == TRUE)
    {
      // recursive search
      oItem = CnrGetItemByResRef(sItemResRef, oItem);
    }

    // next
    oItem = GetNextItemInInventory(oContainer);
  }

  if (GetObjectType(oContainer) == OBJECT_TYPE_CREATURE)
  {
    int nSlot;
    for (nSlot=INVENTORY_SLOT_HEAD; nSlot<=INVENTORY_SLOT_BOLTS; nSlot++)
    {
      oItem = GetItemInSlot(nSlot, oContainer);
      if (oItem != OBJECT_INVALID)
      {
        if (GetResRef(oItem) == sItemResRef)
        {
          return oItem;
        }
      }
    }
  }

  return OBJECT_INVALID;
}

////////////////////////////////////////////////////////
// this function returns the first object
// found by name in the inventory of an object
////////////////////////////////////////////////////////
object CnrGetItemByName(string sItemName, object oContainer)
{
  object oItem = GetFirstItemInInventory(oContainer);
  while (oItem != OBJECT_INVALID)
  {
    // found the right item ?
    if (GetName(oItem) == sItemName)
    {
      return oItem;
    }

    // found a bag or box?
    if (GetHasInventory(oItem) == TRUE)
    {
      // recursive search
      oItem = CnrGetItemByName(sItemName, oItem);
    }

    // next
    oItem = GetNextItemInInventory(oContainer);
  }

  if (GetObjectType(oContainer) == OBJECT_TYPE_CREATURE)
  {
    int nSlot;
    for (nSlot=INVENTORY_SLOT_HEAD; nSlot<=INVENTORY_SLOT_BOLTS; nSlot++)
    {
      oItem = GetItemInSlot(nSlot, oContainer);
      if (oItem != OBJECT_INVALID)
      {
        if (GetName(oItem) == sItemName)
        {
          return oItem;
        }
      }
    }
  }

  return OBJECT_INVALID;
}

////////////////////////////////////////////////////////
int CnrGetTradeskillXPByType(object oPC, int nTradeskillType)
{
  return CnrGetPersistentInt(oPC, "CnrTradeskillXP_"+IntToString(nTradeskillType));
}

////////////////////////////////////////////////////////
int CnrGetTradeskillXPByIndex(object oPC, int nTradeskillIndex)
{
  string sKeyToTradeskillType = "CnrTradeskillType_" + IntToString(nTradeskillIndex);
  int nTradeskillType = GetLocalInt(GetModule(), sKeyToTradeskillType);
  return CnrGetPersistentInt(oPC, "CnrTradeskillXP_"+IntToString(nTradeskillType));
}

////////////////////////////////////////////////////////
void CnrSetTradeskillXPByType(object oPC, int nTradeskillType, int nXP)
{
  CnrUpdateTopTenCrafters(oPC, nTradeskillType, nXP);
  CnrSetPersistentInt(oPC, "CnrTradeskillXP_"+IntToString(nTradeskillType), nXP);
}

////////////////////////////////////////////////////////
void CnrSetTradeskillXPByIndex(object oPC, int nTradeskillIndex, int nXP)
{
  string sKeyToTradeskillType = "CnrTradeskillType_" + IntToString(nTradeskillIndex);
  int nTradeskillType = GetLocalInt(GetModule(), sKeyToTradeskillType);
  CnrUpdateTopTenCrafters(oPC, nTradeskillType, nXP);
  CnrSetPersistentInt(oPC, "CnrTradeskillXP_"+IntToString(nTradeskillType), nXP);
}

////////////////////////////////////////////////////////
int CnrGetTradeskillLevelCapByType(object oPC, int nTradeskillType)
{
  string sKeyToLevel = "CnrPlayerTradeskillLevelCap_" + IntToString(nTradeskillType);
  int nLevel = GetLocalInt(oPC, sKeyToLevel);
  return nLevel;
}

/////////////////////////////////////////////////////////
int CnrGetTradeskillLevelCapByIndex(object oPC, int nTradeskillIndex)
{
  string sKeyToTradeskillType = "CnrTradeskillType_" + IntToString(nTradeskillIndex);
  int nTradeskillType = GetLocalInt(GetModule(), sKeyToTradeskillType);
  string sKeyToLevel = "CnrPlayerTradeskillLevelCap_" + IntToString(nTradeskillType);
  int nLevel = GetLocalInt(oPC, sKeyToLevel);
  return nLevel;
}

/////////////////////////////////////////////////////////
void CnrSetTradeskillLevelCapByType(object oPC, int nTradeskillType, int nLevel)
{
  string sKeyToLevel = "CnrPlayerTradeskillLevelCap_" + IntToString(nTradeskillType);
  SetLocalInt(oPC, sKeyToLevel, nLevel);
}

/////////////////////////////////////////////////////////
void CnrSetTradeskillLevelCapByIndex(object oPC, int nTradeskillIndex, int nLevel)
{
  string sKeyToTradeskillType = "CnrTradeskillType_" + IntToString(nTradeskillIndex);
  int nTradeskillType = GetLocalInt(GetModule(), sKeyToTradeskillType);
  string sKeyToLevel = "CnrPlayerTradeskillLevelCap_" + IntToString(nTradeskillType);
  SetLocalInt(oPC, sKeyToLevel, nLevel);
}

/////////////////////////////////////////////////////////
void CnrConvertOldJournalXPToNewFormat(object oJournal, object oPC)
{
  // Retired.
}

/////////////////////////////////////////////////////////
int CnrGetPlayerLevel(object oPC, string sDeviceTag)
{
  int nPlayerLevel;
  int nDeviceTradeskillType = GetLocalInt(GetModule(), sDeviceTag + "_TradeskillType");
  if (nDeviceTradeskillType == CNR_TRADESKILL_NONE)
  {
    // If no tradeskill is set, return -1.  Success should be automatic. 
    nPlayerLevel = -1;
  }
  else
  {
    int nXP = CnrGetTradeskillXPByType(oPC, nDeviceTradeskillType);
    nPlayerLevel = CnrDetermineTradeskillLevel(nXP);
  }
  return nPlayerLevel;
}

/////////////////////////////////////////////////////////
//  sDeviceTag = the tag of the crafting placeable.
//  sScript = a script that wil be executed when the player attempts to
//            craft a recipe.
void CnrRecipeSetDevicePreCraftingScript(string sDeviceTag, string sScript);
/////////////////////////////////////////////////////////
void CnrRecipeSetDevicePreCraftingScript(string sDeviceTag, string sScript)
{
  SetLocalString(GetModule(), sDeviceTag + "_RecipePreScript", sScript);
}

/////////////////////////////////////////////////////////
//  sDeviceTag = the tag of the crafting placeable.
//  bSpawnItemInDevice = if TRUE, item made are left in the device. Otherwise
//                       the items are moved to the PC for convenience.
/////////////////////////////////////////////////////////
void CnrRecipeSetDeviceSpawnItemInDevice(string sDeviceTag, int bSpawnItemInDevice);
/////////////////////////////////////////////////////////
void CnrRecipeSetDeviceSpawnItemInDevice(string sDeviceTag, int bSpawnItemInDevice)
{
  SetLocalInt(GetModule(), sDeviceTag + "_SpawnItemInDevice", bSpawnItemInDevice);
}

/////////////////////////////////////////////////////////
//  sDeviceTag = the tag of the crafting placeable.
//  sToolTag = the tag of the tool or item required to be in the player's
//             inventory before gaining access to the crafting device.
//  fBreakagePercentage = range 0.1 thru 100.0 (in tenths)
/////////////////////////////////////////////////////////
void CnrRecipeSetDeviceInventoryTool(string sDeviceTag, string sToolTag, float fBreakagePercentage=0.0);
/////////////////////////////////////////////////////////
void CnrRecipeSetDeviceInventoryTool(string sDeviceTag, string sToolTag, float fBreakagePercentage=0.0)
{
  SetLocalString(GetModule(), sDeviceTag + "_InventoryTool", sToolTag);
  SetLocalFloat(GetModule(), sDeviceTag + "_InventoryTool_BP", fBreakagePercentage);
}

/////////////////////////////////////////////////////////
//  sDeviceTag = the tag of the crafting placeable.
//  sToolTag = the tag of the tool or item required to be equipped by
//             the player before gaining access to the crafting device.
//  fBreakagePercentage = range 0.1 thru 100.0 (in tenths)
/////////////////////////////////////////////////////////
void CnrRecipeSetDeviceEquippedTool(string sDeviceTag, string sToolTag, float fBreakagePercentage=0.0);
/////////////////////////////////////////////////////////
void CnrRecipeSetDeviceEquippedTool(string sDeviceTag, string sToolTag, float fBreakagePercentage=0.0)
{
  SetLocalString(GetModule(), sDeviceTag + "_EquippedTool", sToolTag);
  SetLocalFloat(GetModule(), sDeviceTag + "_EquippedTool_BP", fBreakagePercentage);
}

/////////////////////////////////////////////////////////
//  sDeviceTag = the tag of the crafting placeable.
//  nTradeskillType = CNR_TRADESKILL_*** (see cnr_config_inc)
/////////////////////////////////////////////////////////
void CnrRecipeSetDeviceTradeskillType(string sDeviceTag, int nTradeskillType);
/////////////////////////////////////////////////////////
void CnrRecipeSetDeviceTradeskillType(string sDeviceTag, int nTradeskillType)
{
  SetLocalInt(GetModule(), sDeviceTag + "_TradeskillType", nTradeskillType);
}

/////////////////////////////////////////////////////////
string CnrRecipeAddSubMenu(string sKeyToParent, string sTitle)
{
  object oModule = GetModule();

  string sKeyToCount = sKeyToParent + "_SubMenuCount";
  int nSubMenuCount = GetLocalInt(oModule, sKeyToCount);

  // Before adding the new submenu, check if it has already
  // been defined. If so, then just return the key.

  nSubMenuCount++;
  SetLocalInt(oModule, sKeyToCount, nSubMenuCount);

  string sKey = sKeyToParent + "_" + IntToString(nSubMenuCount);
  SetLocalString(oModule, sKey + "_RecipeDesc", sTitle);
  SetLocalString(oModule, sKey + "_KeyToParent", sKeyToParent);

  // always clear our counts in case we are reloading
  SetLocalInt(oModule, sKey + "_SubMenuCount", 0);
  SetLocalInt(oModule, sKey + "_RecipeCount", 0);

  return sKey;
}

/////////////////////////////////////////////////////////
//  sDeviceTag = the tag of the crafting placeable.
//  sRecipeDesc = the description of the recipe (what the recipe will make).
//  sRecipeTag = the tag of the item the recipe will make.
//  nQtyMade = the quantity of sRecipeTag items the recipe makes.
//  NOTE: the returned string represents a key to permit further
//        access to the recipe just created.
/////////////////////////////////////////////////////////
string CnrRecipeCreateRecipe(string sDeviceTag, string sRecipeDesc, string sRecipeTag, int nQtyMade);
/////////////////////////////////////////////////////////
string CnrRecipeCreateRecipe(string sDeviceTag, string sRecipeDesc, string sRecipeTag, int nQtyMade)
{
  string sKeyToRecipe = "RECIPE_INVALID";
  object oModule = GetModule();

  // check if any sub menus have been defined
  int nSubMenuCount = GetLocalInt(oModule, sDeviceTag + "_SubMenuCount");
  if (nSubMenuCount > 0)
  {
    // Cannot add recipes to menus containing sub menus
    return sKeyToRecipe;
  }

  int nRecipeCount = GetLocalInt(oModule, sDeviceTag + "_RecipeCount") + 1;
  SetLocalInt(oModule, sDeviceTag + "_RecipeCount", nRecipeCount);
  //PrintString(sDeviceTag + "_RecipeCount = " + IntToString(nRecipeCount));

  sKeyToRecipe = sDeviceTag + "_" + IntToString(nRecipeCount);

  SetLocalString(oModule, sKeyToRecipe + "_RecipeDesc", sRecipeDesc);
  SetLocalString(oModule, sKeyToRecipe + "_RecipeTag", sRecipeTag);
  SetLocalInt(oModule, sKeyToRecipe + "_RecipeQty", nQtyMade);
  SetLocalInt(oModule, sKeyToRecipe + "_RecipeComponentCount", 0);
  SetLocalString(oModule, sKeyToRecipe + "_KeyToParent", sDeviceTag);

  // count the total number of recipes
  nRecipeCount = GetLocalInt(oModule, "CnrRecipeCount") + 1;
  SetLocalInt(oModule, "CnrRecipeCount", nRecipeCount);

  return sKeyToRecipe;
}

/////////////////////////////////////////////////////////
//  sKeyToRecipe = the string returned from CnrRecipeCreateRecipe()
//  sFilter = identifies one of two things... 1) a local int on the PC.
//  If TRUE the recipe will be displayed on the crafting convo. 2) an
//  item in the PC's inventory. If found the recipe will be displayed.
/////////////////////////////////////////////////////////
void CnrRecipeSetRecipeFilter(string sKeyToRecipe, string sFilter);
/////////////////////////////////////////////////////////
void CnrRecipeSetRecipeFilter(string sKeyToRecipe, string sFilter)
{
  if (sKeyToRecipe != "RECIPE_INVALID")
  {
    SetLocalString(GetModule(), sKeyToRecipe + "_RecipeFilter", sFilter);
  }
}

/////////////////////////////////////////////////////////
//  sKeyToRecipe = the tag of the crafting placeable, or the
// string returned from CnrRecipeCreateRecipe() to override.
//  nXXX = the weighted percentage of the particular ability.
//  Note: The sum of all weighted ability percentages should equal 100.
/////////////////////////////////////////////////////////
void CnrRecipeSetRecipeAbilityPercentages(string sKeyToRecipe, int nStr, int nDex, int nCon, int nInt, int nWis, int nCha);
/////////////////////////////////////////////////////////
void CnrRecipeSetRecipeAbilityPercentages(string sKeyToRecipe, int nStr, int nDex, int nCon, int nInt, int nWis, int nCha)
{
  if (sKeyToRecipe != "RECIPE_INVALID")
  {
    object oModule = GetModule();
    SetLocalInt(oModule, sKeyToRecipe + "_RecipeStr", nStr);
    SetLocalInt(oModule, sKeyToRecipe + "_RecipeDex", nDex);
    SetLocalInt(oModule, sKeyToRecipe + "_RecipeCon", nCon);
    SetLocalInt(oModule, sKeyToRecipe + "_RecipeInt", nInt);
    SetLocalInt(oModule, sKeyToRecipe + "_RecipeWis", nWis);
    SetLocalInt(oModule, sKeyToRecipe + "_RecipeCha", nCha);
  }
}

/////////////////////////////////////////////////////////
//  sKeyToRecipe = the string returned from CnrRecipeCreateRecipe()
//  nLevel = the median level a PC must have to craft the recipe.
//  Note: a PC will have a chance to craft this recipe at lower/higher
//        levels, but their chance of success will decrease/increase.
/////////////////////////////////////////////////////////
void CnrRecipeSetRecipeLevel(string sKeyToRecipe, int nLevel);
/////////////////////////////////////////////////////////
void CnrRecipeSetRecipeLevel(string sKeyToRecipe, int nLevel)
{
  if (sKeyToRecipe != "RECIPE_INVALID")
  {
    SetLocalInt(GetModule(), sKeyToRecipe + "_RecipeLevel", nLevel);
  }
}

/////////////////////////////////////////////////////////
//  sKeyToRecipe = the string returned from CnrRecipeCreateRecipe()
//  nGameXP = the Game XP awarded to the crafting PC on success
//  nTradeXP = the Trade XP awarded to the crafting PC on success
//  bScalarOverrideFlag = Set TRUE to prevent game XP scaling.
//    Note: the "trade" is defined by CnrRecipeSetDeviceTradeskillType()
//    Note: Game XP scaling will occur if CNR_BOOL_GAME_XP_SCALAR_ENABLED is TRUE.
//          This variable is builder configurable and found in "cnr_config_inc".
/////////////////////////////////////////////////////////
void CnrRecipeSetRecipeXP(string sKeyToRecipe, int nGameXP, int nTradeXP, int bScalarOverrideFlag=FALSE);
/////////////////////////////////////////////////////////
void CnrRecipeSetRecipeXP(string sKeyToRecipe, int nGameXP, int nTradeXP, int bScalarOverrideFlag=FALSE)
{
  if (sKeyToRecipe != "RECIPE_INVALID")
  {
    SetLocalInt(GetModule(), sKeyToRecipe + "_GameXP", nGameXP);
    SetLocalInt(GetModule(), sKeyToRecipe + "_TradeXP", nTradeXP);

    // each recipe can override the global scalar enable flag
    SetLocalInt(GetModule(), sKeyToRecipe + "_ScalarOverrideFlag", bScalarOverrideFlag);
  }
}

/////////////////////////////////////////////////////////
//  sKeyToRecipe = the string returned from CnrRecipeCreateRecipe()
//  sScript = a script that wil be executed when the player attempts to
//            craft a recipe.
/////////////////////////////////////////////////////////
void CnrRecipeSetRecipePreCraftingScript(string sKeyToRecipe, string sScript);
/////////////////////////////////////////////////////////
void CnrRecipeSetRecipePreCraftingScript(string sKeyToRecipe, string sScript)
{
  if (sKeyToRecipe != "RECIPE_INVALID")
  {
    SetLocalString(GetModule(), sKeyToRecipe + "_RecipePreScript", sScript);
  }
}

/////////////////////////////////////////////////////////
//  sKeyToRecipe = the string returned from CnrRecipeCreateRecipe()
//  sBiTag = the tag of an item that will be created as a bi-product of the recipe.
//  nBiQty = the quantity of sBiTag items created by the recipe
//  nOnFailBiQty = use a value > 0 if you want some bi-product to be created in
//                 the crafting placeable's inventory after a failed attempt to
//                 craft the recipe.
/////////////////////////////////////////////////////////
void CnrRecipeSetRecipeBiproduct(string sKeyToRecipe, string sBiTag, int nBiQty, int nOnFailBiQty);
/////////////////////////////////////////////////////////
void CnrRecipeSetRecipeBiproduct(string sKeyToRecipe, string sBiTag, int nBiQty, int nOnFailBiQty)
{
  if (sKeyToRecipe != "RECIPE_INVALID")
  {
    SetLocalString(GetModule(), sKeyToRecipe + "_RecipeBiTag", sBiTag);
    SetLocalInt(GetModule(), sKeyToRecipe + "_RecipeBiQty", nBiQty);
    SetLocalInt(GetModule(), sKeyToRecipe + "_OnFailBiQty", nOnFailBiQty);
  }
}

/////////////////////////////////////////////////////////
//  sKeyToRecipe = the string returned from CnrRecipeCreateRecipe()
//  sComponentTag = the tag of one of the items required by the recipe.
//  nComponentQty = the quantity of sComponentTag items required by the recipe
//  nRetainOnFailQty = the number of items to remain in the
//                     crafting placeable's inventory after a failed
//                     attempt to craft the recipe.
/////////////////////////////////////////////////////////
void CnrRecipeAddComponent(string sKeyToRecipe, string sComponentTag, int nComponentQty, int nRetainOnFailQty=0);
/////////////////////////////////////////////////////////
void CnrRecipeAddComponent(string sKeyToRecipe, string sComponentTag, int nComponentQty, int nRetainOnFailQty=0)
{
  if (sKeyToRecipe != "RECIPE_INVALID")
  {
    object oModule = GetModule();

    int nComponentCount = GetLocalInt(oModule, sKeyToRecipe + "_RecipeComponentCount") + 1;
    SetLocalInt(oModule, sKeyToRecipe + "_RecipeComponentCount", nComponentCount);

    string sKeyToComponent = sKeyToRecipe + "_" + IntToString(nComponentCount);

    SetLocalString(oModule, sKeyToComponent + "_Tag", sComponentTag);
    SetLocalInt(oModule, sKeyToComponent + "_Qty", nComponentQty);
    SetLocalInt(oModule, sKeyToComponent + "_RetainQty", nRetainOnFailQty);
  }
}

/////////////////////////////////////////////////////////
int CnrRecipeGetRecipeCount(string sKeyToMenu)
{
  return GetLocalInt(GetModule(), sKeyToMenu + "_RecipeCount");
}

/////////////////////////////////////////////////////////
string CnrRecipeGetKeyToRecipe(string sKeyToMenu, int nRecipeIndex)
{
  string sKeyToRecipe = "RECIPE_INVALID";

  // Check if nRecipeIndex is valid
  int nRecipeCount = CnrRecipeGetRecipeCount(sKeyToMenu);
  if ((nRecipeIndex > 0) && (nRecipeIndex <= nRecipeCount))
  {
    sKeyToRecipe = sKeyToMenu + "_" + IntToString(nRecipeIndex);
  }

  return sKeyToRecipe;
}

/////////////////////////////////////////////////////////
int CnrRecipeGetRecipeCountOnPC(object oPC, string sKeyToMenu)
{
  return GetLocalInt(oPC, sKeyToMenu + "_RecipeCount");
}

/////////////////////////////////////////////////////////
string CnrRecipeGetKeyToRecipeOnPC(object oPC, string sKeyToMenu, int nRecipeIndex)
{
  string sKeyToRecipe = "RECIPE_INVALID";

  // Check if nRecipeIndex is valid
  int nRecipeCount = CnrRecipeGetRecipeCountOnPC(oPC, sKeyToMenu);
  if ((nRecipeIndex > 0) && (nRecipeIndex <= nRecipeCount))
  {
    sKeyToRecipe = sKeyToMenu + "_" + IntToString(nRecipeIndex);
  }

  return sKeyToRecipe;
}

/////////////////////////////////////////////////////////
string CnrRecipeGetRecipePreCraftingScriptByKey(string sKeyToRecipe)
{
  string sRecipeScript = "SCRIPT_INVALID";

  if (sKeyToRecipe != "RECIPE_INVALID")
  {
    sRecipeScript = GetLocalString(GetModule(), sKeyToRecipe + "_RecipePreScript");
  }

  return sRecipeScript;
}

/////////////////////////////////////////////////////////
string CnrRecipeGetRecipePreCraftingScript(string sKeyToMenu, int nRecipeIndex)
{
  string sKeyToRecipe = CnrRecipeGetKeyToRecipe(sKeyToMenu, nRecipeIndex);
  return CnrRecipeGetRecipePreCraftingScriptByKey(sKeyToRecipe);
}

/////////////////////////////////////////////////////////
string CnrRecipeGetRecipeBiproductTagByKey(string sKeyToRecipe)
{
  string sRecipeBiTag = "BIPRODUCT_INVALID";

  if (sKeyToRecipe != "RECIPE_INVALID")
  {
    sRecipeBiTag = GetLocalString(GetModule(), sKeyToRecipe + "_RecipeBiTag");
  }

  return sRecipeBiTag;
}

/////////////////////////////////////////////////////////
string CnrRecipeGetRecipeBiproductTag(string sKeyToMenu, int nRecipeIndex)
{
  string sKeyToRecipe = CnrRecipeGetKeyToRecipe(sKeyToMenu, nRecipeIndex);
  return CnrRecipeGetRecipeBiproductTagByKey(sKeyToRecipe);
}

/////////////////////////////////////////////////////////
int CnrRecipeGetRecipeOnFailBiproductQtyByKey(string sKeyToRecipe)
{
  int nOnFailBiQty = 0;

  if (sKeyToRecipe != "RECIPE_INVALID")
  {
    nOnFailBiQty = GetLocalInt(GetModule(), sKeyToRecipe + "_OnFailBiQty");
  }

  return nOnFailBiQty;
}

/////////////////////////////////////////////////////////
int CnrRecipeGetRecipeOnFailBiproductQty(string sKeyToMenu, int nRecipeIndex)
{
  string sKeyToRecipe = CnrRecipeGetKeyToRecipe(sKeyToMenu, nRecipeIndex);
  return CnrRecipeGetRecipeOnFailBiproductQtyByKey(sKeyToRecipe);
}

/////////////////////////////////////////////////////////
int CnrRecipeGetRecipeBiproductQtyByKey(string sKeyToRecipe)
{
  int nBiQty = 0;

  if (sKeyToRecipe != "RECIPE_INVALID")
  {
    nBiQty = GetLocalInt(GetModule(), sKeyToRecipe + "_RecipeBiQty");
  }

  return nBiQty;
}

/////////////////////////////////////////////////////////
int CnrRecipeGetRecipeBiproductQty(string sKeyToMenu, int nRecipeIndex)
{
  string sKeyToRecipe = CnrRecipeGetKeyToRecipe(sKeyToMenu, nRecipeIndex);
  return CnrRecipeGetRecipeBiproductQtyByKey(sKeyToRecipe);
}

/////////////////////////////////////////////////////////
int CnrRecipeGetRecipeAbilityPercentageByKey(string sKeyToRecipe, int nAbilityType)
{
  int nPercentage = 0;

  if (sKeyToRecipe != "RECIPE_INVALID")
  {
    string sKey = sKeyToRecipe + "_RecipeInt";

    if (nAbilityType == ABILITY_STRENGTH)
    {
      sKey = sKeyToRecipe + "_RecipeStr";
    }
    else if (nAbilityType == ABILITY_DEXTERITY)
    {
      sKey = sKeyToRecipe + "_RecipeDex";
    }
    else if (nAbilityType == ABILITY_CONSTITUTION)
    {
      sKey = sKeyToRecipe + "_RecipeCon";
    }
    else if (nAbilityType == ABILITY_INTELLIGENCE)
    {
      sKey = sKeyToRecipe + "_RecipeInt";
    }
    else if (nAbilityType == ABILITY_WISDOM)
    {
      sKey = sKeyToRecipe + "_RecipeWis";
    }
    else if (nAbilityType == ABILITY_CHARISMA)
    {
      sKey = sKeyToRecipe + "_RecipeCha";
    }

    nPercentage = GetLocalInt(GetModule(), sKey);
  }

  return nPercentage;
}

/////////////////////////////////////////////////////////
string CnrRecipeGetRecipeDescByKey(string sKeyToRecipe)
{
  string sRecipeDesc = "RECIPE_INVALID";

  if (sKeyToRecipe != "RECIPE_INVALID")
  {
    sRecipeDesc = GetLocalString(GetModule(), sKeyToRecipe + "_RecipeDesc");
  }

  return sRecipeDesc;
}

/////////////////////////////////////////////////////////
string CnrRecipeGetRecipeDesc(string sKeyToMenu, int nRecipeIndex)
{
  string sKeyToRecipe = CnrRecipeGetKeyToRecipe(sKeyToMenu, nRecipeIndex);
  return CnrRecipeGetRecipeDescByKey(sKeyToRecipe);
}

/////////////////////////////////////////////////////////
string CnrRecipeGetRecipeTagByKey(string sKeyToRecipe)
{
  string sRecipeTag = "RECIPE_INVALID";

  if (sKeyToRecipe != "RECIPE_INVALID")
  {
    sRecipeTag = GetLocalString(GetModule(), sKeyToRecipe + "_RecipeTag");
  }

  return sRecipeTag;
}

/////////////////////////////////////////////////////////
string CnrRecipeGetRecipeTag(string sKeyToMenu, int nRecipeIndex)
{
  string sKeyToRecipe = CnrRecipeGetKeyToRecipe(sKeyToMenu, nRecipeIndex);
  return CnrRecipeGetRecipeTagByKey(sKeyToRecipe);
}

/////////////////////////////////////////////////////////
int CnrRecipeGetRecipeLevelByKey(string sKeyToRecipe)
{
  int nRecipeLevel = 1;

  if (sKeyToRecipe != "RECIPE_INVALID")
  {
    nRecipeLevel = GetLocalInt(GetModule(), sKeyToRecipe + "_RecipeLevel");
    if (nRecipeLevel == 0)
    {
      nRecipeLevel = 1;
    }
  }

  return nRecipeLevel;
}

/////////////////////////////////////////////////////////
int CnrRecipeGetRecipeLevel(string sKeyToMenu, int nRecipeIndex)
{
  string sKeyToRecipe = CnrRecipeGetKeyToRecipe(sKeyToMenu, nRecipeIndex);
  return CnrRecipeGetRecipeLevelByKey(sKeyToRecipe);
}

/////////////////////////////////////////////////////////
int CnrRecipeGetRecipeQtyByKey(string sKeyToRecipe)
{
  int nRecipeQty = 1;

  if (sKeyToRecipe != "RECIPE_INVALID")
  {
    nRecipeQty = GetLocalInt(GetModule(), sKeyToRecipe + "_RecipeQty");
  }

  return nRecipeQty;
}

/////////////////////////////////////////////////////////
int CnrRecipeGetRecipeQty(string sKeyToMenu, int nRecipeIndex)
{
  string sKeyToRecipe = CnrRecipeGetKeyToRecipe(sKeyToMenu, nRecipeIndex);
  return CnrRecipeGetRecipeQtyByKey(sKeyToRecipe);
}

/////////////////////////////////////////////////////////
int CnrRecipeGetRecipeGameXPByKey(string sKeyToRecipe)
{
  if (sKeyToRecipe == "RECIPE_INVALID")
  {
    return 0;
  }

  int nRecipeXP = GetLocalInt(GetModule(), sKeyToRecipe + "_GameXP");

  if (CNR_BOOL_GAME_XP_SCALAR_ENABLED)
  {
    // each recipe can override the global scalar enable flag
    int bScalarOverrideFlag = GetLocalInt(GetModule(), sKeyToRecipe + "_ScalarOverrideFlag");

    if (bScalarOverrideFlag != TRUE)
    {
      float fRecipeXP = IntToFloat(nRecipeXP);
      fRecipeXP *= CNR_FLOAT_GAME_XP_SCALAR;
      nRecipeXP = FloatToInt(fRecipeXP);
    }
  }

  return nRecipeXP;
}

/////////////////////////////////////////////////////////
int CnrRecipeGetRecipeGameXP(string sKeyToMenu, int nRecipeIndex)
{
  string sKeyToRecipe = CnrRecipeGetKeyToRecipe(sKeyToMenu, nRecipeIndex);
  return CnrRecipeGetRecipeGameXPByKey(sKeyToRecipe);
}

/////////////////////////////////////////////////////////
int CnrRecipeGetRecipeTradeXPByKey(string sKeyToRecipe)
{
  int nRecipeXP = 0;

  if (sKeyToRecipe != "RECIPE_INVALID")
  {
    nRecipeXP = GetLocalInt(GetModule(), sKeyToRecipe + "_TradeXP");
  }

  return nRecipeXP;
}

/////////////////////////////////////////////////////////
int CnrRecipeGetRecipeTradeXP(string sKeyToMenu, int nRecipeIndex)
{
  string sKeyToRecipe = CnrRecipeGetKeyToRecipe(sKeyToMenu, nRecipeIndex);
  return CnrRecipeGetRecipeTradeXPByKey(sKeyToRecipe);
}

/////////////////////////////////////////////////////////
int CnrRecipeGetComponentCountByKey(string sKeyToRecipe)
{
  int nComponentCount = 0;

  if (sKeyToRecipe != "RECIPE_INVALID")
  {
    nComponentCount = GetLocalInt(GetModule(), sKeyToRecipe + "_RecipeComponentCount");
  }

  return nComponentCount;
}

/////////////////////////////////////////////////////////
int CnrRecipeGetComponentCount(string sKeyToMenu, int nRecipeIndex)
{
  string sKeyToRecipe = CnrRecipeGetKeyToRecipe(sKeyToMenu, nRecipeIndex);
  return CnrRecipeGetComponentCountByKey(sKeyToRecipe);
}

/////////////////////////////////////////////////////////
string CnrRecipeGetComponentTag(string sKeyToRecipe, int nComponentIndex)
{
  string sComponentTag = "COMPONENT_INVALID";

  if (sKeyToRecipe != "RECIPE_INVALID")
  {
    // Check if nComponentIndex is valid
    int nComponentCount = CnrRecipeGetComponentCountByKey(sKeyToRecipe);
    if ((nComponentIndex > 0) && (nComponentIndex <= nComponentCount))
    {
      string sKeyToComponentTag = sKeyToRecipe + "_" + IntToString(nComponentIndex) + "_Tag";
      sComponentTag = GetLocalString(GetModule(), sKeyToComponentTag);
    }
  }

  return sComponentTag;
}

/////////////////////////////////////////////////////////
int CnrRecipeGetComponentQty(string sKeyToRecipe, int nComponentIndex)
{
  int nComponentQty = 0;

  if (sKeyToRecipe != "RECIPE_INVALID")
  {
    // Check if nComponentIndex is valid
    int nComponentCount = CnrRecipeGetComponentCountByKey(sKeyToRecipe);
    if ((nComponentIndex > 0) && (nComponentIndex <= nComponentCount))
    {
      string sKeyToComponentQty = sKeyToRecipe + "_" + IntToString(nComponentIndex) + "_Qty";
      nComponentQty = GetLocalInt(GetModule(), sKeyToComponentQty);
    }
  }

  return nComponentQty;
}

/////////////////////////////////////////////////////////
int CnrRecipeGetComponentRetainOnFailQty(string sKeyToRecipe, int nComponentIndex)
{
  int nRetainQty = 0;

  if (sKeyToRecipe != "RECIPE_INVALID")
  {
    // Check if nComponentIndex is valid
    int nComponentCount = CnrRecipeGetComponentCountByKey(sKeyToRecipe);
    if ((nComponentIndex > 0) && (nComponentIndex <= nComponentCount))
    {
      string sKeyToRetainQty = sKeyToRecipe + "_" + IntToString(nComponentIndex) + "_RetainQty";
      nRetainQty = GetLocalInt(GetModule(), sKeyToRetainQty);
    }
  }

  return nRetainQty;
}

/////////////////////////////////////////////////////////
int CnrRecipeCheckComponentAvailability(object oPC, object oContainer, string sKeyToRecipe)
{
  if (!GetIsObjectValid(oContainer))
  {
    return 0;
  }

  if (sKeyToRecipe == "RECIPE_INVALID")
  {
    return 0;
  }

  int nTotalBatchCount = 99;  // something obsurd
  int nComponentCount = CnrRecipeGetComponentCountByKey(sKeyToRecipe);
  int nComponentIndex;
  for (nComponentIndex=1; nComponentIndex<=nComponentCount; nComponentIndex++)
  {
    string sComponentTag = CnrRecipeGetComponentTag(sKeyToRecipe, nComponentIndex);
    if (sComponentTag == "CNR_RECIPE_SPELL")
    {
      // Search the crafter's memorized spell list for this type of spell
      // and tally the count.
      int nComponentQty = CnrRecipeGetComponentQty(sKeyToRecipe, nComponentIndex);
      int nSpell = CnrRecipeGetComponentRetainOnFailQty(sKeyToRecipe, nComponentIndex);
      int nSpellCount = GetHasSpell(nSpell, oPC);

      int nBatchCount = nSpellCount / nComponentQty;
      if (nBatchCount < nTotalBatchCount)
      {
        nTotalBatchCount = nBatchCount;
      }
    }
    else if (sComponentTag != "COMPONENT_INVALID")
    {
      // Search the container's inventory for this type of item
      // and tally the count.
      int nItemCount = 0;

      object oItem = GetFirstItemInInventory(oContainer);
      while (oItem != OBJECT_INVALID)
      {
        if (GetTag(oItem) == sComponentTag)
        {
          nItemCount += GetNumStackedItems(oItem);
        }
        oItem = GetNextItemInInventory(oContainer);
      }

      int nComponentQty = CnrRecipeGetComponentQty(sKeyToRecipe, nComponentIndex);
      int nBatchCount = nItemCount / nComponentQty;
      if (nBatchCount < nTotalBatchCount)
      {
        nTotalBatchCount = nBatchCount;
      }
    }

    // abort early if possible
    if (nTotalBatchCount == 0) return 0;
  }

  return nTotalBatchCount;
}

/////////////////////////////////////////////////////////
string CnrRecipeBuildRecipeStringCommon(object oPC, object oContainer, string sKeyToRecipe)
{
  string sRecipe = CnrRecipeGetRecipeDescByKey(sKeyToRecipe);
  sRecipe = sRecipe + "\n";
  int nComponentCount = CnrRecipeGetComponentCountByKey(sKeyToRecipe);
  int nComponentIndex;
  for (nComponentIndex=1; nComponentIndex<=nComponentCount; nComponentIndex++)
  {
    string sComponentTag = CnrRecipeGetComponentTag(sKeyToRecipe, nComponentIndex);
    int nComponentQty = CnrRecipeGetComponentQty(sKeyToRecipe, nComponentIndex);

    if (sComponentTag == "CNR_RECIPE_SPELL")
    {
      // Search the crafter's memorized spell list for this type of spell
      // and tally the count.
      int nSpell = CnrRecipeGetComponentRetainOnFailQty(sKeyToRecipe, nComponentIndex);
      int nSpellCount = GetHasSpell(nSpell, oPC);
      sRecipe = sRecipe + IntToString(nSpellCount) + CNR_TEXT_OF + IntToString(nComponentQty) + "   " + CNR_TEXT_SPELLS_OF + GetStringByStrRef(StringToInt(Get2DAString("spells", "Name", nSpell))) + "\n";
    }
    else if (sComponentTag != "COMPONENT_INVALID")
    {
      // Search the device's inventory for this type of item
      // and tally the count.
      int nItemCount = 0;
      object oItem = GetFirstItemInInventory(oContainer);
      while (oItem != OBJECT_INVALID)
      {
        if (GetTag(oItem) == sComponentTag)
        {
          nItemCount += GetNumStackedItems(oItem);
        }
        oItem = GetNextItemInInventory(oContainer);
      }

      // If oContainer already has an item of sComponentTag type,
      // get its name for the recipe list string.
      oItem = GetItemPossessedBy(oContainer, sComponentTag);
      if (oItem != OBJECT_INVALID)
      {
        sRecipe = sRecipe + IntToString(nItemCount) + CNR_TEXT_OF + IntToString(nComponentQty) + "   " + GetName(oItem) + "\n";
      }
      else
      {
        // Create a temporary instance of this object so we can get its name.
        oItem = CreateObject(OBJECT_TYPE_ITEM, sComponentTag, GetLocation(oContainer), FALSE);
        if (oItem != OBJECT_INVALID)
        {
          sRecipe = sRecipe + "0" + CNR_TEXT_OF + IntToString(nComponentQty) + "   " + GetName(oItem) + "\n";
          DestroyObject(oItem);
        }
      }
    }
    else
    {
      sRecipe = sRecipe + "?" + CNR_TEXT_OF + IntToString(nComponentQty) + "   " + CNR_INVALID_COMPONENT + "\n";
    }
  }

  return sRecipe;
}

/////////////////////////////////////////////////////////
int CnrRecipeGetRecipeAbilityPercentage(string sDeviceTag, string sKeyToRecipe, int nAbilityType)
{ 
  // If there is a value specified for the recipe, use that.  Otherwise use the menu 
  // (tag of the placeable).  
  int nPercent = CnrRecipeGetRecipeAbilityPercentageByKey(sKeyToRecipe, nAbilityType);
  
  if (nPercent) return nPercent;
  else return CnrRecipeGetRecipeAbilityPercentageByKey(sDeviceTag, nAbilityType);
}

/////////////////////////////////////////////////////////
string CnrRecipeGetAbilityString(string sDeviceTag, string sKeyToRecipe, int bIncludeLevel)
{
  if (sKeyToRecipe == "RECIPE_INVALID") return CNR_TEXT_INTELLIGENCE;
  string sDeviceTradeskillType = IntToString(GetLocalInt(GetModule(), sDeviceTag + "_TradeskillType"));

  object oModule = GetModule();

  float fRecipeStr = IntToFloat(CnrRecipeGetRecipeAbilityPercentage(sDeviceTradeskillType, sKeyToRecipe, ABILITY_STRENGTH));
  float fRecipeDex = IntToFloat(CnrRecipeGetRecipeAbilityPercentage(sDeviceTradeskillType, sKeyToRecipe, ABILITY_DEXTERITY));
  float fRecipeCon = IntToFloat(CnrRecipeGetRecipeAbilityPercentage(sDeviceTradeskillType, sKeyToRecipe, ABILITY_CONSTITUTION));
  float fRecipeInt = IntToFloat(CnrRecipeGetRecipeAbilityPercentage(sDeviceTradeskillType, sKeyToRecipe, ABILITY_INTELLIGENCE));
  float fRecipeWis = IntToFloat(CnrRecipeGetRecipeAbilityPercentage(sDeviceTradeskillType, sKeyToRecipe, ABILITY_WISDOM));
  float fRecipeCha = IntToFloat(CnrRecipeGetRecipeAbilityPercentage(sDeviceTradeskillType, sKeyToRecipe, ABILITY_CHARISMA));

  int nAbilityCount = 0;
  if (fRecipeStr > 0.0) { nAbilityCount++; }
  if (fRecipeDex > 0.0) { nAbilityCount++; }
  if (fRecipeCon > 0.0) { nAbilityCount++; }
  if (fRecipeInt > 0.0) { nAbilityCount++; }
  if (fRecipeWis > 0.0) { nAbilityCount++; }
  if (fRecipeCha > 0.0) { nAbilityCount++; }

  if (nAbilityCount == 0)
  {
    // default to intelligence
    return CNR_TEXT_INTELLIGENCE;
  }

  int nAbilityCountOrig = nAbilityCount;

  string sAbilityString;
  if (fRecipeStr > 0.0)
  {
    sAbilityString += CNR_TEXT_STRENGTH;
    if ((nAbilityCount == 1) && (bIncludeLevel == TRUE)) {sAbilityString += CNR_TEXT_AND_LEVEL;}
    else if ((nAbilityCount == 2) && (bIncludeLevel == FALSE)) {sAbilityString += CNR_TEXT_AND;}
    else if (nAbilityCount > 1) {sAbilityString += ", ";}
    nAbilityCount--;
  }
  if (fRecipeDex > 0.0)
  {
    sAbilityString += CNR_TEXT_DEXTERITY;
    if ((nAbilityCount == 1) && (bIncludeLevel == TRUE)) {sAbilityString += CNR_TEXT_AND_LEVEL;}
    else if ((nAbilityCount == 2) && (bIncludeLevel == FALSE)) {sAbilityString += CNR_TEXT_AND;}
    else if (nAbilityCount > 1) {sAbilityString += ", ";}
    nAbilityCount--;
  }
  if (fRecipeCon > 0.0)
  {
    sAbilityString += CNR_TEXT_CONSTITUTION;
    if ((nAbilityCount == 1) && (bIncludeLevel == TRUE)) {sAbilityString += CNR_TEXT_AND_LEVEL;}
    else if ((nAbilityCount == 2) && (bIncludeLevel == FALSE)) {sAbilityString += CNR_TEXT_AND;}
    else if (nAbilityCount > 1) {sAbilityString += ", ";}
    nAbilityCount--;
  }
  if (fRecipeInt > 0.0)
  {
    sAbilityString += CNR_TEXT_INTELLIGENCE;
    if ((nAbilityCount == 1) && (bIncludeLevel == TRUE)) {sAbilityString += CNR_TEXT_AND_LEVEL;}
    else if ((nAbilityCount == 2) && (bIncludeLevel == FALSE)) {sAbilityString += CNR_TEXT_AND;}
    else if (nAbilityCount > 1) {sAbilityString += ", ";}
    nAbilityCount--;
  }
  if (fRecipeWis > 0.0)
  {
    sAbilityString += CNR_TEXT_WISDOM;
    if ((nAbilityCount == 1) && (bIncludeLevel == TRUE)) {sAbilityString += CNR_TEXT_AND_LEVEL;}
    else if ((nAbilityCount == 2) && (bIncludeLevel == FALSE)) {sAbilityString += CNR_TEXT_AND;}
    else if (nAbilityCount > 1) {sAbilityString += ", ";}
    nAbilityCount--;
  }
  if (fRecipeCha > 0.0)
  {
    sAbilityString += CNR_TEXT_CHARISMA;
    if ((nAbilityCount == 1) && (bIncludeLevel == TRUE)) {sAbilityString += CNR_TEXT_AND_LEVEL;}
  }

  return sAbilityString;
}

/////////////////////////////////////////////////////////
float CnrRecipeGetWeightedPcAbility(object oPC, string sDeviceTag, string sKeyToRecipe)
{
  if (!GetIsPC(oPC)) return 14.0;
  if (sKeyToRecipe == "RECIPE_INVALID") return 14.0;

  object oModule = GetModule();
  string sDeviceTradeskillType = IntToString(GetLocalInt(GetModule(), sDeviceTag + "_TradeskillType"));
  
  float fRecipeStr = IntToFloat(CnrRecipeGetRecipeAbilityPercentage(sDeviceTradeskillType, sKeyToRecipe, ABILITY_STRENGTH));
  float fRecipeDex = IntToFloat(CnrRecipeGetRecipeAbilityPercentage(sDeviceTradeskillType, sKeyToRecipe, ABILITY_DEXTERITY));
  float fRecipeCon = IntToFloat(CnrRecipeGetRecipeAbilityPercentage(sDeviceTradeskillType, sKeyToRecipe, ABILITY_CONSTITUTION));
  float fRecipeInt = IntToFloat(CnrRecipeGetRecipeAbilityPercentage(sDeviceTradeskillType, sKeyToRecipe, ABILITY_INTELLIGENCE));
  float fRecipeWis = IntToFloat(CnrRecipeGetRecipeAbilityPercentage(sDeviceTradeskillType, sKeyToRecipe, ABILITY_WISDOM));
  float fRecipeCha = IntToFloat(CnrRecipeGetRecipeAbilityPercentage(sDeviceTradeskillType, sKeyToRecipe, ABILITY_CHARISMA));

  float fPcStr = IntToFloat(GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE) + (GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE) - 10) / 2);
  float fPcDex = IntToFloat(GetAbilityScore(oPC, ABILITY_DEXTERITY, TRUE) + (GetAbilityScore(oPC, ABILITY_DEXTERITY, TRUE) - 10) / 2);
  float fPcCon = IntToFloat(GetAbilityScore(oPC, ABILITY_CONSTITUTION, TRUE) + (GetAbilityScore(oPC, ABILITY_CONSTITUTION, TRUE) - 10) / 2);
  float fPcInt = IntToFloat(GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE) + (GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE) - 10) / 2);
  float fPcWis = IntToFloat(GetAbilityScore(oPC, ABILITY_WISDOM, TRUE) + (GetAbilityScore(oPC, ABILITY_WISDOM, TRUE) - 10) / 2);
  float fPcCha = IntToFloat(GetAbilityScore(oPC, ABILITY_CHARISMA,TRUE) + (GetAbilityScore(oPC, ABILITY_CHARISMA, TRUE) - 10) / 2);

  float fPcAbility;
  fPcAbility  = fPcStr * (fRecipeStr/100.0);
  fPcAbility += fPcDex * (fRecipeDex/100.0);
  fPcAbility += fPcCon * (fRecipeCon/100.0);
  fPcAbility += fPcInt * (fRecipeInt/100.0);
  fPcAbility += fPcWis * (fRecipeWis/100.0);
  fPcAbility += fPcCha * (fRecipeCha/100.0);

  if (fPcAbility == 0.0)
  {
    // if nothing specified, use intelligence
    fPcAbility = fRecipeInt;
  }

  return fPcAbility;
}

/////////////////////////////////////////////////////////
int GetBuildersAdjustmentToRecipeDC(object oPC, string sDeviceTag, string sKeyToRecipe)
{
  // prep for hook script
  SetLocalInt(oPC, "CnrHookHelperAdjustmentToRecipeDC", 0);
  SetLocalString (oPC, "CnrHookHelperKeyToRecipeInProgress", sKeyToRecipe);
  int nDeviceTradeskillType = GetLocalInt(GetModule(), sDeviceTag + "_TradeskillType");
  SetLocalInt (oPC, "CnrHookHelperTradeskillType", nDeviceTradeskillType);

  // execute hook script
  ExecuteScript("hook_get_dc_adj", oPC);

  // get results
  int nAdjustment = GetLocalInt(oPC, "CnrHookHelperAdjustmentToRecipeDC");

  // clean up
  DeleteLocalInt(oPC, "CnrHookHelperAdjustmentToRecipeDC");
  DeleteLocalString (oPC, "CnrHookHelperKeyToRecipeInProgress");
  DeleteLocalInt (oPC, "CnrHookHelperTradeskillType");

  return nAdjustment;
}

/////////////////////////////////////////////////////////
int CnrRecipeCalculateEffectiveDC(object oPC, string sDeviceTag, string sKeyToRecipe)
{
  int nRecipeLevel = CnrRecipeGetRecipeLevelByKey(sKeyToRecipe);
  int nPcLevel = CnrGetPlayerLevel(oPC, sDeviceTag);
  
  if (nPcLevel >= 0 && GetLocalInt(gsPCGetCreatureHide(oPC), "GIFT_CRAFTSMANSHIP"))
  {
    nPcLevel += 1;
  }
  
  if (nPcLevel == -1) 
  {
    // this device does not need skill checks. 
	return 0;
  }
  
  float fPcAbility = CnrRecipeGetWeightedPcAbility(oPC, sDeviceTag, sKeyToRecipe);

  // Formula: DC = (((11 - (PL*2)) - (A/2)) + 27) - ((10-RL)*2)
  int nEffDC = (((11 - (nPcLevel*2)) - FloatToInt(fPcAbility/2.0)) + 27) - ((10-nRecipeLevel) * 2);

  // Get a builder supplied DC adjustment
  int nAdjustment = GetBuildersAdjustmentToRecipeDC(oPC, sDeviceTag, sKeyToRecipe);

  return nEffDC + nAdjustment;
}

/////////////////////////////////////////////////////////
int CnrRecipeCalculateMinimumPcLevel(object oPC, string sDeviceTag, string sKeyToRecipe)
{
  int nRecipeLevel = CnrRecipeGetRecipeLevelByKey(sKeyToRecipe);
  float fPcAbility = CnrRecipeGetWeightedPcAbility(oPC, sDeviceTag, sKeyToRecipe);

  // Get a builder supplied DC adjustment
  int nAdjustment = GetBuildersAdjustmentToRecipeDC(oPC, sDeviceTag, sKeyToRecipe);

  // Given the player's current ability score, calculate the minimum level
  // the PC needs to be to have any chance of success crafting this recipe.
  //int nMinPcLevel = (11 - (((20 + ((10-nRecipeLevel)*2)) - 27) + (nPcAbility/2))) / 2;
  float fMinPcLevel = IntToFloat(11 - ((((20+nAdjustment) + ((10-nRecipeLevel)*2)) - 27) + FloatToInt(fPcAbility/2.0))) / 2.0;
  int nMinPcLevel = FloatToInt(fMinPcLevel);
  if (IntToFloat(nMinPcLevel) < fMinPcLevel)
  {
    // round up
    nMinPcLevel++;
  }
  return nMinPcLevel;
}

/////////////////////////////////////////////////////////
string CnrRecipeBuildRecipeString(object oDevice, int nRecipeIndex)
{
  if (!GetIsObjectValid(oDevice))
  {
    return "Invalid Container specified in code - notify the module builder.";
  }

  string sDeviceTag = GetTag(oDevice);
  if (GetIsPC(oDevice))
  {
    sDeviceTag = GetLocalString(oDevice, "cnrRecipeBookDevice");
  }

  object oPC = GetPCSpeaker();
  string sKeyToMenu = GetLocalString(oPC, "sCnrCurrentMenu");
  string sKeyToRecipe = CnrRecipeGetKeyToRecipeOnPC(oPC, sKeyToMenu, nRecipeIndex);
  if (sKeyToRecipe == "RECIPE_INVALID")
  {
    return "RECIPE_INVALID";
  }

  // Reference the module's recipe. Convert from PC recipe key to module recipe key.
  sKeyToRecipe = GetLocalString(oPC, sKeyToRecipe);

  string sRecipe = CnrRecipeBuildRecipeStringCommon(oPC, oDevice, sKeyToRecipe);

  int nEffDC = CnrRecipeCalculateEffectiveDC(oPC, sDeviceTag, sKeyToRecipe);
  if (nEffDC < 2)
  {
    sRecipe = sRecipe + "\n" + CNR_THIS_RECIPE_IS_TRIVIAL;
  }
  else if (nEffDC > 20)
  {
    // Given the player's current ability score, calculate the minimum level
    // the PC needs to be to have any chance of success crafting this recipe.
    int nMinPcLevel = CnrRecipeCalculateMinimumPcLevel(oPC, sDeviceTag, sKeyToRecipe);
    sRecipe += "\n" + CNR_TEXT_GIVEN_YOUR;
    string sAbilityString = CnrRecipeGetAbilityString(sDeviceTag, sKeyToRecipe, FALSE);
    sRecipe += sAbilityString;
    sRecipe += CNR_TEXT_THIS_RECIPE_IS_IMPOSSIBLE + " ";
    sRecipe += CNR_TEXT_YOU_WILL_NEED_TO_REACH_LEVEL + IntToString(nMinPcLevel);
    sRecipe += CNR_TEXT_TO_HAVE_A_CHANCE_OF_SUCCESS;
  }
  else
  {
    sRecipe += "\n" + CNR_TEXT_GIVEN_YOUR;
    string sAbilityString = CnrRecipeGetAbilityString(sDeviceTag, sKeyToRecipe, TRUE);
    sRecipe += sAbilityString;
    sRecipe += CNR_TEXT_YOU_HAVE_A + IntToString(100-((nEffDC-1)*5)) + CNR_TEXT_PERCENT_CHANCE_OF_SUCCESS;
  }
  return sRecipe;
}

/////////////////////////////////////////////////////////
void CnrRecipeCreateItemOnObject(string sItemTag, object oTarget, int nQty)
{
  object oItem = CreateItemOnObject(sItemTag, oTarget, nQty);
  SetIdentified(oItem, TRUE);
}

/////////////////////////////////////////////////////////
void CnrRecipeDisplayCraftingResult(object oPC, object oDevice, string sKeyToRecipe, int bSuccess, string sResult, int nEffDC, location locPCAtStart, int bWithConvo)
{
  // Delete the "I am crafting" flag.
  DeleteLocalInt(oPC, "CNR_CRAFTING");

  // Slow this down as a check on grinding.
  int nBatchCount = CnrRecipeCheckComponentAvailability(oPC, oDevice, sKeyToRecipe);
  if (nBatchCount > 1)
  {
    nBatchCount = 1;
	
	// Set the "disturbed" flag so that the PC can craft more copies
	// without needing to manipulate the inventory. 
	SetLocalInt(OBJECT_SELF, "bCnrDisturbed", TRUE);
  }
  
  if (GetIsPC(oDevice))
  {
    // only build 1 batch when using a recipe book
    nBatchCount = 1;
  }

  int nItemCount = 0;

  string sInfo1;
  string sInfo2;

  // Destroy the components required for the recipe (success or failure)
  int nComponentCount = CnrRecipeGetComponentCountByKey(sKeyToRecipe);
  int nComponentIndex;
  for (nComponentIndex=1; nComponentIndex<=nComponentCount; nComponentIndex++)
  {
    string sComponentTag = CnrRecipeGetComponentTag(sKeyToRecipe, nComponentIndex);
    int nComponentQty = CnrRecipeGetComponentQty(sKeyToRecipe, nComponentIndex);

    if (sComponentTag == "CNR_RECIPE_SPELL")
    {
      if ((bSuccess) || (!bSuccess && (CNR_BOOL_DECREMENT_SPELLS_ON_SUCCESS_ONLY != TRUE)))
      {
        // Remove the spell from crafter's memorized spell list on success or failure.
        int nSpell = CnrRecipeGetComponentRetainOnFailQty(sKeyToRecipe, nComponentIndex);
        int nSpellCount = nComponentQty * nBatchCount;
        int n;
        for (n=0; n<nSpellCount; n++)
        {
          DecrementRemainingSpellUses(oPC, nSpell);
        }
      }
    }
    else
    {
      int nRetainOnFailQty = CnrRecipeGetComponentRetainOnFailQty(sKeyToRecipe, nComponentIndex);

      nItemCount = 0;
      if (bSuccess)
      {
        // Search the container's inventory for this type of item
        // and destroy the qty needed to make the recipe.
        nItemCount = nComponentQty * nBatchCount;
      }
      else // failure
      {
        nItemCount = (nComponentQty - nRetainOnFailQty) * nBatchCount;
      }

      // We've now determined how many items to destroy, so destroy them.
      if (nItemCount > 0)
      {
        object oItem = GetFirstItemInInventory(oDevice);
        while ((oItem != OBJECT_INVALID) && (nItemCount > 0))
        {
          if (GetTag(oItem) == sComponentTag)
          {
            int nStackSize = GetNumStackedItems(oItem);
            if (nStackSize <= nItemCount)
            {
              DestroyObject(oItem);
              nItemCount -= nStackSize;
            }
            else
            {
              // split the stack
              DestroyObject(oItem);
              // DestroyObject is deferred, so create must be deferred also to keep order
              AssignCommand(oPC, CnrRecipeCreateItemOnObject(sComponentTag, oDevice, nStackSize-nItemCount));
              nItemCount = 0;
            }
          }
          oItem = GetNextItemInInventory(oDevice);
        }
      }
    }
  }
   
  // Worship hook - increase Piety by number of batches * 0.2 %
  int nAspect = gsWOGetDeityAspect(oPC);
  if (nAspect & ASPECT_KNOWLEDGE_INVENTION)
  {
    gsWOAdjustPiety(oPC, nBatchCount * 0.2f);
  }
  
  string sRecipeBiTag = CnrRecipeGetRecipeBiproductTagByKey(sKeyToRecipe);
  int nRecipeBiQty = CnrRecipeGetRecipeBiproductQtyByKey(sKeyToRecipe);
  int nOnFailBiQty = CnrRecipeGetRecipeOnFailBiproductQtyByKey(sKeyToRecipe);
  int bSpawnItemInDevice = TRUE;
  object oItem;
  //if (!GetIsPC(oDevice))
  //{
  //  if (GetLocalInt(GetModule(), GetTag(oDevice) + "_SpawnItemInDevice"))
  //  {
  //    bSpawnItemInDevice = TRUE;
  //  }
  //}

  // Create the recipe biproduct (if assigned)
  if (sRecipeBiTag != "BIPRODUCT_INVALID")
  {
    nItemCount = 0;
    if (bSuccess)
    {
      nItemCount = nRecipeBiQty;
    }
    else
    {
      nItemCount = nOnFailBiQty;
    }

    // Create the recipe biproduct (if assigned)
    if (nItemCount > 0)
    {
      int nBatch;
      for (nBatch=0; nBatch<(nBatchCount*nItemCount); nBatch++)
      {
        if (bSpawnItemInDevice)
        {
		  oItem = CreateItemOnObject(sRecipeBiTag, oDevice, 1);
		  gsIPSetOwner(oItem, oPC);
          SetIdentified(oItem, TRUE);
        }
        else
        {
          AssignCommand(oPC, CnrRecipeCreateItemOnObject(sRecipeBiTag, oPC, 1));
        }
      }
    }
  }

  if (bSuccess)
  {
    // Create the crafted item(s)
    string sRecipeTag = CnrRecipeGetRecipeTagByKey(sKeyToRecipe);
    int nRecipeQty = CnrRecipeGetRecipeQtyByKey(sKeyToRecipe);
    int nBatch;
    for (nBatch=0; nBatch<nBatchCount; nBatch++)
    {
      int nItem;
      for (nItem=0; nItem<nRecipeQty; nItem++)
      {
        if (bSpawnItemInDevice)
        {
		  oItem = CreateItemOnObject(sRecipeTag, oDevice, 1);
		  gsIPSetOwner(oItem, oPC);
          SetIdentified(oItem, TRUE);
        }
        else
        {
          AssignCommand(oPC, CnrRecipeCreateItemOnObject(sRecipeTag, oPC, 1));
        }
      }
	  
      sResult = "You successfully made " + IntToString(nBatchCount*nRecipeQty);
      if ((nBatchCount*nRecipeQty) > 1)
      {
        sResult += " items.";
      }
      else
      {
        sResult += " item.";
      }
    }
  }
  
  string sDeviceTag = GetTag(oDevice);
  if (GetIsPC(oDevice))
  {
    sDeviceTag = GetLocalString(oDevice, "cnrRecipeBookDevice");
  }
  int nDeviceTradeskillType = GetLocalInt(GetModule(), sDeviceTag + "_TradeskillType");

  // don't calculate a negative value for XP
  if (nEffDC < 1) nEffDC = 1;
  int nGameXP = CnrRecipeGetRecipeGameXPByKey(sKeyToRecipe);
  int nTradeXP = CnrRecipeGetRecipeTradeXPByKey(sKeyToRecipe);

  // XP is scaled as follows...
  // The first time you craft a recipe, 10x recipe level. 
  // a 5% success chance yields 95% of 2*RecipeXP
  // a 50% success chance yields 50% of 2*RecipeXP
  // a 95% success chance yields 5% of 2*RecipeXP
  // On failure, get XP based on your current craft level (no bonus for trying harder things).
  // All xp is gained as adventuring XP (i.e. to be distributed later). 
  float fScale = IntToFloat(nEffDC-1) / 10.0f;
  int nScaledGameXP = (bSuccess ? FloatToInt(fScale * IntToFloat(nGameXP)) : CnrGetPlayerLevel(oPC, sDeviceTag) / 2);
  int nScaledTradeXP = (bSuccess ? FloatToInt(fScale * IntToFloat(nTradeXP)) :  3 * CnrGetPlayerLevel(oPC, sDeviceTag));

  int nOldXP = GetXP(oPC);
  int nNewXP = nScaledGameXP*nBatchCount;

  object oHide = gsPCGetCreatureHide(oPC);
  int iQtyFinished = GetLocalInt(oHide, "GVD_CRAFT_" + sKeyToRecipe);
  if (iQtyFinished == 0 && bSuccess)
  {
    nNewXP = CnrRecipeGetRecipeLevelByKey(sKeyToRecipe)*10;
	SetLocalInt(oHide, "GVD_CRAFT_" + sKeyToRecipe, TRUE);
    miDVGivePoints(oPC, ELEMENT_FIRE, IntToFloat(nNewXP));
  }
  else
  {
    // Divination hook - increase Earth by number of batches. 
    miDVGivePoints(oPC, ELEMENT_EARTH, IntToFloat(nBatchCount));
  }
  
  sInfo1 = CNR_TEXT_YOUR_ADVENTURING_XP_INCREASED_BY + IntToString(nNewXP) + ".\n";
  if (nNewXP) gvd_AdventuringXP_GiveXP(oPC, nNewXP, "Crafting");

  if (nDeviceTradeskillType != CNR_TRADESKILL_NONE)
  {
    nOldXP = CnrGetTradeskillXPByType(oPC, nDeviceTradeskillType);
    nNewXP = nOldXP + (nScaledTradeXP*nBatchCount);

    int bUpdateJournal = FALSE;
    string sTradeName = CnrGetTradeskillNameByType(nDeviceTradeskillType);
    if (nScaledTradeXP > 0)
    {
      sInfo2 = CNR_TEXT_YOUR + sTradeName + CNR_TEXT_XP_INCREASED_BY + IntToString(nScaledTradeXP*nBatchCount) + ".\n\n";
      bUpdateJournal = TRUE;
    }
    else if (nScaledTradeXP < 0)
    {
      sInfo2 = CNR_TEXT_YOUR + sTradeName + CNR_TEXT_XP_DECREASED_BY + IntToString(nScaledTradeXP*nBatchCount) + ".\n\n";
      bUpdateJournal = TRUE;
    }

    int bLevelDenied = FALSE;
    if (bUpdateJournal)
    {
      int nOldLevel = CnrDetermineTradeskillLevel(nOldXP);
      int nNewLevel = CnrDetermineTradeskillLevel(nNewXP);
      if (nNewLevel > nOldLevel)
      {
        // prep for hook script
        SetLocalInt(oPC, "CnrHookHelperTradeskillType", nDeviceTradeskillType);
        SetLocalInt(oPC, "CnrHookHelperNextLevel", nNewLevel);
        SetLocalInt(oPC, "CnrHookHelperLevelUpDenied", FALSE);
        DeleteLocalString(oPC, "CnrHookHelperLevelUpDeniedText");

        // execute hook script
        ExecuteScript("hook_ok_to_level", oPC);

        // check results
        bLevelDenied = GetLocalInt(oPC, "CnrHookHelperLevelUpDenied");
        if (!bLevelDenied)
        {
          string sNewLevel = CNR_TEXT_YOU_HAVE_REACHED_LEVEL + IntToString(nNewLevel) + CNR_TEXT_IN + sTradeName + "!";
          AssignCommand(oPC, DelayCommand(0.6, SendMessageToPC(oPC, sNewLevel)));
          AssignCommand(oPC, DelayCommand(0.6, PlaySound("gui_level_up")));
        }
        else
        {
          sInfo2 = GetLocalString(oPC, "CnrHookHelperLevelUpDeniedText");

          // set the PC's XP to one point below making the level
          nNewXP = GetLocalInt(GetModule(), "CnrTradeXPLevel" + IntToString(nNewLevel)) - 1;
        }

        // clean up
        DeleteLocalInt(oPC, "CnrHookHelperTradeskillType");
        DeleteLocalInt(oPC, "CnrHookHelperNextLevel");
        DeleteLocalString(oPC, "CnrHookHelperLevelUpDeniedText");

      }

      CnrSetTradeskillXPByType(oPC, nDeviceTradeskillType, nNewXP);

      if (!bLevelDenied)
      {
        if (nNewLevel < 20)
        {
          int nLevelXP = GetLocalInt(GetModule(), "CnrTradeXPLevel" + IntToString(nNewLevel+1));
          nLevelXP -= nNewXP;
          sInfo2 += CNR_TEXT_YOU_NEED + IntToString(nLevelXP) + CNR_TEXT_XP_TO_REACH_THE_NEXT_LEVEL_IN + sTradeName + ".";
        }
        sInfo2 += CNR_TEXT_YOU_ARE_CURRENTLY_AT_LEVEL + IntToString(nNewLevel) + ".\n";
      }
    }
    
    if (bWithConvo != TRUE)
    {
      return;
    }

    sResult += "\n\n" + sInfo1 + sInfo2;
  }

  if (bWithConvo != TRUE)
  {
    return;
  }
  else
  {
    //SetCustomToken(22000, sResult);
    SetLocalString(oPC, "sCnrTokenText" + IntToString(22000), sResult);
    // Note: the custom token will be set in "cnr_ta_tok_22000".
    ActionStartConversation(oPC, "cnr_c_craft_it", TRUE);
  }
}

/////////////////////////////////////////////////////////
int CnrRecipeAttemptToCraftNoCheck(object oPC, object oDevice, int nRecipeIndex)
{
  if (!GetIsPC(oPC))
  {
    return FALSE;
  }

  if (!GetIsObjectValid(oDevice))
  {
    return FALSE;
  }

  string sDeviceTag = GetTag(oDevice);
  if (GetIsPC(oDevice))
  {
    sDeviceTag = GetLocalString(oDevice, "cnrRecipeBookDevice");
  }

  string sKeyToMenu = GetLocalString(oPC, "sCnrCurrentMenu");
  string sKeyToRecipe = CnrRecipeGetKeyToRecipeOnPC(oPC, sKeyToMenu, nRecipeIndex);
  if (sKeyToRecipe == "RECIPE_INVALID")
  {
    return FALSE;
  }

  // Reference the module's recipe. Convert from PC recipe key to module recipe key.
  sKeyToRecipe = GetLocalString(oPC, sKeyToRecipe);

  int nBatchCount = CnrRecipeCheckComponentAvailability(oPC, oDevice, sKeyToRecipe);
  if (nBatchCount == 0)
  {
    return FALSE;
  }
  else
  {
    // Slow crafting down.
    nBatchCount = 1;
  }

  if (GetIsPC(oDevice))
  {
    // only build 1 batch when using a recipe book
    nBatchCount = 1;
  }

  int nItemCount = 0;

  // Destroy the components required for the recipe
  int nComponentCount = CnrRecipeGetComponentCountByKey(sKeyToRecipe);
  int nComponentIndex;
  for (nComponentIndex=1; nComponentIndex<=nComponentCount; nComponentIndex++)
  {
    string sComponentTag = CnrRecipeGetComponentTag(sKeyToRecipe, nComponentIndex);
    int nComponentQty = CnrRecipeGetComponentQty(sKeyToRecipe, nComponentIndex);

    if (sComponentTag == "CNR_RECIPE_SPELL")
    {
      // Search the crafter's memorized spell list for this type of spell
      // and tally the count.
      int nSpell = CnrRecipeGetComponentRetainOnFailQty(sKeyToRecipe, nComponentIndex);
      int nSpellCount = nComponentQty * nBatchCount;
      int n;
      for (n=0; n<nSpellCount; n--)
      {
        DecrementRemainingSpellUses(oPC, nSpell);
      }
    }
    else if (sComponentTag != "INVALID_COMPONENT")
    {
      int nRetainOnFailQty = CnrRecipeGetComponentRetainOnFailQty(sKeyToRecipe, nComponentIndex);

      // Search the container's inventory for this type of item
      // and destroy the qty needed to make the recipe.
      nItemCount = nComponentQty * nBatchCount;

      // We've now determined how many items to destroy, so destroy them.
      if (nItemCount > 0)
      {
        object oItem = GetFirstItemInInventory(oDevice);
        while ((oItem != OBJECT_INVALID) && (nItemCount > 0))
        {
          if (GetTag(oItem) == sComponentTag)
          {
            int nStackSize = GetNumStackedItems(oItem);
            if (nStackSize <= nItemCount)
            {
              DestroyObject(oItem);
              nItemCount -= nStackSize;
            }
            else
            {
              // split the stack
              DestroyObject(oItem);
              // DestroyObject is deferred, so create must be deferred also to keep order
              AssignCommand(oPC, CnrRecipeCreateItemOnObject(sComponentTag, oDevice, nStackSize-nItemCount));
              nItemCount = 0;
            }
          }
          oItem = GetNextItemInInventory(oDevice);
        }
      }
    }
  }

  string sRecipeBiTag = CnrRecipeGetRecipeBiproductTagByKey(sKeyToRecipe);
  int nRecipeBiQty = CnrRecipeGetRecipeBiproductQtyByKey(sKeyToRecipe);
  int nOnFailBiQty = CnrRecipeGetRecipeOnFailBiproductQtyByKey(sKeyToRecipe);
  int bSpawnItemInDevice = TRUE;
  //if (!GetIsPC(oDevice))
  //{
  //  if (GetLocalInt(GetModule(), GetTag(oDevice) + "_SpawnItemInDevice"))
  //  {
  //    bSpawnItemInDevice = TRUE;
  //  }
  //}

  // Create the recipe biproduct (if assigned)
  if (sRecipeBiTag != "BIPRODUCT_INVALID")
  {
    nItemCount = nRecipeBiQty;

    // Create the recipe biproduct (if assigned)
    if (nItemCount > 0)
    {
      int nBatch;
      for (nBatch=0; nBatch<(nBatchCount*nItemCount); nBatch++)
      {
        if (bSpawnItemInDevice)
        {
          CreateItemOnObject(sRecipeBiTag, oDevice, 1);
        }
        else
        {
          AssignCommand(oPC, CnrRecipeCreateItemOnObject(sRecipeBiTag, oPC, 1));
        }
      }
    }
  }

  // Create the crafted item(s)
  string sRecipeTag = CnrRecipeGetRecipeTagByKey(sKeyToRecipe);
  int nRecipeQty = CnrRecipeGetRecipeQtyByKey(sKeyToRecipe);
  int nBatch;
  for (nBatch=0; nBatch<nBatchCount; nBatch++)
  {
    int nItem;
    for (nItem=0; nItem<nRecipeQty; nItem++)
    {
      if (bSpawnItemInDevice)
      {
        CreateItemOnObject(sRecipeTag, oDevice, 1);
      }
      else
      {
        // use the action queue so the object message shows
        // after the animation script completes
        AssignCommand(oPC, CnrRecipeCreateItemOnObject(sRecipeTag, oPC, 1));
      }
    }
  }

  return TRUE;
}

// This function returns a multiple info using a float.
// If successful, return a positive value.
// If failure, return a negative value.
// If no attempt made, return 0
/////////////////////////////////////////////////////////
int CnrRecipeAttemptToCraft(object oPC, object oDevice, int nRecipeIndex, int bWithConvo)
{
  if (!GetIsPC(oPC))
  {
    return 0;
  }

  if (!GetIsObjectValid(oDevice))
  {
    return 0;
  }

  string sDeviceTag = GetTag(oDevice);
  if (GetIsPC(oDevice))
  {
    sDeviceTag = GetLocalString(oDevice, "cnrRecipeBookDevice");
  }

  string sKeyToMenu = GetLocalString(oPC, "sCnrCurrentMenu");

  // "No convo" devices should never define submenus or categories!
  if (bWithConvo != TRUE) sKeyToMenu = sDeviceTag;

  string sKeyToRecipe = CnrRecipeGetKeyToRecipeOnPC(oPC, sKeyToMenu, nRecipeIndex);
  if (sKeyToRecipe == "RECIPE_INVALID")
  {
    return 0;
  }

  // Reference the module's recipe. Convert from PC recipe key to module recipe key.
  sKeyToRecipe = GetLocalString(oPC, sKeyToRecipe);

  // The ingot recycler now calls this function, so we cannot rely on the crafting convo
  // to keep us from attempting incomplete recipes. So do this here to filter.
  int nBatchCount = CnrRecipeCheckComponentAvailability(oPC, oDevice, sKeyToRecipe);
  if (nBatchCount == 0)
  {
    return 0;
  }
  else
  {
    // Slow crafting down.
    nBatchCount = 1;
  }

  int nRoll = d20(1);
  int nEffDC = CnrRecipeCalculateEffectiveDC(oPC, sDeviceTag, sKeyToRecipe);

  int bSuccess = TRUE;
  string sResult;
  
  if (nEffDC > 20)
  {
    int nMinPcLevel = CnrRecipeCalculateMinimumPcLevel(oPC, sDeviceTag, sKeyToRecipe);
    sResult += "Failure." + "\n\n" + CNR_TEXT_GIVEN_YOUR;
    string sAbilityString = CnrRecipeGetAbilityString(sDeviceTag, sKeyToRecipe, FALSE);
    sResult += sAbilityString;
    sResult += CNR_TEXT_THIS_RECIPE_IS_IMPOSSIBLE + " ";
    sResult += CNR_TEXT_YOU_WILL_NEED_TO_REACH_LEVEL + IntToString(nMinPcLevel);
    sResult += CNR_TEXT_TO_HAVE_A_CHANCE_OF_SUCCESS;
    bSuccess = FALSE;
  }
  else if (nRoll < nEffDC)
  {
    // Deity insert.  Check whether the crafter's patron deity intercedes to
    // rescue the production.
    string sDeity = GetDeity(oPC);
    if (gsWOGetDeityAspect(oPC) & ASPECT_KNOWLEDGE_INVENTION &&
        gsWOGrantBoon(oPC) )
    {
      FloatingTextStringOnCreature(sDeity + " intercedes to aid your work.", oPC, FALSE);
    }
    else
    {
     // failure
      sResult = CNR_TEXT_FAILURE + "  " + CNR_TEXT_YOU_ROLLED_A + IntToString(nRoll) + ".\n";
      sResult = sResult + "\n" + CNR_TEXT_YOU_NEEDED_TO_ROLL_A + IntToString(nEffDC) + CNR_TEXT_OR_BETTER + "\n";
      bSuccess = FALSE;
    }
  }

  float fAnimationDelay = 0.0;
  location locPC = GetLocation(oPC);

  // if book crafting
  if (GetIsPC(oDevice))
  {
    // skip the animation
    CnrRecipeDisplayCraftingResult(oPC, oDevice, sKeyToRecipe, bSuccess, sResult, nEffDC, locPC, bWithConvo);
  }
  else
  {
    CnrRecipeDoAnimation(oPC, oDevice, bSuccess);

    fAnimationDelay = GetLocalFloat(oPC, "fCnrAnimationDelay"); // Set by the animation script.
    DelayCommand(fAnimationDelay, CnrRecipeDisplayCraftingResult(oPC, oDevice, sKeyToRecipe, bSuccess, sResult, nEffDC, locPC, bWithConvo));
	
	SetLocalInt(oPC, "CNR_CRAFTING", TRUE);
	DelayCommand(fAnimationDelay, DeleteLocalInt(oPC, "CNR_CRAFTING"));
  }

  if (bSuccess)
  {
    // make sure we return a positive value
    return 1;
  }
  else
  {
    // make sure we return a negative value
    return -1;
  }
}

/////////////////////////////////////////////////////////
void CnrRecipeDoAnimation(object oPC, object oDevice, int bSuccess)
{
    // set this for the animation script to use
    SetLocalObject(oDevice, "oCnrCraftingPC", oPC);

    // set this for the animation script to use
    SetLocalInt(oPC, "bCnrCraftingResult", bSuccess);

    // The animation delay should be set by the animation script.
    // It is preset to zero in case no anim script is defined or found.
    SetLocalFloat(oPC, "fCnrAnimationDelay", 0.0);

    // The device's script acts like the default script
    string sScript = GetLocalString(GetModule(), GetTag(oDevice) + "_RecipePreScript");
    ExecuteScript(sScript, oDevice);
}

/////////////////////////////////////////////////////////
int CnrRecipeCraftFirstSatifiedRecipe(object oPC, object oDevice)
{
  // Loop thru each recipe until we're able to craft one
  int bResult = FALSE;
  int nRecipeCount = GetLocalInt(oPC, GetTag(oDevice) + "_RecipeCount");
  int nRecipeIndex;
  for (nRecipeIndex=1; (nRecipeIndex<=nRecipeCount) && (bResult == FALSE); nRecipeIndex++)
  {
    bResult = CnrRecipeAttemptToCraftNoCheck(oPC, oDevice, nRecipeIndex);
  }

  if (bResult == TRUE)
  {
    return (nRecipeIndex-1);
  }

  return 0;
}

/////////////////////////////////////////////////////////
void CnrRecipeShowMenu(string sKeyToMenu, int nMenuPage)
{
  object oPC = GetPCSpeaker();
  SetLocalString(oPC, "sCnrCurrentMenu", sKeyToMenu);
  SetLocalInt(oPC, "nCnrMenuPage", nMenuPage);

  int bHasRecipes = FALSE;

  int nSubCount = GetLocalInt(oPC, sKeyToMenu + "_SubMenuCount");
  if (nSubCount == 0)
  {
    // no sub menus, so list the recipes
    nSubCount = GetLocalInt(oPC, sKeyToMenu + "_RecipeCount");
    bHasRecipes = TRUE;
  }

  int nFirst = (nMenuPage * CNR_SELECTIONS_PER_PAGE) + 1;
  int nLast = (nMenuPage * CNR_SELECTIONS_PER_PAGE) + CNR_SELECTIONS_PER_PAGE;
  if (nLast >= nSubCount)
  {
    nLast = nSubCount;
  }

  int n;
  for (n=nFirst; n<=nLast; n++)
  {
    string sTitle;
    if (bHasRecipes)
    {
      // the recipe titles must be ref'd from the module
      string sKeyToKeyToModuleRecipe = sKeyToMenu + "_" + IntToString(n);
      string sKeyToModuleRecipe = GetLocalString(oPC, sKeyToKeyToModuleRecipe) ;
      sTitle = GetLocalString(GetModule(), sKeyToModuleRecipe + "_RecipeDesc");
    }
    else
    {
      // the menu titles are stored  on the PC
      string sKey = sKeyToMenu + "_" + IntToString(n) + "_RecipeDesc";
      sTitle = GetLocalString(oPC, sKey);
    }

    //SetCustomToken(22001 + (n - nFirst), sTitle);
    SetLocalString(oPC, "sCnrTokenText" + IntToString(22001+(n-nFirst)), sTitle);
    // Note: the custom token will be set in either "cnr_ta_r_grn", "cnr_ta_r_red",
    // or "cnr_ta_r_submenu".
  }

  SetLocalInt(oPC, "nCnrRedOffset", 1);
  SetLocalInt(oPC, "nCnrGrnOffset", 1);
  SetLocalInt(oPC, "nCnrSubOffset", 1);
}

/////////////////////////////////////////////////////////
int CnrRecipeShowAsSubMenu(object oDevice, int menuIndex)
{
  object oPC = GetPCSpeaker();
  string sKeyToMenu = GetLocalString(oPC, "sCnrCurrentMenu");
  int nMenuPage = GetLocalInt(oPC, "nCnrMenuPage");
  int nSubMenuCount = GetLocalInt(oPC, sKeyToMenu + "_SubMenuCount");
  if (nSubMenuCount > 0)
  {
    // we are displaying sub menus
    if (((nMenuPage * CNR_SELECTIONS_PER_PAGE) + menuIndex) <= nSubMenuCount)
    {
      return TRUE;
    }
  }
  return FALSE;
}

/////////////////////////////////////////////////////////
int CnrRecipeShowAsGreen(object oDevice, int menuIndex)
{
  object oPC = GetPCSpeaker();
  string sKeyToMenu = GetLocalString(oPC, "sCnrCurrentMenu");
  int nSubMenuCount = GetLocalInt(oPC, sKeyToMenu + "_SubMenuCount");
  if (nSubMenuCount > 0)
  {
    // we are displaying sub menus
    return FALSE;
  }

  int nMenuPage = GetLocalInt(oPC, "nCnrMenuPage");
  int nRecipeIndex = (nMenuPage * CNR_SELECTIONS_PER_PAGE) + menuIndex;
  string sKeyToRecipe = CnrRecipeGetKeyToRecipeOnPC(oPC, sKeyToMenu, nRecipeIndex);
  if (sKeyToRecipe == "RECIPE_INVALID")
  {
    return FALSE;
  }

  // Convert from PC recipe key to Module recipe key
  sKeyToRecipe = GetLocalString(oPC, sKeyToRecipe);

  string sDeviceTag = GetTag(oDevice);

  if (CNR_BOOL_HIDE_IMPOSSIBLE_RECIPES_IN_CRAFTING_CONVOS != TRUE)
  {
    int nEffDC = CnrRecipeCalculateEffectiveDC(oPC, sDeviceTag, sKeyToRecipe);
    if (nEffDC > 20)
    {
      return FALSE;
    }
  }

  if (CNR_BOOL_HIDE_UNSATISFIED_RECIPES_IN_CRAFTING_CONVOS == TRUE)
  {
    // If we made it here in code, then the recipe must be satisfied.
    return TRUE;
  }

  int nBatchCount = CnrRecipeCheckComponentAvailability(oPC, oDevice, sKeyToRecipe);
  if (nBatchCount > 0)
  {
    return TRUE;
  }

  return FALSE;
}

/////////////////////////////////////////////////////////
int CnrRecipeShowAsRed(object oDevice, int menuIndex)
{
  object oPC = GetPCSpeaker();
  string sKeyToMenu = GetLocalString(oPC, "sCnrCurrentMenu");
  int nSubMenuCount = GetLocalInt(oPC, sKeyToMenu + "_SubMenuCount");
  if (nSubMenuCount > 0)
  {
    // we are displaying sub menus
    return FALSE;
  }

  int nMenuPage = GetLocalInt(oPC, "nCnrMenuPage");
  int nRecipeIndex = (nMenuPage * CNR_SELECTIONS_PER_PAGE) + menuIndex;
  string sKeyToRecipe = CnrRecipeGetKeyToRecipeOnPC(oPC, sKeyToMenu, nRecipeIndex);
  if (sKeyToRecipe == "RECIPE_INVALID")
  {
    return FALSE;
  }

  // Convert from PC recipe key to Module recipe key
  sKeyToRecipe = GetLocalString(oPC, sKeyToRecipe);

  string sDeviceTag = GetTag(oDevice);

  if (CNR_BOOL_HIDE_IMPOSSIBLE_RECIPES_IN_CRAFTING_CONVOS != TRUE)
  {
    int nEffDC = CnrRecipeCalculateEffectiveDC(oPC, sDeviceTag, sKeyToRecipe);
    if (nEffDC > 20)
    {
      return TRUE;
    }
  }

  if (CNR_BOOL_HIDE_UNSATISFIED_RECIPES_IN_CRAFTING_CONVOS != TRUE)
  {
    int nBatchCount = CnrRecipeCheckComponentAvailability(oPC, oDevice, sKeyToRecipe);
    if (nBatchCount == 0)
    {
      return TRUE;
    }
  }

  return FALSE;
}

/////////////////////////////////////////////////////////
// A CNR recipe book is an item the PC can carry around which, when
// activated, will display a list of recipes. There are two flavors
// of these books... (1) "For reference only". These books display the
// recipes supported by a crafting device. They can be thought of as
// grocery lists. (2) "Crafting books". These will not only display
// a list of recipes like #1, but also permit crafting of the recipes
// without the need for an associated crafting device.
//  sBookTag = the tag of the book the recipes will appear in when activated.
//  sDeviceTag = the tag of the placeable that crafts the recipes.
//  Returns a unique string to be used in subsequent calls to init this book.
//  NOTE: To make a "crafting" book, pass the book's tag in sDeviceTag as well.
/////////////////////////////////////////////////////////
string CnrRecipeBookCreateBook(string sBookTag, string sDeviceTag);
/////////////////////////////////////////////////////////
string CnrRecipeBookCreateBook(string sBookTag, string sDeviceTag)
{
  object oModule = GetModule();

  int nBookCount = GetLocalInt(oModule, "cnrRecipeBookCount");

  // First check if this book has already been created. If so,
  // just return the key
  int n;
  for (n=1; n<=nBookCount; n++)
  {
    string sKeyToExistingBook = "cnrRecipeBook_" + IntToString(n);
    string sExistingBookTag = GetLocalString(oModule, sKeyToExistingBook + "_BookTag");
    if (sExistingBookTag == sBookTag)
    {
      return (sKeyToExistingBook);
    }
  }

  // Keep track of the book tags so we can determine which items
  // are books in the module's OnActivateItem handler.
  nBookCount++;
  SetLocalInt(oModule, "cnrRecipeBookCount", nBookCount);

  string sKeyToBook = "cnrRecipeBook_" + IntToString(nBookCount);
  SetLocalString(oModule, sKeyToBook + "_BookTag", sBookTag);
  SetLocalString(oModule, sKeyToBook + "_DeviceTag", sDeviceTag);

  return sKeyToBook;
}

/////////////////////////////////////////////////////////
//  sKeyToBook = a unique string returned from CnrRecipeBookCreateBook.
//  sDescription = the book's convo greeting text.
/////////////////////////////////////////////////////////
void CnrRecipeBookSetDescription(string sKeyToBook, string sDescription);
/////////////////////////////////////////////////////////
void CnrRecipeBookSetDescription(string sKeyToBook, string sDescription)
{
  SetLocalString(GetModule(), sKeyToBook + "_Desc", sDescription);
}

/////////////////////////////////////////////////////////
void CnrRecipeBookShowMenu(string sKeyToMenu, int nMenuPage)
{
  object oPC = GetPCSpeaker();
  SetLocalString(oPC, "sCnrCurrentMenu", sKeyToMenu);
  SetLocalInt(oPC, "nCnrMenuPage", nMenuPage);

  object oBook = GetLocalObject(oPC, "cnrRecipeBookObject");
  string sBookTag1 = GetTag(oBook);

  object oModule = GetModule();

  // To determine the greeting text....
  // walk the book array looking for a matching tag so we can get
  // the book index.. so we can get the book's desc!
  int nBookCount = GetLocalInt(oModule, "cnrRecipeBookCount");
  int nBookIndex;
  for (nBookIndex=1; nBookIndex<=nBookCount; nBookIndex++)
  {
    string sKeyToBook = "cnrRecipeBook_" + IntToString(nBookIndex);
    string sBookTag2 = GetLocalString(oModule, sKeyToBook + "_BookTag");
    if (sBookTag1 == sBookTag2)
    {
      // set the dialogs greeting text
      string sDesc = GetLocalString(oModule, sKeyToBook + "_Desc");
      string sGreeting = GetName(oBook) + "\n";
      if (GetLocalInt(oPC, "cnrEnableBookCrafting") == FALSE)
      {
        sGreeting = sGreeting + CNR_TEXT_FOR_REFERENCE_ONLY + "\n";
      }
      sGreeting = sGreeting + "\n" + sDesc;
      SetLocalString(oPC, "sCnrTokenText22000", sGreeting);
    }
  }

  int bHasRecipes = FALSE;

  int nSubCount = GetLocalInt(oPC, sKeyToMenu + "_SubMenuCount");
  if (nSubCount == 0)
  {
    // no sub menus, so list the recipes
    nSubCount = GetLocalInt(oPC, sKeyToMenu + "_RecipeCount");
    bHasRecipes = TRUE;
  }

  int nFirst = (nMenuPage * CNR_SELECTIONS_PER_PAGE) + 1;
  int nLast = (nMenuPage * CNR_SELECTIONS_PER_PAGE) + CNR_SELECTIONS_PER_PAGE;
  if (nLast >= nSubCount)
  {
    nLast = nSubCount;
  }

  int n;
  for (n=nFirst; n<=nLast; n++)
  {
    string sTitle;
    if (bHasRecipes)
    {
      // the recipe titles must be ref'd from the module
      string sKeyToKeyToModuleRecipe = sKeyToMenu + "_" + IntToString(n);
      string sKeyToModuleRecipe = GetLocalString(oPC, sKeyToKeyToModuleRecipe) ;
      sTitle = GetLocalString(GetModule(), sKeyToModuleRecipe + "_RecipeDesc");
    }
    else
    {
      // the menu titles are stored  on the PC
      string sKey = sKeyToMenu + "_" + IntToString(n) + "_RecipeDesc";
      sTitle = GetLocalString(oPC, sKey);
    }

    //SetCustomToken(22001 + (n - nFirst), sTitle);
    SetLocalString(oPC, "sCnrTokenText" + IntToString(22001+(n-nFirst)), sTitle);
    // Note: the custom token will be set in either "cnr_ta_b_grn", "cnr_ta_b_red",
    // or "cnr_ta_b_submenu".
  }

  SetLocalInt(oPC, "nCnrRedOffset", 1);
  SetLocalInt(oPC, "nCnrGrnOffset", 1);
  SetLocalInt(oPC, "nCnrSubOffset", 1);
}

/////////////////////////////////////////////////////////
int CnrRecipeBookShowAsGreen(object oPC, int menuIndex)
{
  if (!GetIsObjectValid(oPC) || !GetIsPC(oPC))
  {
    return (FALSE);
  }

  string sDeviceTag = GetLocalString(oPC, "cnrRecipeBookDevice");

  int nMenuPage = GetLocalInt(oPC, "nCnrMenuPage");
  int nRecipeIndex = (nMenuPage * CNR_SELECTIONS_PER_PAGE) + menuIndex;
  string sKeyToMenu = GetLocalString(oPC, "sCnrCurrentMenu");
  string sKeyToRecipe = CnrRecipeGetKeyToRecipeOnPC(oPC, sKeyToMenu, nRecipeIndex);
  if (sKeyToRecipe == "RECIPE_INVALID")
  {
    return FALSE;
  }

  // Reference the module's recipe. Convert from PC recipe key to module recipe key.
  sKeyToRecipe = GetLocalString(oPC, sKeyToRecipe);

  if (CNR_BOOL_HIDE_IMPOSSIBLE_RECIPES_IN_CRAFTING_CONVOS != TRUE)
  {
    int nEffDC = CnrRecipeCalculateEffectiveDC(oPC, sDeviceTag, sKeyToRecipe);
    if (nEffDC > 20)
    {
      return FALSE;
    }
  }

  if (CNR_BOOL_HIDE_UNSATISFIED_RECIPES_IN_CRAFTING_CONVOS == TRUE)
  {
    // If we made it here in code, then the recipe must be satisfied.
    return TRUE;
  }

  int nBatchCount = CnrRecipeCheckComponentAvailability(oPC, oPC, sKeyToRecipe);
  if (nBatchCount > 0)
  {
    return TRUE;
  }

  return FALSE;
}

/////////////////////////////////////////////////////////
int CnrRecipeBookShowAsRed(object oPC, int menuIndex)
{
  if (!GetIsObjectValid(oPC) || !GetIsPC(oPC))
  {
    return (TRUE);
  }

  string sDeviceTag = GetLocalString(oPC, "cnrRecipeBookDevice");

  int nMenuPage = GetLocalInt(oPC, "nCnrMenuPage");
  int nRecipeIndex = (nMenuPage * CNR_SELECTIONS_PER_PAGE) + menuIndex;
  string sKeyToMenu = GetLocalString(oPC, "sCnrCurrentMenu");
  string sKeyToRecipe = CnrRecipeGetKeyToRecipeOnPC(oPC, sKeyToMenu, nRecipeIndex);
  if (sKeyToRecipe == "RECIPE_INVALID")
  {
    return FALSE;
  }

  // Reference the module's recipe. Convert from PC recipe key to module recipe key.
  sKeyToRecipe = GetLocalString(oPC, sKeyToRecipe);

  if (CNR_BOOL_HIDE_IMPOSSIBLE_RECIPES_IN_CRAFTING_CONVOS != TRUE)
  {
    int nEffDC = CnrRecipeCalculateEffectiveDC(oPC, sDeviceTag, sKeyToRecipe);
    if (nEffDC > 20)
    {
      return TRUE;
    }
  }

  if (CNR_BOOL_HIDE_UNSATISFIED_RECIPES_IN_CRAFTING_CONVOS != TRUE)
  {
    int nBatchCount = CnrRecipeCheckComponentAvailability(oPC, oPC, sKeyToRecipe);
    if (nBatchCount == 0)
    {
      return TRUE;
    }
  }

  return FALSE;
}

/////////////////////////////////////////////////////////
string CnrRecipeBookBuildRecipeString(object oPC, int nRecipeIndex)
{
  if (!GetIsObjectValid(oPC) || !GetIsPC(oPC))
  {
    return ("Invalid PC used in code. Notify module builder");
  }

  string sDeviceTag = GetLocalString(oPC, "cnrRecipeBookDevice");
  string sKeyToMenu = GetLocalString(oPC, "sCnrCurrentMenu");
  string sKeyToRecipe = CnrRecipeGetKeyToRecipeOnPC(oPC, sKeyToMenu, nRecipeIndex);
  if (sKeyToRecipe == "RECIPE_INVALID")
  {
    return "RECIPE_INVALID";
  }

  // Reference the module's recipe. Convert from PC recipe key to module recipe key.
  sKeyToRecipe = GetLocalString(oPC, sKeyToRecipe);

  int bEnableBookCrafting = GetLocalInt(oPC, "cnrEnableBookCrafting");
  if (bEnableBookCrafting)
  {
    return CnrRecipeBuildRecipeString(oPC, nRecipeIndex);
  }

  string sRecipe = CnrRecipeBuildRecipeStringCommon(oPC, oPC, sKeyToRecipe);

  int nEffDC = CnrRecipeCalculateEffectiveDC(oPC, sDeviceTag, sKeyToRecipe);
  if (nEffDC < 2)
  {
    sRecipe = sRecipe + "\nThis recipe is trivial for you to make.";
  }
  else if (nEffDC > 20)
  {
    // Given the player's current ability score, calculate the minimum level
    // the PC needs to be to have any chance of success crafting this recipe.
    int nMinPcLevel = CnrRecipeCalculateMinimumPcLevel(oPC, sDeviceTag, sKeyToRecipe);
    sRecipe += "\n" + CNR_TEXT_GIVEN_YOUR;
    string sAbilityString = CnrRecipeGetAbilityString(sDeviceTag, sKeyToRecipe, FALSE);
    sRecipe += sAbilityString;
    sRecipe += CNR_TEXT_THIS_RECIPE_IS_IMPOSSIBLE + " ";
    sRecipe += CNR_TEXT_YOU_WILL_NEED_TO_REACH_LEVEL + IntToString(nMinPcLevel);
    sRecipe += CNR_TEXT_TO_HAVE_A_CHANCE_OF_SUCCESS;
  }
  else
  {
    sRecipe += "\n" + CNR_TEXT_GIVEN_YOUR;
    string sAbilityString = CnrRecipeGetAbilityString(sDeviceTag, sKeyToRecipe, TRUE);
    sRecipe += sAbilityString;
    sRecipe = sRecipe + CNR_TEXT_YOU_HAVE_A + IntToString(100-((nEffDC-1)*5)) + CNR_TEXT_PERCENT_CHANCE_OF_SUCCESS;
  }

  sRecipe = sRecipe + "\n";
  return sRecipe;
}

/////////////////////////////////////////////////////////
int CnrRecipeDeviceToolsArePresent(object oCrafter, object oDevice);
/////////////////////////////////////////////////////////
int CnrRecipeDeviceToolsArePresent(object oCrafter, object oDevice)
{
  int bToolInInventory = FALSE;
  int bToolIsEquipped = FALSE;

  string sDeviceTag = GetTag(oDevice);
  object oModule = GetModule();

  // check for a required inventory tool
  string sToolTag = GetLocalString(oModule, sDeviceTag + "_InventoryTool");
  if (sToolTag == "")
  {
    bToolInInventory = TRUE;
  }
  else
  {
    // check if the PC has the tool anywhere in their inventory
    object oTool = CnrGetItemByTag(sToolTag, oCrafter);
    if (oTool != OBJECT_INVALID)
    {
      // roll to see if the tool breaks
      float fBreakagePercentage = GetLocalFloat(oModule, sDeviceTag + "_InventoryTool_BP");
      if (cnr_d100(1) <= fBreakagePercentage)
      {
        FloatingTextStringOnCreature(CNR_TEXT_YOU_HAVE_BROKEN_YOUR + GetName(oTool), oCrafter, FALSE);
        DestroyObject(oTool);
      }
      else
      {
        // no breakage
        bToolInInventory = TRUE;
      }
    }
    else
    {
      oTool = CreateObject(OBJECT_TYPE_ITEM, sToolTag, GetLocation(oCrafter), FALSE);
      FloatingTextStringOnCreature(CNR_TEXT_YOU_MUST_POSSESS_A + GetName(oTool) + CNR_TEXT_TO_USE_THIS_DEVICE, oCrafter, FALSE);
      DestroyObject(oTool);
    }
  }

  if (!bToolInInventory)
  {
    return FALSE;
  }

  // check for a required equipped tool
  sToolTag = GetLocalString(oModule, sDeviceTag + "_EquippedTool");
  if (sToolTag == "")
  {
    bToolIsEquipped = TRUE;
  }
  else
  {
    // check if the PC has the tool equipped
    object oTool;
    int nSlot;
    for (nSlot=INVENTORY_SLOT_HEAD; nSlot<=INVENTORY_SLOT_BOLTS; nSlot++)
    {
      if (bToolIsEquipped == FALSE)
      {
        oTool = GetItemInSlot(nSlot, oCrafter);
        if (oTool != OBJECT_INVALID)
        {
          if (GetTag(oTool) == sToolTag)
          {
            bToolIsEquipped = TRUE;
          }
        }
      }
    }

    if (bToolIsEquipped == TRUE)
    {
      float fBreakagePercentage = GetLocalFloat(oModule, sDeviceTag + "_EquippedTool_BP");
      if (cnr_d100(1) <= fBreakagePercentage)
      {
        FloatingTextStringOnCreature(CNR_TEXT_YOU_HAVE_BROKEN_YOUR + GetName(oTool), oCrafter, FALSE);
        DestroyObject(oTool);
        bToolIsEquipped = FALSE;
      }
    }

    if (bToolIsEquipped == FALSE)
    {
      oTool = CreateObject(OBJECT_TYPE_ITEM, sToolTag, GetLocation(oCrafter), FALSE);
      FloatingTextStringOnCreature(CNR_TEXT_YOU_MUST_HOLD_A + GetName(oTool) + CNR_TEXT_TO_USE_THIS_DEVICE, oCrafter, FALSE);
      DestroyObject(oTool);
    }
  }

  if (bToolInInventory && bToolIsEquipped)
  {
    return TRUE;
  }
  return FALSE;
}

/////////////////////////////////////////////////////////
void CnrRecipeDoSelection(int nSelIndex)
{
  object oPC = GetPCSpeaker();
  string sKeyToCurrentMenu = GetLocalString(oPC, "sCnrCurrentMenu");
  int nMenuPage = GetLocalInt(oPC, "nCnrMenuPage");
  int nSubMenuCount = GetLocalInt(oPC, sKeyToCurrentMenu + "_SubMenuCount");
  if (nSubMenuCount == 0)
  {
    // The menu was displaying recipes
    SetLocalInt(oPC, "nCnrCraftIndex", nSelIndex);
    string sRecipe = CnrRecipeBuildRecipeString(OBJECT_SELF, (nMenuPage*CNR_SELECTIONS_PER_PAGE) + nSelIndex);
    //SetCustomToken(22000, sRecipe);
    SetLocalString(oPC, "sCnrTokenText" + IntToString(22000), sRecipe);
    // Note: the custom token will be set in "cnr_ta_tok_22000".
  }
  else
  {
    // The menu was displaying sub menus
    string sKeyToMenu = sKeyToCurrentMenu + "_" + IntToString((nMenuPage*CNR_SELECTIONS_PER_PAGE) + nSelIndex);
    SetLocalString(oPC, "sCnrCurrentMenu", sKeyToMenu);
    SetLocalInt(oPC, "nCnrMenuPage", 0);
    // cnr_ta_r_top will display the menu
  }
}

/////////////////////////////////////////////////////////
void CnrRecipeBookDoSelection(int nSelIndex)
{
  object oPC = GetPCSpeaker();
  string sKeyToCurrentMenu = GetLocalString(oPC, "sCnrCurrentMenu");
  int nMenuPage = GetLocalInt(oPC, "nCnrMenuPage");
  int nSubMenuCount = GetLocalInt(oPC, sKeyToCurrentMenu + "_SubMenuCount");
  if (nSubMenuCount == 0)
  {
    // The menu was displaying recipes
    SetLocalInt(oPC, "nCnrCraftIndex", nSelIndex);
    string sRecipe = CnrRecipeBookBuildRecipeString(OBJECT_SELF, (nMenuPage*CNR_SELECTIONS_PER_PAGE) + nSelIndex);
    //SetCustomToken(22000, sRecipe);
    SetLocalString(oPC, "sCnrTokenText" + IntToString(22000), sRecipe);
    // Note: the custom token will be set in "cnr_ta_tok_22000".
  }
  else
  {
    // The menu was displaying sub menus
    string sKeyToMenu = sKeyToCurrentMenu + "_" + IntToString((nMenuPage*CNR_SELECTIONS_PER_PAGE) + nSelIndex);
    SetLocalString(oPC, "sCnrCurrentMenu", sKeyToMenu);
    SetLocalInt(oPC, "nCnrMenuPage", 0);
    // cnr_ta_b_top will display the menu
  }
}

/////////////////////////////////////////////////////////
int CnrXpWandOnActivateItem(object oItem, object oActivator)
{
  if (!GetIsObjectValid(oItem) || !GetIsPC(oActivator))
  {
    return FALSE;
  }

  // If the item was the Tradeskill XP Rod,
  // start a conversation with yourself
  // to review the tradeskill levels
  string sRodTag = GetTag(oItem);
  if (sRodTag == "cnrXpAdjRod")
  {
    object oTarget = GetItemActivatedTarget();
    if (!GetIsObjectValid(oTarget) || !GetIsPC(oTarget))
    {
      return FALSE;
    }

    object oJournal = CnrGetItemByTag("cnrTradeJournal", oTarget);
    if (oJournal != OBJECT_INVALID)
    {
      SetLocalInt(oActivator, "nCnrMenuPage", 0);
      SetLocalObject(oActivator, "CnrJournalInUse", oJournal);
      SetLocalObject(oActivator, "oCnrJournalTarget", oTarget);
      AssignCommand(oActivator, ActionStartConversation(oActivator, "cnr_c_journal", TRUE));
      return TRUE;
    }
  }
  return FALSE;
}

/////////////////////////////////////////////////////////
int CnrJournalOnActivateItem(object oItem, object oActivator)
{
  if (!GetIsObjectValid(oItem) || !GetIsPC(oActivator))
  {
    return FALSE;
  }

  if (CnrXpWandOnActivateItem(oItem, oActivator))
  {
    return TRUE;
  }

  // If the item was the Tradeskill Journal,
  // start a conversation with yourself
  // to review the tradeskill levels
  string sJournalTag = GetTag(oItem);
  if (sJournalTag == "cnrTradeJournal")
  {
    SetLocalInt(oActivator, "nCnrMenuPage", 0);
    SetLocalObject(oActivator, "CnrJournalInUse", oItem);
    SetLocalObject(oActivator, "oCnrJournalTarget", oActivator);
    AssignCommand(oActivator, ActionStartConversation(oActivator, "cnr_c_journal", TRUE));
    return TRUE;
  }
  return FALSE;
}

/////////////////////////////////////////////////////////
int CnrJournalIsTradeVisible(int nOffset)
{
  object oModule = GetModule();
  object oPC = GetPCSpeaker();
  object oTarget = GetLocalObject(oPC, "oCnrJournalTarget");
  if (!GetIsPC(oTarget)) return FALSE;
  object oJournal = GetLocalObject(oPC, "CnrJournalInUse");
  if (!GetIsObjectValid(oJournal)) return FALSE;

  int nJournalPage = GetLocalInt(oPC, "nCnrMenuPage");

  int nTradeskillCount = CnrGetTradeskillCount();
  int nFirst = (nJournalPage * CNR_SELECTIONS_PER_PAGE) + 1;
  int nLast = ((nFirst+CNR_SELECTIONS_PER_PAGE)<=nTradeskillCount)?(nFirst+CNR_SELECTIONS_PER_PAGE):nTradeskillCount;

  int nTrade = (nJournalPage * CNR_SELECTIONS_PER_PAGE) + nOffset;
  if ((nTrade >= nFirst) && (nTrade <= nLast))
  {
    string sTradeName = CnrGetTradeskillNameByIndex(nTrade);
    int nXP = CnrGetTradeskillXPByIndex(oTarget, nTrade);
    int nLevel = CnrDetermineTradeskillLevel(nXP);
    int nNextLevelXP = GetLocalInt(oModule, "CnrTradeXPLevel" + IntToString(nLevel));
    if (nLevel != 20)
    {
      nNextLevelXP = GetLocalInt(oModule, "CnrTradeXPLevel" + IntToString(nLevel+1));
    }

    string sReview = sTradeName + ", " + CNR_TEXT_XP_EQUALS + IntToString(nXP);
    sReview += "/" + IntToString(nNextLevelXP) + ", " + CNR_TEXT_LEVEL_EQUALS + IntToString(nLevel);

    int nLevelCap = CnrGetTradeskillLevelCapByIndex(oTarget, nTrade);
    if (nLevelCap == 0) nLevelCap = 20;
    sReview += "/" + IntToString(nLevelCap);

    SetCustomToken(22200+nOffset, sReview);
    return TRUE;
  }

  return FALSE;
}

/////////////////////////////////////////////////////////
int CnrJournalBuildTopTenList(int nOffset)
{
  object oModule = GetModule();
  object oPC = GetPCSpeaker();
  object oTarget = GetLocalObject(oPC, "oCnrJournalTarget");
  if (!GetIsPC(oTarget)) return FALSE;
  object oJournal = GetLocalObject(oPC, "CnrJournalInUse");
  if (!GetIsObjectValid(oJournal)) return FALSE;

  int nJournalPage = GetLocalInt(oPC, "nCnrMenuPage");

  int nTradeskillCount = CnrGetTradeskillCount();
  int nFirst = (nJournalPage * CNR_SELECTIONS_PER_PAGE) + 1;
  int nLast = ((nFirst+CNR_SELECTIONS_PER_PAGE)<=nTradeskillCount)?(nFirst+CNR_SELECTIONS_PER_PAGE):nTradeskillCount;

  int nTrade = (nJournalPage * CNR_SELECTIONS_PER_PAGE) + nOffset;
  if ((nTrade >= nFirst) && (nTrade <= nLast))
  {
    string sTradeName = CnrGetTradeskillNameByIndex(nTrade);
    SetCustomToken(22300, CNR_TEXT_TOP_TEN_CRAFTERS_IN + sTradeName);

    int n;
    for (n=1; n<11; n++)
    {
      string sKeyToLeaderName = "CnrTradeLeaderName_" + IntToString(nTrade) + "_" + IntToString(n);
      string sKeyToLeaderXP = "CnrTradeLeaderXP_" + IntToString(nTrade) + "_" + IntToString(n);
      string sLeaderName = CnrGetPersistentString(oModule, sKeyToLeaderName);
      int nLeaderXP = CnrGetPersistentInt(oModule, sKeyToLeaderXP);
      int nLevel = CnrDetermineTradeskillLevel(nLeaderXP);
      int nNextLevelXP = GetLocalInt(oModule, "CnrTradeXPLevel" + IntToString(nLevel));
      if (nLevel != 20)
      {
        nNextLevelXP = GetLocalInt(oModule, "CnrTradeXPLevel" + IntToString(nLevel+1));
      }

      string sReview;
      if (sLeaderName != "")
      {
        //sReview += "\n(" + IntToString(n) + ") " + sLeaderName;
        sReview = "(" + IntToString(n) + ") " + sLeaderName;
        sReview += ", " + CNR_TEXT_XP_EQUALS + IntToString(nLeaderXP)+ "/" + IntToString(nNextLevelXP);
        sReview += ", " + CNR_TEXT_LEVEL_EQUALS + IntToString(nLevel);
      }
      else
      {
        //sReview += "\n(" + IntToString(n) + ") [--------------]";
        sReview = "(" + IntToString(n) + ") [--------------]";
      }

      SetCustomToken(22300+n, sReview);
    }

    //SetCustomToken(22300, sReview);
    return TRUE;
  }

  return FALSE;
}

/////////////////////////////////////////////////////////
int CnrJournalBuildXpAdjustMenu(int nOffset)
{
  object oModule = GetModule();
  object oPC = GetPCSpeaker();
  object oTarget = GetLocalObject(oPC, "oCnrJournalTarget");
  if (!GetIsPC(oTarget)) return FALSE;
  object oJournal = GetLocalObject(oPC, "CnrJournalInUse");
  if (!GetIsObjectValid(oJournal)) return FALSE;

  int nJournalPage = GetLocalInt(oPC, "nCnrMenuPage");

  int nTradeskillCount = CnrGetTradeskillCount();
  int nFirst = (nJournalPage * CNR_SELECTIONS_PER_PAGE) + 1;
  int nLast = ((nFirst+CNR_SELECTIONS_PER_PAGE)<=nTradeskillCount)?(nFirst+CNR_SELECTIONS_PER_PAGE):nTradeskillCount;

  int nTrade = (nJournalPage * CNR_SELECTIONS_PER_PAGE) + nOffset;
  if ((nTrade >= nFirst) && (nTrade <= nLast))
  {
    SetLocalInt(oPC, "nCnrAdjustingTradeIndex", nTrade);
    string sTradeName = CnrGetTradeskillNameByIndex(nTrade);
    int nXP = CnrGetTradeskillXPByIndex(oTarget, nTrade);
    int nLevel = CnrDetermineTradeskillLevel(nXP);
    SetCustomToken(22300, GetName(oPC, TRUE) + "\n" + sTradeName + ", " + CNR_TEXT_XP_EQUALS + IntToString(nXP) + ", " + CNR_TEXT_LEVEL_EQUALS + IntToString(nLevel));

    int nJournalXpPage = GetLocalInt(oPC, "nCnrXpMenuPage");
    if (nJournalXpPage == 0)
    {
      SetCustomToken(22301, CNR_TEXT_LEVEL + "1");
      SetCustomToken(22302, CNR_TEXT_LEVEL + "2");
      SetCustomToken(22303, CNR_TEXT_LEVEL + "3");
      SetCustomToken(22304, CNR_TEXT_LEVEL + "4");
      SetCustomToken(22305, CNR_TEXT_LEVEL + "5");
      SetCustomToken(22306, CNR_TEXT_LEVEL + "6");
      SetCustomToken(22307, CNR_TEXT_LEVEL + "7");
      SetCustomToken(22308, CNR_TEXT_LEVEL + "8");
      SetCustomToken(22309, CNR_TEXT_LEVEL + "9");
      SetCustomToken(22310, CNR_TEXT_LEVEL + "10");
    }
    else if (nJournalXpPage == 1)
    {
      SetCustomToken(22301, CNR_TEXT_LEVEL + "11");
      SetCustomToken(22302, CNR_TEXT_LEVEL + "12");
      SetCustomToken(22303, CNR_TEXT_LEVEL + "13");
      SetCustomToken(22304, CNR_TEXT_LEVEL + "14");
      SetCustomToken(22305, CNR_TEXT_LEVEL + "15");
      SetCustomToken(22306, CNR_TEXT_LEVEL + "16");
      SetCustomToken(22307, CNR_TEXT_LEVEL + "17");
      SetCustomToken(22308, CNR_TEXT_LEVEL + "18");
      SetCustomToken(22309, CNR_TEXT_LEVEL + "19");
      SetCustomToken(22310, CNR_TEXT_LEVEL + "20");
    }
    else
    {
      SetCustomToken(22301, "+ 10000");
      SetCustomToken(22302, "+ 1000");
      SetCustomToken(22303, "+ 100");
      SetCustomToken(22304, "+ 10");
      SetCustomToken(22305, "+ 1");
      SetCustomToken(22306, "- 1");
      SetCustomToken(22307, "- 10");
      SetCustomToken(22308, "- 100");
      SetCustomToken(22309, "- 1000");
      SetCustomToken(22310, "- 10000");
    }
    return TRUE;
  }

  return FALSE;
}

/////////////////////////////////////////////////////////
string CnrRecipeAddSubMenuToPC(object oPC, string sKeyToParent, string sTitle)
{
  object oModule = GetModule();

  int nSubMenuCount = GetLocalInt(oPC, sKeyToParent + "_SubMenuCount");

  // if the submenu already exists, just return the key
  int nIndex;
  for (nIndex=1; nIndex<=nSubMenuCount; nIndex++)
  {
    string sExistingKey = sKeyToParent + "_" + IntToString(nIndex);
    string sExistingTitle = GetLocalString(oPC, sExistingKey + "_RecipeDesc");
    if (sExistingTitle == sTitle)
    {
      return sExistingKey;
    }
  }

  nSubMenuCount++;
  SetLocalInt(oPC, sKeyToParent + "_SubMenuCount", nSubMenuCount);

  string sKey = sKeyToParent + "_" + IntToString(nSubMenuCount);
  SetLocalString(oPC, sKey + "_RecipeDesc", sTitle);
  SetLocalString(oPC, sKey + "_KeyToParent", sKeyToParent);

  return sKey;
}

/////////////////////////////////////////////////////////
// This crap finds all ancestors of sKeyToModuleRecipe and creates
// new menus for all of them.
/////////////////////////////////////////////////////////
string CnrRecipeBuildAncestorMenus(object oPC, string sKeyToModuleRecipe)
{
  // prep for walk up
  object oModule = GetModule();
  string sKeyToMenuOnModule = GetLocalString(oModule, sKeyToModuleRecipe + "_KeyToParent");

  // walk up
  int nAncestors = 0;
  while (sKeyToMenuOnModule != "")
  {
    nAncestors++;
    SetLocalString(oPC, "CnrAncestorList" + IntToString(nAncestors), sKeyToMenuOnModule);

    sKeyToMenuOnModule = GetLocalString(oModule, sKeyToMenuOnModule + "_KeyToParent");
  }

  if (sKeyToMenuOnModule == "")
  {
    nAncestors--;
  }

  // prep for walk down
  string sDeviceTag = GetLocalString(oPC, "sCnrTagOfDeviceInUse");
  string sKeyToMenuOnPC = sDeviceTag;
  sKeyToMenuOnModule = GetLocalString(oPC, "CnrAncestorList" + IntToString(nAncestors));
  DeleteLocalString(oPC, "CnrAncestorList" + IntToString(nAncestors));
  string sMenuTitle = GetLocalString(oModule, sKeyToMenuOnModule + "_RecipeDesc");

  // walk down
  while ((nAncestors > 0) && (sKeyToMenuOnModule != sDeviceTag))
  {
    sKeyToMenuOnPC = CnrRecipeAddSubMenuToPC(oPC, sKeyToMenuOnPC, sMenuTitle);

    nAncestors--;
    sKeyToMenuOnModule = GetLocalString(oPC, "CnrAncestorList" + IntToString(nAncestors));
    DeleteLocalString(oPC, "CnrAncestorList" + IntToString(nAncestors));
    sMenuTitle = GetLocalString(oModule, sKeyToMenuOnModule + "_RecipeDesc");
  }

  return sKeyToMenuOnPC;
}

/////////////////////////////////////////////////////////
void CnrRecipeAddKeyToModuleRecipeToPC(object oPC, string sKeyToModuleRecipe)
{
  string sKeyToParentMenuOnPC = CnrRecipeBuildAncestorMenus(oPC, sKeyToModuleRecipe);

  int nRecipeCount = GetLocalInt(oPC, sKeyToParentMenuOnPC + "_RecipeCount") + 1;
  SetLocalInt(oPC, sKeyToParentMenuOnPC + "_RecipeCount", nRecipeCount);

  string sKeyToKeyToModuleRecipeOnPC = sKeyToParentMenuOnPC + "_" + IntToString(nRecipeCount);

  // Save the key to the module recipe so we can reference all the recipe data
  // instead of storing a duplicate set.
  SetLocalString(oPC, sKeyToKeyToModuleRecipeOnPC, sKeyToModuleRecipe);
}

/////////////////////////////////////////////////////////
int CnrCheckIfFilterIsSatisfied(object oPC, string sKeyToModuleRecipe)
{
  // The filter may be either an INT set TRUE on the PC, or
  // an item in the PC's inventory.
  string sFilter = GetLocalString(GetModule(), sKeyToModuleRecipe + "_RecipeFilter");

  if (sFilter == "") return TRUE;

  int bFilterSatisfied = GetLocalInt(oPC, sFilter);
  if (bFilterSatisfied) return TRUE;

  object oFilterItem = CnrGetItemByTag(sFilter, oPC);
  if (oFilterItem != OBJECT_INVALID) return TRUE;

  return FALSE;
}

/////////////////////////////////////////////////////////
void CnrCollectSingleRecipeOnPC(object oPC, object oDevice, string sKeyToModuleRecipe, int bEnableFilter)
{
  //PrintString("CnrCollectSingleRecipeOnPC for " + sKeyToModuleRecipe);

  int bShowRecipe = CnrCheckIfFilterIsSatisfied(oPC, sKeyToModuleRecipe);

  if (bShowRecipe && bEnableFilter)
  {
    // if enabled, hide impossible recipes
    if (CNR_BOOL_HIDE_IMPOSSIBLE_RECIPES_IN_CRAFTING_CONVOS == TRUE)
    {
      string sDeviceTag;
      if (GetIsPC(oDevice))
      {
        sDeviceTag = GetLocalString(oDevice, "cnrRecipeBookDevice");
      }
      else
      {
        sDeviceTag = GetTag(oDevice);
      }
      int nEffDC = CnrRecipeCalculateEffectiveDC(oPC, sDeviceTag, sKeyToModuleRecipe);
      if (nEffDC > 20)
      {
        bShowRecipe = FALSE;
      }
    }
  }

  if (bShowRecipe && bEnableFilter)
  {
    // if enabled, hide unsatisfied recipes
    if (CNR_BOOL_HIDE_UNSATISFIED_RECIPES_IN_CRAFTING_CONVOS == TRUE)
    {
      int nBatchCount = CnrRecipeCheckComponentAvailability(oPC, oDevice, sKeyToModuleRecipe);
      if (nBatchCount == 0)
      {
        bShowRecipe = FALSE;
      }
    }
  }

  if (bShowRecipe)
  {
    CnrRecipeAddKeyToModuleRecipeToPC(oPC, sKeyToModuleRecipe);
  }

  // This code deferred by AssignCommand to avoid TMI errors.
  CnrDecrementStackCount(oPC);
}

/////////////////////////////////////////////////////////
void CnrCollectRecipesOnPC(object oPC, object oDevice, string sKeyToModuleMenu, int bEnableFilter)
{
  object oModule = GetModule();

  int nSubCount = GetLocalInt(oModule, sKeyToModuleMenu + "_RecipeCount");
  if (nSubCount > 0)
  {
    //PrintString("CnrCollectRecipesOnPC for " + sKeyToModuleMenu + " RecipeCount = " + IntToString(nSubCount));

    // we have recipes
    int nRecipeIndex;
    for (nRecipeIndex=1; nRecipeIndex<=nSubCount; nRecipeIndex++)
    {
      string sKeyToModuleRecipe = sKeyToModuleMenu + "_" + IntToString(nRecipeIndex);
      //CnrCollectSingleRecipeOnPC(oPC, oDevice, sKeyToModuleRecipe, bEnableFilter);

      // Defer processing to avoid TMI errors.
      CnrIncrementStackCount(oPC);
      AssignCommand(OBJECT_SELF, CnrCollectSingleRecipeOnPC(oPC, oDevice, sKeyToModuleRecipe, bEnableFilter));
    }
  }

  // This code deferred by AssignCommand to avoid TMI errors.
  CnrDecrementStackCount(oPC);
}

/////////////////////////////////////////////////////////
void CnrCollectSubmenusOnPC(object oPC, object oDevice, string sKeyToModuleMenu, int bEnableFilter)
{
  object oModule = GetModule();
  int nSubCount = GetLocalInt(oModule, sKeyToModuleMenu + "_SubMenuCount");
  if (nSubCount > 0)
  {
    //PrintString("CnrCollectSubmenusOnPC for " + sKeyToModuleMenu + " SubMenuCount = " + IntToString(nSubCount));

    // we have submenus
    int nMenuIndex;
    for (nMenuIndex=1; nMenuIndex<=nSubCount; nMenuIndex++)
    {
      string sKeyToSubMenu = sKeyToModuleMenu + "_" + IntToString(nMenuIndex);
      CnrCollectSubmenusOnPC(oPC, oDevice, sKeyToSubMenu, bEnableFilter);
    }
  }
  else
  {
    //PrintString("CnrCollectSubmenusOnPC " + sKeyToModuleMenu + "has no submenus. Start collecting recipes.");

    //CnrCollectRecipesOnPC(oPC, oDevice, sKeyToModuleMenu, bEnableFilter);

    // Defer processing to avoid TMI errors.
    CnrIncrementStackCount(oPC);
    AssignCommand(OBJECT_SELF, CnrCollectRecipesOnPC(oPC, oDevice, sKeyToModuleMenu, bEnableFilter));
  }
}

/////////////////////////////////////////////////////////
// sDeviceTag = the tag of the crafting device placeable
// sDeviceScript = the script defining the device's recipes
void CnrAddCraftingDevice(string sDeviceTag, string sDeviceScript="");
/////////////////////////////////////////////////////////
void CnrAddCraftingDevice(string sDeviceTag, string sDeviceScript="")
{
  object oModule = GetModule();

  // Check if the Crafting Device has already been added
  int nDeviceCount = GetLocalInt(oModule, "CnrCraftingDeviceCount");
  int nIndex;
  for (nIndex=1; nIndex<=nDeviceCount; nIndex++)
  {
    string sExistingDeviceTag = GetLocalString(oModule, "CnrDeviceTag_" + IntToString(nIndex));
    if (sExistingDeviceTag == sDeviceTag)
    {
      // already exists, so don't add again. But, update the script
      SetLocalString(oModule, sDeviceTag + "_DeviceScript", sDeviceScript);
      return;
    }
  }

  nDeviceCount++;
  SetLocalString(oModule, "CnrDeviceTag_" + IntToString(nDeviceCount), sDeviceTag);
  if (sDeviceScript != "")
  {
    SetLocalString(oModule, sDeviceTag + "_DeviceScript", sDeviceScript);
  }
  SetLocalInt(oModule, "CnrCraftingDeviceCount", nDeviceCount);

  CnrSetPersistentInt(oModule, sDeviceTag + "_DeviceLoaded", FALSE);
}

/////////////////////////////////////////////////////////
void CnrRecipeClearRecipesFromPC(object oPC, string sKeyToMenu)
{
  int nCount;
  int nIndex;

  // clear recipe references
  nCount = GetLocalInt(oPC, sKeyToMenu + "_RecipeCount");
  for (nIndex=1; nIndex<=nCount; nIndex++)
  {
    string sKeyToKeyToModuleRecipeOnPC = sKeyToMenu + "_" + IntToString(nIndex);
    DeleteLocalString(oPC, sKeyToKeyToModuleRecipeOnPC);
  }

  // clear menu overhead
  DeleteLocalInt(oPC, sKeyToMenu + "_SubMenuCount");
  DeleteLocalInt(oPC, sKeyToMenu + "_RecipeCount");
  DeleteLocalString(oPC, sKeyToMenu + "_KeyToParent");
  DeleteLocalString(oPC, sKeyToMenu + "_RecipeDesc"); // the menu title
  DeleteLocalString(oPC, sKeyToMenu);

  // This code deferred by AssignCommand to avoid TMI errors.
  // But, it's not critical when it completes. So no need to track with StackCount
}

/////////////////////////////////////////////////////////
void CnrRecipeClearSubmenuFromPC(object oPC, string sKeyToMenu)
{
  int nCount;
  int nIndex;

  // clear sub menus
  nCount = GetLocalInt(oPC, sKeyToMenu + "_SubMenuCount");
  for (nIndex=1; nIndex<=nCount; nIndex++)
  {
    string sKeyToSubMenu = sKeyToMenu + "_" + IntToString(nIndex);
    CnrRecipeClearSubmenuFromPC(oPC, sKeyToSubMenu);
  }

  //CnrRecipeClearRecipesFromPC(oPC, sKeyToMenu);

  // use a stack helper to avoid TMI error
  AssignCommand(OBJECT_SELF, CnrRecipeClearRecipesFromPC(oPC, sKeyToMenu));
}

/////////////////////////////////////////////////////////
void CnrRecipeClearCustomMenuTreeFromPC(object oPC)
{
  string sDeviceTag = GetLocalString(oPC, "sCnrTagOfDeviceInUse");
  if (sDeviceTag != "")
  {
    CnrRecipeClearSubmenuFromPC(oPC, sDeviceTag);
  }
}

/////////////////////////////////////////////////////////
void CnrLoadRecipeScript(string sDeviceTag, object oHost)
{
  object oModule = GetModule();

  // Get associated device script
  string sDeviceScript = GetLocalString(oModule, sDeviceTag + "_DeviceScript");
  if (sDeviceScript == "")
  {
    sDeviceScript = sDeviceTag;
  }

  ExecuteScript(sDeviceScript, oHost);

  // The timing of this flag is not critical
  SetLocalInt(oModule, sDeviceTag + "_DeviceLoaded", TRUE);
  //PrintString(sDeviceTag + "_DeviceLoaded");

  // This code deferred by AssignCommand to avoid TMI errors.
  CnrDecrementStackCount(oHost);
}

/////////////////////////////////////////////////////////
void CnrLoadAllDeviceRecipesFromScript()
{
  object oModule = GetModule();

  CnrSetStackCount(oModule, 0);

  int nDeviceCount = GetLocalInt(oModule, "CnrCraftingDeviceCount");
  int nIndex;
  for (nIndex=1; nIndex<=nDeviceCount; nIndex++)
  {
    string sDeviceTag = GetLocalString(oModule, "CnrDeviceTag_" + IntToString(nIndex));
    if (sDeviceTag != "")
    {
      // Get associated device script
      string sDeviceScript = GetLocalString(oModule, sDeviceTag + "_DeviceScript");
      if (sDeviceScript == "")
      {
        sDeviceScript = sDeviceTag;
      }

      //CnrLoadRecipeScript(sDeviceScript, oModule);

      // Defer processing to avoid TMI errors.
      CnrIncrementStackCount(oModule);
      AssignCommand(OBJECT_SELF, CnrLoadRecipeScript(sDeviceScript, oModule));
    }
  }
}

// Problems can arise with SQL commands if variables or values have single quotes
// in their names. These functions replace these quotes with the tilde character.
// These two functions pilfered from inc_database

/////////////////////////////////////////////////////////
string CnrSQLEncodeSpecialChars(string sString)
{
    if (FindSubString(sString, "'") == -1) // not found
        return sString;

    int i;
    string sReturn = "";
    string sChar;

    // Loop over every character and replace special characters
    for (i = 0; i < GetStringLength(sString); i++)
    {
        sChar = GetSubString(sString, i, 1);
        if (sChar == "'")
            sReturn += "~";
        else
            sReturn += sChar;
    }
    return sReturn;
}

/////////////////////////////////////////////////////////
string CnrSQLDecodeSpecialChars(string sString)
{
    if (FindSubString(sString, "~") == -1) // not found
        return sString;

    int i;
    string sReturn = "";
    string sChar;

    // Loop over every character and replace special characters
    for (i = 0; i < GetStringLength(sString); i++)
    {
        sChar = GetSubString(sString, i, 1);
        if (sChar == "~")
            sReturn += "'";
        else
            sReturn += sChar;
    }
    return sReturn;
}

/////////////////////////////////////////////////////////
void CnrWriteComponentsToSqlDatabase(string sDeviceTag, string sKeyToModuleRecipe)
{
  object oModule = GetModule();

  int nComponentCount = GetLocalInt(oModule, sKeyToModuleRecipe + "_RecipeComponentCount");
  if (nComponentCount > 0)
  {
    // we have components (thank goodness)
    int nComponentIndex;
    for (nComponentIndex=1; nComponentIndex<=nComponentCount; nComponentIndex++)
    {
      string sKeyToComponent = sKeyToModuleRecipe + "_" + IntToString(nComponentIndex);
      string sTag = GetLocalString(oModule, sKeyToComponent + "_Tag");
      int nQty = GetLocalInt(oModule, sKeyToComponent + "_Qty");
      int nRetainQty = GetLocalInt(oModule, sKeyToComponent + "_RetainQty");

      string sSQL;
      sSQL = "INSERT INTO cnr_components (sKeyToComponent, sTag, nQty, nRetainQty, sKeyToRecipe, sDeviceTag) ";
      sSQL += "VALUES ";
      sSQL += "('" + sKeyToComponent + "','" + sTag + "'," + IntToString(nQty) + "," + IntToString(nRetainQty);
      sSQL += ",'" + sKeyToModuleRecipe + "','" + sDeviceTag + "')";
      CnrSQLExecDirect(sSQL);
    }
  }

  /*
  // This code deferred by AssignCommand to avoid TMI errors.
  CnrDecrementStackCount(oModule);
  */
}

/////////////////////////////////////////////////////////
void CnrWriteRecipesToSqlDatabase(string sDeviceTag, string sKeyToModuleMenu)
{
  object oModule = GetModule();

  int nSubCount = GetLocalInt(oModule, sKeyToModuleMenu + "_RecipeCount");
  if (nSubCount > 0)
  {
    // we have recipes
    int nRecipeIndex;
    for (nRecipeIndex=1; nRecipeIndex<=nSubCount; nRecipeIndex++)
    {
      string sKeyToModuleRecipe = sKeyToModuleMenu + "_" + IntToString(nRecipeIndex);
      string sDescription = GetLocalString(oModule, sKeyToModuleRecipe + "_RecipeDesc");
      string sRecipeTag = GetLocalString(oModule, sKeyToModuleRecipe + "_RecipeTag");
      int nRecipeQty = GetLocalInt(oModule, sKeyToModuleRecipe + "_RecipeQty");
      string sFilter = GetLocalString(oModule, sKeyToModuleRecipe + "_RecipeFilter");
      int nStr = GetLocalInt(oModule, sKeyToModuleRecipe + "_RecipeStr");
      int nDex = GetLocalInt(oModule, sKeyToModuleRecipe + "_RecipeDex");
      int nCon = GetLocalInt(oModule, sKeyToModuleRecipe + "_RecipeCon");
      int nInt = GetLocalInt(oModule, sKeyToModuleRecipe + "_RecipeInt");
      int nWis = GetLocalInt(oModule, sKeyToModuleRecipe + "_RecipeWis");
      int nCha = GetLocalInt(oModule, sKeyToModuleRecipe + "_RecipeCha");
      int nLevel = GetLocalInt(oModule, sKeyToModuleRecipe + "_RecipeLevel");
      int nGameXP = GetLocalInt(oModule, sKeyToModuleRecipe + "_GameXP");
      int nTradeXP = GetLocalInt(oModule, sKeyToModuleRecipe + "_TradeXP");
      int bScalarOverrideFlag = GetLocalInt(oModule, sKeyToModuleRecipe + "_ScalarOverrideFlag");
      string sAnimation = GetLocalString(oModule, sKeyToModuleRecipe + "_RecipePreScript");
      string sBiTag = GetLocalString(oModule, sKeyToModuleRecipe + "_RecipeBiTag");
      int nBiQty = GetLocalInt(oModule, sKeyToModuleRecipe + "_RecipeBiQty");
      int nOnFailBiQty = GetLocalInt(oModule, sKeyToModuleRecipe + "_OnFailBiQty");

      sDescription = CnrSQLEncodeSpecialChars(sDescription);

      string sSQL;
      sSQL = "INSERT INTO cnr_recipes (sKeyToRecipe, sDeviceTag, sDescription, sTag, nQty, ";
      sSQL += "sKeyToParent, sFilter, nStr, nDex, nCon, nInt, nWis, nCha, nLevel, nGameXP, ";
      sSQL += "nTradeXP, bScalarOverride, sAnimation, sBiTag, nBiQty, nOnFailBiQty) ";
      sSQL += "VALUES ";
      sSQL += "('" + sKeyToModuleRecipe + "','" + sDeviceTag + "','" + sDescription;
      sSQL += "','" + sRecipeTag + "'," + IntToString(nRecipeQty) + ",'" + sKeyToModuleMenu;
      sSQL += "','" + sFilter + "'," + IntToString(nStr) + "," + IntToString(nDex) + "," + IntToString(nCon) + "," + IntToString(nInt);
      sSQL += "," + IntToString(nWis) + "," + IntToString(nCha) + "," + IntToString(nLevel) + "," + IntToString(nGameXP);
      sSQL += "," + IntToString(nTradeXP) + "," + IntToString(bScalarOverrideFlag) + ",'" + sAnimation + "','" + sBiTag;
      sSQL += "'," + IntToString(nBiQty) + "," + IntToString(nOnFailBiQty) + ")";
      CnrSQLExecDirect(sSQL);

      CnrWriteComponentsToSqlDatabase(sDeviceTag, sKeyToModuleRecipe);

      /*
      // Defer processing to avoid TMI errors.
      CnrIncrementStackCount(oModule);
      AssignCommand(OBJECT_SELF, CnrWriteComponentsToSqlDatabase(sDeviceTag, sKeyToModuleRecipe));
      */
    }
  }

  // This code deferred by AssignCommand to avoid TMI errors.
  CnrDecrementStackCount(oModule);
}

/////////////////////////////////////////////////////////
void CnrWriteSubmenusToSqlDatabase(string sDeviceTag, string sKeyToModuleMenu)
{
  object oModule = GetModule();
  int nSubCount = GetLocalInt(oModule, sKeyToModuleMenu + "_SubMenuCount");
  if (nSubCount > 0)
  {
    // we have submenus
    int nMenuIndex;
    for (nMenuIndex=1; nMenuIndex<=nSubCount; nMenuIndex++)
    {
      string sKeyToSubMenu = sKeyToModuleMenu + "_" + IntToString(nMenuIndex);

      // Add this submenu to the database
      string sMenuTitle = GetLocalString(oModule, sKeyToSubMenu + "_RecipeDesc");
      sMenuTitle = CnrSQLEncodeSpecialChars(sMenuTitle);

      string sSQL;
      sSQL = "INSERT INTO cnr_submenus (sKeyToMenu, sKeyToParent, sTitle, sDeviceTag) ";
      sSQL += "VALUES ";
      sSQL += "('" + sKeyToSubMenu + "','" + sKeyToModuleMenu + "','" + sMenuTitle;
      sSQL += "','" + sDeviceTag + "')";
      CnrSQLExecDirect(sSQL);

      // recursive call
      CnrWriteSubmenusToSqlDatabase(sDeviceTag, sKeyToSubMenu);
    }
  }
  else
  {
    //CnrWriteRecipesToSqlDatabase(sDeviceTag, sKeyToModuleMenu);

    // Defer processing to avoid TMI errors.
    CnrIncrementStackCount(oModule);
    AssignCommand(OBJECT_SELF, CnrWriteRecipesToSqlDatabase(sDeviceTag, sKeyToModuleMenu));
  }

  // This code deferred by AssignCommand to avoid TMI errors.
  CnrDecrementStackCount(oModule);
}

void CnrWriteAllDevicesToSqlDatabase()
{
  object oModule = GetModule();

  CnrSetStackCount(oModule, 0);

  int nDeviceCount = GetLocalInt(oModule, "CnrCraftingDeviceCount");
  int nIndex;
  for (nIndex=1; nIndex<=nDeviceCount; nIndex++)
  {
    string sDeviceTag = GetLocalString(oModule, "CnrDeviceTag_" + IntToString(nIndex));
    if (sDeviceTag != "")
    {
      int bDeviceLoaded = GetLocalInt(oModule, sDeviceTag + "_DeviceLoaded");
      if (bDeviceLoaded == TRUE)
      {
        string sSQL;

        // Clear all recipe data associated with sDeviceTag
        sSQL = "DELETE FROM cnr_components WHERE sDeviceTag = '" + sDeviceTag + "'";
        CnrSQLExecDirect(sSQL);
        sSQL = "DELETE FROM cnr_recipes WHERE sDeviceTag = '" + sDeviceTag + "'`";
        CnrSQLExecDirect(sSQL);
        sSQL = "DELETE FROM cnr_submenus WHERE sDeviceTag = '" + sDeviceTag + "'";
        CnrSQLExecDirect(sSQL);
        sSQL = "DELETE FROM cnr_devices WHERE sDeviceTag = '" + sDeviceTag + "'";
        CnrSQLExecDirect(sSQL);

        // Get the settings for the device
        string sAnimation = GetLocalString(oModule, sDeviceTag + "_RecipePreScript");
        int bSpawnInDevice = GetLocalInt(oModule, sDeviceTag + "_SpawnItemInDevice");
        string sInvTool = GetLocalString(oModule, sDeviceTag + "_InventoryTool");
        string sEqpTool = GetLocalString(oModule, sDeviceTag + "_EquippedTool");
        float fInvToolBP = GetLocalFloat(oModule, sDeviceTag + "_InventoryTool_BP");
        float fEqpToolBP = GetLocalFloat(oModule, sDeviceTag + "_EquippedTool_BP");
        int nTradeType = GetLocalInt(oModule, sDeviceTag + "_TradeskillType");

        // Add the device to the cnr_devices table
        sSQL = "INSERT INTO cnr_devices (sDeviceTag, sAnimation, bSpawnInDevice, ";
        sSQL += "sInvTool, sEqpTool, nTradeType, fInvToolBP, fEqpToolBP) ";
        sSQL += "VALUES ";
        sSQL += "('" + sDeviceTag + "','" + sAnimation + "'," + IntToString(bSpawnInDevice);
        sSQL += ",'" + sInvTool + "','" + sEqpTool + "'," + IntToString(nTradeType);
        sSQL += "," + FloatToString(fInvToolBP) + "," + FloatToString(fEqpToolBP) + ")";
        CnrSQLExecDirect(sSQL);

        // Add submenus, recipes, and components
        //CnrWriteSubmenusToSqlDatabase(sDeviceTag, sDeviceTag);

        // Defer processing to avoid TMI errors.
        CnrIncrementStackCount(oModule);
        AssignCommand(OBJECT_SELF, CnrWriteSubmenusToSqlDatabase(sDeviceTag, sDeviceTag));

        CnrSetPersistentInt(oModule, sDeviceTag + "_DeviceLoaded", TRUE);
      }
    }
  }
}

/////////////////////////////////////////////////////////
void CnrRecipeClearComponentsFromModule(string sKeyToRecipe, object oHost)
{
  object oModule = GetModule();
  int nCount;
  int nIndex;

  // clear components
  nCount = GetLocalInt(oModule, sKeyToRecipe + "_RecipeComponentCount");
  for (nIndex=1; nIndex<=nCount; nIndex++)
  {
    string sKeyToComponent = sKeyToRecipe + "_" + IntToString(nIndex);

    DeleteLocalString(oModule, sKeyToComponent + "_Tag");
    DeleteLocalInt(oModule, sKeyToComponent + "_Qty");
    DeleteLocalInt(oModule, sKeyToComponent + "_RetainQty"); // the menu title
  }

  DeleteLocalInt(oModule, sKeyToRecipe + "_RecipeComponentCount");

  // This code deferred by AssignCommand to avoid TMI errors.
  CnrDecrementStackCount(oHost, "CnrStackCountForClearing");
}

/////////////////////////////////////////////////////////
void CnrRecipeClearRecipesFromModule(string sKeyToMenu, object oHost)
{
  object oModule = GetModule();
  int nCount;
  int nIndex;

  // clear recipes
  nCount = GetLocalInt(oModule, sKeyToMenu + "_RecipeCount");
  for (nIndex=1; nIndex<=nCount; nIndex++)
  {
    string sKeyToRecipe = sKeyToMenu + "_" + IntToString(nIndex);

    //CnrRecipeClearComponentsFromModule(sKeyToRecipe, oHost);

    // Defer processing to avoid TMI errors.
    CnrIncrementStackCount(oHost, "CnrStackCountForClearing");
    AssignCommand(OBJECT_SELF, CnrRecipeClearComponentsFromModule(sKeyToRecipe, oHost));

    DeleteLocalString(oModule, sKeyToRecipe + "_RecipeDesc");
    DeleteLocalString(oModule, sKeyToRecipe + "_RecipeTag");
    DeleteLocalInt(oModule, sKeyToRecipe + "_RecipeQty");
    DeleteLocalString(oModule, sKeyToRecipe + "_RecipeFilter");
    DeleteLocalInt(oModule, sKeyToRecipe + "_RecipeStr");
    DeleteLocalInt(oModule, sKeyToRecipe + "_RecipeDex");
    DeleteLocalInt(oModule, sKeyToRecipe + "_RecipeCon");
    DeleteLocalInt(oModule, sKeyToRecipe + "_RecipeInt");
    DeleteLocalInt(oModule, sKeyToRecipe + "_RecipeWis");
    DeleteLocalInt(oModule, sKeyToRecipe + "_RecipeCha");
    DeleteLocalInt(oModule, sKeyToRecipe + "_RecipeLevel");
    DeleteLocalInt(oModule, sKeyToRecipe + "_GameXP");
    DeleteLocalInt(oModule, sKeyToRecipe + "_TradeXP");
    DeleteLocalInt(oModule, sKeyToRecipe + "_ScalarOverrideFlag");
    DeleteLocalString(oModule, sKeyToRecipe + "_RecipePreScript");
    DeleteLocalString(oModule, sKeyToRecipe + "_RecipeBiTag");
    DeleteLocalInt(oModule, sKeyToRecipe + "_RecipeBiQty");
    DeleteLocalInt(oModule, sKeyToRecipe + "_OnFailBiQty");
  }

  // track the total number of recipes
  int nRecipeCount = GetLocalInt(oModule, "CnrRecipeCount") - nCount;
  if (nRecipeCount < 0) nRecipeCount = 0;
  SetLocalInt(oModule, "CnrRecipeCount", nRecipeCount);

  // clear menu overhead
  DeleteLocalInt(oModule, sKeyToMenu + "_SubMenuCount");
  DeleteLocalInt(oModule, sKeyToMenu + "_RecipeCount");
  DeleteLocalString(oModule, sKeyToMenu + "_KeyToParent");
  DeleteLocalString(oModule, sKeyToMenu + "_RecipeDesc"); // the menu title
  DeleteLocalString(oModule, sKeyToMenu);

  // This code deferred by AssignCommand to avoid TMI errors.
  CnrDecrementStackCount(oHost, "CnrStackCountForClearing");
}

/////////////////////////////////////////////////////////
void CnrRecipeClearSubmenusFromModule(string sKeyToMenu, object oHost)
{
  object oModule = GetModule();
  int nCount;
  int nIndex;

  //PrintString("Clearing submenu = " + sKeyToMenu);

  // clear sub menus
  nCount = GetLocalInt(oModule, sKeyToMenu + "_SubMenuCount");
  for (nIndex=1; nIndex<=nCount; nIndex++)
  {
    string sKeyToSubMenu = sKeyToMenu + "_" + IntToString(nIndex);
    CnrRecipeClearSubmenusFromModule(sKeyToSubMenu, oHost);
  }

  //CnrRecipeClearRecipesFromModule(sKeyToMenu, oHost);

  // Defer processing to avoid TMI errors.
  CnrIncrementStackCount(oHost, "CnrStackCountForClearing");
  AssignCommand(OBJECT_SELF, CnrRecipeClearRecipesFromModule(sKeyToMenu, oHost));
}

/////////////////////////////////////////////////////////
void CnrRecipeClearSingleDeviceFromModule(string sDeviceTag, object oHost)
{
  object oModule = GetModule();

  DeleteLocalString(oModule, sDeviceTag + "_RecipePreScript");
  DeleteLocalInt(oModule, sDeviceTag + "_SpawnItemInDevice");
  DeleteLocalString(oModule, sDeviceTag + "_InventoryTool");
  DeleteLocalString(oModule, sDeviceTag + "_EquippedTool");
  DeleteLocalFloat(oModule, sDeviceTag + "_InventoryTool_BP");
  DeleteLocalFloat(oModule, sDeviceTag + "_EquippedTool_BP");
  DeleteLocalInt(oModule, sDeviceTag + "_TradeskillType");

  CnrRecipeClearSubmenusFromModule(sDeviceTag, oHost);
}

/////////////////////////////////////////////////////////
void CnrFetchSingleComponentFromSqlDatabase(string sDeviceTag, object oHost)
{
  if (CnrSQLFetch() == CNR_SQL_SUCCESS)
  {
    string sKeyToComponent = CnrSQLGetData(1);
    string sComponentTag = CnrSQLGetData(2);
    int nComponentQty = StringToInt(CnrSQLGetData(3));
    int nRetainOnFailQty = StringToInt(CnrSQLGetData(4));
    string sKeyToRecipe = CnrSQLGetData(5);
    //string sDeviceTag = CnrSQLGetData(6);

    // Don't call this, because the fetch may alter the component order
    //CnrRecipeAddComponent(string sKeyToRecipe, string sComponentTag, int nComponentQty, int nRetainOnFailQty=0);

    object oModule = GetModule();

    int nComponentCount = GetLocalInt(oModule, sKeyToRecipe + "_RecipeComponentCount") + 1;
    SetLocalInt(oModule, sKeyToRecipe + "_RecipeComponentCount", nComponentCount);

    SetLocalString(oModule, sKeyToComponent + "_Tag", sComponentTag);
    SetLocalInt(oModule, sKeyToComponent + "_Qty", nComponentQty);
    SetLocalInt(oModule, sKeyToComponent + "_RetainQty", nRetainOnFailQty);

    //PrintString("FetchSingleComponent success: sKeyToComponent = " + sKeyToComponent);

    // Keep fetching
    AssignCommand(OBJECT_SELF, CnrFetchSingleComponentFromSqlDatabase(sDeviceTag, oHost));
  }
  else
  {
    // We're done loading this device.
    CnrSetPersistentInt(GetModule(), sDeviceTag + "_DeviceLoaded", TRUE);

    //PrintString("FetchSingleComponent failed: decrementing stack count");

    // This code deferred by AssignCommand to avoid TMI errors.
    CnrDecrementStackCount(oHost);
  }
}

/////////////////////////////////////////////////////////
void CnrReadComponentsFromSqlDatabase(string sDeviceTag, object oHost)
{
  string sSQL = "SELECT * FROM cnr_components WHERE sDeviceTag = '" + sDeviceTag + "';";
  CnrSQLExecDirect(sSQL);

  // Defer processing to avoid TMI errors.
  AssignCommand(OBJECT_SELF, CnrFetchSingleComponentFromSqlDatabase(sDeviceTag, oHost));
}

/////////////////////////////////////////////////////////
void CnrFetchSingleRecipeFromSqlDatabase(string sDeviceTag, object oHost)
{
  if (CnrSQLFetch() == CNR_SQL_SUCCESS)
  {
    string sKeyToRecipe = CnrSQLGetData(1);
    //string sDeviceTag = CnrSQLGetData(2);
    string sRecipeDesc = CnrSQLGetData(3);
    string sRecipeTag = CnrSQLGetData(4);
    int nQtyMade = StringToInt(CnrSQLGetData(5));
    string sKeyToParent = CnrSQLGetData(6);
    string sFilter = CnrSQLGetData(7);
    int nStr = StringToInt(CnrSQLGetData(8));
    int nDex = StringToInt(CnrSQLGetData(9));
    int nCon = StringToInt(CnrSQLGetData(10));
    int nInt = StringToInt(CnrSQLGetData(11));
    int nWis = StringToInt(CnrSQLGetData(12));
    int nCha = StringToInt(CnrSQLGetData(13));
    int nLevel = StringToInt(CnrSQLGetData(14));
    int nGameXP = StringToInt(CnrSQLGetData(15));
    int nTradeXP = StringToInt(CnrSQLGetData(16));
    int bScalarOverride = StringToInt(CnrSQLGetData(17));
    string sAnimation = CnrSQLGetData(18);
    string sBiTag = CnrSQLGetData(19);
    int nBiQty = StringToInt(CnrSQLGetData(20));
    int nOnFailBiQty = StringToInt(CnrSQLGetData(21));

    // Don't call this, because the fetch may alter the recipe order
    //CnrRecipeCreateRecipe(string sDeviceTag, string sRecipeDesc, string sRecipeTag, int nQtyMade);

    object oModule = GetModule();

    int nRecipeCount = GetLocalInt(oModule, sKeyToParent + "_RecipeCount") + 1;
    SetLocalInt(oModule, sKeyToParent + "_RecipeCount", nRecipeCount);
    //PrintString(sKeyToParent + "_RecipeCount = " + IntToString(nRecipeCount));

    SetLocalString(oModule, sKeyToRecipe + "_RecipeDesc", sRecipeDesc);
    SetLocalString(oModule, sKeyToRecipe + "_RecipeTag", sRecipeTag);
    SetLocalInt(oModule, sKeyToRecipe + "_RecipeQty", nQtyMade);
    SetLocalInt(oModule, sKeyToRecipe + "_RecipeComponentCount", 0);
    SetLocalString(oModule, sKeyToRecipe + "_KeyToParent", sKeyToParent);
    CnrRecipeSetRecipeFilter(sKeyToRecipe, sFilter);
    CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, nStr, nDex, nCon, nInt, nWis, nCha);
    CnrRecipeSetRecipeLevel(sKeyToRecipe, nLevel);
    CnrRecipeSetRecipeXP(sKeyToRecipe, nGameXP, nTradeXP, bScalarOverride);
    CnrRecipeSetRecipePreCraftingScript(sKeyToRecipe, sAnimation);
    CnrRecipeSetRecipeBiproduct(sKeyToRecipe, sBiTag, nBiQty, nOnFailBiQty);

    // count the total number of recipes
    nRecipeCount = GetLocalInt(oModule, "CnrRecipeCount") + 1;
    SetLocalInt(oModule, "CnrRecipeCount", nRecipeCount);

    //PrintString("FetchSingleRecipe success: sKeyToRecipe = " + sKeyToRecipe);

    // Keep fetching
    AssignCommand(OBJECT_SELF, CnrFetchSingleRecipeFromSqlDatabase(sDeviceTag, oHost));
  }
  else
  {
    //PrintString("FetchSingleRecipe failed: Start reading components.");

    //CnrReadComponentsFromSqlDatabase(sDeviceTag, oHost);

    // Defer processing to avoid TMI errors.
    AssignCommand(OBJECT_SELF, CnrReadComponentsFromSqlDatabase(sDeviceTag, oHost));
  }
}

/////////////////////////////////////////////////////////
void CnrReadRecipesFromSqlDatabase(string sDeviceTag, object oHost)
{
  string sSQL = "SELECT * FROM cnr_recipes WHERE sDeviceTag = '" + sDeviceTag + "';";
  CnrSQLExecDirect(sSQL);

  // Defer processing to avoid TMI errors.
  AssignCommand(OBJECT_SELF, CnrFetchSingleRecipeFromSqlDatabase(sDeviceTag, oHost));
}

/////////////////////////////////////////////////////////
void CnrFetchSingleSubmenuFromSqlDatabase(string sDeviceTag, object oHost)
{
  if (CnrSQLFetch() == CNR_SQL_SUCCESS)
  {
    string sKeyToMenu = CnrSQLGetData(1);
    string sKeyToParent = CnrSQLGetData(2);
    string sTitle = CnrSQLGetData(3);
    //string sDeviceTag = CnrSQLGetData(4);

    // Don't call this, because the fetch may alter the submenu order
    //CnrRecipeAddSubMenu(string sKeyToParent, string sTitle);

    object oModule = GetModule();

    string sKeyToCount = sKeyToParent + "_SubMenuCount";
    int nSubMenuCount = GetLocalInt(oModule, sKeyToCount) + 1;
    SetLocalInt(oModule, sKeyToCount, nSubMenuCount);

    SetLocalString(oModule, sKeyToMenu + "_RecipeDesc", sTitle);
    SetLocalString(oModule, sKeyToMenu + "_KeyToParent", sKeyToParent);

    //PrintString("FetchSingleSubmenu success: sKeyToMenu = " + sKeyToMenu);

    // Keep fetching
    AssignCommand(OBJECT_SELF, CnrFetchSingleSubmenuFromSqlDatabase(sDeviceTag, oHost));
  }
  else
  {
    //PrintString("FetchSingleSubmenu failed: Start reading recipes.");

    //CnrReadRecipesFromSqlDatabase(sDeviceTag, oHost);

    // Defer processing to avoid TMI errors.
    AssignCommand(OBJECT_SELF, CnrReadRecipesFromSqlDatabase(sDeviceTag, oHost));
  }
}

/////////////////////////////////////////////////////////
void CnrReadSubmenusFromSqlDatabase(string sDeviceTag, object oHost)
{
  //PrintString("Reading submenus for device " + sDeviceTag);

  string sSQL = "SELECT * FROM cnr_submenus WHERE sDeviceTag = '" + sDeviceTag + "';";
  CnrSQLExecDirect(sSQL);

  // Defer processing to avoid TMI errors.
  AssignCommand(OBJECT_SELF, CnrFetchSingleSubmenuFromSqlDatabase(sDeviceTag, oHost));
}

/////////////////////////////////////////////////////////
void TestIfOkToContinueReadingSingleDeviceFromSqlDatabase(string sDeviceTag, object oHost)
{
  int nStackCount = CnrGetStackCount(oHost, "CnrStackCountForClearing");
  if (nStackCount > 0)
  {
    AssignCommand(OBJECT_SELF, TestIfOkToContinueReadingSingleDeviceFromSqlDatabase(sDeviceTag, oHost));
  }
  else
  {
    // we're done with clearing the locals, so continue with reading
    //PrintString(sDeviceTag + " device cleared. Starting to read from database.");
    string sSQL = "SELECT * FROM cnr_devices WHERE sDeviceTag = '" + sDeviceTag + "';";
    CnrSQLExecDirect(sSQL);
    if (CnrSQLFetch() == CNR_SQL_SUCCESS)
    {
      //string sDeviceTag = CnrSQLGetData(1);
      string sAnimation = CnrSQLGetData(2);
      int bSpawnInDevice = StringToInt(CnrSQLGetData(3));
      string sInvTool = CnrSQLGetData(4);
      string sEqpTool = CnrSQLGetData(5);
      int nTradeType = StringToInt(CnrSQLGetData(6));
      float fInvToolBP = StringToFloat(CnrSQLGetData(7));
      float fEqpToolBP = StringToFloat(CnrSQLGetData(8));

      CnrRecipeSetDevicePreCraftingScript(sDeviceTag, sAnimation);
      CnrRecipeSetDeviceSpawnItemInDevice(sDeviceTag, bSpawnInDevice);
      CnrRecipeSetDeviceInventoryTool(sDeviceTag, sInvTool, fInvToolBP);
      CnrRecipeSetDeviceEquippedTool(sDeviceTag, sEqpTool, fEqpToolBP);
      CnrRecipeSetDeviceTradeskillType(sDeviceTag, nTradeType);

      //CnrReadSubmenusFromSqlDatabase(sDeviceTag, oHost);

      // Defer processing to avoid TMI errors.
      //PrintString("TestIfOk incrementing stack count");
      CnrIncrementStackCount(oHost);
      AssignCommand(OBJECT_SELF, CnrReadSubmenusFromSqlDatabase(sDeviceTag, oHost));
    }

    // This code deferred by AssignCommand to avoid TMI errors.
    //PrintString("TestIfOk decrementing stack count");
    CnrDecrementStackCount(oHost);
  }
}

/////////////////////////////////////////////////////////
void CnrReadSingleDeviceFromSqlDatabase(string sDeviceTag, object oHost)
{
  CnrSetStackCount(oHost, 0, "CnrStackCountForClearing");

  // Start with flag cleared.
  CnrSetPersistentInt(GetModule(), sDeviceTag + "_DeviceLoaded", FALSE);

  // First, we must clear the device data from the module locals.
  CnrRecipeClearSingleDeviceFromModule(sDeviceTag, oHost);

  // Timing on this flag is not critical
  //CnrSetPersistentInt(GetModule(), sDeviceTag + "_DeviceLoaded", TRUE);

  // We don't want to continue until the device is flushed from the locals.
  AssignCommand(OBJECT_SELF, TestIfOkToContinueReadingSingleDeviceFromSqlDatabase(sDeviceTag, oHost));
}

/////////////////////////////////////////////////////////
void TestIfOkToReadNextDeviceFromSqlDatabase(string sDeviceTag, object oHost)
{
  object oModule = GetModule();

  int nStackCount = CnrGetStackCount(oHost);
  if (nStackCount > 0)
  {
    AssignCommand(OBJECT_SELF, TestIfOkToReadNextDeviceFromSqlDatabase(sDeviceTag, oHost));
  }
  else
  {
    int nDeviceCount = GetLocalInt(oModule, "CnrCraftingDevicesToReadFromSql") - 1;
    SetLocalInt(oModule, "CnrCraftingDevicesToReadFromSql", nDeviceCount);

    if (nDeviceCount > 0)
    {
      string sDeviceTag = GetLocalString(oModule, "CnrDeviceTag_" + IntToString(nDeviceCount));
      if (sDeviceTag != "")
      {
        //CnrReadSingleDeviceFromSqlDatabase(sDeviceTag, oModule);

        // use a stack helper
        CnrIncrementStackCount(oHost);
        AssignCommand(OBJECT_SELF, CnrReadSingleDeviceFromSqlDatabase(sDeviceTag, oHost));

        AssignCommand(OBJECT_SELF, TestIfOkToReadNextDeviceFromSqlDatabase(sDeviceTag, oHost));
      }
    }
  }
}

/////////////////////////////////////////////////////////
void CnrReadAllDevicesFromSqlDatabase()
{
  object oModule = GetModule();

  CnrSetStackCount(oModule, 0);

  int nDeviceCount = GetLocalInt(oModule, "CnrCraftingDeviceCount");
  SetLocalInt(oModule, "CnrCraftingDevicesToReadFromSql", nDeviceCount);

  if (nDeviceCount > 0)
  {
    string sDeviceTag = GetLocalString(oModule, "CnrDeviceTag_" + IntToString(nDeviceCount));
    if (sDeviceTag != "")
    {
      //CnrReadSingleDeviceFromSqlDatabase(sDeviceTag, oModule);

      // use a stack helper
      CnrIncrementStackCount(oModule);
      AssignCommand(OBJECT_SELF, CnrReadSingleDeviceFromSqlDatabase(sDeviceTag, oModule));

      AssignCommand(OBJECT_SELF, TestIfOkToReadNextDeviceFromSqlDatabase(sDeviceTag, oModule));
    }
  }
}

/////////////////////////////////////////////////////////
void CnrInitializeDeviceRecipes(object oPC, object oDevice)
{
  object oModule = GetModule();
  int bDeviceLoaded;

  string sDeviceTag = GetTag(oDevice);
  if (GetIsPC(oDevice))
  {
    sDeviceTag = GetLocalString(oDevice, "cnrRecipeBookDevice");
  }

  int bRecipeDataIsPersistent = CnrGetPersistentInt(OBJECT_SELF, "CnrBoolRecipeDataIsPersistent");
  int bRecipeDataIsPersistentInSqlDatabase = bRecipeDataIsPersistent || CNR_BOOL_RECIPE_DATA_IS_PERSISTENT_IN_SQL_DATABASE;

  if (bRecipeDataIsPersistentInSqlDatabase == TRUE)
  {
    bDeviceLoaded = CnrGetPersistentInt(oModule, sDeviceTag + "_DeviceLoaded");
    if (bDeviceLoaded != TRUE)
    {

      //CnrReadSingleDeviceFromSqlDatabase(sDeviceTag, oPC);

      // Defer processing to avoid TMI errors.
      //PrintString("CnrInitializeDeviceRecipes initing stack count");
      CnrSetStackCount(oPC, 1);
      AssignCommand(OBJECT_SELF, CnrReadSingleDeviceFromSqlDatabase(sDeviceTag, oPC));
    }
  }
  else
  {
    bDeviceLoaded = GetLocalInt(oModule, sDeviceTag + "_DeviceLoaded");
    if (bDeviceLoaded != TRUE)
    {
      //CnrLoadRecipeScript(sDeviceTag, oPC);

      // Defer processing to avoid TMI errors.
      CnrSetStackCount(oPC, 1);
      AssignCommand(OBJECT_SELF, CnrLoadRecipeScript(sDeviceTag, oPC));
    }
  }
}

/////////////////////////////////////////////////////////
void CnrCollectDeviceRecipes(object oPC, object oDevice, int bEnableFilter)
{
  string sDeviceTag = GetTag(oDevice);
  if (GetIsPC(oDevice))
  {
    sDeviceTag = GetLocalString(oDevice, "cnrRecipeBookDevice");
  }

  //PrintString("CnrCollectDeviceRecipes for " + sDeviceTag);

  // don't reload if we're still using the same device
  string sTagOfDeviceInUse = GetLocalString(oPC, "sCnrTagOfDeviceInUse");

  // Clear the previously used device menu tree from the PC
  CnrRecipeClearCustomMenuTreeFromPC(oPC);

  SetLocalString(oPC, "sCnrTagOfDeviceInUse", sDeviceTag);

  CnrSetStackCount(oPC, 0);
  CnrCollectSubmenusOnPC(oPC, oDevice, sDeviceTag, bEnableFilter);
}

/////////////////////////////////////////////////////////
void TestIfBookRecipesHaveBeenCollected(object oActivator)
{
  int nStackCount = CnrGetStackCount(oActivator);
  if (nStackCount > 0)
  {
    AssignCommand(OBJECT_SELF, TestIfBookRecipesHaveBeenCollected(oActivator));
  }
  else
  {
    AssignCommand(oActivator, ActionStartConversation(oActivator, "cnr_c_recipebook", TRUE));
  }
}

/////////////////////////////////////////////////////////
void TestIfBookRecipesHaveBeenInitialized(object oActivator)
{
  int nStackCount = CnrGetStackCount(oActivator);
  if (nStackCount > 0)
  {
    AssignCommand(OBJECT_SELF, TestIfBookRecipesHaveBeenInitialized(oActivator));
  }
  else
  {
    // This call is asynchronous. It uses AssignCommand to avoid TMI.
    CnrCollectDeviceRecipes(oActivator, oActivator, TRUE);

    // Wait until collection is done before starting the conversation
    AssignCommand(OBJECT_SELF, TestIfBookRecipesHaveBeenCollected(oActivator));
  }
}

/////////////////////////////////////////////////////////
//  oItem = the object which was just activated.
//  oActivator = the creature that activated oItem.
/////////////////////////////////////////////////////////
int CnrRecipeBookOnActivateItem(object oItem, object oActivator);
/////////////////////////////////////////////////////////
int CnrRecipeBookOnActivateItem(object oItem, object oActivator)
{
  if (!GetIsObjectValid(oItem) || !GetIsPC(oActivator))
  {
    return FALSE;
  }

  object oModule = GetModule();
  string sItemTag = GetTag(oItem);

  // walk the book array looking for a matching tag
  int nBookCount = GetLocalInt(oModule, "cnrRecipeBookCount");
  int nBookIndex;
  for (nBookIndex=1; nBookIndex<=nBookCount; nBookIndex++)
  {
    string sKeyToBook = "cnrRecipeBook_" + IntToString(nBookIndex);
    string sBookTag = GetLocalString(oModule, sKeyToBook + "_BookTag");
    if (sBookTag == sItemTag)
    {
      // a recipe book has been activated
      string sDeviceTag = GetLocalString(oModule, sKeyToBook + "_DeviceTag");
      SetLocalString(oActivator, "cnrRecipeBookDevice", sDeviceTag);
      SetLocalObject(oActivator, "cnrRecipeBookObject", oItem);
      SetLocalString(oActivator , "sCnrCurrentMenu", sDeviceTag);
      SetLocalInt(oActivator, "nCnrMenuPage", 0);

      if (sDeviceTag == sBookTag)
      {
        // Treat the book as a device. This book can craft items without a device.
        SetLocalInt(oActivator, "cnrEnableBookCrafting", TRUE);
      }
      else
      {
        SetLocalInt(oActivator, "cnrEnableBookCrafting", FALSE);
      }

      // This call is asynchronous. It uses AssignCommand to avoid TMI.
      CnrInitializeDeviceRecipes(oActivator, oActivator);

      // Wait until initialization is done before continuing
      AssignCommand(OBJECT_SELF, TestIfBookRecipesHaveBeenInitialized(oActivator));

      return TRUE;
    }
  }

  return FALSE;
}

