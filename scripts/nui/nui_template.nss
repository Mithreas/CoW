// Template for NUI windows
// Copy this for each new window you want to create, and fill in the gaps.
const string sTag = "nui_template"; // This should match the name of the script (without the .nss suffix).

void CreateWindow()
{
    json nui = NuiWindow(
        JsonNull(), // This is where you put the layout.  See nw_nui_demo.nss for examples.
        JsonString("Template Window"),
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

  //NuiSetBind(oPC, nToken, "some_variable_name", JsonInt(some_integer));
  
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