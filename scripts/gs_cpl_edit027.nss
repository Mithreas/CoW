#include "gs_inc_placeable"
#include "mi_log"

void main()
{
    gsPLSaveArea(GetArea(OBJECT_SELF));
    DMLog(OBJECT_SELF, OBJECT_INVALID, "EditPermanentPlaceables(ApplySettingsPermanently)");
}
