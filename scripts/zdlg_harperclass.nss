/*
  Name: zdlg_harperclass
  Author: Mithreas
  Date: 14 Nov 2015
  Description:
    Allows Harper Agents to select their class.
    You can only do this once (and default to regular agent otherwise).
*/
#include "inc_class"
#include "inc_bonuses"
#include "inc_zdlg"

const string CONTINUE = "DLG_CONTINUE";
const string OPTIONS  = "DLG_OPTIONS";

const string PAGE_MAIN    = "";
const string PAGE_MAGE    = "DLG_PAGE_MAGE";
const string PAGE_PRIEST  = "DLG_PAGE_PRIEST";
const string PAGE_PARAGON = "DLG_PAGE_PARAGON";
const string PAGE_MASTER  = "DLG_PAGE_MASTER";
const string PAGE_CONFIRM = "DLG_PAGE_CONFIRM";

// Descriptions
const string D_SCOUT   = "Harper Scout\nLevel 1: Harper Knowledge\nLevel 2: Skill Focus: Bluff, Deneir's Eye\nLevel 3: Lucky, Luck of Heroes\nLevel 4: Lliira's Heart\nLevel 5: Epic Skill Focus: Bluff, Craft Potion\n\nGets a caster level bonus to all classes at levels 1/3/5.\nCan vote in any election without citizenship.";
const string D_MAGE    = "Harper Mage\nLevel 1: Harper Knowledge\nLevel 2: Skill Focus: Spellcraft\nLevel 3: Auto Quicken I\nLevel 5: Eschew Materials (no longer need spell components).\n\nGets a caster level bonus equal to Harper level for all Arcane spellcasting.\nCan vote in any election without citizenship from level 5.";
const string D_PRIEST  = "Harper Priest\nLevel 1: Harper Knowledge\nLevel 2: +3 caster levels for Turn Undead\nLevel 3: Reduce armor movement penalties by 10% (doesn't stack with fighter)\nLevel 5: Get all deity aspect bonuses\n\nGets a caster level bonus equal to Harper level for all Divine spellcasting and Turn Undead (stacks with level 2 ability).\nCan vote in any election without citizenship from level 5.";
const string D_PARAGON = "Harper Paragon\nLevel 1: Can use detect evil.\nLevel 3: Divine Grace\nLevel 4: Turn Undead, Divine Shield\nLevel 5: Divine Might\n\nGets a caster level bonus equal to Harper level.\nCan vote in any election without citizenship from level 5.";
const string D_MASTER  = "Master Harper\nLevel 1: Harper Knowledge\nLevel 2: Your Bardsong cures lycanthropy\nLevel 3: Skill Focus: Lore\nLevel 4: Epic Skill Focus: Lore\nLevel 5: You can use Bardsong unlimited times per day\n\nYou count your Harper levels as Bard levels when singing.\nCan vote in any election without citizenship from level 5.";


void Init()
{
  Trace(ZDIALOG, "Initialising Harper Class Select");
  // This method is called once, at the start of the conversation.

  object oPC = GetPcDlgSpeaker();

  DeleteList(OPTIONS);
  DeleteLocalInt(OBJECT_SELF, "DLG_CLASS_I");
  DeleteLocalString(OBJECT_SELF, "DLG_CLASS");
  int nHarperClass = GetLocalInt(gsPCGetCreatureHide(oPC), VAR_HARPER);

  AddStringElement("[Leave]", OPTIONS);

  // Is the PC a harper without a class?
  if (GetLevelByClass(CLASS_TYPE_HARPER, oPC) &&
      !nHarperClass)
  {
    AddStringElement("[Select This Class]", OPTIONS);
    AddStringElement("[Harper Scout]", OPTIONS);
    AddStringElement("[Harper Mage]", OPTIONS);
    AddStringElement("[Harper Priest]", OPTIONS);
    AddStringElement("[Harper Paragon]", OPTIONS);
    AddStringElement("[Master Harper]", OPTIONS);
  }
  else if (nHarperClass)
  {
    switch (nHarperClass)
    {
      case MI_CL_HARPER_MAGE:
        SetDlgPageString(PAGE_MAGE);
        break;
      case MI_CL_HARPER_PRIEST:
        SetDlgPageString(PAGE_PRIEST);
        break;
      case MI_CL_HARPER_PARAGON:
        SetDlgPageString(PAGE_PARAGON);
        break;
      case MI_CL_HARPER_MASTER:
        SetDlgPageString(PAGE_MASTER);
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
  int bHarper = GetLevelByClass(CLASS_TYPE_HARPER, oPC);
  string sPage = GetDlgPageString();
  SetDlgResponseList(OPTIONS);

  if (!bHarper)
  {
    SetDlgPrompt("Hm.  Come back and speak with me once you've properly trained as a Harper.");
  }
  else if (sPage == PAGE_MAIN)
  {
    SetDlgPrompt("Current class: " + D_SCOUT);
  }
  else if (sPage == PAGE_MAGE)
  {
    SetDlgPrompt("Current class: " + D_MAGE);
  }
  else if (sPage == PAGE_PRIEST)
  {
    SetDlgPrompt("Current class: " + D_PRIEST);
  }
  else if (sPage == PAGE_PARAGON)
  {
    SetDlgPrompt("Current class: " + D_PARAGON);
  }
  else if (sPage == PAGE_MASTER)
  {
    SetDlgPrompt("Current class: " + D_MASTER);
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
        SetLocalInt(gsPCGetCreatureHide(oPC), VAR_HARPER, GetLocalInt(OBJECT_SELF, "DLG_CLASS_I"));
        ApplyCharacterBonuses(oPC);
        SpeakString("Congratulations - you are now a " + GetLocalString(OBJECT_SELF, "DLG_CLASS"));
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
          SetLocalInt(OBJECT_SELF, "DLG_CLASS_I", MI_CL_HARPER_SCOUT);
          SetLocalString(OBJECT_SELF, "DLG_CLASS", "Scout Spy");
        }
        else if (sPage == PAGE_MAGE)
        {
          SetLocalInt(OBJECT_SELF, "DLG_CLASS_I", MI_CL_HARPER_MAGE);
          SetLocalString(OBJECT_SELF, "DLG_CLASS", "Scout Mage");
        }
        else if (sPage == PAGE_PRIEST)
        {
          SetLocalInt(OBJECT_SELF, "DLG_CLASS_I", MI_CL_HARPER_PRIEST);
          SetLocalString(OBJECT_SELF, "DLG_CLASS", "Scout Priest");
        }
        else if (sPage == PAGE_PARAGON)
        {
          SetLocalInt(OBJECT_SELF, "DLG_CLASS_I", MI_CL_HARPER_PARAGON);
          SetLocalString(OBJECT_SELF, "DLG_CLASS", "Scout Paragon");
        }
        else if (sPage == PAGE_MASTER)
        {
          SetLocalInt(OBJECT_SELF, "DLG_CLASS_I", MI_CL_HARPER_MASTER);
          SetLocalString(OBJECT_SELF, "DLG_CLASS", "Master Scout");
        }
        SetDlgPageString(PAGE_CONFIRM);
        break;
      case 2: // Scout
        SetDlgPageString(PAGE_MAIN);
        break;
      case 3:
        SetDlgPageString(PAGE_MAGE);
        break;
      case 4:
        SetDlgPageString(PAGE_PRIEST);
        break;
      case 5:
        SetDlgPageString(PAGE_PARAGON);
        break;
      case 6:
        SetDlgPageString(PAGE_MASTER);
        break;
    }
  }
}

void main()
{
  // Never (ever ever) change this method. Got that? Good.
  int nEvent = GetDlgEventType();
  Trace(ZDIALOG, "Running zdlg_harperclass script");
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
