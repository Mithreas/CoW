#include "inc_flag"

void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

    string sFlag = GetTag(OBJECT_SELF);
    sFlag        = GetStringRight(sFlag, GetStringLength(sFlag) - 6);

    gsFLSetAreaFlag(sFlag);

    DelayCommand(3.0, DestroyObject(OBJECT_SELF));
}
