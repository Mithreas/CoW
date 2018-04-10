#include "mi_log"
#include "nwnx_events"
#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"

void main()
{
    int oldExp = StringToInt(NWNX_Events_GetEventData("OLD_EXP"));
    int newExp = StringToInt(NWNX_Events_GetEventData("NEW_EXP"));
    DMLog(OBJECT_INVALID, OBJECT_SELF, "GiveExperience(" + IntToString(newExp - oldExp) + ")");
}
