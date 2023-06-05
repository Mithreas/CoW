// Template for NUI windows
// Copy this for each new window you want to create, and fill in the gaps.
const string sTag = "nui_crafting"; // This should match the name of the script (without the .nss suffix).

void CreateWindow()
{
  // Pull the category list and convert to an array of ComboEntries.
  json categories;
  CnrRecipeShowMenu("cnrcarpelf", 0);
  
  
  
  json col = JsonArray();
  
  // Filter by craft category
  row = JsonArray();
    row = JsonArrayInsert(row, NuiSpacer());
    row = JsonArrayInsert(row, NuiButtonSelect(NuiString("Filter by category"), NuiBind("filter_category")));
	row = JsonArrayInsert(row, NuiCombo(categories, NuiBind("category_index")));
    row = JsonArrayInsert(row, NuiSpacer());
  col = JsonArrayInsert(col, NuiHeight(NuiRow(row), 20.0));
  
  // Filter by resources available
  
  // Filter by recipe level
  
  // Recipe list
  
  json root = NuiCol(col);
  
    json nui = NuiWindow(
        root,
        JsonString("Crafting"),
        NuiBind("geometry"),
        NuiBind("resizable"),
        NuiBind("collapsed"),
        NuiBind("closable"),
        NuiBind("transparent"),
        NuiBind("border"));

    int token = NuiCreate(OBJECT_SELF, nui, sTag);
}

void Start()
{
  // Put any actions here to perform when the window opens, such as setting the size, and binding field values.
  int    nToken  = NuiGetEventWindow();
  object oPC     = OBJECT_SELF;
  
  NuiSetBind(oPC, nToken, "geometry", NuiRect(420.0, 10.0, 400.0, 600.0));
  NuiSetBind(oPC, nToken, "resizable", JsonBool(FALSE));
  NuiSetBind(oPC, nToken, "collapsed", JsonBool(FALSE));
  NuiSetBind(oPC, nToken, "closable", JsonBool(TRUE));
  NuiSetBind(oPC, nToken, "transparent", JsonBool(FALSE));
  NuiSetBind(oPC, nToken, "border", JsonBool(TRUE));

  NuiSetBind(oPC, nToken, "filter_category", JsonBool(FALSE));
  NuiSetBind(oPC, nToken, "category_index", JsonInt(0));
  
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
  string sElem   = NuiGetEventElement();     // Retrieves the widget name
  int    nIdx    = NuiGetEventArrayIndex();  // Retrieves the index of the element within the widget, if it's an array.
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