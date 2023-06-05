#include "inc_nui"

const string WINDOW = "";

void CreateWindow(object oPC)
{
    //json jCol = JsonArray();
    //json jRow = JsonArray();
 
    /*json root;
      json nui = NUI_Window(
      root,
      JsonString("Title"),
      NuiBind("geometry"),
      JsonBool(TRUE), //Resizeable
      JsonBool(FALSE), //Collapsed
      JsonBool(TRUE), //Closeale
      JsonBool(FALSE), //Transparent
      JsonBool(TRUE)); //Border*/

    int nToken = NuiCreate(pc, nui, WINDOW);

    //Set default bind values and bind watchers down here.
}

void Events()
{
    //object oPlayer = NuiGetEventPlayer();
    //int    nToken  = NuiGetEventWindow();
    //string sEvent  = NuiGetEventType();
    //string sElem   = NuiGetEventElement();
    //int    nIdx    = NuiGetEventArrayIndex();
    //string sWndId  = NuiGetWindowId(oPlayer, nToken);

}
void main()
{
    if(GetCurrentlyRunningEvent() == EVENT_SCRIPT_MODULE_ON_NUI_EVENT)
      Events();
    else
    {
      object oPC;
      CreateWindow(oPC);
    }
}