// Trigger events on the NPC at sunrise and sunset.
#include "inc_event"
void main()
{
    int nTime = GetTimeHour();
	
	// Use nSignal to avoid triggering the event multiple times in the hour.
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
