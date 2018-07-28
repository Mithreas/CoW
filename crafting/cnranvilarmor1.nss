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
  string sMenuShield2 = CnrRecipeAddSubMenu(sMenuShields, "Iron Shields");
  string sMenuShield3 = CnrRecipeAddSubMenu(sMenuShields, "Silver Shields");


  string sMenuSubs1 = CnrRecipeAddSubMenu(sMenuSubs, "Ondaran Components");
  string sMenuSubs2 = CnrRecipeAddSubMenu(sMenuSubs, "Iron Components");
  string sMenuSubs3 = CnrRecipeAddSubMenu(sMenuSubs, "Silver Components");

  string sMenuArmor1 = CnrRecipeAddSubMenu(sMenuArmor, "Ondaran Armour");
  string sMenuArmor2 = CnrRecipeAddSubMenu(sMenuArmor, "Iron Armour");
  string sMenuArmor3 = CnrRecipeAddSubMenu(sMenuArmor, "Silver Armour");


  string sMenu1Medium = CnrRecipeAddSubMenu(sMenuArmor1, "Medium Ondaran");
  string sMenu1Heavy = CnrRecipeAddSubMenu(sMenuArmor1, "Heavy Ondaran");

  string sMenu2Medium = CnrRecipeAddSubMenu(sMenuArmor2, "Medium Iron");
  string sMenu2Heavy = CnrRecipeAddSubMenu(sMenuArmor2, "Heavy Iron");

  string sMenu3Medium = CnrRecipeAddSubMenu(sMenuArmor3, "Medium Silver");
  string sMenu3Heavy = CnrRecipeAddSubMenu(sMenuArmor3, "Heavy Silver");

  CnrRecipeSetDevicePreCraftingScript("cnranvilarmor1", "cnr_anvil_anim");
  CnrRecipeSetDeviceEquippedTool("cnranvilarmor1", "cnrSmithsHammer", CNR_FLOAT_SMITH_HAMMER_BREAKAGE_PERCENTAGE);
  CnrRecipeSetDeviceTradeskillType("cnranvilarmor1", CNR_TRADESKILL_ARMOR_CRAFTING);
  CnrRecipeSetRecipeAbilityPercentages("cnranvilarmor1", 50, 0, 50, 0, 0, 0);

  /////////////////////Ondaran Subcomponents////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSubs1, "Small Ondaran Plates", "cnrsmlplt1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotond", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSubs1, "Medium Ondaran Plates", "cnrmedplt1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotond", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSubs1, "Large Ondaran Plates", "cnrlrgplt1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotond", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSubs1, "Ondaran Chain Rings", "cnrchain1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotond", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);



  //----------------- Ondaran shields -----------------------

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShield1, "Ondaran Buckler", "cnrshldbuck1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshldbuck", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);


  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShield1, "Large Ondaran Shield", "cnrshldlarg1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedplt1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshldlarg", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShield1, "Ondaran Tower Shield", "cnrshldtowr1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgplt1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshldtowr", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);


  //----------------- Ondaran helm -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelms, "Ondaran Helmet", "cnrhelm1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt1", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);


  //----------------- Ondaran armors -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Medium, "Ondaran Chain Shirt", "cnrchainshirt1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrchain1", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Medium, "Ondaran Scale Mail", "cnrscalemail1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrchain1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Medium, "Ondaran Chain Mail", "cnrchainmail1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrchain1", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Heavy, "Ondaran Banded Mail", "cnrbandedmail1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt1", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Heavy, "Ondaran Splint Mail", "cnrsplintmail1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrchain1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Heavy, "Ondaran Half Plate", "cnrhalfplate1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgplt1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Heavy, "Ondaran Full Plate", "cnrfullplate1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgplt1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);


  /////////////////////Iron Subcomponents////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSubs2, "Small Iron Plates", "cnrsmlplt2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiro", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSubs2, "Medium Iron Plates", "cnrmedplt2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiro", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSubs2, "Large Iron Plates", "cnrlrgplt2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiro", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSubs2, "Iron Chain Rings", "cnrchain2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiro", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSubs2, "Studs", "cnrstuds", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiro", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);



  //----------------- Iron shields -----------------------

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShield2, "Iron Buckler", "ashsw003", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshldbuck", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);


  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShield2, "Large Iron Shield", "ashlw003", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedplt2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshldlarg", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShield2, "Iron Tower Shield", "ashto003", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgplt2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshldtowr", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);


  //----------------- Iron helm -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelms, "Iron Helmet", "cnrhelm2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);


  //----------------- Iron armors -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Medium, "Iron Chain Mail", "aarcl016", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrchain2", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Medium, "Iron Scale Mail", "aarcl017", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrchain2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Heavy, "Iron Banded Mail", "aarcl015", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt1", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Heavy, "Iron Half Plate", "aarcl014", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgplt2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Heavy, "Iron Full Plate", "aarcl008", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgplt2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);


  /////////////////////Silver Subcomponents////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSubs3, "Small Silver Plates", "cnrsmlplt3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsil", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSubs3, "Medium Silver Plates", "cnrmedplt3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsil", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSubs3, "Large Silver Plates", "cnrlrgplt3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsil", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSubs3, "Silver Chain Rings", "cnrchain3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsil", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);



  //----------------- Silver shields -----------------------

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShield3, "Silver Buckler", "ashsw005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshldbuck", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);


  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShield3, "Large Silver Shield", "ashlw005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedplt3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshldlarg", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShield3, "Silver Tower Shield", "ashto005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgplt3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshldtowr", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);


  //----------------- Silver helm -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelms, "Silver Helmet", "cnrhelm3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt3", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);


  //----------------- Silver armors -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Medium, "Silver Chain Mail", "aarcl026", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrchain3", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Medium, "Silver Scale Mail", "aarcl027", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrchain3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Heavy, "Silver Banded Mail", "aarcl024", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt3", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Heavy, "Silver Half Plate", "aarcl025", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgplt3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Heavy, "Silver Full Plate", "aarcl023", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgplt3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);


  }
