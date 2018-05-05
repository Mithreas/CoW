///////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrTinkerToolbox
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

  PrintString("cnrtinkertoolbox init");

  /////////////////////////////////////////////////////////
  // CNR recipes made by cnrTinkerToolbox
  /////////////////////////////////////////////////////////
  string sMenuTinkerTools = CnrRecipeAddSubMenu("cnrTinkerToolbox", "Tools");
  string sMenuTinkerTrapsMinor = CnrRecipeAddSubMenu("cnrTinkerToolbox", "Minor Traps");
  string sMenuTinkerTrapsAverage = CnrRecipeAddSubMenu("cnrTinkerToolbox", "Average Traps");
  string sMenuTinkerTrapsStrong = CnrRecipeAddSubMenu("cnrTinkerToolbox", "Strong Traps");
  string sMenuTinkerTrapsDeadly = CnrRecipeAddSubMenu("cnrTinkerToolbox", "Deadly Traps");

  //CnrRecipeSetDevicePreCraftingScript("cnrTinkerToolbox", "cnr_tinker_anim");
  CnrRecipeSetDeviceInventoryTool("cnrtinkertoolbox", "cnrTinkersTools", CNR_FLOAT_TINKERS_TOOLS_BREAKAGE_PERCENTAGE);
  CnrRecipeSetDeviceTradeskillType("cnrtinkertoolbox", CNR_TRADESKILL_EXPLOSIVES);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerTools, "Shovel", "cnrShovel", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 25, 0, 25, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerTools, "Skinning Knife", "cnrSkinningKnife", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 25, 0, 25, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerTools, "Carving Knife", "cnrCarvingKnife", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 25, 0, 25, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerTools, "Woodcutter's Axe", "cnrWoodCutterAxe", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 25, 0, 25, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerTools, "Miner's Pickaxe", "cnrMinersPickaxe", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 25, 0, 25, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerTools, "Smith's Hammer", "cnrSmithsHammer", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 25, 0, 25, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerTools, "Tinker's Tools", "cnrTinkersTools", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerTools, "Carpenter's Tools", "cnrCarpsTools", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerTools, "Sewing Kit", "cnrSewingKit", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSpiderSilk", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  //
  // -------------------------   minor traps ------------------------------
  //
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerTrapsMinor, "Minor Spike Trap", "NW_IT_TRAP001", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIronSpikes", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGearsCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWireCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerTrapsMinor, "Minor Acid Trap", "NW_IT_TRAP033", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBellBomb", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGearsCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWireCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);


  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerTrapsMinor, "Minor Tangle Trap", "NW_IT_TRAP009", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSpiderSilk", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGearsCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWireCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerTrapsMinor, "Minor Fire Trap", "NW_IT_TRAP017", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_MSMLMISC08", 1); //One firebeetle belly
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGearsCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWireCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  //
  // -------------------------   average traps ------------------------------
  //
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerTrapsAverage, "Average Spike Trap", "NW_IT_TRAP002", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIronSpikes", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGearsTin", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWireTin", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerTrapsAverage, "Average Acid Trap", "NW_IT_TRAP034", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBellBomb", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGearsTin", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWireTin", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);


  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerTrapsAverage, "Average Tangle Trap", "NW_IT_TRAP010", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSpiderSilk", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGearsTin", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWireTin", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerTrapsAverage, "Average Fire Trap", "NW_IT_TRAP018", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_MSMLMISC08", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGearsTin", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWireTin", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  //
  // -------------------------   strong traps ------------------------------
  //
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerTrapsStrong, "Strong Spike Trap", "NW_IT_TRAP003", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIronSpikes", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGearsIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWireIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerTrapsStrong, "Strong Acid Trap", "NW_IT_TRAP035", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBellBomb", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGearsIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWireIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerTrapsStrong, "Strong Tangle Trap", "NW_IT_TRAP011", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSpiderSilk", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGearsIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWireIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerTrapsStrong, "Strong Fire Trap", "NW_IT_TRAP019", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_MSMLMISC08", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGearsIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWireIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  //
  // -------------------------   deadly traps ------------------------------
  //
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerTrapsDeadly, "Deadly Spike Trap", "NW_IT_TRAP004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIronSpikes", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGearsMith", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWireMith", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerTrapsDeadly, "Deadly Acid Trap", "NW_IT_TRAP036", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBellBomb", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGearsMith", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWireMith", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerTrapsDeadly, "Deadly Tangle Trap", "NW_IT_TRAP012", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSpiderSilk", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGearsMith", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWireMith", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe,110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerTrapsDeadly, "Deadly Fire Trap", "NW_IT_TRAP020", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_MSMLMISC08", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGearsMith", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWireMith", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

}
