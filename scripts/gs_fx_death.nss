#include "inc_fixture"

void main()
{
    object oDamager = GetLastKiller();
    string sTag = GetTag(OBJECT_SELF);
    string sLeft = GetStringLeft(sTag, 13);

    //Peppermint, 1-14-2016; Updated to return associate owner to prevent exploits.
    if(GetIsObjectValid(GetMaster(oDamager)))
        oDamager = GetMaster(oDamager);

    Log(FIXTURES, "Fixture " + GetName(OBJECT_SELF) + " in area " +
     GetName(GetArea(OBJECT_SELF)) + " was destroyed by " + GetName(oDamager) + " (" + GetName(GetLastKiller()) + ")");

    gsFXDeleteFixture(GetTag(GetArea(OBJECT_SELF)));

    // dunshine: if the fixture is not a remains, then it will leave remains to be repaired
    // Batra: exception for this are explosives, which leave no reparable remains
    if((sLeft != "GS_FX_wt_astr") || 
    	(sLeft != "GS_FX_wt_corr") || 
    	(sLeft != "GS_FX_wt_cryo") || 
    	(sLeft != "GS_FX_wt_mesm") || 
    	(sLeft != "GS_FX_wt_powd") || 
    	(sLeft != "GS_FX_wt_tymp")) 
    {
    	gvdFXCreateRemains(OBJECT_SELF, oDamager);
    }
}

