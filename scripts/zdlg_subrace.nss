/*                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             /*
  Name: zdlg_subrace
  Author: Mithreas, converted to Z-Dialog from Gigaschatten's legacy convo, and
   customised to add background and skin selection menus.
  Date: 8-13 June 2007
  Description: Subrace selection conversation script. Uses Z-Dialog.

  Z-Dialog methods:
    AddStringElement - used to build up replies as a list.
    SetDlgPrompt - sets the NPC text to use
    SetDlgResponseList - sets the responses up
    S/GetDlgPageString - gets the current page
    GetPcDlgSpeaker = GetPCSpeaker
    GetDlgSelection - gets user selection (index of the response list)
*/
#include "__server_config"
#include "inc_state"
#include "inc_subrace"
#include "inc_bonuses"
#include "inc_log"
#include "inc_backgrounds"
#include "inc_class"
#include "inc_favsoul"
#include "inc_totem"
#include "inc_warlock"
#include "inc_spellsword"
#include "zdlg_include_i"
//------------------------------------------------------------------------------
// Set up some constants to use for list and variable names.
//------------------------------------------------------------------------------

const string SUBRACES              = "subrace_options";
const string SELECTIONS            = "subrace_selections";
const string BLOODLINE_OPTIONS     = "bloodline_options";
const string SKIN_OPTIONS          = "skin_options";
const string AVAILABLE_GIFTS       = "gift_options";
const string AVAILABLE_PATHS       = "path_options";
const string AVAILABLE_BACKGROUNDS = "background_options";
const string BACKGROUND_SELECTIONS = "background_selections";
const string MARK_OPTIONS          = "mark_yes_or_no";
const string ALIGNMENT_OPTIONS     = "alignment_options";
const string PACT_OPTIONS          = "pact options";
const string TOTEM_OPTIONS         = "totem options";
const string SPELLSWORD_OPTIONS    = "spellsword options";
const string STARTLOC_OPTIONS      = "startloc options";

const string CONFIRM    = "confirmation";
const string SELECTION  = "selection";

const string CONFIRM_PAGE       = "CONFIRM_PAGE";
const string BACKGROUND_SELECT  = "SELECT_BACKGROUND_PAGE";
const string BACKGROUND_CONFIRM = "CONFIRM_BACKGROUND_PAGE";
const string PATH_SELECT        = "SELECT_PATH";
const string PATH_CONFIRM       = "CONFIRM_PATH";
const string GIFT_SELECT        = "SELECT_GIFT"; //major
const string GIFT_CONFIRM       = "CONFIRM_GIFT"; //major (or both!)
const string SKIN_SELECT        = "SELECT_SKIN";
const string MARK_OF_DESTINY    = "MARK_OF_DESTINY";
const string ALIGNMENT_PAGE     = "ALIGNMENT_PAGE";
const string PACT_SELECT        = "SELECT_PACT";
const string TOTEM_SELECT       = "SELECT_TOTEM";
const string SPELLSWORD_SELECT  = "SELECT_SPELLSWORD";
const string BLOODLINE_SELECT   = "SELECT_BLOODLINE";
const string AWARD_TYPE         = "SELECT_AWARD_TYPE";
const string AWARD_SELECT       = "SELECT_AWARD";
const string STARTLOC_SELECT    = "SELECT_STARTLOC";

const string VAR_GIFT_1 = "VAR_GIFT_1";
const string VAR_GIFT_2 = "VAR_GIFT_2";
const string VAR_GIFT_3 = "VAR_GIFT_3";
const string VAR_GIFT_4 = "VAR_GIFT_4";
const string VAR_PATH   = "VAR_PATH";

const string NUM_DLG_OPTIONS   = "NUM_DLG_OPTIONS";
const int MI_SKIN_NONE       = 0;
const int MI_SKIN_GOBLIN     = 1;
const int MI_SKIN_KOBOLD     = 2;
const int MI_SKIN_GNOLL      = 3;
const int MI_SKIN_OGRE       = 4;
const int MI_SKIN_HOBGOBLIN  = 5;
const int MI_SKIN_IMP        = 6;

string INTRO = "Welcome to Arelith, a role-play server set in 3rd Edition Forgotten Realms.  Adventure awaits in a dangerous archipelago hidden in the mists of the Trackless Sea.  Before entering the gameworld, you can" +
 " choose subraces, paths and gifts to further customize your character.  The following subraces are available for your character's chosen race and alignment.";

string PATH_INTRO = "You may choose to follow a path.  A path modifies a class "+
  "giving you some unique benefits, but also some significant restrictions." +
  "\n\nAvailable paths:"+
  "\nWarlock: Lose bard song, gain an eldritch blast and various other powers."+
  "\nTotem druid: -4 to all physical stats, but gain a more powerful shifted form."+
  // "\nKensai: One extra attack, +2 natural AC. May not take levels in wizard, sorcerer, druid or cleric, may not cast spellbook spells, may not use "+
  // "bound spells, and are restricted to melee and throwing weapons."+
  "\nTrue Fire: May cast unlimited spells per day but may only cast Evocation spells."+
  "\nArcher: Lose dual wield feats but create a quiver of arrows 1/day." +
  "\nSniper: Lose dual wield feats but gain point blank shot and rapid shot at level 1" +
  " and called shot at level 9." +
  "\nHealer: Become a more potent healer, but cannot gain proficiency in armors or weapons other than Simple weapons. " +
  "\nFavoured Soul: Spontaneous casting of cleric spells, but lose Domains, Heavy Armour and Turn Undead. " +
  "\nTribesman: Rage loses its normal effects, but summons an NPC of your tribe to fight " +
  "with you.  You can have two tribesman at any point." +
  "\nShadow Mage: (Experimental!) May not cast Evocation spells.  May take Shadowdancer without usual prerequisites.  Shadow Dancer gives " +
  "caster levels instead of Sneak Attack." +
  "\nWild Mage: A new Wizard School. Allows a chance for Wild Surges " +
  "to occur when casting Arcane Spells. Use with Extreme Caution!" +
  "\nSpellsword: (Experimental!) A new Wizard School. Improves the melee abilities of a wizard " +
  "in exchange for two prohibited spell schools (Conjuration + 1 choice)." +
  "Use with Extreme Caution!";

string BACKGROUND_INTRO = "You may now choose a special background for your character. " +
  "Backgrounds have a significant effect on the starting location and career options on your character, and are recommended " +
  "for experienced players only!" +
  "\nSlave:  This character begins as a lowly slave.  You will start in the Underdark and your freedom will be limited." +
  "\nOutcast:  This character has committed a grave offense in the past.  Shunned in most civilized places, they have no choice but to live in the Underdark.";

string SKIN_INTRO = "Please select a skin for your character.\n(Gnolls, Hobgoblins & Imps only have two skins.).";

string BLOODLINE_INTRO = "Please select a Bloodline for your character.\nCurrent Bloodline: %bloodline";

string MARK_INTRO = "You may elect for your character to have a <c þ >Mark of Destiny</c>."+
" This means that they advance faster (they get bonus XP) but after they reach the " +
"Death area ten times, <cþ  >they are perma-killed</c>.  Once you choose to have a Mark you " +
"may <cþ  >never</c> undo the decision, for <cþ  >any</c> reason whatsoever.  Similarly, characters " +
"who perma-die will not be restored, for any reason whatsoever (even if the death " +
"was caused by lag, griefers or whatever - that's why you have 10 lives not 1). " +
"\n\nSelect Mark of Destiny?";

// string STARTLOC_INTRO = "Dwarves (Excluding Duergar), Halflings, and Gnomes (Including Svirfneblins) have the option to be a part of the Earthkin Alliance. "+
// "\nCharacters who select this option will start in halls of Brogendenstein, a mountain stronghold where other Earthkin frequently gather.\n" +
// "You will start at 3rd level instead of 2nd, as there will be no tutorial delivery quest.  Despite this, there are nearby areas to explore that cater to low-level characters. Do you want to be a part of this alliance?";


//::  Not defined in NWN Base
const int APPEARANCE_TYPE_OGRE_ELITE = 75;


//------------------------------------------------------------------------------
// Private utility methods.
//------------------------------------------------------------------------------

int _isUnderdarkSubrace(object oPC)
{
    int bIsUnderdarker = gsSUGetIsUnderdarker(gsSUGetSubRaceByName(GetSubRace(oPC)));
    int bIsSvirf       = GetRacialType(oPC) == RACIAL_TYPE_GNOME;
    
    return bIsUnderdarker && !bIsSvirf;  
}

int _isEarthkin(object oPC)
{
    int nRace = GetRacialType(oPC);

    if  (nRace == RACIAL_TYPE_DWARF ||
         nRace == RACIAL_TYPE_GNOME ||
         nRace == RACIAL_TYPE_HALFLING)
    {
      return TRUE;
    }
    return FALSE;
}

void _AddSubraceAsOption(int nSubRace)
{
  Trace(SUBRACE, "Adding option for subrace: " + gsSUGetNameBySubRace(nSubRace));
  // As we add elements to the list, create a separate list containing the
  // available selections with a link to their subrace constants. This will
  // make it much easier to tally responses.
  int nECL     = gsSUGetECL(nSubRace, 0);
  string sText = gsSUGetNameBySubRace(nSubRace);
  if (sText == "") sText = "<c þ >[No subrace]</c>";

  //if (nECL) sText += " <cþ  >[ECL +"+IntToString(nECL)+"]</c>";
  AddStringElement(sText, SUBRACES);
  AddIntElement(nSubRace, SELECTIONS);
}

void _ClearSubRaceOptions()
{
  Trace(SUBRACE, "Clearing subraces for new conversation.");
  DeleteList(SUBRACES);
  DeleteList(SELECTIONS);
}

int _SubraceHaveBloodline(object oPC) {
    int nSubrace = gsSUGetSubRaceByName(GetSubRace(oPC));
    return nSubrace == GS_SU_PLANETOUCHED_AASIMAR ||
           nSubrace == GS_SU_PLANETOUCHED_TIEFLING;
}

void _AddBackgroundAsOption(int nBackground)
{
  Trace(BACKGROUNDS, "Adding option for background: " + miBAGetBackgroundName(nBackground));
  AddStringElement(miBAGetBackgroundName(nBackground), AVAILABLE_BACKGROUNDS);
  AddIntElement(nBackground, BACKGROUND_SELECTIONS);
}

void _ClearBackgroundOptions()
{
  Trace(BACKGROUNDS, "Clearing backgrounds for new conversation.");
  DeleteList(AVAILABLE_BACKGROUNDS);
  DeleteList(BACKGROUND_SELECTIONS);
}

void _gvdCreateBaseInventoryForRace(object oPC) {

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
void __InitECL(object oPC)
{
  // For migration purposes, we need to be able to distinguish characters
  // who used the old system (where subraces granted abilities) and
  // new characters who have an explicit ECL.  Older characters will have
  // a value of 0 (not present) for the ECL var, so newer ones get a value
  // 10 higher than needed, to avoid also getting a zero.
  float fCurrentECL = GetLocalFloat(gsPCGetCreatureHide(oPC), "ECL");

  if (fCurrentECL == 0.0f)
  {
    SetLocalFloat(gsPCGetCreatureHide(oPC), "ECL", 10.0f);
  }
}

int _ApplySubRace()
{
  object oSpeaker  = GetPcDlgSpeaker();
  object oProperty = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oSpeaker);
  object oAbility  = GetItemPossessedBy(oSpeaker, "GS_SU_ABILITY");
  int nSubRace     = GetIntElement(GetLocalInt(OBJECT_SELF, SELECTION), SELECTIONS);
  int nLevel       = GetHitDice(oSpeaker);
  int nFlag        = FALSE;
  Trace(SUBRACE, "Applying subrace: " + gsSUGetNameBySubRace(nSubRace));

  if (nSubRace == GS_SU_NONE)
  {
    if (GetIsObjectValid(oProperty))
    {
        gsIPRemoveAllProperties(oProperty);
    }
    else
    {
        oProperty = CreateItemOnObject(GS_SU_TEMPLATE_PROPERTY, oSpeaker);

        if (GetIsObjectValid(oProperty))
        {
            AssignCommand(oSpeaker, ActionEquipItem(oProperty, INVENTORY_SLOT_CARMOUR));
        }
    }

    if (GetIsObjectValid(oAbility)) DestroyObject(oAbility);

    // Have to set a subrace so that the background code can modify it.
    SetSubRace(oSpeaker, gsSUGetRaceName(GetRacialType(oSpeaker)));
  }
  else
  {
    if (! GetIsObjectValid(oProperty))
    {
      oProperty = CreateItemOnObject(GS_SU_TEMPLATE_PROPERTY, oSpeaker);
      nFlag     = TRUE;
    }

    if (! GetIsObjectValid(oAbility))
    {
      oAbility  = CreateItemOnObject(GS_SU_TEMPLATE_ABILITY,  oSpeaker);
    }

    if (GetIsObjectValid(oProperty))
    {
      __InitECL(oSpeaker);
      gsSUApplyProperty(oProperty, nSubRace, nLevel);
      miBAIncreaseECL(oSpeaker, IntToFloat(gsSUGetECL(nSubRace, 0)));
      SetLocalInt(oProperty, "GIFT_SUBRACE", TRUE);
      if (nFlag) AssignCommand(oSpeaker, ActionEquipItem(oProperty, INVENTORY_SLOT_CARMOUR));
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
      case GS_SU_HALFORC_GNOLL:
        SetCreatureAppearanceType(oSpeaker, APPEARANCE_TYPE_GNOLL_WARRIOR);
        //SetRacialType(oSpeaker, RACIAL_TYPE_HUMANOID_GOBLINOID);
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
      case GS_SU_SPECIAL_IMP:
        SetCreatureAppearanceType(oSpeaker, APPEARANCE_TYPE_IMP);
        //SetRacialType(oSpeaker, RACIAL_TYPE_OUTSIDER);
        AdjustAlignment(oSpeaker, ALIGNMENT_LAWFUL, 100, FALSE);
        SetCreatureSize(oSpeaker, CREATURE_SIZE_SMALL);
        break;
      case GS_SU_SPECIAL_HOBGOBLIN:
        SetCreatureAppearanceType(oSpeaker, APPEARANCE_TYPE_HOBGOBLIN_WARRIOR);
        //SetRacialType(oSpeaker, RACIAL_TYPE_HUMANOID_GOBLINOID);
        break;
      case GS_SU_DWARF_WILD:
        SetCreatureSize(oSpeaker, CREATURE_SIZE_SMALL); //here as all wild dwarves should be small even if we decide no subrace stats again
        break;

    }

    // dunshine: handle racial starting equipment here
    _gvdCreateBaseInventoryForRace(oSpeaker);

  }

  md_AddRacialBonuses(oSpeaker, nSubRace, oProperty);

  //:: Remove major awards.
  if (nSubRace == GS_SU_SPECIAL_DRAGON || nSubRace == GS_SU_SPECIAL_RAKSHASA ||
      nSubRace == GS_SU_PLANETOUCHED_TIEFLING || nSubRace == GS_SU_PLANETOUCHED_AASIMAR) {
    string sID = gsPCGetCDKeyID(GetPCPublicCDKey(oSpeaker));
    int nAwards = GetLocalInt(oSpeaker, "award1") -1;
    miDASetKeyedValue("gs_player_data", sID, "award1", IntToString(nAwards));
    // SetLocalInt(oSpeaker, "award1", nAwards);
    // Septire - An award has been spent on this character. Treat this character as having no additional awards to spend. (Checked at conditional in sPage == GIFT_CONFIRM)
    // We assume that only ONE award can be spent on each character. Do NOT update the database.
    SetLocalInt(oProperty, "HAS_MAJOR_AWARD", TRUE);
    SetLocalInt(oSpeaker, "award1", 0);
    SetLocalInt(oSpeaker, "award2", 0);
    SetLocalInt(oSpeaker, "award3", 0);
    SetLocalInt(oSpeaker, "award1_5", 0);

  }
  //::  Remove Greater Awards
  if(nSubRace == GS_SU_SPECIAL_OGRE || nSubRace == GS_SU_DEEP_IMASKARI) {
    string sID = gsPCGetCDKeyID(GetPCPublicCDKey(oSpeaker));
    int nAwards = GetLocalInt(oSpeaker, "award1_5") -1;
    if(nAwards >= 0)
        miDASetKeyedValue("gs_player_data", sID, "award1_5", IntToString(nAwards));
    else
    {
        nAwards = GetLocalInt(oSpeaker, "award1") -1;
        miDASetKeyedValue("gs_player_data", sID, "award1", IntToString(nAwards));
    }
    //SetLocalInt(oSpeaker, "award1_5", nAwards);
    // Septire - An award has been spent on this character. Treat this character as having no additional awards to spend. (Checked at conditional in sPage == GIFT_CONFIRM)
    // We assume that only ONE award can be spent on each character. Do NOT update the database.
    SetLocalInt(oProperty, "HAS_GREATER_AWARD", TRUE);
    SetLocalInt(oSpeaker, "award1", 0);
    SetLocalInt(oSpeaker, "award2", 0);
    SetLocalInt(oSpeaker, "award3", 0);
    SetLocalInt(oSpeaker, "award1_5", 0);
  }
  // Remove normal awards.
  if (nSubRace == GS_SU_SPECIAL_IMP) {
    string sID = gsPCGetCDKeyID(GetPCPublicCDKey(oSpeaker));
    int nAwards = GetLocalInt(oSpeaker, "award2") -1;

    if(nAwards >= 0)
        miDASetKeyedValue("gs_player_data", sID, "award2", IntToString(nAwards));
    else
    {
        nAwards = GetLocalInt(oSpeaker, "award1_5") -1;
        if(nAwards >= 0)
            miDASetKeyedValue("gs_player_data", sID, "award1_5", IntToString(nAwards));
        else
        {
            nAwards = GetLocalInt(oSpeaker, "award1") -1;
            miDASetKeyedValue("gs_player_data", sID, "award1", IntToString(nAwards));
        }
    }
   // SetLocalInt(oSpeaker, "award2", nAwards);
    // Septire - An award has been spent on this character. Treat this character as having no additional awards to spend. (Checked at conditional in sPage == GIFT_CONFIRM)
    // We assume that only ONE award can be spent on each character. Do NOT update the database.
    SetLocalInt(oProperty, "HAS_NORMAL_AWARD", TRUE);
    SetLocalInt(oSpeaker, "award1", 0);
    SetLocalInt(oSpeaker, "award2", 0);
    SetLocalInt(oSpeaker, "award3", 0);
    SetLocalInt(oSpeaker, "award1_5", 0);
  }

  if (nSubRace == GS_SU_GNOME_FOREST ||  nSubRace == GS_SU_SPECIAL_HOBGOBLIN || nSubRace == GS_SU_DWARF_WILD)
  {
    string sID = gsPCGetCDKeyID(GetPCPublicCDKey(oSpeaker));
    int nAwards = GetLocalInt(oSpeaker, "award3") -1;

    if(nAwards >= 0)
        miDASetKeyedValue("gs_player_data", sID, "award3", IntToString(nAwards));
    else
    {
        nAwards = GetLocalInt(oSpeaker, "award2") -1;
        if(nAwards >= 0)
            miDASetKeyedValue("gs_player_data", sID, "award2", IntToString(nAwards));
        else
        {
            nAwards = GetLocalInt(oSpeaker, "award1_5") -1;
            if(nAwards >= 0)
                miDASetKeyedValue("gs_player_data", sID, "award1_5", IntToString(nAwards));
            else
            {
                nAwards = GetLocalInt(oSpeaker, "award1") -1;
                miDASetKeyedValue("gs_player_data", sID, "award1", IntToString(nAwards));
            }
        }


    }
    SetLocalInt(oProperty, "HAS_MINOR_AWARD", TRUE);
    SetLocalInt(oSpeaker, "award1", 0);
    SetLocalInt(oSpeaker, "award2", 0);
    SetLocalInt(oSpeaker, "award3", 0);
    SetLocalInt(oSpeaker, "award1_5", 0);
  }

  if (nSubRace == GS_SU_SPECIAL_GOBLIN) return MI_SKIN_GOBLIN;
  if (nSubRace == GS_SU_SPECIAL_KOBOLD) return MI_SKIN_KOBOLD;
  if (nSubRace == GS_SU_HALFORC_GNOLL) return MI_SKIN_GNOLL;
  if (nSubRace == GS_SU_SPECIAL_OGRE) return MI_SKIN_OGRE;
  if (nSubRace == GS_SU_SPECIAL_HOBGOBLIN) return MI_SKIN_HOBGOBLIN;
  if (nSubRace == GS_SU_SPECIAL_IMP) return MI_SKIN_IMP;

  return MI_SKIN_NONE;
}

void _ApplyBackground()
{
  object oSpeaker  = GetPcDlgSpeaker();
  int nBackground  = GetIntElement(GetLocalInt(OBJECT_SELF, SELECTION), BACKGROUND_SELECTIONS);
  SendMessageToPC(oSpeaker, "Applying selected background: " + miBAGetBackgroundName(nBackground));
  miBAApplyBackground(oSpeaker, nBackground);

  if (nBackground != MI_BA_NONE)
  {
    SetSubRace(oSpeaker,
        GetSubRace(oSpeaker) + " (" + miBAGetBackgroundName(nBackground) + ")");
  }
}

void _ApplyStartLocation(int nChoice)
{
    object oSpeaker = GetPcDlgSpeaker();
    object oHide    = gsPCGetCreatureHide(oSpeaker);
    int nLevel      = GetHitDice(oSpeaker);
    SetLocalInt(oHide, "MI_RACIAL_STARTLOC", nChoice);
	
	// Brogendenstein Start
	if (nChoice == 3 && nLevel < 3) SetXP(oSpeaker, 3000);
}

void _ApplySkin(int nSelection)
{
  object oPC = GetPcDlgSpeaker();
  int nSubRace = gsSUGetSubRaceByName(GetSubRace(oPC));

  if (nSubRace == GS_SU_SPECIAL_GOBLIN)
  {
    switch (nSelection)
    {
      case 0:
        SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_GOBLIN_A);
        break;
      case 1:
        SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_GOBLIN_B);
        break;
      case 2:
        SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_GOBLIN_SHAMAN_A);
        break;
      case 3:
        SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_GOBLIN_SHAMAN_B);
        break;
      case 4:
        SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_GOBLIN_CHIEF_A);
        break;
      case 5:
        SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_GOBLIN_CHIEF_B);
        break;
    }
  }
  else if (nSubRace == GS_SU_SPECIAL_KOBOLD)
  {
    switch (nSelection)
    {
      case 0:
        SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_KOBOLD_A);
        break;
      case 1:
        SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_KOBOLD_B);
        break;
      case 2:
        SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_KOBOLD_SHAMAN_A);
        break;
      case 3:
        SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_KOBOLD_SHAMAN_B);
        break;
      case 4:
        SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_KOBOLD_CHIEF_A);
        break;
      case 5:
        SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_KOBOLD_CHIEF_B);
        break;
    }
  }
  else if (nSubRace == GS_SU_HALFORC_GNOLL)
  {
    switch (nSelection)
    {
      case 0:
        SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_GNOLL_WARRIOR);
        break;
      case 1:
        SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_GNOLL_WIZ);
        break;
    }
  }
  else if (nSubRace == GS_SU_SPECIAL_OGRE)
  {
    switch (nSelection)
    {
      case 0:
        SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_OGRE);
        break;
      case 1:
        SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_OGREB);
        break;
      case 2:
        SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_OGRE_MAGE);
        break;
      case 3:
        SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_OGRE_MAGEB);
        break;
      case 4:
        SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_OGRE_CHIEFTAIN);
        break;
      case 5:
        SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_OGRE_CHIEFTAINB);
        break;
      case 6:
        SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_OGRE_ELITE);
        break;
    }
  }
  else if (nSubRace == GS_SU_SPECIAL_HOBGOBLIN)
  {
    switch (nSelection)
    {
      case 0:
        SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_HOBGOBLIN_WARRIOR);
        break;
      case 1:
        SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_HOBGOBLIN_WIZARD);
        break;
    }
  }
  else if (nSubRace == GS_SU_SPECIAL_IMP)
  {
    switch (nSelection)
    {
      case 0:
        SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_IMP);
        break;
      case 1:
        SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_MEPHIT_MAGMA);
        break;
    }
  }
}

void _ApplyBloodline(int nSelection) {
    object oPC      = GetPcDlgSpeaker();
    int nSubRace    = gsSUGetSubRaceByName(GetSubRace(oPC));
    object oHide    = gsPCGetCreatureHide(oPC);

    if (nSubRace == GS_SU_PLANETOUCHED_AASIMAR) {
        switch (nSelection)
        {
          case 0:
            SetLocalInt(oHide, BLOODLINE, BLOODLINE_AASIMAR_DUTY);
            break;
          case 1:
            SetLocalInt(oHide, BLOODLINE, BLOODLINE_AASIMAR_GRACE);
            break;
          case 2:
            SetLocalInt(oHide, BLOODLINE, BLOODLINE_AASIMAR_PERCEPTION);
            break;
          case 3:
            SetLocalInt(oHide, BLOODLINE, BLOODLINE_AASIMAR_SPLENDOUR);
            break;
          case 4:
            SetLocalInt(oHide, BLOODLINE, BLOODLINE_AASIMAR_ACUMEN);
            break;
        }
    }
    else if (nSubRace == GS_SU_PLANETOUCHED_TIEFLING) {
        switch (nSelection)
        {
          case 0:
            SetLocalInt(oHide, BLOODLINE, BLOODLINE_TIEFLING_BRUTALITY);
            break;
          case 1:
            SetLocalInt(oHide, BLOODLINE, BLOODLINE_TIEFLING_LETHALITY);
            break;
          case 2:
            SetLocalInt(oHide, BLOODLINE, BLOODLINE_TIEFLING_INSIDIOUS);
            break;
          case 3:
            SetLocalInt(oHide, BLOODLINE, BLOODLINE_TIEFLING_ALLURE);
            break;
          case 4:
            SetLocalInt(oHide, BLOODLINE, BLOODLINE_TIEFLING_VISION);
            break;
        }
    }
}

void _ApplyGifts()
{
    object oPC = GetPcDlgSpeaker();
    int nGift1 = GetGiftFromDescription(GetLocalString(oPC, VAR_GIFT_1));
    int nGift2 = GetGiftFromDescription(GetLocalString(oPC, VAR_GIFT_2));
    int nGift3 = GetGiftFromDescription(GetLocalString(oPC, VAR_GIFT_3));
    int nGift4 = GetGiftFromDescription(GetLocalString(oPC, VAR_GIFT_4)); // Reserved for Awards.
    __InitECL(oPC);

    miBAApplyGift(oPC, nGift1);
    miBAApplyGift(oPC, nGift2);
    miBAApplyGift(oPC, nGift3);
    miBAApplyGift(oPC, nGift4);

    // Record the gifts chosen.
    object oAbility  = GetItemPossessedBy(oPC, "GS_SU_ABILITY");
    SetDescription(oAbility, GetDescription(oAbility) + "\nGift 1: " + GetGiftDescription(nGift1));
    if(nGift1) AddListElement(oAbility, "Gifts", IntToString(nGift1));
    SetDescription(oAbility, GetDescription(oAbility) + "\nGift 2: " + GetGiftDescription(nGift2));
    if(nGift2) AddListElement(oAbility, "Gifts", IntToString(nGift2));
    SetDescription(oAbility, GetDescription(oAbility) + "\nGift 3: " + GetGiftDescription(nGift3));
    if(nGift3) AddListElement(oAbility, "Gifts", IntToString(nGift3));
    SetDescription(oAbility, GetDescription(oAbility) + "\nGift 4: " + GetGiftDescription(nGift4));
    if(nGift4) AddListElement(oAbility, "Gifts", IntToString(nGift4));
}
int _GetSREcl(int nSubrace)
{
      if(nSubrace == GS_SU_HALFORC_OROG || nSubrace == GS_SU_FR_OROG)
        return 2;
      return gsSUGetECL(nSubrace, 0);
}
void _BypassGiftOption(object oPC)
{
    if(_GetSREcl(gsSUGetSubRaceByName(GetSubRace(oPC))) >= 3)
    {
        if (GetLocalInt(oPC, "award3") || GetLocalInt(oPC, "award2") ||
                GetLocalInt(oPC, "award1") || GetLocalInt(oPC, "award1_5"))
        {
           SetDlgPageString(AWARD_TYPE);
        }
        else
        {
           SetDlgPageString(BACKGROUND_SELECT);
        }
    }
    else
     SetDlgPageString(GIFT_SELECT);

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
  // for (ii = 1; ii < MI_BA_NUM_BACKGROUNDS; ii++)
  // {
  //  if (miBAGetIsBackgroundLegal(ii, oPC))
  //  {
  //    _AddBackgroundAsOption(ii);
  //  }
  // }

  // Removing all backgrounds except for slave and outcast.

  if (miBAGetIsBackgroundLegal(MI_BA_SLAVE, oPC))   _AddBackgroundAsOption(MI_BA_SLAVE);
  if (miBAGetIsBackgroundLegal(MI_BA_OUTCAST, oPC)) _AddBackgroundAsOption(MI_BA_OUTCAST);
  _AddBackgroundAsOption(MI_BA_NONE);
}

// Call each time the menu loads to rule out gifts already chosen
//Also check for major and minor gifts!
void _AddGiftIfNotTaken(object oPC, string sGift)
{
  string sGift1 = GetLocalString(oPC, VAR_GIFT_1);
  string sGift2 = GetLocalString(oPC, VAR_GIFT_2);
  string sGift3 = GetLocalString(oPC, VAR_GIFT_3);
  int nMajor1 = FindSubString(sGift1, "MAJOR");
  int nMajor2 = FindSubString(sGift2, "MAJOR");
  int nMajor3 = FindSubString(sGift3, "MAJOR");
  int nNewGift = FindSubString(sGift, "MAJOR");
  int nECL = _GetSREcl(gsSUGetSubRaceByName(GetSubRace(oPC)));
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
    AddStringElement(sGift, AVAILABLE_GIFTS);
  }
}

void _SetUpAllowedGifts()
{
  DeleteList(AVAILABLE_GIFTS);

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

  if(gsSUGetSubRaceByName(GetSubRace(oPC)) == GS_SU_ELF_DROW)
  {

        _AddGiftIfNotTaken(oPC, GIFT_OF_DR_CLERGY_DESC);

        _AddGiftIfNotTaken(oPC, GIFT_OF_DR_MM_DESC);
  }
  if(gsSUGetSubRaceByName(GetSubRace(oPC)) == GS_SU_SPECIAL_OGRE)
  {
        _AddGiftIfNotTaken(oPC, GIFT_OF_OG_MAGI_DESC);
  }

 /* if (gsSUGetSubRaceByName(GetSubRace(oPC)) != GS_SU_NONE)
  {
    _AddGiftIfNotTaken(oPC, GIFT_OF_SUBRACE_DESC);
  } */

  AddStringElement(GIFT_NONE_DESC, AVAILABLE_GIFTS);
}

void _SetUpAllowedSkins() {
    DeleteList(SKIN_OPTIONS);

    object oPC      = GetPcDlgSpeaker();
    int nSubRace    = gsSUGetSubRaceByName(GetSubRace(oPC));

    SetLocalInt(OBJECT_SELF, NUM_DLG_OPTIONS, 6);

    //::  2 Skin Option races
    if ( nSubRace == GS_SU_HALFORC_GNOLL || nSubRace == GS_SU_SPECIAL_HOBGOBLIN || nSubRace == GS_SU_SPECIAL_IMP ) {
        SetLocalInt(OBJECT_SELF, NUM_DLG_OPTIONS, 2);
        AddStringElement("Model A <c þ >[Default]</c>", SKIN_OPTIONS);
        AddStringElement("Model B", SKIN_OPTIONS);
        AddStringElement("<c þ >[Continue]</c>", SKIN_OPTIONS);
        return;
    }
    //::  7 Skin Option Races
    else if ( nSubRace == GS_SU_SPECIAL_OGRE ) {
        SetLocalInt(OBJECT_SELF, NUM_DLG_OPTIONS, 7);
        AddStringElement("Ogre A <c þ >[Default]</c>", SKIN_OPTIONS);
        AddStringElement("Ogre B", SKIN_OPTIONS);
        AddStringElement("Ogre Magi A", SKIN_OPTIONS);
        AddStringElement("Ogre Magi B", SKIN_OPTIONS);
        AddStringElement("Ogre Armoured A", SKIN_OPTIONS);
        AddStringElement("Ogre Armoured B", SKIN_OPTIONS);
        AddStringElement("Ogre Elite", SKIN_OPTIONS);
        AddStringElement("<c þ >[Continue]</c>", SKIN_OPTIONS);
        return;
    }

    AddStringElement("Peasant A <c þ >[Default]</c>", SKIN_OPTIONS);
    AddStringElement("Peasant B", SKIN_OPTIONS);
    AddStringElement("Shaman A", SKIN_OPTIONS);
    AddStringElement("Shaman B", SKIN_OPTIONS);
    AddStringElement("Warrior A", SKIN_OPTIONS);
    AddStringElement("Warrior B", SKIN_OPTIONS);
    AddStringElement("<c þ >[Continue]</c>", SKIN_OPTIONS);
}

void _SetUpBloodlines() {
    DeleteList(BLOODLINE_OPTIONS);

    object oPC      = GetPcDlgSpeaker();
    int nSubRace    = gsSUGetSubRaceByName(GetSubRace(oPC));

    SetLocalInt(OBJECT_SELF, NUM_DLG_OPTIONS, 5);

    //::  Aasimar Bloodlines
    if ( nSubRace == GS_SU_PLANETOUCHED_AASIMAR ) {
        AddStringElement("Bloodline of Duty (+2 STR, +2 CON, -2 CHA, -2 WIS)", BLOODLINE_OPTIONS);
        AddStringElement("Bloodline of Grace (+2 DEX, +2 CON, -2 CHA)", BLOODLINE_OPTIONS);
        AddStringElement("Bloodline of Perception (+2 WIS, +2 CHA, -2 DEX)", BLOODLINE_OPTIONS);
        AddStringElement("Bloodline of Splendour (+2 CHA, +2 CON, -2 DEX)", BLOODLINE_OPTIONS);
        AddStringElement("Bloodline of Acumen (+2 INT, +2 CON, -2 DEX)", BLOODLINE_OPTIONS);
    }
    //::  Tiefling Bloodlines
    else if ( nSubRace == GS_SU_PLANETOUCHED_TIEFLING) {
        AddStringElement("Bloodline of Brutality (+2 STR, +2 CON, -2 WIS, -2 CHA)", BLOODLINE_OPTIONS);
        AddStringElement("Bloodline of Lethality (+2 DEX, +2 CON, -2 CHA)", BLOODLINE_OPTIONS);
        AddStringElement("Bloodline of Insidious (+2 INT, +2 CON, -2 CHA)", BLOODLINE_OPTIONS);
        AddStringElement("Bloodline of Allure (+2 CHA, +2 CON, -2 WIS)", BLOODLINE_OPTIONS);
        AddStringElement("Bloodline of Vision (+2 WIS, +2 CON, -2 DEX)", BLOODLINE_OPTIONS);
    }

    AddStringElement("<c þ >[Confirm]</c>", BLOODLINE_OPTIONS);
}

void _SetUpAllowedPaths()
{
  DeleteList(AVAILABLE_PATHS);

  object oPC = GetPcDlgSpeaker();

  if (GetLevelByClass(CLASS_TYPE_BARD, oPC) && GetAlignmentGoodEvil(oPC) != ALIGNMENT_GOOD)
  {
    AddStringElement(PATH_OF_WARLOCK, AVAILABLE_PATHS);
  }

  if (GetLevelByClass(CLASS_TYPE_CLERIC, oPC))
  {
    AddStringElement(PATH_OF_THE_HEALER, AVAILABLE_PATHS);
    AddStringElement(PATH_OF_FAVOURED_SOUL, AVAILABLE_PATHS);
  }

  if (GetLevelByClass(CLASS_TYPE_DRUID, oPC))
  {
    AddStringElement(PATH_OF_TOTEM, AVAILABLE_PATHS);
  }

  if (GetLevelByClass(CLASS_TYPE_SORCERER, oPC))
  {
    AddStringElement(PATH_OF_TRUE_FIRE, AVAILABLE_PATHS);
    AddStringElement(PATH_OF_SHADOW, AVAILABLE_PATHS);
  }

  if (GetLevelByClass(CLASS_TYPE_RANGER, oPC))
  {
    AddStringElement(PATH_OF_THE_ARCHER, AVAILABLE_PATHS);
    AddStringElement(PATH_OF_THE_SNIPER, AVAILABLE_PATHS);
  }

  if (GetLevelByClass(CLASS_TYPE_BARBARIAN, oPC))
  {
    AddStringElement(PATH_OF_THE_TRIBESMAN, AVAILABLE_PATHS);
  }

  // if (!GetLevelByClass(CLASS_TYPE_SORCERER, oPC) &&
  //    !GetLevelByClass(CLASS_TYPE_DRUID, oPC) &&
  //    !GetLevelByClass(CLASS_TYPE_CLERIC, oPC) &&
  //    !GetLevelByClass(CLASS_TYPE_WIZARD, oPC))
  //{
    // AddStringElement(PATH_OF_THE_KENSAI, AVAILABLE_PATHS);
  // }

  //::  Wild Mage and Spellsword only for Non-Specialized (General) Wizards.
  if ( GetLevelByClass(CLASS_TYPE_WIZARD, oPC) && NWNX_Creature_GetWizardSpecialization(oPC) == SPELL_SCHOOL_GENERAL )
  {
    AddStringElement(PATH_OF_WILD_MAGE, AVAILABLE_PATHS);
    //AddStringElement(PATH_OF_SPELLSWORD, AVAILABLE_PATHS);
  }

  if (GetLevelByClass(CLASS_TYPE_WIZARD, oPC)  && NWNX_Creature_GetWizardSpecialization(oPC) != SPELL_SCHOOL_EVOCATION)
  {
    AddStringElement(PATH_OF_SHADOW, AVAILABLE_PATHS);
  }

  AddStringElement(PATH_NONE, AVAILABLE_PATHS);
}

//------------------------------------------------------------------------------
// end utility methods - everything below here is part of the conversation.
//------------------------------------------------------------------------------

void Init()
{
  // This method is called once, at the start of the conversation.
  Trace(SUBRACE, "Subrace conversation initialising.");

  object oPC       = GetPcDlgSpeaker();
  int nRace        = GetRacialType(oPC);
  int nAlign       = GetAlignmentGoodEvil(oPC);
  int nAlignLC     = GetAlignmentLawChaos(oPC);
  int nRP          = gsPCGetRolePlay(oPC);
  int bStaticLevel = GetLocalInt(GetModule(), "STATIC_LEVEL");

  // Check if this character has any awards to use.
  string sID = gsPCGetCDKeyID(GetPCPublicCDKey(oPC));
  SetLocalInt(oPC, "award1", StringToInt(miDAGetKeyedValue("gs_player_data",sID,"award1"))); //major
  SetLocalInt(oPC, "award2", StringToInt(miDAGetKeyedValue("gs_player_data",sID,"award2"))); //medium
  SetLocalInt(oPC, "award3", StringToInt(miDAGetKeyedValue("gs_player_data",sID,"award3"))); //minor
  SetLocalInt(oPC, "award1_5", StringToInt(miDAGetKeyedValue("gs_player_data",sID,"award1_5"))); //greater
  // Options for confirming or cancelling. These are static so we can set them
  // up once.
  if (GetElementCount(CONFIRM) == 0)
  {
    AddStringElement("<c þ >[Select]</c>", CONFIRM);
    AddStringElement("<cþ  >[Back]</c>", CONFIRM);
  }

  /*
  if (GetElementCount(SKIN_OPTIONS) == 0)
  {
    AddStringElement("Peasant A <c þ >[Default]</c>", SKIN_OPTIONS);
    AddStringElement("Peasant B", SKIN_OPTIONS);
    AddStringElement("Shaman A", SKIN_OPTIONS);
    AddStringElement("Shaman B", SKIN_OPTIONS);
    AddStringElement("Warrior A", SKIN_OPTIONS);
    AddStringElement("Warrior B", SKIN_OPTIONS);
    AddStringElement("<c þ >[Continue]</c>", SKIN_OPTIONS);
  }
  */

  if (GetElementCount(MARK_OPTIONS) == 0)
  {
    AddStringElement("<c þ >[Yes, after 10 deaths my character will be permakilled]</c>", MARK_OPTIONS);
    AddStringElement("<cþ  >[No]</c>", MARK_OPTIONS);
  }

  if (GetElementCount(ALIGNMENT_OPTIONS) == 0)
  {
    AddStringElement("<c þ >[Change to Lawful alignment]</c>", ALIGNMENT_OPTIONS);
    AddStringElement("<cþ  >[Keep current alignment]</c>", ALIGNMENT_OPTIONS);
  }

  // if (GetElementCount(STARTLOC_OPTIONS) == 0)
  //{
  //  AddStringElement("<c þ >[Yes, I want a different starting location.]</c>", STARTLOC_OPTIONS);
  //  AddStringElement("<cþ  >[No, I want to start in the default location.]</c>", STARTLOC_OPTIONS);
  // }
  
  // Multiple starting locations now available.  Make sure to clear out the options with each conversation.
  DeleteList(STARTLOC_OPTIONS);
  
  
  //----------------------------------------------------------------------------
  // Options for subraces. These vary with each PC so generate them afresh
  // each time a new PC starts this conversation.
  //----------------------------------------------------------------------------
  _ClearSubRaceOptions();

  if (nRace == RACIAL_TYPE_DWARF)
  {
    // Dwarf subraces
    _AddSubraceAsOption(GS_SU_DWARF_GOLD);
    _AddSubraceAsOption(GS_SU_DWARF_SHIELD);

    if (nAlign != ALIGNMENT_GOOD)
    {
      if (!bStaticLevel) _AddSubraceAsOption(GS_SU_DWARF_GRAY);
    }
  }
  else if (nRace == RACIAL_TYPE_ELF)
  {
    // Elf subraces
    _AddSubraceAsOption(GS_SU_ELF_MOON);
    _AddSubraceAsOption(GS_SU_ELF_SUN);
    _AddSubraceAsOption(GS_SU_ELF_WILD);
    _AddSubraceAsOption(GS_SU_ELF_WOOD);

    if (nAlign != ALIGNMENT_GOOD)
    {
      _AddSubraceAsOption(GS_SU_ELF_DROW);
    }
  }
  else if (nRace == RACIAL_TYPE_GNOME)
  {
    // Gnome subraces
    if (!bStaticLevel) _AddSubraceAsOption(GS_SU_GNOME_DEEP);
    _AddSubraceAsOption(GS_SU_GNOME_ROCK);
  }
  else if (nRace == RACIAL_TYPE_HALFLING)
  {
    // Halfling subraces
    _AddSubraceAsOption(GS_SU_HALFLING_GHOSTWISE);
    _AddSubraceAsOption(GS_SU_HALFLING_LIGHTFOOT);
    _AddSubraceAsOption(GS_SU_HALFLING_STRONGHEART);
  }
  else if (nRace == RACIAL_TYPE_HALFORC)
  {
    // Halforc options
    if (nAlign != ALIGNMENT_GOOD)
    {
      _AddSubraceAsOption(GS_SU_FR_OROG);
      if (!bStaticLevel) _AddSubraceAsOption(GS_SU_HALFORC_GNOLL);
    }
  }

  if (nRace == RACIAL_TYPE_HALFLING)
  {
    // Creatures
    if (nAlign != ALIGNMENT_EVIL &&
        GetAlignmentLawChaos(oPC) == ALIGNMENT_NEUTRAL &&
        nRP >= 30)
    {
      _AddSubraceAsOption(GS_SU_SPECIAL_FEY);
    }

    if (nAlign != ALIGNMENT_GOOD)
    {
      _AddSubraceAsOption(GS_SU_SPECIAL_GOBLIN);
      _AddSubraceAsOption(GS_SU_SPECIAL_KOBOLD);
    }
  }

  if (ALLOW_BAATEZU) // In __server_config
  {
    // Baatezu (demon).
    _AddSubraceAsOption(GS_SU_SPECIAL_BAATEZU);
  }

  if (GetLocalInt(oPC, "award1")) // Available as a Major award only.
  {
    // Dragon and Rakshasa currently retired on main server.
    if (bStaticLevel)
    {
       _AddSubraceAsOption(GS_SU_SPECIAL_RAKSHASA);
       _AddSubraceAsOption(GS_SU_SPECIAL_DRAGON);
    }
    // dunshine: check for admin added variable for allowance
    if (GetLocalInt(oPC, "override_allow_rakshasa") == 1) {
       _AddSubraceAsOption(GS_SU_SPECIAL_RAKSHASA);
    }
    if (GetLocalInt(oPC, "override_allow_dragon") == 1) {
       _AddSubraceAsOption(GS_SU_SPECIAL_DRAGON);
    }

    //::  Planetouched moved to Major
    if (nAlign != ALIGNMENT_EVIL) _AddSubraceAsOption(GS_SU_PLANETOUCHED_AASIMAR);
    if (nAlign != ALIGNMENT_GOOD) _AddSubraceAsOption(GS_SU_PLANETOUCHED_TIEFLING);
  }

  if(GetLocalInt(oPC, "award1_5") || GetLocalInt(oPC, "award1")) // greater
  {
    //::  Ogre (Chaotic Evil proper)
    if ( nRace == RACIAL_TYPE_HALFORC ) {
        if (nAlign != ALIGNMENT_GOOD)   _AddSubraceAsOption(GS_SU_SPECIAL_OGRE);
    }
    else if(nRace == RACIAL_TYPE_HALFELF) {
        _AddSubraceAsOption(GS_SU_DEEP_IMASKARI);
    }
  }

  if (GetLocalInt(oPC, "award2") || GetLocalInt(oPC, "award1") || GetLocalInt(oPC, "award1_5")) // Available as a Normal award only.
  {

    //::  Imp (Lawful Evil only!)
    if (nRace == RACIAL_TYPE_HALFLING) {
        if (nAlign == ALIGNMENT_EVIL && GetLevelByClass(CLASS_TYPE_BARBARIAN, oPC) == 0)   _AddSubraceAsOption(GS_SU_SPECIAL_IMP);
    }

  }

  if(GetLocalInt(oPC, "award2") || GetLocalInt(oPC, "award1") || GetLocalInt(oPC, "award1_5") || GetLocalInt(oPC, "award3")) //minor
  {
    if (nRace == RACIAL_TYPE_GNOME) _AddSubraceAsOption(GS_SU_GNOME_FOREST);

    //::  Hobgoblin
    else if (nRace == RACIAL_TYPE_HALFELF) {
       if (nAlign != ALIGNMENT_GOOD) _AddSubraceAsOption(GS_SU_SPECIAL_HOBGOBLIN);
     }
    else if(nRace == RACIAL_TYPE_DWARF)
        _AddSubraceAsOption(GS_SU_DWARF_WILD);
  }


  _AddSubraceAsOption(GS_SU_NONE);
}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();
  int nRP = gsPCGetRolePlay(oPC);

  Trace(SUBRACE, "Setting up dialog page: " + sPage);
  if (sPage == "")
  {
    SetDlgPrompt(INTRO);
    SetDlgResponseList(SUBRACES, OBJECT_SELF);
  }
  else if (sPage == CONFIRM_PAGE)
  {
    int nSubRace = GetIntElement(GetLocalInt(OBJECT_SELF, SELECTION), SELECTIONS);

    if (nSubRace == GS_SU_NONE)
    {
      SetDlgPrompt("Are you sure you do not want to specify a subrace for your character?");
    }
    else
    {

      string sIntro;
      if(nSubRace == GS_SU_PLANETOUCHED_TIEFLING || nSubRace == GS_SU_PLANETOUCHED_AASIMAR || nSubRace == GS_SU_SPECIAL_OGRE || nSubRace == GS_SU_DEEP_IMASKARI)
      {
        if(GetLocalInt(oPC, "award1_5") == 0)
            sIntro = " You will be spending a major award on a greater award tier race. Cancel or select a different subrace if you wish to save your major award.";
      }
      // Remove normal awards.
      else if (nSubRace == GS_SU_SPECIAL_IMP)
      {
        if(GetLocalInt(oPC, "award2") == 0)
        {
            if(GetLocalInt(oPC, "award1_5") >= 1)
            {
                sIntro = " You will be spending a greater award on a medium award tier race. Cancel or select a different subrace if you wish to save your greater award.";
            }
            else
                sIntro = " You will be spending a major award on a medium award tier race. Cancel or select a different subrace if you wish to save your major award.";
        }
      }
      else if(nSubRace == GS_SU_GNOME_FOREST || nSubRace == GS_SU_SPECIAL_HOBGOBLIN || nSubRace == GS_SU_DWARF_WILD) //minor
      {
        if(GetLocalInt(oPC, "award3") == 0)
        {
            if(GetLocalInt(oPC, "award2") >= 1)
            {
                sIntro = " You will be spending a normal award on a minor award tier race. Cancel or select a different subrace if you wish to save your normal award.";
            }
            else if(GetLocalInt(oPC, "award1_5") >= 1)
                sIntro = " You will be spending a greater award on a minor award tier race. Cancel or select a different subrace if you wish to save your greater award.";
            else
                sIntro = " You will be spending a major award on a minor award tier race. Cancel or select a different subrace if you wish to save your major award.";
        }
      }
      if(sIntro != "")
      {
        sIntro = "!!!WARNING!!!! " + sIntro;
        sIntro = StringToRGBString(sIntro, STRING_COLOR_RED);
      }
      SetDlgPrompt(sIntro + gsSUGetDescriptionBySubRace(nSubRace));
    }
    SetDlgResponseList(CONFIRM, OBJECT_SELF);
  }
  else if (sPage == GIFT_SELECT)
  {
    int nECL = _GetSREcl(gsSUGetSubRaceByName(GetSubRace(oPC)));
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
    SetDlgResponseList(AVAILABLE_GIFTS, OBJECT_SELF);
  }
  else if (sPage == GIFT_CONFIRM)
  {
    string sGift1 = GetLocalString(oPC, VAR_GIFT_1);
    string sGift2 = GetLocalString(oPC, VAR_GIFT_2);
    string sGift3 = GetLocalString(oPC, VAR_GIFT_3);
    string sGift4 = GetLocalString(oPC, VAR_GIFT_4);

    // Override for presentation purposes.  The handler for the previous
    // page auto populates GIFT_NONE based on RPR.
    if (sGift2 == GIFT_NONE_DESC) sGift2 = "";
    if (sGift3 == GIFT_NONE_DESC) sGift3 = "";
    if (sGift4 == GIFT_NONE_DESC) sGift4 = "";

    string sGift = (sGift4 != "" ? sGift4 : (sGift3 != "" ? sGift3 : ((sGift2 != "") ? sGift2 : sGift1)));
    SetDlgPrompt("Are you sure?  Selected gift: " + sGift);

    SetDlgResponseList(CONFIRM, OBJECT_SELF);
  }
  else if (sPage == PATH_SELECT)
  {
    SetDlgPrompt(PATH_INTRO);
    _SetUpAllowedPaths();
    SetDlgResponseList(AVAILABLE_PATHS, OBJECT_SELF);
  }
  else if (sPage == PATH_CONFIRM)
  {
    SetDlgPrompt("Are you sure?  Selected path: " + GetLocalString(oPC, VAR_PATH));
    SetDlgResponseList(CONFIRM, OBJECT_SELF);
  }
  else if (sPage == BACKGROUND_SELECT)
  {
    SetDlgPrompt(BACKGROUND_INTRO);
    SetDlgResponseList(AVAILABLE_BACKGROUNDS, OBJECT_SELF);
  }
  else if (sPage == BACKGROUND_CONFIRM)
  {
    int nBackground = GetIntElement(GetLocalInt(OBJECT_SELF, SELECTION), BACKGROUND_SELECTIONS);

    if (nBackground == MI_BA_NONE)
    {
      SetDlgPrompt("Are you sure you do not want to specify a background for your character?");
    }
    else
    {
      SetDlgPrompt(miBAGetBackgroundDescription(nBackground));
    }
    SetDlgResponseList(CONFIRM, OBJECT_SELF);
  }
  else if (sPage == SKIN_SELECT)
  {
    SetDlgPrompt(SKIN_INTRO);
    _SetUpAllowedSkins();
    SetDlgResponseList(SKIN_OPTIONS, OBJECT_SELF);
  }
  else if (sPage == BLOODLINE_SELECT)
  {
    object oHide = gsPCGetCreatureHide(oPC);
    string sBloodLine = "<c þ >" + arSUGetNameByBloodline(GetLocalInt(oHide, BLOODLINE)) + "</c>";

    SetDlgPrompt(ParseFormatStrings(BLOODLINE_INTRO, "%bloodline", sBloodLine));
    _SetUpBloodlines();
    SetDlgResponseList(BLOODLINE_OPTIONS);
  }
  else if (sPage == MARK_OF_DESTINY)
  {
    SetDlgPrompt(MARK_INTRO);
    SetDlgResponseList(MARK_OPTIONS);

    // Now that subraces are set up, set up hunger/thirst/rest on the skin.
    AssignCommand(oPC, gsSTSetInitialState(TRUE));
  }
  else if (sPage == ALIGNMENT_PAGE)
  {
    SetDlgPrompt("On Arelith, Bards can be Lawful.  Do you want your alignment changed to Lawful?");
    SetDlgResponseList(ALIGNMENT_OPTIONS);
  }
  else if (sPage == PACT_SELECT)
  {
    SetDlgPrompt("Your pact can be with devils (L/N only), demons (C/N only) or unseelie fey. "+
     "The fey pact has different abilities from the abyssal and infernal pacts.");

    DeleteList(PACT_OPTIONS);

    if (GetAlignmentLawChaos(oPC) != ALIGNMENT_LAWFUL)
    {
      AddStringElement("Abyssal pact", PACT_OPTIONS);
    }

    if (GetAlignmentLawChaos(oPC) != ALIGNMENT_CHAOTIC)
    {
      AddStringElement("Infernal pact", PACT_OPTIONS);
    }

    AddStringElement("Fey pact", PACT_OPTIONS);
    AddStringElement("Don't play a warlock", PACT_OPTIONS);

    SetDlgResponseList(PACT_OPTIONS);
  }
  else if (sPage == TOTEM_SELECT)
  {
    DeleteList(TOTEM_OPTIONS);
    AddStringElement("Wolf (+2 spot/hide/ms/str/dex)", TOTEM_OPTIONS);
    AddStringElement("Panther (+4 hide/ms/dex)", TOTEM_OPTIONS);
    AddStringElement("Spider (+2 int, immune to poison and paralysis)", TOTEM_OPTIONS);
    AddStringElement("Parrot (+4 cha)", TOTEM_OPTIONS);
    AddStringElement("Eagle (+8 spot, +2 cha)", TOTEM_OPTIONS);
    AddStringElement("Bear (+4 str/con)", TOTEM_OPTIONS);
    AddStringElement("Raven (+4 wis, +10 lore)", TOTEM_OPTIONS);
    AddStringElement("Bat (true sight)", TOTEM_OPTIONS);
    AddStringElement("Rat (+4 int, immune to disease)", TOTEM_OPTIONS);
    AddStringElement("Snake (+2 cha/dex, immune to poison and disease)", TOTEM_OPTIONS);
    AddStringElement("Don't play a totem druid", TOTEM_OPTIONS);

    SetDlgResponseList(TOTEM_OPTIONS);
  }
  else if (sPage == SPELLSWORD_SELECT)
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
  else if (sPage == STARTLOC_SELECT)
  {
	string STARTLOC_INTRO = "The following starting locations are available to your character: " +
	"/n Skal - A bitterly cold island where a beleagured town is assailed by both monsters and the elements.  This is an action and adventure oriented start suitable to players new to roleplay or Neverwinter Nights." +
	"/n Cordor - A sprawling walled city situated on the largest island of the archipelago.  This sophisticated metropolis is a good starting location for experienced roleplayers or those seeking to participate in settlement politics.";
	if (_isEarthkin(oPC))
		STARTLOC_INTRO += "/n Brogendenstein - Dwarves (Excluding Duergar), Halflings, and Gnomes (Including Svirfneblins) have the option to be a part of the Earthkin Alliance.  This special starting location is a mountain stronghold where other Earthkin races gather.";

    AddStringElement("<c þ >[Skal - An icy northern island in need of adventurers. (Recommended for New Players)]</c>", STARTLOC_OPTIONS);
    AddStringElement("<c þ >[Cordor - A bustling port city of politics and commerce.]</c>", STARTLOC_OPTIONS);
	if (_isEarthkin(oPC))
		AddStringElement("<c þ >[Brogendenstein - A dwarven bastion, center of the Earthkin Alliance.]</c>", STARTLOC_OPTIONS);
		
    SetDlgPrompt(STARTLOC_INTRO);
    SetDlgResponseList(STARTLOC_OPTIONS, OBJECT_SELF);
  }
  else if (sPage == AWARD_TYPE)
  {
    SetDlgPrompt("You have earnt one or more rewards by retiring high level characters. "+
    "Do you wish to use one of these awards on this character? Major: " + IntToString(GetLocalInt(oPC, "award1")) +
    " Greater: " + IntToString(GetLocalInt(oPC, "award1_5")) + " Medium: " + IntToString(GetLocalInt(oPC, "award2")) +
    " Minor: " +  IntToString(GetLocalInt(oPC, "award3")));

    DeleteList(AWARD_TYPE);
    if (GetLocalInt(oPC, "award1")) AddStringElement("Major award", AWARD_TYPE);
    if (GetLocalInt(oPC, "award2") || GetLocalInt(oPC, "award1_5")) AddStringElement("Normal award", AWARD_TYPE);
    if (GetLocalInt(oPC, "award3")) AddStringElement("Minor award", AWARD_TYPE);
    AddStringElement("Do not use award", AWARD_TYPE);
    SetDlgResponseList(AWARD_TYPE);
  }
  else if (sPage == AWARD_SELECT)
  {
    int nType = GetLocalInt(oPC, "award_type");
    DeleteList(AWARD_SELECT);

    SetDlgPrompt("Select benefit.  Minor awards give -1 ECL, normal and greater awards give "
     + "-2 and major awards give -3.");

    AddStringElement("Select a different award", AWARD_SELECT);
    AddStringElement("Reduced ECL", AWARD_SELECT);
    AddStringElement("Noble Award (Minor Award)", AWARD_SELECT);
    if (nType != 3)
    {
      //AddStringElement("Ride Horse skill", AWARD_SELECT);
      // Septire - Disabled Spell shielding gift for now. I recommend 2 + Hit Dice (capping at 32) in future.
      // AddStringElement(GIFT_OF_SPELL_SHIELDING_DESC, AWARD_SELECT);
      AddStringElement("Play a Good aligned monster", AWARD_SELECT);
    }
    if (nType == 1)
    {
      AddStringElement("Red Dragon Disciple PRC token", AWARD_SELECT);
      //AddStringElement("Shifter PRC token", AWARD_SELECT);
    }

    SetDlgResponseList(AWARD_SELECT);
  }
  else
  {
    SendMessageToPC(oPC,
                    "You've found a bug. How embarassing. Please report it.");
    EndDlg();
  }
}



void HandleSelection()
{
  // This method handles what happens when the player selects an option.
  int selection    = GetDlgSelection();
  object oPC       = GetPcDlgSpeaker();
  string sPage     = GetDlgPageString();
  int bStaticLevel = GetLocalInt(GetModule(), "STATIC_LEVEL");

  Trace(SUBRACE, "Player has selected an option: " + IntToString(selection));
  Trace(SUBRACE, "Page: " + sPage);
  if (sPage == "")
  {
    SetLocalInt(OBJECT_SELF, SELECTION, selection);
    SetDlgPageString(CONFIRM_PAGE);
  }
  else if (sPage == CONFIRM_PAGE)
  {
    switch (selection)
    {
      case 0:
      {
        // OK
        int nSkin = _ApplySubRace(); // Returns a MI_SKIN_* constant
        _SetUpAllowedBackgrounds(); // Now that we know which subrace we are.
        if (nSkin)
        {
          SetDlgPageString(SKIN_SELECT);
        }
        //::  Open up Bloodline Dialog Options here
        else if ( _SubraceHaveBloodline(oPC) )
        {
            SetDlgPageString(BLOODLINE_SELECT);
        }
        else
        {
          SetDlgPageString(MARK_OF_DESTINY);
        }
        break;
      }
      case 1:
        // Back
        SetDlgPageString("");
        break;
    }
  }
  else if (sPage == GIFT_SELECT)
  {
    string sGift = GetStringElement(selection, AVAILABLE_GIFTS);
    string sGift1 = GetLocalString(oPC, VAR_GIFT_1);
    string sGift2 = GetLocalString(oPC, VAR_GIFT_2);
    string sGift3 = GetLocalString(oPC, VAR_GIFT_3);
    //string sGift4 = GetLocalString(oPC, VAR_GIFT_4);

    int nRPR = gsPCGetRolePlay(oPC);

    if (sGift1 == "")
    {
      SetLocalString(oPC, VAR_GIFT_1, sGift);
    }
    else if (sGift2 == "")
    {
      SetLocalString(oPC, VAR_GIFT_2, sGift);
    }
    else if (sGift3 == "")
    {
      SetLocalString(oPC, VAR_GIFT_3, sGift);
    }
    //else if (sGift4 == "")
    //{
    //  SetLocalString(oPC, VAR_GIFT_4, sGift);
    //}

    SetDlgPageString(GIFT_CONFIRM);
  }
  else if (sPage == GIFT_CONFIRM)
  {
    string sGift1 = GetLocalString(oPC, VAR_GIFT_1);
    string sGift2 = GetLocalString(oPC, VAR_GIFT_2);
    string sGift3 = GetLocalString(oPC, VAR_GIFT_3);
    //string sGift4 = GetLocalString(oPC, VAR_GIFT_4);

    if (!selection)
    {
      int nECL = _GetSREcl(gsSUGetSubRaceByName(GetSubRace(oPC)));
      if (sGift1 == GIFT_NONE_DESC || sGift2 == GIFT_NONE_DESC ||
          (nECL <= 0 && sGift3 != "" || nECL == 1 && sGift2 != "" || nECL == 2 && sGift1 != ""))
      //|| sGift4 != "")
      {
            _ApplyGifts();

            if (GetLocalInt(oPC, "award3") || GetLocalInt(oPC, "award2") ||
                  GetLocalInt(oPC, "award1") || GetLocalInt(oPC, "award1_5"))
            {
              SetDlgPageString(AWARD_TYPE);
            }
            else
            {
              SetDlgPageString(BACKGROUND_SELECT);
            }
      }
      else
      {
            SetDlgPageString(GIFT_SELECT);
      }
    }
    else
    {
      //if (sGift4 != "") DeleteLocalString(oPC, VAR_GIFT_4);
      if (sGift3 != "") DeleteLocalString(oPC, VAR_GIFT_3);
      else if (sGift2 != "") DeleteLocalString(oPC, VAR_GIFT_2);
      else if (sGift1 != "") DeleteLocalString(oPC, VAR_GIFT_1);
      SetDlgPageString(GIFT_SELECT);
    }
  }
  else if (sPage == PATH_SELECT)
  {
    SetLocalString(oPC, VAR_PATH, GetStringElement(selection, AVAILABLE_PATHS));
    SetDlgPageString(PATH_CONFIRM);
  }
  else if (sPage == PATH_CONFIRM)
  {
    object oItem = gsPCGetCreatureHide(oPC);

    if (!selection)
    {
      // What we do here depends on which path it is.
      // This is the last part of this convo, so we can start other convos.
      object oAbility  = GetItemPossessedBy(oPC, "GS_SU_ABILITY");
      string sPath = GetLocalString(oPC, VAR_PATH);
      SetDescription(oAbility, GetDescription(oAbility) + "\nPath: " + sPath);
      SetIdentified(oAbility, TRUE);
      SetLocalString(oItem, "MI_PATH", sPath);

      if (sPath == PATH_NONE)
      {
        EndDlg();
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
        EndDlg();
      }
      else if (sPath == PATH_OF_TRUE_FIRE)
      {
        // Flag that they are a true-fire sorc.
        SendMessageToPC(oPC, "You have selected Path of True Fire.");
        SetLocalInt(oItem, "TRUE_FIRE", TRUE);
        EndDlg();
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
        EndDlg();
      }
      else if (sPath == PATH_OF_THE_SNIPER)
      {
        SendMessageToPC(oPC, "You have selected Path of the Sniper.");
        RemoveRangerDualWieldFeats(oPC);
        AddSniperFeats(oPC);
        EndDlg();
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
        EndDlg();
      }
	  else if (sPath == PATH_OF_FAVOURED_SOUL)
	  {
	    // Remove both domains.
		NWNX_Creature_SetClericDomain(oPC, 1, 2); // 2 is an unused index in domains.2da.
		NWNX_Creature_SetClericDomain(oPC, 2, 2); // 2 is an unused index in domains.2da.
		
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
        EndDlg();
	  }
      else if (sPath == PATH_OF_SHADOW)
      {
        SetLocalInt(oItem, "SHADOW_MAGE", TRUE);
        miCLOverridePRC(oPC);
        SendMessageToPC(oPC, "You have selected Shadow Mage.");
        EndDlg();
      }
      else if (sPath == PATH_OF_THE_TRIBESMAN)
      {
        // Flag that they are a tribesman barbarian.  Used in the rage script.
        SetLocalInt(oItem, "TRIBESMAN", TRUE);
        SendMessageToPC(oPC, "You have selected Path of the Tribesman.");
        EndDlg();
      }
      else if (sPath == PATH_OF_WILD_MAGE)
      {
        // Flag that they are a wild mage wiz.
        SendMessageToPC(oPC, "You have selected the Wild Mage School.");
        SetLocalInt(oItem, "WILD_MAGE", TRUE);
        EndDlg();
      }
      else if (sPath == PATH_OF_SPELLSWORD)
      {
        //Flag spellsword and then select blocked school
        //miSSSetIsSpellsword(oPC);
        SetDlgPageString(SPELLSWORD_SELECT);
      }

    }
    else SetDlgPageString(PATH_SELECT);
  }
  else if (sPage == AWARD_TYPE)
  {
    string sResponse = GetStringElement(selection, AWARD_TYPE);
    SetDlgPageString(AWARD_SELECT);

    if (sResponse == "Major award") SetLocalInt(oPC, "award_type", 1);
    else if (sResponse == "Normal award") SetLocalInt(oPC, "award_type", 2);
    else if (sResponse == "Minor award") SetLocalInt(oPC, "award_type", 3);
    else SetDlgPageString(BACKGROUND_SELECT);
  }
  else if (sPage == AWARD_SELECT)
  {
    SetDlgPageString(BACKGROUND_SELECT);
    int nType = GetLocalInt(oPC, "award_type");

    switch (selection)
    {
      case 0:
        SetDlgPageString(AWARD_TYPE);
        break;
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
      case 2: //noble
        SetLocalInt(gsPCGetCreatureHide(oPC), "NOBLE_AWARD", 1);
        AddKnownFeat (oPC, FEAT_SILVER_PALM);
        break;
      //case 2:
      //  // Ride Horse
      //  SetLocalInt(gsPCGetCreatureHide(oPC), "MAY_RIDE_HORSE", 1);
      //  break;
      case 3:
        // Good aligned monster
        NWNX_Creature_SetAlignmentGoodEvil(oPC, 85);
        break;
      case 4:
        // RDD
        CreateItemOnObject("gs_item917", oPC);
        break;
      case 5:
        // Shifter
        //CreateItemOnObject("gs_item915", oPC);
        break;

    }

    // Remove used award.
    if (selection)
    {
      object oCreatureHide = gsPCGetCreatureHide(oPC);
      string sAward;
      switch (nType)
      {
        case 1:
          sAward = "award1";
          SetLocalInt(oCreatureHide, "HAS_MAJOR_AWARD", TRUE);
          break;
        case 2:
          if(GetLocalInt(oPC, "award2") > 0)
          {
            sAward = "award2";
            SetLocalInt(oCreatureHide, "HAS_NORMAL_AWARD", TRUE);
          }
          else
          {
            sAward = "award1_5";
            SetLocalInt(oCreatureHide, "HAS_GREATER_AWARD", TRUE);
          }
          break;
        case 3:
          sAward = "award3";
          SetLocalInt(oCreatureHide, "HAS_MINOR_AWARD", TRUE);
          break;
      }

      string sID = gsPCGetCDKeyID(GetPCPublicCDKey(oPC));
      int nAwards = GetLocalInt(oPC, sAward) -1;
      miDASetKeyedValue("gs_player_data", sID, sAward, IntToString(nAwards));
    }
  }
  else if (sPage == BACKGROUND_SELECT)
  {
    SetLocalInt(OBJECT_SELF, SELECTION, selection);
    SetDlgPageString(BACKGROUND_CONFIRM);
  }
  else if (sPage == BACKGROUND_CONFIRM)
  {
    switch (selection)
    {
      case 0:
      {
        // OK
        _ApplyBackground();
        // Underdarkers, slaves and outcasts start in the UD.  Otherwise, players get a selection.
    		// Earthkin:  Skal, Cordor or Brogendenstein
    		// Other Surfacers:  Cordor or Skal
    		if (!_isUnderdarkSubrace(oPC) && 
    			   miBAGetBackground(oPC) != MI_BA_OUTCAST &&
    			   miBAGetBackground(oPC) != MI_BA_SLAVE)
		    {
            SetDlgPageString(STARTLOC_SELECT);
            break;
        }
        else
        {
            // Skip Alternate Start Location, Go to Path Select
            SetDlgPageString(PATH_SELECT);
            break;
        }
      }
      case 1:
        // Back
        SetDlgPageString(BACKGROUND_SELECT);
        break;
    }
  }
  else if (sPage == STARTLOC_SELECT)
  {
    switch (selection)
    {
       case 0:	// Skal
          _ApplyStartLocation(1);
          break;
       case 1:	// Cordor
			    _ApplyStartLocation(2);
          break;
		   case 2:  // Brogendenstein 
					_ApplyStartLocation(3);
    }
    SetDlgPageString(PATH_SELECT);
  }
  else if (sPage == SKIN_SELECT)
  {
    int nNumOptions = GetLocalInt(OBJECT_SELF, NUM_DLG_OPTIONS);

    if (selection != nNumOptions) {
        _ApplySkin(selection);
    } else {
        //::  Open up Bloodline Dialog Options here
        if ( _SubraceHaveBloodline(oPC) ) {
            SetDlgPageString(BLOODLINE_SELECT);
        }
        else {
            if (GetLevelByClass(CLASS_TYPE_BARD, oPC) > 0)
                SetDlgPageString(ALIGNMENT_PAGE);
            else
                _BypassGiftOption(oPC);
            // SetDlgPageString(MARK_OF_DESTINY);
        }
    }
  }
  else if (sPage == BLOODLINE_SELECT)
  {
    int nNumOptions = GetLocalInt(OBJECT_SELF, NUM_DLG_OPTIONS);
    object oHide    = gsPCGetCreatureHide(oPC);
    int nBloodLine  = GetLocalInt(oHide, BLOODLINE);

    if (selection != nNumOptions) {
        _ApplyBloodline(selection);
    } else if ( nBloodLine > BLOODLINE_NONE ) {
        arSUApplyBloodline(oHide, nBloodLine);

        /*
        object oAbility  = GetItemPossessedBy(oPC, "GS_SU_ABILITY");
        string sBloodline = arSUGetNameByBloodline(nBloodLine);
        SetDescription(oAbility, GetDescription(oAbility) + "\nBloodline: " + sBloodline);
        */
        if (GetLevelByClass(CLASS_TYPE_BARD, oPC) > 0)
            SetDlgPageString(ALIGNMENT_PAGE);
        else
            _BypassGiftOption(oPC);
        // SetDlgPageString(MARK_OF_DESTINY);
    } else {
        FloatingTextStringOnCreature("You have to select a Bloodline before proceeding!", oPC, FALSE);
    }
  }
  else if (sPage == MARK_OF_DESTINY)
  {
    if (!selection || bStaticLevel)
    {
      if (bStaticLevel) {
        SendMessageToPC(oPC, "On the Fixed Level server all PCs have a mark of destiny. "
         + "However, only PvP deaths count towards your life total - you can die to "
         + "monsters as often as you want.");

        if (!GetIsObjectValid(GetItemPossessedBy(oPC, "mi_mark_destiny")))
        {
          CreateItemOnObject("mi_mark_destiny", oPC);
        }

      } else {
        // disabling this on-creation, but inform players they can contact a DM for it instead
        SendMessageToPC(oPC, "Choosing Mark of Destiny on character creation is no longer supported, if you still want to play with one, contact a DM ingame. This is not recommended for new players.");

        //if (!GetIsObjectValid(GetItemPossessedBy(oPC, "mi_mark_destiny")))
        //{
        //  CreateItemOnObject("mi_mark_destiny", oPC);
        //}

      }

    }

    if (GetLevelByClass(CLASS_TYPE_BARD, oPC) > 0)
      SetDlgPageString(ALIGNMENT_PAGE);
    else
        _BypassGiftOption(oPC);
  }
  else if (sPage == ALIGNMENT_PAGE)
  {
    switch (selection)
    {
      case 0: // change to lawful.  Bards start out either chaotic or neutral.
      {
        if (GetAlignmentLawChaos(oPC) == ALIGNMENT_CHAOTIC)
        {
          AdjustAlignment(oPC, ALIGNMENT_LAWFUL, 70, FALSE);
        }
        else
        {
          AdjustAlignment(oPC, ALIGNMENT_LAWFUL, 35, FALSE);
        }
        // Fall through to set page.
      }
      default:
        _BypassGiftOption(oPC);
        break;
    }
  }
  else if (sPage == PACT_SELECT)
  {
    string sPact = GetStringElement(selection, PACT_OPTIONS);

    if (sPact == "Abyssal pact") miWATurnIntoWarlock(oPC, PACT_ABYSSAL);
    else if (sPact == "Infernal pact") miWATurnIntoWarlock(oPC, PACT_INFERNAL);
    else if (sPact == "Fey pact") miWATurnIntoWarlock(oPC, PACT_FEY);

    EndDlg();
  }
  else if (sPage == TOTEM_SELECT)
  {
    if ( selection < 10)
    {
      miTOGrantTotem(oPC, selection + 1);
    }
    EndDlg();
  }
  else if (sPage == SPELLSWORD_SELECT)
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
    //miSSApplyBonuses(oPC, FALSE, FALSE);
    EndDlg();
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
      break;
    case DLG_END:
      ApplyCharacterBonuses(GetPcDlgSpeaker(), FALSE, TRUE, TRUE);
      break;
  }
}
