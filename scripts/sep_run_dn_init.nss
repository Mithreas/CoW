// Used for NPCs who use the day/night scripts to lock their doors and secure their homes
// or shops.  See sep_run_daynight.
//
// Sends the correct signal to ensure the NPC starts in the right place, and builds a module wide list
// for NPCs to trigger at day/night transition. 
#include "inc_daynight"
#include "inc_event"
void main()
{
    object oShopkeep = OBJECT_SELF;
	
    if (GetTimeHour() > 6 && GetTimeHour() < 20)
    {
        DelayCommand(3.0, SignalEvent(oShopkeep, EventUserDefined(SEP_EV_ON_DAYPOST)));
    }
    else
    {
        DelayCommand(3.1, SignalEvent(oShopkeep, EventUserDefined(SEP_EV_ON_NIGHTPOST)));
    }
	
	DN_RegisterNPC(oShopkeep);
}
