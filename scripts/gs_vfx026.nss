#include "gs_inc_container"
const string GS_TEMPLATE_OBJECT = "gs_placeable268";

void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

    object oObject = CreateObject(OBJECT_TYPE_PLACEABLE,
                                  GS_TEMPLATE_OBJECT,
                                  GetLocation(OBJECT_SELF));
    /*
    if (GetIsObjectValid(oObject))
    {
        ExecuteScript("gs_co_open", oObject);
        SetLocalObject(GetModule(), "GS_BANISHMENT", oObject);
    }

    DestroyObject(OBJECT_SELF);

    // Added by Mithreas - print all banned CD keys to logfile.
    // Banned CD keys start at 54.
    // Souls have tags GS_BA_CDKEY so we need to substring them from char 6.
    int nStartNum = 54;

    object oSoul = GetFirstItemInInventory(oObject);

    while (GetIsObjectValid(oSoul))
    {
      WriteTimestampedLogEntry(IntToString(nStartNum) + "=" +
        GetSubString(GetTag(oSoul), 6, GetStringLength(GetTag(oSoul)) - 6));
      nStartNum++;
      oSoul = GetNextItemInInventory(oObject);
    }  */
}
