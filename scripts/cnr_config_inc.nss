/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_config_inc
//
//  Desc:  General CNR configuration
//
//  Author: David Bobeck 22Mar03
//
/////////////////////////////////////////////////////////

/////////////////////////////////////
// Float version of d100().
// Range is 0.1 to 100.0 (in tenths)
/////////////////////////////////////
float cnr_d100(int nDice);
/////////////////////////////////////
float cnr_d100(int nDice)
{
  float fAccum = 0.0;
  int n;
  for (n=0; n<nDice; n++)
  {
    fAccum += (IntToFloat(Random(1000)+1) / 10.0); // 0.1 - 100.0
  }
  return fAccum;
}

// You can now add you own tradeskills!
// Each trackable tradeskill must have a unique ID.
// The default trade names are assigned when
// "cnr_trade_init" executes. If you add a new tradeskill,
// you should add a unique ID for it here. ID's in the
// range of 0 thru 99 are reserved for future updates to
// CNR. Builders should assign ID's starting at 101.
const int CNR_TRADESKILL_NONE            = 0;
const int CNR_TRADESKILL_COOKING         = 1;
const int CNR_TRADESKILL_WEAPON_CRAFTING = 2;
const int CNR_TRADESKILL_ARMOR_CRAFTING  = 3;
const int CNR_TRADESKILL_CHEMISTRY       = 4;
const int CNR_TRADESKILL_INVESTING       = 5;
const int CNR_TRADESKILL_IMBUING         = 6;
const int CNR_TRADESKILL_WOOD_CRAFTING   = 7;
const int CNR_TRADESKILL_ENCHANTING      = 8;
const int CNR_TRADESKILL_JEWELRY         = 9;
const int CNR_TRADESKILL_TAILORING       = 10;

// Define your tradeskills here starting at 101. Also define
// the display text for you tradeskills per instructions in
// "cnr_trade_init"
//int CNR_TRADESKILL_TRASH_COLLECTING = 101;

// Resource gathering not tied to a specific tradeskill
// HARVESTING
// ORE MINING
// GEM MINING
// LUMBERJACKING

// ore mining
float CNR_FLOAT_ORE_MINING_FIND_SECOND_NUGGET_PERCENTAGE = 20.0;
float CNR_FLOAT_ORE_MINING_FIND_MYSTERY_MINERAL_PERCENTAGE = 0.0;
float CNR_FLOAT_ORE_MINING_PICKAXE_BREAKAGE_PERCENTAGE = 0.2;
float CNR_FLOAT_ORE_MINING_DEPOSIT_BREAKAGE_PERCENTAGE = 1.0;
float CNR_FLOAT_ORE_MINING_DEPOSIT_RESPAWN_TIME_SECS = 900.0; // 15 mins real time

// forge operation
int CNR_BOOL_FORGES_REQUIRE_COAL = TRUE;
float CNR_FLOAT_FORGE_COAL_BURN_TIME = 60.0f; // 1 min per nugget

// gem mining
float CNR_FLOAT_GEM_MINING_FIND_FIRST_MINERAL_PERCENTAGE = 20.0;
float CNR_FLOAT_GEM_MINING_FIND_SECOND_MINERAL_PERCENTAGE = 20.0;
float CNR_FLOAT_GEM_MINING_FIND_MYSTERY_MINERAL_PERCENTAGE = 5.0;
float CNR_FLOAT_GEM_MINING_CHISEL_BREAKAGE_PERCENTAGE = 0.2;
float CNR_FLOAT_GEM_MINING_DEPOSIT_BREAKAGE_PERCENTAGE = 1.0;
float CNR_FLOAT_GEM_MINING_DEPOSIT_RESPAWN_TIME_SECS = 900.0; // 15 mins real time

// misc mining deposit (dug with shovel, ie: clay & sand)
float CNR_FLOAT_MISC_MINING_DEPOSIT_CHANCE_OF_SUCCESS_PERCENTAGE = 40.0;
float CNR_FLOAT_MISC_MINING_DEPOSIT_SHOVEL_BREAKAGE_PERCENTAGE = 0.2;
float CNR_FLOAT_MISC_MINING_DEPOSIT_BREAKAGE_PERCENTAGE = 1.0;
float CNR_FLOAT_MISC_MINING_DEPOSIT_RESPAWN_TIME_SECS = 900.0; // 15 mins real time

// wood cutting
float CNR_FLOAT_WOOD_MINING_AXE_BREAKAGE_PERCENTAGE = 0.2;
float CNR_FLOAT_WOOD_MINING_TREE_BREAKAGE_PERCENTAGE = 1.0;
float CNR_FLOAT_WOOD_MINING_TREE_RESPAWN_TIME_SECS = 900.0; // 15 mins real time

// misc tool breakage
float CNR_FLOAT_SMITH_HAMMER_BREAKAGE_PERCENTAGE = 0.2;
float CNR_FLOAT_GEM_CRAFTERS_TOOLS_BREAKAGE_PERCENTAGE = 0.2;
float CNR_FLOAT_TINKERS_TOOLS_BREAKAGE_PERCENTAGE = 0.2;
float CNR_FLOAT_CARPS_TOOLS_BREAKAGE_PERCENTAGE = 0.2;
float CNR_FLOAT_SEWING_KIT_BREAKAGE_PERCENTAGE = 0.2;

// plant/fruit respawns
float CNR_FLOAT_DEFAULT_PLANT_RESPAWN_TIME_SECS = 300.0; // 5 mins real time

// If TRUE, when a plant's fruit is harvested, the entire plant will disappear
// and respawn at a later time. If FALSE, when a plant's fruit is harvested,
// the plant will remain and only the fruit will respawn.
int CNR_BOOL_RESPAWN_PLANTS_NOT_FRUIT = FALSE;

// game XP (not trade XP) awarded on recipe success
int CNR_BOOL_GAME_XP_SCALAR_ENABLED = TRUE;
float CNR_FLOAT_GAME_XP_SCALAR = 0.2 * GetLocalFloat(GetModule(), "XP_RATIO");

// To enable the crafting of HCR items, set this flag to TRUE.
// Note: At this time, only cure potions and animal meat are supported.
// Note: CNR does not provide the blueprints for HCR items.
int CNR_BOOL_ENABLE_HCR_ITEM_CRAFTING = FALSE;

// skinnable corpses
float CNR_FLOAT_SKINNABLE_CORPSE_FADE_TIME_SECS = 300.0; // 5 mins real time

// If you're a power builder/DM that uses APS/NWNX2 and would like to tweak recipes and
// reload them without restarting the mod, then you can set this flag to TRUE. CNR will
// create four related tables to hold the recipe data.
int CNR_BOOL_RECIPE_DATA_IS_PERSISTENT_IN_SQL_DATABASE = FALSE;

// If you prefer to bypass the long delays associated with recipe initialization,
// you can set this flag to FALSE. ** WARNING ** This flag should be used during
// module development only as deferred initialization will have a one-time impact
// on each device when it is first used. When your module goes public, it's best to
// have the recipes initialize at module load so that players don't get subjected to
// unnecessary lag during game play.
int CNR_BOOL_INIT_RECIPES_ON_MODULE_LOAD = TRUE;

// By default, spells defined as components in recipes will be decremented on both
// successful and failed crafting attempts. If, however, you would prefer that
// spells not be decremented on failed recipe attempts, then set this to TRUE.
int CNR_BOOL_DECREMENT_SPELLS_ON_SUCCESS_ONLY = FALSE;

// If you prefer that the top ten lists are not dispayed by by trade journal,
// then set this to TRUE.
int CNR_BOOL_HIDE_TRADE_JOURNALS_TOP_TEN_LISTS = FALSE;

// If you prefer that crafting convos only show satisfied recipes, then set this
// flag to TRUE. When TRUE, players will need to experiment to determine the
// components required to make a recipe. ** WARNING ** Filtering adds overhead.
// You will see some lag.
int CNR_BOOL_HIDE_UNSATISFIED_RECIPES_IN_CRAFTING_CONVOS = FALSE;

// If you prefer that crafting convos hide recipes that are statistically impossible
// for the PC to make, then set this to TRUE. ** WARNING ** Filtering adds overhead.
// You will see some lag.
int CNR_BOOL_HIDE_IMPOSSIBLE_RECIPES_IN_CRAFTING_CONVOS = TRUE;

