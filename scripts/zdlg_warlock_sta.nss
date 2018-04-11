/*
  zdlg_warlock_sta

  Warlock staff conversation - lets the warlock select which element to use.
*/
#include "inc_warlock"
#include "zdlg_include_i"
const string ELEMENTS = "MI_WA_ELEMENTS";

void Init()
{
  DeleteList(ELEMENTS);
  object oPC = GetPcDlgSpeaker();
  int nLevel = miWAGetCasterLevel(oPC);
  int nPact = miWAGetIsWarlock(oPC);

  if (nPact == PACT_ABYSSAL || nPact == PACT_INFERNAL)
  {
    AddStringElement("<c þ >[Do Fire damage]</c>", ELEMENTS);
    if (nLevel >= 4) AddStringElement("<c þ >[Do Acid damage]</c>", ELEMENTS);
    if (nLevel >= 8) AddStringElement("<c þ >[Do Negative damage]</c>", ELEMENTS);
    if (nLevel >= 12) AddStringElement("<c þ >[Do Magic damage]</c>", ELEMENTS);
  }
  else if (nPact == PACT_FEY)
  {
    AddStringElement("<c þ >[Do Cold damage]</c>", ELEMENTS);
    if (nLevel >= 4) AddStringElement("<c þ >[Do Lightning damage]</c>", ELEMENTS);
    if (nLevel >= 8) AddStringElement("<c þ >[Do Positive damage]</c>", ELEMENTS);
    if (nLevel >= 12) AddStringElement("<c þ >[Do Magic damage]</c>", ELEMENTS);
  }

  AddStringElement("<cþ  >[Keep current damage type]</c>", ELEMENTS);
}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  object oPC   = GetPcDlgSpeaker();
  int nElement = miWAGetDamageType(oPC);
  string sElement = "magic";

  switch (nElement)
  {
    case DAMAGE_TYPE_FIRE:
      sElement = "fire";
      break;
    case DAMAGE_TYPE_ACID:
      sElement = "acid";
      break;
    case DAMAGE_TYPE_NEGATIVE:
      sElement = "negative";
      break;
    case DAMAGE_TYPE_POSITIVE:
      sElement = "positive";
      break;
    case DAMAGE_TYPE_COLD:
      sElement = "cold";
      break;
    case DAMAGE_TYPE_ELECTRICAL:
      sElement = "lightning";
      break;
  }

  SetDlgPrompt("Your Eldritch Blast currently does "+sElement+" damage.");
  SetDlgResponseList(ELEMENTS);
}

void HandleSelection()
{
  // This method handles what happens when the player selects an option.
  int selection  = GetDlgSelection();
  object oPC     = GetPcDlgSpeaker();
  int nPact      = miWAGetIsWarlock(oPC);

  // Last entry is always 'cancel'
  if (selection == GetElementCount(ELEMENTS) - 1) EndDlg();

  else if (nPact == PACT_ABYSSAL || nPact == PACT_INFERNAL)
  {
    switch (selection)
    {
      case 0:
        miWASetDamageType(WARLOCK_ELEMENT_FIRE, oPC);
        break;
      case 1:
        miWASetDamageType(WARLOCK_ELEMENT_ACID, oPC);
        break;
      case 2:
        miWASetDamageType(WARLOCK_ELEMENT_NEGATIVE, oPC);
        break;
      case 3:
        miWASetDamageType(WARLOCK_ELEMENT_MAGIC, oPC);
        break;
    }
  }
  
  else if (nPact == PACT_FEY)
  {
    switch (selection)
    {
      case 0:
        miWASetDamageType(WARLOCK_ELEMENT_COLD, oPC);
        break;
      case 1:
        miWASetDamageType(WARLOCK_ELEMENT_LIGHTNING, oPC);
        break;
      case 2:
        miWASetDamageType(WARLOCK_ELEMENT_POSITIVE, oPC);
        break;
      case 3:
        miWASetDamageType(WARLOCK_ELEMENT_MAGIC, oPC);
        break;
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
