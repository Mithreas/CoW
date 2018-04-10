const int GS_LIMIT = 500;

void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

    object oObject = GetFirstObjectInArea();

    while (GetIsObjectValid(oObject))
    {
        if (GetObjectType(oObject) == OBJECT_TYPE_PLACEABLE &&
            GetHasInventory(oObject) &&
            (GetStringLeft(GetTag(oObject), 13) == "GS_INVENTORY_" ||
             GetStringLeft(GetTag(oObject), 12) == "MI_RESOURCE_" ||
             GetStringLeft(GetTag(oObject), 13) == "GVD_MERCHANT_" ||
             GetStringLeft(GetTag(oObject), 13) == "GVD_STARTINV_"))
        {
            SetLocalInt(oObject, "GS_LIMIT", GS_LIMIT);
            ActionDoCommand(ExecuteScript("gs_co_open", oObject));
        }

        oObject = GetNextObjectInArea();
    }

    ActionDoCommand(DestroyObject(OBJECT_SELF));
}
