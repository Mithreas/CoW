#include "sep_inc_event"
void main()
{
    string sDay = GetLocalString(OBJECT_SELF, "DAY_TAG");
    string sNight = GetLocalString(OBJECT_SELF, "NIGHT_TAG");

    if (sDay != "" || sNight != "")
    {
        int nTime = GetTimeHour();
        int nSignal = GetLocalInt(OBJECT_SELF, "nSignal");
        if (nTime == 6 && nSignal == 0)
        {
			AssignCommand(OBJECT_SELF, ClearAllActions());
            SignalEvent(OBJECT_SELF, EventUserDefined(SEP_EV_ON_DAYPOST));
            SetLocalInt(OBJECT_SELF, "nSignal", 1);
            DelayCommand(365.0, SetLocalInt(OBJECT_SELF, "nSignal", 0));
        }
        else if (nTime == 20 && nSignal == 0)
        {
			AssignCommand(OBJECT_SELF, ClearAllActions());
            SignalEvent(OBJECT_SELF, EventUserDefined(SEP_EV_ON_NIGHTPOST));
            SetLocalInt(OBJECT_SELF, "nSignal", 1);
            DelayCommand(365.0, SetLocalInt(OBJECT_SELF, "nSignal", 0));
        }
    }
}
