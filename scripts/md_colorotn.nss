//Used in old color dialogs, get's the new color dialog
#include "zzdlg_tools_inc"
int StartingConditional()
{
    _dlgStart(GetPCSpeaker(), OBJECT_SELF, "zz_co_color", TRUE, TRUE);
    return FALSE;
}
