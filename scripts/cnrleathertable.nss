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

  string sMenuLeatherBags = CnrRecipeAddSubMenu("cnrleathertable", "Bags");
  string sMenuLeatherHideArmor = CnrRecipeAddSubMenu("cnrleathertable", "Hide Armour");
  string sMenuLeatherLeathArmor = CnrRecipeAddSubMenu("cnrleathertable", "Leather Armour");
  string sMenuLeatherStdLthArmor = CnrRecipeAddSubMenu("cnrleathertable", "Studded Armour");
  string sMenuLeatherOther = CnrRecipeAddSubMenu("cnrleathertable", "Other");
  string sMenuLeatherBoots = CnrRecipeAddSubMenu("cnrleathertable", "Boots");
  string sMenuLeatherCloaks = CnrRecipeAddSubMenu("cnrleathertable", "Cloaks");
  string sMenuLeatherHouse = CnrRecipeAddSubMenu("cnrleathertable", "House Items");

  CnrRecipeSetDevicePreCraftingScript("cnrleathertable", "cnr_tailor_anim");
  CnrRecipeSetDeviceInventoryTool("cnrleathertable", "cnrSewingKit", CNR_FLOAT_SEWING_KIT_BREAKAGE_PERCENTAGE);
  //CnrRecipeSetDeviceEquippedTool("cnrLeatherTable", "cnr");
  CnrRecipeSetDeviceTradeskillType("cnrleathertable", CNR_TRADESKILL_TAILORING);

///////////////////////////////////Other/////////////////////////////////////////


  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherOther, "Belt", "cnrbelt", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathbadg", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);


  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherOther, "Bracers", "cnrbrac", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathbadg", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);


  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherOther, "Bindings", "cnrbindings", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathbadg", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);


///////////////////////////////////////Bags///////////////////////////////////////////////


  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherBags, "Badger Hide Bag", "cnrbagbadg", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathbadg", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherBags, "Deer Hide Bag", "cnrbagdeer", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathdeer", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherBags, "Wolf Bag", "cnrbagwolf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathwolf", 2, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);


///////////////////////////////////////// LEATHER ARMOR/////////////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherLeathArmor, "Badger Leather Armour", "cnrarmleatbad", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathbadg", 3, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherLeathArmor, "Deer Leather Armour", "cnrarmleatdee", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathdeer", 3, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherLeathArmor, "Wolf Leather Armour", "cnrarmleatwol", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathwolf", 3, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherLeathArmor, "Grizzly Bear Leather Armour", "cnrarmleatgri", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathgriz", 3, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherLeathArmor, "Worg Leather Armour", "cnrarmleatwor", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathworg", 3, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherLeathArmor, "Dire Bear Leather Armour", "cnrarmleatdb", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathdb", 3, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 120);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

// HIDE ARMOR

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherHideArmor, "Badger Hide Armour", "cnrarmhidbad", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecurebadg", 3, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherHideArmor, "Deer Hide Armour", "cnrarmhiddee", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecuredeer", 3, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherHideArmor, "Wolf Hide Armour", "cnrarmhidwol", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecurewolf", 3, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherHideArmor, "Grizzly Bear Hide Armour", "cnrarmhidgri", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecuregriz", 3, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

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
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

// STUDDED ARMOR

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherStdLthArmor, "Studded Badger Armour", "cnrarmstubad", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathbadg", 3, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstuds", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherStdLthArmor, "Studded Deer Armour", "cnrarmstudee", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathdeer", 3, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstuds", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherStdLthArmor, "Studded Wolf Armour", "cnrarmstuwol", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathwolf", 3, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstuds", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherStdLthArmor, "Studded Grizzly Bear Armour", "cnrarmstugri", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathgriz", 3, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstuds", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherStdLthArmor, "Studded Worg Armour", "cnrarmstuwor", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathworg", 3, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstuds", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherStdLthArmor, "Studded Dire Bear Armour", "cnrarmstuddb", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathdb", 3, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpadding", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstuds", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);


////////////////////////////////////////////////Boots/////////////////////////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherBoots, "Badger Hide Boots", "cnrbootsbadg", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathbadg", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherBoots, "Deer Hide Boots", "cnrbootsdeer", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathdeer", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherBoots, "Wolf Hide Boots", "cnrbootswolf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathwolf", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherBoots, "Grizzly Bear Hide Boots", "cnrbootsgriz", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathgriz", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherBoots, "Worg Hide Boots", "cnrbootsworg", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathworg", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherBoots, "Dire Bear Hide Boots", "cnrbootsdb", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathdb", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 120);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

////////////////////////////////////////////////Cloaks/////////////////////////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherCloaks, "Badger Hide Cloak", "cnrcloak1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecurebadg", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherCloaks, "Deer Hide Cloak", "cnrcloak2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecurehdeer", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherCloaks, "Wolf Hide Cloak", "cnrcloak3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecurewolf", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherCloaks, "Grizzly Bear Hide Cloak", "cnrcloak4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecuregriz", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherCloaks, "Worg Hide Boots", "cnrcloak5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecureworg", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherCloaks, "Dire Bear Hide Boots", "cnrcloak6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecuredb", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 120);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  //////////////////////////////////////////House Items/////////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLeatherHouse, "Renerrin: Duelling Gloves", "rendueglo", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleatbat", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "rescarrendueglo", 1, 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "rescarrendueglo", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 0, 35, 0);

}
