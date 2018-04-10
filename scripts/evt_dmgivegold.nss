#include "mi_log"
#include "nwnx_events"
#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"

void main()
{
    int gold = StringToInt(NWNX_Events_GetEventData("GOLD"));
    DMLog(OBJECT_INVALID, OBJECT_SELF, "GiveGold(" + IntToString(gold) + ")");
}
