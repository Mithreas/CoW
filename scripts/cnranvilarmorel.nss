/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnranvilarmorel
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

  PrintString("cnranvilarmorel init");

  /////////////////////////////////////////////////////////
  // CNR recipes made by cnrAnvilArmor
  /////////////////////////////////////////////////////////
  string sMenuShields = CnrRecipeAddSubMenu("cnranvilarmorel", "Shields");
  string sMenuHelms = CnrRecipeAddSubMenu("cnranvilarmorel", "Helms");
  string sMenuArmor = CnrRecipeAddSubMenu("cnranvilarmorel", "Armour");
  string sMenuSubs = CnrRecipeAddSubMenu("cnranvilarmorel", "Components");

  string sMenuShield1 = CnrRecipeAddSubMenu(sMenuShields, "Ondaran Shields");
  string sMenuShield3 = CnrRecipeAddSubMenu(sMenuShields, "Silver Shields");
  string sMenuShield4 = CnrRecipeAddSubMenu(sMenuShields, "Mithril Shields");


  string sMenuSubs1 = CnrRecipeAddSubMenu(sMenuSubs, "Ondaran Components");
  string sMenuSubs2 = CnrRecipeAddSubMenu(sMenuSubs, "Chitin Components");
  string sMenuSubs3 = CnrRecipeAddSubMenu(sMenuSubs, "Silver Components");
  string sMenuSubs4 = CnrRecipeAddSubMenu(sMenuSubs, "Mithril Components");

  string sMenuArmor1 = CnrRecipeAddSubMenu(sMenuArmor, "Ondaran Armour");
  string sMenuArmor2 = CnrRecipeAddSubMenu(sMenuArmor, "Chitin Armour");
  string sMenuArmor3 = CnrRecipeAddSubMenu(sMenuArmor, "Silver Armour");
  string sMenuArmor4 = CnrRecipeAddSubMenu(sMenuArmor, "Mithril Armour");
  string sMenuArmor5 = CnrRecipeAddSubMenu(sMenuArmor, "Ankheg Armour");

  
  string sMenu1Medium = CnrRecipeAddSubMenu(sMenuArmor1, "Medium Ondaran");
  string sMenu1Heavy = CnrRecipeAddSubMenu(sMenuArmor1, "Heavy Ondaran");

  string sMenu2Medium = CnrRecipeAddSubMenu(sMenuArmor2, "Medium Chitin");

  string sMenu3Medium = CnrRecipeAddSubMenu(sMenuArmor3, "Medium Silver");
  string sMenu3Heavy = CnrRecipeAddSubMenu(sMenuArmor3, "Heavy Silver");

  string sMenu4Medium = CnrRecipeAddSubMenu(sMenuArmor4, "Medium Mithril");
  string sMenu4Heavy = CnrRecipeAddSubMenu(sMenuArmor4, "Heavy Mithril");

  CnrRecipeSetDevicePreCraftingScript("cnranvilarmorel", "cnr_anvil_anim");
  CnrRecipeSetDeviceEquippedTool("cnranvilarmorel", "cnrSmithsHammer", CNR_FLOAT_SMITH_HAMMER_BREAKAGE_PERCENTAGE);
  CnrRecipeSetDeviceTradeskillType("cnranvilarmorel", CNR_TRADESKILL_ARMOR_CRAFTING);
  CnrRecipeSetRecipeAbilityPercentages("cnranvilarmorel", 50, 0, 50, 0, 0, 0);

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


  /////////////////////Chitin Subcomponents////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSubs2, "Small Chitin Plates", "cnrsmlplt5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "arachnechitin", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSubs2, "Medium Chitin Plates", "cnrmedplt5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "arachnechitin", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  //sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSubs2, "Large Chitin Plates", "cnrlrgplt5", 1);
  //CnrRecipeAddComponent(sKeyToRecipe, "arachnechitin", 3);
  //CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  //CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);


  //----------------- Chitin helm -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelms, "Chitin Helmet", "cnrhelm5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt5", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

  //----------------- Chitin armor -----------------------

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Medium, "Chitin Scale Mail", "aarcl037", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedplt5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

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

 /////////////////////Mithril Subcomponents////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSubs4, "Small Mithril Plates", "cnrsmlplt6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotmit", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSubs4, "Medium Mithril Plates", "cnrmedplt6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotmit", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSubs4, "Large Mithril Plates", "cnrlrgplt6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotmit", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSubs4, "Mithril Chain Rings", "cnrchain6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotmit", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);

  //----------------- Mithril shields -----------------------

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShield4, "Mithril Buckler", "ashsw006", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshldbuck", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);


  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShield4, "Large Mithril Shield", "ashlw006", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedplt6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshldlarg", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShield4, "Mithril Tower Shield", "ashto006", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgplt6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshldtowr", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 15);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 150, 150);


  //----------------- Mithril helm -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelms, "Mithril Helmet", "cnrhelm6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt6", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);


  //----------------- Mithril armors -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu4Medium, "Mithril Chain Mail", "aarcl032", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrchain6", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrthreadmit", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu4Medium, "Mithril Scale Mail", "aarcl033", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrchain6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrthreadmit", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu4Heavy, "Mithril Banded Mail", "aarcl030", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt6", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrthreadmit", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 15);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 150, 150);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu4Heavy, "Mithril Half Plate", "aarcl031", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgplt6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrthreadmit", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 16);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 160, 160);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu4Heavy, "Mithril Full Plate", "aarcl029", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgplt6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrthreadmit", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 17);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 170, 170);


  //----------------- Ankheg armor -----------------------

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuArmor5, "Ankheg Full Plate", "aarcl028", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "AnkhegShell", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 15);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 150, 150);

  }
