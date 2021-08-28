//::///////////////////////////////////////////////
//:: Name    zz_co_form
//:: FileName
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The conversation file for distorted mirros
*/
//:://////////////////////////////////////////////
//:: Created By: Morderon
//:: Created On: 12/11/2010 Added spellbook save: 04/23/2012
//:://////////////////////////////////////////////
#include "zzdlg_main_inc"
#include "inc_iprop"
#include "inc_text"
#include "x2_inc_itemprop"
#include "x2_inc_craft"
#include "x0_inc_skills"
#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"
#include "nwnx_alts"

const string FB_RESPONSES = "FB_RESPONSES";
const string SHIELD_MENU  = "SHIELD_MENU";
const string WEAPON_MENU  = "WEAPON_MENU";
const string TRAP_MENU    = "TRAP_MENU";
const string DIF_MENU     = "DIF_MENU";
const string SAVE_MENU    = "SAVE_MENU";
const string SAVE_SUB     = "SAVE_SUB";
const string SPELL_MENU   = "SPELL_MENU";
const string SPELL_SUB    = "SPELL_SUB";
const string SPELL_CLASS  = "SPELL_CLASS";
//These hold the responses that aren't going to change
const string STARTER_MENU = "STARTER_MENU";
const string BODY_MENU    = "BODY_MENU";
const string LEG_MENU     = "LEG_MENU";
const string ARM_MENU     = "ARM_MENU";
const string WEP_SUBMENU  = "WEP_SUB";
const string PACK_MENU    = "PACK_MENU";
const string OUTFIT_LIST  = "OUTFIT_LIST";

//Prefix for outfit saves
const string MD_OUTS = "MD_OUTS";
const string MD_SPELLBOOK = "MD_SPBOOK";
const string MD_CLASS = "MD_CLASS";


//OnPageInit, these set the dialog prompts
//Sets a blue dialog prompt
void onBluePrompt(string sTxt = "[Select armor part]");
//Sets up the responses when an item is selected.
void onItem();
//When the shield option is selected.
void onShield();
//When the weapon option is selected.
void onWeapon();
//on Weapon part
void onWepPart();
//on Trap
void onTrap();
//Difficult trap
void onDifficulty();
//When the save option is selection from the start menu
void onSave();
void onSaveSub();

//onSelection
//Toggles visibility of helm
void onSHelm();
//Helmet, Cloaks
void onSItem(int nInventorySlot, int nType, int nIndex, int nTable);
//Wrapper function of onSItem
void onSArmor(int nIndex);
//Changes the objects form
void onSForm();
//cleans up variables
void CleanUp();
//Next shield part
void onSNShield();
//Previous shield part
void onSPShield();
//Changes the weapon style
void onSWeaponS(int nDest);
//Next weapon color
void onSNWeaponC();
//Previous weapon color
void onSPWeaponC();
//On selection of a part.
void onSWepPart(int nPart);
//Pack Toggle
void onSPackTog();
//Pack Next
void onSNPack();
//Pack Prev
void onSPPack();
//Trap Selection
void onSTrap();
//Difficulty Selection. create the trap
void onSDif();
//On Save option selection
void onSSub();
//Saves the spellbook
void onSSpell(int nSelection);

void OnInit()
{
  object oPC = dlgGetSpeakingPC();
  
  dlgClearResponseList(STARTER_MENU);
  
  dlgAddResponseAction(STARTER_MENU, "Toggle helmet visibility");
  dlgAddResponseAction(STARTER_MENU, "Helmet");
  dlgAddResponseAction(STARTER_MENU, "Cloak");
  dlgAddResponseAction(STARTER_MENU, "Body");
  dlgAddResponseAction(STARTER_MENU, "Arms");
  dlgAddResponseAction(STARTER_MENU, "Legs");
  dlgAddResponseAction(STARTER_MENU, "Shield");
  dlgAddResponseAction(STARTER_MENU, "Weapon");
  dlgAddResponseAction(STARTER_MENU, "Backpack");
  dlgAddResponseAction(STARTER_MENU, "Create Trap Kit");
  dlgAddResponseAction(STARTER_MENU, "Save Options");
  if (GetLevelByClass(CLASS_TYPE_SHIFTER, oPC))
  {
    dlgAddResponseAction(STARTER_MENU, "Modify Appearance");
  }
  //Only for classes with a spellbook (and paladins/rangers above level 4)
  if(GetLevelByClass(CLASS_TYPE_WIZARD, oPC) >= 1 ||
     GetLevelByClass(CLASS_TYPE_CLERIC, oPC) >= 1 ||
     GetLevelByClass(CLASS_TYPE_DRUID, oPC) >= 1  ||
     GetLevelByClass(CLASS_TYPE_RANGER, oPC) >= 4 ||
     GetLevelByClass(CLASS_TYPE_PALADIN, oPC) >= 4)
  {
    dlgAddResponseAction(STARTER_MENU, "Spellbooks");
  }
  
  dlgClearResponseList(BODY_MENU);
  dlgAddResponse(BODY_MENU, "Neck");
  dlgAddResponse(BODY_MENU, "Torso");
  dlgAddResponse(BODY_MENU, "Belt");
  dlgAddResponse(BODY_MENU, "Pelvis");
  dlgAddResponse(BODY_MENU, "Robe");

  dlgClearResponseList(LEG_MENU);
  dlgAddResponse(LEG_MENU, "Right Thigh");
  dlgAddResponse(LEG_MENU, "Left Thigh");
  dlgAddResponse(LEG_MENU, "Right Shin");
  dlgAddResponse(LEG_MENU, "Left Shin");
  dlgAddResponse(LEG_MENU, "Right Foot");
  dlgAddResponse(LEG_MENU, "Left Foot");

  dlgClearResponseList(ARM_MENU);
  dlgAddResponse(ARM_MENU, "Right Shoulder");
  dlgAddResponse(ARM_MENU, "Left Shoulder");
  dlgAddResponse(ARM_MENU, "Right Biceps");
  dlgAddResponse(ARM_MENU, "Left Biceps");
  dlgAddResponse(ARM_MENU, "Right Forearm");
  dlgAddResponse(ARM_MENU, "Left Forearm");
  dlgAddResponse(ARM_MENU, "Right Hand");
  dlgAddResponse(ARM_MENU, "Left Hand");

  dlgClearResponseList(WEP_SUBMENU);
  dlgAddResponseAction(WEP_SUBMENU, "Show Next Style");
  dlgAddResponseAction(WEP_SUBMENU, "Show Previous Style");
  dlgAddResponseAction(WEP_SUBMENU, "Show Next Color");
  dlgAddResponseAction(WEP_SUBMENU, "Show Previous Color");

  dlgClearResponseList(PACK_MENU);
  dlgAddResponseAction(PACK_MENU, "Next");
  dlgAddResponseAction(PACK_MENU, "Previous");
  dlgAddResponseAction(PACK_MENU, "Toggle on/off");

  dlgClearResponseList(SPELL_MENU);
  dlgAddResponseAction(SPELL_MENU, "Spellbook 1");
  dlgAddResponseAction(SPELL_MENU, "Spellbook 2");
  dlgAddResponseAction(SPELL_MENU, "Spellbook 3");
  dlgAddResponseAction(SPELL_MENU, "Spellbook 4");
  dlgAddResponseAction(SPELL_MENU, "Spellbook 5");

  dlgActivatePreservePageNumberOnSelection();
  dlgActivateEndResponse("[Done]", txtBlue);
  dlgChangeLabelNext(DLG_DEFAULTLABEL_NEXT, DLG_DEFAULT_TXT_ACTION_COLOR);
  dlgChangeLabelPrevious(DLG_DEFAULTLABEL_PREV, DLG_DEFAULT_TXT_ACTION_COLOR);

  dlgChangePage(STARTER_MENU);
}
void OnPageInit(string sPage)
{

  // Conversation options
  if(sPage == STARTER_MENU)
   onBluePrompt();
  else
  {
    //Only set up reset response on pages not the first
    dlgActivateResetResponse(DLG_DEFAULTLABEL_RESET, DLG_DEFAULT_TXT_ACTION_COLOR);
    if(sPage == BODY_MENU || sPage == LEG_MENU || sPage == ARM_MENU)
      onBluePrompt();
    else if(sPage == SHIELD_MENU)
      onShield();
    else if(sPage == WEAPON_MENU)
      onWeapon();
    else if(sPage == WEP_SUBMENU)
      onWepPart();
    else if(sPage == PACK_MENU)
      onBluePrompt("Select appearance:");
    else if(sPage == TRAP_MENU)
      onTrap();
    else if(sPage == DIF_MENU)
      onDifficulty();
    else if(sPage == SAVE_MENU)
      onSave();
    else if(sPage == SAVE_SUB)
      onSaveSub();
    else if(sPage == SPELL_MENU)
      onBluePrompt("Select spell book slot:");
    else if(sPage == SPELL_SUB)
    {
      onBluePrompt("What would you like to do?");
      dlgClearResponseList(SPELL_SUB);
      dlgAddResponseAction(SPELL_SUB, "Replace Saved Spellbook with Current.");

      object oHide = gsPCGetCreatureHide(dlgGetSpeakingPC());
      string sVar =  GetLocalString(oHide, MD_SPELLBOOK);
      int nStart = FindSubString(sVar, IntToString(dlgGetPlayerDataInt(MD_CLASS)) + "C");
      if(nStart > -1)
      {
        sVar = GetSubString(sVar, nStart, FindSubString(sVar, "_", nStart) - nStart);
        if(FindSubString(sVar, dlgGetPlayerDataString(MD_SPELLBOOK) + "S") > -1)
          dlgAddResponseAction(SPELL_SUB, "Change to Saved Spellbook.");
      }
    }
    else if(sPage == SPELL_CLASS)
    {
      object oPC = dlgGetSpeakingPC();
      onBluePrompt("What class would you like to save a book for?");
      if(!GetElementCount(SPELL_CLASS, oPC))
      {
        if(GetLevelByClass(CLASS_TYPE_WIZARD, oPC) >= 1)
          dlgAddResponseAction(SPELL_CLASS, "Wizard");
        if(GetLevelByClass(CLASS_TYPE_CLERIC, oPC) >= 1)
          dlgAddResponseAction(SPELL_CLASS, "Cleric");
        if(GetLevelByClass(CLASS_TYPE_DRUID, oPC) >= 1)
          dlgAddResponseAction(SPELL_CLASS, "Druid");
        if(GetLevelByClass(CLASS_TYPE_RANGER, oPC) >= 4)
          dlgAddResponseAction(SPELL_CLASS, "Ranger");
        if(GetLevelByClass(CLASS_TYPE_PALADIN, oPC) >= 4)
          dlgAddResponseAction(SPELL_CLASS, "Paladin");
      }
    }
    else if(sPage == OUTFIT_LIST)
    {
        dlgSetPrompt("Your saved outfits are as follows:\n" +
            GetLocalString(gsPCGetCreatureHide(dlgGetSpeakingPC()), "outfitList"));
    }
    else
      onItem();
  }

  dlgSetActiveResponseList(sPage);

}
void OnSelection(string sPage)
{
  object oPC = dlgGetSpeakingPC();
  int nSel = dlgGetSelectionIndex();
 //Save the last page if needed.
  if(sPage == BODY_MENU)
  {
    dlgSetPlayerDataString("MD_LPage", sPage);
    switch(nSel)
    {
    case 0: onSArmor(ITEM_APPR_ARMOR_MODEL_NECK); break;
    case 1: onSArmor(ITEM_APPR_ARMOR_MODEL_TORSO); break;
    case 2: onSArmor(ITEM_APPR_ARMOR_MODEL_BELT); break;
    case 3: onSArmor(ITEM_APPR_ARMOR_MODEL_PELVIS); break;
    case 4: onSArmor(ITEM_APPR_ARMOR_MODEL_ROBE); break;
    }
  }
  else if(sPage == LEG_MENU)
  {
    dlgSetPlayerDataString("MD_LPage", sPage);
    switch(nSel)
    {
    case 0: onSArmor(ITEM_APPR_ARMOR_MODEL_RTHIGH); break;
    case 1: onSArmor(ITEM_APPR_ARMOR_MODEL_LTHIGH); break;
    case 2: onSArmor(ITEM_APPR_ARMOR_MODEL_RSHIN); break;
    case 3: onSArmor(ITEM_APPR_ARMOR_MODEL_LSHIN); break;
    case 4: onSArmor(ITEM_APPR_ARMOR_MODEL_RFOOT); break;
    case 5: onSArmor(ITEM_APPR_ARMOR_MODEL_LFOOT); break;
    }
  }
  else if(sPage == ARM_MENU)
  {
    dlgSetPlayerDataString("MD_LPage", sPage);
    switch(nSel)
    {
    case 0: onSArmor(ITEM_APPR_ARMOR_MODEL_RSHOULDER); break;
    case 1: onSArmor(ITEM_APPR_ARMOR_MODEL_LSHOULDER); break;
    case 2: onSArmor(ITEM_APPR_ARMOR_MODEL_RBICEP); break;
    case 3: onSArmor(ITEM_APPR_ARMOR_MODEL_LBICEP); break;
    case 4: onSArmor(ITEM_APPR_ARMOR_MODEL_RFOREARM); break;
    case 5: onSArmor(ITEM_APPR_ARMOR_MODEL_LFOREARM); break;
    case 6: onSArmor(ITEM_APPR_ARMOR_MODEL_RHAND); break;
    case 7: onSArmor(ITEM_APPR_ARMOR_MODEL_LHAND); break;
    }
  }
  else if(sPage == FB_RESPONSES)
    onSForm();
  else if(sPage == SHIELD_MENU)
  {
    switch(nSel)
    {
    case 0: onSNShield(); break;
    case 1: onSPShield(); break;
    }
  }
  else if(sPage == WEAPON_MENU)
  {
    dlgSetPlayerDataString("MD_LPage", sPage);
    switch(nSel)
    {
    case 0: onSWepPart(ITEM_APPR_WEAPON_MODEL_TOP); break;
    case 1: onSWepPart(ITEM_APPR_WEAPON_MODEL_MIDDLE); break;
    case 2: onSWepPart(ITEM_APPR_WEAPON_MODEL_BOTTOM); break;
    }
  }
  else if(sPage == WEP_SUBMENU)
  {
    switch(nSel)
    {
    case 0: onSWeaponS(X2_IP_WEAPONTYPE_NEXT); break;
    case 1: onSWeaponS(X2_IP_WEAPONTYPE_PREV); break;
    case 2: onSNWeaponC();  break;
    case 3: onSPWeaponC(); break;
    }
  }
  else if(sPage == PACK_MENU)
  {
    switch(nSel)
    {
    case 0: onSNPack(); break;
    case 1: onSPPack(); break;
    case 2: onSPackTog();  break;
    }
  }
  else if(sPage == TRAP_MENU)
  {
    dlgSetPlayerDataString("MD_LPage", sPage);
    onSTrap();
  }
  else if(sPage ==  DIF_MENU)
  {
    onSDif();
  }
  else if(sPage == SAVE_MENU)
  {
    if(dlgIsSelectionEqualToName("List outfits"))
        dlgChangePage(OUTFIT_LIST);
    else
    {
        dlgSetPlayerDataString("MD_LPage", sPage);
        dlgSetPlayerDataInt(MD_OUTS, nSel + 1);
        dlgChangePage(SAVE_SUB);
    }
  }
  else if(sPage == SAVE_SUB)
    onSSub();
  else if(sPage == SPELL_MENU)
  {
   // dlgSetPlayerDataString("MD_LPage", sPage);
    dlgSetPlayerDataString(MD_SPELLBOOK, IntToString(nSel + 1));
    dlgChangePage(SPELL_SUB);
  }
  else if(sPage == SPELL_CLASS)
  {
    //dlgSetPlayerDataString("MD_LPage", sPage);
    string sName = dlgGetSelectionName();
    int nClass;
    if(sName == "Wizard")
      nClass = CLASS_TYPE_WIZARD;
    else if(sName == "Cleric")
      nClass = CLASS_TYPE_CLERIC;
    else if(sName == "Druid")
      nClass = CLASS_TYPE_DRUID;
    else if(sName == "Ranger")
      nClass = CLASS_TYPE_RANGER;
    else if(sName == "Paladin")
      nClass = CLASS_TYPE_PALADIN;

    dlgSetPlayerDataInt(MD_CLASS, nClass);

    dlgChangePage(SPELL_MENU);
  }
  else if(sPage == SPELL_SUB)
    onSSpell(nSel);
  else //starter Menu
  {
    switch(nSel)
    {
    case 0: onSHelm(); break;
    case 1: onSItem(INVENTORY_SLOT_HEAD, ITEM_APPR_TYPE_SIMPLE_MODEL, -2, gsIPGetTableID("helmetmodel")); break;
    case 2: onSItem(INVENTORY_SLOT_CLOAK, ITEM_APPR_TYPE_SIMPLE_MODEL, -1, gsIPGetTableID("cloakmodel")); break;
    case 3: dlgChangePage(BODY_MENU); break;
    case 4: dlgChangePage(ARM_MENU); break;
    case 5: dlgChangePage(LEG_MENU); break;
    case 6: dlgChangePage(SHIELD_MENU); break;
    case 7: dlgChangePage(WEAPON_MENU); break;
    case 8: dlgChangePage(PACK_MENU); break;
    case 9: dlgChangePage(TRAP_MENU); break;
    case 10: dlgChangePage(SAVE_MENU); break;
    case 11: 
	{
	  if (GetLevelByClass(CLASS_TYPE_SHIFTER, oPC))
	  {
	    dlgEndDialog();
		SetLocalString(oPC, "dialog", "zdlg_customise");
		AssignCommand(oPC, ActionStartConversation(oPC, "zdlg_converse"));
	  }
	  else
	  {
	    dlgChangePage(SPELL_CLASS); break;
	  }
	}
	case 12: dlgChangePage(SPELL_CLASS); break;
    }
  }
}
void OnContinue(string sPage, int nContinuePage)
{
}
void OnReset(string sPage)
{
  dlgResetPageNumber();
  string sLPage = dlgGetPlayerDataString("MD_LPage");
  if(sPage == SPELL_SUB)
   dlgChangePage(SPELL_MENU);
  else if(sPage == SPELL_MENU)
    dlgChangePage(SPELL_CLASS);
  else if(sLPage == "")
   dlgChangePage(STARTER_MENU);
  else
  {
    dlgChangePage(sLPage);
    dlgClearPlayerDataString("MD_LPage");
  }
  dlgDeactivateResetResponse();
}
void OnAbort(string sPage)
{
  CleanUp();
}
void OnEnd(string sPage)
{
  CleanUp();
}
void main()
{
  dlgOnMessage();
}

void CleanUp()
{
  dlgClearResponseList(FB_RESPONSES);
  dlgClearResponseList(STARTER_MENU);
  dlgClearResponseList(BODY_MENU);
  dlgClearResponseList(LEG_MENU);
  dlgClearResponseList(ARM_MENU);
  dlgClearResponseList(SHIELD_MENU);
  dlgClearResponseList(WEAPON_MENU);
  dlgClearResponseList(WEP_SUBMENU);
  dlgClearResponseList(PACK_MENU);
  dlgClearResponseList(TRAP_MENU);
  dlgClearResponseList(DIF_MENU);
  dlgClearResponseList(SAVE_MENU);
  dlgClearResponseList(SAVE_SUB);
  dlgClearPlayerDataString("MD_LPage");
  dlgClearPlayerDataInt("GS_TABLE_ID");
  dlgClearPlayerDataInt("GS_INVENTORY_SLOT");
  dlgClearPlayerDataInt("GS_TYPE");
  dlgClearPlayerDataInt("GS_INDEX");
  dlgClearPlayerDataString("MD_Component");
  dlgClearPlayerDataInt(MD_OUTS);
  dlgClearPlayerDataInt("X2_TAILOR_CURRENT_PART");
  dlgClearPlayerDataString(MD_SPELLBOOK);
  dlgClearResponseList(SPELL_MENU);
  dlgClearResponseList(SPELL_SUB);
  dlgClearResponseList(SPELL_CLASS);
  dlgDeactivateResetResponse();
}
void onBluePrompt(string sTxt = "[Select armor part]")
{
  dlgSetPrompt(txtBlue+sTxt+"</c>");
}

void onShield()
{
  dlgClearResponseList(SHIELD_MENU);
  object oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, dlgGetSpeakingPC());
  int nType = GetBaseItemType(oItem);
  if(GetIsObjectValid(oItem) && (nType == BASE_ITEM_LARGESHIELD  ||
     nType == BASE_ITEM_SMALLSHIELD || nType == BASE_ITEM_TOWERSHIELD))
  {
     onBluePrompt("Shield\nSelect Appearance:");
     dlgAddResponseAction(SHIELD_MENU, "Next");
     dlgAddResponseAction(SHIELD_MENU, "Previous");
  }
  else
    dlgSetPrompt("You do not currently have a shield equipped");
}

void onWeapon()
{
  dlgClearResponseList(WEAPON_MENU);
  object oPC = dlgGetSpeakingPC();
  object oW = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
  if (!GetIsObjectValid(oW) || !IPGetIsMeleeWeapon(oW)&& !IPGetIsRangedWeapon(oW))
    dlgSetPrompt("No weapon equipped in right hand");
  else if(IPGetIsIntelligentWeapon(oW))
    dlgSetPrompt("Intelligent weapon equipped and cannot be modified");
  else if(GetBaseItemType(oW) == BASE_ITEM_WHIP || GetBaseItemType(oW) == BASE_ITEM_SLING)
    dlgSetPrompt("Whips and slings cannot be modified, yet.");
  else
  {
    onBluePrompt("Weapon\nSelect Part:");
    CISetCurrentModBackup(oPC, oW);
    CISetCurrentModItem(oPC, oW);
    dlgAddResponseAction(WEAPON_MENU, "Change Top");
    dlgAddResponseAction(WEAPON_MENU, "Change Middle");
    dlgAddResponseAction(WEAPON_MENU, "Change Bottom");
  }
}

void onWepPart()
{
   int nPart = dlgGetPlayerDataInt("X2_TAILOR_CURRENT_PART");
   switch(nPart)
   {
   case ITEM_APPR_WEAPON_MODEL_TOP:
     onBluePrompt("Current Selection: " + GetStringByStrRef(84540));
     break;
   case ITEM_APPR_WEAPON_MODEL_MIDDLE:
     onBluePrompt("Current Selection: " + GetStringByStrRef(84541));
     break;
   case ITEM_APPR_WEAPON_MODEL_BOTTOM:
     onBluePrompt("Current Selection: " + GetStringByStrRef(84542));
     break;
   }
}
//Cuts down typing when adding traps
void AddTrapRes(string sTrap, string sComponent, object oPC)
{
  if(skillCTRAPGetHasComponent(sComponent, oPC, 1))
    dlgAddResponse(TRAP_MENU, sTrap + " trap");
}
void onTrap()
{
  dlgSetPrompt("Craft trap\n" +
               "Trap type: Resource needed\n" +
               txtRed + "Fire trap: Alchemist Fire</c>\n" +
               txtBlue + "Electrical trap: Quartz Crystal</c>\n" +
               txtMaroon + "Tangle trap: Tanglefoot Bag</c>\n" +
               txtOrange + "Speak trap: Caltrops</c>\n" +
               txtYellow + "Holy trap: Holy Water</c>\n" +
               txtGreen + "Gas trap: Choking Powder</c>\n" +
               txtAqua + "Frost trap: Coldstone</c>\n" +
               txtGrey + "Negative trap: Skeleton Knuckles</c>\n" +
               txtSilver + "Sonic trap: Thunderstone</c>\n" +
               txtGreen + "Acid trap: Acid Flask</c>\n" +
               "If there are no options below, you don't have the necessary components");

   object oPC = dlgGetSpeakingPC();
   dlgClearResponseList(TRAP_MENU);
   AddTrapRes("Fire", SKILL_CTRAP_FIRECOMPONENT, oPC);
   AddTrapRes("Electrical", SKILL_CTRAP_ELECTRICALCOMPONENT, oPC);
   AddTrapRes("Tangle", SKILL_CTRAP_TANGLECOMPONENT, oPC);
   AddTrapRes("Spike", SKILL_CTRAP_SPIKECOMPONENT, oPC);
   AddTrapRes("Holy", SKILL_CTRAP_HOLYCOMPONENT, oPC);
   AddTrapRes("Gas", SKILL_CTRAP_GASCOMPONENT, oPC);
   AddTrapRes("Frost", SKILL_CTRAP_FROSTCOMPONENT, oPC);
   AddTrapRes("Negative", SKILL_CTRAP_NEGATIVECOMPONENT, oPC);
   AddTrapRes("Sonic", SKILL_CTRAP_SONICCOMPONENT, oPC);
   AddTrapRes("Acid", SKILL_CTRAP_ACIDCOMPONENT, oPC);
}
void onDifficulty()
{
  dlgSetPrompt(dlgGetSelectionName() + "\n" + "Compenents required:\n" +
               "Minor: 1\nAverage: 3\nStrong: 5\nDeadly: 7");

  int nMinor;
  int nAvg;
  int nStrong;
  int nDeadly;

  int nFound = 0;
  object oPC = dlgGetSpeakingPC();
  object oItem = GetFirstItemInInventory(oPC);
  string sComp = dlgGetPlayerDataString("MD_Component");

  while (GetIsObjectValid(oItem) == TRUE)
  {
      if (GetTag(oItem) == sComp)
      {
          //nFound++;
          //SpeakString("here");
          nFound = nFound + GetNumStackedItems(oItem);
      }
      oItem = GetNextItemInInventory(oPC);
  }

  dlgClearResponseList(DIF_MENU);

  if(sComp == SKILL_CTRAP_FIRECOMPONENT || sComp == SKILL_CTRAP_ELECTRICALCOMPONENT)
  {
    nMinor = SKILLDC_TRAP_BASE_TYPE_MINOR_FIRE;
    nAvg = SKILLDC_TRAP_BASE_TYPE_AVERAGE_FIRE;
    nStrong = SKILLDC_TRAP_BASE_TYPE_STRONG_FIRE;
    nDeadly = SKILLDC_TRAP_BASE_TYPE_DEADLY_FIRE;
  }
  else if(sComp == SKILL_CTRAP_SPIKECOMPONENT)
  {
    nMinor = SKILLDC_TRAP_BASE_TYPE_MINOR_SPIKE;
    nAvg = SKILLDC_TRAP_BASE_TYPE_AVERAGE_SPIKE;
    nStrong = SKILLDC_TRAP_BASE_TYPE_STRONG_SPIKE;
    nDeadly = SKILLDC_TRAP_BASE_TYPE_DEADLY_SPIKE;
  }
  else if(sComp == SKILL_CTRAP_HOLYCOMPONENT || sComp == SKILL_CTRAP_TANGLECOMPONENT
         || sComp == SKILL_CTRAP_FROSTCOMPONENT
         || sComp == SKILL_CTRAP_NEGATIVECOMPONENT
         || sComp == SKILL_CTRAP_SONICCOMPONENT
         || sComp == SKILL_CTRAP_ACIDCOMPONENT)
  {
    nMinor = SKILLDC_TRAP_BASE_TYPE_MINOR_HOLY;
    nAvg = SKILLDC_TRAP_BASE_TYPE_AVERAGE_HOLY;
    nStrong = SKILLDC_TRAP_BASE_TYPE_STRONG_HOLY;
    nDeadly = SKILLDC_TRAP_BASE_TYPE_DEADLY_HOLY;
  }
  else if(sComp == SKILL_CTRAP_GASCOMPONENT)
  {
    nMinor = SKILLDC_TRAP_BASE_TYPE_MINOR_GAS;
    nAvg = SKILLDC_TRAP_BASE_TYPE_AVERAGE_GAS;
    nStrong = SKILLDC_TRAP_BASE_TYPE_STRONG_GAS;
    nDeadly = SKILLDC_TRAP_BASE_TYPE_DEADLY_GAS;
  }

  if(nFound >= 1) //minor
    dlgAddResponse(DIF_MENU, "DC: " + IntToString(nMinor) + " Minor trap");
  if(nFound >= 3) //Average
    dlgAddResponse(DIF_MENU, "DC: " + IntToString(nAvg) + " Average trap");
  if(nFound >= 5) //Strong
    dlgAddResponse(DIF_MENU, "DC: " + IntToString(nStrong) + " Strong trap");
  if(nFound >= 7) //deadly
    dlgAddResponse(DIF_MENU, "DC: " + IntToString(nDeadly) + " Deadly trap");
}

void onItem()
{
  object oPC         = dlgGetSpeakingPC();
  int nInventorySlot = dlgGetPlayerDataInt("GS_INVENTORY_SLOT");
  object oItem       = GetItemInSlot(nInventorySlot, oPC);
  int nTableID       = dlgGetPlayerDataInt("GS_TABLE_ID");
  int nType          = dlgGetPlayerDataInt("GS_TYPE");
  int nIndex         = dlgGetPlayerDataInt("GS_INDEX");
  int nLimit         = gsIPGetCount(nTableID);
  int nNth           = 0;
  int nLMod          = 0;  //stores  the last model
  string sCurApr     = "You do not currently have the item equipped";

  //The last model also happens to be the current model when the menu is first accessed
  //and when next and previous page is used.
  int nModelNum      = GetItemAppearance(oItem, nType, nIndex); //keep the current appearance
  dlgClearResponseList(FB_RESPONSES);
  if(GetIsObjectValid(oItem))
  {
    for(; nNth < nLimit; nNth++)
    {
    //This sets the dialog value, if it's not the torso piece OR it's the torso piece of the same AC value
      if((nIndex != ITEM_APPR_ARMOR_MODEL_TORSO ||
         gsIPGetAppearanceAC(nTableID, GetItemAppearance(oItem, nType, nIndex)) ==
         gsIPGetValue(nTableID, nNth, "AC")))
           dlgAddResponse(FB_RESPONSES, "Form_" + IntToString(nNth));
    /*  else //set the dialog, only as red, if object isn't valid
        dlgAddResponse(FB_RESPONSES, txtRed + "Form_" + IntToString(nNth) + "</c>");*/

      //Get the table value that matches the model value
      if(gsIPGetValue(nTableID, nNth, "ID") == nModelNum)
        nLMod = nNth;
    }
    sCurApr = "Last Appearance: " + IntToString(nLMod) + "\n" + txtBlue + "[Select Form]</c>";
  }



  switch (nInventorySlot)
  {
  case INVENTORY_SLOT_CHEST:
    switch (nIndex)
    {
      case ITEM_APPR_ARMOR_MODEL_BELT:
        dlgSetPrompt(GS_T_16777244 + "\n" + sCurApr);
        break;

      case ITEM_APPR_ARMOR_MODEL_LBICEP:
        dlgSetPrompt(GS_T_16777245 + "\n" + sCurApr);
        break;

      case ITEM_APPR_ARMOR_MODEL_LFOOT:
        dlgSetPrompt(GS_T_16777246 + "\n" + sCurApr);
        break;

      case ITEM_APPR_ARMOR_MODEL_LFOREARM:
        dlgSetPrompt(GS_T_16777247 + "\n" + sCurApr);
        break;

      case ITEM_APPR_ARMOR_MODEL_LHAND:
        dlgSetPrompt(GS_T_16777248 + "\n" + sCurApr);
        break;

      case ITEM_APPR_ARMOR_MODEL_LSHIN:
        dlgSetPrompt(GS_T_16777249 + "\n" + sCurApr);
        break;

      case ITEM_APPR_ARMOR_MODEL_LSHOULDER:
        dlgSetPrompt(GS_T_16777250 + "\n" + sCurApr);
        break;

      case ITEM_APPR_ARMOR_MODEL_LTHIGH:
        dlgSetPrompt(GS_T_16777251 + "\n" + sCurApr);
        break;

      case ITEM_APPR_ARMOR_MODEL_NECK:
        dlgSetPrompt(GS_T_16777252 + "\n" + sCurApr);
        break;

      case ITEM_APPR_ARMOR_MODEL_PELVIS:
        dlgSetPrompt(GS_T_16777253 + "\n" + sCurApr);
        break;

      case ITEM_APPR_ARMOR_MODEL_RBICEP:
        dlgSetPrompt(GS_T_16777254 + "\n" + sCurApr);
        break;

      case ITEM_APPR_ARMOR_MODEL_RFOOT:
        dlgSetPrompt(GS_T_16777255 + "\n" + sCurApr);
        break;

      case ITEM_APPR_ARMOR_MODEL_RFOREARM:
        dlgSetPrompt(GS_T_16777256 + "\n" + sCurApr);
        break;

      case ITEM_APPR_ARMOR_MODEL_RHAND:
        dlgSetPrompt(GS_T_16777257 + "\n" + sCurApr);
        break;

      case ITEM_APPR_ARMOR_MODEL_ROBE:
        dlgSetPrompt(GS_T_16777258 + "\n" + sCurApr);
        break;

      case ITEM_APPR_ARMOR_MODEL_RSHIN:
       dlgSetPrompt(GS_T_16777259 + "\n" + sCurApr);
       break;

      case ITEM_APPR_ARMOR_MODEL_RSHOULDER:
        dlgSetPrompt(GS_T_16777260 + "\n" + sCurApr);
        break;

      case ITEM_APPR_ARMOR_MODEL_RTHIGH:
        dlgSetPrompt(GS_T_16777261 + "\n" + sCurApr);
        break;

      case ITEM_APPR_ARMOR_MODEL_TORSO:
        dlgSetPrompt(GS_T_16777262 + "\n" + sCurApr);
        break;
    }
    break;

  case INVENTORY_SLOT_CLOAK:
    dlgSetPrompt(GS_T_16777507 + "\n" + sCurApr);
    break;

  case INVENTORY_SLOT_HEAD:
    dlgSetPrompt(GS_T_16777508 + "\n" + sCurApr);
    break;

/*  case INVENTORY_SLOT_LEFTHAND:
    dlgSetPrompt(GS_T_16777248 + "\n" + sCurApr);
    break;  */
  }


}

//gets the value for each individual piece, Model numbers may be different from Form_XX numbers
//so we get them this way.
int MD_GetIndividualPieceValue(int nIndex, object oItem)
{
  int nNth;
  int nTableID = gsIPGetAppearanceTableID(nIndex);
  int nModelNum = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, nIndex);
  int nLimit = gsIPGetCount(nTableID);
  for(nNth = 0; nNth < nLimit; nNth++)
  {
    //Get the table value that matches the model value
    if(gsIPGetValue(nTableID, nNth, "ID") == nModelNum)
      return nNth;
  }

  return -1;
}

void onSave()
{
   dlgClearResponseList(SAVE_MENU);
   object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, dlgGetSpeakingPC());
   if(GetIsObjectValid(oItem))
   {
     dlgSetPrompt("Current outfit:\n" +
                 "Neck: " + IntToString(MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_NECK, oItem)) + "\n" +
                 "Torso: " + IntToString(MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_TORSO, oItem)) + "\n" +
                 "Belt: " + IntToString(MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_BELT, oItem)) + "\n" +
                 "Pelvis: " + IntToString(MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_PELVIS, oItem)) + "\n" +
                 "Robe: " + IntToString(MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_ROBE, oItem)) + "\n" +
                 "Right Thigh: " +  IntToString(MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_RTHIGH, oItem)) + "\n" +
                 "Left Thigh: " + IntToString(MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_LTHIGH, oItem)) + "\n" +
                 "Right Shin: " + IntToString(MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_RSHIN, oItem)) + "\n" +
                 "Left Shin: " + IntToString(MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_LSHIN, oItem)) + "\n" +
                 "Right Foot: " + IntToString(MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_RFOOT, oItem)) + "\n" +
                 "Left Foot: " + IntToString(MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_LFOOT, oItem)) + "\n" +
                 "Right Shoulder: " + IntToString(MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_RSHOULDER, oItem)) + "\n" +
                 "Left Shoulder: " + IntToString(MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_LSHOULDER, oItem)) + "\n" +
                 "Right Bicep: " + IntToString(MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_RBICEP, oItem)) + "\n" +
                 "Left Bicep: " + IntToString(MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_LBICEP, oItem)) + "\n" +
                 "Right Forearm: " + IntToString(MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_RFOREARM, oItem)) + "\n" +
                 "Left Forearm: " + IntToString(MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_LFOREARM, oItem)) + "\n" +
                 "Right Hand: " + IntToString(MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_RHAND, oItem)) + "\n" +
                 "Left Hand: " + IntToString(MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_LHAND, oItem)) + "\n" +
                 "Cloth 1: " + IntToString(GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH1)) + "\n" +
                 "Cloth 2: " + IntToString(GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH2)) + "\n" +
                 "Leather 1: " + IntToString(GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER1)) + "\n" +
                 "Leather 2: " + IntToString(GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER2)) + "\n" +
                 "Metal 1: " + IntToString(GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL1)) + "\n" +
                 "Metal 2: " + IntToString(GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL2)));

    dlgAddResponse(SAVE_MENU, "Save 1");
    dlgAddResponse(SAVE_MENU, "Save 2");
    dlgAddResponse(SAVE_MENU, "Save 3");
    dlgAddResponse(SAVE_MENU, "Save 4");
    dlgAddResponse(SAVE_MENU, "Save 5");
    dlgAddResponse(SAVE_MENU, "Save 6");
    dlgAddResponse(SAVE_MENU, "Save 7");
    dlgAddResponse(SAVE_MENU, "Save 8");
    dlgAddResponse(SAVE_MENU, "Save 9");
    dlgAddResponse(SAVE_MENU, "Save 10");
    dlgAddResponse(SAVE_MENU, "Save 11");
    dlgAddResponse(SAVE_MENU, "Save 12");
  }	
  else
    dlgSetPrompt("You have no outfit equipped");

  dlgAddResponse(SAVE_MENU, "List outfits");
}

void onSaveSub()
{
 dlgClearResponseList(SAVE_SUB);
 string sPrompt = "";
 object oPC = dlgGetSpeakingPC();
 object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
 string sVar = MD_OUTS + IntToString(dlgGetPlayerDataInt(MD_OUTS));
 //We have a save
 if(GetLocalInt(oSkin, sVar))
 {
   int nTorso = GetLocalInt(oSkin, sVar + "T");
   sPrompt =     "Saved outfit:\n" +
                 "Neck: " + IntToString(GetLocalInt(oSkin, sVar + "N")) + "\n" +
                 "Torso: " + IntToString(nTorso) + "\n" +
                 "Belt: " + IntToString(GetLocalInt(oSkin, sVar + "B")) + "\n" +
                 "Pelvis: " + IntToString(GetLocalInt(oSkin, sVar + "P")) + "\n" +
                 "Robe: " + IntToString(GetLocalInt(oSkin, sVar + "R")) + "\n" +
                 "Right Thigh: " + IntToString(GetLocalInt(oSkin, sVar + "RT")) + "\n" +
                 "Left Thigh: " + IntToString(GetLocalInt(oSkin, sVar + "LT")) + "\n" +
                 "Right Shin: " + IntToString(GetLocalInt(oSkin, sVar + "RS")) + "\n" +
                 "Left Shin: " + IntToString(GetLocalInt(oSkin, sVar + "LS")) + "\n" +
                 "Right Foot: " + IntToString(GetLocalInt(oSkin, sVar + "RFT")) + "\n" +
                 "Left Foot: " + IntToString(GetLocalInt(oSkin, sVar + "LFT")) + "\n" +
                 "Right Shoulder: " + IntToString(GetLocalInt(oSkin, sVar + "RSO")) + "\n" +
                 "Left Shoulder: " + IntToString(GetLocalInt(oSkin, sVar + "LSO")) + "\n" +
                 "Right Bicep: " + IntToString(GetLocalInt(oSkin, sVar + "RB")) + "\n" +
                 "Left Bicep: " + IntToString(GetLocalInt(oSkin, sVar + "LB")) + "\n" +
                 "Right Forearm: " + IntToString(GetLocalInt(oSkin, sVar + "RF")) + "\n" +
                 "Left Forearm: " + IntToString(GetLocalInt(oSkin, sVar + "LF")) + "\n" +
                 "Right Hand: " + IntToString(GetLocalInt(oSkin, sVar + "RH")) + "\n" +
                 "Left Hand: " + IntToString(GetLocalInt(oSkin, sVar + "LH")) + "\n" +
                 "Cloth 1: " + IntToString(GetLocalInt(oSkin, sVar + "C1")) + "\n" +
                 "Cloth 2: " + IntToString(GetLocalInt(oSkin, sVar + "C2")) + "\n" +
                 "Leather 1: " + IntToString(GetLocalInt(oSkin, sVar + "L1")) + "\n" +
                 "Leather 2: " + IntToString(GetLocalInt(oSkin, sVar + "L2")) + "\n" +
                 "Metal 1: " + IntToString(GetLocalInt(oSkin, sVar + "M1")) + "\n" +
                 "Metal 2: " + IntToString(GetLocalInt(oSkin, sVar + "M2"));

   int nTableID = gsIPGetAppearanceTableID(ITEM_APPR_ARMOR_MODEL_TORSO);
   if(gsIPGetAppearanceAC(nTableID, GetItemAppearance(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC), ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO)) ==
      gsIPGetValue(nTableID, nTorso, "AC"))
     dlgAddResponse(SAVE_SUB, "Change current outfit worn to save");
   else
     sPrompt += "\nYou cannot currently change outfit due to mismatched AC types";
 }
 else
   sPrompt = "You have no saved outfit.";

 dlgAddResponse(SAVE_SUB, "Save current outfit");
 dlgSetPrompt(sPrompt);
}

void onSHelm()
{
    object player = dlgGetSpeakingPC();
    object helm = GetItemInSlot(INVENTORY_SLOT_HEAD, player);

    if (helm != OBJECT_INVALID)
    {
        SetHiddenWhenEquipped(helm, !GetHiddenWhenEquipped(helm));
    }
}

void onSItem(int nInventorySlot, int nType, int nIndex, int nTable)
{
  dlgSetPlayerDataInt("GS_TABLE_ID", nTable);
  dlgSetPlayerDataInt("GS_INVENTORY_SLOT", nInventorySlot);
  dlgSetPlayerDataInt("GS_TYPE", nType);
  dlgSetPlayerDataInt("GS_INDEX", nIndex);
  dlgChangePage(FB_RESPONSES);
}

void onSArmor(int nIndex)
{
  onSItem(INVENTORY_SLOT_CHEST, ITEM_APPR_TYPE_ARMOR_MODEL, nIndex, gsIPGetAppearanceTableID(nIndex));
}
//Modifies the item, used in onSForm.
void MD_ModifyItem(int nNth, object oItem, int nIndex, int nInventorySlot, object oPC, int nTableID, int nType)
{

  int nValue       = gsIPGetValue(nTableID, nNth, "ID");
  object oCopy     = gsCMCopyItemAndModify(oItem, nType, nIndex, nValue, TRUE);

  if (GetIsObjectValid(oCopy))
  {
    AssignCommand(oPC, ActionEquipItem(oCopy, nInventorySlot));
    DestroyObject(oItem);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
      EffectVisualEffect(VFX_DUR_CESSATE_NEUTRAL),
      oPC,
      0.25);
   }
}

void onSForm()
{
  object oPC         = dlgGetSpeakingPC();
  int nInventorySlot = dlgGetPlayerDataInt("GS_INVENTORY_SLOT");
  object oItem       = GetItemInSlot(nInventorySlot, oPC);

  if (GetIsObjectValid(oItem))
  {
    int nTableID     = dlgGetPlayerDataInt("GS_TABLE_ID");
    int nType        = dlgGetPlayerDataInt("GS_TYPE");
    int nIndex       = dlgGetPlayerDataInt("GS_INDEX");
    //item isn't a torso, the usual method for selection works
    if (nIndex != ITEM_APPR_ARMOR_MODEL_TORSO)
    {
      MD_ModifyItem(dlgGetSelectionIndex(), oItem, nIndex, nInventorySlot, oPC, nTableID, nType);
      return; //exit out early if succesful
    }
    //Get nNth this way if torso. "Form_" Number start at 5
    string sName = dlgGetSelectionName();
    int nNth = StringToInt(GetSubString(sName, 5, GetStringLength(sName) - 5));
    if(gsIPGetAppearanceAC(nTableID, GetItemAppearance(oItem, nType, nIndex)) ==
            gsIPGetValue(nTableID, nNth, "AC"))
    {
      MD_ModifyItem(nNth, oItem, nIndex, nInventorySlot, oPC, nTableID, nType);
    }
  }

}

void onSNShield()
{
  object oPC = dlgGetSpeakingPC();
  object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
  int nShieldType = GetBaseItemType(oShield);
  int nAppearance = GetItemAppearance(oShield, ITEM_APPR_TYPE_SIMPLE_MODEL, 0);

  switch (nShieldType)
  {
    case BASE_ITEM_LARGESHIELD:
      switch (nAppearance)
      {
        case 13:
          nAppearance = 21;
          break;
        case 23:
          nAppearance = 31;
          break;
        case 33:
          nAppearance = 41;
          break;
        case 43:
          nAppearance = 51;
          break;
        case 56:
          nAppearance = 61;
          break;
        case 75:
          nAppearance = 11; // loop.
          break;
        default:
          nAppearance++;
          break;
      }
      break;
    case BASE_ITEM_SMALLSHIELD:
      switch (nAppearance)
      {
        case 13:
          nAppearance = 21;
          break;
        case 23:
          nAppearance = 31;
          break;
        case 33:
          nAppearance = 41;
          break;
        case 43:
          nAppearance = 11;  // loop
          break;
        default:
          nAppearance++;
          break;
      }
      break;
    case BASE_ITEM_TOWERSHIELD:
      switch (nAppearance)
      {
        case 13:
          nAppearance = 21;
          break;
        case 23:
          nAppearance = 31;
          break;
        case 33:
          nAppearance = 41;
          break;
        case 43:
          nAppearance = 51;
          break;
        case 54:
          nAppearance = 11;  // loop
          break;
        default:
          nAppearance++;
          break;
      }
      break;
    default:
      return;
  }

  object oNew = gsCMCopyItemAndModify(oShield, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, nAppearance, TRUE);

  if (GetIsObjectValid(oNew))
  {
    AssignCommand(oPC, ActionEquipItem(oNew, INVENTORY_SLOT_LEFTHAND));
    DestroyObject (oShield);
  }
}

void onSPShield()
{
  object oPC = dlgGetSpeakingPC();
  object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
  int nShieldType = GetBaseItemType(oShield);
  int nAppearance = GetItemAppearance(oShield, ITEM_APPR_TYPE_SIMPLE_MODEL, 0);

  switch (nShieldType)
  {
    case BASE_ITEM_LARGESHIELD:
      switch (nAppearance)
      {
        case 11:
          nAppearance = 75; // loop
          break;
        case 21:
          nAppearance = 13;
          break;
        case 31:
          nAppearance = 23;
          break;
        case 41:
          nAppearance = 33;
          break;
        case 51:
          nAppearance = 41;
          break;
        case 61:
          nAppearance = 56;
          break;
        default:
          nAppearance--;
          break;
      }
      break;
    case BASE_ITEM_SMALLSHIELD:
      switch (nAppearance)
      {
        case 11:
          nAppearance = 43;  // loop
          break;
        case 21:
          nAppearance = 13;
          break;
        case 31:
          nAppearance = 23;
          break;
        case 41:
          nAppearance = 33;
          break;
        default:
          nAppearance--;
          break;
      }
      break;
    case BASE_ITEM_TOWERSHIELD:
      switch (nAppearance)
      {
        case 11:
          nAppearance = 54;  // loop
          break;
        case 21:
          nAppearance = 13;
          break;
        case 31:
          nAppearance = 23;
          break;
        case 41:
          nAppearance = 33;
          break;
        case 51:
          nAppearance = 43;
          break;
        default:
          nAppearance--;
          break;
      }
      break;
    default:
      return;
  }

  object oNew = gsCMCopyItemAndModify(oShield, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, nAppearance, TRUE);

  if (GetIsObjectValid(oNew))
  {
    AssignCommand(oPC, ActionEquipItem(oNew, INVENTORY_SLOT_LEFTHAND));
    DestroyObject (oShield);
  }
}

void onSWepPart(int nPart)
{
  dlgSetPlayerDataInt("X2_TAILOR_CURRENT_PART",nPart);

  dlgChangePage(WEP_SUBMENU);
}

void onSWeaponS(int nDest)
{
  object oPC = dlgGetSpeakingPC();
  int nPart =  dlgGetPlayerDataInt("X2_TAILOR_CURRENT_PART");
  object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

  int nCurrentAppearance;

  if(GetIsObjectValid(oItem) == TRUE)
  {
    object oNew;
    AssignCommand(oPC,ClearAllActions(TRUE));
    oNew = IPGetModifiedWeapon(oItem, nPart, nDest, TRUE);
    AssignCommand(oPC, ActionEquipItem(oNew, INVENTORY_SLOT_RIGHTHAND));
  }
}

void onSNWeaponC()
{
  object oPC = dlgGetSpeakingPC();
  int nPart =  dlgGetPlayerDataInt("X2_TAILOR_CURRENT_PART");
  object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

  if(GetIsObjectValid(oItem) == TRUE)
  {
      object oNew;
      AssignCommand(oPC,ClearAllActions(TRUE));
      int nColour = GetLocalInt(oItem, "MI_WPN_CURRENT_COLOUR");

      if (nColour == 4)
      {
        nColour = 1;
      }
      else
      {
        nColour++;
      }

      oNew = gsCMCopyItemAndModify(oItem,
                                   ITEM_APPR_TYPE_WEAPON_COLOR,
                                   nPart,
                                   nColour,
                                   TRUE);
      if (oNew != OBJECT_INVALID)
      {
        DestroyObject(oItem);
        AssignCommand(oPC, ActionEquipItem(oNew, INVENTORY_SLOT_RIGHTHAND));
        SetLocalInt(oNew, "MI_WPN_CURRENT_COLOUR", nColour);
      }
  }
}

void onSPWeaponC()
{

  object oPC = dlgGetSpeakingPC();
  int nPart =  dlgGetPlayerDataInt("X2_TAILOR_CURRENT_PART");
  object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

  if(GetIsObjectValid(oItem) == TRUE)
  {
      object oNew;
      AssignCommand(oPC,ClearAllActions(TRUE));
      int nColour = GetLocalInt(oItem, "MI_WPN_CURRENT_COLOUR");

      if (nColour == 0 || nColour == 1)
      {
        nColour = 4;
      }
      else
      {
        nColour--;
      }

      oNew = gsCMCopyItemAndModify(oItem,
                                   ITEM_APPR_TYPE_WEAPON_COLOR,
                                   nPart,
                                   nColour,
                                   TRUE);
      if (oNew != OBJECT_INVALID)
      {
        DestroyObject(oItem);
        AssignCommand(oPC, ActionEquipItem(oNew, INVENTORY_SLOT_RIGHTHAND));
        SetLocalInt(oNew, "MI_WPN_CURRENT_COLOUR", nColour);
      }
   }
}

void onSNPack()
{
  object oPC = dlgGetSpeakingPC();
  int nWingType = GetCreatureWingType(oPC);

  if (nWingType != 0 && nWingType < 79)
  {
    FloatingTextStringOnCreature("Winged creatures can't wear a backpack.  " +
     "Their wings get in the way.", oPC);
    return;
  }

  switch (nWingType)
  {
    case 0:
      nWingType = 79;
      break;
    case 89:
      nWingType = 0; // loop
      break;
    default:
      nWingType ++;
      break;
  }

  SetCreatureWingType(nWingType, oPC);
}

void onSPPack()
{
  object oPC = dlgGetSpeakingPC();
  int nWingType = GetCreatureWingType(oPC);

  if (nWingType != 0 && nWingType < 79)
  {
    FloatingTextStringOnCreature("Winged creatures can't wear a backpack.  " +
     "Their wings get in the way.", oPC);
    return;
  }

  switch (nWingType)
  {
    case 0:
      nWingType = 89; // loop
      break;
    case 79:
      nWingType = 0;
      break;
    default:
      nWingType --;
      break;
  }

  SetCreatureWingType(nWingType, oPC);
}

void onSPackTog()
{
  object oPC = dlgGetSpeakingPC();
  int nWingType = GetCreatureWingType(oPC);

  if (nWingType != 0 && nWingType < 79)
  {
    FloatingTextStringOnCreature("Winged creatures can't wear a backpack.  " +
     "Their wings get in the way.", oPC);
    return;
  }

  switch (nWingType)
  {
    case 0:
      nWingType = GetLocalInt(GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC), "BACKPACK");
      break;
    default:
      SetLocalInt(GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC), "BACKPACK", nWingType);
      nWingType = 0;
      break;
  }

  SetCreatureWingType(nWingType, oPC);
}

void onSTrap()
{
  string sSel = dlgGetSelectionName();
  if(sSel == "Fire trap")
    dlgSetPlayerDataString("MD_Component", SKILL_CTRAP_FIRECOMPONENT);
  else if(sSel == "Electrical trap")
    dlgSetPlayerDataString("MD_Component", SKILL_CTRAP_ELECTRICALCOMPONENT);
  else if(sSel == "Acid trap")
    dlgSetPlayerDataString("MD_Component", SKILL_CTRAP_ACIDCOMPONENT);
  else if(sSel == "Frost trap")
    dlgSetPlayerDataString("MD_Component", SKILL_CTRAP_FROSTCOMPONENT);
  else if(sSel == "Gas trap")
    dlgSetPlayerDataString("MD_Component", SKILL_CTRAP_GASCOMPONENT);
  else if(sSel == "Holy trap")
    dlgSetPlayerDataString("MD_Component", SKILL_CTRAP_HOLYCOMPONENT);
  else if(sSel == "Negative trap")
    dlgSetPlayerDataString("MD_Component", SKILL_CTRAP_NEGATIVECOMPONENT);
  else if(sSel == "Sonic trap")
    dlgSetPlayerDataString("MD_Component", SKILL_CTRAP_SONICCOMPONENT);
  else if(sSel == "Tangle trap")
    dlgSetPlayerDataString("MD_Component", SKILL_CTRAP_TANGLECOMPONENT);
  else if(sSel == "Spike trap")
    dlgSetPlayerDataString("MD_Component", SKILL_CTRAP_SPIKECOMPONENT);

  dlgChangePage(DIF_MENU);
}

void onSDif()
{
  object oPC = dlgGetSpeakingPC();
  string sSel = dlgGetSelectionName();
  string sTrapKit = "";

  string sComponent = dlgGetPlayerDataString("MD_Component");
  int nTrapDifficulty = SKILL_TRAP_MINOR;

  if(FindSubString(sSel, "Average") > -1)
    nTrapDifficulty = SKILL_TRAP_AVERAGE;
  else if(FindSubString(sSel, "Strong") > -1)
    nTrapDifficulty = SKILL_TRAP_STRONG;
  else if(FindSubString(sSel, "Deadly") > -1)
    nTrapDifficulty = SKILL_TRAP_DEADLY;

  //Recheck here because the items aren't deleted until after the page
  //comes back up.
  if(skillCTRAPGetHasComponent(sComponent, oPC, nTrapDifficulty))
    skillCTRAPCreateTrapKit(sComponent, oPC, nTrapDifficulty);
  else
    FloatingTextStringOnCreature("Option unavailable due to lack of components", oPC, FALSE);

}
//CopyItemAndMod used for SSub
object MD_CopyItemModel(object oCopy, int nIndex, int nValue)
{
  object oNew = gsCMCopyItemAndModify(oCopy, ITEM_APPR_TYPE_ARMOR_MODEL, nIndex, gsIPGetValue(gsIPGetAppearanceTableID(nIndex), nValue, "ID"), TRUE);
  DestroyObject(oCopy);
  return oNew;
}
object MD_CopyItemColor(object oCopy, int nIndex, int nValue)
{
  object oNew = gsCMCopyItemAndModify(oCopy, ITEM_APPR_TYPE_ARMOR_COLOR, nIndex, nValue, TRUE);
  DestroyObject(oCopy);
  return oNew;
}
void onSSub()
{

  object oPC = dlgGetSpeakingPC();
  object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
  if(!GetIsObjectValid(oItem)) return;
  string sSel = dlgGetSelectionName();
  object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
  string sVar = MD_OUTS + IntToString(dlgGetPlayerDataInt(MD_OUTS));
  if(sSel == "Save current outfit")
  {
    SetLocalInt(oSkin, sVar, 1);
    SetLocalInt(oSkin, sVar + "N", MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_NECK, oItem));
    SetLocalInt(oSkin, sVar + "T", MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_TORSO, oItem));
    SetLocalInt(oSkin, sVar + "B", MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_BELT, oItem));
    SetLocalInt(oSkin, sVar + "P", MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_PELVIS, oItem));
    SetLocalInt(oSkin, sVar + "R", MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_ROBE, oItem));
    SetLocalInt(oSkin, sVar + "RT", MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_RTHIGH, oItem));
    SetLocalInt(oSkin, sVar + "LT", MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_LTHIGH, oItem));
    SetLocalInt(oSkin, sVar + "RS", MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_RSHIN, oItem));
    SetLocalInt(oSkin, sVar + "LS", MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_LSHIN, oItem));
    SetLocalInt(oSkin, sVar + "RFT", MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_RFOOT, oItem));
    SetLocalInt(oSkin, sVar + "LFT", MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_LFOOT, oItem));
    SetLocalInt(oSkin, sVar + "RSO", MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_RSHOULDER, oItem));
    SetLocalInt(oSkin, sVar + "LSO", MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_LSHOULDER, oItem));
    SetLocalInt(oSkin, sVar + "RB", MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_RBICEP, oItem));
    SetLocalInt(oSkin, sVar + "LB", MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_LBICEP, oItem));
    SetLocalInt(oSkin, sVar + "RF", MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_RFOREARM, oItem));
    SetLocalInt(oSkin, sVar + "LF", MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_LFOREARM, oItem));
    SetLocalInt(oSkin, sVar + "RH", MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_RHAND, oItem));
    SetLocalInt(oSkin, sVar + "LH", MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_LHAND, oItem));
    SetLocalInt(oSkin, sVar + "C1", GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH1));
    SetLocalInt(oSkin, sVar + "C2", GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH2));
    SetLocalInt(oSkin, sVar + "L1", GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER1));
    SetLocalInt(oSkin, sVar + "L2", GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER2));
    SetLocalInt(oSkin, sVar + "M1", GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL1));
    SetLocalInt(oSkin, sVar + "M2", GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL2));
  }
  else //change the outfit
  {
    object oHelper = GetObjectByTag("MD_outhelp");
    if(!GetIsObjectValid(oHelper)) return;

    int nTableID = gsIPGetAppearanceTableID(ITEM_APPR_ARMOR_MODEL_TORSO);
    int nTorso = GetLocalInt(oSkin, sVar + "T");
    if(gsIPGetAppearanceAC(nTableID, GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO)) !=
      gsIPGetValue(nTableID, nTorso, "AC"))
      {
        FloatingTextStringOnCreature("AC on current outfit and saved outfit are mismatched.", oPC, FALSE);
        return;
      }


    string sDescription = GetDescription(oItem);
    int nDroppable = GetDroppableFlag(oItem);
    object oCopy = CopyItem(oItem, oHelper, TRUE);
    oCopy = MD_CopyItemModel(oCopy, ITEM_APPR_ARMOR_MODEL_NECK, GetLocalInt(oSkin, sVar + "N"));
    oCopy = MD_CopyItemModel(oCopy, ITEM_APPR_ARMOR_MODEL_TORSO, nTorso);
    oCopy = MD_CopyItemModel(oCopy, ITEM_APPR_ARMOR_MODEL_BELT, GetLocalInt(oSkin, sVar + "B"));
    oCopy = MD_CopyItemModel(oCopy, ITEM_APPR_ARMOR_MODEL_PELVIS, GetLocalInt(oSkin, sVar + "P"));
    oCopy = MD_CopyItemModel(oCopy, ITEM_APPR_ARMOR_MODEL_ROBE, GetLocalInt(oSkin, sVar + "R"));
    oCopy = MD_CopyItemModel(oCopy, ITEM_APPR_ARMOR_MODEL_RTHIGH, GetLocalInt(oSkin, sVar + "RT"));
    oCopy = MD_CopyItemModel(oCopy, ITEM_APPR_ARMOR_MODEL_LTHIGH, GetLocalInt(oSkin, sVar + "LT"));
    oCopy = MD_CopyItemModel(oCopy, ITEM_APPR_ARMOR_MODEL_RSHIN, GetLocalInt(oSkin, sVar + "RS"));
    oCopy = MD_CopyItemModel(oCopy, ITEM_APPR_ARMOR_MODEL_LSHIN, GetLocalInt(oSkin, sVar + "LS"));
    oCopy = MD_CopyItemModel(oCopy, ITEM_APPR_ARMOR_MODEL_RFOREARM, GetLocalInt(oSkin, sVar + "RF"));
    oCopy = MD_CopyItemModel(oCopy, ITEM_APPR_ARMOR_MODEL_LFOREARM, GetLocalInt(oSkin, sVar + "LF"));
    oCopy = MD_CopyItemModel(oCopy, ITEM_APPR_ARMOR_MODEL_RSHOULDER, GetLocalInt(oSkin, sVar + "RSO"));
    oCopy = MD_CopyItemModel(oCopy, ITEM_APPR_ARMOR_MODEL_LSHOULDER, GetLocalInt(oSkin, sVar + "LSO"));
    oCopy = MD_CopyItemModel(oCopy, ITEM_APPR_ARMOR_MODEL_RBICEP, GetLocalInt(oSkin, sVar + "RB"));
    oCopy = MD_CopyItemModel(oCopy, ITEM_APPR_ARMOR_MODEL_LBICEP, GetLocalInt(oSkin, sVar + "LB"));
    oCopy = MD_CopyItemModel(oCopy, ITEM_APPR_ARMOR_MODEL_RFOOT, GetLocalInt(oSkin, sVar + "RFT"));
    oCopy = MD_CopyItemModel(oCopy, ITEM_APPR_ARMOR_MODEL_LFOOT, GetLocalInt(oSkin, sVar + "LFT"));
    oCopy = MD_CopyItemModel(oCopy, ITEM_APPR_ARMOR_MODEL_RHAND, GetLocalInt(oSkin, sVar + "RH"));
    oCopy = MD_CopyItemModel(oCopy, ITEM_APPR_ARMOR_MODEL_LHAND, GetLocalInt(oSkin, sVar + "LH"));
    oCopy = MD_CopyItemColor(oCopy, ITEM_APPR_ARMOR_COLOR_CLOTH1, GetLocalInt(oSkin, sVar + "C1"));
    oCopy = MD_CopyItemColor(oCopy, ITEM_APPR_ARMOR_COLOR_CLOTH2, GetLocalInt(oSkin, sVar + "C2"));
    oCopy = MD_CopyItemColor(oCopy, ITEM_APPR_ARMOR_COLOR_LEATHER1, GetLocalInt(oSkin, sVar + "L1"));
    oCopy = MD_CopyItemColor(oCopy, ITEM_APPR_ARMOR_COLOR_LEATHER2, GetLocalInt(oSkin, sVar + "L2"));
    oCopy = MD_CopyItemColor(oCopy, ITEM_APPR_ARMOR_COLOR_METAL1, GetLocalInt(oSkin, sVar + "M1"));
    oCopy = MD_CopyItemColor(oCopy, ITEM_APPR_ARMOR_COLOR_METAL2, GetLocalInt(oSkin, sVar + "M2"));

    object oNew = CopyItem(oCopy, oPC, TRUE);
    DestroyObject(oCopy);

    if (GetIsObjectValid(oNew))
    {
      SetDescription(oNew, sDescription);
      SetDroppableFlag(oNew, nDroppable);
      AssignCommand(oPC, ActionEquipItem(oNew, INVENTORY_SLOT_CHEST));
      DestroyObject(oItem);

      ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
        EffectVisualEffect(VFX_DUR_CESSATE_NEUTRAL),
        oPC,
        0.25);
    }
  }
}
void onSSpell(int nSel)
{

  object oPC = dlgGetSpeakingPC();
  int nClass = dlgGetPlayerDataInt(MD_CLASS);
  object oHide = gsPCGetCreatureHide(oPC);
  //Get the whole string
  string sOVar =  GetLocalString(oHide, MD_SPELLBOOK);
  //Get the string for the individual class
  string sClass = IntToString(nClass)+"C";
  int nStartC = FindSubString(sOVar, sClass);
  int nEndC = -1;
  int nStartS = -1;
  int nEndS = -1;
  string sSlot = dlgGetPlayerDataString(MD_SPELLBOOK)+"S";
  if(nStartC > -1)
  {
    nEndC = FindSubString(sOVar, "_", nStartC);
    sClass = GetSubString(sOVar, nStartC, nEndC-nStartC);
    //Get the values for the individual save too.
    nStartS = FindSubString(sClass, sSlot);
    nEndS = FindSubString(sClass, "*", nStartS);
  }

  string sVar;
  struct NWNX_Creature_MemorisedSpell mss;
  int nSpellLevel;
  int nIndex;


  if(nSel == 0)
  {

    for(nSpellLevel = 0; nSpellLevel <= 9; nSpellLevel++)
    {
      mss = NWNX_Creature_GetMemorisedSpell(oPC, nClass, nSpellLevel, 0);
      sVar += IntToString(nSpellLevel) + ":";
      while(mss.id != -1)
      {
        sVar += IntToString(mss.id) + ";";
        if(mss.domain == 1)
            sVar += "O";
        if(mss.meta > 0)
          sVar += "M" + IntToString(mss.meta);

        sVar += "|"; //end spell index string
        mss = NWNX_Creature_GetMemorisedSpell(oPC, nClass, nSpellLevel, ++nIndex);
      }
      sVar += "!"; //end spelllevel string
      nIndex = 0;
    }
    sVar = sSlot + sVar + "*";
    //place into the class variable
    if(nStartS > -1)  //get rid of * in front
      sVar = GetSubString(sClass, 0, nStartS) + sVar + GetSubString(sClass, nEndS+1, GetStringLength(sClass)-nEndS-1) + "_";
    else
      sVar = sClass + sVar + "_";

    //combine into the whole string
    if(nStartC > -1)  //get rid of _ in the back
      sVar = GetSubString(sOVar, 0, nStartC) + sVar + GetSubString(sOVar, nEndC+1, GetStringLength(sClass)-nEndC-1);
    else if(sOVar != "") //first time the class is being added.
      sVar = sOVar + sVar;

    SetLocalString(oHide, MD_SPELLBOOK, sVar);
  }
  else
  {
    sVar = GetSubString(sClass, nStartS, nEndS-nStartS);

    string sSpellLevel;
    int nStart;
    int nEnd;
    int nIEnd;
    string sIndex;
    for(nSpellLevel = 0; nSpellLevel <= 9; nSpellLevel++)
    {
      nStart = FindSubString(sVar, IntToString(nSpellLevel) + ":");
      sSpellLevel = GetSubString(sVar,  nStart + 2, FindSubString(sVar, "!", nStart)- nStart - 1);

      if(sSpellLevel != "")
      {
         nEnd = FindSubString(sSpellLevel, "|", 0);
         sIndex = GetSubString(sSpellLevel, 0, nEnd);
         while(nEnd > -1)
         {
           mss.id = StringToInt(GetSubString(sIndex, 0, FindSubString(sIndex, ";")));

           nStart = FindSubString(sIndex, "M");
           if(nStart > -1)
             mss.meta = StringToInt(GetSubString(sIndex, nStart + 1, nEnd-nStart-1));
           else
             mss.meta = 0;

           if(FindSubString(sIndex, "O") > -1)
             mss.domain = 1;
           else
             mss.domain = 0;

           NWNX_Creature_SetMemorisedSpell(oPC, nClass, nSpellLevel, nIndex++, mss);

           nIEnd =  FindSubString(sSpellLevel, "|", nEnd+1);
           sIndex = GetSubString(sSpellLevel, nEnd+1, nIEnd-nEnd-1);
           nEnd = nIEnd;

         }

      }

      nIndex = 0;
    }
  }
}
