/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnranvilarmor1
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

  PrintString("cnranvilarmor1 init");

  /////////////////////////////////////////////////////////
  // CNR recipes made by cnrAnvilArmor
  /////////////////////////////////////////////////////////
  string sMenuShields = CnrRecipeAddSubMenu("cnranvilarmor1", "Shields");
  string sMenuHelms = CnrRecipeAddSubMenu("cnranvilarmor1", "Helms");
  string sMenuArmor = CnrRecipeAddSubMenu("cnranvilarmor1", "Armour");
  string sMenuSubs = CnrRecipeAddSubMenu("cnranvilarmor1", "Components");

  string sMenuShield1 = CnrRecipeAddSubMenu(sMenuShields, "Ondaran Shields");
  string sMenuShield2 = CnrRecipeAddSubMenu(sMenuShields, "Elfur Shields");
  string sMenuShield3 = CnrRecipeAddSubMenu(sMenuShields, "Lirium Shields");


  string sMenuSubs1 = CnrRecipeAddSubMenu(sMenuSubs, "Ondaran Components");
  string sMenuSubs2 = CnrRecipeAddSubMenu(sMenuSubs, "Elfur Components");
  string sMenuSubs3 = CnrRecipeAddSubMenu(sMenuSubs, "Lirium Components");

  string sMenuArmor1 = CnrRecipeAddSubMenu(sMenuArmor, "Ondaran Armour");
  string sMenuArmor2 = CnrRecipeAddSubMenu(sMenuArmor, "Elfur Armour");
  string sMenuArmor3 = CnrRecipeAddSubMenu(sMenuArmor, "Lirium Armour");


  string sMenu1Medium = CnrRecipeAddSubMenu(sMenuArmor1, "Medium Ondaran");
  string sMenu1Heavy = CnrRecipeAddSubMenu(sMenuArmor1, "Heavy Ondaran");

  string sMenu2Medium = CnrRecipeAddSubMenu(sMenuArmor2, "Medium Elfur");
  string sMenu2Heavy = CnrRecipeAddSubMenu(sMenuArmor2, "Heavy Elfur");

  string sMenu3Medium = CnrRecipeAddSubMenu(sMenuArmor3, "Medium Lirium");
  string sMenu3Heavy = CnrRecipeAddSubMenu(sMenuArmor3, "Heavy Lirium");

  CnrRecipeSetDevicePreCraftingScript("cnranvilarmor1", "cnr_anvil_anim");
  CnrRecipeSetDeviceEquippedTool("cnranvilarmor1", "cnrSmithsHammer", CNR_FLOAT_SMITH_HAMMER_BREAKAGE_PERCENTAGE);
  CnrRecipeSetDeviceTradeskillType("cnranvilarmor1", CNR_TRADESKILL_ARMOR_CRAFTING);

  /////////////////////Ondaran Subcomponents////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSubs1, "Small Ondaran Plates", "cnrsmlplt1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotond", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSubs1, "Medium Ondaran Plates", "cnrmedplt1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotond", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSubs1, "Large Ondaran Plates", "cnrlrgplt1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotond", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSubs1, "Ondaran Chain Rings", "cnrchain1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotond", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);



  //----------------- Ondaran shields -----------------------

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShield1, "Ondaran Buckler", "cnrshldbuck1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshldbuck", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);


  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShield1, "Large Ondaran Shield", "cnrshldlarg1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedplt1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshldlarg", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShield1, "Ondaran Tower Shield", "cnrshldtowr1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgplt1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshldtowr", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);


  //----------------- Ondaran helm -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelms, "Ondaran Helmet", "cnrhelm1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt1", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);


  //----------------- Ondaran armors -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Medium, "Ondaran Chain Shirt", "cnrchainshirt1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrchain1", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Medium, "Ondaran Scale Mail", "cnrscalemail1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrchain1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Medium, "Ondaran Chain Mail", "cnrchainmail1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrchain1", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Heavy, "Ondaran Banded Mail", "cnrbandedmail1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt1", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Heavy, "Ondaran Splint Mail", "cnrsplintmail1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrchain1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Heavy, "Ondaran Half Plate", "cnrhalfplate1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgplt1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Heavy, "Ondaran Full Plate", "cnrfullplate1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgplt1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);


  /////////////////////Elfur Subcomponents////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSubs2, "Small Elfur Plates", "cnrsmlplt2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotelf", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSubs2, "Medium Elfur Plates", "cnrmedplt2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotelf", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSubs2, "Large Elfur Plates", "cnrlrgplt2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotelf", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSubs2, "Elfur Chain Rings", "cnrchain2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotelf", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSubs2, "Studs", "cnrstuds", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotelf", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);



  //----------------- Elfur shields -----------------------

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShield2, "Elfur Buckler", "cnrshldbuck2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshldbuck", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);


  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShield2, "Large Elfur Shield", "cnrshldlarg2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedplt2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshldlarg", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShield2, "Elfur Tower Shield", "cnrshldtowr2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgplt2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshldtowr", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);


  //----------------- Elfur helm -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelms, "Elfur Helmet", "cnrhelm2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);


  //----------------- Elfur armors -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Medium, "Elfur Chain Shirt", "cnrchainshirt2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrchain2", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Medium, "Elfur Scale Mail", "cnrscalemail2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrchain2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Medium, "Elfur Chain Mail", "cnrchainmail2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrchain2", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Heavy, "Elfur Banded Mail", "cnrbandedmail2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt1", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Heavy, "Elfur Splint Mail", "cnrsplintmail2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrchain2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Heavy, "Elfur Half Plate", "cnrhalfplate2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgplt2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Heavy, "Elfur Full Plate", "cnrfullplate2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgplt2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);


  /////////////////////Lirium Subcomponents////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSubs3, "Small Lirium Plates", "cnrsmlplt3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotlir", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSubs3, "Medium Lirium Plates", "cnrmedplt3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotlir", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSubs3, "Large Lirium Plates", "cnrlrgplt3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotlir", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSubs3, "Lirium Chain Rings", "cnrchain3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotlir", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);



  //----------------- Lirium shields -----------------------

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShield3, "Lirium Buckler", "cnrshldbuck3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshldbuck", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);


  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShield3, "Large Lirium Shield", "cnrshldlarg3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedplt3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshldlarg", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShield3, "Lirium Tower Shield", "cnrshldtowr3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgplt3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshldtowr", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);


  //----------------- Lirium helm -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelms, "Lirium Helmet", "cnrhelm3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt3", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);


  //----------------- Lirium armors -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Medium, "Lirium Chain Shirt", "cnrchainshirt3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrchain3", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Medium, "Lirium Scale Mail", "cnrscalemail3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrchain3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Medium, "Lirium Chain Mail", "cnrchainmail3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrchain3", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Heavy, "Lirium Banded Mail", "cnrbandedmail3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt1", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Heavy, "Lirium Splint Mail", "cnrsplintmail3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrchain3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Heavy, "Lirium Half Plate", "cnrhalfplate3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgplt3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Heavy, "Lirium Full Plate", "cnrfullplate3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgplt3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);


  }
