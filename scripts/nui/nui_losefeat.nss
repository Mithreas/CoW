// Template for NUI windows
// Copy this for each new window you want to create, and fill in the gaps.
#include "nwnx_creature"
#include "nwnx_alts"
#include "nw_inc_nui"
#include "inc_pc"
const string sTag = "nui_losefeat"; // This should match the name of the script (without the .nss suffix).

int isAllowedFeat(int nFeat)
{
  switch (nFeat)
  {
    case 2: // armour prof
	case 3: // armour prof
	case 4: // armour prof
	case 48: // class wpn prof
	case 49: // class wpn prof
	case 50: // class wpn prof
	case 51: // class wpn prof
	case 197: // class lvl 1
	case 198: // class lvl 1
	case 199: // class lvl 1
	case 200: // class lvl 1
	case 201: // class lvl 1
	case 204: // class lvl 1
	case 213: // class lvl 1
	case 221: // class lvl 1
	case 227: // racial
	case 228: // racial
	case 229: // racial
	case 230: // racial
	case 231: // racial
	case 232: // racial
	case 233: // racial
	case 234: // racial
	case 235: // racial
	case 236: // racial
	case 237: // racial
	case 238: // racial
	case 239: // racial
	case 240: // racial
	case 241: // racial
	case 242: // racial
	case 243: // racial
	case 244: // racial
	case 245: // racial
	case 246: // racial
	case 247: // racial
	case 248: // racial
	case 249: // racial
	case 250: // racial
	case 256: // racial
	case 257: // class lvl 1
	case 258: // racial
	case 259: // class lvl 1
	case 260: // class lvl 1
	case 293: // class lvl 1
	case 306: // class lvl 1
	case 307: // class lvl 1
	case 308: // class lvl 1
	case 309: // class lvl 1
	case 310: // class lvl 1
	case 311: // class lvl 1
	case 312: // class lvl 1
	case 313: // class lvl 1
	case 314: // class lvl 1
	case 315: // class lvl 1
	case 316: // class lvl 1
	case 317: // class lvl 1
	case 318: // class lvl 1
	case 319: // class lvl 1
	case 320: // class lvl 1
	case 321: // class lvl 1
	case 322: // class lvl 1
	case 323: // class lvl 1
	case 324: // class lvl 1
	case 325: // class lvl 1
	
  
      return FALSE;
  }
  
  return TRUE;
}

void CreateWindow()
{
	json col = JsonArray();
	
  // Header
  json row = JsonArray();
    row = JsonArrayInsert(row, NuiSpacer());
    row = JsonArrayInsert(row, NuiWidth(NuiText(JsonString("Please select the feat to remove.  This will lower your SL but you will NOT be refunded."), FALSE, NUI_SCROLLBARS_NONE), 400.0));
    row = JsonArrayInsert(row, NuiSpacer());
  col = JsonArrayInsert(col, NuiHeight(NuiRow(row), 50.0));
	
  // Feat list
  row = JsonArray();
  
	json featList = JsonArray();
	int nFeat;
	int nFirst = 0;
	
	for (nFeat = 0; nFeat < 1500; nFeat++)
	{
	  if (NWNX_Creature_GetKnowsFeat(OBJECT_SELF, nFeat) && isAllowedFeat(nFeat))
	  {
	    featList = JsonArrayInsert(featList, NuiComboEntry(GetStringByStrRef(StringToInt(Get2DAString("feat", "FEAT",  nFeat))), nFeat));
		if (!nFirst) nFirst = nFeat;
	  }
	}
  
    row = JsonArrayInsert(row, NuiSpacer());
    row = JsonArrayInsert(row, NuiWidth(NuiCombo(featList, NuiBind("selected_feat")), 300.0));
    row = JsonArrayInsert(row, NuiSpacer());
  col = JsonArrayInsert(col, NuiHeight(NuiRow(row), 30.0));
  
  row = JsonArray();
    row = JsonArrayInsert(row, NuiSpacer());
    json btnRemove = NuiId(NuiButton(JsonString("Remove")), "btnRemove");
    row = JsonArrayInsert(row, NuiWidth(btnRemove, 80.0));
    row = JsonArrayInsert(row, NuiSpacer());
  col = JsonArrayInsert(col, NuiRow(row));
	
  json root = NuiCol(col);
  
  json nui = NuiWindow(
        root, 
        JsonString("Remove Feat"),
        NuiBind("geometry"),
        NuiBind("resizable"),
        NuiBind("collapsed"),
        NuiBind("closable"),
        NuiBind("transparent"),
        NuiBind("border"));

  int nToken = NuiCreate(OBJECT_SELF, nui, sTag);
	
  NuiSetBind(OBJECT_SELF, nToken, "selected_feat", JsonInt(nFirst));
	
  NuiSetBind(OBJECT_SELF, nToken, "geometry", NuiRect(100.0, 100.0, 500.0, 200.0));
  NuiSetBind(OBJECT_SELF, nToken, "resizable", JsonBool(FALSE));
  NuiSetBind(OBJECT_SELF, nToken, "collapsed", JsonBool(FALSE));
  NuiSetBind(OBJECT_SELF, nToken, "closable", JsonBool(TRUE));
  NuiSetBind(OBJECT_SELF, nToken, "transparent", JsonBool(FALSE));
  NuiSetBind(OBJECT_SELF, nToken, "border", JsonBool(TRUE));  
	
}

void Start()
{
  // Put any actions here to perform when the window opens, such as setting the size, and binding field values.
  int    nToken  = NuiGetEventWindow();
  object oPC     = OBJECT_SELF;
  
}

void OnMouseDown()
{
  string sElem   = NuiGetEventElement();     // Retrieves the widget name
  int    nIdx    = NuiGetEventArrayIndex();  // Retrieves the index of the element within the widget, if it's an array.
}

void OnMouseUp()
{
  string sElem   = NuiGetEventElement();     // Retrieves the widget name
  int    nIdx    = NuiGetEventArrayIndex();  // Retrieves the index of the element within the widget, if it's an array.
}

void OnClick()
{
  int    nToken  = NuiGetEventWindow();
  object oPC     = OBJECT_SELF;
  string sElem   = NuiGetEventElement();     // Retrieves the widget name
  int    nIdx    = NuiGetEventArrayIndex();  // Retrieves the index of the element within the widget, if it's an array.
  
  if (sElem == "btnRemove")
  {
    int nFeat = JsonGetInt(NuiGetBind(oPC, nToken, "selected_feat"));
	
	if (nFeat)
	{
	  NWNX_Creature_RemoveFeat(oPC, nFeat);
	  int nLevel = GetLocalInt(gsPCGetCreatureHide(oPC), "FL_LEVEL") - 1;
	  SetLocalInt(gsPCGetCreatureHide(oPC), "FL_LEVEL", nLevel);
	  FloatingTextStringOnCreature("Removed feat.  Your system level is now " + IntToString(nLevel), oPC);
	  NuiDestroy(oPC, nToken);
	  WriteTimestampedLogEntry(GetName(oPC) + " removed feat " + IntToString(nFeat));
	  
	  switch (nFeat)
	  {
	    case FEAT_EPIC_GREAT_CHARISMA_1:
		case FEAT_EPIC_GREAT_CHARISMA_2:
		case FEAT_EPIC_GREAT_CHARISMA_3:
		case FEAT_EPIC_GREAT_CHARISMA_4:
		  ModifyAbilityScore(oPC, ABILITY_CHARISMA, -1);
		  break;
		case FEAT_EPIC_GREAT_CONSTITUTION_1:
		case FEAT_EPIC_GREAT_CONSTITUTION_2:
		case FEAT_EPIC_GREAT_CONSTITUTION_3:
		case FEAT_EPIC_GREAT_CONSTITUTION_4:
		  ModifyAbilityScore(oPC, ABILITY_CONSTITUTION, -1);
		  break;
		case FEAT_EPIC_GREAT_DEXTERITY_1:
		case FEAT_EPIC_GREAT_DEXTERITY_2:
		case FEAT_EPIC_GREAT_DEXTERITY_3:
		case FEAT_EPIC_GREAT_DEXTERITY_4:
		  ModifyAbilityScore(oPC, ABILITY_DEXTERITY, -1);
		  break;
		case FEAT_EPIC_GREAT_INTELLIGENCE_1:
		case FEAT_EPIC_GREAT_INTELLIGENCE_2:
		case FEAT_EPIC_GREAT_INTELLIGENCE_3:
		case FEAT_EPIC_GREAT_INTELLIGENCE_4:
		  ModifyAbilityScore(oPC, ABILITY_INTELLIGENCE, -1);
		  break;
		case FEAT_EPIC_GREAT_WISDOM_1:
		case FEAT_EPIC_GREAT_WISDOM_2:
		case FEAT_EPIC_GREAT_WISDOM_3:
		case FEAT_EPIC_GREAT_WISDOM_4:
		  ModifyAbilityScore(oPC, ABILITY_WISDOM, -1);
		  break;
		case FEAT_EPIC_GREAT_STRENGTH_1:
		case FEAT_EPIC_GREAT_STRENGTH_2:
		case FEAT_EPIC_GREAT_STRENGTH_3:
		case FEAT_EPIC_GREAT_STRENGTH_4:
		  ModifyAbilityScore(oPC, ABILITY_STRENGTH, -1);
		  break;
	  }
	}
  }
}


void CleanUp()
{
  // Put any cleanup actions here to perform when the window closes.
}

void main()
{
  int bCreate = GetLocalInt(OBJECT_SELF, "NUI_CREATE");
  if (bCreate)
  {
    CreateWindow();
	DeleteLocalInt(OBJECT_SELF, "NUI_CREATE");
	return;
  }

  string sEvent  = NuiGetEventType();
  
  if (sEvent == "click")
  {
    OnClick();
  }
  else if (sEvent == "close")
  {
    CleanUp();
  }
  else if (sEvent == "open")
  {
    Start();
  }
  else if (sEvent == "mouseup")
  {
    OnMouseUp();
  }
  else if (sEvent == "mousedown")
  {
    OnMouseDown();
  }

}