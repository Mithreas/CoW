#include "zzdlg_tools_inc"
void main()
{
    if (GetHasInventory(OBJECT_SELF))                      return;
    if (GetIsObjectValid(GetSittingCreature(OBJECT_SELF))) return;

    object oSelf = OBJECT_SELF;
    object oUser = GetLastUsedBy();

    AssignCommand(oUser, ActionDoCommand(_dlgStart(oUser, oSelf, "zz_co_fixture", TRUE, TRUE)));
}
