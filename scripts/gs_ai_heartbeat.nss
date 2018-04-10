#include "gs_inc_event"

void main()
{
    SignalEvent(OBJECT_SELF, EventUserDefined(GS_EV_ON_HEART_BEAT));
}