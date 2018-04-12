#include "gs_inc_event"
void main()
{
    SetLocalInt(OBJECT_SELF, "sep_forceful", 1);
    if (GetTimeHour() > 6 && GetTimeHour() < 20)
    {
        DelayCommand(3.0, SignalEvent(OBJECT_SELF, EventUserDefined(SEP_EV_ON_DAYPOST)));
    }
    else
    {
        DelayCommand(3.1, SignalEvent(OBJECT_SELF, EventUserDefined(SEP_EV_ON_NIGHTPOST)));
    }
    DelayCommand(10.0, SetLocalInt(OBJECT_SELF, "sep_forceful", 0));
}
