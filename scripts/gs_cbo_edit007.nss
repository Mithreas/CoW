#include "gs_inc_boss"
#include "mi_log"

void main()
{
    gsBOSaveArea(GetArea(OBJECT_SELF));
    DMLog(OBJECT_SELF, OBJECT_INVALID, "EditBossEncounters(ApplySettingsPermanently)");
}
