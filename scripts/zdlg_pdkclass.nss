/*
  Name: zdlg_pdkclass
  Author: Mithreas
  Date: 14 Nov 2015
  Description:
    Allows [Purple Dragon] Knights to select their class.
    You can only do this once.  Should be called repeatedly until
    the PC has MI_CL_PDK_PATH set to a non zero value.
*/
#include "inc_class"
#include "inc_bonuses"
#include "inc_zdlg"

const string CONTINUE = "DLG_CONTINUE";
const string OPTIONS  = "DLG_OPTIONS";

const string PAGE_MAIN      = "";
const string PAGE_VANGUARD  = "DLG_PAGE_VANGUARD";
const string PAGE_PROTECTOR = "DLG_PAGE_PROTECTOR";
const string PAGE_VALIANT   = "DLG_PAGE_VALIANT";
const string PAGE_CONFIRM   = "DLG_PAGE_CONFIRM";

// Descriptions
const string D_VANGUARD  = "Knight Vanguard\nThe Knight Vanguard is the scourge of his enemies, scattering all before him.";
const string D_PROTECTOR = "Knight Protector\nThe Knight Protector is the defender of the weak, and stalwart comrade-at-arms.";
const string D_VALIANT   = "Knight Valiant\nThe Knight Valiant inspires all around them to feats of heroism.";


void Init()
{
  Trace(ZDIALOG, "Initialising PDK Select");
  // This method is called once, at the start of the conversation.

  object oPC = GetPcDlgSpeaker();

  DeleteList(OPTIONS);
  DeleteLocalInt(OBJECT_SELF, "DLG_CLASS_I");
  DeleteLocalString(OBJECT_SELF, "DLG_CLASS");
  int nPDKClass = GetLocalInt(gsPCGetCreatureHide(oPC), VAR_PDK);

  AddStringElement("[Leave]", OPTIONS);

  // Is the PC a PDK without a class?
  if (GetLevelByClass(CLASS_TYPE_PURPLE_DRAGON_KNIGHT, oPC) &&
      !nPDKClass)
  {
    AddStringElement("[Select This Class]", OPTIONS);
    AddStringElement("[Knight Vanguard]", OPTIONS);
    AddStringElement("[Knight Protector]", OPTIONS);
    AddStringElement("[Knight Valiant]", OPTIONS);
  }
  else if (nPDKClass)
  {
    switch (nPDKClass)
    {
      case MI_CL_PDK_VANGUARD:
        SetDlgPageString(PAGE_VANGUARD);
        break;
      case MI_CL_PDK_PROTECTOR:
        SetDlgPageString(PAGE_PROTECTOR);
        break;
      case MI_CL_PDK_VALIANT:
        SetDlgPageString(PAGE_VALIANT);
        break;
    }
  }

  if (GetElementCount(CONTINUE) == 0)
  {
    AddStringElement("[Confirm]", CONTINUE);
    AddStringElement("[Back]", CONTINUE);
  }
}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  object oPC = GetPcDlgSpeaker();
  int bPDK = GetLevelByClass(CLASS_TYPE_PURPLE_DRAGON_KNIGHT, oPC);
  string sPage = GetDlgPageString();
  SetDlgResponseList(OPTIONS);

  if (!bPDK)
  {
    SetDlgPrompt("Hm.  Come back and speak with me once you've properly trained as a Knight.");
  }
  else if (sPage == PAGE_MAIN)
  {
    SetDlgPrompt("Choose the tradition to which your Order belongs.");
  }
  else if (sPage == PAGE_VANGUARD)
  {
    SetDlgPrompt("Current class: " + D_VANGUARD);
  }
  else if (sPage == PAGE_PROTECTOR)
  {
    SetDlgPrompt("Current class: " + D_PROTECTOR);
  }
  else if (sPage == PAGE_VALIANT)
  {
    SetDlgPrompt("Current class: " + D_VALIANT);
  }
  else if (sPage == PAGE_CONFIRM)
  {
    SetDlgPrompt("Are you sure you want to become a " + GetLocalString(OBJECT_SELF, "DLG_CLASS") + "?\n\n<cþ  >Once you make this choice, it cannot be reversed!</c>");
    SetDlgResponseList(CONTINUE);
  }
}

void HandleSelection()
{
  // This method handles what happens when the player selects an option.
  int selection   = GetDlgSelection();
  object oPC      = GetPcDlgSpeaker();
  string sPage    = GetDlgPageString();

  if (sPage == PAGE_CONFIRM)
  {
    switch (selection)
    {
      case 0:
        // Set class.
        SetLocalInt(gsPCGetCreatureHide(oPC), VAR_PDK, GetLocalInt(OBJECT_SELF, "DLG_CLASS_I"));
        ApplyCharacterBonuses(oPC);
        FloatingTextStringOnCreature("Congratulations - you are now a " + GetLocalString(OBJECT_SELF, "DLG_CLASS"), oPC, FALSE);
        EndDlg();
        break;
      case 1:
        SetDlgPageString(GetLocalString(OBJECT_SELF, "DLG_PREV_PAGE"));
        break;
    }
  }
  else
  {
    switch (selection)
    {
      case 0:
        EndDlg();
        break;
      case 1:
        // Select this class
        SetLocalString(OBJECT_SELF, "DLG_PREV_PAGE", sPage);

        if (sPage == PAGE_MAIN)
        {
          SendMessageToPC(oPC, "Please choose a class.");
        }
        else if (sPage == PAGE_VANGUARD)
        {
          SetLocalInt(OBJECT_SELF, "DLG_CLASS_I", MI_CL_PDK_VANGUARD);
          SetLocalString(OBJECT_SELF, "DLG_CLASS", "Knight Vanguard");
          SetDlgPageString(PAGE_CONFIRM);
        }
        else if (sPage == PAGE_PROTECTOR)
        {
          SetLocalInt(OBJECT_SELF, "DLG_CLASS_I", MI_CL_PDK_PROTECTOR);
          SetLocalString(OBJECT_SELF, "DLG_CLASS", "Knight Protector");
          SetDlgPageString(PAGE_CONFIRM);
        }
        else if (sPage == PAGE_VALIANT)
        {
          SetLocalInt(OBJECT_SELF, "DLG_CLASS_I", MI_CL_PDK_VALIANT);
          SetLocalString(OBJECT_SELF, "DLG_CLASS", "Knight Valiant");
          SetDlgPageString(PAGE_CONFIRM);
        }
        break;
      case 2: // Vanguard
        SetDlgPageString(PAGE_VANGUARD);
        break;
      case 3: // Protector
        SetDlgPageString(PAGE_PROTECTOR);
        break;
      case 4: // Valiant
        SetDlgPageString(PAGE_VALIANT);
        break;
    }
  }
}

void main()
{
  int nEvent = GetDlgEventType();
  Trace(ZDIALOG, "Running zdlg_pdkclass script");
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
