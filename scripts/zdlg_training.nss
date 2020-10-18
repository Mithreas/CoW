// zdlg_training
//
// Used in the FL server to purchase feats for advancement.
//
// Concept: let players spend gold to buy feats.  The cost of each new
// feat depends on how many they have purchased and is adjusted for ECL.
// Pricing is based off xp - i.e. n/2*(n+1) * 1000.
//
// Added 18 Apr 18 - 
// - trainers can only train in class feats that they have.
// - trainers must be epic level to train epic feats.
// - trainers must have an arcane level to train spell feats. 
#include "inc_class"
#include "inc_customspells"
#include "inc_iprop"
#include "inc_pc"
#include "inc_skills"
#include "inc_spellsword"
#include "inc_totem"
#include "inc_warlock"
#include "inc_zdlg"
#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"
string LIST_1           = "T_LIST_1";
string LIST_1_IDS       = "T_LIST_1_IDS";
string LIST_2           = "T_LIST_2";
string LIST_2_IDS       = "T_LIST_2_IDS";
string LIST_3           = "T_LIST_3";
string LIST_3_IDS       = "T_LIST_3_IDS";
string LIST_4           = "T_LIST_4";
string LIST_4_IDS       = "T_LIST_4_IDS";
string LIST_5           = "T_LIST_5";
string LIST_5_IDS       = "T_LIST_5_IDS";

string CATEGORIES       = "T_LIST_CATEGORIES";
string CONFIRM          = "T_LIST_CONFIRM";

string CURR_LIST        = "T_CURRENT_LIST";
string CURR_SELECTION   = "T_CURRENT_SELECTION";
string CURR_LVL         = "T_CURRENT_LEVEL";
string CURR_COST        = "T_CURRENT_COST";

string PAGE_SELECT_FEAT = "T_PAGE_SEL_FEAT";
string PAGE_CONFIRM     = "T_PAGE_CONFIRM";

//For feat group pages
//-1 reserved for back.
const int GROUP_NUMBER_FE = -3; //favored enemy
const int GROUP_NUMBER_IC = -4; //improved crit
const int GROUP_NUMBER_SF = -5; //skill focus
const int GROUP_NUMBER_WF = -6; //weapon focus


const string LIST_FE       = "T_LIST_FE";
const string LIST_FE_IDS   = "T_LIST_FE_IDS";
const string LIST_IC       = "T_LIST_IC";
const string LIST_IC_IDS   = "T_LIST_IC_IDS";
const string LIST_SF       = "T_LIST_SF";
const string LIST_SF_IDS   = "T_LIST_SF_IDS";
const string LIST_WF       = "T_LIST_WF";
const string LIST_WF_IDS   = "T_LIST_WF_IDS";

const string LIST_SKILLS   = "T_LIST_SKILLS";
const string LIST_SK_ID    = "T_LIST_SK_ID";
const string LIST_SK_AMT   = "T_LIST_SK_AMT";

// Builds oPC's feat list for each of the sublists.
void init_feat_list (object oPC);
// Adds the specified feat to the current list and saves its
// index to feat number mapping in the corresponding IDs list.
// Won't add feats a PC already has.
// If nIgnore = TRUE, the pc doesn't have to meet the requirements for the feat.
// nClass sets the feat as a class feat to the specified class
void add_feat_to_list(object oPC, string sFriendlyName, int nFeat, int nIgnore = FALSE, int nClass = -1);
//Add a heading for groups of feats.
//nGroupNumber should be a GROUP_NUMBER_* (see the const int above for further notes)
//should be called before the feats within the group.
//Reset the current list once more after the feats within the group.
void add_group_list(string sName, int nGroupNumber, string sNewList);

void _AddSpellSlot(object oHide, string sVarName, int nClass, int nMaxSlotLevel)
{
  int nCurrentSlot  = GetLocalInt(oHide, sVarName) + 1;
  int nSpellSlot = nCurrentSlot;

  while (nSpellSlot > nMaxSlotLevel)
  {
    nSpellSlot -= nMaxSlotLevel;
  }

  AddItemProperty(DURATION_TYPE_PERMANENT,
                  ItemPropertyBonusLevelSpell(nClass, nSpellSlot),
                  oHide);

  SetLocalInt(oHide, sVarName, nCurrentSlot);
}

string _SkillName(int nSkill)
{
  switch(nSkill)
  {
  case SKILL_ANIMAL_EMPATHY: return "Animal Empathy";
  case SKILL_APPRAISE: return "Appraise";
  case SKILL_BLUFF: return "Bluff";
  case SKILL_CONCENTRATION: return "Concentration";
  case SKILL_CRAFT_TRAP: return "Craft Trap";
  case SKILL_DISABLE_TRAP: return "Disable Trap";
  case SKILL_DISCIPLINE: return "Discipline";
  case SKILL_HEAL: return "Heal";
  case SKILL_HIDE: return "Hide";
  case SKILL_INTIMIDATE: return "Intimidate";
  case SKILL_LISTEN: return "Listen";
  case SKILL_LORE: return "Lore";
  case SKILL_MOVE_SILENTLY: return "Move Silently";
  case SKILL_OPEN_LOCK: return "Open Lock";
  case SKILL_PARRY: return "Parry";
  case SKILL_PERFORM: return "Perform";
  case SKILL_PERSUADE: return "Persuade";
  case SKILL_PICK_POCKET: return "Pick Pocket";
  case SKILL_RIDE: return "Ride";
  case SKILL_SEARCH: return "Search";
  case SKILL_SET_TRAP: return "Set Trap";
  case SKILL_SPELLCRAFT: return "Spellcraft";
  case SKILL_SPOT: return "Spot";
  case SKILL_TAUNT: return "Taunt";
  case SKILL_TUMBLE: return "Tumble";
  case SKILL_USE_MAGIC_DEVICE: return "Use Magic Device";
  }
  return "";
}
void _CheckSkillAvailable(object oPC, int nSkill)
{
  int nRank = GetSkillRank(nSkill, oPC, TRUE);
  int nMax = GetHitDice(oPC) + 3;
  int nClass1 = miSKGetIsClassSkill(GetClassByPosition(1, oPC), nSkill);
  int nClass2 = GetClassByPosition(2, oPC);
  int nClass3 = -1;
  if(nClass2 == CLASS_TYPE_INVALID)
    nClass2 = -1;
  else
  {
    nClass2 = miSKGetIsClassSkill(nClass2, nSkill);
    nClass3 = GetClassByPosition(3, oPC);
    if(nClass3 == CLASS_TYPE_INVALID)
      nClass3 = -1;
    else
      nClass3 = miSKGetIsClassSkill(nClass3, nSkill);
  }


  if(((nClass1 == 1|| nClass2 == 1|| nClass3 == 1) && nRank < nMax)
       || (nRank < (nMax/2) && (nClass1 != -1 || nClass2 != -1 || nClass3 != -1)))
  {
      AddStringElement(_SkillName(nSkill), LIST_SKILLS);
      AddIntElement(nSkill, LIST_SK_ID);
  }

}
void _DoSkillPointList(object oPC)
{
  DeleteList(LIST_SKILLS);
  DeleteList(LIST_SK_ID);
  string sPrompt = "Select a skill:";
  sPrompt += "\nSkill points to use: " + IntToString(GetPCSkillPoints(oPC) - GetLocalInt(oPC, "T_SKILL_USED"));
  sPrompt += "\n\nNOTE: This includes skill points saved on level up - you can spend them here.";
  int x;
  for(x = 0; x <= 27; x++)
  {
    int nAmt = GetLocalInt(oPC, "T_INCREASE_AMT_"+IntToString(x));
    if(nAmt > 0)
      sPrompt += "\n"+_SkillName(x)+":  "+IntToString(nAmt);

  }
  SetDlgPrompt(sPrompt);
  _CheckSkillAvailable(oPC, SKILL_ANIMAL_EMPATHY);
  _CheckSkillAvailable(oPC, SKILL_APPRAISE);
  _CheckSkillAvailable(oPC, SKILL_BLUFF);
  _CheckSkillAvailable(oPC, SKILL_CONCENTRATION);
  _CheckSkillAvailable(oPC, SKILL_CRAFT_TRAP);
  _CheckSkillAvailable(oPC, SKILL_DISABLE_TRAP);
  _CheckSkillAvailable(oPC, SKILL_DISCIPLINE);
  _CheckSkillAvailable(oPC, SKILL_HEAL);
  _CheckSkillAvailable(oPC, SKILL_HIDE);
  _CheckSkillAvailable(oPC, SKILL_INTIMIDATE);
  _CheckSkillAvailable(oPC, SKILL_LISTEN);
  _CheckSkillAvailable(oPC, SKILL_LORE);
  _CheckSkillAvailable(oPC, SKILL_MOVE_SILENTLY);
  _CheckSkillAvailable(oPC, SKILL_OPEN_LOCK);
  _CheckSkillAvailable(oPC, SKILL_PARRY);
  _CheckSkillAvailable(oPC, SKILL_PERFORM);
  _CheckSkillAvailable(oPC, SKILL_PERSUADE);
  _CheckSkillAvailable(oPC, SKILL_PICK_POCKET);
  _CheckSkillAvailable(oPC, SKILL_RIDE);
  _CheckSkillAvailable(oPC, SKILL_SEARCH);
  _CheckSkillAvailable(oPC, SKILL_SET_TRAP);
  _CheckSkillAvailable(oPC, SKILL_SPELLCRAFT);
  _CheckSkillAvailable(oPC, SKILL_SPOT);
  _CheckSkillAvailable(oPC, SKILL_TAUNT);
  _CheckSkillAvailable(oPC, SKILL_TUMBLE);
  _CheckSkillAvailable(oPC, SKILL_USE_MAGIC_DEVICE);
  AddStringElement("<c  þ>Confirm</c>", LIST_SKILLS);
  AddIntElement(-10, LIST_SK_ID);
  SetDlgResponseList(LIST_SKILLS);
}


void add_feat_to_list(object oPC, string sFriendlyName, int nFeat, int nIgnore = FALSE, int nClass = -1)
{
   if (GetKnowsFeat(nFeat, oPC)) return;
   if (!NWNX_Creature_GetMeetsFeatRequirements(oPC, nFeat) && !nIgnore) return;

   string sList = GetLocalString(OBJECT_SELF, CURR_LIST);
   string sIDList = sList + "_IDS";

   AddStringElement(sFriendlyName, sList);
   AddIntElement(nFeat, sIDList);
   AddIntElement(nClass, sList+"_CLASS");
}

void add_group_list(string sName, int nGroupNumber, string sNewList)
{
  string sList = GetLocalString(OBJECT_SELF, CURR_LIST);
  string sIDList = sList + "_IDS";

  AddStringElement(sName, sList);
  AddIntElement(nGroupNumber, sIDList);
  AddIntElement(-1, sList+"_CLASS");
  SetLocalString(OBJECT_SELF, CURR_LIST, sNewList);
}

void init_feat_list (object oPC)
{
  object oNPC = OBJECT_SELF;

  DeleteList(LIST_1);
  DeleteList(LIST_1_IDS);
  DeleteList(LIST_2);
  DeleteList(LIST_2_IDS);
  DeleteList(LIST_3);
  DeleteList(LIST_3_IDS);
  DeleteList(LIST_4);
  DeleteList(LIST_4_IDS);
  DeleteList(LIST_5);
  DeleteList(LIST_5_IDS);

  DeleteList(LIST_1+"_CLASS");
  DeleteList(LIST_2+"_CLASS");
  DeleteList(LIST_3+"_CLASS");
  DeleteList(LIST_4+"_CLASS");
  DeleteList(LIST_5+"_CLASS");


  DeleteList(LIST_FE);
  DeleteList(LIST_FE_IDS);
  DeleteList(LIST_WF);
  DeleteList(LIST_WF_IDS);
  DeleteList(LIST_IC);
  DeleteList(LIST_IC_IDS);
  DeleteList(LIST_SF);
  DeleteList(LIST_SF_IDS);

  int nPCLevel = GetLocalInt(gsPCGetCreatureHide(oPC), "FL_LEVEL") + 1;

  //---------------------------------
  // Spell related feats.
  //---------------------------------
  SetLocalString(OBJECT_SELF, CURR_LIST, LIST_1);

  // Item creation feats
  if(GetLevelByClass(CLASS_TYPE_WIZARD, oPC) ||
     GetLevelByClass(CLASS_TYPE_SORCERER, oPC) ||
     GetLevelByClass(CLASS_TYPE_BARD, oPC) ||
     GetLevelByClass(CLASS_TYPE_CLERIC, oPC) ||
     GetLevelByClass(CLASS_TYPE_DRUID, oPC) ||
	 GetLevelByClass(CLASS_TYPE_FAVOURED_SOUL, oPC) ||
     GetLevelByClass(CLASS_TYPE_RANGER, oPC) >=4 ||
     GetLevelByClass(CLASS_TYPE_PALADIN, oPC) >= 4)
  {
    add_feat_to_list(oPC, "Brew Potion", FEAT_BREW_POTION);
    add_feat_to_list(oPC, "Craft Wand", FEAT_CRAFT_WAND);
    add_feat_to_list(oPC, "Scribe Scroll", FEAT_SCRIBE_SCROLL);

    if (GetKnowsFeat(FEAT_BREW_POTION, oPC) &&
        GetKnowsFeat(FEAT_CRAFT_WAND, oPC) &&
        GetKnowsFeat(FEAT_SCRIBE_SCROLL, oPC))
    {
      if (!GetLocalInt(gsPCGetCreatureHide(oPC), "CRAFT_WONDROUS_ITEM"))
        add_feat_to_list(oPC, "Craft Wondrous Item", 10005, TRUE);
    }
  }
  // Metamagic
  add_feat_to_list(oPC, "Maximize Spell", FEAT_MAXIMIZE_SPELL);
  add_feat_to_list(oPC, "Empower Spell", FEAT_EMPOWER_SPELL);
  add_feat_to_list(oPC, "Extend Spell", FEAT_EXTEND_SPELL);
  add_feat_to_list(oPC, "Quicken Spell", FEAT_QUICKEN_SPELL);
  add_feat_to_list(oPC, "Silence Spell", FEAT_SILENCE_SPELL);
  add_feat_to_list(oPC, "Still Spell", FEAT_STILL_SPELL);
  add_feat_to_list(oPC, "Spell Penetration", FEAT_SPELL_PENETRATION);
  add_feat_to_list(oPC, "Greater Spell Penetration", FEAT_GREATER_SPELL_PENETRATION);
  add_feat_to_list(oPC, "Combat Casting", FEAT_COMBAT_CASTING);

  // Spell focuses
  add_feat_to_list(oPC, "Spell focus: Abjuration", FEAT_SPELL_FOCUS_ABJURATION);
  add_feat_to_list(oPC, "Arcane Defense: Abjuration", FEAT_ARCANE_DEFENSE_ABJURATION);
  add_feat_to_list(oPC, "Greater spell focus: Abjuration", FEAT_GREATER_SPELL_FOCUS_ABJURATION);
  add_feat_to_list(oPC, "Spell focus: Conjuration", FEAT_SPELL_FOCUS_CONJURATION);
  add_feat_to_list(oPC, "Arcane Defense: Conjuration", FEAT_ARCANE_DEFENSE_CONJURATION);
  add_feat_to_list(oPC, "Greater spell focus: Conjuration", FEAT_GREATER_SPELL_FOCUS_CONJURATION);
  add_feat_to_list(oPC, "Spell focus: Divination", FEAT_SPELL_FOCUS_DIVINATION);
  add_feat_to_list(oPC, "Arcane Defense: Divination", FEAT_ARCANE_DEFENSE_DIVINATION);
  add_feat_to_list(oPC, "Greater spell focus: Divination", FEAT_GREATER_SPELL_FOCUS_DIVINATION);
  add_feat_to_list(oPC, "Spell focus: Enchantment", FEAT_SPELL_FOCUS_ENCHANTMENT);
  add_feat_to_list(oPC, "Arcane Defense: Enchantment", FEAT_ARCANE_DEFENSE_ENCHANTMENT);
  add_feat_to_list(oPC, "Greater spell focus: Enchantment", FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT);
  add_feat_to_list(oPC, "Spell focus: Evocation", FEAT_SPELL_FOCUS_EVOCATION);
  add_feat_to_list(oPC, "Arcane Defense: Evocation", FEAT_ARCANE_DEFENSE_EVOCATION);
  add_feat_to_list(oPC, "Greater spell focus: Evocation", FEAT_GREATER_SPELL_FOCUS_EVOCATION);
  add_feat_to_list(oPC, "Spell focus: Illusion", FEAT_SPELL_FOCUS_ILLUSION);
  add_feat_to_list(oPC, "Arcane Defense: Illusion", FEAT_ARCANE_DEFENSE_ILLUSION);
  add_feat_to_list(oPC, "Greater spell focus: Illusion", FEAT_GREATER_SPELL_FOCUS_ILLUSION);
  add_feat_to_list(oPC, "Spell focus: Necromancy", FEAT_SPELL_FOCUS_NECROMANCY);
  add_feat_to_list(oPC, "Arcane Defense: Necromancy", FEAT_ARCANE_DEFENSE_NECROMANCY);
  add_feat_to_list(oPC, "Greater spell focus: Necromancy", FEAT_GREATER_SPELL_FOCUS_NECROMANCY);
  add_feat_to_list(oPC, "Spell focus: Transmutation", FEAT_SPELL_FOCUS_TRANSMUTATION);
  add_feat_to_list(oPC, "Arcane Defense: Transmutation", FEAT_ARCANE_DEFENSE_TRANSMUTATION);
  add_feat_to_list(oPC, "Greater spell focus: Transmutation", FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION);

  //---------------------------------
  // Combat related feats.
  //---------------------------------
  SetLocalString(OBJECT_SELF, CURR_LIST, LIST_2);

  // Generic combat feats
  add_feat_to_list(oPC, "Ambidexterity", FEAT_AMBIDEXTERITY);
  add_feat_to_list(oPC, "Blind fight", FEAT_BLIND_FIGHT);
  add_feat_to_list(oPC, "Called Shot", FEAT_CALLED_SHOT);
  add_feat_to_list(oPC, "Cleave", FEAT_CLEAVE);
  add_feat_to_list(oPC, "Circle Kick", FEAT_CIRCLE_KICK);
  add_feat_to_list(oPC, "Deflect Arrows", FEAT_DEFLECT_ARROWS);
  add_feat_to_list(oPC, "Dirty Fighting", FEAT_DIRTY_FIGHTING);
  add_feat_to_list(oPC, "Disarm", FEAT_DISARM);
  add_feat_to_list(oPC, "Dodge", FEAT_DODGE);
  add_feat_to_list(oPC, "Expertise", FEAT_EXPERTISE);
  add_feat_to_list(oPC, "Great Cleave", FEAT_GREAT_CLEAVE);
  add_feat_to_list(oPC, "Improved Disarm", FEAT_IMPROVED_DISARM);
  add_feat_to_list(oPC, "Improved Expertise", FEAT_IMPROVED_EXPERTISE);
  add_feat_to_list(oPC, "Improved Knockdown", FEAT_IMPROVED_KNOCKDOWN);
  add_feat_to_list(oPC, "Improved Parry", FEAT_IMPROVED_PARRY);
  add_feat_to_list(oPC, "Improved Power Attack", FEAT_IMPROVED_POWER_ATTACK);
  add_feat_to_list(oPC, "Improved Unarmed Strike", FEAT_IMPROVED_UNARMED_STRIKE);
  if (!GetIsArcher(oPC)) add_feat_to_list(oPC, "Improved 2-Weapon Fighting", FEAT_IMPROVED_TWO_WEAPON_FIGHTING);
  add_feat_to_list(oPC, "Knockdown", FEAT_KNOCKDOWN);
  add_feat_to_list(oPC, "Mobility", FEAT_MOBILITY);
  add_feat_to_list(oPC, "Point Blank Shot", FEAT_POINT_BLANK_SHOT);
  add_feat_to_list(oPC, "Power Attack", FEAT_POWER_ATTACK);
  add_feat_to_list(oPC, "Rapid Reload", FEAT_RAPID_RELOAD);
  add_feat_to_list(oPC, "Rapid Shot", FEAT_RAPID_SHOT);
  add_feat_to_list(oPC, "Spring Attack", FEAT_SPRING_ATTACK);
  add_feat_to_list(oPC, "2-Weapon Fighting", FEAT_TWO_WEAPON_FIGHTING);
  add_feat_to_list(oPC, "Weapon Finesse", FEAT_WEAPON_FINESSE);
  add_feat_to_list(oPC, "Whirlwind Attack", FEAT_WHIRLWIND_ATTACK);
  add_feat_to_list(oPC, "Zen Archery", FEAT_ZEN_ARCHERY);

  // Weapon and armor proficiencies, focuses etc
  if (!GetIsHealer(oPC))
  {
    add_feat_to_list(oPC, "Light armor", FEAT_ARMOR_PROFICIENCY_LIGHT);
    add_feat_to_list(oPC, "Medium armor", FEAT_ARMOR_PROFICIENCY_MEDIUM);
    add_feat_to_list(oPC, "Heavy armor", FEAT_ARMOR_PROFICIENCY_HEAVY);
    add_feat_to_list(oPC, "Shields", FEAT_SHIELD_PROFICIENCY);
    add_feat_to_list(oPC, "Simple weapons", FEAT_WEAPON_PROFICIENCY_SIMPLE);
    add_feat_to_list(oPC, "Martial weapons", FEAT_WEAPON_PROFICIENCY_MARTIAL);
    add_feat_to_list(oPC, "Exotic weapons", FEAT_WEAPON_PROFICIENCY_EXOTIC);
  }
  
  add_group_list("Weapon Focus", GROUP_NUMBER_WF, LIST_WF);
  //add_feat_to_list(oPC, "Weapon focus: bastard sword", FEAT_WEAPON_FOCUS_BASTARD_SWORD);
  add_feat_to_list(oPC, "Weapon focus: battle axe", FEAT_WEAPON_FOCUS_BATTLE_AXE);
  add_feat_to_list(oPC, "Weapon focus: club", FEAT_WEAPON_FOCUS_CLUB);
  add_feat_to_list(oPC, "Weapon focus: creature weapon", FEAT_WEAPON_FOCUS_CREATURE);
  add_feat_to_list(oPC, "Weapon focus: dagger", FEAT_WEAPON_FOCUS_DAGGER);
  add_feat_to_list(oPC, "Weapon focus: dart", FEAT_WEAPON_FOCUS_DART);
  add_feat_to_list(oPC, "Weapon focus: dire mace", FEAT_WEAPON_FOCUS_DIRE_MACE);
  add_feat_to_list(oPC, "Weapon focus: double axe", FEAT_WEAPON_FOCUS_DOUBLE_AXE);
  add_feat_to_list(oPC, "Weapon focus: dwarven waraxe", FEAT_WEAPON_FOCUS_DWAXE);
  add_feat_to_list(oPC, "Weapon focus: greataxe", FEAT_WEAPON_FOCUS_GREAT_AXE);
  add_feat_to_list(oPC, "Weapon focus: greatsword", FEAT_WEAPON_FOCUS_GREAT_SWORD);
  add_feat_to_list(oPC, "Weapon focus: halberd", FEAT_WEAPON_FOCUS_HALBERD);
  add_feat_to_list(oPC, "Weapon focus: handaxe", FEAT_WEAPON_FOCUS_HAND_AXE);
  add_feat_to_list(oPC, "Weapon focus: heavy crossbow", FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW);
  add_feat_to_list(oPC, "Weapon focus: heavy flail", FEAT_WEAPON_FOCUS_HEAVY_FLAIL);
  add_feat_to_list(oPC, "Weapon focus: kama", FEAT_WEAPON_FOCUS_KAMA);
  add_feat_to_list(oPC, "Weapon focus: katana", FEAT_WEAPON_FOCUS_KATANA);
  add_feat_to_list(oPC, "Weapon focus: kukri", FEAT_WEAPON_FOCUS_KUKRI);
  add_feat_to_list(oPC, "Weapon focus: light crossbow", FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW);
  add_feat_to_list(oPC, "Weapon focus: light flail", FEAT_WEAPON_FOCUS_LIGHT_FLAIL);
  add_feat_to_list(oPC, "Weapon focus: light hammer", FEAT_WEAPON_FOCUS_LIGHT_HAMMER);
  add_feat_to_list(oPC, "Weapon focus: light mace", FEAT_WEAPON_FOCUS_LIGHT_MACE);
  add_feat_to_list(oPC, "Weapon focus: longsword", FEAT_WEAPON_FOCUS_LONG_SWORD);
  add_feat_to_list(oPC, "Weapon focus: longbow", FEAT_WEAPON_FOCUS_LONGBOW);
  add_feat_to_list(oPC, "Weapon focus: morningstar", FEAT_WEAPON_FOCUS_MORNING_STAR);
  add_feat_to_list(oPC, "Weapon focus: quarterstaff", FEAT_WEAPON_FOCUS_STAFF);
  add_feat_to_list(oPC, "Weapon focus: rapier", FEAT_WEAPON_FOCUS_RAPIER);
  add_feat_to_list(oPC, "Weapon focus: scimitar", FEAT_WEAPON_FOCUS_SCIMITAR);
  add_feat_to_list(oPC, "Weapon focus: scythe", FEAT_WEAPON_FOCUS_SCYTHE);
  add_feat_to_list(oPC, "Weapon focus: shortsword", FEAT_WEAPON_FOCUS_SHORT_SWORD);
  add_feat_to_list(oPC, "Weapon focus: shortbow", FEAT_WEAPON_FOCUS_SHORTBOW);
  add_feat_to_list(oPC, "Weapon focus: shuriken", FEAT_WEAPON_FOCUS_SHURIKEN);
  add_feat_to_list(oPC, "Weapon focus: sickle", FEAT_WEAPON_FOCUS_SICKLE);
  add_feat_to_list(oPC, "Weapon focus: sling", FEAT_WEAPON_FOCUS_SLING);
  add_feat_to_list(oPC, "Weapon focus: spear", FEAT_WEAPON_FOCUS_SPEAR);
  add_feat_to_list(oPC, "Weapon focus: throwing axe", FEAT_WEAPON_FOCUS_THROWING_AXE);
  add_feat_to_list(oPC, "Weapon focus: trident", FEAT_WEAPON_FOCUS_TRIDENT);
  add_feat_to_list(oPC, "Weapon focus: two-bladed sword", FEAT_WEAPON_FOCUS_TWO_BLADED_SWORD);
  add_feat_to_list(oPC, "Weapon focus: unarmed strike", FEAT_WEAPON_FOCUS_UNARMED_STRIKE);
  add_feat_to_list(oPC, "Weapon focus: warhammer", FEAT_WEAPON_FOCUS_WAR_HAMMER);
  add_feat_to_list(oPC, "Weapon focus: whip", FEAT_WEAPON_FOCUS_WHIP);
  //End the group list
  SetLocalString(OBJECT_SELF, CURR_LIST, LIST_2);
  // Improved Crit
  add_group_list("Improved Critical", GROUP_NUMBER_IC, LIST_IC);
  //add_feat_to_list(oPC, "Imp Crit: bastard sword", FEAT_IMPROVED_CRITICAL_BASTARD_SWORD);
  add_feat_to_list(oPC, "Imp Crit: battle axe", FEAT_IMPROVED_CRITICAL_BATTLE_AXE);
  add_feat_to_list(oPC, "Imp Crit: club", FEAT_IMPROVED_CRITICAL_CLUB);
  add_feat_to_list(oPC, "Imp Crit: creature weapon", FEAT_IMPROVED_CRITICAL_CREATURE);
  add_feat_to_list(oPC, "Imp Crit: dagger", FEAT_IMPROVED_CRITICAL_DAGGER);
  add_feat_to_list(oPC, "Imp Crit: dart", FEAT_IMPROVED_CRITICAL_DART);
  add_feat_to_list(oPC, "Imp Crit: dire mace", FEAT_IMPROVED_CRITICAL_DIRE_MACE);
  add_feat_to_list(oPC, "Imp Crit: double axe", FEAT_IMPROVED_CRITICAL_DOUBLE_AXE);
  add_feat_to_list(oPC, "Imp Crit: dwarven waraxe", FEAT_IMPROVED_CRITICAL_DWAXE);
  add_feat_to_list(oPC, "Imp Crit: greataxe", FEAT_IMPROVED_CRITICAL_GREAT_AXE);
  add_feat_to_list(oPC, "Imp Crit: greatsword", FEAT_IMPROVED_CRITICAL_GREAT_SWORD);
  add_feat_to_list(oPC, "Imp Crit: halberd", FEAT_IMPROVED_CRITICAL_HALBERD);
  add_feat_to_list(oPC, "Imp Crit: handaxe", FEAT_IMPROVED_CRITICAL_HAND_AXE);
  add_feat_to_list(oPC, "Imp Crit: heavy crossbow", FEAT_IMPROVED_CRITICAL_HEAVY_CROSSBOW);
  add_feat_to_list(oPC, "Imp Crit: heavy flail", FEAT_IMPROVED_CRITICAL_HEAVY_FLAIL);
  add_feat_to_list(oPC, "Imp Crit: kama", FEAT_IMPROVED_CRITICAL_KAMA);
  add_feat_to_list(oPC, "Imp Crit: katana", FEAT_IMPROVED_CRITICAL_KATANA);
  add_feat_to_list(oPC, "Imp Crit: kukri", FEAT_IMPROVED_CRITICAL_KUKRI);
  add_feat_to_list(oPC, "Imp Crit: light crossbow", FEAT_IMPROVED_CRITICAL_LIGHT_CROSSBOW);
  add_feat_to_list(oPC, "Imp Crit: light flail", FEAT_IMPROVED_CRITICAL_LIGHT_FLAIL);
  add_feat_to_list(oPC, "Imp Crit: light hammer", FEAT_IMPROVED_CRITICAL_LIGHT_HAMMER);
  add_feat_to_list(oPC, "Imp Crit: light mace", FEAT_IMPROVED_CRITICAL_LIGHT_MACE);
  add_feat_to_list(oPC, "Imp Crit: longsword", FEAT_IMPROVED_CRITICAL_LONG_SWORD);
  add_feat_to_list(oPC, "Imp Crit: longbow", FEAT_IMPROVED_CRITICAL_LONGBOW);
  add_feat_to_list(oPC, "Imp Crit: morningstar", FEAT_IMPROVED_CRITICAL_MORNING_STAR);
  add_feat_to_list(oPC, "Imp Crit: quarterstaff", FEAT_IMPROVED_CRITICAL_STAFF);
  add_feat_to_list(oPC, "Imp Crit: rapier", FEAT_IMPROVED_CRITICAL_RAPIER);
  add_feat_to_list(oPC, "Imp Crit: scimitar", FEAT_IMPROVED_CRITICAL_SCIMITAR);
  add_feat_to_list(oPC, "Imp Crit: scythe", FEAT_IMPROVED_CRITICAL_SCYTHE);
  add_feat_to_list(oPC, "Imp Crit: shortsword", FEAT_IMPROVED_CRITICAL_SHORT_SWORD);
  add_feat_to_list(oPC, "Imp Crit: shortbow", FEAT_IMPROVED_CRITICAL_SHORTBOW);
  add_feat_to_list(oPC, "Imp Crit: shuriken", FEAT_IMPROVED_CRITICAL_SHURIKEN);
  add_feat_to_list(oPC, "Imp Crit: sickle", FEAT_IMPROVED_CRITICAL_SICKLE);
  add_feat_to_list(oPC, "Imp Crit: sling", FEAT_IMPROVED_CRITICAL_SLING);
  add_feat_to_list(oPC, "Imp Crit: spear", FEAT_IMPROVED_CRITICAL_SPEAR);
  add_feat_to_list(oPC, "Imp Crit: throwing axe", FEAT_IMPROVED_CRITICAL_THROWING_AXE);
  add_feat_to_list(oPC, "Imp Crit: trident", FEAT_IMPROVED_CRITICAL_TRIDENT);
  add_feat_to_list(oPC, "Imp Crit: two-bladed sword", FEAT_IMPROVED_CRITICAL_TWO_BLADED_SWORD);
  add_feat_to_list(oPC, "Imp Crit: unarmed strike", FEAT_IMPROVED_CRITICAL_UNARMED_STRIKE);
  add_feat_to_list(oPC, "Imp Crit: warhammer", FEAT_IMPROVED_CRITICAL_WAR_HAMMER);
  add_feat_to_list(oPC, "Imp Crit: whip", FEAT_IMPROVED_CRITICAL_WHIP);
  //End the group list
  SetLocalString(OBJECT_SELF, CURR_LIST, LIST_2);
  //---------------------------------
  // Generic feats.
  //---------------------------------
  SetLocalString(OBJECT_SELF, CURR_LIST, LIST_3);

  add_feat_to_list(oPC, "Alertness", FEAT_ALERTNESS);
  add_feat_to_list(oPC, "Artist", FEAT_ARTIST);
  add_feat_to_list(oPC, "Bullheaded", FEAT_BULLHEADED);
  add_feat_to_list(oPC, "Courtly Magocracy", FEAT_COURTLY_MAGOCRACY);
  add_feat_to_list(oPC, "Extra Smiting", FEAT_EXTRA_SMITING);
  add_feat_to_list(oPC, "Extra Stunning Attack", FEAT_EXTRA_STUNNING_ATTACK);
  add_feat_to_list(oPC, "Extra Turning", FEAT_EXTRA_TURNING);
  add_feat_to_list(oPC, "Fearless", FEAT_FEARLESS);
  add_feat_to_list(oPC, "Great Fortitude", FEAT_GREAT_FORTITUDE);
  add_feat_to_list(oPC, "Improved Initiative", FEAT_IMPROVED_INITIATIVE);
  add_feat_to_list(oPC, "Iron Will", FEAT_IRON_WILL);
  add_feat_to_list(oPC, "Lightning Reflexes", FEAT_LIGHTNING_REFLEXES);
  add_feat_to_list(oPC, "Luck of Heroes", FEAT_LUCK_OF_HEROES);
  add_feat_to_list(oPC, "Resist Disease", FEAT_RESIST_DISEASE);
  add_feat_to_list(oPC, "Resist Acid", FEAT_RESIST_ENERGY_ACID);
  add_feat_to_list(oPC, "Resist Cold", FEAT_RESIST_ENERGY_COLD);
  add_feat_to_list(oPC, "Resist Lightning", FEAT_RESIST_ENERGY_ELECTRICAL);
  add_feat_to_list(oPC, "Resist Fire", FEAT_RESIST_ENERGY_FIRE);
  add_feat_to_list(oPC, "Resist Sonic", FEAT_RESIST_ENERGY_SONIC);
  add_feat_to_list(oPC, "Resist Poison", FEAT_RESIST_POISON);
  add_feat_to_list(oPC, "Silver Palm", FEAT_SILVER_PALM);
  add_feat_to_list(oPC, "Stealthy", FEAT_STEALTHY);
  add_feat_to_list(oPC, "Thug", FEAT_THUG);
  add_feat_to_list(oPC, "Toughness", FEAT_TOUGHNESS);

  add_feat_to_list(oPC, "Gain (2+int) skill points", 10003, TRUE);
  add_group_list("Skill Focus", GROUP_NUMBER_SF, LIST_SF);
  add_feat_to_list(oPC, "Skill Focus: Appraise", FEAT_SKILLFOCUS_APPRAISE);
  add_feat_to_list(oPC, "Skill Focus: Animal Empathy", FEAT_SKILL_FOCUS_ANIMAL_EMPATHY);
  add_feat_to_list(oPC, "Skill Focus: Bluff", FEAT_SKILL_FOCUS_BLUFF);
  add_feat_to_list(oPC, "Skill Focus: Concentration", FEAT_SKILL_FOCUS_CONCENTRATION);
  //add_feat_to_list(oPC, "Skill Focus: Craft Armor", FEAT_SKILL_FOCUS_CRAFT_ARMOR);
  add_feat_to_list(oPC, "Skill Focus: Craft Trap", FEAT_SKILL_FOCUS_CRAFT_TRAP);
  //add_feat_to_list(oPC, "Skill Focus: Craft Weapon", FEAT_SKILL_FOCUS_CRAFT_WEAPON);
  add_feat_to_list(oPC, "Skill Focus: Disable Trap", FEAT_SKILL_FOCUS_DISABLE_TRAP);
  add_feat_to_list(oPC, "Skill Focus: Discipline", FEAT_SKILL_FOCUS_DISCIPLINE);
  add_feat_to_list(oPC, "Skill Focus: Heal", FEAT_SKILL_FOCUS_HEAL);
  add_feat_to_list(oPC, "Skill Focus: Hide", FEAT_SKILL_FOCUS_HIDE);
  add_feat_to_list(oPC, "Skill Focus: Intimidate", FEAT_SKILL_FOCUS_INTIMIDATE);
  add_feat_to_list(oPC, "Skill Focus: Listen", FEAT_SKILL_FOCUS_LISTEN);
  add_feat_to_list(oPC, "Skill Focus: Lore", FEAT_SKILL_FOCUS_LORE);
  add_feat_to_list(oPC, "Skill Focus: Move Silently", FEAT_SKILL_FOCUS_MOVE_SILENTLY);
  add_feat_to_list(oPC, "Skill Focus: Open Lock", FEAT_SKILL_FOCUS_OPEN_LOCK);
  add_feat_to_list(oPC, "Skill Focus: Parry", FEAT_SKILL_FOCUS_PARRY);
  add_feat_to_list(oPC, "Skill Focus: Perform", FEAT_SKILL_FOCUS_PERFORM);
  add_feat_to_list(oPC, "Skill Focus: Persuade", FEAT_SKILL_FOCUS_PERSUADE);
  add_feat_to_list(oPC, "Skill Focus: Pick Pocket", FEAT_SKILL_FOCUS_PICK_POCKET);
  add_feat_to_list(oPC, "Skill Focus: Search", FEAT_SKILL_FOCUS_SEARCH);
  add_feat_to_list(oPC, "Skill Focus: Set Trap", FEAT_SKILL_FOCUS_SET_TRAP);
  add_feat_to_list(oPC, "Skill Focus: Spellcraft", FEAT_SKILL_FOCUS_SPELLCRAFT);
  add_feat_to_list(oPC, "Skill Focus: Spot", FEAT_SKILL_FOCUS_SPOT);
  add_feat_to_list(oPC, "Skill Focus: Taunt", FEAT_SKILL_FOCUS_TAUNT);
  add_feat_to_list(oPC, "Skill Focus: Tumble", FEAT_SKILL_FOCUS_TUMBLE);
  add_feat_to_list(oPC, "Skill Focus: Use Magic Device", FEAT_SKILL_FOCUS_USE_MAGIC_DEVICE);
  //End the group list
  SetLocalString(OBJECT_SELF, CURR_LIST, LIST_3);

  //---------------------------------
  // Epic feats.
  //---------------------------------
  SetLocalString(OBJECT_SELF, CURR_LIST, LIST_4);
  if (nPCLevel > 30 && GetHitDice(oNPC) > 20)
  {
    //add_feat_to_list(oPC, "Armor Skin", FEAT_EPIC_ARMOR_SKIN);
    add_feat_to_list(oPC, "Auto Quicken I", FEAT_EPIC_AUTOMATIC_QUICKEN_1);
    add_feat_to_list(oPC, "Auto Quicken II", FEAT_EPIC_AUTOMATIC_QUICKEN_2);
    //add_feat_to_list(oPC, "Auto Quicken III", FEAT_EPIC_AUTOMATIC_QUICKEN_3);
    add_feat_to_list(oPC, "Auto Silent I", FEAT_EPIC_AUTOMATIC_SILENT_SPELL_1);
    add_feat_to_list(oPC, "Auto Silent II", FEAT_EPIC_AUTOMATIC_SILENT_SPELL_2);
    //add_feat_to_list(oPC, "Auto Silent III", FEAT_EPIC_AUTOMATIC_SILENT_SPELL_3);
    //add_feat_to_list(oPC, "Auto Still I", FEAT_EPIC_AUTOMATIC_STILL_SPELL_1);
    //add_feat_to_list(oPC, "Auto Still II", FEAT_EPIC_AUTOMATIC_STILL_SPELL_2);
    //add_feat_to_list(oPC, "Auto Still III", FEAT_EPIC_AUTOMATIC_STILL_SPELL_3);
    add_feat_to_list(oPC, "Blinding Speed", FEAT_EPIC_BLINDING_SPEED);
    //add_feat_to_list(oPC, "Construct Shape", FEAT_EPIC_CONSTRUCT_SHAPE);
    //add_feat_to_list(oPC, "Epic DR (3/-)", FEAT_EPIC_DAMAGE_REDUCTION_3);
    //add_feat_to_list(oPC, "Epic DR (6/-)", FEAT_EPIC_DAMAGE_REDUCTION_6);
    //add_feat_to_list(oPC, "Epic DR (9/-)", FEAT_EPIC_DAMAGE_REDUCTION_9);
    if (GetKnowsFeat(FEAT_IMPROVED_EVASION, oPC)) add_feat_to_list(oPC, "Epic Dodge", FEAT_EPIC_DODGE); 
    add_feat_to_list(oPC, "Acid Resistance (10)", FEAT_EPIC_ENERGY_RESISTANCE_ACID_1);
    add_feat_to_list(oPC, "Acid Resistance (20)", FEAT_EPIC_ENERGY_RESISTANCE_ACID_2);
    //add_feat_to_list(oPC, "Acid Resistance (30)", FEAT_EPIC_ENERGY_RESISTANCE_ACID_3);
    //add_feat_to_list(oPC, "Acid Resistance (40)", FEAT_EPIC_ENERGY_RESISTANCE_ACID_4);
    //add_feat_to_list(oPC, "Acid Resistance (50)", FEAT_EPIC_ENERGY_RESISTANCE_ACID_5);
    add_feat_to_list(oPC, "Cold Resistance (10)", FEAT_EPIC_ENERGY_RESISTANCE_COLD_1);
    add_feat_to_list(oPC, "Cold Resistance (20)", FEAT_EPIC_ENERGY_RESISTANCE_COLD_2);
    //add_feat_to_list(oPC, "Cold Resistance (30)", FEAT_EPIC_ENERGY_RESISTANCE_COLD_3);
    //add_feat_to_list(oPC, "Cold Resistance (40)", FEAT_EPIC_ENERGY_RESISTANCE_COLD_4);
    //add_feat_to_list(oPC, "Cold Resistance (50)", FEAT_EPIC_ENERGY_RESISTANCE_COLD_5);
    add_feat_to_list(oPC, "Electric Resistance (10)", FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_1);
    add_feat_to_list(oPC, "Electric Resistance (20)", FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_2);
    //add_feat_to_list(oPC, "Electric Resistance (30)", FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_3);
    //add_feat_to_list(oPC, "Electric Resistance (40)", FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_4);
    //add_feat_to_list(oPC, "Electric Resistance (50)", FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_5);
    add_feat_to_list(oPC, "Fire Resistance (10)", FEAT_EPIC_ENERGY_RESISTANCE_FIRE_1);
    add_feat_to_list(oPC, "Fire Resistance (20)", FEAT_EPIC_ENERGY_RESISTANCE_FIRE_2);
    //add_feat_to_list(oPC, "Fire Resistance (30)", FEAT_EPIC_ENERGY_RESISTANCE_FIRE_3);
    //add_feat_to_list(oPC, "Fire Resistance (40)", FEAT_EPIC_ENERGY_RESISTANCE_FIRE_4);
    //add_feat_to_list(oPC, "Fire Resistance (50)", FEAT_EPIC_ENERGY_RESISTANCE_FIRE_5);
    add_feat_to_list(oPC, "Sonic Resistance (10)", FEAT_EPIC_ENERGY_RESISTANCE_SONIC_1);
    add_feat_to_list(oPC, "Sonic Resistance (20)", FEAT_EPIC_ENERGY_RESISTANCE_SONIC_2);
    //add_feat_to_list(oPC, "Sonic Resistance (30)", FEAT_EPIC_ENERGY_RESISTANCE_SONIC_3);
    //add_feat_to_list(oPC, "Sonic Resistance (40)", FEAT_EPIC_ENERGY_RESISTANCE_SONIC_4);
    //add_feat_to_list(oPC, "Sonic Resistance (50)", FEAT_EPIC_ENERGY_RESISTANCE_SONIC_5);
    add_feat_to_list(oPC, "Epic Fiend", FEAT_EPIC_EPIC_FIEND, FALSE, CLASS_TYPE_BLACKGUARD); 
    add_feat_to_list(oPC, "Epic Shadowlord", FEAT_EPIC_EPIC_SHADOWLORD, FALSE, CLASS_TYPE_SHADOWDANCER);
	if (GetKnowsFeat(339, oPC)) add_feat_to_list(oPC, "Infinite Wildshape", 1068, FALSE, CLASS_TYPE_DRUID);
    if (GetKnowsFeat(341, oPC)) add_feat_to_list(oPC, "Infinite Elemental Shape", 1069, FALSE, CLASS_TYPE_DRUID);
    add_feat_to_list(oPC, "Epic Fortitude", FEAT_EPIC_FORTITUDE);
    add_feat_to_list(oPC, "Great CHA 1", FEAT_EPIC_GREAT_CHARISMA_1);
    add_feat_to_list(oPC, "Great CHA 2", FEAT_EPIC_GREAT_CHARISMA_2);
    add_feat_to_list(oPC, "Great CHA 3", FEAT_EPIC_GREAT_CHARISMA_3);
    add_feat_to_list(oPC, "Great CHA 4", FEAT_EPIC_GREAT_CHARISMA_4);
    add_feat_to_list(oPC, "Great CON 1", FEAT_EPIC_GREAT_CONSTITUTION_1);
    add_feat_to_list(oPC, "Great CON 2", FEAT_EPIC_GREAT_CONSTITUTION_2);
    add_feat_to_list(oPC, "Great CON 3", FEAT_EPIC_GREAT_CONSTITUTION_3);
    add_feat_to_list(oPC, "Great CON 4", FEAT_EPIC_GREAT_CONSTITUTION_4);
    add_feat_to_list(oPC, "Great DEX 1", FEAT_EPIC_GREAT_DEXTERITY_1);
    add_feat_to_list(oPC, "Great DEX 2", FEAT_EPIC_GREAT_DEXTERITY_2);
    add_feat_to_list(oPC, "Great DEX 3", FEAT_EPIC_GREAT_DEXTERITY_3);
    add_feat_to_list(oPC, "Great DEX 4", FEAT_EPIC_GREAT_DEXTERITY_4);
    add_feat_to_list(oPC, "Great INT 1", FEAT_EPIC_GREAT_INTELLIGENCE_1);
    add_feat_to_list(oPC, "Great INT 2", FEAT_EPIC_GREAT_INTELLIGENCE_2);
    add_feat_to_list(oPC, "Great INT 3", FEAT_EPIC_GREAT_INTELLIGENCE_3);
    add_feat_to_list(oPC, "Great INT 4", FEAT_EPIC_GREAT_INTELLIGENCE_4);
    add_feat_to_list(oPC, "Great Smiting 1", FEAT_EPIC_GREAT_SMITING_1);
    add_feat_to_list(oPC, "Great Smiting 2", FEAT_EPIC_GREAT_SMITING_2);
    add_feat_to_list(oPC, "Great Smiting 3", FEAT_EPIC_GREAT_SMITING_3);
    add_feat_to_list(oPC, "Great Smiting 4", FEAT_EPIC_GREAT_SMITING_4);
    add_feat_to_list(oPC, "Great STR 1", FEAT_EPIC_GREAT_STRENGTH_1);
    add_feat_to_list(oPC, "Great STR 2", FEAT_EPIC_GREAT_STRENGTH_2);
    add_feat_to_list(oPC, "Great STR 3", FEAT_EPIC_GREAT_STRENGTH_3);
    add_feat_to_list(oPC, "Great STR 4", FEAT_EPIC_GREAT_STRENGTH_4);
    add_feat_to_list(oPC, "Great WIS 1", FEAT_EPIC_GREAT_WISDOM_1);
    add_feat_to_list(oPC, "Great WIS 2", FEAT_EPIC_GREAT_WISDOM_2);
    add_feat_to_list(oPC, "Great WIS 3", FEAT_EPIC_GREAT_WISDOM_3);
    add_feat_to_list(oPC, "Great WIS 4", FEAT_EPIC_GREAT_WISDOM_4);
    add_feat_to_list(oPC, "Improved Sneak I", FEAT_EPIC_IMPROVED_SNEAK_ATTACK_1);
    add_feat_to_list(oPC, "Improved Sneak II", FEAT_EPIC_IMPROVED_SNEAK_ATTACK_2);
    add_feat_to_list(oPC, "Improved Sneak III", FEAT_EPIC_IMPROVED_SNEAK_ATTACK_3);
    add_feat_to_list(oPC, "Improved Sneak IV", FEAT_EPIC_IMPROVED_SNEAK_ATTACK_4);
    add_feat_to_list(oPC, "Improved SR (+2)", FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_1);
    add_feat_to_list(oPC, "Improved SR (+4)", FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_2);
    add_feat_to_list(oPC, "Improved SR (+6)", FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_3);
    add_feat_to_list(oPC, "Improved SR (+8)", FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_4);
    add_feat_to_list(oPC, "Improved SR (+10)", FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_5);
    add_feat_to_list(oPC, "Improved Stunning Fist I", FEAT_EPIC_IMPROVED_STUNNING_FIST_1);
    add_feat_to_list(oPC, "Improved Stunning Fist II", FEAT_EPIC_IMPROVED_STUNNING_FIST_2);
    add_feat_to_list(oPC, "Improved Stunning Fist III", FEAT_EPIC_IMPROVED_STUNNING_FIST_3);
    add_feat_to_list(oPC, "Improved Stunning Fist IV", FEAT_EPIC_IMPROVED_STUNNING_FIST_4);
    add_feat_to_list(oPC, "Improved Whirlwind Attack", FEAT_IMPROVED_WHIRLWIND);
    add_feat_to_list(oPC, "Lasting Inspiration", FEAT_EPIC_LASTING_INSPIRATION);
    if (GetKnowsFeat(344, oPC)) add_feat_to_list(oPC, "Ki Strike 4", 697, FALSE, CLASS_TYPE_MONK);
    if (GetKnowsFeat(697, oPC)) add_feat_to_list(oPC, "Ki Strike 5", 698, FALSE, CLASS_TYPE_MONK);
    //add_feat_to_list(oPC, "Outsider Shape", FEAT_EPIC_OUTSIDER_SHAPE);
    //add_feat_to_list(oPC, "OC: Bastard Sword", FEAT_EPIC_OVERWHELMING_CRITICAL_BASTARDSWORD);
    add_feat_to_list(oPC, "OC: Battleaxe", FEAT_EPIC_OVERWHELMING_CRITICAL_BATTLEAXE);
    add_feat_to_list(oPC, "OC: Club", FEAT_EPIC_OVERWHELMING_CRITICAL_CLUB);
    add_feat_to_list(oPC, "OC: Creature Weapon", FEAT_EPIC_OVERWHELMING_CRITICAL_CREATURE);
    add_feat_to_list(oPC, "OC: Dagger", FEAT_EPIC_OVERWHELMING_CRITICAL_DAGGER);
    add_feat_to_list(oPC, "OC: Dart", FEAT_EPIC_OVERWHELMING_CRITICAL_DART);
    add_feat_to_list(oPC, "OC: Dire Mace", FEAT_EPIC_OVERWHELMING_CRITICAL_DIREMACE);
    add_feat_to_list(oPC, "OC: Double Axe", FEAT_EPIC_OVERWHELMING_CRITICAL_DOUBLEAXE);
    add_feat_to_list(oPC, "OC: Dwarven Waraxe", FEAT_EPIC_OVERWHELMING_CRITICAL_DWAXE);
    add_feat_to_list(oPC, "OC: Greataxe", FEAT_EPIC_OVERWHELMING_CRITICAL_GREATAXE);
    add_feat_to_list(oPC, "OC: Greatsword", FEAT_EPIC_OVERWHELMING_CRITICAL_GREATSWORD);
    add_feat_to_list(oPC, "OC: Halberd", FEAT_EPIC_OVERWHELMING_CRITICAL_HALBERD);
    add_feat_to_list(oPC, "OC: Handaxe", FEAT_EPIC_OVERWHELMING_CRITICAL_HANDAXE);
    add_feat_to_list(oPC, "OC: Heavy Crossbow", FEAT_EPIC_OVERWHELMING_CRITICAL_HEAVYCROSSBOW);
    add_feat_to_list(oPC, "OC: Heavy Flail", FEAT_EPIC_OVERWHELMING_CRITICAL_HEAVYFLAIL);
    add_feat_to_list(oPC, "OC: Kama", FEAT_EPIC_OVERWHELMING_CRITICAL_KAMA);
    add_feat_to_list(oPC, "OC: Katana", FEAT_EPIC_OVERWHELMING_CRITICAL_KATANA);
    add_feat_to_list(oPC, "OC: Kukri", FEAT_EPIC_OVERWHELMING_CRITICAL_KUKRI);
    add_feat_to_list(oPC, "OC: Light Crossbow", FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTCROSSBOW);
    add_feat_to_list(oPC, "OC: Light Flail", FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTFLAIL);
    add_feat_to_list(oPC, "OC: Light Hammer", FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTHAMMER);
    add_feat_to_list(oPC, "OC: Light Mace", FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTMACE);
    add_feat_to_list(oPC, "OC: Longbow", FEAT_EPIC_OVERWHELMING_CRITICAL_LONGBOW);
    add_feat_to_list(oPC, "OC: Longsword", FEAT_EPIC_OVERWHELMING_CRITICAL_LONGSWORD);
    add_feat_to_list(oPC, "OC: Morningstar", FEAT_EPIC_OVERWHELMING_CRITICAL_MORNINGSTAR);
    add_feat_to_list(oPC, "OC: Quarterstaff", FEAT_EPIC_OVERWHELMING_CRITICAL_QUARTERSTAFF);
    add_feat_to_list(oPC, "OC: Rapier", FEAT_EPIC_OVERWHELMING_CRITICAL_RAPIER);
    add_feat_to_list(oPC, "OC: Scimitar", FEAT_EPIC_OVERWHELMING_CRITICAL_SCIMITAR);
    add_feat_to_list(oPC, "OC: Scythe", FEAT_EPIC_OVERWHELMING_CRITICAL_SCYTHE);
    add_feat_to_list(oPC, "OC: Shortbow", FEAT_EPIC_OVERWHELMING_CRITICAL_SHORTBOW);
    add_feat_to_list(oPC, "OC: Shortspear", FEAT_EPIC_OVERWHELMING_CRITICAL_SHORTSPEAR);
    add_feat_to_list(oPC, "OC: Shortsword", FEAT_EPIC_OVERWHELMING_CRITICAL_SHORTSWORD);
    add_feat_to_list(oPC, "OC: Shuriken", FEAT_EPIC_OVERWHELMING_CRITICAL_SHURIKEN);
    add_feat_to_list(oPC, "OC: Sickle", FEAT_EPIC_OVERWHELMING_CRITICAL_SICKLE);
    add_feat_to_list(oPC, "OC: Sling", FEAT_EPIC_OVERWHELMING_CRITICAL_SLING);
    add_feat_to_list(oPC, "OC: Throwing Axe", FEAT_EPIC_OVERWHELMING_CRITICAL_THROWINGAXE);
    add_feat_to_list(oPC, "OC: Trident", FEAT_EPIC_OVERWHELMING_CRITICAL_TRIDENT);
    add_feat_to_list(oPC, "OC: Two-bladed Sword", FEAT_EPIC_OVERWHELMING_CRITICAL_TWOBLADEDSWORD);
    add_feat_to_list(oPC, "OC: Unarmed Strike", FEAT_EPIC_OVERWHELMING_CRITICAL_UNARMED);
    add_feat_to_list(oPC, "OC: Warhammer", FEAT_EPIC_OVERWHELMING_CRITICAL_WARHAMMER);
    add_feat_to_list(oPC, "OC: Whip", FEAT_EPIC_OVERWHELMING_CRITICAL_WHIP);
    add_feat_to_list(oPC, "Perfect Health", FEAT_EPIC_PERFECT_HEALTH);
    add_feat_to_list(oPC, "Epic Prowess", FEAT_EPIC_PROWESS);
    add_feat_to_list(oPC, "Epic Reflexes", FEAT_EPIC_REFLEXES);
    add_feat_to_list(oPC, "Epic Reputation", FEAT_EPIC_REPUTATION);
    add_feat_to_list(oPC, "Self Concealment (10%)", FEAT_EPIC_SELF_CONCEALMENT_10);
    //add_feat_to_list(oPC, "Self Concealment (20%)", FEAT_EPIC_SELF_CONCEALMENT_20);
    //add_feat_to_list(oPC, "Self Concealment (30%)", FEAT_EPIC_SELF_CONCEALMENT_30);
    //add_feat_to_list(oPC, "Self Concealment (40%)", FEAT_EPIC_SELF_CONCEALMENT_40);
    //add_feat_to_list(oPC, "Self Concealment (50%)", FEAT_EPIC_SELF_CONCEALMENT_50);
    add_feat_to_list(oPC, "Epic Skill Focus: Appraise", FEAT_EPIC_SKILL_FOCUS_APPRAISE);
    add_feat_to_list(oPC, "Epic Skill Focus: Animal Empathy", FEAT_EPIC_SKILL_FOCUS_ANIMAL_EMPATHY);
    add_feat_to_list(oPC, "Epic Skill Focus: Bluff", FEAT_EPIC_SKILL_FOCUS_BLUFF);
    add_feat_to_list(oPC, "Epic Skill Focus: Concentration", FEAT_EPIC_SKILL_FOCUS_CONCENTRATION);
    //add_feat_to_list(oPC, "Epic Skill Focus: Craft Armor", FEAT_EPIC_SKILL_FOCUS_CRAFT_ARMOR);
    add_feat_to_list(oPC, "Epic Skill Focus: Craft Trap", FEAT_EPIC_SKILL_FOCUS_CRAFT_TRAP);
    //add_feat_to_list(oPC, "Epic Skill Focus: Craft Weapon", FEAT_EPIC_SKILL_FOCUS_CRAFT_WEAPON);
    add_feat_to_list(oPC, "Epic Skill Focus: Disable Trap", FEAT_EPIC_SKILL_FOCUS_DISABLETRAP);
    add_feat_to_list(oPC, "Epic Skill Focus: Discipline", FEAT_EPIC_SKILL_FOCUS_DISCIPLINE);
    add_feat_to_list(oPC, "Epic Skill Focus: Heal", FEAT_EPIC_SKILL_FOCUS_HEAL);
    add_feat_to_list(oPC, "Epic Skill Focus: Hide", FEAT_EPIC_SKILL_FOCUS_HIDE);
    add_feat_to_list(oPC, "Epic Skill Focus: Intimidate", FEAT_EPIC_SKILL_FOCUS_INTIMIDATE);
    add_feat_to_list(oPC, "Epic Skill Focus: Listen", FEAT_EPIC_SKILL_FOCUS_LISTEN);
    add_feat_to_list(oPC, "Epic Skill Focus: Lore", FEAT_EPIC_SKILL_FOCUS_LORE);
    add_feat_to_list(oPC, "Epic Skill Focus: Move Silently", FEAT_EPIC_SKILL_FOCUS_MOVESILENTLY);
    add_feat_to_list(oPC, "Epic Skill Focus: Open Lock", FEAT_EPIC_SKILL_FOCUS_OPENLOCK);
    add_feat_to_list(oPC, "Epic Skill Focus: Parry", FEAT_EPIC_SKILL_FOCUS_PARRY);
    add_feat_to_list(oPC, "Epic Skill Focus: Perform", FEAT_EPIC_SKILL_FOCUS_PERFORM);
    add_feat_to_list(oPC, "Epic Skill Focus: Persuade", FEAT_EPIC_SKILL_FOCUS_PERSUADE);
    add_feat_to_list(oPC, "Epic Skill Focus: Pick Pocket", FEAT_EPIC_SKILL_FOCUS_PICKPOCKET);
    add_feat_to_list(oPC, "Epic Skill Focus: Search", FEAT_EPIC_SKILL_FOCUS_SEARCH);
    add_feat_to_list(oPC, "Epic Skill Focus: Set Trap", FEAT_EPIC_SKILL_FOCUS_SETTRAP);
    add_feat_to_list(oPC, "Epic Skill Focus: Spellcraft", FEAT_EPIC_SKILL_FOCUS_SPELLCRAFT);
    add_feat_to_list(oPC, "Epic Skill Focus: Spot", FEAT_EPIC_SKILL_FOCUS_SPOT);
    add_feat_to_list(oPC, "Epic Skill Focus: Taunt", FEAT_EPIC_SKILL_FOCUS_TAUNT);
    add_feat_to_list(oPC, "Epic Skill Focus: Tumble", FEAT_EPIC_SKILL_FOCUS_TUMBLE);
    add_feat_to_list(oPC, "Epic Skill Focus: Use Magic Device", FEAT_EPIC_SKILL_FOCUS_USEMAGICDEVICE);

    if (GetLevelByClass(CLASS_TYPE_BARD,oPC) ||
        GetLevelByClass(CLASS_TYPE_CLERIC,oPC) ||
	    GetLevelByClass(CLASS_TYPE_FAVOURED_SOUL, oPC) ||
        GetLevelByClass(CLASS_TYPE_DRUID,oPC) ||
        GetLevelByClass(CLASS_TYPE_RANGER, oPC) >=4 ||
        GetLevelByClass(CLASS_TYPE_PALADIN, oPC) >= 4 ||
        GetLevelByClass(CLASS_TYPE_SORCERER,oPC) ||
        GetLevelByClass(CLASS_TYPE_WIZARD,oPC))
    {
	  if (GetLevelByClass(CLASS_TYPE_WIZARD, oNPC) || 
	      GetLevelByClass(CLASS_TYPE_SORCERER, oNPC) ||
	      GetLevelByClass(CLASS_TYPE_DRUID, oNPC) ||
	      GetLevelByClass(CLASS_TYPE_CLERIC, oNPC) ||
	      GetLevelByClass(CLASS_TYPE_FAVOURED_SOUL, oNPC) ||
	      GetLevelByClass(CLASS_TYPE_BARD, oNPC))
  
	  {
        add_feat_to_list(oPC, "Epic Spell Focus: Abjuration", FEAT_EPIC_SPELL_FOCUS_ABJURATION);
        add_feat_to_list(oPC, "Epic Spell Focus: Conjuration", FEAT_EPIC_SPELL_FOCUS_CONJURATION);
        add_feat_to_list(oPC, "Epic Spell Focus: Divination", FEAT_EPIC_SPELL_FOCUS_DIVINATION);
        add_feat_to_list(oPC, "Epic Spell Focus: Enchantment", FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT);
        add_feat_to_list(oPC, "Epic Spell Focus: Evocation", FEAT_EPIC_SPELL_FOCUS_EVOCATION);
        add_feat_to_list(oPC, "Epic Spell Focus: Illusion", FEAT_EPIC_SPELL_FOCUS_ILLUSION);
        add_feat_to_list(oPC, "Epic Spell Focus: Necromancy", FEAT_EPIC_SPELL_FOCUS_NECROMANCY);
        add_feat_to_list(oPC, "Epic Spell Focus: Transmutation", FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION);
        add_feat_to_list(oPC, "Epic Spell Penetration", FEAT_EPIC_SPELL_PENETRATION);
		if (!GetLevelByClass(CLASS_TYPE_DRUID, oPC)) add_feat_to_list(oPC, "Mummy Dust", FEAT_EPIC_SPELL_MUMMY_DUST);
		
	    if (miSSGetIsSpellsword(oPC) && !GetLocalInt(gsPCGetCreatureHide(oPC), "SS_GREATER_IMBUE")) add_feat_to_list(oPC, "Spellsword Greater Imbue", 10016, TRUE);
	  }		  
    }	
		
    if ( GetLevelByClass(CLASS_TYPE_RANGER, oPC) &&
	     (GetLevelByClass(CLASS_TYPE_RANGER, oNPC) || GetLevelByClass(CLASS_TYPE_HARPER, oNPC)) ) 
      add_feat_to_list(oPC, "Bane of Enemies", FEAT_EPIC_BANE_OF_ENEMIES, FALSE, CLASS_TYPE_RANGER);
    else if (GetLevelByClass(CLASS_TYPE_HARPER, oPC) && 
	     (GetLevelByClass(CLASS_TYPE_RANGER, oNPC) || GetLevelByClass(CLASS_TYPE_HARPER, oNPC)) ) 
      add_feat_to_list(oPC, "Bane of Enemies", FEAT_EPIC_BANE_OF_ENEMIES, FALSE, CLASS_TYPE_HARPER);

    add_feat_to_list(oPC, "Superior Initiative", FEAT_EPIC_SUPERIOR_INITIATIVE);
    //add_feat_to_list(oPC, "Superior Weapon Focus", FEAT_EPIC_SUPERIOR_WEAPON_FOCUS);
    add_feat_to_list(oPC, "Mighty Rage", FEAT_MIGHTY_RAGE);
    add_feat_to_list(oPC, "Terrifying Rage", FEAT_EPIC_TERRIFYING_RAGE);
    add_feat_to_list(oPC, "Thundering Rage", FEAT_EPIC_THUNDERING_RAGE);
    add_feat_to_list(oPC, "Epic Toughness (+20)", FEAT_EPIC_TOUGHNESS_1);
    add_feat_to_list(oPC, "Epic Toughness (+20)", FEAT_EPIC_TOUGHNESS_2);
    //add_feat_to_list(oPC, "Epic Toughness (+20)", FEAT_EPIC_TOUGHNESS_3);
    //add_feat_to_list(oPC, "Epic Toughness (+20)", FEAT_EPIC_TOUGHNESS_4);
    //add_feat_to_list(oPC, "Epic Weapon Focus: Bastard Sword", FEAT_EPIC_WEAPON_FOCUS_BASTARDSWORD);
    add_feat_to_list(oPC, "Epic Weapon Focus: Battleaxe", FEAT_EPIC_WEAPON_FOCUS_BATTLEAXE);
    add_feat_to_list(oPC, "Epic Weapon Focus: Club", FEAT_EPIC_WEAPON_FOCUS_CLUB);
    add_feat_to_list(oPC, "Epic Weapon Focus: Creature Weapon", FEAT_EPIC_WEAPON_FOCUS_CREATURE);
    add_feat_to_list(oPC, "Epic Weapon Focus: Dagger", FEAT_EPIC_WEAPON_FOCUS_DAGGER);
    add_feat_to_list(oPC, "Epic Weapon Focus: Dart", FEAT_EPIC_WEAPON_FOCUS_DART);
    add_feat_to_list(oPC, "Epic Weapon Focus: Dire Mace", FEAT_EPIC_WEAPON_FOCUS_DIREMACE);
    add_feat_to_list(oPC, "Epic Weapon Focus: Double Axe", FEAT_EPIC_WEAPON_FOCUS_DOUBLEAXE);
    add_feat_to_list(oPC, "Epic Weapon Focus: Dwarven Waraxe", FEAT_EPIC_WEAPON_FOCUS_DWAXE);
    add_feat_to_list(oPC, "Epic Weapon Focus: Greataxe", FEAT_EPIC_WEAPON_FOCUS_GREATAXE);
    add_feat_to_list(oPC, "Epic Weapon Focus: Greatsword", FEAT_EPIC_WEAPON_FOCUS_GREATSWORD);
    add_feat_to_list(oPC, "Epic Weapon Focus: Halberd", FEAT_EPIC_WEAPON_FOCUS_HALBERD);
    add_feat_to_list(oPC, "Epic Weapon Focus: Handaxe", FEAT_EPIC_WEAPON_FOCUS_HANDAXE);
    add_feat_to_list(oPC, "Epic Weapon Focus: Heavy Crossbow", FEAT_EPIC_WEAPON_FOCUS_HEAVYCROSSBOW);
    add_feat_to_list(oPC, "Epic Weapon Focus: Heavy Flail", FEAT_EPIC_WEAPON_FOCUS_HEAVYFLAIL);
    add_feat_to_list(oPC, "Epic Weapon Focus: Kama", FEAT_EPIC_WEAPON_FOCUS_KAMA);
    add_feat_to_list(oPC, "Epic Weapon Focus: Katana", FEAT_EPIC_WEAPON_FOCUS_KATANA);
    add_feat_to_list(oPC, "Epic Weapon Focus: Kukri", FEAT_EPIC_WEAPON_FOCUS_KUKRI);
    add_feat_to_list(oPC, "Epic Weapon Focus: Light Crossbow", FEAT_EPIC_WEAPON_FOCUS_LIGHTCROSSBOW);
    add_feat_to_list(oPC, "Epic Weapon Focus: Light Flail", FEAT_EPIC_WEAPON_FOCUS_LIGHTFLAIL);
    add_feat_to_list(oPC, "Epic Weapon Focus: Light Hammer", FEAT_EPIC_WEAPON_FOCUS_LIGHTHAMMER);
    add_feat_to_list(oPC, "Epic Weapon Focus: Light Mace", FEAT_EPIC_WEAPON_FOCUS_LIGHTMACE);
    add_feat_to_list(oPC, "Epic Weapon Focus: Longbow", FEAT_EPIC_WEAPON_FOCUS_LONGBOW);
    add_feat_to_list(oPC, "Epic Weapon Focus: Longsword", FEAT_EPIC_WEAPON_FOCUS_LONGSWORD);
    add_feat_to_list(oPC, "Epic Weapon Focus: Morningstar", FEAT_EPIC_WEAPON_FOCUS_MORNINGSTAR);
    add_feat_to_list(oPC, "Epic Weapon Focus: Quarterstaff", FEAT_EPIC_WEAPON_FOCUS_QUARTERSTAFF);
    add_feat_to_list(oPC, "Epic Weapon Focus: Rapier", FEAT_EPIC_WEAPON_FOCUS_RAPIER);
    add_feat_to_list(oPC, "Epic Weapon Focus: Scimitar", FEAT_EPIC_WEAPON_FOCUS_SCIMITAR);
    add_feat_to_list(oPC, "Epic Weapon Focus: Scythe", FEAT_EPIC_WEAPON_FOCUS_SCYTHE);
    add_feat_to_list(oPC, "Epic Weapon Focus: Shortbow", FEAT_EPIC_WEAPON_FOCUS_SHORTBOW);
    add_feat_to_list(oPC, "Epic Weapon Focus: Shortspear", FEAT_EPIC_WEAPON_FOCUS_SHORTSPEAR);
    add_feat_to_list(oPC, "Epic Weapon Focus: Shortsword", FEAT_EPIC_WEAPON_FOCUS_SHORTSWORD);
    add_feat_to_list(oPC, "Epic Weapon Focus: Shuriken", FEAT_EPIC_WEAPON_FOCUS_SHURIKEN);
    add_feat_to_list(oPC, "Epic Weapon Focus: Sickle", FEAT_EPIC_WEAPON_FOCUS_SICKLE);
    add_feat_to_list(oPC, "Epic Weapon Focus: Sling", FEAT_EPIC_WEAPON_FOCUS_SLING);
    add_feat_to_list(oPC, "Epic Weapon Focus: Throwing Axe", FEAT_EPIC_WEAPON_FOCUS_THROWINGAXE);
    add_feat_to_list(oPC, "Epic Weapon Focus: Trident", FEAT_EPIC_WEAPON_FOCUS_TRIDENT);
    add_feat_to_list(oPC, "Epic Weapon Focus: Two-bladed Sword", FEAT_EPIC_WEAPON_FOCUS_TWOBLADEDSWORD);
    add_feat_to_list(oPC, "Epic Weapon Focus: Unarmed Strike", FEAT_EPIC_WEAPON_FOCUS_UNARMED);
    add_feat_to_list(oPC, "Epic Weapon Focus: Warhammer", FEAT_EPIC_WEAPON_FOCUS_WARHAMMER);
    add_feat_to_list(oPC, "Epic Weapon Focus: Whip", FEAT_EPIC_WEAPON_FOCUS_WHIP);
    add_feat_to_list(oPC, "Epic Will", FEAT_EPIC_WILL);
    //add_feat_to_list(oPC, "Undead Shape", FEAT_EPIC_WILD_SHAPE_UNDEAD);

    if (GetLevelByClass(CLASS_TYPE_FIGHTER, oPC))
    {
      //add_feat_to_list(oPC, "Epic Weapon Spec: Bastard Sword", FEAT_EPIC_WEAPON_SPECIALIZATION_BASTARDSWORD, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Battleaxe", FEAT_EPIC_WEAPON_SPECIALIZATION_BATTLEAXE, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Club", FEAT_EPIC_WEAPON_SPECIALIZATION_CLUB, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Creature Weapon", FEAT_EPIC_WEAPON_SPECIALIZATION_CREATURE, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Dagger", FEAT_EPIC_WEAPON_SPECIALIZATION_DAGGER, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Dart", FEAT_EPIC_WEAPON_SPECIALIZATION_DART, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Dire Mace", FEAT_EPIC_WEAPON_SPECIALIZATION_DIREMACE, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Double Axe", FEAT_EPIC_WEAPON_SPECIALIZATION_DOUBLEAXE, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Dwarven Waraxe", FEAT_EPIC_WEAPON_SPECIALIZATION_DWAXE, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Greataxe", FEAT_EPIC_WEAPON_SPECIALIZATION_GREATAXE, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Greatsword", FEAT_EPIC_WEAPON_SPECIALIZATION_GREATSWORD, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Halberd", FEAT_EPIC_WEAPON_SPECIALIZATION_HALBERD, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Handaxe", FEAT_EPIC_WEAPON_SPECIALIZATION_HANDAXE, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Heavy Crossbow", FEAT_EPIC_WEAPON_SPECIALIZATION_HEAVYCROSSBOW, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Heavy Flail", FEAT_EPIC_WEAPON_SPECIALIZATION_HEAVYFLAIL, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Kama", FEAT_EPIC_WEAPON_SPECIALIZATION_KAMA, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Katana", FEAT_EPIC_WEAPON_SPECIALIZATION_KATANA, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Kukri", FEAT_EPIC_WEAPON_SPECIALIZATION_KUKRI, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Light Crossbow", FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTCROSSBOW, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Light Flail", FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTFLAIL, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Light Hammer", FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTHAMMER, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Light Mace", FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTMACE, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Longsword", FEAT_EPIC_WEAPON_SPECIALIZATION_LONGSWORD, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Longbow", FEAT_EPIC_WEAPON_SPECIALIZATION_LONGBOW, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Morningstar", FEAT_EPIC_WEAPON_SPECIALIZATION_MORNINGSTAR, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Rapier", FEAT_EPIC_WEAPON_SPECIALIZATION_RAPIER, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Scimitar", FEAT_EPIC_WEAPON_SPECIALIZATION_SCIMITAR, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Scythe", FEAT_EPIC_WEAPON_SPECIALIZATION_SCYTHE, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Shortsword", FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTSWORD, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Shortbow", FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTBOW, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Shuriken", FEAT_EPIC_WEAPON_SPECIALIZATION_SHURIKEN, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Sickle", FEAT_EPIC_WEAPON_SPECIALIZATION_SICKLE, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Sling", FEAT_EPIC_WEAPON_SPECIALIZATION_SLING, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Spear", FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTSPEAR, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Staff", FEAT_EPIC_WEAPON_SPECIALIZATION_QUARTERSTAFF, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Throwing Axe", FEAT_EPIC_WEAPON_SPECIALIZATION_THROWINGAXE, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Trident", FEAT_EPIC_WEAPON_SPECIALIZATION_TRIDENT, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Two-bladed Sword", FEAT_EPIC_WEAPON_SPECIALIZATION_TWOBLADEDSWORD, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Unarmed Strike", FEAT_EPIC_WEAPON_SPECIALIZATION_UNARMED, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Warhammer", FEAT_EPIC_WEAPON_SPECIALIZATION_WARHAMMER, FALSE, CLASS_TYPE_FIGHTER);
      add_feat_to_list(oPC, "Epic Weapon Spec: Whip", FEAT_EPIC_WEAPON_SPECIALIZATION_WHIP, FALSE, CLASS_TYPE_FIGHTER);
    }
  }

  //---------------------------------
  // Class specific feats.
  //---------------------------------
  SetLocalString(OBJECT_SELF, CURR_LIST, LIST_5);

  //if (GetSkillRank(SKILL_SPELLCRAFT, oPC, TRUE) >= 5)  add_feat_to_list(oPC, "Animate Dead", FEAT_ANIMATE_DEAD);
  add_feat_to_list(oPC, "Evasion", FEAT_EVASION);
  if (GetAbilityScore(oPC, ABILITY_DEXTERITY, TRUE) >= 18)
     add_feat_to_list(oPC, "Improved Evasion", FEAT_IMPROVED_EVASION);

  ///add_feat_to_list(oPC, "Summon Familiar (Bat)", FEAT_SUMMON_FAMILIAR);
  add_feat_to_list(oPC, "Uncanny Dodge I", FEAT_UNCANNY_DODGE_1);
  add_feat_to_list(oPC, "Uncanny Dodge II", FEAT_UNCANNY_DODGE_2);
  add_feat_to_list(oPC, "Uncanny Dodge III", FEAT_UNCANNY_DODGE_3);
  add_feat_to_list(oPC, "Uncanny Dodge IV", FEAT_UNCANNY_DODGE_4);
  add_feat_to_list(oPC, "Uncanny Dodge V", FEAT_UNCANNY_DODGE_5);
  add_feat_to_list(oPC, "Uncanny Dodge VI", FEAT_UNCANNY_DODGE_6);
  //if (GetKnowsFeat(FEAT_UNCANNY_DODGE_6, oPC)) add_feat_to_list(oPC, "Uncanny Reflex (cannot be flat footed)", FEAT_UNCANNY_REFLEX);
  add_feat_to_list(oPC, "Divine Might", FEAT_DIVINE_MIGHT);
  add_feat_to_list(oPC, "Divine Shield", FEAT_DIVINE_SHIELD);

  // Caster levels and spell slots (custom feats 10006-10013).
  if(GetLevelByClass(CLASS_TYPE_WIZARD, oPC) ||
     GetLevelByClass(CLASS_TYPE_SORCERER, oPC) ||
     GetLevelByClass(CLASS_TYPE_BARD, oPC) ||
     GetLevelByClass(CLASS_TYPE_CLERIC, oPC) ||
	 GetLevelByClass(CLASS_TYPE_FAVOURED_SOUL, oPC) ||
     GetLevelByClass(CLASS_TYPE_DRUID, oPC) ||
     GetLevelByClass(CLASS_TYPE_RANGER, oPC) >=4 ||
     GetLevelByClass(CLASS_TYPE_PALADIN, oPC) >= 4)
  {	
    if (GetLevelByClass(CLASS_TYPE_BARD, oPC) && GetLevelByClass(CLASS_TYPE_BARD, oNPC)) add_feat_to_list(oPC, "Bonus spell slot (Bard)", 10007, TRUE);
    if (GetLevelByClass(CLASS_TYPE_CLERIC, oPC) && GetLevelByClass(CLASS_TYPE_CLERIC, oNPC)) add_feat_to_list(oPC, "Bonus spell slot (Cleric)", 10008, TRUE);
    if (GetLevelByClass(CLASS_TYPE_DRUID, oPC) && GetLevelByClass(CLASS_TYPE_DRUID, oNPC)) add_feat_to_list(oPC, "Bonus spell slot (Druid)", 10009, TRUE);
    if (GetLevelByClass(CLASS_TYPE_PALADIN, oPC) >= 4 && GetLevelByClass(CLASS_TYPE_PALADIN, oNPC)) add_feat_to_list(oPC, "Bonus spell slot (Paladin)", 10010, TRUE);
    if (GetLevelByClass(CLASS_TYPE_RANGER, oPC) >= 4 && GetLevelByClass(CLASS_TYPE_RANGER, oNPC)) add_feat_to_list(oPC, "Bonus spell slot (Ranger)", 10011, TRUE);
    //if (GetLevelByClass(CLASS_TYPE_SORCERER, oPC) && GetLevelByClass(CLASS_TYPE_SORCERER, oNPC)) add_feat_to_list(oPC, "Bonus spell slot (Sorcerer)", 10012, TRUE);
    if (GetLevelByClass(CLASS_TYPE_WIZARD, oPC) && GetLevelByClass(CLASS_TYPE_WIZARD, oNPC)) add_feat_to_list(oPC, "Bonus spell slot (Wizard)", 10013, TRUE);	  
  }

  if (GetLevelByClass(CLASS_TYPE_BARD, oPC) && GetLevelByClass(CLASS_TYPE_BARD, oNPC))
  {
    if (miWAGetIsWarlock(oPC))
    {
      int nWLLevel = miWAGetCasterLevel(oPC);
      if (nWLLevel < 24)
      {
        nWLLevel += 2;
        string sIncrease = "2";
        if(nWLLevel > 24)
        {
          nWLLevel = 24;
          sIncrease = "1";
        }
        add_feat_to_list(oPC, "Warlock level +"+sIncrease+" (New Caster Level: "+IntToString(nWLLevel)+")", 10001, TRUE);
      }
    }
    else
    {
      add_feat_to_list(oPC, "Curse Song", FEAT_CURSE_SONG);
      add_feat_to_list(oPC, "Extra Music", FEAT_EXTRA_MUSIC);
      add_feat_to_list(oPC, "Lingering Song", FEAT_LINGERING_SONG);
      add_feat_to_list(oPC, "+4 Bard levels for song strength purposes, +4 Perform", 10004, TRUE);
    }
  }

  if (GetLevelByClass(CLASS_TYPE_BARBARIAN, oPC) && GetLevelByClass(CLASS_TYPE_BARBARIAN, oNPC))
  {
    // Numbers taken direct from 2da file.
    add_feat_to_list(oPC, "Barbarian Rage II", 326, FALSE, CLASS_TYPE_BARBARIAN);
    add_feat_to_list(oPC, "Barbarian Rage III", 327, FALSE, CLASS_TYPE_BARBARIAN);
    if (nPCLevel > 11) add_feat_to_list(oPC, "Barbarian Rage IV", 328, FALSE, CLASS_TYPE_BARBARIAN);
    if (nPCLevel > 14) add_feat_to_list(oPC, "Barbarian Rage V (Greater Rage)", 329, FALSE, CLASS_TYPE_BARBARIAN);
    if (nPCLevel > 15) add_feat_to_list(oPC, "Barbarian Rage VI", 330, FALSE, CLASS_TYPE_BARBARIAN);
    if (nPCLevel > 19) add_feat_to_list(oPC, "Barbarian Rage VII", 331, FALSE, CLASS_TYPE_BARBARIAN);

    if (nPCLevel > 10 && GetLevelByClass(CLASS_TYPE_BARBARIAN, oPC) >= 2) add_feat_to_list(oPC, "Barbarian DR 1", 196, FALSE, CLASS_TYPE_BARBARIAN);
    if (nPCLevel > 13 && GetLevelByClass(CLASS_TYPE_BARBARIAN, oPC) >= 4) add_feat_to_list(oPC, "Barbarian DR 2", 332, FALSE, CLASS_TYPE_BARBARIAN);
    if (nPCLevel > 16 && GetLevelByClass(CLASS_TYPE_BARBARIAN, oPC) >= 6) add_feat_to_list(oPC, "Barbarian DR 3", 333, FALSE, CLASS_TYPE_BARBARIAN);
    if (nPCLevel > 19 && GetLevelByClass(CLASS_TYPE_BARBARIAN, oPC) >= 8) add_feat_to_list(oPC, "Barbarian DR 4", 334, FALSE, CLASS_TYPE_BARBARIAN);
  }

  if (GetLevelByClass(CLASS_TYPE_DRUID, oPC) && GetLevelByClass(CLASS_TYPE_DRUID, oNPC))
  {
    add_feat_to_list(oPC, "Wildshape II", 335, FALSE, CLASS_TYPE_DRUID);
    add_feat_to_list(oPC, "Wildshape III", 336, FALSE, CLASS_TYPE_DRUID);
    if (nPCLevel > 9) add_feat_to_list(oPC, "Wildshape IV", 337, FALSE, CLASS_TYPE_DRUID);
    if (nPCLevel > 9) add_feat_to_list(oPC, "Wildshape V", 338, FALSE, CLASS_TYPE_DRUID);
    if (nPCLevel > 9) add_feat_to_list(oPC, "Wildshape VI", 339, FALSE, CLASS_TYPE_DRUID);
    if (nPCLevel > 15) add_feat_to_list(oPC, "Elemental Shape I", 304, FALSE, CLASS_TYPE_DRUID);
    if (nPCLevel > 16) add_feat_to_list(oPC, "Elemental Shape II", 340, FALSE, CLASS_TYPE_DRUID);
    if (nPCLevel > 18) add_feat_to_list(oPC, "Elemental Shape III", 341, FALSE, CLASS_TYPE_DRUID);
  }
  
  if (miTOGetTotemAnimalAppearance(oPC) && miTOGetTotemBonus(oPC) < 12)
  {
    add_feat_to_list(oPC, "+2 class levels for totem purposes", 10015, TRUE);
  }

  if (GetLevelByClass(CLASS_TYPE_FIGHTER, oPC) && GetLevelByClass(CLASS_TYPE_FIGHTER, oNPC))
  {
    //add_feat_to_list(oPC, "Weapon Spec: Bastard Sword", FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD, FALSE, CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Battleaxe", FEAT_WEAPON_SPECIALIZATION_BATTLE_AXE, FALSE, CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Club", FEAT_WEAPON_SPECIALIZATION_CLUB, FALSE, CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Creature Weapon", FEAT_WEAPON_SPECIALIZATION_CREATURE, FALSE, CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Dagger", FEAT_WEAPON_SPECIALIZATION_DAGGER, FALSE, CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Dart", FEAT_WEAPON_SPECIALIZATION_DART, FALSE, CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Dire Mace", FEAT_WEAPON_SPECIALIZATION_DIRE_MACE, FALSE, CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Double Axe", FEAT_WEAPON_SPECIALIZATION_DOUBLE_AXE, FALSE, CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Dwarven Waraxe", FEAT_WEAPON_SPECIALIZATION_DWAXE, FALSE, CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Greataxe", FEAT_WEAPON_SPECIALIZATION_GREAT_AXE, FALSE, CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Greatsword", FEAT_WEAPON_SPECIALIZATION_GREAT_SWORD, FALSE, CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Halberd", FEAT_WEAPON_SPECIALIZATION_HALBERD, FALSE, CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Handaxe", FEAT_WEAPON_SPECIALIZATION_HAND_AXE, FALSE, CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Heavy Crossbow", FEAT_WEAPON_SPECIALIZATION_HEAVY_CROSSBOW, FALSE, CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Heavy Flail", FEAT_WEAPON_SPECIALIZATION_HEAVY_FLAIL, FALSE, CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Kama", FEAT_WEAPON_SPECIALIZATION_KAMA, FALSE, CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Katana", FEAT_WEAPON_SPECIALIZATION_KATANA, FALSE, CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Kukri", FEAT_WEAPON_SPECIALIZATION_KUKRI, FALSE, CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Light Crossbow", FEAT_WEAPON_SPECIALIZATION_LIGHT_CROSSBOW, FALSE, CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Light Flail", FEAT_WEAPON_SPECIALIZATION_LIGHT_FLAIL, FALSE, CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Light Hammer", FEAT_WEAPON_SPECIALIZATION_LIGHT_HAMMER, FALSE, CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Light Mace", FEAT_WEAPON_SPECIALIZATION_LIGHT_MACE, FALSE, CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Longsword", FEAT_WEAPON_SPECIALIZATION_LONG_SWORD, FALSE, CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Longbow", FEAT_WEAPON_SPECIALIZATION_LONGBOW, FALSE, CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Morningstar", FEAT_WEAPON_SPECIALIZATION_MORNING_STAR, FALSE, CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Rapier", FEAT_WEAPON_SPECIALIZATION_RAPIER, FALSE, CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Scimitar", FEAT_WEAPON_SPECIALIZATION_SCIMITAR, FALSE, CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Scythe", FEAT_WEAPON_SPECIALIZATION_SCYTHE, FALSE, CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Shortsword", FEAT_WEAPON_SPECIALIZATION_SHORT_SWORD, FALSE, CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Shortbow", FEAT_WEAPON_SPECIALIZATION_SHORTBOW, FALSE, CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Shuriken", FEAT_WEAPON_SPECIALIZATION_SHURIKEN, FALSE, CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Sickle", FEAT_WEAPON_SPECIALIZATION_SICKLE, FALSE, CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Sling", FEAT_WEAPON_SPECIALIZATION_SLING, FALSE, CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Spear", FEAT_WEAPON_SPECIALIZATION_SPEAR, FALSE, CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Staff", FEAT_WEAPON_SPECIALIZATION_STAFF, FALSE, CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Throwing Axe", FEAT_WEAPON_SPECIALIZATION_THROWING_AXE, FALSE, CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Trident", FEAT_WEAPON_SPECIALIZATION_TRIDENT, FALSE, CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Two-bladed Sword", FEAT_WEAPON_SPECIALIZATION_TWO_BLADED_SWORD, FALSE, CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Unarmed Strike", FEAT_WEAPON_SPECIALIZATION_UNARMED_STRIKE, FALSE, CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Warhammer", FEAT_WEAPON_SPECIALIZATION_WAR_HAMMER,FALSE,  CLASS_TYPE_FIGHTER);
    add_feat_to_list(oPC, "Weapon Spec: Whip", FEAT_WEAPON_SPECIALIZATION_WHIP, FALSE, CLASS_TYPE_FIGHTER);
  }

  if ((GetLevelByClass(CLASS_TYPE_RANGER, oPC) && GetLevelByClass(CLASS_TYPE_RANGER, oNPC)) ||
      (GetLevelByClass(CLASS_TYPE_HARPER, oPC) && GetLevelByClass(CLASS_TYPE_HARPER, oNPC)))
  {
    if(GetLevelByClass(CLASS_TYPE_RANGER, oPC))
    {
		add_group_list("Favored Enemy", GROUP_NUMBER_FE, LIST_FE);
		add_feat_to_list(oPC, "Favored Enemy: Aberration", FEAT_FAVORED_ENEMY_ABERRATION, FALSE, CLASS_TYPE_RANGER);
		add_feat_to_list(oPC, "Favored Enemy: Animal", FEAT_FAVORED_ENEMY_ANIMAL, FALSE, CLASS_TYPE_RANGER);
		add_feat_to_list(oPC, "Favored Enemy: Beast", FEAT_FAVORED_ENEMY_BEAST, FALSE, CLASS_TYPE_RANGER);
		add_feat_to_list(oPC, "Favored Enemy: Construct", FEAT_FAVORED_ENEMY_CONSTRUCT, FALSE, CLASS_TYPE_RANGER);
		add_feat_to_list(oPC, "Favored Enemy: Dragon", FEAT_FAVORED_ENEMY_DRAGON, FALSE, CLASS_TYPE_RANGER);
		add_feat_to_list(oPC, "Favored Enemy: Dwarf", FEAT_FAVORED_ENEMY_DWARF, FALSE, CLASS_TYPE_RANGER);
		add_feat_to_list(oPC, "Favored Enemy: Elemental", FEAT_FAVORED_ENEMY_ELEMENTAL, FALSE, CLASS_TYPE_RANGER);
		add_feat_to_list(oPC, "Favored Enemy: Elf", FEAT_FAVORED_ENEMY_ELF, FALSE, CLASS_TYPE_RANGER);
		add_feat_to_list(oPC, "Favored Enemy: Fey", FEAT_FAVORED_ENEMY_FEY, FALSE, CLASS_TYPE_RANGER);
		add_feat_to_list(oPC, "Favored Enemy: Giant", FEAT_FAVORED_ENEMY_GIANT, FALSE, CLASS_TYPE_RANGER);
		add_feat_to_list(oPC, "Favored Enemy: Gnome", FEAT_FAVORED_ENEMY_GNOME, FALSE, CLASS_TYPE_RANGER);
		add_feat_to_list(oPC, "Favored Enemy: Goblinoid", FEAT_FAVORED_ENEMY_GOBLINOID, FALSE, CLASS_TYPE_RANGER);
		add_feat_to_list(oPC, "Favored Enemy: Half-Elf", FEAT_FAVORED_ENEMY_HALFELF, FALSE, CLASS_TYPE_RANGER);
		add_feat_to_list(oPC, "Favored Enemy: Halfling", FEAT_FAVORED_ENEMY_HALFLING, FALSE, CLASS_TYPE_RANGER);
		add_feat_to_list(oPC, "Favored Enemy: Half-Orc", FEAT_FAVORED_ENEMY_HALFORC, FALSE, CLASS_TYPE_RANGER);
		add_feat_to_list(oPC, "Favored Enemy: Human", FEAT_FAVORED_ENEMY_HUMAN, FALSE, CLASS_TYPE_RANGER);
		add_feat_to_list(oPC, "Favored Enemy: Magical Beast", FEAT_FAVORED_ENEMY_MAGICAL_BEAST, FALSE, CLASS_TYPE_RANGER);
		add_feat_to_list(oPC, "Favored Enemy: Monstrous Creature", FEAT_FAVORED_ENEMY_MONSTROUS, FALSE, CLASS_TYPE_RANGER);
		add_feat_to_list(oPC, "Favored Enemy: Orc", FEAT_FAVORED_ENEMY_ORC, FALSE, CLASS_TYPE_RANGER);
		add_feat_to_list(oPC, "Favored Enemy: Outsider", FEAT_FAVORED_ENEMY_OUTSIDER, FALSE, CLASS_TYPE_RANGER);
		add_feat_to_list(oPC, "Favored Enemy: Reptilian", FEAT_FAVORED_ENEMY_REPTILIAN, FALSE, CLASS_TYPE_RANGER);
		add_feat_to_list(oPC, "Favored Enemy: Shapechanger", FEAT_FAVORED_ENEMY_SHAPECHANGER, FALSE, CLASS_TYPE_RANGER);
		add_feat_to_list(oPC, "Favored Enemy: Undead", FEAT_FAVORED_ENEMY_UNDEAD, FALSE, CLASS_TYPE_RANGER);
		add_feat_to_list(oPC, "Favored Enemy: Vermin", FEAT_FAVORED_ENEMY_VERMIN, FALSE, CLASS_TYPE_RANGER);

		SetLocalString(OBJECT_SELF, CURR_LIST, LIST_5);
	
        add_feat_to_list(oPC, "Summon Animal Companion (Wolf)", FEAT_ANIMAL_COMPANION, FALSE, CLASS_TYPE_RANGER);
        if (GetKnowsFeat(374, oPC) && !GetKnowsFeat(20, oPC)) add_feat_to_list(oPC, "Improved Dual Wield", FEAT_IMPROVED_TWO_WEAPON_FIGHTING, TRUE, CLASS_TYPE_RANGER); // Custom!
        add_feat_to_list(oPC, "+4 Ranger levels for nature checks, +4 Animal Empathy", 10014, TRUE);
    }
	else
	{
		add_group_list("Favored Enemy", GROUP_NUMBER_FE, LIST_FE);
		add_feat_to_list(oPC, "Favored Enemy: Aberration", FEAT_FAVORED_ENEMY_ABERRATION, FALSE, CLASS_TYPE_HARPER);
		add_feat_to_list(oPC, "Favored Enemy: Animal", FEAT_FAVORED_ENEMY_ANIMAL, FALSE, CLASS_TYPE_HARPER);
		add_feat_to_list(oPC, "Favored Enemy: Beast", FEAT_FAVORED_ENEMY_BEAST, FALSE, CLASS_TYPE_HARPER);
		add_feat_to_list(oPC, "Favored Enemy: Construct", FEAT_FAVORED_ENEMY_CONSTRUCT, FALSE, CLASS_TYPE_HARPER);
		add_feat_to_list(oPC, "Favored Enemy: Dragon", FEAT_FAVORED_ENEMY_DRAGON, FALSE, CLASS_TYPE_HARPER);
		add_feat_to_list(oPC, "Favored Enemy: Dwarf", FEAT_FAVORED_ENEMY_DWARF, FALSE, CLASS_TYPE_HARPER);
		add_feat_to_list(oPC, "Favored Enemy: Elemental", FEAT_FAVORED_ENEMY_ELEMENTAL, FALSE, CLASS_TYPE_HARPER);
		add_feat_to_list(oPC, "Favored Enemy: Elf", FEAT_FAVORED_ENEMY_ELF, FALSE, CLASS_TYPE_HARPER);
		add_feat_to_list(oPC, "Favored Enemy: Fey", FEAT_FAVORED_ENEMY_FEY, FALSE, CLASS_TYPE_HARPER);
		add_feat_to_list(oPC, "Favored Enemy: Giant", FEAT_FAVORED_ENEMY_GIANT, FALSE, CLASS_TYPE_HARPER);
		add_feat_to_list(oPC, "Favored Enemy: Gnome", FEAT_FAVORED_ENEMY_GNOME, FALSE, CLASS_TYPE_HARPER);
		add_feat_to_list(oPC, "Favored Enemy: Goblinoid", FEAT_FAVORED_ENEMY_GOBLINOID, FALSE, CLASS_TYPE_HARPER);
		add_feat_to_list(oPC, "Favored Enemy: Half-Elf", FEAT_FAVORED_ENEMY_HALFELF, FALSE, CLASS_TYPE_HARPER);
		add_feat_to_list(oPC, "Favored Enemy: Halfling", FEAT_FAVORED_ENEMY_HALFLING, FALSE, CLASS_TYPE_HARPER);
		add_feat_to_list(oPC, "Favored Enemy: Half-Orc", FEAT_FAVORED_ENEMY_HALFORC, FALSE, CLASS_TYPE_HARPER);
		add_feat_to_list(oPC, "Favored Enemy: Human", FEAT_FAVORED_ENEMY_HUMAN, FALSE, CLASS_TYPE_HARPER);
		add_feat_to_list(oPC, "Favored Enemy: Magical Beast", FEAT_FAVORED_ENEMY_MAGICAL_BEAST, FALSE, CLASS_TYPE_HARPER);
		add_feat_to_list(oPC, "Favored Enemy: Monstrous Creature", FEAT_FAVORED_ENEMY_MONSTROUS, FALSE, CLASS_TYPE_HARPER);
		add_feat_to_list(oPC, "Favored Enemy: Orc", FEAT_FAVORED_ENEMY_ORC, FALSE, CLASS_TYPE_HARPER);
		add_feat_to_list(oPC, "Favored Enemy: Outsider", FEAT_FAVORED_ENEMY_OUTSIDER, FALSE, CLASS_TYPE_HARPER);
		add_feat_to_list(oPC, "Favored Enemy: Reptilian", FEAT_FAVORED_ENEMY_REPTILIAN, FALSE, CLASS_TYPE_HARPER);
		add_feat_to_list(oPC, "Favored Enemy: Shapechanger", FEAT_FAVORED_ENEMY_SHAPECHANGER, FALSE, CLASS_TYPE_HARPER);
		add_feat_to_list(oPC, "Favored Enemy: Undead", FEAT_FAVORED_ENEMY_UNDEAD, FALSE, CLASS_TYPE_HARPER);
		add_feat_to_list(oPC, "Favored Enemy: Vermin", FEAT_FAVORED_ENEMY_VERMIN, FALSE, CLASS_TYPE_HARPER);

		SetLocalString(OBJECT_SELF, CURR_LIST, LIST_5);
	}
  }

  if (GetLevelByClass(CLASS_TYPE_MONK, oPC) && GetLevelByClass(CLASS_TYPE_MONK, oNPC))
  {
    if (nPCLevel > 10) add_feat_to_list(oPC, "Diamond Body", FEAT_DIAMOND_BODY, FALSE, CLASS_TYPE_MONK);
    if (nPCLevel > 11) add_feat_to_list(oPC, "Diamond Soul", FEAT_DIAMOND_SOUL, FALSE, CLASS_TYPE_MONK);
    if (nPCLevel > 17) add_feat_to_list(oPC, "Empty Body", FEAT_EMPTY_BODY, FALSE, CLASS_TYPE_MONK);
    add_feat_to_list(oPC, "Ki Strike", FEAT_KI_STRIKE, FALSE, CLASS_TYPE_MONK);
    if (GetKnowsFeat(FEAT_KI_STRIKE, oPC)) add_feat_to_list(oPC, "Ki Strike 2", 343, FALSE, CLASS_TYPE_MONK);
    if (GetKnowsFeat(343, oPC)) add_feat_to_list(oPC, "Ki Strike 3", 344, FALSE, CLASS_TYPE_MONK);
    if (nPCLevel > 19) add_feat_to_list(oPC, "Perfect Self", FEAT_PERFECT_SELF, FALSE, CLASS_TYPE_MONK);
    add_feat_to_list(oPC, "Purity of Body", FEAT_PURITY_OF_BODY, FALSE, CLASS_TYPE_MONK);
    if (nPCLevel > 14) add_feat_to_list(oPC, "Quivering Palm", FEAT_QUIVERING_PALM, FALSE, CLASS_TYPE_MONK);
    add_feat_to_list(oPC, "Still Mind", FEAT_STILL_MIND, FALSE, CLASS_TYPE_MONK);
    add_feat_to_list(oPC, "Wholeness of Body", FEAT_WHOLENESS_OF_BODY, FALSE, CLASS_TYPE_MONK);
  }

  if (GetLevelByClass(CLASS_TYPE_PALADIN, oPC) && GetLevelByClass(CLASS_TYPE_PALADIN, oNPC))
  {
    add_feat_to_list(oPC, "Aura of Courage", FEAT_AURA_OF_COURAGE, FALSE, CLASS_TYPE_PALADIN);
    add_feat_to_list(oPC, "Smite Evil", FEAT_SMITE_EVIL, FALSE, CLASS_TYPE_PALADIN);
    add_feat_to_list(oPC, "Remove Disease", FEAT_REMOVE_DISEASE, FALSE, CLASS_TYPE_PALADIN);
    add_feat_to_list(oPC, "Turn Undead", FEAT_TURN_UNDEAD, FALSE, CLASS_TYPE_PALADIN);
    if (GetLocalInt(gsPCGetCreatureHide(oPC), "MAY_RIDE_HORSE"))
      add_feat_to_list(oPC, "Summon Mount", FEAT_PALADIN_SUMMON_MOUNT, FALSE, CLASS_TYPE_PALADIN);
  }

  // Rogue special skills.  Requires 'level' 10.
  if (nPCLevel > 10 && GetLevelByClass(CLASS_TYPE_ROGUE, oPC) && GetLevelByClass(CLASS_TYPE_ROGUE, oNPC))
  {
    add_feat_to_list(oPC, "Crippling Strike", FEAT_CRIPPLING_STRIKE, FALSE, CLASS_TYPE_ROGUE);
    add_feat_to_list(oPC, "Defensive Roll", FEAT_DEFENSIVE_ROLL, FALSE, CLASS_TYPE_ROGUE);
    add_feat_to_list(oPC, "Opportunist", FEAT_OPPORTUNIST, FALSE, CLASS_TYPE_ROGUE);
    add_feat_to_list(oPC, "Skill Mastery", FEAT_SKILL_MASTERY, FALSE, CLASS_TYPE_ROGUE);
    add_feat_to_list(oPC, "Slippery Mind", FEAT_SLIPPERY_MIND, FALSE, CLASS_TYPE_ROGUE);
  }

  if (GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, oPC) && GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, oNPC))
  {
    add_feat_to_list(oPC, "Enchant Arrow 2", FEAT_PRESTIGE_ENCHANT_ARROW_2, FALSE, CLASS_TYPE_ARCANE_ARCHER);
    if (GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, oPC) >= 2) add_feat_to_list(oPC, "Enchant Arrow 3", FEAT_PRESTIGE_ENCHANT_ARROW_3, FALSE, CLASS_TYPE_ARCANE_ARCHER);
    if (GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, oPC) >= 2) add_feat_to_list(oPC, "Enchant Arrow 4", FEAT_PRESTIGE_ENCHANT_ARROW_4, FALSE, CLASS_TYPE_ARCANE_ARCHER);
    if (GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, oPC) >= 3) add_feat_to_list(oPC, "Enchant Arrow 5", FEAT_PRESTIGE_ENCHANT_ARROW_5, FALSE, CLASS_TYPE_ARCANE_ARCHER);
    if (GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, oPC) >= 3) add_feat_to_list(oPC, "Enchant Arrow 6", FEAT_PRESTIGE_ENCHANT_ARROW_6, FALSE, CLASS_TYPE_ARCANE_ARCHER);
    add_feat_to_list(oPC, "Imbue Arrow", FEAT_PRESTIGE_IMBUE_ARROW, FALSE, CLASS_TYPE_ARCANE_ARCHER);
    add_feat_to_list(oPC, "Seeker Arrow 1", FEAT_PRESTIGE_SEEKER_ARROW_1, FALSE, CLASS_TYPE_ARCANE_ARCHER);
    // add_feat_to_list(oPC, "Seeker Arrow 2", FEAT_PRESTIGE_SEEKER_ARROW_2, FALSE, CLASS_TYPE_ARCANE_ARCHER);
    if (nPCLevel > 13) add_feat_to_list(oPC, "Hail of Arrows", FEAT_PRESTIGE_HAIL_OF_ARROWS, FALSE, CLASS_TYPE_ARCANE_ARCHER);
    if (nPCLevel > 16) add_feat_to_list(oPC, "Arrow of Death", FEAT_PRESTIGE_ARROW_OF_DEATH, FALSE, CLASS_TYPE_ARCANE_ARCHER);
  }

  if (GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC) && GetLevelByClass(CLASS_TYPE_ASSASSIN, oNPC))
  {
    add_feat_to_list(oPC, "Ghostly Visage", FEAT_PRESTIGE_SPELL_GHOSTLY_VISAGE, FALSE, CLASS_TYPE_ASSASSIN);
    add_feat_to_list(oPC, "Poison Save +5", FEAT_PRESTIGE_POISON_SAVE_5, FALSE, CLASS_TYPE_ASSASSIN);
    add_feat_to_list(oPC, "Darkness", FEAT_PRESTIGE_DARKNESS, FALSE, CLASS_TYPE_ASSASSIN);
    add_feat_to_list(oPC, "Invisibility", FEAT_PRESTIGE_INVISIBILITY_1, FALSE, CLASS_TYPE_ASSASSIN);
    if (GetKnowsFeat(FEAT_PRESTIGE_INVISIBILITY_1, oPC))
      add_feat_to_list(oPC, "Improved Invisibility", FEAT_PRESTIGE_INVISIBILITY_2, FALSE, CLASS_TYPE_ASSASSIN);
  }

  if (GetLevelByClass(CLASS_TYPE_BLACKGUARD, oPC) && GetLevelByClass(CLASS_TYPE_BLACKGUARD, oNPC))
  {
    add_feat_to_list(oPC, "Dark Blessing", FEAT_PRESTIGE_DARK_BLESSING, FALSE, CLASS_TYPE_BLACKGUARD);
    add_feat_to_list(oPC, "Smite Good", FEAT_SMITE_GOOD, FALSE, CLASS_TYPE_BLACKGUARD);
    add_feat_to_list(oPC, "Bull's Strength", FEAT_BULLS_STRENGTH, FALSE, CLASS_TYPE_BLACKGUARD);
    add_feat_to_list(oPC, "Create Undead", SPELLABILITY_BG_CREATEDEAD, FALSE, CLASS_TYPE_BLACKGUARD);
    add_feat_to_list(oPC, "Turn Undead", FEAT_TURN_UNDEAD, FALSE, CLASS_TYPE_BLACKGUARD);
    add_feat_to_list(oPC, "Fiendish Servant", 475, FALSE, CLASS_TYPE_BLACKGUARD);
    add_feat_to_list(oPC, "Inflict Serious Wounds", FEAT_INFLICT_SERIOUS_WOUNDS, FALSE, CLASS_TYPE_BLACKGUARD);
    add_feat_to_list(oPC, "Contagion", FEAT_CONTAGION, FALSE, CLASS_TYPE_BLACKGUARD);
    if (GetKnowsFeat(FEAT_INFLICT_SERIOUS_WOUNDS, oPC))
      add_feat_to_list(oPC, "Inflict Critical Wounds", FEAT_INFLICT_CRITICAL_WOUNDS, FALSE, CLASS_TYPE_BLACKGUARD);

    if (nPCLevel > 30 && GetKnowsFeat(475, oPC))
       add_feat_to_list(oPC, "Improved Fiend", FEAT_EPIC_EPIC_FIEND, FALSE, CLASS_TYPE_BLACKGUARD);
  }

  if (GetLevelByClass(CLASS_TYPE_DIVINE_CHAMPION, oPC) &&
      GetLevelByClass(CLASS_TYPE_DIVINE_CHAMPION, oNPC))
  {
    add_feat_to_list(oPC, "Sacred Defense +1", FEAT_SACRED_DEFENSE_1, FALSE, CLASS_TYPE_DIVINECHAMPION);
    if (GetKnowsFeat(FEAT_SACRED_DEFENSE_1, oPC))
      add_feat_to_list(oPC, "Sacred Defense +2", FEAT_SACRED_DEFENSE_2, FALSE, CLASS_TYPE_DIVINECHAMPION);
    if (GetKnowsFeat(FEAT_SACRED_DEFENSE_2, oPC))
      add_feat_to_list(oPC, "Sacred Defense +3", FEAT_SACRED_DEFENSE_3, FALSE, CLASS_TYPE_DIVINECHAMPION);
    if (GetKnowsFeat(FEAT_SACRED_DEFENSE_3, oPC))
      add_feat_to_list(oPC, "Sacred Defense +4", FEAT_SACRED_DEFENSE_4, FALSE, CLASS_TYPE_DIVINECHAMPION);
    if (GetKnowsFeat(FEAT_SACRED_DEFENSE_4, oPC))
      add_feat_to_list(oPC, "Sacred Defense +5", FEAT_SACRED_DEFENSE_5, FALSE, CLASS_TYPE_DIVINECHAMPION);
    add_feat_to_list(oPC, "Smite Evil", FEAT_SMITE_EVIL, CLASS_TYPE_DIVINECHAMPION);
    add_feat_to_list(oPC, "Divine Wrath", FEAT_DIVINE_WRATH, CLASS_TYPE_DIVINECHAMPION);
  }

  if (GetLevelByClass(CLASS_TYPE_DWARVEN_DEFENDER, oPC) &&
      GetLevelByClass(CLASS_TYPE_DWARVEN_DEFENDER, oNPC))
  {
    add_feat_to_list(oPC, "Defensive Awareness", FEAT_PRESTIGE_DEFENSIVE_AWARENESS_1, FALSE, CLASS_TYPE_DWARVEN_DEFENDER);
    if (GetKnowsFeat(FEAT_PRESTIGE_DEFENSIVE_AWARENESS_1, oPC))
      add_feat_to_list(oPC, "Defensive Awareness 2", FEAT_PRESTIGE_DEFENSIVE_AWARENESS_2, FALSE, CLASS_TYPE_DWARVEN_DEFENDER);
    if (GetKnowsFeat(FEAT_PRESTIGE_DEFENSIVE_AWARENESS_2, oPC))
      add_feat_to_list(oPC, "Defensive Awareness 3", FEAT_PRESTIGE_DEFENSIVE_AWARENESS_3, FALSE, CLASS_TYPE_DWARVEN_DEFENDER);

    if (GetKnowsFeat(FEAT_PRESTIGE_DEFENSIVE_AWARENESS_3, oPC))
      add_feat_to_list(oPC, "Damage Reduction", 948, FALSE, CLASS_TYPE_DWARVEN_DEFENDER);
  }

  if (GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE, oPC) &&
      GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE, oNPC))
  {
    add_feat_to_list(oPC, "Dragon strength", FEAT_DRAGON_ABILITIES, FALSE, CLASS_TYPE_DRAGON_DISCIPLE);
    add_feat_to_list(oPC, "Dragon breath", FEAT_DRAGON_DIS_BREATH, FALSE, CLASS_TYPE_DRAGON_DISCIPLE);
    add_feat_to_list(oPC, "Dragon darkvision", FEAT_DARKVISION, FALSE, CLASS_TYPE_DRAGON_DISCIPLE);
    if (nPCLevel > 14) add_feat_to_list(oPC, "Dragon fire immunity", FEAT_DRAGON_IMMUNE_FIRE, FALSE, CLASS_TYPE_DRAGON_DISCIPLE);
    if (nPCLevel > 14) add_feat_to_list(oPC, "Dragon sleep immunity", FEAT_IMMUNITY_TO_SLEEP, FALSE, CLASS_TYPE_DRAGON_DISCIPLE);
    if (nPCLevel > 20) add_feat_to_list(oPC, "Dragon paralysis immunity", FEAT_DRAGON_IMMUNE_PARALYSIS, FALSE, CLASS_TYPE_DRAGON_DISCIPLE);
  }

  if (GetLevelByClass(CLASS_TYPE_HARPER, oPC) && GetLevelByClass(CLASS_TYPE_HARPER, oNPC))
  {
    int nHarperType  = GetLocalInt(gsPCGetCreatureHide(oPC), VAR_HARPER);
    // add_feat_to_list(oPC, "Sleep", FEAT_HARPER_SLEEP, FALSE, CLASS_TYPE_HARPER);
	
	if(!nHarperType || nHarperType == MI_CL_HARPER_SCOUT)
	{
      add_feat_to_list(oPC, "Deneir's Eye", FEAT_DENEIRS_EYE, FALSE, CLASS_TYPE_HARPER);
      add_feat_to_list(oPC, "Lliira's Heart", FEAT_LLIIRAS_HEART, FALSE, CLASS_TYPE_HARPER);
      add_feat_to_list(oPC, "Cat's Grace", FEAT_HARPER_CATS_GRACE, FALSE, CLASS_TYPE_HARPER);
      add_feat_to_list(oPC, "Eagle's Splendor", FEAT_HARPER_EAGLES_SPLENDOR, FALSE, CLASS_TYPE_HARPER);
      if (nPCLevel > 12) add_feat_to_list(oPC, "Craft Harper Item", FEAT_CRAFT_HARPER_ITEM, FALSE, CLASS_TYPE_HARPER);
      if (nPCLevel > 12) add_feat_to_list(oPC, "Invisibility", FEAT_HARPER_INVISIBILITY, FALSE, CLASS_TYPE_HARPER);
	}
  }

  if (GetLevelByClass(CLASS_TYPE_PALE_MASTER, oPC) &&
      GetLevelByClass(CLASS_TYPE_PALE_MASTER, oNPC))
  {
    add_feat_to_list(oPC, "Animate Dead", FEAT_ANIMATE_DEAD, FALSE, CLASS_TYPE_PALEMASTER);
    add_feat_to_list(oPC, "Darkvision", FEAT_DARKVISION, FALSE, CLASS_TYPE_PALEMASTER);
    add_feat_to_list(oPC, "Deathless Vigor", FEAT_DEATHLESS_VIGOR, FALSE, CLASS_TYPE_PALEMASTER);
    if (nPCLevel > 20 && GetKnowsFeat(FEAT_TOUGH_AS_BONE, oPC)) add_feat_to_list(oPC, "Deathless Mastery", FEAT_DEATHLESS_MASTERY, FALSE, CLASS_TYPE_PALEMASTER);
    if (GetKnowsFeat(FEAT_ANIMATE_DEAD, oPC)) add_feat_to_list(oPC, "Summon Undead", FEAT_SUMMON_UNDEAD, FALSE, CLASS_TYPE_PALEMASTER);
    if (GetKnowsFeat(FEAT_SUMMON_UNDEAD, oPC)) add_feat_to_list(oPC, "Summon Greater Undead", FEAT_SUMMON_GREATER_UNDEAD, FALSE, CLASS_TYPE_PALEMASTER);
    if (nPCLevel > 15) add_feat_to_list(oPC, "Tough as Bone", FEAT_TOUGH_AS_BONE, FALSE, CLASS_TYPE_PALEMASTER);
    if (nPCLevel > 15) add_feat_to_list(oPC, "Deathless Touch", FEAT_DEATHLESS_MASTER_TOUCH, FALSE, CLASS_TYPE_PALEMASTER);
  }

  if (GetLevelByClass(CLASS_TYPE_SHADOWDANCER, oPC) && GetLevelByClass(CLASS_TYPE_SHADOWDANCER, oNPC))
  {
    add_feat_to_list(oPC, "Darkvision", FEAT_DARKVISION, FALSE, CLASS_TYPE_SHADOWDANCER);
    add_feat_to_list(oPC, "Shadow Daze", FEAT_SHADOW_DAZE, FALSE, CLASS_TYPE_SHADOWDANCER);
    add_feat_to_list(oPC, "Shadow Evade", FEAT_SHADOW_EVADE, FALSE, CLASS_TYPE_SHADOWDANCER);
    add_feat_to_list(oPC, "Summon Shadow", FEAT_SUMMON_SHADOW, FALSE, CLASS_TYPE_SHADOWDANCER);
    add_feat_to_list(oPC, "Defensive Roll", FEAT_DEFENSIVE_ROLL, FALSE, CLASS_TYPE_SHADOWDANCER);
    add_feat_to_list(oPC, "Slippery Mind", FEAT_SLIPPERY_MIND, FALSE, CLASS_TYPE_SHADOWDANCER);
    //if (nPCLevel > 20) add_feat_to_list(oPC, "Hide in Plain Sight", FEAT_HIDE_IN_PLAIN_SIGHT, FALSE, CLASS_TYPE_SHADOWDANCER); -- back to granting this at level 1
  }

  if (GetLevelByClass(CLASS_TYPE_SHIFTER, oPC) && GetLevelByClass(CLASS_TYPE_SHIFTER, oNPC))
  {
    add_feat_to_list(oPC, "Greater Wildshape 2", FEAT_GREATER_WILDSHAPE_2, FALSE, CLASS_TYPE_SHIFTER);
    if (GetKnowsFeat(FEAT_GREATER_WILDSHAPE_2, oPC)) add_feat_to_list(oPC, "Infinite Wildshape 1", FEAT_EPIC_SHIFTER_INFINITE_WILDSHAPE_1, FALSE, CLASS_TYPE_SHIFTER);
    if (GetKnowsFeat(FEAT_EPIC_SHIFTER_INFINITE_WILDSHAPE_1, oPC)) add_feat_to_list(oPC, "Greater Wildshape 3", FEAT_GREATER_WILDSHAPE_3, FALSE, CLASS_TYPE_SHIFTER);
    if (GetKnowsFeat(FEAT_GREATER_WILDSHAPE_3, oPC)) add_feat_to_list(oPC, "Infinite Wildshape 2", FEAT_EPIC_SHIFTER_INFINITE_WILDSHAPE_2, FALSE, CLASS_TYPE_SHIFTER);
    if (GetKnowsFeat(FEAT_EPIC_SHIFTER_INFINITE_WILDSHAPE_2, oPC)) add_feat_to_list(oPC, "Greater Wildshape 4", FEAT_GREATER_WILDSHAPE_4, FALSE, CLASS_TYPE_SHIFTER);
    if (GetKnowsFeat(FEAT_GREATER_WILDSHAPE_4, oPC)) add_feat_to_list(oPC, "Infinite Wildshape 3", FEAT_EPIC_SHIFTER_INFINITE_WILDSHAPE_3, FALSE, CLASS_TYPE_SHIFTER);
    if (GetKnowsFeat(FEAT_EPIC_SHIFTER_INFINITE_WILDSHAPE_3, oPC)) add_feat_to_list(oPC, "Humanoid Shape", FEAT_HUMANOID_SHAPE, FALSE, CLASS_TYPE_SHIFTER);
    if (GetKnowsFeat(FEAT_HUMANOID_SHAPE, oPC)) add_feat_to_list(oPC, "Infinite Wildshape 4", FEAT_EPIC_SHIFTER_INFINITE_WILDSHAPE_4, FALSE, CLASS_TYPE_SHIFTER);
    if (GetKnowsFeat(FEAT_EPIC_SHIFTER_INFINITE_WILDSHAPE_4, oPC)) add_feat_to_list(oPC, "Infinite Humanoid Shape", FEAT_EPIC_SHIFTER_INFINITE_HUMANOID_SHAPE, FALSE, CLASS_TYPE_SHIFTER);
  }

  if (GetLevelByClass(CLASS_TYPE_WEAPON_MASTER, oPC) && GetLevelByClass(CLASS_TYPE_WEAPON_MASTER, oNPC))
  {
    if (nPCLevel > 12) add_feat_to_list(oPC, "Increased Multiplier", FEAT_INCREASE_MULTIPLIER, FALSE, CLASS_TYPE_WEAPON_MASTER);
    if (nPCLevel > 15) add_feat_to_list(oPC, "Ki Critical", FEAT_KI_CRITICAL, FALSE, CLASS_TYPE_WEAPON_MASTER);


    //add_feat_to_list(oPC, "Weapon of Choice: Bastard Sword", FEAT_WEAPON_OF_CHOICE_BASTARDSWORD, FALSE, CLASS_TYPE_WEAPON_MASTER);
    add_feat_to_list(oPC, "Weapon of Choice: Battleaxe", FEAT_WEAPON_OF_CHOICE_BATTLEAXE, FALSE, CLASS_TYPE_WEAPON_MASTER);
    add_feat_to_list(oPC, "Weapon of Choice: Club", FEAT_WEAPON_OF_CHOICE_CLUB, FALSE, CLASS_TYPE_WEAPON_MASTER);
    add_feat_to_list(oPC, "Weapon of Choice: Dagger", FEAT_WEAPON_OF_CHOICE_DAGGER, FALSE, CLASS_TYPE_WEAPON_MASTER);
    add_feat_to_list(oPC, "Weapon of Choice: Dire Mace", FEAT_WEAPON_OF_CHOICE_DIREMACE, FALSE, CLASS_TYPE_WEAPON_MASTER);
    add_feat_to_list(oPC, "Weapon of Choice: Double Axe", FEAT_WEAPON_OF_CHOICE_DOUBLEAXE, FALSE, CLASS_TYPE_WEAPON_MASTER);
    add_feat_to_list(oPC, "Weapon of Choice: Dwarven Waraxe", FEAT_WEAPON_OF_CHOICE_DWAXE, FALSE, CLASS_TYPE_WEAPON_MASTER);
    add_feat_to_list(oPC, "Weapon of Choice: Greataxe", FEAT_WEAPON_OF_CHOICE_GREATAXE, FALSE, CLASS_TYPE_WEAPON_MASTER);
    add_feat_to_list(oPC, "Weapon of Choice: Greatsword", FEAT_WEAPON_OF_CHOICE_GREATSWORD, FALSE, CLASS_TYPE_WEAPON_MASTER);
    add_feat_to_list(oPC, "Weapon of Choice: Halberd", FEAT_WEAPON_OF_CHOICE_HALBERD, FALSE, CLASS_TYPE_WEAPON_MASTER);
    add_feat_to_list(oPC, "Weapon of Choice: Handaxe", FEAT_WEAPON_OF_CHOICE_HANDAXE, FALSE, CLASS_TYPE_WEAPON_MASTER);
    add_feat_to_list(oPC, "Weapon of Choice: Heavy Flail", FEAT_WEAPON_OF_CHOICE_HEAVYFLAIL, FALSE, CLASS_TYPE_WEAPON_MASTER);
    add_feat_to_list(oPC, "Weapon of Choice: Kama", FEAT_WEAPON_OF_CHOICE_KAMA, FALSE, CLASS_TYPE_WEAPON_MASTER);
    add_feat_to_list(oPC, "Weapon of Choice: Katana", FEAT_WEAPON_OF_CHOICE_KATANA, FALSE, CLASS_TYPE_WEAPON_MASTER);
    add_feat_to_list(oPC, "Weapon of Choice: Kukri", FEAT_WEAPON_OF_CHOICE_KUKRI, FALSE, CLASS_TYPE_WEAPON_MASTER);
    add_feat_to_list(oPC, "Weapon of Choice: Light Flail", FEAT_WEAPON_OF_CHOICE_LIGHTFLAIL, FALSE, CLASS_TYPE_WEAPON_MASTER);
    add_feat_to_list(oPC, "Weapon of Choice: Light Hammer", FEAT_WEAPON_OF_CHOICE_LIGHTHAMMER, FALSE, CLASS_TYPE_WEAPON_MASTER);
    add_feat_to_list(oPC, "Weapon of Choice: Light Mace", FEAT_WEAPON_OF_CHOICE_LIGHTMACE, FALSE, CLASS_TYPE_WEAPON_MASTER);
    add_feat_to_list(oPC, "Weapon of Choice: Longsword", FEAT_WEAPON_OF_CHOICE_LONGSWORD, FALSE, CLASS_TYPE_WEAPON_MASTER);
    add_feat_to_list(oPC, "Weapon of Choice: Morningstar", FEAT_WEAPON_OF_CHOICE_MORNINGSTAR, FALSE, CLASS_TYPE_WEAPON_MASTER);
    add_feat_to_list(oPC, "Weapon of Choice: Rapier", FEAT_WEAPON_OF_CHOICE_RAPIER, FALSE, CLASS_TYPE_WEAPON_MASTER);
    add_feat_to_list(oPC, "Weapon of Choice: Scimitar", FEAT_WEAPON_OF_CHOICE_SCIMITAR, FALSE, CLASS_TYPE_WEAPON_MASTER);
    add_feat_to_list(oPC, "Weapon of Choice: Scythe", FEAT_WEAPON_OF_CHOICE_SCYTHE, FALSE, CLASS_TYPE_WEAPON_MASTER);
    add_feat_to_list(oPC, "Weapon of Choice: Shortsword", FEAT_WEAPON_OF_CHOICE_SHORTSWORD, FALSE, CLASS_TYPE_WEAPON_MASTER);
    add_feat_to_list(oPC, "Weapon of Choice: Sickle", FEAT_WEAPON_OF_CHOICE_SICKLE, FALSE, CLASS_TYPE_WEAPON_MASTER);
    add_feat_to_list(oPC, "Weapon of Choice: Spear", FEAT_WEAPON_OF_CHOICE_SHORTSPEAR, FALSE, CLASS_TYPE_WEAPON_MASTER);
    add_feat_to_list(oPC, "Weapon of Choice: Staff", FEAT_WEAPON_OF_CHOICE_QUARTERSTAFF, FALSE, CLASS_TYPE_WEAPON_MASTER);
    add_feat_to_list(oPC, "Weapon of Choice: Trident", FEAT_WEAPON_OF_CHOICE_TRIDENT, FALSE, CLASS_TYPE_WEAPON_MASTER);
    add_feat_to_list(oPC, "Weapon of Choice: Two-bladed Sword", FEAT_WEAPON_OF_CHOICE_TWOBLADEDSWORD, FALSE, CLASS_TYPE_WEAPON_MASTER);
    add_feat_to_list(oPC, "Weapon of Choice: Warhammer", FEAT_WEAPON_OF_CHOICE_WARHAMMER, FALSE, CLASS_TYPE_WEAPON_MASTER);
    add_feat_to_list(oPC, "Weapon of Choice: Whip", FEAT_WEAPON_OF_CHOICE_WHIP, FALSE, CLASS_TYPE_WEAPON_MASTER);
  }
  
  if (GetLevelByClass(CLASS_TYPE_PURPLE_DRAGON_KNIGHT, oPC) && GetLevelByClass(CLASS_TYPE_PURPLE_DRAGON_KNIGHT, oNPC))
  {
    add_feat_to_list(oPC, "Heroic Shield", FEAT_PDK_SHIELD, FALSE, CLASS_TYPE_PURPLE_DRAGON_KNIGHT);
    add_feat_to_list(oPC, "Rallying Cry", FEAT_PDK_RALLY, FALSE, CLASS_TYPE_PURPLE_DRAGON_KNIGHT);
    add_feat_to_list(oPC, "Inspire Courage", FEAT_PDK_INSPIRE_1, FALSE, CLASS_TYPE_PURPLE_DRAGON_KNIGHT);
    if (nPCLevel > 8 && GetKnowsFeat(FEAT_PDK_INSPIRE_1, oPC)) add_feat_to_list(oPC, "Inspire Courage II", FEAT_PDK_INSPIRE_2, FALSE, CLASS_TYPE_PURPLE_DRAGON_KNIGHT);
    if (nPCLevel > 8) add_feat_to_list(oPC, "Inspire Fear", FEAT_PDK_FEAR, FALSE, CLASS_TYPE_PURPLE_DRAGON_KNIGHT);
    if (nPCLevel > 10) add_feat_to_list(oPC, "Oath of Wrath", FEAT_PDK_WRATH, FALSE, CLASS_TYPE_PURPLE_DRAGON_KNIGHT);
    if (nPCLevel > 12) add_feat_to_list(oPC, "Final Stand", FEAT_PDK_STAND, FALSE, CLASS_TYPE_PURPLE_DRAGON_KNIGHT);
  }
  
  // Cleric additional domains.  Requires 'level' 10.
  /* These don't work. Sadly.
  if (nPCLevel > 10 && GetLevelByClass(CLASS_TYPE_CLERIC, oPC))
  {
    add_feat_to_list(oPC, "Air domain", FEAT_AIR_DOMAIN_POWER);
    add_feat_to_list(oPC, "Animal domain", FEAT_ANIMAL_DOMAIN_POWER);
    add_feat_to_list(oPC, "Death domain", FEAT_DEATH_DOMAIN_POWER);
    add_feat_to_list(oPC, "Destruction domain", FEAT_DESTRUCTION_DOMAIN_POWER);
    add_feat_to_list(oPC, "Earth domain", FEAT_EARTH_DOMAIN_POWER);
    add_feat_to_list(oPC, "Evil domain", FEAT_EVIL_DOMAIN_POWER);
    add_feat_to_list(oPC, "Fire domain", FEAT_FIRE_DOMAIN_POWER);
    add_feat_to_list(oPC, "Good domain", FEAT_GOOD_DOMAIN_POWER);
    add_feat_to_list(oPC, "Healing domain", FEAT_HEALING_DOMAIN_POWER);
    add_feat_to_list(oPC, "Knowledge domain", FEAT_KNOWLEDGE_DOMAIN_POWER);
    //add_feat_to_list("Luck domain", FEAT_LUCK_DOMAIN_POWER);
    add_feat_to_list(oPC, "Magic domain", FEAT_MAGIC_DOMAIN_POWER);
    add_feat_to_list(oPC, "Plant domain", FEAT_PLANT_DOMAIN_POWER);
    add_feat_to_list(oPC, "Protection domain", FEAT_PROTECTION_DOMAIN_POWER);
    add_feat_to_list(oPC, "Strength domain", FEAT_STRENGTH_DOMAIN_POWER);
    add_feat_to_list(oPC, "Sun domain", FEAT_SUN_DOMAIN_POWER);
    add_feat_to_list(oPC, "Travel domain", FEAT_TRAVEL_DOMAIN_POWER);
    add_feat_to_list(oPC, "Trickery domain", FEAT_TRICKERY_DOMAIN_POWER);
    add_feat_to_list(oPC, "War domain", FEAT_WAR_DOMAIN_POWER);
    add_feat_to_list(oPC, "Water domain", FEAT_WATER_DOMAIN_POWER);
  }
  */

    //End group list
}

void Init()
{
  object oPC  = GetPCSpeaker();
  object oNPC = OBJECT_SELF;

  int nPCLevel = GetLocalInt(gsPCGetCreatureHide(oPC), "FL_LEVEL") + 1;

  float fPCLevel = IntToFloat(GetLocalInt(gsPCGetCreatureHide(oPC), "FL_LEVEL"));

  init_feat_list (oPC);

  // Close out the feat lists.
  AddStringElement("<cþ  >[Back]</c>", LIST_1);
  AddIntElement(-1, LIST_1_IDS);
  AddStringElement("<cþ  >[Back]</c>", LIST_2);
  AddIntElement(-1, LIST_2_IDS);
  AddStringElement("<cþ  >[Back]</c>", LIST_3);
  AddIntElement(-1, LIST_3_IDS);
  AddStringElement("<cþ  >[Back]</c>", LIST_4);
  AddIntElement(-1, LIST_4_IDS);
  AddStringElement("<cþ  >[Back]</c>", LIST_5);
  AddIntElement(-1, LIST_5_IDS);


  AddStringElement("<cþ  >[Back]</c>", LIST_FE);
  AddIntElement(-1, LIST_FE_IDS);
  AddStringElement("<cþ  >[Back]</c>", LIST_IC);
  AddIntElement(-1, LIST_IC_IDS);
  AddStringElement("<cþ  >[Back]</c>", LIST_SF);
  AddIntElement(-1, LIST_SF_IDS);
  AddStringElement("<cþ  >[Back]</c>", LIST_WF);
  AddIntElement(-1, LIST_WF_IDS);

  // Build the main menu.
  DeleteList(CATEGORIES);
  if (GetLevelByClass(CLASS_TYPE_WIZARD, oNPC) || 
      GetLevelByClass(CLASS_TYPE_SORCERER, oNPC) ||
	  GetLevelByClass(CLASS_TYPE_DRUID, oNPC) ||
	  GetLevelByClass(CLASS_TYPE_CLERIC, oNPC) ||
	  GetLevelByClass(CLASS_TYPE_BARD, oNPC))
  {
    AddStringElement("<c  þ>Spell-related feats</c>", CATEGORIES);
  }
  else
  {
    AddStringElement("<cþ  >Spell-related feats</c>", CATEGORIES);
  }  
  
  AddStringElement("<c  þ>Combat-related feats</c>", CATEGORIES);
  AddStringElement("<c  þ>Generic feats</c>", CATEGORIES);
  if (nPCLevel > 30)
    AddStringElement("<c  þ>Epic feats</c>", CATEGORIES);
  else
    AddStringElement("<cþ  >Epic feats</c>", CATEGORIES);
  AddStringElement("<c  þ>Class-related feats</c>", CATEGORIES);

  AddStringElement("<c þ >Cancel</c>", CATEGORIES);

  // Build the confirm menu.
  DeleteList(CONFIRM);
  if (GetElementCount(CONFIRM) == 0)
  {
    AddStringElement("<c þ >[Yes]</c>", CONFIRM);
    AddStringElement("<cþ  >[No]</c>", CONFIRM);
  }

  // Calculate level and cost so we only do this once.
  if (fPCLevel == 0.0f)
  {
    fPCLevel = IntToFloat(GetHitDice(oPC));
    SetLocalInt(gsPCGetCreatureHide(oPC), "FL_LEVEL", GetHitDice(oPC));
  }

  // Older characters won't have an ECL.  If an ECL exists it's
  // baselined at 10.0 - see zdlg_subrace.
  float fCurrentECL = GetLocalFloat(gsPCGetCreatureHide(oPC), "ECL");
  if (fCurrentECL > 0.0) fCurrentECL -= 10.0f;

  fPCLevel += fCurrentECL;
  if (fPCLevel < 1.0f) fPCLevel = 1.0f;

  SetLocalFloat(oPC, CURR_LVL, fPCLevel);
   
  // Factor actual class levels out of the cost calculation.
  // To allow for negative ECL, add 5 to the base cost. 
  fPCLevel -= IntToFloat(GetHitDice(oPC));
  fPCLevel += 5.0f;
  int nGoldCost = FloatToInt(fPCLevel * 500.0f);
  SetLocalInt(oPC, CURR_COST, nGoldCost);
}


void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();

  float fPCLevel = GetLocalFloat(oPC, CURR_LVL);
  int nSystemLevel = GetLocalInt(gsPCGetCreatureHide(oPC), "FL_LEVEL");
  int nGold = GetLocalInt(oPC, CURR_COST);

  //int nStaticLevel        = GetLocalInt(GetModule(), "STATIC_LEVEL");

  //if (GetHitDice(oPC) < nStaticLevel)
  //{
  //  SetDlgPrompt("Please level up before training.");
  //  return;
  //}

  if(sPage == LIST_SKILLS || sPage == "" && GetLocalInt(gsPCGetCreatureHide(oPC), "T_UNCON_SKILL"))
  {
     SetDlgPageString(LIST_SKILLS);
     _DoSkillPointList(oPC);
  }
  else if (sPage == "")
  {
    SetDlgPrompt("You are currently System Level " + IntToString(nSystemLevel) + ". " +
    "\n\nYour current effective level is " + FloatToString(fPCLevel, 4, 1) +
    " and to take another feat will cost you " + IntToString(nGold) + " gp." +
    "\n\nPick the category of feat you wish to take.\n\n" +
	"My classes:\n" + mdGetClassName(GetClassByPosition(1, OBJECT_SELF)) + " " + 
	mdGetClassName(GetClassByPosition(2, OBJECT_SELF)) + " " + mdGetClassName(GetClassByPosition(3, OBJECT_SELF)));
    SetDlgResponseList(CATEGORIES);
  }
  else if (sPage == PAGE_SELECT_FEAT)
  {
    string sList = GetLocalString(OBJECT_SELF, CURR_LIST);
    SetDlgPrompt("Select the feat you wish to take.");
    SetDlgResponseList(sList);
  }
  else if (sPage == PAGE_CONFIRM)
  {
    string sList = GetLocalString(OBJECT_SELF, CURR_LIST);
    int nSelection = GetLocalInt(OBJECT_SELF, CURR_SELECTION);
    int nFeat = GetIntElement(nSelection, sList + "_IDS");
    int nCost = GetLocalInt(oPC, CURR_COST);
    //first lets get the 2da string
    string sDescription = Get2DAString("feat", "DESCRIPTION", nFeat);
    //Now we get the  result from the tlk table
    sDescription = GetStringByStrRef(StringToInt(sDescription));
    SetDlgPrompt("You have selected " + GetStringElement(nSelection, sList)
    + ".\n\nSelecting this feat will cost you " + IntToString(nCost)
    + "gp.\n\nFeat description:\n" + sDescription + " \n\nLearn feat?");
    SetDlgResponseList(CONFIRM);
  }
  else if(sPage == LIST_SK_AMT)
  {
    int nSkill = GetLocalInt(oPC, "T_SEL_SKILL");
    int nRank = GetSkillRank(nSkill, oPC, TRUE);
    int nPurR = GetPCSkillPoints(oPC) - GetLocalInt(oPC, "T_SKILL_USED");
    DeleteList(LIST_SK_AMT);
    int nMax = GetHitDice(oPC) + 3;
    int nMulti = 1;
    int nCC;
    //class skill
    if(!(miSKGetIsClassSkill(GetClassByPosition(1, oPC), nSkill) || miSKGetIsClassSkill(GetClassByPosition(2, oPC), nSkill) ||
       miSKGetIsClassSkill(GetClassByPosition(3, oPC), nSkill)))
    {
      nMax /= 2;
      nMulti = 2;
      nCC = 1;
    }


    int x = 0;
    nMax -= nRank;
    while(x <= nMax && nPurR >= (x*nMulti))
    {
      string sAmt = IntToString(x);
      if(nCC)
      {
        sAmt += " ("+IntToString(x*2)+")";
      }
      AddStringElement(sAmt, LIST_SK_AMT);
      x++;
    }
    SetDlgPrompt(_SkillName(nSkill) +" ("+IntToString(nRank)+"):");
    SetDlgResponseList(LIST_SK_AMT);
  }
}


void HandleSelection()
{
  // This method handles what happens when the player selects an option.
  int selection  = GetDlgSelection();
  object oPC     = GetPcDlgSpeaker();
  object oNPC    = OBJECT_SELF;
  string sPage   = GetDlgPageString();

  if (sPage == "")
  {
    SetDlgPageString(PAGE_SELECT_FEAT);

    switch (selection)
    {
      case 0:
        if (GetLevelByClass(CLASS_TYPE_WIZARD, oNPC) ||
		    GetLevelByClass(CLASS_TYPE_SORCERER, oNPC) ||
	        GetLevelByClass(CLASS_TYPE_DRUID, oNPC) ||
	        GetLevelByClass(CLASS_TYPE_CLERIC, oNPC) ||
	        GetLevelByClass(CLASS_TYPE_BARD, oNPC))
        {
          SetLocalString(OBJECT_SELF, CURR_LIST, LIST_1);
		}
		else
		{
		  // Do nothing - stay on this page. 
          SetDlgPageString("");
		}
       break;
      case 1:
       SetLocalString(OBJECT_SELF, CURR_LIST, LIST_2);
       break;
      case 2:
       SetLocalString(OBJECT_SELF, CURR_LIST, LIST_3);
       break;
      case 3:
       SetLocalString(OBJECT_SELF, CURR_LIST, LIST_4);
       break;
      case 4:
       SetLocalString(OBJECT_SELF, CURR_LIST, LIST_5);
       break;
      case 5:
        EndDlg();
        break;
    }

  }
  else if (sPage == PAGE_SELECT_FEAT)
  {
    string sList = GetLocalString(OBJECT_SELF, CURR_LIST);
    int nFeat = GetIntElement(selection, sList + "_IDS");

    if (nFeat == -1) //back
    {
      //handles groups
      if(sList == LIST_FE)
        sList = LIST_5;
      else if(sList == LIST_SF)
        sList = LIST_3;
      else if(sList == LIST_IC || sList == LIST_WF)
        sList = LIST_2;
      else
      {
        SetDlgPageString("");
        return;
      }

      SetLocalString(OBJECT_SELF, CURR_LIST, sList);
      //stay on the same page.
    }
    else if(nFeat == GROUP_NUMBER_FE)
      SetLocalString(OBJECT_SELF, CURR_LIST, LIST_FE);
    else if(nFeat == GROUP_NUMBER_IC)
      SetLocalString(OBJECT_SELF, CURR_LIST, LIST_IC);
    else if(nFeat == GROUP_NUMBER_SF)
      SetLocalString(OBJECT_SELF, CURR_LIST, LIST_SF);
    else if(nFeat == GROUP_NUMBER_WF)
      SetLocalString(OBJECT_SELF, CURR_LIST, LIST_WF);
    else
    {
      SetDlgPageString(PAGE_CONFIRM);
      SetLocalInt(OBJECT_SELF, CURR_SELECTION, selection);
    }
  }
  else if (sPage == PAGE_CONFIRM)
  {
    switch (selection)
    {
      case 0:
      {
        string sList = GetLocalString(OBJECT_SELF, CURR_LIST);
        int nSelection = GetLocalInt(OBJECT_SELF, CURR_SELECTION);
        string sName = GetStringElement(nSelection, sList);
        int nFeat = GetIntElement(nSelection, sList + "_IDS");
        int nClass = GetIntElement(nSelection, sList + "_CLASS");
        int nCost = GetLocalInt(oPC, CURR_COST);

        if (GetGold(oPC) < nCost)
        {
          SendMessageToPC(oPC, "You don't have enough gold!");
          EndDlg();
        }
        else
        {
          TakeGoldFromCreature(nCost, oPC, TRUE);
          AssignCommand(oPC, PlaySound("gui_level_up"));
          if (nFeat > 10000)
          {
            // Indices over 10000 are used to signal custom abilities.
            object oHide = gsPCGetCreatureHide(oPC);

            switch (nFeat)
            {
              case 10001:
                if (miWAGetCasterLevel(oPC) == 23) miWAIncreaseCasterLevel(oPC, 1);
                else miWAIncreaseCasterLevel(oPC, 2);
                miWAApplyAbilities(oPC, FALSE);
                break;
              case 10003:
              {
                int nBonusSkillPoints = 2 + (GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE) - 10)/2;
                if(nBonusSkillPoints <= 0)
                  nBonusSkillPoints = 1;
                if(GetRacialType(oPC) == RACIAL_TYPE_HUMAN)
                  nBonusSkillPoints += 1;
                SetLocalInt(gsPCGetCreatureHide(oPC), "T_UNCON_SKILL", 1);
                SetPCSkillPoints(oPC, GetPCSkillPoints(oPC) + nBonusSkillPoints);
                SetDlgPageString(LIST_SKILLS);
                break;
              }
              case 10004: // Bard song
              {
                gsIPStackSkill(oHide, SKILL_PERFORM, 4);
                SetLocalInt(oHide, "FL_BONUS_BARD_LEVELS",
                  GetLocalInt(oHide, "FL_BONUS_BARD_LEVELS") + 4);
                break;
              }
              case 10005: // Craft Wondrous Item
              {
                SetLocalInt(oHide, "CRAFT_WONDROUS_ITEM", TRUE);
                break;
              }
              case 10006: // Caster level increase
              {
                // Retired
                break;
              }
              case 10007: // Bard spell slot
              {
                _AddSpellSlot(oHide, "BARD_BONUS_SLOT", CLASS_TYPE_BARD, 3);
                break;
              }
              case 10008: // Cleric spell slot
              {
                _AddSpellSlot(oHide, "CLERIC_BONUS_SLOT", CLASS_TYPE_CLERIC, 5);
                break;
              }
              case 10009: // Druid spell slot
              {
                _AddSpellSlot(oHide, "DRUID_BONUS_SLOT", CLASS_TYPE_DRUID, 5);
                break;
              }
              case 10010: // Paladin spell slot
              {
                _AddSpellSlot(oHide, "PALLY_BONUS_SLOT", CLASS_TYPE_PALADIN, 2);
                break;
              }
              case 10011: // Ranger spell slot
              {
                _AddSpellSlot(oHide, "RANGER_BONUS_SLOT", CLASS_TYPE_RANGER, 2);
                break;
              }
              case 10012: // Sorcerer spell slot
              {
                _AddSpellSlot(oHide, "SORC_BONUS_SLOT", CLASS_TYPE_SORCERER, 5);
                break;
              }
              case 10013: // Wizard spell slot
              {
                _AddSpellSlot(oHide, "WIZZY_BONUS_SLOT", CLASS_TYPE_WIZARD, 5);
                break;
              }
              case 10014: // Ranger levels
              {
                gsIPStackSkill(oHide, SKILL_ANIMAL_EMPATHY, 4);
                SetLocalInt(oHide, "FL_BONUS_RGR_LEVELS",
                  GetLocalInt(oHide, "FL_BONUS_RGR_LEVELS") + 4);
                break;
              }
              case 10015: // Totem druid levels
              {
                miTOSetTotemBonus(miTOGetTotemBonus(oPC) + 2, oPC);
                break;
              }
			  case 10016: // Spellsword Greater Imbue
			  {
			    SetLocalInt(oHide, "SS_GREATER_IMBUE", TRUE);
				break;
			  }

              default:
                break;
            }
          }
          else
          {
            int nLevel = 1;
            //For favored enemy
            if(nFeat >= 261 && nFeat <= 286)
            {
              //Get the highest of harper scout or ranger
              int nClass = CLASS_TYPE_RANGER;
              if(GetLevelByClass(nClass, oPC) < GetLevelByClass(CLASS_TYPE_HARPER, oPC))
                nClass = CLASS_TYPE_HARPER;

              int x;
              //put on level 1.
              for(x = 1; x <= 15; x++)
              {
                if(NWNX_Creature_GetClassByLevel(oPC, x) == nClass)
                {
                  nLevel = x;
                  break;
                }
              }
            }
            else if(nClass > -1)
            {
              int x;
              for(x = 1; x <= 15; x++)
              {
                if(NWNX_Creature_GetClassByLevel(oPC, x) == nClass)
                {
                  nLevel = x;
                  break;
                }
              }
            }

            AddKnownFeat(oPC, nFeat, nLevel);
          }

          // Stat pump feats need to be handled specially.
          switch (nFeat)
          {
            case FEAT_EPIC_GREAT_CHARISMA_1:
            case FEAT_EPIC_GREAT_CHARISMA_2:
            case FEAT_EPIC_GREAT_CHARISMA_3:
            case FEAT_EPIC_GREAT_CHARISMA_4:
              ModifyAbilityScore(oPC, ABILITY_CHARISMA, 1);
              break;
            case FEAT_EPIC_GREAT_CONSTITUTION_1:
            case FEAT_EPIC_GREAT_CONSTITUTION_2:
            case FEAT_EPIC_GREAT_CONSTITUTION_3:
            case FEAT_EPIC_GREAT_CONSTITUTION_4:
              ModifyAbilityScore(oPC, ABILITY_CONSTITUTION, 1);
              break;
            case FEAT_EPIC_GREAT_DEXTERITY_1:
            case FEAT_EPIC_GREAT_DEXTERITY_2:
            case FEAT_EPIC_GREAT_DEXTERITY_3:
            case FEAT_EPIC_GREAT_DEXTERITY_4:
              ModifyAbilityScore(oPC, ABILITY_DEXTERITY, 1);
              break;
            case FEAT_EPIC_GREAT_INTELLIGENCE_1:
            case FEAT_EPIC_GREAT_INTELLIGENCE_2:
            case FEAT_EPIC_GREAT_INTELLIGENCE_3:
            case FEAT_EPIC_GREAT_INTELLIGENCE_4:
              ModifyAbilityScore(oPC, ABILITY_INTELLIGENCE, 1);
              break;
            case FEAT_EPIC_GREAT_STRENGTH_1:
            case FEAT_EPIC_GREAT_STRENGTH_2:
            case FEAT_EPIC_GREAT_STRENGTH_3:
            case FEAT_EPIC_GREAT_STRENGTH_4:
              ModifyAbilityScore(oPC, ABILITY_STRENGTH, 1);
              break;
            case FEAT_EPIC_GREAT_WISDOM_1:
            case FEAT_EPIC_GREAT_WISDOM_2:
            case FEAT_EPIC_GREAT_WISDOM_3:
            case FEAT_EPIC_GREAT_WISDOM_4:
              ModifyAbilityScore(oPC, ABILITY_WISDOM, 1);
              break;
          }

          int nPCLevel = GetLocalInt(gsPCGetCreatureHide(oPC), "FL_LEVEL") + 1;
          SetLocalInt(gsPCGetCreatureHide(oPC), "FL_LEVEL", nPCLevel);
          SendMessageToPC(oPC, "You have learnt " + sName + ".");
          if(nFeat != 10003) //Don't want to cancel out the conversation for skill selection
            EndDlg();

          break;
        }
      }
      case 1:
        SetDlgPageString("");
        break;
    }
  }
  else if(sPage == LIST_SKILLS)
  {
    int nSkill = GetIntElement(selection, LIST_SK_ID);
    if(nSkill == -10) //Confirm
    {

      int nAmt;
      int nUsed = GetLocalInt(oPC, "T_SKILL_USED");
      SetPCSkillPoints(oPC, GetPCSkillPoints(oPC) - nUsed);
      int x;
      for(x = 0; x <= 27; x++)
      {
        nAmt = GetLocalInt(oPC, "T_INCREASE_AMT_"+IntToString(x));
        DeleteLocalInt(oPC, "T_INCREASE_AMT_"+IntToString(x));
        if(nAmt > 0)
          NWNX_Creature_SetSkillRank(oPC, x, nAmt + GetSkillRank(x, oPC, TRUE));

      }
      DeleteLocalInt(oPC, "T_SEL_SKILL");
      DeleteLocalInt(gsPCGetCreatureHide(oPC), "T_UNCON_SKILL");
      DeleteLocalInt(oPC, "T_SKILL_USED");
      EndDlg();
      return;
    }
    else
    {
      SetLocalInt(oPC, "T_SEL_SKILL", nSkill);
      SetDlgPageString(LIST_SK_AMT);
    }

  }
  else if(sPage == LIST_SK_AMT)
  {
    int nSkill = GetLocalInt(oPC, "T_SEL_SKILL");
    int nMulti = 1;
    if(!(miSKGetIsClassSkill(GetClassByPosition(1, oPC), nSkill) || miSKGetIsClassSkill(GetClassByPosition(2, oPC), nSkill) ||
       miSKGetIsClassSkill(GetClassByPosition(3, oPC), nSkill)))
       nMulti = 2;

    int nORank =  GetLocalInt(oPC, "T_INCREASE_AMT_"+IntToString(nSkill));
    if(selection > 0)
      SetLocalInt(oPC, "T_INCREASE_AMT_"+IntToString(nSkill), selection);
    else
      DeleteLocalInt(oPC, "T_INCREASE_AMT_"+IntToString(nSkill));

    SetLocalInt(oPC, "T_SKILL_USED", GetLocalInt(oPC, "T_SKILL_USED") + ((selection - nORank))*nMulti);
    SetDlgPageString(LIST_SKILLS);
  }
}

void main()
{
  // Don't change this method unless you understand Z-dialog.
  int nEvent = GetDlgEventType();
  Trace(ZDIALOG, "Called conversation script with event... " + IntToString(nEvent));
  switch (nEvent)
  {
    case DLG_INIT:
      Init();
      break;
    case DLG_PAGE_INIT:
      PageInit();
      break;
    case DLG_SELECTION:
      HandleSelection();
      break;
    case DLG_ABORT:
    case DLG_END:
      break;
  }
}
