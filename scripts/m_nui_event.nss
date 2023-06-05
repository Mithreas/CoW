// Module event script for NUI events.
// Looks up the window type and executes the relevant script.
// See nui_template for the structure the script should follow.
#include "nw_inc_nui"
void main()
{
  object oPlayer = NuiGetEventPlayer();
  int    nToken  = NuiGetEventWindow();
  string sWndId  = NuiGetWindowId(oPlayer, nToken);
	
  ExecuteScript(sWndId, oPlayer);
}