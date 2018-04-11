#include "__server_config"
#include "gs_inc_subrace"
#include "zdlg_include_i"
#include "zzdlg_color_inc"

//------------------------------------------------------------------------------
// Set up some constants to use for list and variable names.
//------------------------------------------------------------------------------

const string SKIN_OPTIONS   = "skin_options";

const string SKIN_SELECT    = "SELECT_SKIN";

const string NUM_RACE_OPTIONS   = "NUM_RACE_OPTIONS";

const int MI_SKIN_NONE       = 0;
const int MI_SKIN_GOBLIN     = 1;
const int MI_SKIN_KOBOLD     = 2;
const int MI_SKIN_GNOLL      = 3;
const int MI_SKIN_OGRE       = 4;
const int MI_SKIN_HOBGOBLIN  = 5;
const int MI_SKIN_IMP        = 6;

//::  Not defined in NWN Base
const int APPEARANCE_TYPE_OGRE_ELITE = 75;

string SKIN_INTRO = "Please select a skin for your character.\n(Gnolls, Hobgoblins & Imps only have two skins.).";

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


//------------------------------------------------------------------------------
// end utility methods - everything below here is part of the conversation.
//------------------------------------------------------------------------------

void Init()
{

  object oPC = GetPcDlgSpeaker();
  int nSubRace = gsSUGetSubRaceByName(GetSubRace(oPC));

  SetLocalInt(OBJECT_SELF, NUM_RACE_OPTIONS, 6);


  //::  Removes all previous elements, we do this so we can setup SKIN_INTRO differently
  DeleteList(SKIN_OPTIONS);

  if (GetElementCount(SKIN_OPTIONS) == 0) {
    //::  2 Option races
    if ( nSubRace == GS_SU_HALFORC_GNOLL || nSubRace == GS_SU_SPECIAL_HOBGOBLIN || nSubRace == GS_SU_SPECIAL_IMP ) {
        SetLocalInt(OBJECT_SELF, NUM_RACE_OPTIONS, 2);
        AddStringElement("Model A <c þ >[Default]</c>", SKIN_OPTIONS);
        AddStringElement("Model B", SKIN_OPTIONS);
        AddStringElement(txtRed + "[Leave]</c>", SKIN_OPTIONS);
        return;
    }
    //::  7 Option Races
    else if ( nSubRace == GS_SU_SPECIAL_OGRE ) {
        SetLocalInt(OBJECT_SELF, NUM_RACE_OPTIONS, 7);
        AddStringElement("Ogre A <c þ >[Default]</c>", SKIN_OPTIONS);
        AddStringElement("Ogre B", SKIN_OPTIONS);
        AddStringElement("Ogre Magi A", SKIN_OPTIONS);
        AddStringElement("Ogre Magi B", SKIN_OPTIONS);
        AddStringElement("Ogre Armoured A", SKIN_OPTIONS);
        AddStringElement("Ogre Armoured B", SKIN_OPTIONS);
        AddStringElement("Ogre Elite", SKIN_OPTIONS);
        AddStringElement(txtRed + "[Leave]</c>", SKIN_OPTIONS);
        return;
    }


    AddStringElement("Peasant A <c þ >[Default]</c>", SKIN_OPTIONS);
    AddStringElement("Peasant B", SKIN_OPTIONS);
    AddStringElement("Shaman A", SKIN_OPTIONS);
    AddStringElement("Shaman B", SKIN_OPTIONS);
    AddStringElement("Warrior A", SKIN_OPTIONS);
    AddStringElement("Warrior B", SKIN_OPTIONS);
    AddStringElement(txtRed +  "[Leave]</c>", SKIN_OPTIONS);
  }

}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();

  object oPC = GetPcDlgSpeaker();
  int nSubRace = gsSUGetSubRaceByName(GetSubRace(oPC));

  if (sPage == "")
  {
    SetDlgPrompt(SKIN_INTRO);
    SetDlgResponseList(SKIN_OPTIONS, OBJECT_SELF);
  }

}

void HandleSelection()
{
  // This method handles what happens when the player selects an option.
  int selection    = GetDlgSelection();
  string sPage     = GetDlgPageString();

  int nNumOptions = GetLocalInt(OBJECT_SELF, NUM_RACE_OPTIONS);

  if (sPage == "")
  {
     if (selection != nNumOptions) {
       _ApplySkin(selection);
     } else {
       EndDlg();
     }
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
