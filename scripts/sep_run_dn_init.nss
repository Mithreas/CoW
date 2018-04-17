// Used for NPCs who use the day/night scripts to lock their doors and secure their homes
// or shops.  See sep_run_daynight.
#include "inc_event"
void main()
{
    if (GetTimeHour() > 6 && GetTimeHour() < 20)
    {
        DelayCommand(3.0, SignalEvent(OBJECT_SELF, EventUserDefined(SEP_EV_ON_DAYPOST)));
    }
    else
    {
        DelayCommand(3.1, SignalEvent(OBJECT_SELF, EventUserDefined(SEP_EV_ON_NIGHTPOST)));
    }
}
