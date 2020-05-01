/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrTailorsTable
//
//  Desc:  Recipe initialization.
//
//  Author: David Bobeck 15May03
//  Modified: Gary Corcoran 05Aug03
//  Updated and substantially revised by Cara 15Apr06
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"

void main()
{
  string sKeyToRecipe;

  PrintString("cnrtailorstable init");

  /////////////////////////////////////////////////////////
  //  CNR Crafting Device "cnrTailorsTable"
  /////////////////////////////////////////////////////////

  string sMenuTailorCloths = CnrRecipeAddSubMenu("cnrtailorstable", "Cloth and Silks");
  string sMenuTailorClothing = CnrRecipeAddSubMenu("cnrtailorstable", "Clothing");
  string sMenuTailorPaddArm = CnrRecipeAddSubMenu("cnrtailorstable", "Padded Armour");
  string sMenuTailorKits = CnrRecipeAddSubMenu("cnrtailorstable", "Healing Kits");
  string sMenuTailorSlings = CnrRecipeAddSubMenu("cnrtailorstable", "Slings");
  string sMenuTailorProducts = CnrRecipeAddSubMenu("cnrtailorstable", "Products");
  string sMenuTailorHouse = CnrRecipeAddSubMenu("cnrtailorstable", "House Items");

  CnrRecipeSetDevicePreCraftingScript("cnrtailorstable", "cnr_tailor_anim");
  CnrRecipeSetDeviceInventoryTool("cnrtailorstable", "cnrSewingKit", CNR_FLOAT_SEWING_KIT_BREAKAGE_PERCENTAGE);
  //CnrRecipeSetDeviceEquippedTool("cnrTailorsTable", "cnr");
  CnrRecipeSetDeviceTradeskillType("cnrtailorstable", CNR_TRADESKILL_TAILORING);
  CnrRecipeSetRecipeAbilityPercentages(IntToString(CNR_TRADESKILL_TAILORING), 0, 50, 0, 50, 0, 0);

/////////////////////////////Cloths///////////////////////////////////////////


  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorCloths, "Cloth", "cnrcloth", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcotton", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorCloths, "Spun Wool", "cnrcloth1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrskinwool", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorCloths, "Spun Silk", "cnrcloth2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrspidersilk", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);


///////////////////////////////Other//////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorProducts, "Cloth Padding", "cnrpadding", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcotton", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorProducts, "Bow String", "cnrbowstring", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrspidersilk", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorProducts, "Rope", "cnrrope", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorProducts, "Fixture: Cushions", "gs_item375", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcotton", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorProducts, "Fixture: Bedroll", "gs_item309", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth1", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorProducts, "Fixture: Tent", "gs_item309", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorProducts, "Fixture: Rug (round blue)", "wt_item_rug1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth1", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorProducts, "Fixture: Rug (fancy medium)", "wt_item_rug2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth1", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorProducts, "Fixture: Rug (fancy large)", "wt_item_rug3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth1", 4);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorProducts, "Fixture: Market Stall", "wt_item_stall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth", 4);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);

////////////////////////////Clothing////////////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorClothing, "Clothes", "cnrclothes", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth", 2, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorClothing, "Woollen Clothes", "cloth023", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth1", 2, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorClothing, "Silk Clothes", "cloth029", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth2", 2, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorClothing, "Cloth Gloves", "cnrglovecloth", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorClothing, "Gloves (Wool)", "cnrglovewool", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth1", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorClothing, "Gloves (Silk)", "cnrglovesilk", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth2", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorClothing, "Cotton Cloak", "cnrcloak", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorClothing, "Wool Cloak", "maarcl038", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth1", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorClothing, "Silk Cloak", "maarcl063", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth2", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);


///////////////////////////Padded Armour//////////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorPaddArm, "Padded Armour", "cnrarmpad", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth", 2, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorPaddArm, "Woollen Padded Armour", "cloth024", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth1", 2, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorPaddArm, "Silk Padded Armour", "cloth030", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth2", 2, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);


/////////////////////////////Slings/////////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorSlings, "Cloth Sling", "cnrslingcloth", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  // Other slings are leather.




/////////////////////// HEALING KITS by Forsetti modified by Cara///////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorKits, "5 Basic Healer's Kits", "cnrhealkit1", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcotton", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnraloeleaf", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrgarlicclove", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorKits, "5 Healer's Kits", "cnrhealkit3", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcotton", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnraloeleaf", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcomfreyroot", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorKits, "5 Good Healer's Kits", "cnrhealkit6", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcotton", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnraloeleaf", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrgingerroot", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorKits, "5 Superb Healer's Kits", "cnrhealkit10", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcotton", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnraloeleaf", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrginsengroot", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);


  //////////////////////House Items//////////////////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorHouse, "Erenia: Robes of the Inquisition (male)", "ererobinq", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt3", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsil", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "rescarererobinq", 1, 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "rescarererobinq", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorHouse, "Erenia: Robes of the Inquisition (female)", "ererobinq2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt3", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsil", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "rescarererobinq", 1, 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "rescarererobinq", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorHouse, "Renerrin: Rake's Salvation", "renraksal", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth3", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "rescarrenraksal", 1, 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "rescarrenraksal", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);


}

