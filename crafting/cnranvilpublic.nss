/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrAnvilPublic
//
//  Desc:  Recipe initialization.
//
//  Author: David Bobeck 15May03
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"

////////////////////////////////////////////////////////////////////////
// NOTE: This file has been formatted to be compatible with RecipeMaker.
////////////////////////////////////////////////////////////////////////

void ProcessMenuWeaponsCopp(string sMenuWeaponsCopp);
void ProcessMenuWeaponsBron(string sMenuWeaponsBron);
void ProcessMenuWeaponsIron(string sMenuWeaponsIron);

void main()
{
  PrintString("cnrAnvilPublic init");

  /////////////////////////////////////////////////////////
  // CNR recipes made by cnrAnvilPublic
  /////////////////////////////////////////////////////////

  CnrRecipeSetDevicePreCraftingScript("cnrAnvilPublic", "cnr_anvil_anim");
  CnrRecipeSetDeviceEquippedTool("cnrAnvilPublic", "cnrSmithsHammer", CNR_FLOAT_SMITH_HAMMER_BREAKAGE_PERCENTAGE);
  CnrRecipeSetDeviceTradeskillType("cnrAnvilPublic", CNR_TRADESKILL_WEAPON_CRAFTING);

  string sMenuWeaponsCopp = CnrRecipeAddSubMenu("cnrAnvilPublic", "Copper Weapons");
  string sMenuWeaponsBron = CnrRecipeAddSubMenu("cnrAnvilPublic", "Bronze Weapons");
  string sMenuWeaponsIron = CnrRecipeAddSubMenu("cnrAnvilPublic", "Iron Weapons");

  CnrIncrementStackCount(OBJECT_SELF);
  AssignCommand(OBJECT_SELF, ProcessMenuWeaponsCopp(sMenuWeaponsCopp));

  CnrIncrementStackCount(OBJECT_SELF);
  AssignCommand(OBJECT_SELF, ProcessMenuWeaponsBron(sMenuWeaponsBron));

  CnrIncrementStackCount(OBJECT_SELF);
  AssignCommand(OBJECT_SELF, ProcessMenuWeaponsIron(sMenuWeaponsIron));
}

void ProcessMenuWeaponsCopp(string sMenuWeaponsCopp)
{
  string sKeyToRecipe;

  string sMenuCoppAmmo = CnrRecipeAddSubMenu(sMenuWeaponsCopp, "Copper Ammo");
  string sMenuCoppAxes = CnrRecipeAddSubMenu(sMenuWeaponsCopp, "Copper Axes");
  string sMenuCoppBladed = CnrRecipeAddSubMenu(sMenuWeaponsCopp, "Copper Bladed");
  string sMenuCoppBlunts = CnrRecipeAddSubMenu(sMenuWeaponsCopp, "Copper Blunts");
  string sMenuCoppExotic = CnrRecipeAddSubMenu(sMenuWeaponsCopp, "Copper Exotic");
  string sMenuCoppDouble = CnrRecipeAddSubMenu(sMenuWeaponsCopp, "Copper Double-Sided");
  string sMenuCoppPolearms = CnrRecipeAddSubMenu(sMenuWeaponsCopp, "Copper Polearms");
  string sMenuCoppThrowing = CnrRecipeAddSubMenu(sMenuWeaponsCopp, "Copper Throwing");
  string sMenuCoppMage = CnrRecipeAddSubMenu(sMenuWeaponsCopp, "Copper Mage Specific");

  ///////////////// Copper Weapons ///////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCoppAmmo, "Copper Bullet", "cnrBulletCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCopp", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCoppThrowing, "Copper Dart", "cnrDartCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrFeatherRaven", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCopp", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCoppThrowing, "Copper Shuriken", "cnrShurikenCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCopp", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCoppThrowing, "Copper Throwing Axes", "cnrTAxeCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftHick", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCopp", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCoppExotic, "Copper Kukri", "cnrKukriCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCopp", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCoppExotic, "Copper Sickle", "cnrSickleCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftHick", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCopp", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCoppPolearms, "Copper Spear", "cnrSpearCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftHick", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCopp", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCoppBladed, "Copper Dagger", "cnrDaggerCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCopp", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCoppBlunts, "Light Copper Hammer", "cnrLtHammerCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftHick", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCopp", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCoppExotic, "Copper Kama", "cnrKamaCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftHick", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCopp", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCoppAxes, "Copper Handaxe", "cnrHandAxeCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftHick", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCopp", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCoppBlunts, "Light Copper Flail", "cnrLtFlailCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftHick", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCopp", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCoppPolearms, "Copper Scythe", "cnrScytheCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftHick", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCopp", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCoppBladed, "Copper Scimitar", "cnrScimitarCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldMedium", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCopp", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCoppBlunts, "Copper Mace", "cnrMaceCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldMedium", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftHick", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCopp", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCoppBlunts, "Copper Morningstar", "cnrMstarCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldMedium", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftHick", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCopp", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCoppPolearms, "Copper Halberd", "cnrHalberdCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldMedium", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftHick", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCopp", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCoppBladed, "Copper Shortsword", "cnrShSwordCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldMedium", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCopp", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCoppAxes, "Copper Battleaxe", "cnrBattleAxeCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldMedium", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftHick", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCopp", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCoppBlunts, "Copper Warhammer", "cnrWarHammerCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldMedium", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftHick", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCopp", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCoppBladed, "Copper Rapier", "cnrRapierCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCopp", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCoppBlunts, "Copper Heavy Flail", "cnrHyFlailCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftHick", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCopp", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCoppExotic, "Copper Katana", "cnrKatanaCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCopp", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCoppDouble, "Copper Dire Mace", "cnrDireMaceCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftHick", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCopp", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCoppBladed, "Copper Longsword", "cnrLgSwordCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCopp", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCoppAxes, "Copper Greataxe", "cnrGreatAxeCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftHick", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCopp", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCoppDouble, "Copper Double Axe", "cnrDoubleAxeCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftHick", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCopp", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCoppBladed, "Copper Bastard Sword", "cnrBaSwordCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCopp", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCoppDouble, "Copper Two-Bladed Sword", "cnrDSwordCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftHick", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCopp", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCoppBladed, "Copper Greatsword", "cnrGrSwordCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCopp", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  CnrDecrementStackCount(OBJECT_SELF);
}

void ProcessMenuWeaponsBron(string sMenuWeaponsBron)
{
  string sKeyToRecipe;

  string sMenuBronAmmo = CnrRecipeAddSubMenu(sMenuWeaponsBron, "Bronze Ammo");
  string sMenuBronAxes = CnrRecipeAddSubMenu(sMenuWeaponsBron, "Bronze Axes");
  string sMenuBronBladed = CnrRecipeAddSubMenu(sMenuWeaponsBron, "Bronze Bladed");
  string sMenuBronBlunts = CnrRecipeAddSubMenu(sMenuWeaponsBron, "Bronze Blunts");
  string sMenuBronExotic = CnrRecipeAddSubMenu(sMenuWeaponsBron, "Bronze Exotic");
  string sMenuBronDouble = CnrRecipeAddSubMenu(sMenuWeaponsBron, "Bronze Double-Sided");
  string sMenuBronPolearms = CnrRecipeAddSubMenu(sMenuWeaponsBron, "Bronze Polearms");
  string sMenuBronThrowing = CnrRecipeAddSubMenu(sMenuWeaponsBron, "Bronze Throwing");

  /////////////// Bronze Weapons ///////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronAmmo, "Bronze Bullet", "cnrBulletBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronThrowing, "Bronze Dart", "cnrDartBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrFeatherRaven", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronThrowing, "Bronze Shuriken", "cnrShurikenBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronThrowing, "Bronze Throwing Axes", "cnrTAxeBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronExotic, "Bronze Kukri", "cnrKukriBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronExotic, "Bronze Sickle", "cnrSickleBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronPolearms, "Bronze Spear", "cnrSpearBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronBladed, "Bronze Dagger", "cnrDaggerBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronBlunts, "Light Bronze Hammer", "cnrLtHammerBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronExotic, "Bronze Kama", "cnrKamaBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronAxes, "Bronze Handaxe", "cnrHandAxeBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronBlunts, "Light Bronze Flail", "cnrLtFlailBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronPolearms, "Bronze Scythe", "cnrScytheBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronBladed, "Bronze Scimitar", "cnrScimitarBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldMedium", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronBlunts, "Bronze Mace", "cnrMaceBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldMedium", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronBlunts, "Bronze Morningstar", "cnrMstarBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldMedium", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronPolearms, "Bronze Halberd", "cnrHalberdBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldMedium", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronBladed, "Bronze Shortsword", "cnrShSwordBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldMedium", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronAxes, "Bronze Battleaxe", "cnrBattleAxeBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldMedium", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronBlunts, "Bronze Warhammer", "cnrWarHammerBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldMedium", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronBladed, "Bronze Rapier", "cnrRapierBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronBlunts, "Bronze Heavy Flail", "cnrHyFlailBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronExotic, "Bronze Katana", "cnrKatanaBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronDouble, "Bronze Dire Mace", "cnrDireMaceBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronBladed, "Bronze Longsword", "cnrLgSwordBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronAxes, "Bronze Greataxe", "cnrGreatAxeBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronDouble, "Bronze Double Axe", "cnrDoubleAxeBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronBladed, "Bronze Bastard Sword", "cnrBaSwordBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronDouble, "Bronze Two-Bladed Sword", "cnrDSwordBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronBladed, "Bronze Greatsword", "cnrGrSwordBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  CnrDecrementStackCount(OBJECT_SELF);
}

void ProcessMenuWeaponsIron(string sMenuWeaponsIron)
{
  string sKeyToRecipe;

  string sMenuIronAmmo = CnrRecipeAddSubMenu(sMenuWeaponsIron, "Iron Ammo");
  string sMenuIronAxes = CnrRecipeAddSubMenu(sMenuWeaponsIron, "Iron Axes");
  string sMenuIronBladed = CnrRecipeAddSubMenu(sMenuWeaponsIron, "Iron Bladed");
  string sMenuIronBlunts = CnrRecipeAddSubMenu(sMenuWeaponsIron, "Iron Blunts");
  string sMenuIronExotic = CnrRecipeAddSubMenu(sMenuWeaponsIron, "Iron Exotic");
  string sMenuIronDouble = CnrRecipeAddSubMenu(sMenuWeaponsIron, "Iron Double-Sided");
  string sMenuIronPolearms = CnrRecipeAddSubMenu(sMenuWeaponsIron, "Iron Polearms");
  string sMenuIronThrowing = CnrRecipeAddSubMenu(sMenuWeaponsIron, "Iron Throwing");

  /////////////// Iron Weapons ///////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronAmmo, "Iron Bullet", "cnrBulletIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronThrowing, "Iron Dart", "cnrDartIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrFeatherRaven", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCopp", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronThrowing, "Iron Throwing Axes", "cnrTAxeIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftMahog", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronThrowing, "Iron Shuriken", "cnrShurikenIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronExotic, "Iron Kukri", "cnrKukriIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronExotic, "Iron Sickle", "cnrSickleIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftMahog", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronPolearms, "Iron Spear", "cnrSpearIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftMahog", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronBladed, "Iron Dagger", "cnrDaggerIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronBlunts, "Light Iron Hammer", "cnrLtHammerIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftMahog", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronExotic, "Iron Kama", "cnrKamaIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftMahog", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronAxes, "Iron Handaxe", "cnrHandAxeIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftMahog", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronBlunts, "Light Iron Flail", "cnrLtFlailIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftMahog", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronPolearms, "Iron Scythe", "cnrScytheIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftMahog", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronBladed, "Iron Scimitar", "cnrScimitarIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldMedium", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronBlunts, "Iron Mace", "cnrMaceIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldMedium", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftMahog", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronBlunts, "Iron Morningstar", "cnrMstarIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldMedium", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftMahog", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronPolearms, "Iron Halberd", "cnrHalberdIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldMedium", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftMahog", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronBladed, "Iron Shortsword", "cnrShSwordIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldMedium", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronAxes, "Iron Battleaxe", "cnrBattleAxeIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldMedium", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftMahog", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronBlunts, "Iron Warhammer", "cnrWarHammerIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldMedium", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftMahog", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronBladed, "Iron Rapier", "cnrRapierIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronBlunts, "Heavy Iron Flail", "cnrHyFlailIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftMahog", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronExotic, "Iron Katana", "cnrKatanaIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronDouble, "Iron Dire Mace", "cnrDireMaceIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftMahog", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronBladed, "Iron Longsword", "cnrLgSwordIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronAxes, "Iron Greataxe", "cnrGreatAxeIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftMahog", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronDouble, "Iron Double Axe", "cnrDoubleAxeIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftMahog", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronBladed, "Iron Bastard Sword", "cnrBaSwordIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronDouble, "Iron Two-Bladed Sword", "cnrDSwordIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftMahog", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronBladed, "Iron Greatsword", "cnrGrSwordIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  CnrDecrementStackCount(OBJECT_SELF);
}

