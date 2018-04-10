/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrIngotRecycler
//
//  Desc:  Recipe initialization.
//
//  Author: David Bobeck 15May03
//  Modified: Gary Corcoran 19May03
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"

void InitIngotRecyclerMangled()
{
  string sKeyToRecipe;

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Copper Ingot", "cnrIngotCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMangledCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingot", "cnrIngotBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMangledBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingot", "cnrIngotIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMangledIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Platinum Ingot", "cnrIngotPlat", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMangledPlat", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Adamantium Ingot", "cnrIngotAdam", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMangledAdam", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Cobalt Ingot", "cnrIngotCoba", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMangledCoba", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Mithril Ingot", "cnrIngotMith", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMangledMith", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  CnrDecrementStackCount(OBJECT_SELF);
}

void InitIngotRecyclerCopper()
{
  string sKeyToRecipe;

  //----------------- small copper weapons -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Copper Ingot", "cnrIngotCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrTAxeCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Copper Ingot", "cnrIngotCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrKurkiCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Copper Ingot", "cnrIngotCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSickleCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Copper Ingot", "cnrIngotCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSpearCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Copper Ingot", "cnrIngotCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrDaggerCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Copper Ingot", "cnrIngotCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrLtHammerCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Copper Ingot", "cnrIngotCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrKamaCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Copper Ingot", "cnrIngotCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHandAxeCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Copper Ingot", "cnrIngotCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrLtFlailCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Copper Ingot", "cnrIngotCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScytheCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  //----------------- medium copper weapons -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Copper Ingots", "cnrIngotCopp", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScimitarCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Copper Ingots", "cnrIngotCopp", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMaceCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Copper Ingots", "cnrIngotCopp", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMstarCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Copper Ingots", "cnrIngotCopp", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHalberdCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Copper Ingots", "cnrIngotCopp", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShSwordCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Copper Ingots", "cnrIngotCopp", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBattleAxeCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Copper Ingots", "cnrIngotCopp", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWarHammerCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  //----------------- large copper weapons -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Copper Ingots", "cnrIngotCopp", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrRapierCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Copper Ingots", "cnrIngotCopp", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHyFlailCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Copper Ingots", "cnrIngotCopp", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrKatanaCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Copper Ingots", "cnrIngotCopp", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrDireMaceCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Copper Ingots", "cnrIngotCopp", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrLgSwordCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Copper Ingots", "cnrIngotCopp", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrDoubleAxeCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Copper Ingots", "cnrIngotCopp", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGreatAxeCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Copper Ingots", "cnrIngotCopp", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBaSwordCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Copper Ingots", "cnrIngotCopp", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrDSwordCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Copper Ingots", "cnrIngotCopp", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGrSwordCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  CnrDecrementStackCount(OBJECT_SELF);
}
 
void InitIngotRecyclerBronze()
{
  string sKeyToRecipe;

  //----------------- small bronze weapons -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingot", "cnrIngotBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrTAxeBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingot", "cnrIngotBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrKurkiBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingot", "cnrIngotBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSickleBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingot", "cnrIngotBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSpearBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingot", "cnrIngotBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrLtHammerBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingot", "cnrIngotBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrDaggerBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingot", "cnrIngotBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrKamaBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingot", "cnrIngotBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHandAxeBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingot", "cnrIngotBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrLtFlailBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingot", "cnrIngotBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScytheBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  //----------------- medium bronze weapons -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingots", "cnrIngotBron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScimitarBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingots", "cnrIngotBron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMaceBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingots", "cnrIngotBron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMstarBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingots", "cnrIngotBron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHalberdBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingots", "cnrIngotBron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShSwordBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingots", "cnrIngotBron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBattleAxeBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingots", "cnrIngotBron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWarHammerBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  //----------------- large bronze weapons -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingots", "cnrIngotBron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrRapierBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingots", "cnrIngotBron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHyFlailBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingots", "cnrIngotBron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrKatanaBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingots", "cnrIngotBron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrDireMaceBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingots", "cnrIngotBron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrLgSwordBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingots", "cnrIngotBron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrDoubleAxeBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingots", "cnrIngotBron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGreatAxeBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingots", "cnrIngotBron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBaSwordBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingots", "cnrIngotBron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrDSwordBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingots", "cnrIngotBron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGrSwordBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  CnrDecrementStackCount(OBJECT_SELF);
}

void InitIngotRecyclerIron()
{
  string sKeyToRecipe;

  //----------------- small iron weapons -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingot", "cnrIngotIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrTAxeIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingot", "cnrIngotIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrKurkiIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingot", "cnrIngotIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSickleIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingot", "cnrIngotIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSpearIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingot", "cnrIngotIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrLtHammerIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingot", "cnrIngotIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrDaggerIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingot", "cnrIngotIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrKamaIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingot", "cnrIngotIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHandAxeIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingot", "cnrIngotIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrLtFlailIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingot", "cnrIngotIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScytheIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  //----------------- medium iron weapons -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingots", "cnrIngotIron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScimitarIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingots", "cnrIngotIron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMaceIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingots", "cnrIngotIron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMstarIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingots", "cnrIngotIron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHalberdIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingots", "cnrIngotIron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShSwordIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingots", "cnrIngotIron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBattleAxeIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingots", "cnrIngotIron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWarHammerIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  //----------------- large iron weapons -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingots", "cnrIngotIron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrRapierIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingots", "cnrIngotIron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHyFlailIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingots", "cnrIngotIron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrKatanaIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingots", "cnrIngotIron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrDireMaceIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingots", "cnrIngotIron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrLgSwordIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingots", "cnrIngotIron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrDoubleAxeIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingots", "cnrIngotIron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGreatAxeIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingots", "cnrIngotIron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBaSwordIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingots", "cnrIngotIron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrDSwordIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingots", "cnrIngotIron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGrSwordIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  CnrDecrementStackCount(OBJECT_SELF);
}

void InitIngotRecyclerShields()
{
  string sKeyToRecipe;

  //----------------- copper shields -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Copper Ingots", "cnrIngotCopp", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldSmalCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Copper Ingots", "cnrIngotCopp", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldBuckCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Copper Ingots", "cnrIngotCopp", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldStarCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Copper Ingots", "cnrIngotCopp", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldLargCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Copper Ingots", "cnrIngotCopp", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldHeatCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Copper Ingots", "cnrIngotCopp", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldKiteCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Copper Ingots", "cnrIngotCopp", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldTowrCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  //----------------- bronze shields -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingots", "cnrIngotBron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldSmalBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingots", "cnrIngotBron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldBuckBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingots", "cnrIngotBron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldStarBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingots", "cnrIngotBron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldLargBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingots", "cnrIngotBron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldHeatBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingots", "cnrIngotBron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldKiteBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingots", "cnrIngotBron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldTowrBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  //----------------- iron shields -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingots", "cnrIngotIron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldSmalIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingots", "cnrIngotIron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldBuckIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingots", "cnrIngotIron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldStarIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingots", "cnrIngotIron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldLargIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingots", "cnrIngotIron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldHeatIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingots", "cnrIngotIron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldKiteIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingots", "cnrIngotIron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldTowrIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  CnrDecrementStackCount(OBJECT_SELF);
} 

void InitIngotRecyclerArmors()
{
  string sKeyToRecipe;

  //----------------- bronze armors -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingots", "cnrIngotBron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChainShirtBro", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingots", "cnrIngotBron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScaleMailBro", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingots", "cnrIngotBron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChainMailBro", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingots", "cnrIngotBron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBandedMailBro", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingots", "cnrIngotBron", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSplintMailBro", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingots", "cnrIngotBron", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHalfPlateBro", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingots", "cnrIngotBron", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrFullPlateBro", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  //----------------- iron armors -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingots", "cnrIngotIron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChainShirtIro", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingots", "cnrIngotIron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScaleMailIro", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingots", "cnrIngotIron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChainMailIro", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingots", "cnrIngotIron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBandedMailIro", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingots", "cnrIngotIron", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSplintMailIro", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingots", "cnrIngotIron", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHalfPlateIro", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingots", "cnrIngotIron", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrFullPlateIro", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  //----------------- platinum armors -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Platinum Ingots", "cnrIngotPlat", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChainShirtPlat", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Platinum Ingots", "cnrIngotPlat", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScaleMailPlat", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Platinum Ingots", "cnrIngotPlat", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChainMailPlat", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Platinum Ingots", "cnrIngotPlat", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBandedMailPlat", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Platinum Ingots", "cnrIngotPlat", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSplintMailPlat", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Platinum Ingots", "cnrIngotPlat", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHalfPlatePlat", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Platinum Ingots", "cnrIngotPlat", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrFullPlatePlat", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  //----------------- adamantium armors -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Adamantium Ingots", "cnrIngotAdam", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChainShirtAdam", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Adamantium Ingots", "cnrIngotAdam", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScaleMailAdam", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Adamantium Ingots", "cnrIngotAdam", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChainMailAdam", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Adamantium Ingots", "cnrIngotAdam", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBandedMailAdam", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Adamantium Ingots", "cnrIngotAdam", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSplintMailAdam", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Adamantium Ingots", "cnrIngotAdam", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHalfPlateAdam", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Adamantium Ingots", "cnrIngotAdam", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrFullPlateAdam", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  //----------------- cobalt armors -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Cobalt Ingots", "cnrIngotCoba", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChainShirtCoba", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Cobalt Ingots", "cnrIngotCoba", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScaleMailCoba", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Cobalt Ingots", "cnrIngotCoba", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChainMailCoba", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Cobalt Ingots", "cnrIngotCoba", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBandedMailCoba", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Cobalt Ingots", "cnrIngotCoba", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSplintMailCoba", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Cobalt Ingots", "cnrIngotCoba", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHalfPlateCoba", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Cobalt Ingots", "cnrIngotCoba", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrFullPlateCoba", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  //----------------- mithril armors -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Mithril Ingots", "cnrIngotMith", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChainShirtMith", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Mithril Ingots", "cnrIngotMith", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScaleMailMith", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Mithril Ingots", "cnrIngotMith", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChainMailMith", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Mithril Ingots", "cnrIngotMith", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBandedMailMith", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Mithril Ingots", "cnrIngotMith", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSplintMailMith", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Mithril Ingots", "cnrIngotMith", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHalfPlateMith", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Mithril Ingots", "cnrIngotMith", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrFullPlateMith", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  CnrDecrementStackCount(OBJECT_SELF);
}

void InitIngotRecyclerHelms()
{
  string sKeyToRecipe;

  //----------------- bronze helms -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingots", "cnrIngotBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHelmPotBro", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingots", "cnrIngotBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHelmBasBro", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingots", "cnrIngotBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHelmExeBro", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingots", "cnrIngotBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHelmJutBro", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingots", "cnrIngotBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHelmSpikeBro", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Bronze Ingots", "cnrIngotBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHelmVisBro", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  //----------------- iron helms -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingots", "cnrIngotIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHelmPotIro", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingots", "cnrIngotIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHelmBasIro", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingots", "cnrIngotIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHelmExeIro", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingots", "cnrIngotIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHelmJutIro", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingots", "cnrIngotIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHelmSpikeIro", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Iron Ingots", "cnrIngotIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHelmVisIro", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  //----------------- platinum helms -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Platinum Ingots", "cnrIngotPlat", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHelmPotPlat", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Platinum Ingots", "cnrIngotPlat", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHelmBasPlat", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Platinum Ingots", "cnrIngotPlat", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHelmExePlat", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Platinum Ingots", "cnrIngotPlat", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHelmJutPlat", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Platinum Ingots", "cnrIngotPlat", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHelmSpikePlat", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Platinum Ingots", "cnrIngotPlat", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHelmVisPlat", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  //----------------- adamantium helms -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Adamantium Ingots", "cnrIngotAdam", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHelmPotAdam", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Adamantium Ingots", "cnrIngotAdam", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHelmBasAdam", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Adamantium Ingots", "cnrIngotAdam", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHelmExeAdam", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Adamantium Ingots", "cnrIngotAdam", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHelmJutAdam", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Adamantium Ingots", "cnrIngotAdam", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHelmSpikeAdam", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Adamantium Ingots", "cnrIngotAdam", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHelmVisAdam", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  //----------------- cobalt helms -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Cobalt Ingots", "cnrIngotCoba", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHelmPotCoba", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Cobalt Ingots", "cnrIngotCoba", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHelmBasCoba", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Cobalt Ingots", "cnrIngotCoba", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHelmExeCoba", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Cobalt Ingots", "cnrIngotCoba", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHelmJutCoba", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Cobalt Ingots", "cnrIngotCoba", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHelmSpikeCoba", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Cobalt Ingots", "cnrIngotCoba", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHelmVisCoba", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  //----------------- mithril helms -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Mithril Ingots", "cnrIngotMith", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHelmPotMith", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Mithril Ingots", "cnrIngotMith", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHelmBasMith", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Mithril Ingots", "cnrIngotMith", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHelmExeMith", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Mithril Ingots", "cnrIngotMith", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHelmJutMith", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Mithril Ingots", "cnrIngotMith", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHelmSpikeMith", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrIngotRecycler", "Mithril Ingots", "cnrIngotMith", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHelmVisMith", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 20, 20, 20, 20, 20, 0);

  CnrDecrementStackCount(OBJECT_SELF);
}

void main()
{
  PrintString("cnrIngotRecycler init");

  /////////////////////////////////////////////////////////
  // CNR recipes made by cnrIngotRecycler
  /////////////////////////////////////////////////////////
  CnrRecipeSetDevicePreCraftingScript("cnrIngotRecycler", "cnr_recycle_anim");
  CnrRecipeSetDeviceTradeskillType("cnrIngotRecycler", CNR_TRADESKILL_SMELTING);

  CnrIncrementStackCount(OBJECT_SELF);
  AssignCommand(OBJECT_SELF, InitIngotRecyclerMangled());

  CnrIncrementStackCount(OBJECT_SELF);
  AssignCommand(OBJECT_SELF, InitIngotRecyclerCopper());

  CnrIncrementStackCount(OBJECT_SELF);
  AssignCommand(OBJECT_SELF, InitIngotRecyclerBronze());

  CnrIncrementStackCount(OBJECT_SELF);
  AssignCommand(OBJECT_SELF, InitIngotRecyclerIron());

  CnrIncrementStackCount(OBJECT_SELF);
  AssignCommand(OBJECT_SELF, InitIngotRecyclerShields());

  CnrIncrementStackCount(OBJECT_SELF);
  AssignCommand(OBJECT_SELF, InitIngotRecyclerArmors());

  CnrIncrementStackCount(OBJECT_SELF);
  AssignCommand(OBJECT_SELF, InitIngotRecyclerHelms());
}
