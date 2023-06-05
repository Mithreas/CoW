#include "nw_inc_nui_insp"
void main()
{
    HandleWindowInspectorEvent();
    string sScript  = NuiGetWindowId(NuiGetEventPlayer(), NuiGetEventWindow());
    int nFind = FindSubString(sScript, "|");

    if(nFind > -1)
        sScript = GetStringLeft(sScript, nFind);

    ExecuteScript(sScript, OBJECT_SELF);
}
