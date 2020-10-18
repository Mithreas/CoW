// BACKGROUNDS library by Mithreas
#include "inc_common"
#include "inc_iprop"
#include "inc_subrace"
#include "inc_log"
#include "inc_effect"
#include "inc_generic"
#include "inc_item"
#include "inc_list"
#include "inc_factions"
const string BACKGROUNDS = "BACKGROUNDS"; // for tracing

const string BACKGROUND = "MI_BACKGROUND";
const int MI_BA_NONE     = 0;
const int MI_BA_IMPERIAL = 1;
const int MI_BA_DRANNIS  = 2;
const int MI_BA_ERENIA   = 3;
const int MI_BA_RENERRIN = 4;
const int MI_BA_SHADOW   = 5;
const int MI_BA_WARDEN   = 6;
const int MI_BA_FERNVALE = 7;
const int MI_BA_AIREVORN = 8;

const int MI_BA_NUM_BACKGROUNDS = 9;

//Gifts
const int GIFT_NONE = 0;
const int GIFT_OF_MIGHT = 1;
const int GIFT_OF_GRACE = 2;
const int GIFT_OF_ENDURANCE = 3;
const int GIFT_OF_LEARNING = 4;
const int GIFT_OF_INSIGHT = 5;
const int GIFT_OF_CONFIDENCE = 6;
const int GIFT_OF_WEALTH = 7;
const int GIFT_OF_TONGUES = 8;
const int GIFT_OF_HARDINESS = 9;
const int GIFT_OF_DARKNESS = 10;
const int GIFT_OF_HIDING = 11;
const int GIFT_OF_LIGHT = 12;
const int GIFT_OF_THE_GAB = 13;
const int GIFT_OF_THE_HUNTER = 14;
const int GIFT_OF_THE_SNEAK = 15;
const int GIFT_OF_FORTUNE = 16;
const int GIFT_OF_STARDOM = 17;
const int GIFT_OF_CRAFTSMANSHIP = 18;
const int GIFT_OF_SPELL_SHIELDING = 19;
const int GIFT_OF_GREENFINGERS = 20;
const int GIFT_OF_HUMILITY = 21;
const int GIFT_OF_HOLY = 22;
const int GIFT_OF_UNIQUE_FAVOR = 23;
const int GIFT_OF_SUBRACE = 24;
const int GIFT_OF_ENDURANCE_M = 25;
const int GIFT_OF_FORTUNE_M = 26;
const int GIFT_OF_DR_CLERGY = 27;
const int GIFT_OF_DR_MM     = 28;
const int GIFT_OF_LIGHTFINGERS = 29;
const int GIFT_OF_OG_MAGI = 30;
// Gift ECL Values
const float GIFT_OF_MIGHT_ECL = 1.0;
const float GIFT_OF_GRACE_ECL = 1.0;
const float GIFT_OF_ENDURANCE_ECL = 0.5;
const float GIFT_OF_ENDURANCE_ECL_M = 1.0;
const float GIFT_OF_LEARNING_ECL = 1.0;
const float GIFT_OF_INSIGHT_ECL = 1.0;
const float GIFT_OF_CONFIDENCE_ECL = 1.0;
const float GIFT_OF_WEALTH_ECL = 0.5;
const float GIFT_OF_TONGUES_ECL = 1.0;
const float GIFT_OF_HARDINESS_ECL = 0.5;
const float GIFT_OF_DARKNESS_ECL = 0.5;
const float GIFT_OF_HIDING_ECL = 0.5;
const float GIFT_OF_LIGHT_ECL = 0.0;
const float GIFT_OF_THE_GAB_ECL = 0.0;
const float GIFT_OF_THE_HUNTER_ECL = 0.0;
const float GIFT_OF_THE_SNEAK_ECL = 0.0;
const float GIFT_OF_FORTUNE_ECL = 1.0;
const float GIFT_OF_STARDOM_ECL = 0.0;
const float GIFT_OF_CRAFTSMANSHIP_ECL = 1.0;
const float GIFT_OF_SPELL_SHIELDING_ECL = 2.0;
const float GIFT_OF_GREENFINGERS_ECL = 0.5;
const float GIFT_OF_HUMILITY_ECL = -2.0;
const float GIFT_OF_HOLY_ECL = 0.5;
const float GIFT_OF_UNIQUE_FAVOR_ECL = 0.5;
const float GIFT_OF_SUBRACE_ECL = 0.0; // Determined via special handling in subrace script.
const float GIFT_OF_DR_CLERGY_ECL = 0.0;
const float GIFT_OF_DR_MM_ECL     = 0.0;
const float GIFT_OF_LIGHTFINGERS_ECL = 0.0;
const float GIFT_OF_OG_MAGI_ECL = 0.0;


// Gift Descriptions
const string GIFT_NONE_DESC = "No more gifts.";
const string GIFT_OF_MIGHT_DESC = "MAJOR Gift of Might (+2 STR, +1 ECL)";
const string GIFT_OF_GRACE_DESC = "MAJOR Gift of Grace (+2 DEX, +1 ECL)";
const string GIFT_OF_ENDURANCE_DESC = "Gift of Endurance (+2 CON, +0.5 ECL)"; //some of these will match major version
const string GIFT_OF_ENDURANCE_DESC_M = "MAJOR Gift of Endurance (+2 CON, +1 ECL)";
const string GIFT_OF_LEARNING_DESC = "MAJOR Gift of Learning (+2 INT, +1 ECL)";
const string GIFT_OF_INSIGHT_DESC = "MAJOR Gift of Insight (+2 WIS, +1 ECL)";
const string GIFT_OF_CONFIDENCE_DESC = "MAJOR Gift of Confidence (+2 CHA, +1 ECL)";
const string GIFT_OF_WEALTH_DESC = "MAJOR Gift of Wealth (+1,000 gold per month, +0.5 ECL)";
const string GIFT_OF_TONGUES_DESC = "Gift of Tongues (learn languages faster, +1 ECL)";
const string GIFT_OF_HARDINESS_DESC = "Gift of Hardiness (5% fire+cold+electrical+acid resistance, +0.5 ECL)";
const string GIFT_OF_DARKNESS_DESC = "Gift of Darkness (cast darkness 1/day, +0.5 ECL)";
const string GIFT_OF_HIDING_DESC = "Gift of Hiding (cast invis 1/day, +0.5 ECL)";
const string GIFT_OF_LIGHT_DESC = "Gift of Light (cast light 1/day, 0 ECL)";
const string GIFT_OF_THE_GAB_DESC = "Gift of the Gab (+6 Bluff, 0 ECL)";
const string GIFT_OF_THE_HUNTER_DESC = "Gift of the Hunter (+6 Spot, 0 ECL)";
const string GIFT_OF_THE_SNEAK_DESC = "Gift of the Sneak (+4 Hide, +4 MS, 0 ECL)";
const string GIFT_OF_FORTUNE_DESC_M = "MAJOR Gift of Fortune (+2 to all saves, +1 ECL)";
const string GIFT_OF_FORTUNE_DESC = "Gift of Fortune (+1 to all saves, +1 ECL)";  //some of these will match major version
const string GIFT_OF_STARDOM_DESC = "Gift of Stardom (+6 Perform, +0 ECL)";
const string GIFT_OF_CRAFTSMANSHIP_DESC = "Gift of Craftsmanship (+1 to all craft skill levels, +1 ECL)";
const string GIFT_OF_SPELL_SHIELDING_DESC = "Gift of Spell Shielding (32 SR, +2 ECL)";
const string GIFT_OF_GREENFINGERS_DESC = "Gift of Greenfingers (may tend to plants even if not a nature-worshipping druid or ranger, +0.5 ECL)";
const string GIFT_OF_HUMILITY_DESC = "Gift of Humility (-2 to all stats, -2 ECL)";
const string GIFT_OF_HOLY_DESC = "Gift of (Un)Holy (Character can consecrate altars without cleric, druid, wizard or sorcerer levels. Character must respect the race/alignment restrictions of the deity. +0.5 ECL)";
const string GIFT_OF_UNIQUE_FAVOR_DESC = "Gift of Unique Favor (Character always ignores deity's race restriction, +0.5 ECL)";
const string GIFT_OF_SUBRACE_DESC = "Subrace properties.  Abilities and ECL vary by subrace.";
const string GIFT_OF_DR_CLERGY_DESC = "Gift of Clergy (-2 DEX +2 WIS, +0.0 ECL)";
const string GIFT_OF_DR_MM_DESC = "Gift of Melee-Magthere (-2 CHA +2 CON, +0.0 ECL)";
const string GIFT_OF_LIGHTFINGERS_DESC = "Gift of Lightfingers (+6 Pickpocket, +0.0 ECL)";
const string GIFT_OF_OG_MAGI_DESC = "Gift of Magi (-2 STR, -2 DEX, +4 CHA, +0.0 ECL). Effectively removing Charisma penalty on Ogres.";

// Gift Names
const string GIFT_NONE_NAME = "None";
const string GIFT_OF_MIGHT_NAME = "Gift of Might";
const string GIFT_OF_GRACE_NAME = "Gift of Grace";
const string GIFT_OF_ENDURANCE_NAME = "Gift of Endurance";
const string GIFT_OF_ENDURANCE_NAME_M = "MAJOR Gift of Endurance";
const string GIFT_OF_LEARNING_NAME = "Gift of Learning";
const string GIFT_OF_INSIGHT_NAME = "Gift of Insight";
const string GIFT_OF_CONFIDENCE_NAME = "Gift of Confidence";
const string GIFT_OF_WEALTH_NAME = "Gift of Wealth";
const string GIFT_OF_TONGUES_NAME = "Gift of Tongues";
const string GIFT_OF_HARDINESS_NAME = "Gift of Hardiness";
const string GIFT_OF_DARKNESS_NAME = "Gift of Darkness";
const string GIFT_OF_HIDING_NAME = "Gift of Hiding";
const string GIFT_OF_LIGHT_NAME = "Gift of Light";
const string GIFT_OF_THE_GAB_NAME = "Gift of the Gab";
const string GIFT_OF_THE_HUNTER_NAME = "Gift of the Hunter";
const string GIFT_OF_THE_SNEAK_NAME = "Gift of the Sneak";
const string GIFT_OF_FORTUNE_NAME = "Gift of Fortune";
const string GIFT_OF_FORTUNE_NAME_M = "MAJOR Gift of Fortune";
const string GIFT_OF_STARDOM_NAME = "Gift of Stardom";
const string GIFT_OF_CRAFTSMANSHIP_NAME = "Gift of Craftsmanship";
const string GIFT_OF_SPELL_SHIELDING_NAME = "Gift of Spell Shielding";
const string GIFT_OF_GREENFINGERS_NAME = "Gift of Greenfingers";
const string GIFT_OF_HUMILITY_NAME = "Gift of Humility";
const string GIFT_OF_HOLY_NAME = "Gift of (Un)Holy";
const string GIFT_OF_UNIQUE_FAVOR_NAME = "Gift of Unique Favor";
const string GIFT_OF_SUBRACE_NAME = "Gift of Subrace";
const string GIFT_OF_DR_CLERGY_NAME = "Gift of Clergy";
const string GIFT_OF_DR_MM_NAME   = "Gift of Melee-Magthere";
const string GIFT_OF_LIGHTFINGERS_NAME   = "Gift of Lightfingers";
const string GIFT_OF_OG_MAGI_NAME = "Gift of Magi";
const string GIFT_INVALID_NAME = "Invalid Gift";

const int CASTE_WARRIOR = 0;
const int CASTE_PEASANT = 1;
const int CASTE_MERCHANT = 2;
const int CASTE_NOBILITY = 3;

const int LANDED_NOBLE_INSIDE = 0x20000000;
const int GRANTED_NOBLE_INSIDE = 0x10000000;
const int LANDED_NOBLE_OUTSIDE = 0x08000000;
const int GRANTED_NOBLE_OUTSIDE = 0x04000000;
const int BROKER_HIGH_NOBLE_INSIDE = 0x02000000;
const int BROKER_HIGH_NOBLE_OUTSIDE = 0x01000000;
const int BROKER_LES_NOBLE_INSIDE = 0x00800000;
const int BROKER_LES_NOBLE_OUTSIDE = 0x00400000;
const int NOBLE_AWARD = 0x01;
const int NOBLE_INSIDE = 0x32800008; //true for any noble working inside their settlement
//void main() {}

// Returns TRUE if oPC can take nBackground, FALSE otherwise.
int miBAGetIsBackgroundLegal(int nBackground, object oPC);
// Applies background abilities to the character. Note that backgrounds MUST
// be applied after subrace selection, i.e. characters must always have a
// skin object. If no background is selected the PC's current background will
// be used.
void miBAApplyBackground(object oPC, int nBackground = -1, int nFirstTime = TRUE);
// Gives gear to the PC based on their background (faction) and level within the faction.
void miBADoFactionGear(object oPC, int nBackground, int nLevel);
// Returns the craft skill bonus from the character's background.
int miBAGetCraftSkillBonus(object oPC, int nCraftSkill);
// Returns the name of the background.
string miBAGetBackgroundName(int nBackground);
// Returns the description of the background.
string miBAGetBackgroundDescription(int nBackground);
// Returns the caste (CASTE_*) associated with the specified background.
int miBAGetCasteByBackground(int nBackground);
// Returns the PC's background
int miBAGetBackground(object oPC);
// Reapplies gifts on level up if needed.
void miBAReapplyGifts(object oPC, int bReapplySpecialAbilities = TRUE);
// Increase oPC's ECL by fECL.  A negative value reduces the ECL.
void miBAIncreaseECL(object oPC, float fECL);
// Apply a gift's properties.  If bFirstTime is false, only creature
// hide properties will be applied.
void miBAApplyGift(object oPC, int nGift, int bFirstTime = TRUE, int bApplySpecialAbilities = TRUE);

// Adds the gift to the PC's list of gifts. If bReapplyBonuses is TRUE, character bonuses
// will be updated immediately.
void AddGift(object oPC, int nGift, int bReapplyBonuses = TRUE);
// Returns the gift at the specified index for the PC.
int GetGift(object oPC, int nIndex);
// Returns the description of the specified gift.
string GetGiftDescription(int nGift);
// Returns the ECL of the specified gift.
float GetGiftECL(int nGift);
// Returns the gift that corresponds to the specified gift description.
int GetGiftFromDescription(string sDescription);
// Returns the name of the specified gift.
string GetGiftName(int nGift);
// Returns TRUE if the PC has the specified gift.
int GetHasGift(object oPC, int nGift);
// Returns the number of gifts that the PC has.
int GetTotalGifts(object oPC);
// Removes the gift at the specified index for the PC. if bReapplyBonuses is TRUE, character
// bonuses will be updated immediately.
void RemoveGift(object oPC, int nIndex, int bReapplyBonuses = TRUE);
// Sets the gift at the specified index for the PC. if bReapplyBonuses is TRUE, character
// bonuses will be updated immediately.
void SetGift(object oPC, int nIndex, int nGift, int bReapplyBonuses = TRUE);
//Returns (uses bitwise):
//LANDED_NOBLE_INSIDE for landed nobles belonging to sNationId
//8 pc leader match sNationID
//4 for any pc leader outside of settlement
//16 for background noble
//LANDED_NOBLE_OUTSIDE for landed nobility outside of granting settlement
//GRANTED_NOBLE_INSIDE for granted nobility within settlement
//GRANTED_NOBLE_OUTSIDE for granted nobility outside settlement
//2 for epic reputation
//NOBLE_AWARD for noble award
int md_GetIsNoble(object oPC, string sNationID);
//Returns pirate rank name
string md_GetPirateNameFromRank(int nRank);

// Migrates gift data from the old system (i.e. string-based) to the new (i.e.
// int-based). There is no reason to ever call this function externally. It will be
// called automatically if necessary.
void _MigrateGiftData(object oPC);
// Updates the gift of subrace flag on the PC. Call whenever gifts are changed.
void _UpdateGiftOfSubraceFlag(object oPC);

string miBAGetBackgroundName(int nBackground)
{
  switch (nBackground)
  {
    case MI_BA_NONE:
      return "<c þ >[No background]</c>";
    case MI_BA_DRANNIS:
      return "Drannis";
    case MI_BA_ERENIA:
      return "Erenia";
    case MI_BA_RENERRIN:
      return "Renerrin";
    case MI_BA_WARDEN:
      return "Wardens";
    case MI_BA_SHADOW:
      return "Shadow";
    case MI_BA_FERNVALE:
      return "Fernvale";
    case MI_BA_AIREVORN:
      return "Airevorn";
  }

  return "";
}

int miBAGetCasteByBackground(int nBackground)
{
  switch (nBackground)
  {
    case MI_BA_NONE:
	case MI_BA_SHADOW:
      return CASTE_PEASANT;
    case MI_BA_DRANNIS:
    case MI_BA_ERENIA:
    case MI_BA_RENERRIN:
      return CASTE_NOBILITY;
    case MI_BA_WARDEN:
	case MI_BA_FERNVALE:
    case MI_BA_AIREVORN:
      return CASTE_WARRIOR;
  }

  return CASTE_WARRIOR;
}

string miBAGetBackgroundDescription(int nBackground)
{
  string sRetVal= "None";

  switch (nBackground)
  {
    case MI_BA_NONE:
      sRetVal = "No Background.";
      break;
	case MI_BA_IMPERIAL:
      sRetVal = "You are a retainer of the Imperial Throne, and have left your past allegiances behind to serve the God-Emperor directly.";
      break;	  
    case MI_BA_DRANNIS:
      sRetVal = "You are a retainer or scion of House Drannis, a house known for its martial might and trading acumen.";
      break;
    case MI_BA_ERENIA:
      sRetVal = "You are a retainer or scion of House Erenia, a house known for its religious devotion and skilled sailors.";
      break;
    case MI_BA_RENERRIN:
      sRetVal = "You are a retainer or scion of House Renerrin, a house known for its scholarship and political nous.";
      break;
	case MI_BA_SHADOW:
	  sRetVal = "You are a member of the mysterious organisation known to outsiders only as the Shadow, known to have a nebulous sort of authority over the Undercity.";
	  break;
    case MI_BA_WARDEN:
      sRetVal = "You are a Warden of Vyvian Village, one of those who protect the village and its people.";
      break;  
    case MI_BA_FERNVALE:
      sRetVal = "You are a resident of Fernvale Village, an ancient elven settlement.";
      break;  
    case MI_BA_AIREVORN:
	  sRetVal = "You are a resident of Airevorn, a small mountain village where Elves and Half-Elves live together in peace.";
	  break;
  }

  // If using castes (server config.2da)
  if (GetLocalInt(GetModule(), "USE_CASTES"))
  {
    int bCaste = miBAGetCasteByBackground(nBackground);
    switch (bCaste)
    {
      case CASTE_WARRIOR:
        sRetVal += " (Warrior caste)";
        break;
      case CASTE_MERCHANT:
        sRetVal += " (Merchant caste)";
        break;
      case CASTE_PEASANT:
        sRetVal += " (Peasant caste)";
        break;
      case CASTE_NOBILITY:
        sRetVal += " (Noble caste)";
        break;
    }
  }

  return sRetVal;
}

int miBAGetIsBackgroundLegal(int nBackground, object oPC)
{
  Trace(BACKGROUNDS, "Checking whether background " + IntToString(nBackground) +
   " is legal for " + GetName(oPC));

  switch (nBackground)
  {
    case MI_BA_NONE:
      return TRUE;
    case MI_BA_DRANNIS:
    case MI_BA_ERENIA:
    case MI_BA_RENERRIN:
	  return (GetRacialType(oPC) == RACIAL_TYPE_HUMAN);
	case MI_BA_WARDEN:
	  return (GetRacialType(oPC) == RACIAL_TYPE_HALFLING);
	case MI_BA_FERNVALE:
	  return (GetRacialType(oPC) == RACIAL_TYPE_ELF);
    case MI_BA_AIREVORN:
	  return (GetRacialType(oPC) == RACIAL_TYPE_HALFELF);
	case MI_BA_IMPERIAL:
    case MI_BA_SHADOW:
	  return FALSE;  // Can only be acquired during gameplay.
  }

  return FALSE;
}

void miBADoFactionGear(object oPC, int nBackground, int nLevel)
{
  switch (nLevel)
  {
   case 1:
   {
    switch (nBackground)
	{
	  case MI_BA_DRANNIS:	
        if (GetIsObjectValid(GetItemPossessedBy(oPC, "key_drannis"))) return;	  
        CreateItemOnObject("galeoutfit", oPC);
        CreateItemOnObject("key_drannis", oPC);
        CreateItemOnObject("drannis_dye_1", oPC);
        CreateItemOnObject("drannis_dye_2", oPC);
        CreateItemOnObject("drannis_dye_3", oPC);
        GiveGoldToCreature(oPC, 750);
	    break;
	  case MI_BA_ERENIA:  
        if (GetIsObjectValid(GetItemPossessedBy(oPC, "key_erenia"))) return;	       
        CreateItemOnObject("spiritoutfit", oPC);
        CreateItemOnObject("key_erenia", oPC);
        CreateItemOnObject("erenia_dye_1", oPC);
        CreateItemOnObject("erenia_dye_2", oPC);
        CreateItemOnObject("erenia_dye_3", oPC);
        GiveGoldToCreature(oPC, 750);
        break;
	  case MI_BA_RENERRIN:
        if (GetIsObjectValid(GetItemPossessedBy(oPC, "key_renerrin"))) return;	  
        CreateItemOnObject("voiceoutfit", oPC);
        CreateItemOnObject("key_renerrin", oPC);
        CreateItemOnObject("renerrin_dye_1", oPC);
        CreateItemOnObject("renerrin_dye_2", oPC);
        CreateItemOnObject("renerrin_dye_3", oPC);
        GiveGoldToCreature(oPC, 750);
		break;
      case MI_BA_WARDEN:   	  
        if (GetIsObjectValid(GetItemPossessedBy(oPC, "key_warden"))) return;	  
        CreateItemOnObject("nw_cloth001", oPC);
        CreateItemOnObject("key_warden", oPC);
        GiveGoldToCreature(oPC, 750);
		break;
      case MI_BA_SHADOW:   	  
        if (GetIsObjectValid(GetItemPossessedBy(oPC, "key_shadow"))) return;	  
        CreateItemOnObject("key_shadow", oPC);
        CreateItemOnObject("shadow_phil", oPC);
        GiveGoldToCreature(oPC, 250);
		break;
      case MI_BA_FERNVALE:   	  
        if (GetIsObjectValid(GetItemPossessedBy(oPC, "key_fernvale"))) return;	
        CreateItemOnObject("key_fernvale", oPC);  
        GiveGoldToCreature(oPC, 750);
		break;
      case MI_BA_AIREVORN:	  
        if (GetIsObjectValid(GetItemPossessedBy(oPC, "key_airevorn"))) return;	  
	    CreateItemOnObject("aireoutfit", oPC);
        CreateItemOnObject("key_airevorn", oPC);
        GiveGoldToCreature(oPC, 750);
		break;	    
	  default:
        break;		
	}
	break;
   }
   case 2:
   {
    switch (nBackground)
	{
	  case MI_BA_DRANNIS:	
        if (GetIsObjectValid(GetItemPossessedBy(oPC, "key_drannis_guar"))) return;	
		SendMessageToPC(oPC, "Congratulations, you have achieved Officer status.");
        CreateItemOnObject("key_drannis_guar", oPC);
        GiveGoldToCreature(oPC, 1000);
	    break;
	  case MI_BA_ERENIA:  
        if (GetIsObjectValid(GetItemPossessedBy(oPC, "key_erenia_guard"))) return;
		SendMessageToPC(oPC, "Congratulations, you have achieved Officer status.");
        CreateItemOnObject("key_erenia_guard", oPC);
        GiveGoldToCreature(oPC, 1000);
        break;
	  case MI_BA_RENERRIN:
        if (GetIsObjectValid(GetItemPossessedBy(oPC, "key_renerrin_gua"))) return;	
		SendMessageToPC(oPC, "Congratulations, you have achieved Officer status.");
        CreateItemOnObject("key_renerrin_gua", oPC);
        GiveGoldToCreature(oPC, 1000);
		break;
      case MI_BA_WARDEN:   	  
		break;
      case MI_BA_SHADOW:   	  
		break;
      case MI_BA_FERNVALE:   	  
		break;
      case MI_BA_AIREVORN:	  
		break;	    
	  default:
        break;		
	}
	break;
   }
   case 3:
   {
    switch (nBackground)
	{
	  case MI_BA_DRANNIS:	
        if (GetIsObjectValid(GetItemPossessedBy(oPC, "key_drannis_nobl"))) return;	
		SendMessageToPC(oPC, "Congratulations, you have achieved Noble status.");
        CreateItemOnObject("key_drannis_nobl", oPC);
        GiveGoldToCreature(oPC, 1000);
	    break;
	  case MI_BA_ERENIA:  
        if (GetIsObjectValid(GetItemPossessedBy(oPC, "key_erenia_noble"))) return;
		SendMessageToPC(oPC, "Congratulations, you have achieved Noble status.");
        CreateItemOnObject("key_erenia_noble", oPC);
        GiveGoldToCreature(oPC, 1000);
        break;
	  case MI_BA_RENERRIN:
        if (GetIsObjectValid(GetItemPossessedBy(oPC, "key_renerrin_nob"))) return;	
		SendMessageToPC(oPC, "Congratulations, you have achieved Noble status.");
        CreateItemOnObject("key_renerrin_nob", oPC);
        GiveGoldToCreature(oPC, 1000);
		break;
      case MI_BA_WARDEN:   	  
		break;
      case MI_BA_SHADOW:   	  
		break;
      case MI_BA_FERNVALE:   	  
		break;
      case MI_BA_AIREVORN:	  
		break;	    
	  default:
        break;		
	}
	break;
   }
  } 
}


void miBAApplyBackground(object oPC, int nBackground = -1, int nFirstTime = TRUE)
{
  Trace(BACKGROUNDS, "Applying background " + IntToString(nBackground) + " (" +
   miBAGetBackgroundName(nBackground) + ") to " + GetName(oPC));

  object oItem = gsPCGetCreatureHide(oPC);

  Trace(BACKGROUNDS, "Tried to get creature armour item: " + (GetIsObjectValid(oItem) ? "SUCCESS" : "FAILURE"));

  if (!GetIsObjectValid(oItem))
  {
    oItem = CreateItemOnObject(GS_SU_TEMPLATE_PROPERTY, oPC);

    if (GetIsObjectValid(oItem))
    {
      AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_CARMOUR));
    }
  }

  if (nBackground == -1)
  {
    nBackground = GetLocalInt(oItem, BACKGROUND);
  }
  else
  {
    SetLocalInt(oItem, BACKGROUND, nBackground);
  }

  Trace(BACKGROUNDS, "Got creature armour item: " + (GetIsObjectValid(oItem) ? "SUCCESS" : "FAILURE"));

  if (nBackground != MI_BA_NONE)
  {
    // This slightly weird logic ensures that we don't duplicate background text.
    int nSubRace = gsSUGetSubRaceByName(GetSubRace(oPC));
	
	if (nSubRace == GS_SU_NONE)
	{
      SetSubRace(oPC, gsSUGetRaceName(GetRacialType(oPC)) + " (" + miBAGetBackgroundName(nBackground) + ")");
	}
	else
	{	
      SetSubRace(oPC, gsSUGetNameBySubRace(nSubRace) + " (" + miBAGetBackgroundName(nBackground) + ")");
	}  
  }
  
  // Optional - apply bonuses based on background here.
  if (nFirstTime)
  {
    miBADoFactionGear(oPC, nBackground, 1);
  }
}

int miBAGetCraftSkillBonus(object oPC, int nCraftSkill)
{
  Trace(BACKGROUNDS, "Reading craft skill bonus for " + GetName(oPC));

  object oItem = gsPCGetCreatureHide(oPC);

  if (GetIsObjectValid(oItem))
  {
    int nBackground = GetLocalInt(oItem, BACKGROUND);

    switch (nBackground)
    {
	  // Optional - apply bonuses based on background here.
    }

    return 0;
  }
  else
  {
    Trace(BACKGROUNDS, "No creature skin found to read from!");
    return 0;
  }
}

int miBAGetBackground(object oPC)
{
  object oItem = gsPCGetCreatureHide(oPC);
  return GetLocalInt(oItem, BACKGROUND);
}

void miBAReapplyGifts(object oPC, int bReapplySpecialAbilities = TRUE)
{
  Trace(BACKGROUNDS, "Reapplying gifts to " + GetName(oPC));

  object oAbility  = GetItemPossessedBy(oPC, "GS_SU_ABILITY");
  int i;

  // Gifts have not been migrated. Do that now.
  if(!GetIsListValid(oAbility, "Gifts") && GetLocalString(oAbility, "MI_GIFT_1") != "")
  {
    _MigrateGiftData(oPC);
  }

  for(i = 0; i < GetListSize(oAbility, "Gifts"); i++)
  {
    miBAApplyGift(oPC, StringToInt(GetListElement(oAbility, "Gifts", i)), FALSE, bReapplySpecialAbilities);
  }
}

void miBAIncreaseECL(object oPC, float fECL)
{
  float fCurrentECL = GetLocalFloat(gsPCGetCreatureHide(oPC), "ECL");

  SetLocalFloat(gsPCGetCreatureHide(oPC), "ECL", fCurrentECL + fECL);
}

void miBAApplyGift(object oPC, int nGift, int bFirstTime = TRUE, int bApplySpecialAbilities = TRUE)
{
  // NOTE - Any gifts that add properties to the creature skin item need
  // to be reapplied on level up.  Hence bFirstTime.
  object oItem = gsPCGetCreatureHide(oPC);
  object oAbility  = GetItemPossessedBy(oPC, "GS_SU_ABILITY");

  if (! GetIsObjectValid(oAbility))
  {
    oAbility  = CreateItemOnObject(GS_SU_TEMPLATE_ABILITY,  oPC);
  }

  if(nGift == GIFT_NONE) return;

  switch(nGift)
  {
    case GIFT_OF_MIGHT:
      if(bFirstTime)
      {
        ModifyAbilityScore(oPC, ABILITY_STRENGTH, 2);
      }
      break;
    case GIFT_OF_GRACE:
      if(bFirstTime)
      {
        ModifyAbilityScore(oPC, ABILITY_DEXTERITY, 2);
      }
      break;
    case GIFT_OF_ENDURANCE:
    case GIFT_OF_ENDURANCE_M:
      if(bFirstTime)
      {
        ModifyAbilityScore(oPC, ABILITY_CONSTITUTION, 2);
      }
      break;
    case GIFT_OF_LEARNING:
      if(bFirstTime)
      {
        IncreasePCSkillPoints(oPC, GetHitDice(oPC) + 3);
        ModifyAbilityScore(oPC, ABILITY_INTELLIGENCE, 2);
      }
      break;
    case GIFT_OF_INSIGHT:
      if(bFirstTime)
      {
        ModifyAbilityScore(oPC, ABILITY_WISDOM, 2);
      }
      break;
    case GIFT_OF_CONFIDENCE:
      if(bFirstTime)
      {
        ModifyAbilityScore(oPC, ABILITY_CHARISMA, 2);
      }
      break;
    case GIFT_OF_WEALTH:
      if(bFirstTime)
      {
        GiveGoldToCreature(oPC, 1000);
        miDASetKeyedValue("gs_pc_data", gsPCGetPlayerID(oPC), "wealth", "1");
      }
      break;
    case GIFT_OF_TONGUES:
      if(bFirstTime)
      {
        SetLocalInt(oItem, "GIFT_OF_TONGUES", 1);
      }
      break;
    case GIFT_OF_HARDINESS:
      ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, 5)), oPC, 0.0, EFFECT_TAG_CHARACTER_BONUS);
      ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 5)), oPC, 0.0, EFFECT_TAG_CHARACTER_BONUS);
      ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 5)), oPC, 0.0, EFFECT_TAG_CHARACTER_BONUS);
      ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 5)), oPC, 0.0, EFFECT_TAG_CHARACTER_BONUS);
      break;
    case GIFT_OF_DARKNESS:
      if(bApplySpecialAbilities) AddItemProperty(DURATION_TYPE_PERMANENT,
        ItemPropertyCastSpell(IP_CONST_CASTSPELL_DARKNESS_3, IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY), oAbility);
      break;
    case GIFT_OF_HIDING:
      if (bApplySpecialAbilities) AddItemProperty(DURATION_TYPE_PERMANENT,
        ItemPropertyCastSpell(IP_CONST_CASTSPELL_INVISIBILITY_3, IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY), oAbility);
      break;
    case GIFT_OF_LIGHT:
      if (bApplySpecialAbilities) AddItemProperty(DURATION_TYPE_PERMANENT,
        ItemPropertyCastSpell(IP_CONST_CASTSPELL_LIGHT_1, IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY), oAbility);
      break;
    case GIFT_OF_THE_GAB:
      AddStackingItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySkillBonus(SKILL_BLUFF, 6), oItem);
      break;
    case GIFT_OF_THE_HUNTER:
      AddStackingItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySkillBonus(SKILL_SPOT, 6), oItem);
      break;
    case GIFT_OF_THE_SNEAK:
      AddStackingItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySkillBonus(SKILL_MOVE_SILENTLY, 4), oItem);
      AddStackingItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySkillBonus(SKILL_HIDE, 4), oItem);
      break;
    case GIFT_OF_FORTUNE:
      AddStackingItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 1), oItem);
      break;
    case GIFT_OF_FORTUNE_M:
      AddStackingItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 2), oItem);
      break;
    case GIFT_OF_STARDOM:
      AddStackingItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySkillBonus(SKILL_PERFORM, 6), oItem);
      break;
    case GIFT_OF_CRAFTSMANSHIP:
      if(bFirstTime)
      {
        SetLocalInt(oItem, "GIFT_CRAFTSMANSHIP", TRUE);
      }
      break;
    case GIFT_OF_GREENFINGERS:
      if(bFirstTime)
      {
        SetLocalInt(oItem, "GIFT_GREENFINGERS", TRUE);
      }
      break;
    case GIFT_OF_SPELL_SHIELDING:
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_32), oItem);
      break;
    case GIFT_OF_HUMILITY:
      if(bFirstTime)
      {
        ModifyAbilityScore(oPC, ABILITY_STRENGTH, -2);
        ModifyAbilityScore(oPC, ABILITY_DEXTERITY, -2);
        ModifyAbilityScore(oPC, ABILITY_CONSTITUTION, -2);
        ModifyAbilityScore(oPC, ABILITY_INTELLIGENCE, -2);
        ModifyAbilityScore(oPC, ABILITY_WISDOM, -2);
        ModifyAbilityScore(oPC, ABILITY_CHARISMA, -2);
      }
      break;
    case GIFT_OF_HOLY:
      if(bFirstTime)
      {
        SetLocalInt(oItem, "GIFT_OF_HOLY", 1);
      }
      break;
    case GIFT_OF_UNIQUE_FAVOR:
      if(bFirstTime)
      {
        SetLocalInt(oItem, "GIFT_OF_UFAVOR", 1);
      }
      break;
    case GIFT_OF_SUBRACE:
      if(bFirstTime)
      {
        // Some subrace properties need to be reapplied on level up,
        // but this is already handled through the level up code.
        int nSubRace = gsSUGetSubRaceByName(GetSubRace(oPC));
        int nLevel = GetHitDice(oPC);
        SetLocalInt(oItem, "GIFT_SUBRACE", TRUE);
        gsSUApplyProperty(oItem, nSubRace, nLevel);
        gsSUApplyAbility(oAbility, nSubRace, nLevel);
        // Handling ECL here since each subrace has a unique value that needs to be calculated.
        miBAIncreaseECL(oPC, IntToFloat(gsSUGetECL(nSubRace, 0)));
      }
      break;
    case GIFT_OF_DR_CLERGY:
        if(bFirstTime)
        {
            ModifyAbilityScore(oPC, ABILITY_DEXTERITY, -2);
            ModifyAbilityScore(oPC, ABILITY_WISDOM, 2);
        }
        break;
    case GIFT_OF_DR_MM:
        if(bFirstTime)
        {
            ModifyAbilityScore(oPC, ABILITY_CHARISMA, -2);
            ModifyAbilityScore(oPC, ABILITY_CONSTITUTION, 2);
        }
        break;
    case GIFT_OF_LIGHTFINGERS:
      AddStackingItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySkillBonus(SKILL_PICK_POCKET, 6), oItem);
      break;
    case GIFT_OF_OG_MAGI:
        if(bFirstTime)
        {
            ModifyAbilityScore(oPC, ABILITY_CHARISMA, 4);
            ModifyAbilityScore(oPC, ABILITY_STRENGTH, -2);
            ModifyAbilityScore(oPC, ABILITY_DEXTERITY, -2);
        }
        break;
    default:
      Error("miBAApplyGift()", "Attempted to apply invalid gift ID(" + IntToString(nGift) + ") to " + GetName(oPC) + ".");
      return;
  }
  
  if(bFirstTime)
  {
    miBAIncreaseECL(oPC, GetGiftECL(nGift));
  }
}

//::///////////////////////////////////////////////
//:: AddGift
//:://////////////////////////////////////////////
/*
    Adds the gift to the PC's list of gifts.
    If bReapplyBonuses is TRUE, character bonuses
    will be updated immediately.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 27, 2016
//:://////////////////////////////////////////////
void AddGift(object oPC, int nGift, int bReapplyBonuses = TRUE)
{
    object oAbility = GetItemPossessedBy(oPC, "GS_SU_ABILITY");

    AddListElement(oAbility, "Gifts", IntToString(nGift));
    _UpdateGiftOfSubraceFlag(oPC);

	miBAApplyGift(oPC, nGift, TRUE, TRUE);
}

//::///////////////////////////////////////////////
//:: GetGift
//:://////////////////////////////////////////////
/*
    Returns the gift at the specified index
    for the PC.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 27, 2016
//:://////////////////////////////////////////////
int GetGift(object oPC, int nIndex)
{
    object oAbility = GetItemPossessedBy(oPC, "GS_SU_ABILITY");

    return StringToInt(GetListElement(oAbility, "Gifts", nIndex));
}

//::///////////////////////////////////////////////
//:: GetGiftDescription
//:://////////////////////////////////////////////
/*
    Returns the description of the specified
    gift.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 9, 2016
//:://////////////////////////////////////////////
string GetGiftDescription(int nGift)
{
  switch(nGift)
  {
    case GIFT_NONE:               return GIFT_NONE_DESC;
    case GIFT_OF_MIGHT:           return GIFT_OF_MIGHT_DESC;
    case GIFT_OF_GRACE:           return GIFT_OF_GRACE_DESC;
    case GIFT_OF_ENDURANCE:       return GIFT_OF_ENDURANCE_DESC;
    case GIFT_OF_ENDURANCE_M:     return GIFT_OF_ENDURANCE_DESC_M;
    case GIFT_OF_LEARNING:        return GIFT_OF_LEARNING_DESC;
    case GIFT_OF_INSIGHT:         return GIFT_OF_INSIGHT_DESC;
    case GIFT_OF_CONFIDENCE:      return GIFT_OF_CONFIDENCE_DESC;
    case GIFT_OF_WEALTH:          return GIFT_OF_WEALTH_DESC;
    case GIFT_OF_TONGUES:         return GIFT_OF_TONGUES_DESC;
    case GIFT_OF_HARDINESS:       return GIFT_OF_HARDINESS_DESC;
    case GIFT_OF_DARKNESS:        return GIFT_OF_DARKNESS_DESC;
    case GIFT_OF_HIDING:          return GIFT_OF_HIDING_DESC;
    case GIFT_OF_LIGHT:           return GIFT_OF_LIGHT_DESC;
    case GIFT_OF_THE_GAB:         return GIFT_OF_THE_GAB_DESC;
    case GIFT_OF_THE_HUNTER:      return GIFT_OF_THE_HUNTER_DESC;
    case GIFT_OF_THE_SNEAK:       return GIFT_OF_THE_SNEAK_DESC;
    case GIFT_OF_FORTUNE:         return GIFT_OF_FORTUNE_DESC;
    case GIFT_OF_FORTUNE_M:       return GIFT_OF_FORTUNE_DESC_M;
    case GIFT_OF_STARDOM:         return GIFT_OF_STARDOM_DESC;
    case GIFT_OF_CRAFTSMANSHIP:   return GIFT_OF_CRAFTSMANSHIP_DESC;
    case GIFT_OF_SPELL_SHIELDING: return GIFT_OF_SPELL_SHIELDING_DESC;
    case GIFT_OF_GREENFINGERS:    return GIFT_OF_GREENFINGERS_DESC;
    case GIFT_OF_HUMILITY:        return GIFT_OF_HUMILITY_DESC;
    case GIFT_OF_HOLY:            return GIFT_OF_HOLY_DESC;
    case GIFT_OF_UNIQUE_FAVOR:    return GIFT_OF_UNIQUE_FAVOR_DESC;
    case GIFT_OF_SUBRACE:         return GIFT_OF_SUBRACE_DESC;
    case GIFT_OF_DR_CLERGY:       return GIFT_OF_DR_CLERGY_DESC;
    case GIFT_OF_DR_MM:           return GIFT_OF_DR_MM_DESC;
    case GIFT_OF_LIGHTFINGERS:    return GIFT_OF_LIGHTFINGERS_DESC;
    case GIFT_OF_OG_MAGI:         return GIFT_OF_OG_MAGI_DESC;
  }
  return "None";
}

//::///////////////////////////////////////////////
//:: GetGiftECL
//:://////////////////////////////////////////////
/*
    Returns the ECL of the specified gift.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 9, 2016
//:://////////////////////////////////////////////
float GetGiftECL(int nGift)
{
  switch(nGift)
  {
    case GIFT_OF_MIGHT:           return GIFT_OF_MIGHT_ECL;
    case GIFT_OF_GRACE:           return GIFT_OF_GRACE_ECL;
    case GIFT_OF_ENDURANCE:       return GIFT_OF_ENDURANCE_ECL;
    case GIFT_OF_ENDURANCE_M:     return GIFT_OF_ENDURANCE_ECL_M;
    case GIFT_OF_LEARNING:        return GIFT_OF_LEARNING_ECL;
    case GIFT_OF_INSIGHT:         return GIFT_OF_INSIGHT_ECL;
    case GIFT_OF_CONFIDENCE:      return GIFT_OF_CONFIDENCE_ECL;
    case GIFT_OF_WEALTH:          return GIFT_OF_WEALTH_ECL;
    case GIFT_OF_TONGUES:         return GIFT_OF_TONGUES_ECL;
    case GIFT_OF_HARDINESS:       return GIFT_OF_HARDINESS_ECL;
    case GIFT_OF_DARKNESS:        return GIFT_OF_DARKNESS_ECL;
    case GIFT_OF_HIDING:          return GIFT_OF_HIDING_ECL;
    case GIFT_OF_LIGHT:           return GIFT_OF_LIGHT_ECL;
    case GIFT_OF_THE_GAB:         return GIFT_OF_THE_GAB_ECL;
    case GIFT_OF_THE_HUNTER:      return GIFT_OF_THE_HUNTER_ECL;
    case GIFT_OF_THE_SNEAK:       return GIFT_OF_THE_SNEAK_ECL;
    case GIFT_OF_FORTUNE:
    case GIFT_OF_FORTUNE_M:       return GIFT_OF_FORTUNE_ECL;
    case GIFT_OF_STARDOM:         return GIFT_OF_STARDOM_ECL;
    case GIFT_OF_CRAFTSMANSHIP:   return GIFT_OF_CRAFTSMANSHIP_ECL;
    case GIFT_OF_SPELL_SHIELDING: return GIFT_OF_SPELL_SHIELDING_ECL;
    case GIFT_OF_GREENFINGERS:    return GIFT_OF_GREENFINGERS_ECL;
    case GIFT_OF_HUMILITY:        return GIFT_OF_HUMILITY_ECL;
    case GIFT_OF_HOLY:            return GIFT_OF_HOLY_ECL;
    case GIFT_OF_UNIQUE_FAVOR:    return GIFT_OF_UNIQUE_FAVOR_ECL;
    case GIFT_OF_SUBRACE:         return GIFT_OF_SUBRACE_ECL;
    case GIFT_OF_DR_CLERGY:       return GIFT_OF_DR_CLERGY_ECL;
    case GIFT_OF_DR_MM:           return GIFT_OF_DR_MM_ECL;
    case GIFT_OF_LIGHTFINGERS:    return GIFT_OF_LIGHTFINGERS_ECL;
    case GIFT_OF_OG_MAGI:         return GIFT_OF_OG_MAGI_ECL;
  }
  return 0.0;
}

//::///////////////////////////////////////////////
//:: GetGiftFromDescription
//:://////////////////////////////////////////////
/*
    Returns the gift that corresponds to the
    specified gift description.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 9, 2016
//:://////////////////////////////////////////////
int GetGiftFromDescription(string sDescription)
{
  if(FindSubString(sDescription, "Gift of Might") != -1)
    return GIFT_OF_MIGHT;
  if(FindSubString(sDescription, "Gift of Grace") != -1)
    return GIFT_OF_GRACE;
  if(FindSubString(sDescription, "MAJOR Gift of Endurance") != -1)
    return GIFT_OF_ENDURANCE_M;
  if(FindSubString(sDescription, "Gift of Endurance") != -1)
    return GIFT_OF_ENDURANCE;
  if(FindSubString(sDescription, "Gift of Learning") != -1)
    return GIFT_OF_LEARNING;
  if(FindSubString(sDescription, "Gift of Insight") != -1)
    return GIFT_OF_INSIGHT;
  if(FindSubString(sDescription, "Gift of Confidence") != -1)
    return GIFT_OF_CONFIDENCE;
  if(FindSubString(sDescription, "Gift of Wealth") != -1)
    return GIFT_OF_WEALTH;
  if(FindSubString(sDescription, "Gift of Tongues") != -1)
    return GIFT_OF_TONGUES;
  if(FindSubString(sDescription, "Gift of Hardiness") != -1)
    return GIFT_OF_HARDINESS;
  if(FindSubString(sDescription, "Gift of Darkness") != -1)
    return GIFT_OF_DARKNESS;
  if(FindSubString(sDescription, "Gift of Hiding") != -1)
    return GIFT_OF_HIDING;
  if(FindSubString(sDescription, "Gift of Lightfingers") != -1)
    return GIFT_OF_LIGHTFINGERS;
  if(FindSubString(sDescription, "Gift of Light") != -1)
    return GIFT_OF_LIGHT;
  if(FindSubString(sDescription, "Gift of the Gab") != -1)
    return GIFT_OF_THE_GAB;
  if(FindSubString(sDescription, "Gift of the Hunter") != -1)
    return GIFT_OF_THE_HUNTER;
  if(FindSubString(sDescription, "Gift of the Sneak") != -1)
    return GIFT_OF_THE_SNEAK;
  if(FindSubString(sDescription, "MAJOR Gift of Fortune") != -1)
    return GIFT_OF_FORTUNE_M;
  if(FindSubString(sDescription, "Gift of Fortune") != -1)
    return GIFT_OF_FORTUNE;
  if(FindSubString(sDescription, "Gift of Stardom") != -1)
    return GIFT_OF_STARDOM;
  if(FindSubString(sDescription, "Gift of Craftsmanship") != -1)
    return GIFT_OF_CRAFTSMANSHIP;
  if(FindSubString(sDescription, "Gift of Spell Shielding") != -1)
    return GIFT_OF_SPELL_SHIELDING;
  if(FindSubString(sDescription, "Gift of Greenfingers") != -1)
    return GIFT_OF_GREENFINGERS;
  if(FindSubString(sDescription, "Gift of Humility") != -1)
    return GIFT_OF_HUMILITY;
  if(FindSubString(sDescription, "Gift of (Un)Holy") != -1)
    return GIFT_OF_HOLY;
  if(FindSubString(sDescription, "Gift of Unique Favor") != -1)
    return GIFT_OF_UNIQUE_FAVOR;
  if(FindSubString(sDescription, "Subrace properties") != -1)
    return GIFT_OF_SUBRACE;
  if(FindSubString(sDescription, "Gift of Clergy") != -1)
    return GIFT_OF_DR_CLERGY;
  if(FindSubString(sDescription, "Gift of Melee-Magthere") != -1)
    return GIFT_OF_DR_MM;
  if(FindSubString(sDescription, "Gift of Magi") != -1)
    return GIFT_OF_OG_MAGI;
  return GIFT_NONE;
}

//::///////////////////////////////////////////////
//:: GetGiftName
//:://////////////////////////////////////////////
/*
    Returns the name of the specified gift.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 27, 2017
//:://////////////////////////////////////////////
string GetGiftName(int nGift)
{
  switch(nGift)
  {
    case GIFT_NONE:               return GIFT_NONE_NAME;
    case GIFT_OF_MIGHT:           return GIFT_OF_MIGHT_NAME;
    case GIFT_OF_GRACE:           return GIFT_OF_GRACE_NAME;
    case GIFT_OF_ENDURANCE:       return GIFT_OF_ENDURANCE_NAME;
    case GIFT_OF_ENDURANCE_M:     return GIFT_OF_ENDURANCE_NAME_M;
    case GIFT_OF_LEARNING:        return GIFT_OF_LEARNING_NAME;
    case GIFT_OF_INSIGHT:         return GIFT_OF_INSIGHT_NAME;
    case GIFT_OF_CONFIDENCE:      return GIFT_OF_CONFIDENCE_NAME;
    case GIFT_OF_WEALTH:          return GIFT_OF_WEALTH_NAME;
    case GIFT_OF_TONGUES:         return GIFT_OF_TONGUES_NAME;
    case GIFT_OF_HARDINESS:       return GIFT_OF_HARDINESS_NAME;
    case GIFT_OF_DARKNESS:        return GIFT_OF_DARKNESS_NAME;
    case GIFT_OF_HIDING:          return GIFT_OF_HIDING_NAME;
    case GIFT_OF_LIGHT:           return GIFT_OF_LIGHT_NAME;
    case GIFT_OF_THE_GAB:         return GIFT_OF_THE_GAB_NAME;
    case GIFT_OF_THE_HUNTER:      return GIFT_OF_THE_HUNTER_NAME;
    case GIFT_OF_THE_SNEAK:       return GIFT_OF_THE_SNEAK_NAME;
    case GIFT_OF_FORTUNE:         return GIFT_OF_FORTUNE_NAME;
    case GIFT_OF_FORTUNE_M:       return GIFT_OF_FORTUNE_NAME_M;
    case GIFT_OF_STARDOM:         return GIFT_OF_STARDOM_NAME;
    case GIFT_OF_CRAFTSMANSHIP:   return GIFT_OF_CRAFTSMANSHIP_NAME;
    case GIFT_OF_SPELL_SHIELDING: return GIFT_OF_SPELL_SHIELDING_NAME;
    case GIFT_OF_GREENFINGERS:    return GIFT_OF_GREENFINGERS_NAME;
    case GIFT_OF_HUMILITY:        return GIFT_OF_HUMILITY_NAME;
    case GIFT_OF_HOLY:            return GIFT_OF_HOLY_NAME;
    case GIFT_OF_UNIQUE_FAVOR:    return GIFT_OF_UNIQUE_FAVOR_NAME;
    case GIFT_OF_SUBRACE:         return GIFT_OF_SUBRACE_NAME;
    case GIFT_OF_DR_CLERGY:       return GIFT_OF_DR_CLERGY_NAME;
    case GIFT_OF_DR_MM:           return GIFT_OF_DR_MM_NAME;
    case GIFT_OF_LIGHTFINGERS:    return GIFT_OF_LIGHTFINGERS_NAME;
    case GIFT_OF_OG_MAGI:         return GIFT_OF_OG_MAGI_NAME;
  }
  return GIFT_INVALID_NAME;
}

//::///////////////////////////////////////////////
//:: GetHasGift
//:://////////////////////////////////////////////
/*
    Returns TRUE if the PC has the specified
    gift.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 9, 2016
//:://////////////////////////////////////////////
int GetHasGift(object oPC, int nGift)
{
  int i;
  object oAbility = GetItemPossessedBy(oPC, "GS_SU_ABILITY");

  for(i = 0; i <= GetListSize(oAbility, "Gifts"); i++)
  {
    if(StringToInt(GetListElement(oAbility, "Gifts", i)) == nGift)
        return TRUE;
  }
  return FALSE;
}

//::///////////////////////////////////////////////
//:: GetTotalGifts
//:://////////////////////////////////////////////
/*
    Returns the number of gifts that the PC has.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 27, 2017
//:://////////////////////////////////////////////
int GetTotalGifts(object oPC)
{
    object oAbility = GetItemPossessedBy(oPC, "GS_SU_ABILITY");

    return GetListSize(oAbility, "Gifts");
}

//::///////////////////////////////////////////////
//:: RemoveGift
//:://////////////////////////////////////////////
/*
    Removes the gift at the specified index for
    the PC. if bReapplyBonuses is TRUE, character
    bonuses will be updated immediately.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 27, 2016
//:://////////////////////////////////////////////
void RemoveGift(object oPC, int nIndex, int bReapplyBonuses = TRUE)
{
    object oAbility = GetItemPossessedBy(oPC, "GS_SU_ABILITY");

    RemoveListElement(oAbility, "Gifts", nIndex);
    _UpdateGiftOfSubraceFlag(oPC);

    if(bReapplyBonuses) ExecuteScript("exe_bonuses", oPC);
}

//::///////////////////////////////////////////////
//:: SetGift
//:://////////////////////////////////////////////
/*
    Sets the gift at the specified index for
    the PC. if bReapplyBonuses is TRUE, character
    bonuses will be updated immediately.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 27, 2016
//:://////////////////////////////////////////////
void SetGift(object oPC, int nIndex, int nGift, int bReapplyBonuses = TRUE)
{
    object oAbility = GetItemPossessedBy(oPC, "GS_SU_ABILITY");

    SetListElement(oAbility, "Gifts", nIndex, IntToString(nGift));
    _UpdateGiftOfSubraceFlag(oPC);

    if(bReapplyBonuses) ExecuteScript("exe_bonuses", oPC);
}

//::///////////////////////////////////////////////
//:: _MigrateGiftData
//:://////////////////////////////////////////////
/*
    Migrates gift data from the old system
    (i.e. string-based) to the new (i.e.
    int-based). There is no reason to ever
    call this function externally. It will be
    called automatically if necessary.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 9, 2016
//:://////////////////////////////////////////////
void _MigrateGiftData(object oPC)
{
  int nGift1;
  int nGift2;
  int nGift3;
  int nGift4;
  object oAbility = GetItemPossessedBy(oPC, "GS_SU_ABILITY");
  string sAbilityDesc = GetDescription(oAbility);
  string sGiftDesc1 = GetLocalString(oAbility, "MI_GIFT_1");
  string sGiftDesc2 = GetLocalString(oAbility, "MI_GIFT_2");
  string sGiftDesc3 = GetLocalString(oAbility, "MI_GIFT_3");
  string sGiftDesc4 = GetLocalString(oAbility, "MI_GIFT_4");

  if(sGiftDesc1 == "")
  {
    sGiftDesc1 = GetSubStringBetween(sAbilityDesc, "Gift 1:", "Gift 2:");
  }
  if(sGiftDesc2 == "")
  {
    sGiftDesc2 = GetSubStringBetween(sAbilityDesc, "Gift 2:", "Gift 3:");
  }
  if(sGiftDesc3 == "")
  {
    sGiftDesc3 = GetSubStringBetween(sAbilityDesc, "Gift 3:", "Gift 4:");
  }
  if(sGiftDesc3 == "")
  {
    // Extra check for characters made before addition of fourth gift.
    sGiftDesc3 = GetSubStringBetween(sAbilityDesc, "Gift 3:", "");
  }
  else if(sGiftDesc4 == "")
  {
    sGiftDesc4 = GetSubStringBetween(sAbilityDesc, "Gift 4:", "");
  }

  nGift1 = GetGiftFromDescription(sGiftDesc1);
  nGift2 = GetGiftFromDescription(sGiftDesc2);
  nGift3 = GetGiftFromDescription(sGiftDesc3);
  nGift4 = GetGiftFromDescription(sGiftDesc4);

  if(!nGift1 && !nGift2 && !nGift3 && !nGift4)
  {
    AddListElement(oAbility, "Gifts", IntToString(GIFT_NONE));
  }
  else
  {
    AddListElement(oAbility, "Gifts", IntToString(nGift1));
    AddListElement(oAbility, "Gifts", IntToString(nGift2));
    AddListElement(oAbility, "Gifts", IntToString(nGift3));
    AddListElement(oAbility, "Gifts", IntToString(nGift4));
  }
}

//::///////////////////////////////////////////////
//:: _UpdateGiftOfSubraceFlag
//:://////////////////////////////////////////////
/*
    Updates the gift of subrace flag on the PC.
    Call whenever gifts are changed.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On:July 27, 2016
//:://////////////////////////////////////////////
void _UpdateGiftOfSubraceFlag(object oPC)
{
    object oHide = gsPCGetCreatureHide(oPC);

    if(GetHasGift(oPC, GIFT_OF_SUBRACE))
    {
        SetLocalInt(oHide, "GIFT_SUBRACE", 1);
    }
    else
    {
        DeleteLocalInt(oHide, "GIFT_SUBRACE");
    }
}

int md_GetIsNoble(object oPC, string sNationID)
{
    //if check for landed noble changes here, checking in miczgethasauthority needs to change too, circular dependances suck
    SQLExecStatement("SELECT f.type,f.nation,m.is_OwnerRank FROM md_fa_members AS m INNER JOIN md_fa_factions AS f ON f.id = m.faction_id WHERE m.pc_id=? AND m.is_Noble=1", gsPCGetPlayerID(oPC));
    int nType;
    string sNation;
    int nNobleType;
    while(SQLFetch())
    {
        int nType = StringToInt(SQLGetData(1));
        string sNation = SQLGetData(2);
        string sOwner = SQLGetData(3);
        if(sNation == sNationID)
        {
            if(nType == FAC_NATION)
                nNobleType |= LANDED_NOBLE_INSIDE;
            else if(nType == FAC_BROKER)
            {
                if(sOwner == "1")
                    nNobleType |= BROKER_HIGH_NOBLE_INSIDE;
                else
                    nNobleType |= BROKER_LES_NOBLE_INSIDE;
            }
            else
                nNobleType |= GRANTED_NOBLE_INSIDE;
        }
        else
        {
            if(nType == FAC_NATION)
                nNobleType |= LANDED_NOBLE_OUTSIDE;
            else if(nType == FAC_BROKER)
            {
                if(sOwner == "1")
                    nNobleType |= BROKER_HIGH_NOBLE_OUTSIDE;
                else
                    nNobleType |= BROKER_LES_NOBLE_OUTSIDE;
            }
            else
                nNobleType |= GRANTED_NOBLE_OUTSIDE;

        }
    }

    if(miCZGetIsLeader(oPC, sNationID))
        nNobleType |= 0x08; //pc leader in selected nation
    else if(miCZGetIsLeader(oPC))
        nNobleType |= 0x04; //pc leader in any other nation

    if(miBAGetBackground(oPC) == MI_BA_IMPERIAL ||
	   miBAGetBackground(oPC) == MI_BA_DRANNIS ||
	   miBAGetBackground(oPC) == MI_BA_ERENIA ||
	   miBAGetBackground(oPC) == MI_BA_RENERRIN
	   )
        nNobleType |= 0x010;

    if(GetHasFeat(FEAT_EPIC_REPUTATION, oPC))
        nNobleType |= 0x02;
    if(GetLocalInt(gsPCGetCreatureHide(oPC), "NOBLE_AWARD"))
        nNobleType |= NOBLE_AWARD;

    return nNobleType;
}
//***************************************************************
string md_GetPirateNameFromRank(int nRank)
{
    string sName = "Pirate ";
    switch(nRank)
    {
    case 1: sName += "{Shipmate)"; break;
    case 2: sName += "{Veteran)"; break;
    case 3: sName += "(Swashbuckler)"; break;
    case 4: sName += "(Corsair)"; break;
    case 5: sName += "(Buccaneer)"; break;
    case 6: sName = "Dread Pirate"; break;
    default: sName += "(Greenhorn)";
    }

    return sName;
}
