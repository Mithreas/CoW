#include "nwnx_events"
#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"

void main()
{
    object item = StringToObject(NWNX_Events_GetEventData("ITEM_OBJECT_ID"));
    object target = StringToObject(NWNX_Events_GetEventData("TARGET_OBJECT_ID"));

    if (GetActionMode(OBJECT_SELF, ACTION_MODE_PARRY))
    {
        SetActionMode(OBJECT_SELF, ACTION_MODE_PARRY, FALSE);
        // Parry bonuses will be automatically removed in evt_mode_off.
    }
}
