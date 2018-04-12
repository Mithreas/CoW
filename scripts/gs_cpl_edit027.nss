#include "inc_placeable"
#include "inc_log"

void main()
{
    gsPLSaveArea(GetArea(OBJECT_SELF));
    DMLog(OBJECT_SELF, OBJECT_INVALID, "EditPermanentPlaceables(ApplySettingsPermanently)");
}
