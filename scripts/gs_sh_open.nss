#include "inc_shop"

void main()
{
    if (gsSHGetIsVacant(OBJECT_SELF)) return;

    object oPC = GetLastOpenedBy();

    if (gsSHGetIsOwner(OBJECT_SELF, oPC))
    {
        gsSHTouchWithNotification(OBJECT_SELF, oPC);
    }

    if (! GetLocalInt(OBJECT_SELF, "GS_ENABLED"))
    {
        gsSHLoad(OBJECT_SELF);
        SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);
    }
}
