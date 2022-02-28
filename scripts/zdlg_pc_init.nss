/**
  zdlg_pc_init
  
  This is based on zdlg_subrace and provides options for new players.
  
  Rather than going through one thing at a time, this presents all options side by side. 
  New PCs can pick as many of them as they like, then move on.
  A lever in the new starter area will let them restart the convo if needed.
  
  Subraces can only be picked once (since they modify stats).  Similarly, once gifts
  are applied, they can't be changed.  The convo simply stops showing the option. 

  Implementation notes:
  - The Confirm dialog looks for the ZPI_CONFIRM_DESC String variable and displays that 
    as a summary of the changes to be confirmed.  It then returns to the main page
	(whether confirmed or not).  So the same Confirm dialog can be used for all changes.

*/
#include "inc_achievements"
#include "inc_backgrounds"
#include "inc_bonuses"
#include "inc_class"
#include "inc_favsoul"
#include "inc_log"
#include "inc_subrace"
#include "inc_zdlg"

const string MAIN_MENU       = "ZPI_MAIN_MENU";
const string CONFIRM         = "ZPI_CONFIRM";
const string CONFIRM_DESC    = "ZPI_CONFIRM_DESC";
const string CONFIRM_PAGE    = "ZPI_CONFIRM_PAGE";
const string CONFIRM_OPT     = "ZPI_CONFIRM_OPT";
const string SUBRACE_OPTS    = "ZPI_SUBRACE_OPTIONS";
const string BACKGROUND_OPTS = "ZPI_BACKGROUND_OPTIONS";
const string GIFT_OPTS       = "ZPI_GIFT_OPTIONS";
const string PATH_OPTS       = "ZPI_PATH_OPTIONS";
const string HEIGHT_OPTS     = "ZPI_HEIGHT_OPTIONS";
const string AWARD_OPTS      = "ZPI_AWARD_OPTIONS";

const string SPELLSWORD_OPTIONS    = "spellsword options";

const string SU_SELECTIONS   = "ZPI_SU_SELECTIONS"; // Used to record int versions for ease of access later.
const string BA_SELECTIONS   = "ZPI_BA_SELECTIONS"; // Used to record int versions for ease of access later.

// Disabled path options, keeping to include later.
const string PACT_SELECT     = "ZPI_PACT_OPTIONS";
const string TOTEM_SELECT    = "ZPI_TOTEM_OPTIONS"; 

const string VAR_GIFT_1 = "VAR_GIFT_1";
const string VAR_GIFT_2 = "VAR_GIFT_2";
const string VAR_GIFT_3 = "VAR_GIFT_3";
const string VAR_GIFT_4 = "VAR_GIFT_4";
const string VAR_PATH   = "VAR_PATH";

string INTRO = "Welcome to Anemoi: Fall of Man(?)!  This module is set up to support conflict roleplay, and plot discovery.  PCs will find themselves part of a well defined society, but anything or " +
"everything taken commonly to be true may or may not be a lie.  The hope is that as players discover secrets, that knowledge will interact with the political landscape in fun ways. " +
"\n\nAt present we only support a limited number of races and classes, but before entering the gameworld, you can choose 'gifts' and 'paths' that will give you some more variety in options. " +
"Over time, more options will become available - we've limited options to make the world and setting more coherent and structured, and we hope that pays off in the roleplay experience you get!";

string PATH_INTRO = "You may choose to follow a path.  A path modifies a class "+
  "giving you some unique benefits, but also some significant restrictions." +
  "\n\nYou may pick from the following paths:";
  
string BACKGROUND_INTRO = "You may choose a starting faction for your character (recommended!). " +
  "Factions have a significant effect on the starting location and career options on your character.  Available (starting) factions:\n\n"; 

void _removeAward(object oPC, string sAwardType)
{
    string sID = gsPCGetCDKeyID(GetPCPublicCDKey(oPC));
    int nAwards = GetLocalInt(oPC, "sAwardType") -1;
    miDASetKeyedValue("gs_player_data", sID, "sAwardType", IntToString(nAwards));	
	
    SetLocalInt(oPC, "award1", 0);
    SetLocalInt(oPC, "award2", 0);
    SetLocalInt(oPC, "award3", 0);
}

void _gvdCreateBaseInventoryForRace(object oPC) 
{
  // get subrace name
  string sRaceName = GetSubRace(oPC);

  // clean name for use as tag
  sRaceName = GetStringUpperCase(sRaceName);
  sRaceName = StringReplace(sRaceName, " ", "");
  sRaceName = StringReplace(sRaceName, "-", "");

  // see if there is a starting gear NPC for this specific subrace
  object oStartNPC = GetObjectByTag("GVD_STARTINV_" + sRaceName);

  // if no subrace or no NPC with starting gear for this subrace, use base race
  if ((sRaceName == "") || (oStartNPC == OBJECT_INVALID)) {
    sRaceName = gsSUGetRaceName(GetRacialType(oPC));
    sRaceName = GetStringUpperCase(sRaceName);
    sRaceName = StringReplace(sRaceName, " ", "");
    sRaceName = StringReplace(sRaceName, "-", "");
    oStartNPC = GetObjectByTag("GVD_STARTINV_" + sRaceName);
  }

  object oItem;

  // NPC found?
  if (oStartNPC != OBJECT_INVALID) {

    // copy inventory first
    oItem  = GetFirstItemInInventory(oStartNPC);
    object oCopy  = OBJECT_INVALID;

    while (oItem != OBJECT_INVALID) {

      oCopy = gsCMCopyItem(oItem, oPC);

      if (GetIsObjectValid(oCopy)) {
        SetIdentified(oCopy, TRUE);
        SetStolenFlag(oCopy, FALSE);
      }

      oItem = GetNextItemInInventory(oStartNPC);

    }

    // now copy equipped gear
    int i;
    for (i = 0; i < NUM_INVENTORY_SLOTS; ++i) {

      oItem = GetItemInSlot(i, oStartNPC);

      if (oItem != OBJECT_INVALID) {
        // copy item to PC and equip in same slot
        oCopy = gsCMCopyItem(oItem, oPC);

        if (GetIsObjectValid(oCopy)) {
          SetIdentified(oCopy, TRUE);
          SetStolenFlag(oCopy, FALSE);
        }

        AssignCommand(oPC, ActionEquipItem(oCopy, i));

      }
    }
  }
}

//--------------------------------------------------------------------------------------------------------
// Subrace-related utility methods.
//--------------------------------------------------------------------------------------------------------

void _AddSubraceAsOption(int nSubRace)
{
  Trace(SUBRACE, "Adding option for subrace: " + gsSUGetNameBySubRace(nSubRace));
  // As we add elements to the list, create a separate list containing the
  // available selections with a link to their subrace constants. This will
  // make it much easier to tally responses.
  int nECL     = gsSUGetECL(nSubRace, 0);
  string sText = gsSUGetNameBySubRace(nSubRace);
  if (sText == "") sText = "[No subrace]";

  if (nECL) sText += " [ECL +"+IntToString(nECL)+"]";
  AddStringElement(sText, SUBRACE_OPTS);
  AddIntElement(nSubRace, SU_SELECTIONS);
}

void _ClearSubRaceOptions()
{
  Trace(SUBRACE, "Clearing subraces for new conversation.");
  DeleteList(SUBRACE_OPTS);
  DeleteList(SU_SELECTIONS);
}

void _DoRaceChange(int nSubRace)
{
  object oPC  = GetPcDlgSpeaker();
  int nRace = 0;
  
  if (nSubRace == 96 || nSubRace == 97)      nRace = RACIAL_TYPE_HALFELF;
  else if (nSubRace == 98 || nSubRace == 99) nRace = 21; // Elfling

  if (!nRace) return;
  
  switch (nRace)
  {
    case RACIAL_TYPE_HALFELF:
	{
		// Remove Elven feats that we don't want to keep..
        if (GetHasFeat(FEAT_KEEN_SENSE, oPC))               NWNX_Creature_RemoveFeat(oPC, FEAT_KEEN_SENSE);
        if (GetHasFeat(FEAT_SKILL_AFFINITY_LISTEN, oPC))    NWNX_Creature_RemoveFeat(oPC, FEAT_SKILL_AFFINITY_LISTEN);
        if (GetHasFeat(FEAT_SKILL_AFFINITY_SEARCH, oPC))    NWNX_Creature_RemoveFeat(oPC, FEAT_SKILL_AFFINITY_SEARCH);
        if (GetHasFeat(FEAT_SKILL_AFFINITY_SPOT, oPC))      NWNX_Creature_RemoveFeat(oPC, FEAT_SKILL_AFFINITY_SPOT);
        if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_ELF, oPC))   NWNX_Creature_RemoveFeat(oPC, FEAT_WEAPON_PROFICIENCY_ELF);
			
		// Add Half-Elf feats.	
        if (!GetHasFeat(FEAT_PARTIAL_SKILL_AFFINITY_LISTEN, oPC))    NWNX_Creature_AddFeat(oPC, FEAT_PARTIAL_SKILL_AFFINITY_LISTEN);
        if (!GetHasFeat(FEAT_PARTIAL_SKILL_AFFINITY_SEARCH, oPC))    NWNX_Creature_AddFeat(oPC, FEAT_PARTIAL_SKILL_AFFINITY_SEARCH);
        if (!GetHasFeat(FEAT_PARTIAL_SKILL_AFFINITY_SPOT, oPC))      NWNX_Creature_AddFeat(oPC, FEAT_PARTIAL_SKILL_AFFINITY_SPOT);
		
		NWNX_Creature_SetRacialType(oPC, nRace);
		SetCreatureAppearanceType(oPC, 4);
		break;
	}
	case 21: // Elfling
	{
		// Remove Elven feats that we don't want to keep..
        if (GetHasFeat(FEAT_SKILL_AFFINITY_SEARCH, oPC))    NWNX_Creature_RemoveFeat(oPC, FEAT_SKILL_AFFINITY_SEARCH);
        if (GetHasFeat(FEAT_SKILL_AFFINITY_SPOT, oPC))      NWNX_Creature_RemoveFeat(oPC, FEAT_SKILL_AFFINITY_SPOT);
        if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_ELF, oPC))   NWNX_Creature_RemoveFeat(oPC, FEAT_WEAPON_PROFICIENCY_ELF);
			
		// Add Elfling feats.  Note Elflings get listen from both sides so retain full affinity.	 
        if (!GetHasFeat(FEAT_PARTIAL_SKILL_AFFINITY_SEARCH, oPC))    NWNX_Creature_AddFeat(oPC, FEAT_PARTIAL_SKILL_AFFINITY_SEARCH);
        if (!GetHasFeat(FEAT_PARTIAL_SKILL_AFFINITY_SPOT, oPC))      NWNX_Creature_AddFeat(oPC, FEAT_PARTIAL_SKILL_AFFINITY_SPOT);
        if (!GetHasFeat(FEAT_LUCKY, oPC))      						 NWNX_Creature_AddFeat(oPC, FEAT_LUCKY);
		
		NWNX_Creature_SetRacialType(oPC, nRace);
		SetCreatureAppearanceType(oPC, 2081);
		_removeAward(oPC, "award2");    
		SetLocalInt(gsPCGetCreatureHide(oPC), "HAS_NORMAL_AWARD", TRUE);
		
		break;
	}
  }
  
  switch (nSubRace)
  {
    // Hand out either the Elven permission token or the swimming certificate depending on choice.
	case 96:
	case 98:
	  // swimming
	  CreateItemOnObject("permission_sea", oPC);
	  break;
	case 97:
	case 99:
	  // mythal
	  CreateItemOnObject("elf_safe_passage", oPC);
	  break;
  }
  
  // Resize ourselves appropriately.
  gsPCRefreshCreatureScale(oPC);
}

int _ApplySubRace()
{
  object oSpeaker  = GetPcDlgSpeaker();
  object oProperty = gsPCGetCreatureHide(oSpeaker, TRUE);
  object oAbility  = GetItemPossessedBy(oSpeaker, "GS_SU_ABILITY");
  int nSubRace     = GetIntElement(GetLocalInt(OBJECT_SELF, CONFIRM_OPT), SU_SELECTIONS);
  int nLevel       = GetHitDice(oSpeaker);
  Trace(SUBRACE, "Applying subrace: " + gsSUGetNameBySubRace(nSubRace));

  if (nSubRace > 90)
  {
    // Special - Half-Elf / Elfling race changes.
	// Don't apply a subrace yet - just change race and leave this menu to repeat as needed.
	_DoRaceChange(nSubRace);
	return 0;
  }

  if (nSubRace == GS_SU_NONE)
  {
    if (GetIsObjectValid(oProperty))
    {
        gsIPRemoveAllProperties(oProperty);
    }

    // Have to set a subrace so that the background code can modify it.
    SetSubRace(oSpeaker, gsSUGetRaceName(GetRacialType(oSpeaker)));
	
	// Apply the (empty) subrace to avoid this option being available again.
	gsSUApplyProperty(oProperty, nSubRace, nLevel);
  }
  else
  {
    if (! GetIsObjectValid(oAbility))
    {
      oAbility  = CreateItemOnObject(GS_SU_TEMPLATE_ABILITY,  oSpeaker);
    }

    if (GetIsObjectValid(oProperty))
    {
      gsSUApplyProperty(oProperty, nSubRace, nLevel);
      miBAIncreaseECL(oSpeaker, IntToFloat(gsSUGetECL(nSubRace, 0)));
      SetLocalInt(oProperty, "GIFT_SUBRACE", TRUE);
	  
    }

    if (GetIsObjectValid(oAbility))
    {
      gsSUApplyAbility(oAbility, nSubRace, nLevel);
    }

    SetSubRace(oSpeaker, gsSUGetNameBySubRace(nSubRace));

    // Septire - Adding in Race Change here, sets the player's race to correspond with their subrace selection.
    // Important note: This will cause PCs not to be subject to Multiclassing Penalties, so we need to cover these
    //                 cases in our XP system if they are not already.
    switch (nSubRace)
    {
      case GS_SU_SPECIAL_FEY:
        SetCreatureAppearanceType(oSpeaker, APPEARANCE_TYPE_FAIRY);
        //SetRacialType(oSpeaker, RACIAL_TYPE_FEY);
        break;
      case GS_SU_SPECIAL_GOBLIN:
        SetCreatureAppearanceType(oSpeaker, APPEARANCE_TYPE_GOBLIN_A);
        //SetRacialType(oSpeaker, RACIAL_TYPE_HUMANOID_GOBLINOID);
        break;
      case GS_SU_SPECIAL_KOBOLD:
        SetCreatureAppearanceType(oSpeaker, APPEARANCE_TYPE_KOBOLD_A);
        //SetRacialType(oSpeaker, RACIAL_TYPE_HUMANOID_REPTILIAN);
        break;
      case GS_SU_SPECIAL_RAKSHASA:
        SetCreatureAppearanceType(oSpeaker,
          GetGender(oSpeaker) ? APPEARANCE_TYPE_RAKSHASA_TIGER_FEMALE : APPEARANCE_TYPE_RAKSHASA_TIGER_MALE);
        // Not going to touch this one, technically they should be outsiders but I think Planar Turning can affect them as can Banishment and Dismissal if they are set.
        // SetRacialType(oSpeaker, RACIAL_TYPE_OUTSIDER);
        break;
      case GS_SU_SPECIAL_OGRE:
        SetCreatureAppearanceType(oSpeaker, APPEARANCE_TYPE_OGRE);
        //SetRacialType(oSpeaker, RACIAL_TYPE_GIANT);
        SetCreatureSize(oSpeaker, CREATURE_SIZE_LARGE);
        break;
      case GS_SU_SPECIAL_HOBGOBLIN:
        SetCreatureAppearanceType(oSpeaker, APPEARANCE_TYPE_HOBGOBLIN_WARRIOR);
        //SetRacialType(oSpeaker, RACIAL_TYPE_HUMANOID_GOBLINOID);
        break;

    }
  }

  // dunshine: handle racial starting equipment here
  _gvdCreateBaseInventoryForRace(oSpeaker);

  md_AddRacialBonuses(oSpeaker, nSubRace, oProperty);

  //:: Remove awards if an award subrace was selected.
  if (nSubRace == GS_SU_SHAPECHANGER)
  {
	
    SetLocalInt(oProperty, "HAS_MAJOR_AWARD", TRUE);  
	
	_removeAward(oSpeaker, "award1");
  }
  
  if (FALSE)
  {
    // Septire - An award has been spent on this character. Treat this character as having no additional awards to spend.
    // We assume that only ONE award can be spent on each character. Do NOT update the database (Mith - unclear why...).
    SetLocalInt(oProperty, "HAS_NORMAL_AWARD", TRUE);
	_removeAward(oSpeaker, "award2");
  }
  
  return 0;
}

void _SetUpAllowedSubraces()
{ 
  //----------------------------------------------------------------------------
  // Options for subraces. These vary with each PC so generate them afresh
  // each time a new PC starts this conversation.
  //----------------------------------------------------------------------------
  _ClearSubRaceOptions();
  
  object oPC = GetPcDlgSpeaker();
  int nRace = GetRacialType(oPC);

  if (nRace == RACIAL_TYPE_DWARF)
  {
    // Dwarf subraces
  }
  else if (nRace == RACIAL_TYPE_ELF)
  {
    // Elf subraces - disabled for now.
	if (acPlayerHasAchievement(oPC, "airevorn"))
	{
		AddStringElement("Half-Elf (can swim)", SUBRACE_OPTS);
		AddIntElement(96, SU_SELECTIONS);
		AddStringElement("Half-Elf (can pass mythal)", SUBRACE_OPTS);
		AddIntElement(97, SU_SELECTIONS);
	  
		if (GetLocalInt(oPC, "award2"))
		{
			AddStringElement("Elfling (can swim) (NORMAL AWARD)", SUBRACE_OPTS);
			AddIntElement(98, SU_SELECTIONS);
			AddStringElement("Elfling (can pass mythal) (NORMAL AWARD)", SUBRACE_OPTS);
			AddIntElement(99, SU_SELECTIONS);
		}
	}
  }
  else if (nRace == RACIAL_TYPE_GNOME)
  {
    // Gnome subraces
  }
  else if (nRace == RACIAL_TYPE_HALFLING)
  {
    // Halfling subraces - disabled for now.
  }
  else if (nRace == RACIAL_TYPE_HALFORC)
  {
    // Halforc options - none for now
  }
  else if (nRace == RACIAL_TYPE_HALFELF)
  {
    // Halfelf options - none for now
  }
  else if (nRace == 21) // Elfling
  {
    // Elfling options - none for now.
  }

  if (GetLocalInt(oPC, "award1")) // Available as a Major award only.
  {
    // Add award-locked subraces here.  Don't forget to remove the award in _ApplySubRace above.
	if (acPlayerHasAchievement(oPC, "werecats") && acPlayerHasAchievement(oPC, "werebeetles") &&
	     acPlayerHasAchievement(oPC, "wererats") && acPlayerHasAchievement(oPC, "weresharks") &&
		 miBAGetBackground(oPC) == MI_BA_NONE && !GetIsObjectValid(GetItemPossessedBy(oPC, "elf_safe_passage")))
	{
	  _AddSubraceAsOption(GS_SU_SHAPECHANGER);
	}
  }
  
  if (GetLocalInt(oPC, "award2") || GetLocalInt(oPC, "award1")) // Available as a Normal award only.
  {
    // Add award-locked subraces here.  Don't forget to remove the award in _ApplySubRace above.
  }

  if(GetLocalInt(oPC, "award2") || GetLocalInt(oPC, "award1") || GetLocalInt(oPC, "award3")) //minor
  {
    // Add award-locked subraces here.  Don't forget to remove the award in _ApplySubRace above.
  }

  _AddSubraceAsOption(GS_SU_NONE);
}

//--------------------------------------------------------------------------------------------------------
// Background-related utility methods.
//--------------------------------------------------------------------------------------------------------

void _AddBackgroundAsOption(int nBackground)
{
  Trace(BACKGROUNDS, "Adding option for background: " + miBAGetBackgroundName(nBackground));
  AddStringElement(miBAGetBackgroundName(nBackground) + (nBackground == MI_BA_DRANNIS ? " (Recommended for new players)": ""), BACKGROUND_OPTS);
  AddIntElement(nBackground, BA_SELECTIONS);
}

void _ClearBackgroundOptions()
{
  Trace(BACKGROUNDS, "Clearing backgrounds for new conversation.");
  DeleteList(BACKGROUND_OPTS);
  DeleteList(BA_SELECTIONS);
}

void _SetUpAllowedBackgrounds()
{
  object oPC = GetPcDlgSpeaker();

  //----------------------------------------------------------------------------
  // Set up available backgrounds. These vary with each PC so generate them
  // afresh each time a new PC starts this conversation.
  //----------------------------------------------------------------------------
  _ClearBackgroundOptions();
  int ii;

  //----------------------------------------------------------------------------
  // We start at 1 because 0 is the 'none' option and we present that
  //last.
  //----------------------------------------------------------------------------
  for (ii = 1; ii < MI_BA_NUM_BACKGROUNDS; ii++)
  {
    if (miBAGetIsBackgroundLegal(ii, oPC))
    {
      _AddBackgroundAsOption(ii);
    }
  }

  if (acPlayerHasAchievement(oPC, "undercity"))
	_AddBackgroundAsOption(MI_BA_NONE);
}

void _ApplyBackground()
{
  object oSpeaker  = GetPcDlgSpeaker();
  int nBackground  = GetIntElement(GetLocalInt(OBJECT_SELF, CONFIRM_OPT), BA_SELECTIONS);
  SendMessageToPC(oSpeaker, "Applying selected background: " + miBAGetBackgroundName(nBackground));
  miBAApplyBackground(oSpeaker, nBackground, TRUE);
}

//--------------------------------------------------------------------------------------------------------
// Gift-related utility methods.
//--------------------------------------------------------------------------------------------------------
void _ApplyGifts()
{
    object oPC      = GetPcDlgSpeaker();
	object oHide    = gsPCGetCreatureHide(oPC, TRUE);
	object oAbility = GetItemPossessedBy(oPC, "GS_SU_ABILITY");
    int nGift1      = GetGiftFromDescription(GetLocalString(oPC, VAR_GIFT_1));
    int nGift2      = GetGiftFromDescription(GetLocalString(oPC, VAR_GIFT_2));
    int nGift3      = GetGiftFromDescription(GetLocalString(oPC, VAR_GIFT_3));
	
    if (! GetIsObjectValid(oAbility))
    {
      oAbility  = CreateItemOnObject(GS_SU_TEMPLATE_ABILITY,  oPC);
    }

	if (GetListSize(oAbility, "Gifts") < 1) 
	{
	  AddGift(oPC, nGift1);
      SetDescription(oAbility, GetDescription(oAbility) + "\nGift 1: " + GetGiftDescription(nGift1));
	  SetDlgPageString(GIFT_OPTS);
	  SetLocalInt(oHide, "GIFT_1", nGift1);
	}  
	else if (GetListSize(oAbility, "Gifts") < 2) 
	{
	  AddGift(oPC, nGift2);
	  SetDescription(oAbility, GetDescription(oAbility) + "\nGift 2: " + GetGiftDescription(nGift2));
	  SetDlgPageString(GIFT_OPTS);
	  SetLocalInt(oHide, "GIFT_2", nGift2);
	}
	else if (GetListSize(oAbility, "Gifts") < 3) 
	{
	  AddGift(oPC, nGift3);
	  SetDescription(oAbility, GetDescription(oAbility) + "\nGift 3: " + GetGiftDescription(nGift3));
	  SetLocalInt(oHide, "GIFT_3", nGift3);
	}  
	// If none of the above, this was called in error.
}

// Call each time the menu loads to rule out gifts already chosen
//Also check for major and minor gifts!
void _AddGiftIfNotTaken(object oPC, string sGift)
{
  object oHide = gsPCGetCreatureHide(oPC, TRUE);
  string sGift1 = GetLocalInt(oHide, "GIFT_1") ? GetLocalString(oPC, VAR_GIFT_1) : "";
  string sGift2 = GetLocalInt(oHide, "GIFT_2") ? GetLocalString(oPC, VAR_GIFT_2) : "";
  string sGift3 = GetLocalInt(oHide, "GIFT_3") ? GetLocalString(oPC, VAR_GIFT_3) : "";
  int nMajor1 = FindSubString(sGift1, "MAJOR");
  int nMajor2 = FindSubString(sGift2, "MAJOR");
  int nMajor3 = FindSubString(sGift3, "MAJOR");
  int nNewGift = FindSubString(sGift, "MAJOR");
  int nECL = gsSUGetECL(gsSUGetSubRaceByName(GetSubRace(oPC)), 0);
  if(nECL <= 0)
  {
    if(nNewGift >= 0 &&
        ((nMajor1 >= 0 && (nMajor2 >= 0 || nMajor3 >= 0)) ||
        (nMajor2 >= 0 && nMajor3 >=0)))
        return;
  }
  else if(nECL < 2)
  {
    if(nNewGift >= 0 &&
        (nMajor1 >= 0 || nMajor2 >= 0 || nMajor3 >= 0))
        return;
  }
  else if(nECL < 3)
  {
    if(nNewGift >= 0)
        return;
  }
  if (sGift1 != sGift &&
      sGift2 != sGift &&
      sGift3 != sGift)
  {
    AddStringElement(sGift, GIFT_OPTS);
  }
}

void _SetUpAllowedGifts()
{
  DeleteList(GIFT_OPTS);

  object oPC = GetPcDlgSpeaker();
  _AddGiftIfNotTaken(oPC, GIFT_OF_MIGHT_DESC);
  _AddGiftIfNotTaken(oPC, GIFT_OF_GRACE_DESC);
  _AddGiftIfNotTaken(oPC, GIFT_OF_ENDURANCE_DESC_M);
  _AddGiftIfNotTaken(oPC, GIFT_OF_LEARNING_DESC);
  _AddGiftIfNotTaken(oPC, GIFT_OF_INSIGHT_DESC);
  _AddGiftIfNotTaken(oPC, GIFT_OF_CONFIDENCE_DESC);
  _AddGiftIfNotTaken(oPC, GIFT_OF_WEALTH_DESC);
  _AddGiftIfNotTaken(oPC, GIFT_OF_TONGUES_DESC);
  _AddGiftIfNotTaken(oPC, GIFT_OF_HARDINESS_DESC);
  _AddGiftIfNotTaken(oPC, GIFT_OF_DARKNESS_DESC);
  _AddGiftIfNotTaken(oPC, GIFT_OF_HIDING_DESC);
  _AddGiftIfNotTaken(oPC, GIFT_OF_LIGHT_DESC);
  _AddGiftIfNotTaken(oPC, GIFT_OF_THE_GAB_DESC);
  _AddGiftIfNotTaken(oPC, GIFT_OF_THE_HUNTER_DESC);
  _AddGiftIfNotTaken(oPC, GIFT_OF_THE_SNEAK_DESC);
  _AddGiftIfNotTaken(oPC, GIFT_OF_STARDOM_DESC);
  _AddGiftIfNotTaken(oPC, GIFT_OF_LIGHTFINGERS_DESC);
  _AddGiftIfNotTaken(oPC, GIFT_OF_FORTUNE_DESC_M);
  _AddGiftIfNotTaken(oPC, GIFT_OF_CRAFTSMANSHIP_DESC);
  _AddGiftIfNotTaken(oPC, GIFT_OF_HUMILITY_DESC);
  _AddGiftIfNotTaken(oPC, GIFT_OF_GREENFINGERS_DESC);
  _AddGiftIfNotTaken(oPC, GIFT_OF_HOLY_DESC);
  _AddGiftIfNotTaken(oPC, GIFT_OF_UNIQUE_FAVOR_DESC);

  if(gsSUGetSubRaceByName(GetSubRace(oPC)) == GS_SU_SPECIAL_OGRE)
  {
    _AddGiftIfNotTaken(oPC, GIFT_OF_OG_MAGI_DESC);
  }

  AddStringElement(GIFT_NONE_DESC, GIFT_OPTS);
}

//--------------------------------------------------------------------------------------------------------
// Path-related utility methods.
//--------------------------------------------------------------------------------------------------------
void _SetUpAllowedPaths()
{
  DeleteList(PATH_OPTS);

  object oPC = GetPcDlgSpeaker();

  if (GetLevelByClass(CLASS_TYPE_BARBARIAN, oPC))
  {
    AddStringElement(PATH_OF_THE_TRIBESMAN, PATH_OPTS);
	PATH_INTRO += "Barbarian - Tribesman: Rage loses its normal effects, but summons an NPC of your faction to fight with you.  You can have two followers at any point.\n";
  }

  if (GetLevelByClass(CLASS_TYPE_CLERIC, oPC))
  {
    AddStringElement(PATH_OF_THE_HEALER, PATH_OPTS);
    // AddStringElement(PATH_OF_FAVOURED_SOUL, PATH_OPTS);
	PATH_INTRO += 
      "Cleric - Healer: Become a more potent healer, but cannot gain proficiency in armors or weapons other than Simple weapons.\n";
       // "Cleric - Favoured Soul: Spontaneous casting of cleric spells, but lose Domains, Heavy Armour and Turn Undead. \n";
  }

  if (GetLevelByClass(CLASS_TYPE_RANGER, oPC))
  {
    AddStringElement(PATH_OF_THE_ARCHER, PATH_OPTS);
    //AddStringElement(PATH_OF_THE_SNIPER, PATH_OPTS);
	PATH_INTRO += 
      "Ranger - Archer: Lose dual wield feats but create a quiver of arrows 1/day.\n" +
      "Ranger - Sniper: Lose dual wield feats but gain point blank shot and rapid shot at level 1\n";
  }

  if (!GetLevelByClass(CLASS_TYPE_SORCERER, oPC) &&
      !GetLevelByClass(CLASS_TYPE_DRUID, oPC) &&
      !GetLevelByClass(CLASS_TYPE_CLERIC, oPC) &&
      !GetLevelByClass(CLASS_TYPE_BARD, oPC) &&
      !GetLevelByClass(CLASS_TYPE_FAVOURED_SOUL, oPC) &&
      !GetLevelByClass(CLASS_TYPE_SHAMAN, oPC) &&
      !GetLevelByClass(CLASS_TYPE_WIZARD, oPC))
  {
    AddStringElement(PATH_OF_THE_KENSAI, PATH_OPTS);
	PATH_INTRO += 
      "Melee Classes - Kensai: One extra attack, +2 natural AC. May not take levels in wizard, sorcerer, bard, druid, favoured soul or cleric, may not cast spellbook spells, may not use "+
      "potions or bound spells, and are restricted to melee and throwing weapons.\n";
  }
  
  /** Not currently available, but may be added later.
  if (GetLevelByClass(CLASS_TYPE_DRUID, oPC))
  {
    AddStringElement(PATH_OF_TOTEM, PATH_OPTS);
  }

  if (GetLevelByClass(CLASS_TYPE_BARD, oPC) && GetAlignmentGoodEvil(oPC) != ALIGNMENT_GOOD)
  {
    AddStringElement(PATH_OF_WARLOCK, PATH_OPTS);
  }
  
  */

  if (GetLevelByClass(CLASS_TYPE_SORCERER, oPC))
  {
    //AddStringElement(PATH_OF_TRUE_FIRE, PATH_OPTS);
    AddStringElement(PATH_OF_SHADOW, PATH_OPTS);
  }
  
  if (GetLevelByClass(CLASS_TYPE_WIZARD, oPC)  && GetSpecialization(oPC) != SPELL_SCHOOL_EVOCATION)
  {
    AddStringElement(PATH_OF_SHADOW, PATH_OPTS);
  }

  //::  Wild Mage and Spellsword only for Non-Specialized (General) Wizards.
  if ( GetLevelByClass(CLASS_TYPE_WIZARD, oPC) && GetSpecialization(oPC) == SPELL_SCHOOL_GENERAL )
  {
    //AddStringElement(PATH_OF_WILD_MAGE, PATH_OPTS);
    AddStringElement(PATH_OF_SPELLSWORD, PATH_OPTS);
  }
  

  AddStringElement(PATH_NONE, PATH_OPTS);
}

void _ApplyPath()
{
    object oPC = GetPcDlgSpeaker();  
    object oItem = gsPCGetCreatureHide(oPC, TRUE);

    // What we do here depends on which path it is.
    // This is the last part of this convo, so we can start other convos.
    object oAbility  = GetItemPossessedBy(oPC, "GS_SU_ABILITY");
    string sPath = GetLocalString(OBJECT_SELF, CONFIRM_DESC);
	
    if (! GetIsObjectValid(oAbility))
    {
      oAbility  = CreateItemOnObject(GS_SU_TEMPLATE_ABILITY, oPC);
    }
	
    SetDescription(oAbility, GetDescription(oAbility) + "\nPath: " + sPath);
    SetIdentified(oAbility, TRUE);
    SetLocalString(oItem, "MI_PATH", sPath);

    if (sPath == PATH_NONE)
    {
	  // Do nothing.
    }
    else if (sPath == PATH_OF_WARLOCK)
    {
        SetDlgPageString(PACT_SELECT);
    }
    else if (sPath == PATH_OF_TOTEM)
    {
        SetDlgPageString(TOTEM_SELECT);
    }
    else if (sPath == PATH_OF_THE_KENSAI)
    {
        // Flag that they are a kensai and hence unable to cast spells etc.
        SetLocalInt(oItem, "KENSAI", TRUE);
    }
    else if (sPath == PATH_OF_TRUE_FIRE)
    {
        // Flag that they are a true-fire sorc.
        SendMessageToPC(oPC, "You have selected Path of True Fire.");
        SetLocalInt(oItem, "TRUE_FIRE", TRUE);
    }
    else if (sPath == PATH_OF_THE_ARCHER)
    {
        // Give the innate abilities a 1/day use (for spawning arrows).

        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_UNIQUE_POWER_SELF_ONLY,
                                              IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oAbility);

        // Store that we are an archer in case we add any more innate powers
        // in future.
        SendMessageToPC(oPC, "You have selected Path of the Archer.");
        RemoveRangerDualWieldFeats(oPC);
        SetLocalInt(oItem, "ARCHER", TRUE);
    }
    else if (sPath == PATH_OF_THE_SNIPER)
    {
        SendMessageToPC(oPC, "You have selected Path of the Sniper.");
        RemoveRangerDualWieldFeats(oPC);
        AddSniperFeats(oPC);
    }
    else if (sPath == PATH_OF_THE_HEALER)
    {
        if (GetHasFeat(FEAT_ARMOR_PROFICIENCY_HEAVY, oPC)) NWNX_Creature_RemoveFeat(oPC, FEAT_ARMOR_PROFICIENCY_HEAVY);
        if (GetHasFeat(FEAT_ARMOR_PROFICIENCY_LIGHT, oPC)) NWNX_Creature_RemoveFeat(oPC, FEAT_ARMOR_PROFICIENCY_LIGHT);
        if (GetHasFeat(FEAT_ARMOR_PROFICIENCY_MEDIUM, oPC)) NWNX_Creature_RemoveFeat(oPC, FEAT_ARMOR_PROFICIENCY_MEDIUM);
        if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_ELF, oPC)) NWNX_Creature_RemoveFeat(oPC, FEAT_WEAPON_PROFICIENCY_ELF);
        if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC)) NWNX_Creature_RemoveFeat(oPC, FEAT_WEAPON_PROFICIENCY_EXOTIC);
        if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC)) NWNX_Creature_RemoveFeat(oPC, FEAT_WEAPON_PROFICIENCY_MARTIAL);

        SendMessageToPC(oPC, "You have selected Path of the Healer.");
        SetLocalInt(oItem, "HEALER", TRUE);
    }
	else if (sPath == PATH_OF_FAVOURED_SOUL)
	{
	    // Remove both domains.
		NWNX_Creature_SetDomain(oPC, CLASS_TYPE_CLERIC, 1, 2); // 2 is an unused index in domains.2da.
		NWNX_Creature_SetDomain(oPC, CLASS_TYPE_CLERIC, 2, 2); // 2 is an unused index in domains.2da.
		
		// Remove all domain feats. 
		int nFeat;
		for (nFeat = 306; nFeat < 326; nFeat++)
		{
		  NWNX_Creature_RemoveFeat(oPC, nFeat);
		}  
		
		// Remove heavy armour proficiency and Turn Undead.
		NWNX_Creature_RemoveFeat(oPC, FEAT_ARMOR_PROFICIENCY_HEAVY);
		NWNX_Creature_RemoveFeat(oPC, FEAT_TURN_UNDEAD);
		
		// Improve reflex saves (+0 -> +2 at first level)
		AddItemProperty(DURATION_TYPE_PERMANENT,
		                ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_REFLEX, 2),
						oItem);
		
		SetLocalInt(oItem, "FAVOURED_SOUL", TRUE);	
	}
    else if (sPath == PATH_OF_SHADOW)
    {
        SetLocalInt(oItem, "SHADOW_MAGE", TRUE);
        miCLOverridePRC(oPC);
        SendMessageToPC(oPC, "You have selected Shadow Mage.");
    }
    else if (sPath == PATH_OF_THE_TRIBESMAN)
    {
        // Flag that they are a tribesman barbarian.  Used in the rage script.
        SetLocalInt(oItem, "TRIBESMAN", TRUE);
        SendMessageToPC(oPC, "You have selected Path of the Tribesman.");
    }
    else if (sPath == PATH_OF_WILD_MAGE)
    {
        // Flag that they are a wild mage wiz.
        SendMessageToPC(oPC, "You have selected the Wild Mage School.");
        SetLocalInt(oItem, "WILD_MAGE", TRUE);
    }
    else if (sPath == PATH_OF_SPELLSWORD)
    {
        // Flag that they are a spellsword.
        SendMessageToPC(oPC, "You have selected the Spellsword path.");
        SetDlgPageString(SPELLSWORD_OPTIONS);
    }
}

void _SetUpMainOptions()
{ 
  object oPC       = GetPcDlgSpeaker();
  object oHide     = gsPCGetCreatureHide(oPC, TRUE);
  
  if (!GetIsObjectValid(oHide))
  {
    oHide = CreateItemOnObject(GS_SU_TEMPLATE_PROPERTY, oPC);

    if (GetIsObjectValid(oHide))
    {
        AssignCommand(oPC, ActionEquipItem(oHide, INVENTORY_SLOT_CARMOUR));
    }
  }
  
  DeleteList(MAIN_MENU);
  
  if (!GetLocalInt(oHide, "APPLIED_ABILITIES"))  AddStringElement("Subrace options", MAIN_MENU);
  if (miBAGetBackground(oPC) == MI_BA_NONE) AddStringElement("Faction options", MAIN_MENU);
  if (GetLocalString(oHide, "MI_PATH") == "") AddStringElement("Path options", MAIN_MENU);
  if (!GetLocalInt(oHide, "GIFT_3")) AddStringElement("Gift options", MAIN_MENU);
  if (GetLocalInt(oPC, "award1") || GetLocalInt(oPC, "award2") || GetLocalInt(oPC, "award3")) AddStringElement("Award options", MAIN_MENU);
  AddStringElement("PC height options", MAIN_MENU);
  AddStringElement("[Done]", MAIN_MENU);
  
  if (GetElementCount(HEIGHT_OPTS) == 0)
  {
    AddStringElement("Normal height", HEIGHT_OPTS);
    AddStringElement("Shorter than average", HEIGHT_OPTS);
    AddStringElement("Taller than average", HEIGHT_OPTS);
    AddStringElement("Very short", HEIGHT_OPTS);
    AddStringElement("Very tall", HEIGHT_OPTS);
  }
  
}

//------------------------------------------------------------------------------
// end utility methods - everything below here is part of the conversation.
//------------------------------------------------------------------------------
void Init()
{
  // This method is called once, at the start of the conversation.
  Trace(SUBRACE, "Subrace conversation initialising.");
  
  object oPC       = GetPcDlgSpeaker();
  object oHide     = gsPCGetCreatureHide(oPC, TRUE);
  int nRace        = GetRacialType(oPC);

  // Check if this character has any awards to use.  If they already have an award, skip.
  if (!GetLocalInt(oHide, "HAS_MAJOR_AWARD") && 
      !GetLocalInt(oHide, "HAS_NORMAL_AWARD") && 
	  !GetLocalInt(oHide, "HAS_MINOR_AWARD"))
  {
	string sID = gsPCGetCDKeyID(GetPCPublicCDKey(oPC));
	SetLocalInt(oPC, "award1", StringToInt(miDAGetKeyedValue("gs_player_data",sID,"award1"))); //major
	SetLocalInt(oPC, "award2", StringToInt(miDAGetKeyedValue("gs_player_data",sID,"award2"))); //medium
	SetLocalInt(oPC, "award3", StringToInt(miDAGetKeyedValue("gs_player_data",sID,"award3"))); //minor
  }
  
  // Options for confirming or cancelling. These are static so we can set them
  // up once.
  if (GetElementCount(CONFIRM) == 0)
  {
    AddStringElement("[Select]", CONFIRM);
    AddStringElement("[Back]", CONFIRM);
  }
      
  if (!GetIsObjectValid(GetItemPossessedBy(oPC, "mi_mark_destiny")))
  {
    CreateItemOnObject("mi_mark_destiny", oPC);
  }
  
  // Initialise ECL and creature hide/ms/dex
  miBAIncreaseECL(oPC, 0.0f);
}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();
  int nRP = gsPCGetRolePlay(oPC);

  Trace(SUBRACE, "Setting up dialog page: " + sPage);
  if (sPage == "" || sPage == MAIN_MENU)
  {
    SetDlgPrompt(INTRO);
	_SetUpMainOptions();
    SetDlgResponseList(MAIN_MENU, OBJECT_SELF);	
  }
  else if (sPage == CONFIRM)
  {
    SetDlgPrompt("Selected option: " + GetLocalString(OBJECT_SELF, CONFIRM_DESC) + "\n\nAre you sure?");
    SetDlgResponseList(CONFIRM, OBJECT_SELF);
  }
  else if (sPage == HEIGHT_OPTS)
  {
    SetDlgPrompt("You may choose the approximate height of your character compared to your race's normal height.");
    SetDlgResponseList(HEIGHT_OPTS, OBJECT_SELF);	
  }
  else if (sPage == SUBRACE_OPTS)
  {
    _SetUpAllowedSubraces();
    SetDlgPrompt("You may pick from the following subraces.  Options are likely to grow with time.");
    SetDlgResponseList(SUBRACE_OPTS, OBJECT_SELF);	
  }
  else if (sPage == GIFT_OPTS)
  {
    int nECL = gsSUGetECL(gsSUGetSubRaceByName(GetSubRace(oPC)), 0);
    string GIFT_INTRO;
    if(nECL <= 0)
        GIFT_INTRO = "You may pick up to 2 major gifts and 1 minor gift";
    else if(nECL < 2)
        GIFT_INTRO = "You may pick up to 1 major gift and 1 minor gift";
    else if(nECL < 3)
        GIFT_INTRO = "You may pick up to 1 minor gift";
    GIFT_INTRO += " for your " +
     "character." +
     "\n\nECL = Effective character level\nBecause gifted PCs are more " +
     "powerful than 'normal' player characters, their levels are computed " +
     "differently. As a consequence they need longer to gain levels.";
    SetDlgPrompt(GIFT_INTRO);
    _SetUpAllowedGifts();
    SetDlgResponseList(GIFT_OPTS, OBJECT_SELF);
  }
  else if (sPage == PATH_OPTS)
  {
    _SetUpAllowedPaths();
    SetDlgPrompt(PATH_INTRO);
    SetDlgResponseList(PATH_OPTS, OBJECT_SELF);
  }
   else if (sPage == BACKGROUND_OPTS)
  {
    _SetUpAllowedBackgrounds();
    SetDlgPrompt(BACKGROUND_INTRO);
    SetDlgResponseList(BACKGROUND_OPTS, OBJECT_SELF);
  }
  else if (sPage == AWARD_OPTS)
  {
    int nType = GetLocalInt(oPC, "award_type");
    DeleteList(AWARD_OPTS);

    SetDlgPrompt("Select benefit.  Minor awards give -1 ECL, normal awards give "
     + "-2 and major awards give -3.");
	 
	string sType = "-1";
	if (GetLocalInt(oPC, "award2")) sType = "-2";
	if (GetLocalInt(oPC, "award1")) sType = "-3"; 

    AddStringElement("No award", AWARD_OPTS);
    AddStringElement("Reduced ECL (" + sType + ")", AWARD_OPTS);
    if (nType != 3)
    {
      //AddStringElement(GIFT_OF_SPELL_SHIELDING_DESC, AWARD_OPTS);
    }
    if (nType == 1)
    {
      //AddStringElement("Red Dragon Disciple PRC token", AWARD_OPTS);
      //AddStringElement("Shifter PRC token", AWARD_OPTS);
    }

    SetDlgResponseList(AWARD_OPTS);
  } 
  else if (sPage == SPELLSWORD_OPTIONS)
  {
    SetDlgPrompt("In order to specialize in melee combat a Spellsword must give up one school in addition to all summoning abilities.");
    DeleteList(SPELLSWORD_OPTIONS);
    AddStringElement("Abjuration",SPELLSWORD_OPTIONS);
    // AddStringElement("Conjuration", SPELLSWORD_OPTIONS);
    AddStringElement("Divination", SPELLSWORD_OPTIONS);
    AddStringElement("Enchantment", SPELLSWORD_OPTIONS);
    AddStringElement("Evocation", SPELLSWORD_OPTIONS);
    AddStringElement("Illusion", SPELLSWORD_OPTIONS);
    AddStringElement("Necromancy", SPELLSWORD_OPTIONS);
    AddStringElement("Transmutation", SPELLSWORD_OPTIONS);
    //AddStringElement("Don't play a Spellsword", SPELLSWORD_OPTIONS);

    SetDlgResponseList(SPELLSWORD_OPTIONS);
  }
  else
  {
    SendMessageToPC(oPC,
                    "You've found a bug. How embarrassing. Please report it.");
    EndDlg();
  }
}

void HandleSelection()
{
  // This method handles what happens when the player selects an option.
  int selection    = GetDlgSelection();
  object oPC       = GetPcDlgSpeaker();
  object oHide     = gsPCGetCreatureHide(oPC, TRUE);
  string sPage     = GetDlgPageString();
  int bStaticLevel = GetLocalInt(GetModule(), "STATIC_LEVEL");

  Trace(SUBRACE, "Player has selected an option: " + IntToString(selection));
  Trace(SUBRACE, "Page: " + sPage);
  if (sPage == "" || sPage == MAIN_MENU)
  {
    string sNextPage = GetStringElement(selection, MAIN_MENU);
	
	if (sNextPage == "Subrace options") SetDlgPageString(SUBRACE_OPTS);
	else if (sNextPage == "Faction options") SetDlgPageString(BACKGROUND_OPTS);
	else if (sNextPage == "PC height options") SetDlgPageString(HEIGHT_OPTS);
	else if (sNextPage == "Award options") SetDlgPageString(AWARD_OPTS);
	else if (sNextPage == "Path options") SetDlgPageString(PATH_OPTS);
	else if (sNextPage == "Gift options") SetDlgPageString(GIFT_OPTS); 
	else EndDlg();	
  }
  else if (sPage == CONFIRM)
  {
	SetDlgPageString(MAIN_MENU);  // At the top so it can be overridden, e.g. by some paths. 
	
    if (selection)
	{
	  if (sPage == GIFT_OPTS)
	  {
		// Unselect the last gift chosen (but not previous ones)		
        string sGift1 = GetLocalString(oPC, VAR_GIFT_1);
        string sGift2 = GetLocalString(oPC, VAR_GIFT_2);
        string sGift3 = GetLocalString(oPC, VAR_GIFT_3);
		
        if (sGift3 != "") DeleteLocalString(oPC, VAR_GIFT_3);
        else if (sGift2 != "") DeleteLocalString(oPC, VAR_GIFT_2);
        else if (sGift1 != "") DeleteLocalString(oPC, VAR_GIFT_1);
	  }
      else
      {	  
	    // Do nothing - just go back. 
	  }	
	}
	else
	{
	  sPage = GetLocalString(OBJECT_SELF, CONFIRM_PAGE);
	  
	  if (sPage == SUBRACE_OPTS)
	  {
	    _ApplySubRace();
	  }
	  else if (sPage == PATH_OPTS)
	  {
	    _ApplyPath();
	  }
	  else if (sPage == BACKGROUND_OPTS)
	  {
        _ApplyBackground();
	  }
	  else if (sPage == HEIGHT_OPTS)
	  {
	    int nHeight = GetLocalInt(OBJECT_SELF, CONFIRM_OPT);
		float fHeight = 1.0f;
		
		switch (nHeight)
		{
		  case 0: // Normal
		    fHeight = 0.97f + ( Random(6) / 100); // 0.97 - 1.02
		    break;
		  case 1: // Short
		    fHeight = 0.91f + ( Random(6) / 100); // 0.91 - 0.96
		    break;
		  case 2: // Tall
		    fHeight = 1.03f + ( Random(6) / 100); // 1.03 - 1.08
		    break;
		  case 3: // Very short
		    fHeight = 0.85f + ( Random(6) / 100); // 0.85 - 0.90
		    break;
		  case 4: // Very tall
		    fHeight = 1.09f + ( Random(6) / 100); // 1.08 - 1.14
		    break;
		}
		
		SetLocalFloat(oPC, "AR_SCALE", fHeight);
		SetLocalFloat(gsPCGetCreatureHide(oPC), "AR_SCALE", fHeight);

	    // Resize ourselves appropriately.
	    gsPCRefreshCreatureScale(oPC);		
	  }
      else if (sPage == GIFT_OPTS)
      {
        // Apply changes.  _ApplyGifts will only apply the newly selected gift.
        _ApplyGifts();        
      }	  
	  else if (sPage == AWARD_OPTS)
	  {	
		int nAwardChoice = GetLocalInt(OBJECT_SELF, CONFIRM_OPT);  // Option zero is "go back" so we should never have zero. 

		int nType = 1;
		
		if (!GetLocalInt(oPC, "award1")) 
		{
		  // No Major awards, so check Normal.
		  nType = 2;
		  
		  if (!GetLocalInt(oPC, "award2")) 
		  {
		    // No Normal awards either, so check Minor. 
		    nType = 3;
			
			if (!GetLocalInt(oPC, "award3")) nType = 0; // Should never hit this, but putting in for safety.
		  }
		}
				
        switch (nAwardChoice)
        {
          case 1:
          {
            // ECL
            switch (nType)
            {
              case 1:
                SendMessageToPC(oPC, "Applying -3 ECL");
                miBAIncreaseECL(oPC, -3.0f);
                break;
              case 2:
                miBAIncreaseECL(oPC, -2.0f);
                SendMessageToPC(oPC, "Applying -2 ECL");
                break;
              case 3:
                miBAIncreaseECL(oPC, -1.0f);
                SendMessageToPC(oPC, "Applying -1 ECL");
                break;
            }
			
            break;
          }
        }

        // Remove used award.
        if (nAwardChoice)
        {
          object oCreatureHide = gsPCGetCreatureHide(oPC, TRUE);
          string sAward;
          switch (nType)
          {
            case 1:
              sAward = "award1";
              SetLocalInt(oCreatureHide, "HAS_MAJOR_AWARD", TRUE);
              break;
            case 2:
              sAward = "award2";
              SetLocalInt(oCreatureHide, "HAS_NORMAL_AWARD", TRUE);
              break;
            case 3:
              sAward = "award3";
              SetLocalInt(oCreatureHide, "HAS_MINOR_AWARD", TRUE);
              break;
          }

		  _removeAward(oPC, sAward);
        }
	  }
	}
  }
  else if (sPage == SUBRACE_OPTS)
  {
    SetLocalString(OBJECT_SELF, CONFIRM_DESC, GetStringElement(selection, SUBRACE_OPTS));
	SetLocalString(OBJECT_SELF, CONFIRM_PAGE, SUBRACE_OPTS);
    SetLocalInt(OBJECT_SELF, CONFIRM_OPT, selection);
    SetDlgPageString(CONFIRM);    
  }
  else if (sPage == HEIGHT_OPTS)
  {
    SetLocalString(OBJECT_SELF, CONFIRM_DESC, GetStringElement(selection, HEIGHT_OPTS));
	SetLocalString(OBJECT_SELF, CONFIRM_PAGE, HEIGHT_OPTS);
    SetLocalInt(OBJECT_SELF, CONFIRM_OPT, selection);
    SetDlgPageString(CONFIRM);    
  }
  else if (sPage == GIFT_OPTS)
  {
    string sGift = GetStringElement(selection, GIFT_OPTS);
    int nGift1 = GetLocalInt(oHide, "GIFT_1");
    int nGift2 = GetLocalInt(oHide, "GIFT_2");
    int nGift3 = GetLocalInt(oHide, "GIFT_3");

    int nRPR = gsPCGetRolePlay(oPC);

    if (!nGift1)
    {
      SetLocalString(oPC, VAR_GIFT_1, sGift);
    }
    else if (!nGift2)
    {
      SetLocalString(oPC, VAR_GIFT_2, sGift);
    }
    else if (!nGift3)
    {
      SetLocalString(oPC, VAR_GIFT_3, sGift);
    }
	else
	{
	  SendMessageToPC(oPC, "Error - you already have three gifts.");
	}

    SetLocalString(OBJECT_SELF, CONFIRM_DESC, GetStringElement(selection, GIFT_OPTS));
	SetLocalString(OBJECT_SELF, CONFIRM_PAGE, GIFT_OPTS);
    SetLocalInt(OBJECT_SELF, CONFIRM_OPT, selection);
    SetDlgPageString(CONFIRM);
  }
  else if (sPage == PATH_OPTS)
  {
    SetLocalString(OBJECT_SELF, CONFIRM_DESC, GetStringElement(selection, PATH_OPTS));
	SetLocalString(OBJECT_SELF, CONFIRM_PAGE, PATH_OPTS);
    SetLocalInt(OBJECT_SELF, CONFIRM_OPT, selection);
    SetDlgPageString(CONFIRM);
  }
  else if (sPage == BACKGROUND_OPTS)
  {
    SetLocalString(OBJECT_SELF, CONFIRM_DESC, GetStringElement(selection, BACKGROUND_OPTS));
	SetLocalString(OBJECT_SELF, CONFIRM_PAGE, BACKGROUND_OPTS);
    SetLocalInt(OBJECT_SELF, CONFIRM_OPT, selection);
    SetDlgPageString(CONFIRM);
  }
  else if (sPage == AWARD_OPTS)
  {	
    SetLocalString(OBJECT_SELF, CONFIRM_DESC, GetStringElement(selection, AWARD_OPTS));
	SetLocalString(OBJECT_SELF, CONFIRM_PAGE, AWARD_OPTS);
    SetLocalInt(OBJECT_SELF, CONFIRM_OPT, selection);
    SetDlgPageString(CONFIRM);
  }
  else if (sPage == TOTEM_SELECT)
  {
    if ( selection < 10)
    {
      miTOGrantTotem(oPC, selection + 1);
    }
    EndDlg();
  }  
  else if (sPage == SPELLSWORD_OPTIONS)
  {
    if ( selection == 0)
    {
      miSSSetBlockedSchool(oPC, selection + 1, 1);
    }
    else if ( selection < 10)
    {
      miSSSetBlockedSchool(oPC, selection + 2, 1);
    }
	
    //block conjuration as second school
    miSSSetBlockedSchool(oPC, SPELL_SCHOOL_CONJURATION , 2);
    miSSSetIsSpellsword(oPC);
    miSSMWPFeat(oPC);
	SetDlgPageString(MAIN_MENU);
  }
}

void main()
{
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
      break;
    case DLG_END:
      ApplyCharacterBonuses(GetPcDlgSpeaker(), FALSE, TRUE, TRUE);
      break;
  }
}
