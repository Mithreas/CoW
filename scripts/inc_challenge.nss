/**
 * Challenge library by Mithreas
 *
 * Includes a bunch of utility functions for non-combat challenges. 
 */
#include "inc_log"
#include "inc_common"
#include "inc_pc"
#include "inc_subrace" 
#include "inc_time"
#include "nwnx_creature"

const string CHALLENGE      = "CHALLENGE";  // For logging, set MI_DEBUG_CHALLENGE to TRUE on the module
const string VAR_UNDERWATER = "CH_IS_UNDERWATER";
const string VAR_QUEST      = "CH_Q_";

// Check whether 1-2 skills are of the required ranks.  If nUseBaseRanks is TRUE, exclude ranks and
// ability bonuses from gear and spells (default) but include bonuses from feats.
int CHTwoSkillCheck(object oPC, int nSkill1, int nTarget1, int nSkill2 = -1, int nTarget2 = 0, int nUseBaseRanks = TRUE); 

// Get the base number of ranks oPC has in nSkill, including feat bonuses and the feat's usual ability score,
// but no bonuses to skill ranks or abilities from items or spells (and excluding feats granted by items).
int CHGetBaseSkillRank(int nSkill, object oPC);

// Underwater status check, called every round.  
void CHDoUnderwater(object oPC);

// Mark a PC as underwater, or not.
void CHSetUnderwater(object oPC, int nUnderwater = TRUE);

// Creates a unique tag for oObject from its current tag plus the current module timestamp plus a random number.
// Generated tag will be up to 20 characters long.
void CHGiveUniqueTag(object oObject);

// Get the current quest state for oPC with oNPC.
int CHGetQuestState(object oPC, object oNPC);

// Set the current quest state for oPC with oNPC.  sCategory is optional and used for counting
// active quests in a family (so you can tell when they are all completed).  
void CHSetQuestState(object oPC, object oNPC, int nState, string sCategory = "");

// Get the current number of active quests for oPC.
int CHGetQuestCount(object oPC, string sCategory = "");

int CHTwoSkillCheck(object oPC, int nSkill1, int nTarget1, int nSkill2 = -1, int nTarget2 = 0, int nUseBaseRanks = TRUE)
{
  // Do the first check.
  Log(CHALLENGE, "First skill check, skill: " + IntToString(nSkill1) + ", target: " + IntToString(nTarget1) + ", base ranks: " + IntToString(nUseBaseRanks));
  
  int nRank = GetSkillRank(nSkill1, oPC, FALSE);
  if (nUseBaseRanks) nRank = CHGetBaseSkillRank(nSkill1, oPC);  
  
  if (nRank < nTarget1) return FALSE;

  // Do the second check.
  if (nSkill2 >= 0)
  {
    Log(CHALLENGE, "Second skill check, skill: " + IntToString(nSkill2) + ", target: " + IntToString(nTarget2) + ", base ranks: " + IntToString(nUseBaseRanks));
  
    nRank = GetSkillRank(nSkill2, oPC, FALSE);
	if (nUseBaseRanks) nRank = CHGetBaseSkillRank(nSkill2, oPC);
	
    if (nRank < nTarget2) return FALSE;
  }
  
  Log (CHALLENGE, "Passed all checks.");
  
  return TRUE;
}

int CHGetBaseSkillRank(int nSkill, object oPC)
{
  int nSkillFocusFeat = 0;
  int nEpicSkillFocusFeat = 0;
  int nPartialAffinity = 0;
  int nAffinity = 0;
  int nAbility  = 0;
  
  switch (nSkill)
  {
    case SKILL_ANIMAL_EMPATHY:
      nSkillFocusFeat     = FEAT_SKILL_FOCUS_ANIMAL_EMPATHY;
      nEpicSkillFocusFeat = FEAT_EPIC_SKILL_FOCUS_ANIMAL_EMPATHY;
	  nAbility            = ABILITY_CHARISMA;
      break;
    case SKILL_APPRAISE:
      nSkillFocusFeat     = FEAT_SKILLFOCUS_APPRAISE;
      nEpicSkillFocusFeat = FEAT_EPIC_SKILL_FOCUS_APPRAISE;
	  nAbility            = ABILITY_INTELLIGENCE;
      break;
    case SKILL_BLUFF:
      nSkillFocusFeat     = FEAT_SKILL_FOCUS_BLUFF;
      nEpicSkillFocusFeat = FEAT_EPIC_SKILL_FOCUS_BLUFF;
	  nAbility            = ABILITY_CHARISMA;
      break;
    case SKILL_CONCENTRATION:
      nSkillFocusFeat     = FEAT_SKILL_FOCUS_CONCENTRATION;
      nEpicSkillFocusFeat = FEAT_EPIC_SKILL_FOCUS_CONCENTRATION;
      nAffinity           = FEAT_SKILL_AFFINITY_CONCENTRATION;
	  nAbility            = ABILITY_CONSTITUTION;
      break;
    case SKILL_CRAFT_ARMOR:
      nSkillFocusFeat     = FEAT_SKILL_FOCUS_CRAFT_ARMOR;
      nEpicSkillFocusFeat = FEAT_EPIC_SKILL_FOCUS_CRAFT_ARMOR;
	  nAbility            = ABILITY_INTELLIGENCE;
      break;
    case SKILL_CRAFT_TRAP:
      nSkillFocusFeat     = FEAT_SKILL_FOCUS_CRAFT_TRAP;
      nEpicSkillFocusFeat = FEAT_EPIC_SKILL_FOCUS_CRAFT_TRAP;
	  nAbility            = ABILITY_INTELLIGENCE;
      break;
    case SKILL_CRAFT_WEAPON:
      nSkillFocusFeat     = FEAT_SKILL_FOCUS_CRAFT_WEAPON;
      nEpicSkillFocusFeat = FEAT_EPIC_SKILL_FOCUS_CRAFT_WEAPON;
	  nAbility            = ABILITY_INTELLIGENCE;
      break;
    case SKILL_DISABLE_TRAP:
      nSkillFocusFeat     = FEAT_SKILL_FOCUS_DISABLE_TRAP;
      nEpicSkillFocusFeat = FEAT_EPIC_SKILL_FOCUS_DISABLETRAP;
	  nAbility            = ABILITY_INTELLIGENCE;
      break;
    case SKILL_DISCIPLINE:
      nSkillFocusFeat     = FEAT_SKILL_FOCUS_DISCIPLINE;
      nEpicSkillFocusFeat = FEAT_EPIC_SKILL_FOCUS_DISCIPLINE;
	  nAbility            = ABILITY_STRENGTH;
      break;
    case SKILL_HEAL:
      nSkillFocusFeat     = FEAT_SKILL_FOCUS_HEAL;
      nEpicSkillFocusFeat = FEAT_EPIC_SKILL_FOCUS_HEAL;
	  nAbility            = ABILITY_WISDOM;
      break;
    case SKILL_HIDE:
      nSkillFocusFeat     = FEAT_SKILL_FOCUS_HIDE;
      nEpicSkillFocusFeat = FEAT_EPIC_SKILL_FOCUS_HIDE;
	  nAbility            = ABILITY_DEXTERITY;
      break;
    case SKILL_INTIMIDATE:
      nSkillFocusFeat     = FEAT_SKILL_FOCUS_INTIMIDATE;
      nEpicSkillFocusFeat = FEAT_EPIC_SKILL_FOCUS_INTIMIDATE;
	  nAbility            = ABILITY_CHARISMA;
      break;
    case SKILL_LISTEN:
      nSkillFocusFeat     = FEAT_SKILL_FOCUS_LISTEN;
      nEpicSkillFocusFeat = FEAT_EPIC_SKILL_FOCUS_LISTEN;
      nPartialAffinity    = FEAT_PARTIAL_SKILL_AFFINITY_LISTEN;
      nAffinity           = FEAT_SKILL_AFFINITY_LISTEN;
	  nAbility            = ABILITY_WISDOM;
      break;
    case SKILL_LORE:
      nSkillFocusFeat     = FEAT_SKILL_FOCUS_LORE;
      nEpicSkillFocusFeat = FEAT_EPIC_SKILL_FOCUS_LORE;
      nAffinity           = FEAT_SKILL_AFFINITY_LORE;
	  nAbility            = ABILITY_INTELLIGENCE;
      break;
    case SKILL_MOVE_SILENTLY:
      nSkillFocusFeat     = FEAT_SKILL_FOCUS_MOVE_SILENTLY;
      nEpicSkillFocusFeat = FEAT_EPIC_SKILL_FOCUS_MOVESILENTLY;
      nAffinity           = FEAT_SKILL_AFFINITY_MOVE_SILENTLY;
	  nAbility            = ABILITY_DEXTERITY;
      break;
    case SKILL_OPEN_LOCK:
      nSkillFocusFeat     = FEAT_SKILL_FOCUS_OPEN_LOCK;
      nEpicSkillFocusFeat = FEAT_EPIC_SKILL_FOCUS_OPENLOCK;
	  nAbility            = ABILITY_DEXTERITY;
      break;
    case SKILL_PARRY:
      nSkillFocusFeat     = FEAT_SKILL_FOCUS_PARRY;
      nEpicSkillFocusFeat = FEAT_EPIC_SKILL_FOCUS_PARRY;
	  nAbility            = ABILITY_DEXTERITY;
      break;
    case SKILL_PERFORM:
      nSkillFocusFeat     = FEAT_SKILL_FOCUS_PERFORM;
      nEpicSkillFocusFeat = FEAT_EPIC_SKILL_FOCUS_PERFORM;
	  nAbility            = ABILITY_CHARISMA;
      break;
    case SKILL_PERSUADE:
      nSkillFocusFeat     = FEAT_SKILL_FOCUS_PERSUADE;
      nEpicSkillFocusFeat = FEAT_EPIC_SKILL_FOCUS_PERSUADE;
	  nAbility            = ABILITY_CHARISMA;
      break;
    case SKILL_PICK_POCKET:
      nSkillFocusFeat     = FEAT_SKILL_FOCUS_PICK_POCKET;
      nEpicSkillFocusFeat = FEAT_EPIC_SKILL_FOCUS_PICKPOCKET;
	  nAbility            = ABILITY_DEXTERITY;
      break;
    case SKILL_RIDE:
      nSkillFocusFeat     = 0;  // Apparently doesn't exist
      nEpicSkillFocusFeat = 0;  // Apparently doesn't exist
	  nAbility            = ABILITY_DEXTERITY;
      break;
    case SKILL_SEARCH:
      nSkillFocusFeat     = FEAT_SKILL_FOCUS_SEARCH;
      nEpicSkillFocusFeat = FEAT_EPIC_SKILL_FOCUS_SEARCH;
      nPartialAffinity    = FEAT_PARTIAL_SKILL_AFFINITY_SEARCH;
      nAffinity           = FEAT_SKILL_AFFINITY_SEARCH;
	  nAbility            = ABILITY_INTELLIGENCE;
      break;
    case SKILL_SET_TRAP:
      nSkillFocusFeat     = FEAT_SKILL_FOCUS_SET_TRAP;
      nEpicSkillFocusFeat = FEAT_EPIC_SKILL_FOCUS_SETTRAP;
	  nAbility            = ABILITY_INTELLIGENCE;
      break;
    case SKILL_SPELLCRAFT:
      nSkillFocusFeat     = FEAT_SKILL_FOCUS_SPELLCRAFT;
      nEpicSkillFocusFeat = FEAT_EPIC_SKILL_FOCUS_SPELLCRAFT;
	  nAbility            = ABILITY_INTELLIGENCE;
      break;
    case SKILL_SPOT:
      nSkillFocusFeat     = FEAT_SKILL_FOCUS_SPOT;
      nEpicSkillFocusFeat = FEAT_EPIC_SKILL_FOCUS_SPOT;
      nPartialAffinity    = FEAT_PARTIAL_SKILL_AFFINITY_SPOT;
      nAffinity           = FEAT_SKILL_AFFINITY_SPOT;
	  nAbility            = ABILITY_WISDOM;
      break;
    case SKILL_TAUNT:
      nSkillFocusFeat     = FEAT_SKILL_FOCUS_TAUNT;
      nEpicSkillFocusFeat = FEAT_EPIC_SKILL_FOCUS_TAUNT;
	  nAbility            = ABILITY_CHARISMA;
      break;
    case SKILL_TUMBLE:
      nSkillFocusFeat     = FEAT_SKILL_FOCUS_TUMBLE;
      nEpicSkillFocusFeat = FEAT_EPIC_SKILL_FOCUS_TUMBLE;
	  nAbility            = ABILITY_DEXTERITY;
      break;
    case SKILL_USE_MAGIC_DEVICE:
      nSkillFocusFeat     = FEAT_SKILL_FOCUS_USE_MAGIC_DEVICE;
      nEpicSkillFocusFeat = FEAT_EPIC_SKILL_FOCUS_USEMAGICDEVICE;
	  nAbility            = ABILITY_CHARISMA;
      break;
  }
  
  return (GetSkillRank(nSkill, oPC, TRUE) +
          (GetAbilityScore(oPC, nAbility, TRUE) - 10) / 2 +
          (nSkillFocusFeat && GetKnowsFeat(nSkillFocusFeat, oPC) ? 3 : 0) + 
          (nEpicSkillFocusFeat && GetKnowsFeat(nEpicSkillFocusFeat, oPC) ? 10 : 0) + 
          (nPartialAffinity && GetKnowsFeat(nPartialAffinity, oPC) ? 1 : 0) + 
          (nAffinity && GetKnowsFeat(nAffinity, oPC) ? 2 : 0));
		  
}

void CHDoUnderwater(object oPC)
{
  int nUnderwater = GetLocalInt(oPC, VAR_UNDERWATER);
  if (!nUnderwater) return;
  
  Log (CHALLENGE, "Doing underwater round check for " + GetName(oPC));
  
  // Track time spent underwater, unless the PC has a helm of water breathing.
  if (GetTag(GetItemInSlot(INVENTORY_SLOT_HEAD, oPC)) == "CH_HELM_WATER_BREATHING") return;
  
  Log (CHALLENGE, "Not wearing helm of water breathing.");
 
  nUnderwater += 6;
  
  if (nUnderwater >= GetCurrentHitPoints(oPC))
  {
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oPC);
	SendMessageToPC(oPC, "You ran out of air.");
  }  
  else
  {
    FloatingTextStringOnCreature(IntToString(GetCurrentHitPoints(oPC) - nUnderwater) + " seconds of breath remaining.", oPC, FALSE);
	SetLocalInt(oPC, VAR_UNDERWATER, nUnderwater);
  }
  
  DelayCommand(6.0, CHDoUnderwater(oPC));
}

void CHSetUnderwater(object oPC, int nUnderwater = TRUE)
{
  Log (CHALLENGE, GetName(oPC) + " sets underwater: " + IntToString(nUnderwater));
  if (nUnderwater) 
  {
    NWNX_Creature_SetMovementRate(oPC, MOVEMENT_RATE_SLOW);
    SetLocalInt(oPC, VAR_UNDERWATER, TRUE);
	SendMessageToPC(oPC, "You descend beneath the surface.");
  }
  else 
  {
    DeleteLocalInt(oPC, VAR_UNDERWATER);
	
	// Restore normal movement.
    if(gsSUGetSubRaceByName(GetSubRace(oPC)) == GS_SU_SPECIAL_FEY)
    {
        NWNX_Creature_SetMovementRate(oPC, MOVEMENT_RATE_VERY_FAST);
    }
    else
    {
        NWNX_Creature_SetMovementRate(oPC, MOVEMENT_RATE_PC);
    }
	
	SendMessageToPC(oPC, "You surface again, and take a deep breath of air.");
  }
}

void CHGiveUniqueTag(object oObject)
{
  string sCurrentTag = GetStringLeft(GetTag(oObject), 8);
  SetTag(oObject, sCurrentTag + GetStringRight(IntToString(gsTIGetActualTimestamp()), 8) + IntToString(Random(10000))); 
}

int CHGetQuestState(object oPC, object oNPC)
{
  object oHide = gsPCGetCreatureHide(oPC);
  int nState   = GetLocalInt(oHide, VAR_QUEST + GetTag(oNPC));

  Log(CHALLENGE, "Quest state for " + GetName(oPC) + " with " + GetName(oNPC) + " is " + IntToString(nState));
  
  return nState;
}

void CHSetQuestState(object oPC, object oNPC, int nState, string sCategory = "")
{
  Log(CHALLENGE, "Setting quest state for " + GetName(oPC) + " with " + GetName(oNPC) + " to " + IntToString(nState));
  
  object oHide      = gsPCGetCreatureHide(oPC);
  int nCurrentState = GetLocalInt(oHide, VAR_QUEST + GetTag(oNPC));
  
  if (nState == 0)
  {
    DeleteLocalInt(oHide, VAR_QUEST + GetTag(oNPC));
	SetLocalInt(oHide, VAR_QUEST + sCategory + "_COUNT", CHGetQuestCount(oPC, sCategory) - 1);
	return;
  }
  else if (nCurrentState == 0)
  {
	SetLocalInt(oHide, VAR_QUEST + sCategory + "_COUNT", CHGetQuestCount(oPC, sCategory) + 1);    
  }
  
  SetLocalInt(oHide, VAR_QUEST + GetTag(oNPC), nState);
}

int CHGetQuestCount(object oPC, string sCategory = "")
{
  return GetLocalInt(gsPCGetCreatureHide(oPC), VAR_QUEST + sCategory + "_COUNT");
}
