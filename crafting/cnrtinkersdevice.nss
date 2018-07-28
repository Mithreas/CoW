/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrTinkersDevice
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

  PrintString("cnrtinkersdevice init");

  /////////////////////////////////////////////////////////
  // CNR recipes made by cnrTinkersDevice
  /////////////////////////////////////////////////////////
  string sMenuTinkerBelts = CnrRecipeAddSubMenu("cnrTinkersDevice", "Belts");
  string sMenuTinkerBracers = CnrRecipeAddSubMenu("cnrTinkersDevice", "Bracers");
  string sMenuTinkerCloaks = CnrRecipeAddSubMenu("cnrTinkersDevice", "Cloaks");
  string sMenuTinkerMisc = CnrRecipeAddSubMenu("cnrTinkersDevice", "Misc Stuff");

  CnrRecipeSetDevicePreCraftingScript("cnrtinkersdevice", "cnr_tinker_anim");
  CnrRecipeSetDeviceInventoryTool("cnrtinkersdevice", "cnrTinkersTools", CNR_FLOAT_TINKERS_TOOLS_BREAKAGE_PERCENTAGE);
  CnrRecipeSetDeviceTradeskillType("cnrtinkersdevice", CNR_TRADESKILL_CHEMISTRY);


////////////////////////////////////////////////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerMisc, "Compound Bow Cam", "cnrbowcam", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiro", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  /////////////////////Belts for gemsetting////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerBelts, "Iron Buckled Belt", "ca_1belt", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "intca_1buc", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbelt", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerBelts, "Lirium Buckled Belt", "ca_2belt", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "intca_2buc", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbelt", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerBelts, "Demon's Bane Buckled Belt", "ca_3belt", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "intca_3buc", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbelt", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerBelts, "Iolum Buckled Belt", "ca_4belt", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "intca_4buc", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbelt", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerBelts, "Adanium Buckled Belt", "ca_5belt", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "intca_5buc", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbelt", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerBelts, "Mithril Buckled Belt", "ca_6belt", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "intca_6buc", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbelt", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  /////////////////////Bracers for gemsetting////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerBracers, "Iron Banded Bracers", "ca_1bracers", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "intca_1ban", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbrac", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerBracers, "Lirium Banded Bracers", "ca_2bracers", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "intca_2ban", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbrac", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerBracers, "Demon's Bane Banded Bracers", "ca_3bracers", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "intca_3ban", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbrac", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerBracers, "Iolum Banded Bracers", "ca_4bracers", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "intca_4ban", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbrac", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerBracers, "Adanium Banded Bracers", "ca_5bracers", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "intca_5ban", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbrac", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerBracers, "Stallix Banded Bracers", "ca_6bracers", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "intca_6ban", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbrac", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  /////////////////////Cloaks for gemsetting////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerBracers, "Cloak with an Iron Brooch", "ca_1cloak", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "intca_1bro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerBracers, "Cloak with a Lirium Brooch", "ca_2cloak", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "intca_2bro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerBracers, "Cloak with a Lirium Brooch", "ca_3cloak", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "intca_3bro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerBracers, "Cloak with an Iolum Brooch", "ca_4cloak", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "intca_4bro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerBracers, "Cloak with an Adanium Brooch", "ca_5cloak", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "intca_5bro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerBracers, "Cloak with a Stallix Brooch", "ca_6cloak", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "intca6bro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

}
