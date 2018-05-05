/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrAlchemyTable
//
//  Desc:  Recipe initialization.
//
//  Author: David Bobeck 15May03
//  Modified: Gary Corcoran 30Jul03
//  Updated and substantially revised by Cara 17Apr06
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"

void main()
{
  string sKeyToRecipe;

  PrintString("cnralchemytable init");

  /////////////////////////////////////////////////////////
  // CNR recipes made by cnrAlchemyTable
  /////////////////////////////////////////////////////////
  string sMenuAlchemyOils = CnrRecipeAddSubMenu("cnralchemytable", "Oils and Acids");
  string sMenuAlchemyPotions = CnrRecipeAddSubMenu("cnralchemytable", "Potions");

  CnrRecipeSetDevicePreCraftingScript("cnralchemytable", "cnr_alchemy_anim");
  //CnrRecipeSetDeviceInventoryTool("cnrAlchemyTable", "");
  CnrRecipeSetDeviceTradeskillType("cnralchemytable", CNR_TRADESKILL_IMBUING);
  CnrRecipeSetRecipeAbilityPercentages("cnralchemytable", 0, 0, 0, 0, 50, 50); // WIS and CHA

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyOils, "Tanning Acid", "cnrAcidTanning", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_MSMLMISC08", 1); // Fire Beetle Belly
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyOils, "Tanning Oil", "cnrOilTanning", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_MSMLMISC08", 1); // Fire Beetle Belly
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);


  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Bless", "NW_IT_MPOTION009", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrangelicaleaf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrwalnutfruit", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);


  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Cure Light Wounds", "NW_IT_MPOTION001", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnraloeleaf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrgarlicclove", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Lore", "cnrpotlore", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloverleaf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsageleaf", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Barkskin", "NW_IT_MPOTION005", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpepmintleaf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbirchbark", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Cure Moderate Wounds", "NW_IT_MPOTION020", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnraloeleaf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcomfreyroot", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Lesser Restoration", "NW_IT_MPOTION011", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrangelicaleaf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnralmondfruit", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Bull's Strength", "NW_IT_MPOTION015", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpepmintleaf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHawthornFwr", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Cat's Grace", "NW_IT_MPOTION014", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpepmintleaf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcatnipleaf", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Fox's Cunning", "NW_IT_MPOTION017", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpepmintleaf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhazelleaf", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Eagle's Splendor", "NW_IT_MPOTION010", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpepmintleaf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcalendulafwr", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Owl's Wisdom", "NW_IT_MPOTION018", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpepmintleaf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhazelnutfruit", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Endurance", "NW_IT_MPOTION013", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpepmintleaf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrchestnutfruit", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Aid", "NW_IT_MPOTION016", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrangelicaleaf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpecanfruit", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Invisibility", "NW_IT_MPOTION008", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloverleaf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrskullcapleaf", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Speed", "NW_IT_MPOTION004", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloverleaf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrthistleleaf", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Clarity", "NW_IT_MPOTION007", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloverleaf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrnettleleaf", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Cure Serious Wounds", "NW_IT_MPOTION002", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnraloeleaf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrechinacearoot", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Antidote", "NW_IT_MPOTION006", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrangelicaleaf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrchamomilefwr", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Cure Critical Wounds", "NW_IT_MPOTION003", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnraloeleaf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrgingerroot", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Heal", "NW_IT_MPOTION012", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnraloeleaf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrginsengroot", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);

}



