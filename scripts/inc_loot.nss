// This header includes everything that is necessary for spawning loot on Arelith.

#include "inc_pc"
#include "inc_lootdist"
#include "inc_lootgen"
#include "inc_lootname"
#include "inc_lootresref"
#include "inc_database"
#include "inc_log"
#include "x3_inc_string"
#include "inc_language"

// ----- PUBLIC API ------

// TIER ONE describes basic adventuring gear.
// LOW    [tier1l]: // 1 -> 3, 1 +1 stat, 60%/40% +1/+2 skill
// MEDIUM [tier1m]: // 2 -> 4, 1 +1 stat, 50%/50% +1/+2 skill
// HIGH   [tier1h]: // 3 -> 4, 1 +1 stat, 40%/60% +1/+2 skill
const string LOOT_TEMPLATE_TIER_1 = "tier1";

// TIER TWO describes advanced adventuring gear.
// LOW    [tier2l]: // 3 -> 5, 2 +1 stats, 60%/40% +1/+2 skill
// MEDIUM [tier2m]: // 4 -> 6, 2 +1 stats, 50%/50% +1/+2 skill
// HIGH   [tier2h]: // 5 -> 6, 2 +1 stats, 40%/60% +1/+2 skill
const string LOOT_TEMPLATE_TIER_2 = "tier2";

// These constants describe contexts for which we're distributing loot.
const int LOOT_CONTEXT_MOB_LOW      = 0;
const int LOOT_CONTEXT_MOB_MEDIUM   = 1;
const int LOOT_CONTEXT_MOB_HIGH     = 2;
const int LOOT_CONTEXT_BOSS_LOW     = 3;
const int LOOT_CONTEXT_BOSS_MEDIUM  = 4;
const int LOOT_CONTEXT_BOSS_HIGH    = 5;
const int LOOT_CONTEXT_CHEST_LOW    = 6;
const int LOOT_CONTEXT_CHEST_MEDIUM = 7;
const int LOOT_CONTEXT_CHEST_HIGH   = 8;

// Called once by gs_m_load to initialise the loot system.
void InitialiseLootSystem();

// Called once for each time we wish to spawn loot.
// This function may create one loot item, many loot items, or no loot items.
void CreateLoot(int context, object container, object creature);

// Generates a loot item in container for creature's party.  If override is true, 
// bypasses % chances, always uses creature (not another of their party members)
// and always generates a tailored item.
void CreateProceduralLoot(string template, int context, object container, object creature, int override = FALSE);

// ----- INTERNAL API ------

// These postfixes combine to form the loot template name passed to inc_lootgen.
// e.g. tier1h, tier2l.
const string INTERNAL_POSTFIX_LOW = "l";
const string INTERNAL_POSTFIX_MEDIUM = "m";
const string INTERNAL_POSTFIX_HIGH = "h";

const string INTERNAL_LOOT_BUCKET_MOB = "mob";
const string INTERNAL_LOOT_BUCKET_BOSS = "boss";
const string INTERNAL_LOOT_BUCKET_CHEST = "chest";

string INTERNAL_LootBucketFromContext(int context);
string INTERNAL_GetPostfixFromContext(int context);

//
// -----
//

void InitialiseLootSystem()
{
    // Set up the resref arrays. We select one of these based on what we want to spawn.
    // These use the expanded base item set in inc_baseitem.
    AddBaseItemResRef(BASE_ITEM_AMULET, "nw_it_mneck020"); // copper necklace
    AddBaseItemResRef(BASE_ITEM_ARMOR, "mcloth012"); // not used by loot, but needed for crafting. 
    AddBaseItemResRef(BASE_ITEM_ARMOR_AC0, "mcloth012"); // Vesture
    AddBaseItemResRef(BASE_ITEM_ARMOR_AC0, "cloth023");
    AddBaseItemResRef(BASE_ITEM_ARMOR_AC0, "cloth029");
    AddBaseItemResRef(BASE_ITEM_ARMOR_AC1, "mcloth013");
    AddBaseItemResRef(BASE_ITEM_ARMOR_AC1, "cloth024");
    AddBaseItemResRef(BASE_ITEM_ARMOR_AC1, "cloth030");
    AddBaseItemResRef(BASE_ITEM_ARMOR_AC2, "maarcl029");
    AddBaseItemResRef(BASE_ITEM_ARMOR_AC2, "aarcl002");
    AddBaseItemResRef(BASE_ITEM_ARMOR_AC2, "cnrarmhiddb");
    AddBaseItemResRef(BASE_ITEM_ARMOR_AC2, "cnrarmleatdb");
    AddBaseItemResRef(BASE_ITEM_ARMOR_AC3, "maarcl030");
    AddBaseItemResRef(BASE_ITEM_ARMOR_AC3, "aarcl003");
    AddBaseItemResRef(BASE_ITEM_ARMOR_AC3, "cnrarmstudb");
    AddBaseItemResRef(BASE_ITEM_ARMOR_AC3, "maarcl033");
    AddBaseItemResRef(BASE_ITEM_ARMOR_AC4, "aarcl016");
    AddBaseItemResRef(BASE_ITEM_ARMOR_AC4, "aarcl026");
    AddBaseItemResRef(BASE_ITEM_ARMOR_AC4, "aarcl021");
    AddBaseItemResRef(BASE_ITEM_ARMOR_AC5, "aarcl017");
    AddBaseItemResRef(BASE_ITEM_ARMOR_AC5, "aarcl022");
    AddBaseItemResRef(BASE_ITEM_ARMOR_AC6, "aarcl015");
    AddBaseItemResRef(BASE_ITEM_ARMOR_AC6, "aarcl018");
    AddBaseItemResRef(BASE_ITEM_ARMOR_AC7, "aarcl014");
    AddBaseItemResRef(BASE_ITEM_ARMOR_AC7, "aarcl020");
    AddBaseItemResRef(BASE_ITEM_ARMOR_AC8, "aarcl008");
    AddBaseItemResRef(BASE_ITEM_ARMOR_AC8, "aarcl019");
    AddBaseItemResRef(BASE_ITEM_ARMOR_AC8, "aarcl029");
    //AddBaseItemResRef(BASE_ITEM_BASTARDSWORD, "nw_wswbs001");
    AddBaseItemResRef(BASE_ITEM_BATTLEAXE, "nw_waxbt001");
    AddBaseItemResRef(BASE_ITEM_BELT, "cnrbelt0"); // "Belt"
    AddBaseItemResRef(BASE_ITEM_BELT, "cnrbelt1");
    AddBaseItemResRef(BASE_ITEM_BELT, "cnrbelt2");  
    AddBaseItemResRef(BASE_ITEM_BELT, "cnrbelt3");
    AddBaseItemResRef(BASE_ITEM_BELT, "cnrbelt4");
    AddBaseItemResRef(BASE_ITEM_BOOTS, "cnrboots");
    AddBaseItemResRef(BASE_ITEM_BOOTS, "cnrbootsdeer");
    AddBaseItemResRef(BASE_ITEM_BOOTS, "cnrbootsdb");
    AddBaseItemResRef(BASE_ITEM_BRACER, "cnrbrac");
    AddBaseItemResRef(BASE_ITEM_BRACER, "orcishironbracer");
    AddBaseItemResRef(BASE_ITEM_CLOAK, "cnrcloak");
    AddBaseItemResRef(BASE_ITEM_CLOAK, "maarcl038");
    AddBaseItemResRef(BASE_ITEM_CLOAK, "maarcl035");
    AddBaseItemResRef(BASE_ITEM_CLOAK, "maarcl036");
    AddBaseItemResRef(BASE_ITEM_CLOAK, "cnrcloak5");
    AddBaseItemResRef(BASE_ITEM_CLUB, "nw_wblcl001");
    AddBaseItemResRef(BASE_ITEM_DART, "returningdart");
    AddBaseItemResRef(BASE_ITEM_DAGGER, "nw_wswdg001");
    AddBaseItemResRef(BASE_ITEM_DIREMACE, "nw_wdbma001");
    AddBaseItemResRef(BASE_ITEM_DOUBLEAXE, "nw_wdbax001");
    AddBaseItemResRef(BASE_ITEM_DWARVENWARAXE, "x2_wdwraxe001");
    AddBaseItemResRef(BASE_ITEM_GLOVES, "cnrglovecloth0");
    AddBaseItemResRef(BASE_ITEM_GLOVES, "cnrglovecloth");
    AddBaseItemResRef(BASE_ITEM_GLOVES, "cnrglovewool");
    AddBaseItemResRef(BASE_ITEM_GLOVES, "cnrglovesilk");
    AddBaseItemResRef(BASE_ITEM_GREATAXE, "nw_waxgr001");
    AddBaseItemResRef(BASE_ITEM_GREATSWORD, "nw_wswgs001");
    AddBaseItemResRef(BASE_ITEM_HALBERD, "nw_wplhb001");
    AddBaseItemResRef(BASE_ITEM_HANDAXE, "nw_waxhn001");
    AddBaseItemResRef(BASE_ITEM_HEAVYCROSSBOW, "nw_wbwxh001");
    AddBaseItemResRef(BASE_ITEM_HEAVYFLAIL, "nw_wblfh001");
    AddBaseItemResRef(BASE_ITEM_HELMET, "helmet");
    AddBaseItemResRef(BASE_ITEM_HELMET, "cnrhelm1");
    AddBaseItemResRef(BASE_ITEM_HELMET, "cnrhelm2");
    AddBaseItemResRef(BASE_ITEM_HELMET, "cnrhelm3");
    AddBaseItemResRef(BASE_ITEM_HELMET, "cnrhelm6");
    AddBaseItemResRef(BASE_ITEM_HELMET, "cnrhelm7");
    AddBaseItemResRef(BASE_ITEM_KAMA, "nw_wspka001");
    AddBaseItemResRef(BASE_ITEM_KATANA, "nw_wswka001");
    AddBaseItemResRef(BASE_ITEM_KUKRI, "nw_wspku001");
    AddBaseItemResRef(BASE_ITEM_LARGESHIELD, "ashlw007");
    AddBaseItemResRef(BASE_ITEM_LARGESHIELD, "ashlw008");
    AddBaseItemResRef(BASE_ITEM_LARGESHIELD, "ashlw009");
    AddBaseItemResRef(BASE_ITEM_LIGHTCROSSBOW, "nw_wbwxl001");
    AddBaseItemResRef(BASE_ITEM_LIGHTFLAIL, "nw_wblfl001");
    AddBaseItemResRef(BASE_ITEM_LIGHTHAMMER, "nw_wblhl001");
    AddBaseItemResRef(BASE_ITEM_LIGHTMACE, "nw_wblml001");
    AddBaseItemResRef(BASE_ITEM_LONGBOW, "nw_wbwln001");
    AddBaseItemResRef(BASE_ITEM_LONGSWORD, "nw_wswls001");
    AddBaseItemResRef(BASE_ITEM_MORNINGSTAR, "nw_wblms001");
    AddBaseItemResRef(BASE_ITEM_QUARTERSTAFF, "nw_wdbqs001");
    AddBaseItemResRef(BASE_ITEM_RAPIER, "nw_wswrp001");
    AddBaseItemResRef(BASE_ITEM_RING, "nw_it_mring021");
    //AddBaseItemResRef(BASE_ITEM_SCIMITAR, "nw_wswsc001");
    //AddBaseItemResRef(BASE_ITEM_SCYTHE, "nw_wplsc001");
    AddBaseItemResRef(BASE_ITEM_SHORTBOW, "nw_wbwsh001");
    AddBaseItemResRef(BASE_ITEM_SHORTSPEAR, "nw_wplss001");
    AddBaseItemResRef(BASE_ITEM_SHORTSWORD, "nw_wswss001");
    AddBaseItemResRef(BASE_ITEM_SHURIKEN, "returningshur");
    AddBaseItemResRef(BASE_ITEM_SICKLE, "nw_wspsc001");
    AddBaseItemResRef(BASE_ITEM_SLING, "nw_wbwsl001");
    AddBaseItemResRef(BASE_ITEM_SMALLSHIELD, "ashsw007");
    AddBaseItemResRef(BASE_ITEM_SMALLSHIELD, "ashsw008");
    AddBaseItemResRef(BASE_ITEM_SMALLSHIELD, "ashsw009");
    AddBaseItemResRef(BASE_ITEM_THROWINGAXE, "returningaxe");
    AddBaseItemResRef(BASE_ITEM_TOWERSHIELD, "ashto007");
    AddBaseItemResRef(BASE_ITEM_TOWERSHIELD, "ashto008");
    AddBaseItemResRef(BASE_ITEM_TOWERSHIELD, "ashto009");
    //AddBaseItemResRef(BASE_ITEM_TRIDENT, "nw_wpltr001");
    AddBaseItemResRef(BASE_ITEM_TWOBLADEDSWORD, "nw_wdbsw001");
    AddBaseItemResRef(BASE_ITEM_WARHAMMER, "nw_wblhw001");
    AddBaseItemResRef(BASE_ITEM_WHIP, "x2_it_wpwhip");

    // Tier 1 loot describes "basic adventuring gear".
    // The accelerated timeout on this type of loot is 2 days.
    SetLootCategoryTimeout(LOOT_TEMPLATE_TIER_1, 1 * 60 * 60 * 24 * 2); // 2 days

    // Tier 1 loot items will have a 0.25% chance of dropping from mobs.
    AddLootBucketChance(LOOT_TEMPLATE_TIER_1, INTERNAL_LOOT_BUCKET_MOB, 0.25f);
    AddLootBucketChance(LOOT_TEMPLATE_TIER_1, INTERNAL_LOOT_BUCKET_MOB, 0.25f);
    AddLootBucketChance(LOOT_TEMPLATE_TIER_1, INTERNAL_LOOT_BUCKET_MOB, 0.25f);

    // Tier 1 loot items will have a 30% chance of dropping from bosses.
    // For the first and second tier 1 drops per timeout, this chance is increased to 60%.
    AddLootBucketChance(LOOT_TEMPLATE_TIER_1, INTERNAL_LOOT_BUCKET_BOSS, 60.0f);
    AddLootBucketChance(LOOT_TEMPLATE_TIER_1, INTERNAL_LOOT_BUCKET_BOSS, 60.0f);
    AddLootBucketChance(LOOT_TEMPLATE_TIER_1, INTERNAL_LOOT_BUCKET_BOSS, 30.0f);

    // Tier 1 loot items will have a 25% chance of dropping from chests.
    // For the first and second tier 1 drops per timeout, this chance is increased to 50%.
    AddLootBucketChance(LOOT_TEMPLATE_TIER_1, INTERNAL_LOOT_BUCKET_CHEST, 50.0f);
    AddLootBucketChance(LOOT_TEMPLATE_TIER_1, INTERNAL_LOOT_BUCKET_CHEST, 50.0f);
    AddLootBucketChance(LOOT_TEMPLATE_TIER_1, INTERNAL_LOOT_BUCKET_CHEST, 25.0f);

    // Tier 2 loot describes "advanced adventuring gear".
    // The accelerated timeout on this type of loot is 1 week.
    SetLootCategoryTimeout(LOOT_TEMPLATE_TIER_2, 1 * 60 * 60 * 24 * 7); // 1 week

    // Tier 2 loot items will have a 0.05% chance of dropping from mobs.
    AddLootBucketChance(LOOT_TEMPLATE_TIER_2, INTERNAL_LOOT_BUCKET_MOB, 0.05f);
    AddLootBucketChance(LOOT_TEMPLATE_TIER_2, INTERNAL_LOOT_BUCKET_MOB, 0.05f);

    // Tier 2 loot items will have a 5% chance of dropping from bosses.
    // For the first tier 2 drop per timeout, this chance is increased to 10%.
    AddLootBucketChance(LOOT_TEMPLATE_TIER_2, INTERNAL_LOOT_BUCKET_BOSS, 5.0f);
    AddLootBucketChance(LOOT_TEMPLATE_TIER_2, INTERNAL_LOOT_BUCKET_BOSS, 10.0f);

    // Tier 2 loot items will have a 2.5% chance of dropping from chests.
    // For the first tier 2 drop per timeout, this chance is increased to 5%.
    AddLootBucketChance(LOOT_TEMPLATE_TIER_2, INTERNAL_LOOT_BUCKET_CHEST, 5.0f);
    AddLootBucketChance(LOOT_TEMPLATE_TIER_2, INTERNAL_LOOT_BUCKET_CHEST, 2.5f);
}

void CreateLoot(int context, object container, object creature)
{
    if (!GetIsObjectValid(creature) || !GetIsPC(creature))
    {
        return;
    }

    CreateProceduralLoot(LOOT_TEMPLATE_TIER_1, context, container, creature);
	
	// Only make more powerful items if we're in a Medium or High context loot situation.
	if (INTERNAL_GetPostfixFromContext(context) == INTERNAL_POSTFIX_MEDIUM || 
	    INTERNAL_GetPostfixFromContext(context) == INTERNAL_POSTFIX_HIGH)
	{
      CreateProceduralLoot(LOOT_TEMPLATE_TIER_2, context, container, creature);
	}  
}

void CreateProceduralLoot(string template, int context, object container, object creature, int override = FALSE)
{
    int bestChanceTimestamp = -1;
    int bestChanceDrops = 0;
    object bestChanceObject = OBJECT_INVALID;
    object bestChanceObjectHide = OBJECT_INVALID;

    object partyMember = GetFirstFactionMember(creature);

    while (GetIsObjectValid(partyMember))
    {
        object hide = gsPCGetCreatureHide(partyMember);
        struct LootDistributionHistory history = GetLootDistributionHistory(hide, template);

        if (bestChanceObject == OBJECT_INVALID || history.drops < bestChanceDrops ||
            (history.drops == bestChanceDrops && history.timestamp < bestChanceTimestamp))
        {
            bestChanceTimestamp = history.timestamp;
            bestChanceDrops = history.drops;
            bestChanceObject = partyMember;
            bestChanceObjectHide = hide;
        }

        partyMember = GetNextFactionMember(creature);
    }
	
	if (override) bestChanceObject = creature;

    string bucket = INTERNAL_LootBucketFromContext(context);
    struct LootDistrbutionResults results = GetLootDistributionResults(bestChanceObjectHide, template, bucket);

    if (results.createDrop || override)
    {
        object generatedLoot = OBJECT_INVALID;

        string resref = GetRandomResRefFromItemType(ITEM_TYPE_GEAR);
		
		switch (d3())
		{
		  case 1: 
		  {
		    if (GetIsObjectValid(creature) && (results.acceleratedDrop || override))
			{
			  // Tailored weapon.
			  string weaponArray = "LOOT_TAILORED_WPN";
			  IntArray_Clear(OBJECT_INVALID, weaponArray);
			  
			  // Only select from weapons that the user has weapon focus in. 
			  if (GetHasFeat(FEAT_WEAPON_FOCUS_CLUB, creature)) IntArray_PushBack(OBJECT_INVALID, weaponArray, BASE_ITEM_CLUB);
			  if (GetHasFeat(FEAT_WEAPON_FOCUS_DAGGER, creature)) IntArray_PushBack(OBJECT_INVALID, weaponArray, BASE_ITEM_DAGGER);
			  if (GetHasFeat(FEAT_WEAPON_FOCUS_DART, creature)) IntArray_PushBack(OBJECT_INVALID, weaponArray, BASE_ITEM_DART);
			  if (GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW, creature)) IntArray_PushBack(OBJECT_INVALID, weaponArray, BASE_ITEM_HEAVYCROSSBOW);
			  if (GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW, creature)) IntArray_PushBack(OBJECT_INVALID, weaponArray, BASE_ITEM_LIGHTCROSSBOW);
			  if (GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_MACE, creature)) IntArray_PushBack(OBJECT_INVALID, weaponArray, BASE_ITEM_LIGHTMACE);
			  if (GetHasFeat(FEAT_WEAPON_FOCUS_MORNING_STAR, creature)) IntArray_PushBack(OBJECT_INVALID, weaponArray, BASE_ITEM_MORNINGSTAR);
			  if (GetHasFeat(FEAT_WEAPON_FOCUS_STAFF, creature)) IntArray_PushBack(OBJECT_INVALID, weaponArray, BASE_ITEM_QUARTERSTAFF);
			  if (GetHasFeat(FEAT_WEAPON_FOCUS_SPEAR, creature)) IntArray_PushBack(OBJECT_INVALID, weaponArray, BASE_ITEM_SHORTSPEAR);
			  if (GetHasFeat(FEAT_WEAPON_FOCUS_SICKLE, creature)) IntArray_PushBack(OBJECT_INVALID, weaponArray, BASE_ITEM_SICKLE);
			  if (GetHasFeat(FEAT_WEAPON_FOCUS_SLING, creature)) IntArray_PushBack(OBJECT_INVALID, weaponArray, BASE_ITEM_SLING);
			  if (GetHasFeat(FEAT_WEAPON_FOCUS_LONGBOW, creature)) IntArray_PushBack(OBJECT_INVALID, weaponArray, BASE_ITEM_LONGBOW);
			  if (GetHasFeat(FEAT_WEAPON_FOCUS_SHORTBOW, creature)) IntArray_PushBack(OBJECT_INVALID, weaponArray, BASE_ITEM_SHORTBOW);
			  if (GetHasFeat(FEAT_WEAPON_FOCUS_SHORT_SWORD, creature)) IntArray_PushBack(OBJECT_INVALID, weaponArray, BASE_ITEM_SHORTSWORD);
			  if (GetHasFeat(FEAT_WEAPON_FOCUS_RAPIER, creature)) IntArray_PushBack(OBJECT_INVALID, weaponArray, BASE_ITEM_RAPIER);
			  if (GetHasFeat(FEAT_WEAPON_FOCUS_SCIMITAR, creature)) IntArray_PushBack(OBJECT_INVALID, weaponArray, BASE_ITEM_SCIMITAR);
			  if (GetHasFeat(FEAT_WEAPON_FOCUS_LONG_SWORD, creature)) IntArray_PushBack(OBJECT_INVALID, weaponArray, BASE_ITEM_LONGSWORD);
			  if (GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_SWORD, creature)) IntArray_PushBack(OBJECT_INVALID, weaponArray, BASE_ITEM_GREATSWORD);
			  if (GetHasFeat(FEAT_WEAPON_FOCUS_HAND_AXE, creature)) IntArray_PushBack(OBJECT_INVALID, weaponArray, BASE_ITEM_HANDAXE);
			  if (GetHasFeat(FEAT_WEAPON_FOCUS_THROWING_AXE, creature)) IntArray_PushBack(OBJECT_INVALID, weaponArray, BASE_ITEM_THROWINGAXE);
			  if (GetHasFeat(FEAT_WEAPON_FOCUS_BATTLE_AXE, creature)) IntArray_PushBack(OBJECT_INVALID, weaponArray, BASE_ITEM_BATTLEAXE);
			  if (GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_AXE, creature)) IntArray_PushBack(OBJECT_INVALID, weaponArray, BASE_ITEM_GREATAXE);
			  if (GetHasFeat(FEAT_WEAPON_FOCUS_HALBERD, creature)) IntArray_PushBack(OBJECT_INVALID, weaponArray, BASE_ITEM_HALBERD);
			  if (GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_HAMMER, creature)) IntArray_PushBack(OBJECT_INVALID, weaponArray, BASE_ITEM_LIGHTHAMMER);
			  if (GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_FLAIL, creature)) IntArray_PushBack(OBJECT_INVALID, weaponArray, BASE_ITEM_LIGHTFLAIL);
			  if (GetHasFeat(FEAT_WEAPON_FOCUS_WAR_HAMMER, creature)) IntArray_PushBack(OBJECT_INVALID, weaponArray, BASE_ITEM_WARHAMMER);
			  if (GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_FLAIL, creature)) IntArray_PushBack(OBJECT_INVALID, weaponArray, BASE_ITEM_HEAVYFLAIL);
			  if (GetHasFeat(FEAT_WEAPON_FOCUS_KAMA, creature)) IntArray_PushBack(OBJECT_INVALID, weaponArray, BASE_ITEM_KAMA);
			  if (GetHasFeat(FEAT_WEAPON_FOCUS_KUKRI, creature)) IntArray_PushBack(OBJECT_INVALID, weaponArray, BASE_ITEM_KUKRI);
			  if (GetHasFeat(FEAT_WEAPON_FOCUS_SHURIKEN, creature)) IntArray_PushBack(OBJECT_INVALID, weaponArray, BASE_ITEM_SHURIKEN);
			  if (GetHasFeat(FEAT_WEAPON_FOCUS_KATANA, creature)) IntArray_PushBack(OBJECT_INVALID, weaponArray, BASE_ITEM_KATANA);
			  if (GetHasFeat(FEAT_WEAPON_FOCUS_DIRE_MACE, creature)) IntArray_PushBack(OBJECT_INVALID, weaponArray, BASE_ITEM_DIREMACE);
			  if (GetHasFeat(FEAT_WEAPON_FOCUS_DOUBLE_AXE, creature)) IntArray_PushBack(OBJECT_INVALID, weaponArray, BASE_ITEM_DOUBLEAXE);
			  if (GetHasFeat(FEAT_WEAPON_FOCUS_TWO_BLADED_SWORD, creature)) IntArray_PushBack(OBJECT_INVALID, weaponArray, BASE_ITEM_TWOBLADEDSWORD);
			  if (GetHasFeat(FEAT_WEAPON_FOCUS_WHIP, creature)) IntArray_PushBack(OBJECT_INVALID, weaponArray, BASE_ITEM_WHIP);
			  /* Anemoi - some weapon types unavailable.
			  if (GetHasFeat(FEAT_WEAPON_FOCUS_BASTARD_SWORD, creature)) IntArray_PushBack(OBJECT_INVALID, weaponArray, BASE_ITEM_BASTARDSWORD);
			  if (GetHasFeat(FEAT_WEAPON_FOCUS_SCYTHE, creature)) IntArray_PushBack(OBJECT_INVALID, weaponArray, BASE_ITEM_SCYTHE);
			  if (GetHasFeat(FEAT_WEAPON_FOCUS_DWAXE, creature)) IntArray_PushBack(OBJECT_INVALID, weaponArray, BASE_ITEM_DWARVENWARAXE);
			  if (GetHasFeat(FEAT_WEAPON_FOCUS_TRIDENT, creature)) IntArray_PushBack(OBJECT_INVALID, weaponArray, BASE_ITEM_TRIDENT);
			  */
			  
              int count = IntArray_Size(OBJECT_INVALID, weaponArray);
              resref = (count > 0 ? GetRandomResRefFromBaseItemType(IntArray_At(OBJECT_INVALID, weaponArray, Random(count))) : GetRandomResRefFromItemType(ITEM_TYPE_WEAPON));
			}
			else
			{
		      resref = GetRandomResRefFromItemType(ITEM_TYPE_WEAPON); break;
			}  
		  }	
		  case 2: 
		  {
		    if (GetIsObjectValid(creature) && (results.acceleratedDrop || override))
			{
			  // Tailored armour. 
			  string armourArray = "LOOT_TAILORED_ARM";
			  IntArray_Clear(OBJECT_INVALID, armourArray);
			  
			  if (GetHasFeat(FEAT_ARMOR_PROFICIENCY_HEAVY, creature) && GetAbilityModifier(ABILITY_DEXTERITY, creature) <= 4)
			  {
			    IntArray_PushBack(OBJECT_INVALID, armourArray, BASE_ITEM_ARMOR_AC8);
			    IntArray_PushBack(OBJECT_INVALID, armourArray, BASE_ITEM_ARMOR_AC7);
			    IntArray_PushBack(OBJECT_INVALID, armourArray, BASE_ITEM_ARMOR_AC6);
			  }
			  else if (GetHasFeat(FEAT_ARMOR_PROFICIENCY_MEDIUM, creature) && GetAbilityModifier(ABILITY_DEXTERITY, creature) <= 6)
			  {
			    // Note - counting studded leather/hide in the Medium section due to its dex cap.
			    IntArray_PushBack(OBJECT_INVALID, armourArray, BASE_ITEM_ARMOR_AC5);
			    IntArray_PushBack(OBJECT_INVALID, armourArray, BASE_ITEM_ARMOR_AC4);
			    IntArray_PushBack(OBJECT_INVALID, armourArray, BASE_ITEM_ARMOR_AC3);
			  }
			  else if (GetHasFeat(FEAT_ARMOR_PROFICIENCY_LIGHT, creature) && GetAbilityModifier(ABILITY_DEXTERITY, creature) <= 9)
			  {
			    IntArray_PushBack(OBJECT_INVALID, armourArray, BASE_ITEM_ARMOR_AC2);
			    IntArray_PushBack(OBJECT_INVALID, armourArray, BASE_ITEM_ARMOR_AC1);
			  }
			  else
			  {
			    IntArray_PushBack(OBJECT_INVALID, armourArray, BASE_ITEM_ARMOR_AC0);
			  }
			  
			  if (GetHasFeat(FEAT_SHIELD_PROFICIENCY, creature))
			  {
			    IntArray_PushBack(OBJECT_INVALID, armourArray, BASE_ITEM_SMALLSHIELD);
			    IntArray_PushBack(OBJECT_INVALID, armourArray, BASE_ITEM_LARGESHIELD);
				
				if (GetCreatureSize(creature) >= CREATURE_SIZE_MEDIUM)
			      IntArray_PushBack(OBJECT_INVALID, armourArray, BASE_ITEM_TOWERSHIELD);
			  }
			  
			  IntArray_PushBack(OBJECT_INVALID, armourArray, BASE_ITEM_HELMET);
			  
              int count = IntArray_Size(OBJECT_INVALID, armourArray);
              resref = (count > 0 ? GetRandomResRefFromBaseItemType(IntArray_At(OBJECT_INVALID, armourArray, Random(count))) : GetRandomResRefFromItemType(ITEM_TYPE_ARMOUR));
			
			}
			else
			{
		      resref = GetRandomResRefFromItemType(ITEM_TYPE_ARMOUR); break;
			}  
		  }
		  default: break;
		}

        // To allow for different loot generation per loot difficulty (low, med, high), we actually
        // have three loot scripts per tier.
        // We want everything to be shared between the three difficulties *except* for the loot
        // generation script, so we add the postfix to the template name here.
        string postfixedTemplate = template + INTERNAL_GetPostfixFromContext(context);

        if (results.acceleratedDrop || override)
        {
            generatedLoot = GenerateTailoredLootInContainer(container, bestChanceObject, postfixedTemplate, resref);
        }
        else
        {
            generatedLoot = GenerateLootInContainer(container, postfixedTemplate, resref);
        }

        if (GetIsObjectValid(generatedLoot))
        {
            // Now apply the naming scheme.
            ApplyLootNamingScheme(generatedLoot, bestChanceObject);

            int itemValue = GetGoldPieceValue(generatedLoot);

            // Items have a certain percentage chance to be runic, depending on item value.
            // At 0 value, the percentage is 25%.
            // At 10000 value or above, the percentage is 2%.
            float percentageChance = (itemValue < 10000 ? (23.0 / 10000.0) * (10000.0 - itemValue) : 0.0f) + 2.0f;
            int runic = PercentageRandom(percentageChance);

            if (runic)
            {
                // Runic items have an equal percentage chance to apply to elf/dwarf/all races.
                int runicLang;
                int nRandom = Random(100)+1;
                if(nRandom <= 20)
                    runicLang = GS_LA_LANGUAGE_ELVEN;
                else if(nRandom <= 40)
                    runicLang = GS_LA_LANGUAGE_DRACONIC;
                else if(nRandom <= 55)
                    runicLang = GS_LA_LANGUAGE_ANIMAL;
                else if(nRandom <= 65)
                {
                    switch(Random(3))
                    {
                    case 0: runicLang = GS_LA_LANGUAGE_ABYSSAL; break;
                    case 1: runicLang = GS_LA_LANGUAGE_CELESTIAL; break;
                    case 2: runicLang = GS_LA_LANGUAGE_INFERNAL; break;
                    }

                }
                //Else, 35% of the time common//all races

                SetLocalInt(generatedLoot, "RUNIC", 1);               //+1 so we can tell common is different from dwarven race, BC
                SetLocalInt(generatedLoot, "RUNIC_LANGUAGE", runicLang+1);

                // Runic items have blue names because those are mystical! Like runic items!
                SetName(generatedLoot, StringToRGBString(GetName(generatedLoot), "339"));
            }

            string area = GetName(GetArea(bestChanceObject));
            string propertyCount = IntToString(GetLocalInt(generatedLoot, "GENERATED_LOOT_ITEM_PROPERTIES"));
            string itemValueAsStr = IntToString(itemValue);

            // Insert the data we need into the database ...
            SQLExecStatement("INSERT INTO " +
                "procedural_loot(gs_pc_data_id, area, template, bucket, tailored, runic, properties, value) " +
                "VALUES(?, ?, ?, ?, ?, ?, ?, ?)",
                gsPCGetPlayerID(bestChanceObject),
                area,
                postfixedTemplate,
                bucket,
                results.acceleratedDrop ? "1" : "0",
                runic ? "1" : "0",
                propertyCount,
                itemValueAsStr);

            // And log it out!
            Log("LOOT", "Creating loot " +
                "(" + postfixedTemplate + " in bucket " + bucket + ") " + (results.acceleratedDrop ? "(tailored) " : "") +
                "for " + GetName(bestChanceObject) + "'s party " +
                "in area " + area + " " +
                "with property count " + propertyCount + " " +
                "and value " + itemValueAsStr + ".");
        }
    }

    AcceptLootDistributionResults(bestChanceObjectHide, results);
}

string INTERNAL_LootBucketFromContext(int context)
{
    switch (context)
    {
        case LOOT_CONTEXT_MOB_LOW:
        case LOOT_CONTEXT_MOB_MEDIUM:
        case LOOT_CONTEXT_MOB_HIGH:
            return INTERNAL_LOOT_BUCKET_MOB;

        case LOOT_CONTEXT_BOSS_LOW:
        case LOOT_CONTEXT_BOSS_MEDIUM:
        case LOOT_CONTEXT_BOSS_HIGH:
            return INTERNAL_LOOT_BUCKET_BOSS;

        case LOOT_CONTEXT_CHEST_LOW:
        case LOOT_CONTEXT_CHEST_MEDIUM:
        case LOOT_CONTEXT_CHEST_HIGH:
            return INTERNAL_LOOT_BUCKET_CHEST;
    }

    return "";
}

string INTERNAL_GetPostfixFromContext(int context)
{
    switch (context)
    {
        case LOOT_CONTEXT_MOB_LOW:
        case LOOT_CONTEXT_BOSS_LOW:
        case LOOT_CONTEXT_CHEST_LOW:
            return INTERNAL_POSTFIX_LOW;

        case LOOT_CONTEXT_MOB_MEDIUM:
        case LOOT_CONTEXT_BOSS_MEDIUM:
        case LOOT_CONTEXT_CHEST_MEDIUM:
            return INTERNAL_POSTFIX_MEDIUM;

        case LOOT_CONTEXT_MOB_HIGH:
        case LOOT_CONTEXT_BOSS_HIGH:
        case LOOT_CONTEXT_CHEST_HIGH:
            return INTERNAL_POSTFIX_HIGH;
    }

    return "";
}
