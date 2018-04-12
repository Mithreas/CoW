#include "inc_encounter"
#include "inc_log"

void main()
{
    gsENSaveArea(GetArea(OBJECT_SELF));
    DMLog(OBJECT_SELF, OBJECT_INVALID, "EditAreaEncounters(ApplySettingsPermanently)");
}
