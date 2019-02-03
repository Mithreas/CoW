/*
Social Skills system.

Intended to be an equivalent to combat in terms of being a minigame that a 
character can be built around and which can fuel advancement.  The hope is 
to make something fun to play with where the challenge varies with different 
NPCs.  

Basic concepts:
- 4 skills - Persuade (Flirt), Bluff (manipulate), Spot & Listen.  
  Listen becomes class for cleric and paladin, other skills stay as they are.
- Invoked by using a Player Tool action on a non-hostile NPC (only - not on 
  other PCs)
- Starts a Z-Dialog (i.e. not the NPC's usual dialog) that lets you flirt with
  them or persuade them.
- Pick from one of 4 objectives - get money, get items, get influence, get quest
- plus standard "ask NPC to move" option (used to clear blocked doors etc. NPC 
  will agree if you have a positive reputation with them).
- 6 standard options - Flirt/Tease, Flirt/Flatter, Flirt/Charm, Persuade/Con, 
  Perusade/Beg, Persuade/Influence
- Plus Bribe - pay an amount of gold to gain influence.   

Key stats:
- Intelligence, Wisdom, Charisma
- Intelligence is used for Tease and Con
- Wisdom is used for Flatter and Beg, as well as being the main defense stat 
  and powering Spot/Listen
- Charisma is used for Charm and Influence, as well as powering the Bluff (Flirt) 
  and Persuade skill rolls as usual
- DC is modified by comparing the relevant attacking stat (e.g. Intelligence for Con) 
  with the defender's Wisdom.  
- Then a contested roll - Bluff or Persuade vs Listen, modified by the DC. 
- Personal reputation changes based on the outcome.  Rewards are triggered by hitting 
  certain reputation levels.  Other scripts can check the reputation level (using 
  standard methods) in the NPC's standard dialog to do custom rewards e.g. allow passage 
  if you've raised NPC reputation enough.  

There are various other factors that influence the DC.  The randomised ones can be 
overridden by configuring variables on the NPC, or they are randomised on spawn for the 
duration of the reset.
- Gender - same gender has an 85% chance of being a penalty to flirt and a (smaller) bonus 
  to persuade, and a 15% chance of having the reverse effect (determined OnSpawn or via 
  preset variable on NPC)
- Relationship status - 30% chance of a significant penalty to any flirt approach
- Race - different race means a penalty to DC.  May scale depending on different races.
- Language - large penalty if no common language.  Smaller penalty if learning a language 
  the other knows.
- NPC Social Class - Noble, Merchant, Guard or Commoner - bonus or penalty to DC based on 
  what you're after (e.g. Nobles are easy for money but hard for quests, Commoners easy 
  for influence but hard for items and money, Guards are more willing to give quests but hard 
  for influence, Merchants easy for items and not hard for anything.  Bribe effectiveness
  varies with class.
- The Examine window hooks a Spot check that can hint to PCs the gender preferences 
  and social class of the NPC.

There are various possible outcomes. The likelihood of different outcomes will depend on the 
objective and magnitude of the check result (positive or negative).  A Spot check vs 
15 + the delta will give hints where the NPC's reaction changes.
- No effect (yet).
- Bonus or penalty to next roll of a particular type. 
- Penalty to all future rolls of this type.   
- Penalty to all future rolls of this category (i.e. Flirt/Persuade). 
- Personal reputation gain or loss (bigger gain if seeking influence)
- Faction reputation gain or loss
- Global reputation gain or loss (if using a reputation system)
- XP gain (common, likely to happen alongside other results)
- Skill point gain (rare)
- GP (common if objective is gold, rare otherwise)
- Item (as GP) - drawn from the NPC inventory, the NPC drop palette, or a nearby shop - maybe add 
  craft components
- Quest (as GP) - hook into writ/bounty system
- NPC ends conversation and will have no more to do with you (possible outcome at any point, more 
  likely the more often you fail, less likely the more often you succeed)
- NPC changes faction and goes hostile (very rare)

Feedback and animations
- NPCs and the PC will play appropriate animations through the dialog
- NPCs will have a wide range of spoken responses - positive, neutral/polite and negative, where 
  a successful spot check is required to get the positive or negative ones (DC is influenced by 
  NPC's Discipline score - high Discipline NPCs are harder to read). 
- NPCs will walk away if they bring the conversation to an end

TODO - consideration of nearby NPCs (partners, friends etc.). 
*/
#include "inc_backgrounds"
#include "inc_chatutils"
#include "inc_zdlg"
#include "zzdlg_color_inc"

// Variable names
// NPC variables storing bonuses or penalties.  All stored so that a positive value represents
// a bonus when dealing with the same gender and a penalty when dealing with the opposite.
const string FLIRT_MOD = "FLIRT_MODIFIER";
const string MANIP_MOD = "MANIPULATE_MODIFIER";
const string TEASE_MOD = "TEASE_MODIFIER";
const string FLAT_MOD  = "FLATTER_MODIFIER";
const string CHARM_MOD = "CHARM_MODIFIER";
const string CON_MOD   = "CON_MODIFIER";
const string BEG_MOD   = "BEG_MODIFIER";
const string INF_MOD   = "INFLUENCE_MODIFIER";

// NPC variable for storing caste. Int - 1=guard, 2=commoner, 3=merchant, 4=noble
const string NPC_CASTE = "CASTE";

// Dialog variables.  Set when figuring out the results.
const string NEXT_PROMPT = "ZD_SOC_NEXT_PROMPT";
const string OBJECTIVE   = "ZD_SOC_OBJECTIVE";

// Dialog options
string TEASE     = txtFuchsia + "[Flirt: Tease]</c>";
string FLATTER   = txtFuchsia + "[Flirt: Flatter]</c>";
string CHARM     = txtFuchsia + "[Flirt: Charm]</c>";
string CON       = txtBlue + "[Manipulate: Con]</c>";
string BEG       = txtBlue + "[Manipulate: Beg]</c>";
string INFLUENCE = txtBlue + "[Manipulate: Influence]</c>";
string BRIBE     = txtGreen+ "[Bribe]</c>";
string LEAVE     = txtGreen+ "[Leave]</c>";

// Dialog pages
const string MAIN      = "ZD_SOC_MAIN";
const string OPTIONS   = "ZD_SOC_OPTIONS";

//-------------------------------------------------------------------------------------------------------
// Utility methods
//-------------------------------------------------------------------------------------------------------

// Set up the NPC's initial personal modifiers.
void _InitialiseNPC(object oNPC)
{
  // Check whether the NPC is already set up.
  int nConfiguredFlirtMod = GetLocalInt(oNPC, FLIRT_MOD);
  int nConfiguredManipMod  = GetLocalInt(oNPC, MANIP_MOD);
    
  if (nConfiguredFlirtMod && nConfiguredManipMod) return;
  
  // Module designer may have set one of the variables but not
  // the other.  If so, calculate the other.
  if (nConfiguredFlirtMod)
  {
    nConfiguredManipMod = d10();
	if (nConfiguredFlirtMod > 0) nConfiguredManipMod *= -1;
	SetLocalInt(oNPC, MANIP_MOD, nConfiguredManipMod);
	return; 
  }
  
  if (nConfiguredManipMod)
  {
    nConfiguredFlirtMod = d20();
	if (nConfiguredManipMod > 0) nConfiguredFlirtMod *= -1;
	SetLocalInt(oNPC, FLIRT_MOD, nConfiguredFlirtMod);
	return;
  }
  
  // Neither is set, so set up from scratch. 
  nConfiguredManipMod = d10();
  nConfiguredFlirtMod = d20();
  
  if (d100() > 85)
  {
    // 15% chance of being gay.
	nConfiguredManipMod *= -1;
  }
  else
  {
     nConfiguredFlirtMod *= -1;
  }
  
  SetLocalInt(oNPC, MANIP_MOD, nConfiguredManipMod);
  SetLocalInt(oNPC, FLIRT_MOD, nConfiguredFlirtMod);
}

// Utility method - ensures NPC initialised.
int _GetNPCFlirtMod(object oNPC)
{
  _InitialiseNPC(oNPC);
  
  return GetLocalInt(oNPC, FLIRT_MOD);
}

// Utility method - ensures NPC initialised.
int _GetNPCManipulateMod(object oNPC)
{
  _InitialiseNPC(oNPC);
  
  return GetLocalInt(oNPC, MANIP_MOD);
}

// Check whether the PC successfully interprets the result of their action. Returns 1 if
// they do, 0 if they don't, and -1 if they get it hilariously wrong. 
int _DoReactionCheck(object oPC, object oNPC, int nRepChange)
{
  // DC - small changes are hard to spot.  Large changes are easier. 
  int nDC = 20 + GetSkillRank(SKILL_DISCIPLINE, oNPC) - abs(nRepChange);
  int nResult;
  
  int nCheck = d20();
  
  // 1 always critical fails, 20 always succeeds.  Otherwise, failing by more than 10 
  // is a critical failure.
  if (nCheck == 1) nResult = -1;
  else if (nCheck == 20) nResult = 1;
  else if (nCheck + GetSkillRank(SKILL_SPOT, oPC) >= nDC) nResult = 1;
  else if ((nCheck + GetSkillRank(SKILL_SPOT, oPC) + 10) >= nDC) nResult = 0;
  else nCheck = -1;
  
  return nCheck;
}

// The main method that determined NPC responses to PC approaches.  nSelection is 0-5 in dialog order 
// (tease, flatter, charm, con, beg, influence).  
void _ProcessResponse(int nSelection)
{
  object oPC    = GetPcDlgSpeaker();
  object oNPC   = GetLocalObject(oPC, "TARGET_NPC");
  int nRep      = 50; // @@@ GetNPCRep(oNPC, oPC);
  
  int nGender   = (GetGender(oNPC) == GetGender(oPC) ? 1 : -1 );
  int nModifier = 0;
  int nAbility  = ABILITY_CHARISMA;
  int nSkill    = SKILL_PERFORM;
  
  // Determine modifiers from caste, NPC preference and past dialog history. 
  switch  (nSelection)
  {
    case 0: // Flirt : Tease
	  nModifier = _GetNPCFlirtMod(oNPC) * nGender + GetLocalInt(oNPC, TEASE_MOD + gsPCGetPlayerID(oPC));
	  nAbility  = ABILITY_INTELLIGENCE;
	  break;
	case 1: // Flirt : Flatter
	  nModifier = _GetNPCFlirtMod(oNPC) * nGender + GetLocalInt(oNPC, FLAT_MOD + gsPCGetPlayerID(oPC));
	  nAbility  = ABILITY_WISDOM;
	  break;
	case 2: // Flirt : Charm
	  nModifier = _GetNPCFlirtMod(oNPC) * nGender + GetLocalInt(oNPC, CHARM_MOD + gsPCGetPlayerID(oPC));
	  break;
	case 3: // Manipulate: Con
	  nModifier = _GetNPCManipulateMod(oNPC) * nGender + GetLocalInt(oNPC, CON_MOD + gsPCGetPlayerID(oPC));
	  nAbility  = ABILITY_INTELLIGENCE;
	  nSkill    = SKILL_BLUFF;
	  break;
	case 4: // Manipulate: Beg
	  nModifier = _GetNPCManipulateMod(oNPC) * nGender + GetLocalInt(oNPC, BEG_MOD + gsPCGetPlayerID(oPC));
	  nAbility  = ABILITY_WISDOM;
	  nSkill    = SKILL_BLUFF;
	  break;
	case 5: // Manipulate: Influence
	  nModifier = _GetNPCManipulateMod(oNPC) * nGender + GetLocalInt(oNPC, INF_MOD + gsPCGetPlayerID(oPC));
	  nSkill    = SKILL_BLUFF;
	  break;
  }
  
  // Determine the base DC from int/wis/cha vs wis.
  nModifier = nModifier + 5 * GetAbilityModifier(nAbility, oPC) - 5 * GetAbilityModifier(ABILITY_WISDOM, oNPC);
  
  // Do the contested roll.
  int nResult = nModifier + d20() + GetSkillRank(nSkill, oPC) - d20() - GetSkillRank(SKILL_LISTEN, oNPC);
  
  // Determine result effect, play animations, and set up the prompt for the next attempt.
  // @@@ henchman if CR =~ hit dice
  // Display any feedback.
}

//-------------------------------------------------------------------------------------------------------
// Begin main dialog methods
//-------------------------------------------------------------------------------------------------------

void Init()
{
  object oNPC = GetLocalObject(GetPcDlgSpeaker(), "TARGET_NPC");;
  _InitialiseNPC(oNPC);
  
  if (GetElementCount(MAIN) == 0)
  {
    AddStringElement("<c  þ>[Money]</c>", MAIN);
    AddStringElement("<c  þ>[Items]</c>", MAIN);
    AddStringElement("<c  þ>[Influence]</c>", MAIN);
    AddStringElement("<c  þ>[Quests]</c>", MAIN);
	AddStringElement(txtGreen+"[Ask NPC to move aside]</c>", MAIN);
    AddStringElement("<cþ  >[Cancel]</c>", MAIN);
  }
  
  if (GetElementCount(BRIBE) == 0)
  {
    AddStringElement("<c  þ>[Speak an amount and press to continue]</c>", BRIBE);
    AddStringElement(LEAVE, BRIBE);
  }
  
  if (GetElementCount(OPTIONS) == 0)
  {
    AddStringElement(TEASE, OPTIONS);
    AddStringElement(FLATTER, OPTIONS);
    AddStringElement(CHARM, OPTIONS);
    AddStringElement(CON, OPTIONS);
    AddStringElement(BEG, OPTIONS);
    AddStringElement(INFLUENCE, OPTIONS);
    AddStringElement(BRIBE, OPTIONS);
    AddStringElement(LEAVE, OPTIONS);
  }
}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();
  object NPC   = GetLocalObject(oPC, "TARGET_NPC");
  
  if (sPage == "")
  {
    SetDlgPrompt("Social influence system.  What are you trying to get from the NPC?");
	SetDlgResponseList(MAIN);
	SetLocalString(oPC, NEXT_PROMPT, "How do you want to begin?\n\n" +
	  "Under the Flirt skill (Persuade), you can Tease (int based), Flatter (wis based) or Charm (cha based).\n" + 
	  "Under the Manipulate skill (Bluff), you can Con (int based), Beg (wis based) or Influence (cha based).\n" +
	  "Or you can try a bribe to make the NPC feel better about you.");
  }
  else if (sPage == BRIBE)
  {
    SetDlgPrompt(GetLocalString(oPC, NEXT_PROMPT));
	SetDlgResponseList(BRIBE);    
  }
  else
  {
    SetDlgPrompt(GetLocalString(oPC, NEXT_PROMPT));
	SetDlgResponseList(OPTIONS);
  }
}  

void HandleSelection()
{
  // This is the function that sets up the prompts for each page.
  string sPage   = GetDlgPageString();
  int nSelection = GetDlgSelection();
  object oPC     = GetPcDlgSpeaker();
  object oNPC    = GetLocalObject(oPC, "TARGET_NPC");
  
  if (sPage == "")
  {
    switch (nSelection)
	{
	  case 5: // cancel
	    EndDlg();
		break;
	  case 4: // step aside	
	  {
		if (TRUE) // @@@ GetNPCRep(oNPC, oPC) > 50)
		{
		  AssignCommand(oNPC, ActionMoveAwayFromObject(oPC, FALSE, 5.0));
		}  
	    EndDlg();
		break;
	  }
	  default:
	    SetLocalInt(oPC, OBJECTIVE, nSelection + 1); 
		SetDlgPageString(OPTIONS);
		break;
	}	
  }
  else if (sPage == BRIBE)
  {
    if (nSelection) 
	{
	  // Cancel
	  EndDlg();	  
	}
	else
	{
	  // Get the amount spoken.
	  string sAmount = chatGetLastMessage(oPC);
	  int    nAmount = StringToInt(sAmount);
	  if (nAmount < 1) 
	  {
	    SendMessageToPC(oPC, "Please speak a positive number.");
		return;
	  }	
	  
	  if (nAmount > GetGold(oPC)) nAmount = GetGold(oPC);
	  
	  TakeGoldFromCreature(nAmount, oPC, TRUE);
	  GiveGoldToCreature(oNPC, nAmount); // Available to pickpocket.
	  
	  // Get NPC caste.
	  int nCaste = 0; // @@@ GetNPCCaste(oNPC);
	  int nRep;
	  
	  // Based on caste and amount, determine reputation impact. 
	  switch (nCaste)
	  {
	    case CASTE_PEASANT:
		  nRep = nAmount;
		  break;
		case CASTE_WARRIOR:
		  nRep = nAmount / 10;
		  break;
		case CASTE_MERCHANT:
		  nRep = nAmount / 50;
          break;
        case CASTE_NOBILITY:
		  nRep = (nAmount - 500) / 100; // Insulted by low bribes.
          break;				  
	  }
	  
	  if (nRep > 10) nRep = 10;
	  // @@@ AdjustNPCRep(oNPC, oPC, nRep);
	  int nReaction = _DoReactionCheck(oPC, oNPC, nRep);
	  string sReaction;
	  
	  if (nRep > 0)
	  {
	    switch (nReaction)
		{
		  case -1:
		    sReaction = GetName(oNPC) + " appears insulted by your bribe!";
			break;
		  case 0:
		    sReaction = GetName(oNPC) + " pockets the money.";
			break;
		  case 1:
		    sReaction = GetName(oNPC) + " appears satisfied with the bribe.";
			break;		  
		}
	  }
	  else
	  {
	    switch (nReaction)
		{
		  case -1:
		    sReaction = GetName(oNPC) + " appears satisfied with the bribe.";
			break;
		  case 0:
		    sReaction = GetName(oNPC) + " pockets the money.";
			break;
		  case 1:
		    sReaction = GetName(oNPC) + " appears insulted by your bribe!";
			break;		 
		}
	  }
	  
	  SetDlgPageString(OPTIONS);
	}	
  }
  else
  {
    switch (nSelection)
	{
	  case 7: // leave
	    EndDlg();
		break;
	  case 6: // bribe
	    SetLocalString(oPC, NEXT_PROMPT, "Please speak an amount to bribe. (You can send " +
		"this as a Tell to yourself to keep it hidden).  A good bribe will be appropriate " +
		"to the NPC's social class."); 
	    SetDlgPageString(BRIBE);
		break;
	  default:
	    _ProcessResponse(nSelection);
		break;
	}
  }
}  

void main()
{
  int nEvent = GetDlgEventType();
  Trace(ZDIALOG, "Called zdlg_social with event... " + IntToString(nEvent));
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