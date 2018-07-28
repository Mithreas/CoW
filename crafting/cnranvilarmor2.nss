/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnranvilarmor2
//
//  Desc:  Recipe initialization.
//
//  Author: David Bobeck 15May03
//  Updated and substantially revised by Cara 15Apr06
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"

void main()
{
  string sKeyToRecipe;

  PrintString("cnranvilarmor2 init");

  /////////////////////////////////////////////////////////
  // CNR recipes made by cnrAnvilArmor
  /////////////////////////////////////////////////////////
  string sMenuShields = CnrRecipeAddSubMenu("cnranvilarmor2", "Shields");
  string sMenuHelms = CnrRecipeAddSubMenu("cnranvilarmor2", "Helms");
  string sMenuArmor = CnrRecipeAddSubMenu("cnranvilarmor2", "Armour");
  string sMenuSubs = CnrRecipeAddSubMenu("cnranvilarmor2", "Components");
  string sMenuHouse = CnrRecipeAddSubMenu("cnranvilarmor2", "House Items");


  string sMenuShield1 = CnrRecipeAddSubMenu(sMenuShields, "Demon's Bane Shields");
  string sMenuShield2 = CnrRecipeAddSubMenu(sMenuShields, "Iolum Shields");
  string sMenuShield3 = CnrRecipeAddSubMenu(sMenuShields, "Adorned Shields");


  string sMenuSubs2 = CnrRecipeAddSubMenu(sMenuSubs, "Iolum Components");

  string sMenuArmor1 = CnrRecipeAddSubMenu(sMenuArmor, "Demon's Bane Armour");
  string sMenuArmor2 = CnrRecipeAddSubMenu(sMenuArmor, "Iolum Armour");
  string sMenuArmor3 = CnrRecipeAddSubMenu(sMenuArmor, "Adorned Armour");


  string sMenu1Medium = CnrRecipeAddSubMenu(sMenuArmor1, "Medium Demon's Bane");
  string sMenu1Heavy = CnrRecipeAddSubMenu(sMenuArmor1, "Heavy Demon's Bane");

  string sMenu2Medium = CnrRecipeAddSubMenu(sMenuArmor2, "Medium Iolum");
  string sMenu2Heavy = CnrRecipeAddSubMenu(sMenuArmor2, "Heavy Iolum");

  string sMenu3Medium = CnrRecipeAddSubMenu(sMenuArmor3, "Medium Adorned");
  string sMenu3Heavy = CnrRecipeAddSubMenu(sMenuArmor3, "Heavy Adorned");

  CnrRecipeSetDevicePreCraftingScript("cnranvilarmor1", "cnr_anvil_anim");
  CnrRecipeSetDeviceEquippedTool("cnranvilarmor1", "cnrSmithsHammer", CNR_FLOAT_SMITH_HAMMER_BREAKAGE_PERCENTAGE);
  CnrRecipeSetDeviceTradeskillType("cnranvilarmor1", CNR_TRADESKILL_ARMOR_CRAFTING);



  //----------------- Demon's Bane shields -----------------------

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShield1, "Demon's Bane Buckler", "cnrshldbuck4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshldbuck2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrholywater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);


  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShield1, "Large Demon's Bane Shield", "cnrshldlarg4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshldlarg2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrholywater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShield1, "Demon's Bane Tower Shield", "cnrshldtowr4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshldtowr2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrholywater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);


  //----------------- Demon's Bane helm -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelms, "Demon's Bane Helmet", "cnrhelm4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhelm2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrholywater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);


  //----------------- Demon's Bane armors -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Medium, "Demon's Bane Chain Shirt", "cnrchainshirt4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrchainshirt2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrholywater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Medium, "Demon's Bane Scale Mail", "cnrscalemail4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrscalemail2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrholywater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Medium, "Demon's Bane Chain Mail", "cnrchainmail4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrchainmail2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrholywater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Heavy, "Demon's Bane Banded Mail", "cnrbandedmail4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbandedmail2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrholywater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Heavy, "Demon's Bane Splint Mail", "cnrsplintmail4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsplintmail2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrholywater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Heavy, "Demon's Bane Half Plate", "cnrhalfplate4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhalfplate2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrholywater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Heavy, "Demon's Bane Full Plate", "cnrfullplate4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrfullplate2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrholywater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);


  /////////////////////Iolum Subcomponents////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSubs2, "Small Iolum Plates", "cnrsmlplt5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiol", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSubs2, "Medium Iolum Plates", "cnrmedplt5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiol", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSubs2, "Large Iolum Plates", "cnrlrgplt5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiol", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSubs2, "Iolum Chain Rings", "cnrchain5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiol", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);



  //----------------- Iolum shields -----------------------

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShield2, "Iolum Buckler", "cnrshldbuck5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshldbuck", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);


  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShield2, "Large Iolum Shield", "cnrshldlarg5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedplt5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshldlarg", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShield2, "Iolum Tower Shield", "cnrshldtowr5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgplt5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshldtowr", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);


  //----------------- Iolum helm -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelms, "Iolum Helmet", "cnrhelm5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt5", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);


  //----------------- Iolum armors -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Medium, "Iolum Chain Shirt", "cnrchainshirt5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrchain5", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Medium, "Iolum Scale Mail", "cnrscalemail5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrchain5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Medium, "Iolum Chain Mail", "cnrchainmail5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrchain5", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Heavy, "Iolum Banded Mail", "cnrbandedmail5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt1", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Heavy, "Iolum Splint Mail", "cnrsplintmail5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrchain5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Heavy, "Iolum Half Plate", "cnrhalfplate5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgplt5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Heavy, "Iolum Full Plate", "cnrfullplate5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgplt5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);



  //----------------- Adorned shields -----------------------

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShield3, "Adorned Buckler", "cnrshldbuck6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshldbuck5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotada", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);


  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShield3, "Large Adorned Shield", "cnrshldlarg6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshldlarg5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotada", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShield3, "Adorned Tower Shield", "cnrshldtowr6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshldtowr5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotada", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);


  //----------------- Adorned helm -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelms, "Adorned Helmet", "cnrhelm6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhelm5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotada", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);


  //----------------- Adorned armors -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Medium, "Adorned Chain Shirt", "cnrchainshirt6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrchainshirt5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotada", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Medium, "Adorned Scale Mail", "cnrscalemail6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrscalemail5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotada", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Medium, "Adorned Chain Mail", "cnrchainmail6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrchainmail5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotada", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Heavy, "Adorned Banded Mail", "cnrbandedmail6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbandedmail5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotada", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Heavy, "Adorned Splint Mail", "cnrsplintmail6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsplintmail5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotada", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Heavy, "Adorned Half Plate", "cnrhalfplate6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhalfplate5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotada", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Heavy, "Adorned Full Plate", "cnrfullplate6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrfullplate5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotada", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  //////////////////////House Items//////////////////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHouse, "Drannis: Armour of the Tunnels", "dratunarm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrfullplate5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotlir", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "rescardraarmtun", 1, 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "rescardraarmtun", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  }
