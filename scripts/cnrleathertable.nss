/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrleathertable
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

  PrintString("cnrleathertable init");

  /////////////////////////////////////////////////////////
  //  CNR Crafting Device "cnrleathertable"
  /////////////////////////////////////////////////////////

  string sMenuLeatherArmor = CnrRecipeAddSubMenu("cnrleathertable", "Armour");
  string sMenuLeatherHideArmor = CnrRecipeAddSubMenu(sMenuLeatherArmor, "Hide Armour");
  string sMenuLeatherLeathArmor = CnrRecipeAddSubMenu(sMenuLeatherArmor, "Leather Armour");
  string sMenuLeatherStdLthArmor = CnrRecipeAddSubMenu(sMenuLeatherArmor, "Studded Armour");
  string sMenuLeatherSlings = CnrRecipeAddSubMenu("cnrleathertable", "Weapons");
  string sMenuLeatherAcc = CnrRecipeAddSubMenu("cnrleathertable", "Accessories");
  string sMenuLeatherBoots = CnrRecipeAddSubMenu(sMenuLeatherAcc, "Boots");
  string sMenuLeatherCloaks = CnrRecipeAddSubMenu(sMenuLeatherAcc, "Cloaks");
  string sMenuLeatherBelts = CnrRecipeAddSubMenu(sMenuLeatherAcc, "Belts");
  string sMenuLeatherOther = CnrRecipeAddSubMenu("cnrleathertable", "Misc");
  string sMenuLeatherHouse = CnrRecipeAddSubMenu("cnrleathertable", "House Items");

  CnrRecipeSetDevicePreCraftingScript("cnrleathertable", "cnr_tailor_anim");
  CnrRecipeSetDeviceInventoryTool("cnrleathertable", "cnrSewingKit", CNR_FLOAT_SEWING_KIT_BREAKAGE_PERCENTAGE);
  CnrRecipeSetDeviceTradeskillType("cnrleathertable", CNR_TRADESKILL_TAILORING);
  CnrRecipeSetRecipeAbilityPercentages(IntToString(CNR_TRADESKILL_TAILORING), 0, 50, 0, 50, 0, 0);
  
///////////////////////////////////Weapons/////////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherSlings, "Hide Sling", "wbwsl003", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecurebadg", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherSlings, "Leather Sling", "wbwsl004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathbadg", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherSlings, "Hide Whip", "cnrwhip1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathwolf", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherSlings, "Leather Whip", "cnrwhip2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathwolf", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherSlings, "Dragonhide Sling", "wbwsl005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dragonhide", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 15);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 150, 150);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherSlings, "Dragonhide Whip", "cnrwhip3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dragonhide", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 18);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 180, 180);

///////////////////////////////////Other/////////////////////////////////////////


  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherOther, "Bracers", "cnrbrac", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathbadg", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherOther, "Leather Bindings", "cnrbindings", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathbadg", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherOther, "Bearskin Rug", "wt_item_bearrug", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecuregriz", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);

// HIDE ARMOR

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherHideArmor, "Badger Hide Armour", "cnrarmhidbad", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecurebadg", 3, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherHideArmor, "Deer Hide Armour", "cnrarmhiddee", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecuredeer", 3, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherHideArmor, "Wolf Hide Armour", "cnrarmhidwol", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecurewolf", 3, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherHideArmor, "Grizzly Bear Hide Armour", "cnrarmhidgri", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecuregriz", 3, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherHideArmor, "Worg Hide Armour", "cnrarmhidwor", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecureworg", 3, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherHideArmor, "Dire Bear Hide Armour", "cnrarmhiddb", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecuredb", 3, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherHideArmor, "Dragonhide Armour", "maarcl032", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dragonhide", 3, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 17);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 170, 170);

///////////////////////////////////////// LEATHER ARMOR/////////////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherLeathArmor, "Badger Leather Armour", "cnrarmleatbad", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathbadg", 3, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherLeathArmor, "Deer Leather Armour", "cnrarmleatdee", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathdeer", 3, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherLeathArmor, "Wolf Leather Armour", "cnrarmleatwol", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathwolf", 3, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherLeathArmor, "Grizzly Bear Leather Armour", "cnrarmleatgri", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathgriz", 3, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherLeathArmor, "Worg Leather Armour", "cnrarmleatwor", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathworg", 3, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherLeathArmor, "Dire Bear Leather Armour", "cnrarmleatdb", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathdb", 3, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);

// STUDDED ARMOR

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherStdLthArmor, "Studded Badger Armour", "cnrarmstubad", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathbadg", 3, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstuds", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherStdLthArmor, "Studded Deer Armour", "cnrarmstudee", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathdeer", 3, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstuds", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherStdLthArmor, "Studded Wolf Armour", "cnrarmstuwol", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathwolf", 3, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstuds", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherStdLthArmor, "Studded Grizzly Bear Armour", "cnrarmstugri", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathgriz", 3, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstuds", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherStdLthArmor, "Studded Worg Armour", "cnrarmstuwor", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathworg", 3, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstuds", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherStdLthArmor, "Studded Dire Bear Armour", "cnrarmstuddb", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathdb", 3, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstuds", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherStdLthArmor, "Studded Dragonhide Armour", "maarcl033", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dragonhide", 3, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstuds", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 18);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 180, 180);


////////////////////////////////////////////////Boots/////////////////////////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherBoots, "Badger Hide Boots", "cnrbootsbadg", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecurebadg", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherBoots, "Deer Hide Boots", "cnrbootsdeer", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecuredeer", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherBoots, "Wolf Hide Boots", "cnrbootswolf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecurewolf", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherBoots, "Grizzly Bear Hide Boots", "cnrbootsgriz", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecuregriz", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherBoots, "Worg Hide Boots", "cnrbootsworg", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecureworg", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherBoots, "Dire Bear Hide Boots", "cnrbootsdb", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecuredb", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherBoots, "Dragonhide Boots", "cnrbootsdrag", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dragonhide", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 16);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 160, 160);

////////////////////////////////////////////////Cloaks/////////////////////////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherCloaks, "Badger Hide Cloak", "cnrcloak1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecurebadg", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherCloaks, "Deer Hide Cloak", "cnrcloak2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecuredeer", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherCloaks, "Wolf Hide Cloak", "cnrcloak3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecurewolf", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherCloaks, "Grizzly Bear Hide Cloak", "cnrcloak4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecuregriz", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherCloaks, "Worg Hide Cloak", "cnrcloak5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecureworg", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherCloaks, "Dire Bear Hide Cloak", "cnrcloak6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecuredb", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherCloaks, "Dragonhide Cloak", "maarcl037", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dragonhide", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 16);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 160, 160);
  
  
////////////////////////////////////////////////Belts/////////////////////////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherBelts, "Badger Hide Belt", "cnrbelt", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecurebadg", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherBelts, "Deer Hide Belt", "cnrbelt2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecuredeer", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherBelts, "Wolf Hide Belt", "cnrbelt3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecurewolf", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherBelts, "Grizzly Hide Belt", "cnrbelt4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecuregriz", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherBelts, "Worg Hide Belt", "cnrbelt5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecureworg", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherBelts, "Dire Bear Hide Belt", "cnrbelt6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecuredb", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherBelts, "Dragonhide Belt", "cnrbelt7", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dragonhide", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 16);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 160, 160);

  //////////////////////////////////////////House Items/////////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherHouse, "Renerrin: Duelling Gloves", "rendueglo", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleatbat", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "rescarrendueglo", 1, 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "rescarrendueglo", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

}
