/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrTinkerSetting
//
//  Desc:  Recipe initialization.
//
//  Author: David Bobeck 15May03
//  Updated and substantially revised by Cara 17Apr06
//
/////////////////////////////////////////////////////////

#include "cnr_recipe_utils"

void main()
{
  string sKeyToRecipe;

  PrintString("cnrtinkersetting init");

  /////////////////////////////////////////////////////////
  // CNR recipes made by cnrTinkersDevice
  /////////////////////////////////////////////////////////
  string sMenuTinkerBands = CnrRecipeAddSubMenu("cnrTinkerSetting", "Bands");
  string sMenuTinkerBroches = CnrRecipeAddSubMenu("cnrTinkerSetting", "Broches");
  string sMenuTinkerBuckles = CnrRecipeAddSubMenu("cnrTinkerSetting", "Buckles");
  string sMenuTinkerRings = CnrRecipeAddSubMenu("cnrTinkerSetting", "Rings");
  string sMenuTinkerAmulets = CnrRecipeAddSubMenu("cnrTinkerSetting", "Amulets");
  string sMenuTinkerHouse = CnrRecipeAddSubMenu("cnrTinkerSetting", "House Items");

  CnrRecipeSetDevicePreCraftingScript("cnrtinkersetting", "cnr_tinker_anim");
  CnrRecipeSetDeviceInventoryTool("cnrtinkersetting", "cnrTinkersTools", CNR_FLOAT_TINKERS_TOOLS_BREAKAGE_PERCENTAGE);
  CnrRecipeSetDeviceTradeskillType("cnrtinkersetting", CNR_TRADESKILL_EXPLOSIVES);

  /////////////////////Bands for gemsetting////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerBands, "Elfur Bands", "intca_1ban", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotelf", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerBands, "Lirium Bands", "intca_2ban", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotlir", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerBands, "Demon's Bane Bands", "intca_3ban", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerBands, "Iolum Bands", "intca_4ban", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiol", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerBands, "Adanium Bands", "intca_5ban", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotada", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerBands, "Stallix Bands", "intca_6ban", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsta", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  /////////////////////Broches for gemsetting////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerBroches, "Elfur Broach", "intca_1bro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotelf", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerBroches, "Lirium Broach", "intca_2bro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotlir", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerBroches, "Demon's Bane Broach", "intca_3bro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerBroches, "Iolum Broach", "intca_4bro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiol", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerBroches, "Adanium Broach", "intca_5bro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotada", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerBroches, "Stallix Broach", "intca_6bro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsta", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  /////////////////////Buckles for gemsetting////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerBuckles, "Elfur Buckle", "intca_1buc", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotelf", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerBuckles, "Lirium Buckle", "intca_2buc", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotlir", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerBuckles, "Demon's Bane Buckle", "intca_3buc", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerBuckles, "Iolum Buckle", "intca_4buc", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiol", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerBroches, "Adanium Buckle", "intca_52", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotada", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerBuckles, "Stallix Buckle", "intca_6buc", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsta", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  /////////////////////Rings for gemsetting////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerRings, "Elfur Ring", "ca_1ring", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotelf", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerRings, "Lirium Ring", "ca_2ring", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotlir", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerRings, "Demon's Bane Ring", "ca_3ring", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerRings, "Iolum Ring", "ca_4ring", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiol", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerRings, "Adanium Ring", "ca_5ring", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotada", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerRings, "Stallix Ring", "ca_6ring", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsta", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  /////////////////////Amulets for gemsetting////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerAmulets, "Elfur Amulet", "ca_1amulet", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotelf", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerAmulets, "Lirium Amulet", "ca_2amulet", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotlir", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerAmulets, "Demon's Bane Amulet", "ca_3amulet", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerAmulets, "Iolum Amulet", "ca_4amulet", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiol", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerAmulets, "Adanium Amulet", "ca_5amulet", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotada", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerAmulets, "Stallix Amulet", "ca_6amulet", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsta", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  ///////////////////////House Items////////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerHouse, "Renerrin: Amulet of Leano", "renamulea", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemgarn", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "rescarrenamullea", 1, 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "rescarrenamulea", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerHouse, "Erenia: Prayer Beads", "ereprabea", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotond", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotelf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotlir", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiol", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotada", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsta", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "rescarereprabea", 1, 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "rescarereprabea", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

}
