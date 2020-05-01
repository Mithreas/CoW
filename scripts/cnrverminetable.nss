#include "cnr_recipe_utils"

void main()
{
  string sKeyToRecipe;

  PrintString("cnrverminetable init");

  /////////////////////////////////////////////////////////
  //  CNR Crafting Device "cnrTailorsTable"
  /////////////////////////////////////////////////////////

  string sMenuVermineHides = CnrRecipeAddSubMenu("cnrverminetable", "Hides and Leathers");
  string sMenuVermineClothing = CnrRecipeAddSubMenu("cnrverminetable", "Clothing");
  string sMenuVermineArmor = CnrRecipeAddSubMenu("cnrverminetable", "Armour");

  CnrRecipeSetDevicePreCraftingScript("cnrverminetable", "cnr_tailor_anim");
  CnrRecipeSetDeviceInventoryTool("cnrverminetable", "cnrSewingKit", CNR_FLOAT_SEWING_KIT_BREAKAGE_PERCENTAGE);
  CnrRecipeSetDeviceTradeskillType("cnrverminetable", CNR_TRADESKILL_TAILORING);
  CnrRecipeSetRecipeAbilityPercentages(IntToString(CNR_TRADESKILL_TAILORING), 0, 50, 0, 50, 0, 0);
  
  // Vermine hides and leathers.

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuVermineHides, "Vermine Fur", "cnrfurverm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSkinBat", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuVermineHides, "Vermine Fur", "cnrfurverm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrskinrat", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuVermineHides, "Cured Vermine Hide", "cnrhidecureverm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnracidtanning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSkinBat", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuVermineHides, "Cured Vermine Hide", "cnrhidecureverm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnracidtanning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrskinrat", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuVermineHides, "Vermine Leather", "cnrleathverm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroiltanning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSkinBat", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuVermineHides, "Vermine Leather", "cnrleathverm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroiltanning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrskinrat", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  
  // Vermine clothing
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuVermineClothing, "Vermine Belt", "cnrbeltverm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecureverm", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuVermineClothing, "Vermine-trimmed Gloves", "cnrgloveverm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrglovecloth", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrfurverm", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuVermineClothing, "Vermine Cloak", "cnrcloakverm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecureverm", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrfurverm", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuVermineClothing, "Vermine Boots", "cnrbootsverm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecureverm", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuVermineClothing, "Vermine-trimmed Clothing", "cnrclothesverm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrclothes", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrfurverm", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  
  // Vermine armour

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuVermineArmor, "Vermine Padded Armour", "cnrarmpadverm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth", 2, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrfurverm", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuVermineArmor, "Vermine Hide Armour", "cnrarmhidverm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhidecureverm", 3, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrfurverm", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuVermineArmor, "Vermine Leather Armour", "cnrarmleatverm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathverm", 3, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrfurverm", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuVermineArmor, "Vermine Studded Leather Armour", "cnrarmstuverm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleathverm", 3, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrfurverm", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstuds", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  
}  
  
  