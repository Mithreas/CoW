/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrBrazierSilv
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

  PrintString("cnrBrazierSilv init");

  /////////////////////////////////////////////////////////
  // CNR recipes made by cnrBrazierSilv
  /////////////////////////////////////////////////////////
  string sMenuSilvAmmo = CnrRecipeAddSubMenu("cnrBrazierSilv", "Ammo");
  string sMenuSilvAxes = CnrRecipeAddSubMenu("cnrBrazierSilv", "Axes");
  string sMenuSilvBladed = CnrRecipeAddSubMenu("cnrBrazierSilv", "Bladed");
  string sMenuSilvBlunts = CnrRecipeAddSubMenu("cnrBrazierSilv", "Blunts");
  string sMenuSilvExotic = CnrRecipeAddSubMenu("cnrBrazierSilv", "Exotic");
  string sMenuSilvDouble = CnrRecipeAddSubMenu("cnrBrazierSilv", "Double-Sided");
  string sMenuSilvPolearms = CnrRecipeAddSubMenu("cnrBrazierSilv", "Polearms");
  string sMenuSilvThrowing = CnrRecipeAddSubMenu("cnrBrazierSilv", "Throwing");

  CnrRecipeSetDevicePreCraftingScript("cnrBrazierSilv", "cnr_caldron_anim");
  //CnrRecipeSetDeviceEquippedTool("cnrBrazierSilv", "cnrSmithsHammer");
  CnrRecipeSetDeviceTradeskillType("cnrBrazierSilv", CNR_TRADESKILL_WEAPON_CRAFTING);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSilvAmmo, "Silver-Coated Bullet", "cnrBulletSilv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotSilv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHolyWater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBulletBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSilvThrowing, "Silver-Coated Dart", "cnrDartSilv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotSilv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHolyWater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrDartBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSilvThrowing, "Silver-Coated Shuriken", "cnrShurikenSilv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotSilv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHolyWater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShurikenBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSilvThrowing, "Silver-Coated Throwing Axes", "cnrTAxeSilv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotSilv", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHolyWater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrTAxeBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSilvExotic, "Silver-Coated Kukri", "cnrKukriSilv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotSilv", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHolyWater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrKukriBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSilvExotic, "Silver-Coated Sickle", "cnrSickleSilv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotSilv", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHolyWater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSickleBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSilvThrowing, "Silver-Coated Spear", "cnrSpearSilv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotSilv", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHolyWater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSpearBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSilvBlunts, "Light Silver-Coated Hammer", "cnrLtHammerSilv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotSilv", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHolyWater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrLtHammerBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSilvBladed, "Silver-Coated Dagger", "cnrDaggerSilv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotSilv", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHolyWater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrDaggerBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSilvExotic, "Silver-Coated Kama", "cnrKamaSilv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotSilv", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHolyWater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrKamaBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSilvAxes, "Silver-Coated Handaxe", "cnrHandAxeSilv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotSilv", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHolyWater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHandAxeBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSilvBlunts, "Light Silver-Coated Flail", "cnrLtFlailSilv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotSilv", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHolyWater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrLtFlailBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSilvPolearms, "Silver-Coated Scythe", "cnrScytheSilv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotSilv", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHolyWater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScytheBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSilvBladed, "Silver-Coated Scimitar", "cnrScimitarSilv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotSilv", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHolyWater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScimitarBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSilvBlunts, "Silver-Coated Mace", "cnrMaceSilv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotSilv", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHolyWater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMaceBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSilvBlunts, "Silver-Coated Morningstar", "cnrMstarSilv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotSilv", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHolyWater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMstarBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSilvPolearms, "Silver-Coated Halberd", "cnrHalberdSilv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotSilv", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHolyWater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHalberdBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSilvBladed, "Silver-Coated Shortsword", "cnrShSwordSilv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotSilv", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHolyWater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShSwordBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSilvAxes, "Silver-Coated Battleaxe", "cnrBattleAxeSilv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotSilv", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHolyWater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBattleAxeBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSilvBlunts, "Silver-Coated Warhammer", "cnrWarHammerSilv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotSilv", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHolyWater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWarHammerBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSilvBladed, "Silver-Coated Rapier", "cnrRapierSilv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotSilv", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHolyWater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrRapierBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSilvBlunts, "Heavy Silver-Coated Flail", "cnrHyFlailSilv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotSilv", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHolyWater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHyFlailBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSilvExotic, "Silver-Coated Katana", "cnrKatanaSilv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotSilv", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHolyWater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrKatanaBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSilvDouble, "Silver-Coated Dire Mace", "cnrDireMaceSilv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotSilv", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHolyWater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrDireMaceBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSilvBladed, "Silver-Coated Longsword", "cnrLgSwordSilv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotSilv", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHolyWater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrLgSwordBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSilvAxes, "Silver-Coated Greataxe", "cnrGreatAxeSilv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotSilv", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHolyWater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGreatAxeBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSilvDouble, "Silver-Coated Double Axe", "cnrDoubleAxeSilv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotSilv", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHolyWater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrDoubleAxeBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSilvBladed, "Silver-Coated Bastard Sword", "cnrBaSwordSilv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotSilv", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHolyWater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBaSwordBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSilvDouble, "Silver-Coated Two-Bladed Sword", "cnrDSwordSilv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotSilv", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHolyWater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrDSwordBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSilvBladed, "Silver-Coated Greatsword", "cnrGrSwordSilv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotSilv", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHolyWater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGrSwordBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

}
