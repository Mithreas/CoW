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
  string sMenuTailorGloves = CnrRecipeAddSubMenu("cnrtailorstable", "Gloves");
  string sMenuTailorProducts = CnrRecipeAddSubMenu("cnrtailorstable", "Products");
  string sMenuTailorHouse = CnrRecipeAddSubMenu("cnrtailorstable", "House Items");

  CnrRecipeSetDevicePreCraftingScript("cnrtailorstable", "cnr_tailor_anim");
  CnrRecipeSetDeviceInventoryTool("cnrtailorstable", "cnrSewingKit", CNR_FLOAT_SEWING_KIT_BREAKAGE_PERCENTAGE);
  //CnrRecipeSetDeviceEquippedTool("cnrTailorsTable", "cnr");
  CnrRecipeSetDeviceTradeskillType("cnrtailorstable", CNR_TRADESKILL_TAILORING);

/////////////////////////////Cloths///////////////////////////////////////////


  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorCloths, "Cloth", "cnrcloth", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcotton", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorCloths, "Ondaran-Silk", "cnrcloth1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrspidersilk", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotond", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorCloths, "Elfur-Silk", "cnrcloth2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrspidersilk", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotelf", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorCloths, "Lirium-Silk", "cnrcloth3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrspidersilk", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotlir", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorCloths, "Demon's Bane-Silk", "cnrcloth4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrspidersilk", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotelf", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorCloths, "Iolum-Silk", "cnrcloth5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrspidersilk", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiol", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorCloths, "Adanium-Silk", "cnrcloth6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrspidersilk", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotada", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiol", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorCloths, "Stallix-Silk", "cnrcloth7", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrspidersilk", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsta", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiol", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);



///////////////////////////////Other//////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorProducts, "Cloth Padding", "cnrpadding", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcotton", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorProducts, "Bow String", "cnrbowstring", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrspidersilk", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorProducts, "Rope", "cnrrope", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrspidersilk", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorProducts, "Cloak", "cnrcloak", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

////////////////////////////Clothing////////////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorClothing, "Clothes", "cnrclothes", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth", 2, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorClothing, "Ondaran-Silk Clothes", "cnrclothes1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth1", 2, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorClothing, "Elfur-Silk Clothes", "cnrclothes2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth2", 2, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorClothing, "Lirium-Silk Clothes", "cnrclothes3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth3", 2, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorClothing, "Demon's Bane-Silk Clothes", "cnrclothes4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth4", 2, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorClothing, "Iolum-Silk Clothes", "cnrclothes5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth5", 2, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorClothing, "Adanium-Silk Clothes", "cnrclothes6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth6", 2, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

///////////////////////////Padded Armour//////////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorPaddArm, "Padded Armour", "cnrarmpad", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth", 2, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorPaddArm, "Ondaran-Silk Padded Armour", "cnrarmpad1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth1", 2, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorPaddArm, "Elfur-Silk Padded Armour", "cnrarmpad2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth2", 2, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorPaddArm, "Lirium-Silk Padded Armour", "cnrarmpad3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth3", 2, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorPaddArm, "Demon's Bane-Silk Padded Armour", "cnrarmpad4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth4", 2, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorPaddArm, "Iolum-Silk Padded Armour", "cnrarmpad5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth5", 2, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorPaddArm, "Adanium-Silk Padded Armour", "cnrarmpad6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth6", 2, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 120);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);


/////////////////////////////Slings/////////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorSlings, "Cloth Sling", "cnrslingcloth", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorSlings, "Ondaran-Silk Sling", "cnrsling2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth1", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorSlings, "Elfur-Silk Sling", "cnrsling2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth2", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorSlings, "Lirium-Silk Sling", "cnrsling3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth3", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorSlings, "Demon'S Bane-Silk Sling", "cnrsling4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth4", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorSlings, "Iolum-Silk Sling", "cnrsling5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth2", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorSlings, "Stallix-Silk Sling", "cnrsling6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth7", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);


/////////////////////////////////////Gloves//////////////////////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorGloves, "Cloth Gloves", "cnrglovecloth", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorGloves, "Ondaran Reinforced Gloves", "cnrglove1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrglovecloth", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotond", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorGloves, "Elfur Reinforced Gloves", "cnrglove2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrglovecloth", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotelf", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 40);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorGloves, "Lirium Spiked Gloves", "cnrglove3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrglovecloth", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotlir", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 60);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorGloves, "Demon's Bane Gloves", "cnrglove4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrholywater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrglove2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 80);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorGloves, "Iolum Bladed Gloves", "cnrglove5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrglovecloth", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiol", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorGloves, "Stallix Bladed Gloves", "cnrglove6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsta", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrglove5", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);


/////////////////////// HEALING KITS by Forsetti modified by Cara///////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorKits, "5 Basic Healer's Kits", "cnrhealkit1", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcotton", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnraloeleaf", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrgarlicclove", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 0, 35, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorKits, "5 Healer's Kits", "cnrhealkit3", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcotton", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnraloeleaf", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcomfreyroot", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 0, 35, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorKits, "5 Good Healer's Kits", "cnrhealkit6", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcotton", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnraloeleaf", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrgingerroot", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 0, 35, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorKits, "5 Superb Healer's Kits", "cnrhealkit10", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcotton", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnraloeleaf", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrginsengroot", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 0, 35, 0);


  //////////////////////House Items//////////////////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorHouse, "Erenia: Robes of the Inquisition (male)", "ererobinq", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt5", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "rescarererobinq", 1, 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "rescarererobinq", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 0, 35, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorHouse, "Erenia: Robes of the Inquisition (female)", "ererobinq2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt5", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "rescarererobinq", 1, 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "rescarererobinq", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 0, 35, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorHouse, "Renerrin: Rake's Salvation", "renraksal", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth3", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "rescarrenraksal", 1, 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "rescarrenraksal", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 0, 35, 0);


}

