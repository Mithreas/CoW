/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrEnchantPool
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

  PrintString("cnrEnchantPool init");

  /////////////////////////////////////////////////////////
  //  CNR Crafting Device "cnrEnchantPool"
  /////////////////////////////////////////////////////////
  string sMenuWeaponsLtng = CnrRecipeAddSubMenu("cnrEnchantPool", "Weapons of Lightning");
  string sMenuWeaponsAcid = CnrRecipeAddSubMenu("cnrEnchantPool", "Weapons of Acid");
  string sMenuWeaponsFire = CnrRecipeAddSubMenu("cnrEnchantPool", "Weapons of Fire");

  string sMenuLtngAmmo = CnrRecipeAddSubMenu(sMenuWeaponsLtng, "Ammo");
  string sMenuLtngAxes = CnrRecipeAddSubMenu(sMenuWeaponsLtng, "Axes");
  string sMenuLtngBladed = CnrRecipeAddSubMenu(sMenuWeaponsLtng, "Bladed");
  string sMenuLtngBlunts = CnrRecipeAddSubMenu(sMenuWeaponsLtng, "Blunts");
  string sMenuLtngExotic = CnrRecipeAddSubMenu(sMenuWeaponsLtng, "Exotic");
  string sMenuLtngDouble = CnrRecipeAddSubMenu(sMenuWeaponsLtng, "Double-Sided");
  string sMenuLtngPolearms = CnrRecipeAddSubMenu(sMenuWeaponsLtng, "Polearms");
  string sMenuLtngThrowing = CnrRecipeAddSubMenu(sMenuWeaponsLtng, "Throwing");

  string sMenuAcidAmmo = CnrRecipeAddSubMenu(sMenuWeaponsAcid, "Ammo");
  string sMenuAcidAxes = CnrRecipeAddSubMenu(sMenuWeaponsAcid, "Axes");
  string sMenuAcidBladed = CnrRecipeAddSubMenu(sMenuWeaponsAcid, "Bladed");
  string sMenuAcidBlunts = CnrRecipeAddSubMenu(sMenuWeaponsAcid, "Blunts");
  string sMenuAcidExotic = CnrRecipeAddSubMenu(sMenuWeaponsAcid, "Exotic");
  string sMenuAcidDouble = CnrRecipeAddSubMenu(sMenuWeaponsAcid, "Double-Sided");
  string sMenuAcidPolearms = CnrRecipeAddSubMenu(sMenuWeaponsAcid, "Polearms");
  string sMenuAcidThrowing = CnrRecipeAddSubMenu(sMenuWeaponsAcid, "Throwing");

  string sMenuFireAmmo = CnrRecipeAddSubMenu(sMenuWeaponsFire, "Ammo");
  string sMenuFireAxes = CnrRecipeAddSubMenu(sMenuWeaponsFire, "Axes");
  string sMenuFireBladed = CnrRecipeAddSubMenu(sMenuWeaponsFire, "Bladed");
  string sMenuFireBlunts = CnrRecipeAddSubMenu(sMenuWeaponsFire, "Blunts");
  string sMenuFireExotic = CnrRecipeAddSubMenu(sMenuWeaponsFire, "Exotic");
  string sMenuFireDouble = CnrRecipeAddSubMenu(sMenuWeaponsFire, "Double-Sided");
  string sMenuFirePolearms = CnrRecipeAddSubMenu(sMenuWeaponsFire, "Polearms");
  string sMenuFireThrowing = CnrRecipeAddSubMenu(sMenuWeaponsFire, "Throwing");

  CnrRecipeSetDevicePreCraftingScript("cnrEnchantPool", "cnr_enchant_anim");
  //CnrRecipeSetDeviceInventoryTool("cnrEnchantPool", "cnrXXX");
  CnrRecipeSetDeviceTradeskillType("cnrEnchantPool", CNR_TRADESKILL_IMBUING);

  /////////////////////////////////////////////////////////
  //  CNR Crafting Device "cnrEnchantPool"
  /////////////////////////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLtngAmmo, "Lightning Bullet", "cnrBulletLigh", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBulletCopp", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLtngThrowing, "Lightning Dart", "cnrDartLigh", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrDartCopp", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLtngThrowing, "Lightning Shuriken", "cnrShurikenLigh", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShurikenCopp", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLtngThrowing, "Lightning Throwing Axe", "cnrTAxeLigh", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrTAxeCopp", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLtngBlunts, "Club of Lightning", "cnrClubLigh", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrClubWood", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLtngDouble, "Quarterstaff of Lightning", "cnrQStaffLigh", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrQStaffWood", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLtngExotic, "Kukri of Lightning", "cnrKukriLigh", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrKukriCopp", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLtngExotic, "Sickle of Lightning", "cnrSickleLigh", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSickleCopp", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLtngThrowing, "Spear of Lightning", "cnrSpearLtng", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSpearCopp", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLtngBlunts, "Light Hammer of Lightning", "cnrLtHammerLtng", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrLtHammerCopp", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLtngBladed, "Dagger of Lightning", "cnrDaggerLtng", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrDaggerCopp", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLtngExotic, "Kama of Ligntning", "cnrKamaLtng", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrKamaCopp", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLtngAxes, "Handaxe of Lightning", "cnrHandAxeLtng", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHandAxeCopp", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLtngBlunts, "Light Flail of Lightning", "cnrLtFlailLtng", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrLtFlailCopp", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLtngPolearms, "Scythe of Lightning", "cnrScytheLtng", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScytheCopp", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLtngBladed, "Scimitar of Lightning", "cnrScimitarLtng", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScimitarCopp", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  /////////////////////////////////////////////////////////
  //  CNR Crafting Device "cnrEnchantPool"
  /////////////////////////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLtngBlunts, "Mace of Lightning", "cnrMaceLtng", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMaceCopp", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLtngBlunts, "Morningstar of Lightning", "cnrMstarLtng", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMstarCopp", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLtngPolearms, "Halberd of Lightning", "cnrHalberdLtng", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHalberdCopp", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLtngBladed, "Shortsword of Lightning", "cnrShSwordLtng", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShSwordCopp", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLtngAxes, "Battleaxe of Lightning", "cnrBattleAxeLtng", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBattleAxeCopp", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLtngBlunts, "Warhammer of Lightning", "cnrWarHammerLtng", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWarHammerCopp", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  /////////////////////////////////////////////////////////
  //  CNR Crafting Device "cnrEnchantPool"
  /////////////////////////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLtngBladed, "Rapier of Lightning", "cnrRapierLtng", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrRapierCopp", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLtngBlunts, "Heavy Flail of Lightning", "cnrHyFlailLtng", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHyFlailCopp", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLtngExotic, "Katana of Lightning", "cnrKatanaLtng", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrKatanaCopp", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLtngDouble, "Dire Mace of Lightning", "cnrDireMaceLigh", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrDireMaceCopp", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLtngBladed, "Longsword of Lightning", "cnrLgSwordLtng", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrLgSwordCopp", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLtngDouble, "Double Axe of Lightning", "cnrDoubleAxeLigh", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrDoubleAxeCopp", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLtngAxes, "Greataxe of Lightning", "cnrGreatAxeLtng", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGreatAxeCopp", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLtngBladed, "Bastard Sword of Lightning", "cnrBaSwordLtng", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBaSwordCopp", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLtngDouble, "Two-Bladed Sword of Lightning", "cnrDSwordLigh", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrDSwordCopp", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLtngBladed, "Great Sword of Lightning", "cnrGrSwordLtng", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGrSwordCopp", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  /////////////////////////////////////////////////////////
  //  CNR Crafting Device "cnrEnchantPool"
  /////////////////////////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAcidAmmo, "Acid Bullet", "cnrBulletAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBulletBron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAcidThrowing, "Acid Dart", "cnrDartAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrDartBron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAcidThrowing, "Acid Shuriken", "cnrShurikenAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShurikenBron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAcidThrowing, "Acid Throwing Axe", "cnrTAxeAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrTAxeBron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAcidBlunts, "Club of Acid", "cnrClubAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrClubBron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAcidDouble, "Quarterstaff of Acid", "cnrQStaffAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrQStaffBron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAcidExotic, "Kukri of Acid", "cnrKukriAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrKukriBron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAcidExotic, "Sickle of Acid", "cnrSickleAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSickleBron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAcidThrowing, "Spear of Acid", "cnrSpearAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSpearBron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAcidBlunts, "Light Hammer of Acid", "cnrLtHammerAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrLtHammerBron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAcidBladed, "Dagger of Acid", "cnrDaggerAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrDaggerBron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAcidExotic, "Kama of Acid", "cnrKamaAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrKamaBron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAcidAxes, "Handaxe of Acid", "cnrHandAxeAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHandAxeBron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAcidBlunts, "Light Flail of Acid", "cnrLtFlailAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrLtFlailBron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAcidPolearms, "Scythe of Acid", "cnrScytheAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScytheBron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAcidBladed, "Scimitar of Acid", "cnrScimitarAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScimitarBron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  /////////////////////////////////////////////////////////
  //  CNR Crafting Device "cnrEnchantPool"
  /////////////////////////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAcidBlunts, "Mace of Acid", "cnrMaceAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMaceBron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAcidBlunts, "Morningstar of Acid", "cnrMstarAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMstarBron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAcidPolearms, "Halberd of Acid", "cnrHalberdAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHalberdBron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAcidBladed, "Shortsword of Acid", "cnrShSwordAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShSwordBron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAcidAxes, "Battleaxe of Acid", "cnrBattleAxeAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBattleAxeBron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAcidBlunts, "Warhammer of Acid", "cnrWarHammerAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWarHammerBron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAcidBladed, "Rapier of Acid", "cnrRapierAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrRapierBron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAcidBlunts, "Heavy Flail of Acid", "cnrHyFlailAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHyFlailBron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAcidExotic, "Katana of Acid", "cnrKatanaAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrKatanaBron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAcidDouble, "Dire Mace of Acid", "cnrDireMaceAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrDireMaceBron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAcidBladed, "Longsword of Acid", "cnrLgSwordAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrLgSwordBron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAcidDouble, "Double Axe of Acid", "cnrDoubleAxeAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrDoubleAxeBron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAcidAxes, "Greataxe of Acid", "cnrGreatAxeAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGreatAxeBron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAcidBladed, "Bastard Sword of Acid", "cnrBaSwordAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBaSwordBron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAcidDouble, "Two-Bladed Sword of Acid", "cnrDSwordAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrDSwordBron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAcidBladed, "Great Sword of Acid", "cnrGrSwordAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGrSwordBron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  /////////////////////////////////////////////////////////
  //  CNR Crafting Device "cnrEnchantPool"
  /////////////////////////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuFireAmmo, "Fire Bullet", "cnrBulletFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBulletIron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuFireThrowing, "Fire Dart", "cnrDartFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrDartIron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuFireThrowing, "Fire Shuriken", "cnrShurikenFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShurikenIron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuFireThrowing, "Fire Throwing Axe", "cnrTAxeFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrTAxeIron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuFireBlunts, "Club of Fire", "cnrClubFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrClubIron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuFireDouble, "Quarterstaff of Fire", "cnrQStaffFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrQStaffIron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuFireExotic, "Kukri of Fire", "cnrKukriFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrKukriIron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuFireExotic, "Sickle of Fire", "cnrSickleFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSickleIron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuFireThrowing, "Spear of Fire", "cnrSpearFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSpearIron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuFireBlunts, "Light Hammer of Fire", "cnrLtHammerFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrLtFlailIron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuFireBladed, "Dagger of Fire", "cnrDaggerFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrDaggerIron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuFireExotic, "Kama of Fire", "cnrKamaFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrKamaIron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuFireAxes, "Handaxe of Fire", "cnrHandAxeFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHandAxeIron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuFireBlunts, "Light Flail of Fire", "cnrLtFlailFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrLtFlailIron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuFirePolearms, "Scythe of Fire", "cnrScytheFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScytheIron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuFireBladed, "Scimitar of Fire", "cnrScimitarFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScimitarIron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  /////////////////////////////////////////////////////////
  //  CNR Crafting Device "cnrEnchantPool"
  /////////////////////////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuFireBlunts, "Mace of Fire", "cnrMaceFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMaceIron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuFireBlunts, "Morningstar of Fire", "cnrMstarFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMstarIron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuFirePolearms, "Halberd of Fire", "cnrHalberdFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHalberdIron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuFireBladed, "Shortsword of Fire", "cnrShSwordFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShSwordIron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuFireAxes, "Battleaxe of Fire", "cnrBattleAxeFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBattleAxeIron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuFireBlunts, "Warhammer of Fire", "cnrWarHammerFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWarHammerIron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuFireBladed, "Rapier of Fire", "cnrRapierFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrRapierIron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuFireBlunts, "Heavy Flail of Fire", "cnrHyFlailFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHyFlailIron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuFireExotic, "Katana of Fire", "cnrKatanaFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrKatanaIron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuFireDouble, "Dire Mace of Fire", "cnrDireMaceFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrDireMaceIron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuFireBladed, "Longsword of Fire", "cnrLgSwordFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrLgSwordIron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuFireDouble, "Double Axe of Fire", "cnrDoubleAxeFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrDoubleAxeIron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuFireAxes, "Greataxe of Fire", "cnrGreatAxeFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGreatAxeIron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuFireBladed, "Bastard Sword of Fire", "cnrBaSwordFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBaSwordSilv", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuFireDouble, "Two-Bladed Sword of Fire", "cnrDSwordFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrDSwordIron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuFireBladed, "Great Sword of Fire", "cnrGrSwordFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGrSwordIron", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

}
