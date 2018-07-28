/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrBrazierTita
//
//  Desc:  Recipe initialization.
//
//  Author: David Bobeck 15May03
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"

void main()
{
  string sKeyToRecipe;

  PrintString("cnrBrazierTita init");

  /////////////////////////////////////////////////////////
  // CNR recipes made by cnrBrazierTita
  /////////////////////////////////////////////////////////
  string sMenuTitaAmmo = CnrRecipeAddSubMenu("cnrBrazierTita", "Ammo");
  string sMenuTitaAxes = CnrRecipeAddSubMenu("cnrBrazierTita", "Axes");
  string sMenuTitaBladed = CnrRecipeAddSubMenu("cnrBrazierTita", "Bladed");
  string sMenuTitaBlunts = CnrRecipeAddSubMenu("cnrBrazierTita", "Blunts");
  string sMenuTitaExotic = CnrRecipeAddSubMenu("cnrBrazierTita", "Exotic");
  string sMenuTitaDouble = CnrRecipeAddSubMenu("cnrBrazierTita", "Double-Sided");
  string sMenuTitaPolearms = CnrRecipeAddSubMenu("cnrBrazierTita", "Polearms");
  string sMenuTitaThrowing = CnrRecipeAddSubMenu("cnrBrazierTita", "Throwing");

  CnrRecipeSetDevicePreCraftingScript("cnrBrazierTita", "cnr_caldron_anim");
  //CnrRecipeSetDeviceEquippedTool("cnrBrazierTita", "cnrSmithsHammer");
  CnrRecipeSetDeviceTradeskillType("cnrBrazierTita", CNR_TRADESKILL_WEAPON_CRAFTING);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTitaAmmo, "Titanium-Coated Bullet", "cnrBulletTita", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotTita", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEssPower", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBulletIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTitaThrowing, "Titanium-Tipped Dart", "cnrDartTita", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotTita", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEssPower", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrDartIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTitaThrowing, "Titanium-Tipped Shuriken", "cnrShurikenTita", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotTita", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEssPower", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShurikenIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTitaThrowing, "Titanium-Tipped Throwing Axes", "cnrTAxeTita", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotTita", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEssPower", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrTAxeIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTitaExotic, "Titanium-Tipped Kukri", "cnrKukriTita", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotTita", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEssPower", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrKukriIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTitaExotic, "Titanium-Tipped Sickle", "cnrSickleTita", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotTita", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEssPower", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSickleIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTitaThrowing, "Titanium-Tipped Spear", "cnrSpearTita", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotTita", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEssPower", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSpearIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTitaBlunts, "Light Titanium-Tipped Hammer", "cnrLtHammerTita", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotTita", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEssPower", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrLtHammerIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTitaBladed, "Titanium-Tipped Dagger", "cnrDaggerTita", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotTita", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEssPower", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrDaggerIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTitaExotic, "Titanium-Tipped Kama", "cnrKamaTita", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotTita", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEssPower", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrKamaIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTitaAxes, "Titanium-Tipped Handaxe", "cnrHandAxeTita", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotTita", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEssPower", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHandAxeIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTitaBlunts, "Light Titanium-Tipped Flail", "cnrLtFlailTita", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotTita", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEssPower", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrLtFlailIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTitaPolearms, "Titanium-Tipped Scythe", "cnrScytheTita", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotTita", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEssPower", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScytheIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTitaBladed, "Titanium-Tipped Scimitar", "cnrScimitarTita", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotTita", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEssPower", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScimitarIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTitaBlunts, "Titanium-Tipped Mace", "cnrMaceTita", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotTita", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEssPower", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMaceIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTitaBlunts, "Titanium-Tipped Morningstar", "cnrMstarTita", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotTita", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEssPower", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMstarIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTitaPolearms, "Titanium-Tipped Halberd", "cnrHalberdTita", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotTita", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEssPower", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHalberdIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTitaBladed, "Titanium-Tipped Shortsword", "cnrShSwordTita", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotTita", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEssPower", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShSwordIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTitaAxes, "Titanium-Tipped Battleaxe", "cnrBattleAxeTita", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotTita", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEssPower", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBattleAxeIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTitaBlunts, "Titanium-Tipped Warhammer", "cnrWarHammerTita", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotTita", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEssPower", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWarHammerIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTitaBladed, "Titanium-Tipped Rapier", "cnrRapierTita", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotTita", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEssPower", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrRapierIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTitaBlunts, "Heavy Titanium-Tipped Flail", "cnrHyFlailTita", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotTita", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEssPower", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHyFlailIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTitaExotic, "Titanium-Tipped Katana", "cnrKatanaTita", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotTita", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEssPower", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrKatanaIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTitaDouble, "Titanium-Tipped Dire Mace", "cnrDireMaceTita", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotTita", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEssPower", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrDireMaceIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 15);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 150, 150);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTitaBladed, "Titanium-Tipped Longsword", "cnrLgSwordTita", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotTita", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEssPower", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrLgSwordIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 15);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 150, 150);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTitaAxes, "Titanium-Tipped Greataxe", "cnrGreatAxeTita", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotTita", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEssPower", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGreatAxeIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 15);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 150, 150);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTitaDouble, "Titanium-Tipped Double Axe", "cnrDoubleAxeTita", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotTita", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEssPower", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrDoubleAxeIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 15);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 150, 150);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTitaBladed, "Titanium-Tipped Bastard Sword", "cnrBaSwordTita", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotTita", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEssPower", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBaSwordIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 15);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 150, 150);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTitaDouble, "Titanium-Tipped Two-Bladed Sword", "cnrDSwordTita", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotTita", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEssPower", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrDSwordIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 15);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 150, 150);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTitaBladed, "Titanium-Tipped Greatsword", "cnrGrSwordTita", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotTita", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEssPower", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGrSwordIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 15);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 150, 150);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

}
