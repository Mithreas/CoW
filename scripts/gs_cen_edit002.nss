#include "gs_inc_encounter"
#include "mi_log"

void main()
{
    gsENSaveArea(GetArea(OBJECT_SELF));
    DMLog(OBJECT_SELF, OBJECT_INVALID, "EditAreaEncounters(ApplySettingsPermanently)");
}
