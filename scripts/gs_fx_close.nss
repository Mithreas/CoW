#include "zzdlg_tools_inc"
void main()
{
    object oSelf = OBJECT_SELF;
    object oUser = GetLastClosedBy();
    AssignCommand(oUser, ActionDoCommand(_dlgStart(oUser, oSelf, "", TRUE, TRUE)));
}
