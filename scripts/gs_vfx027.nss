const string GS_TEMPLATE_STOOL = "gs_placeable272";
const string GS_TEMPLATE_SEAT  = "gs_placeable043";

void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

    location lLocation = GetLocation(OBJECT_SELF);

    CreateObject(OBJECT_TYPE_PLACEABLE, GS_TEMPLATE_STOOL, lLocation);
    CreateObject(OBJECT_TYPE_PLACEABLE, GS_TEMPLATE_SEAT,  lLocation);

    DestroyObject(OBJECT_SELF);
}
