//::///////////////////////////////////////////////
//:: mj_ai_projimag
//:://////////////////////////////////////////////
/*
    On-User defined AI script for project_image.
    Slightly different then the nw_ch_acd and the
    x0_ch_hen_usrdef so that we can have bettter
    control on Stealth/Detect modes on the
    project_image clones.
*/
//:://////////////////////////////////////////////
//:: Created By: Miesny_Jez
//:: Created On: November 18, 2017
//:://////////////////////////////////////////////
#include "inc_behaviors"
#include "X0_INC_HENAI"
#include "x2_inc_spellhook"

void main()
{
	int nEvent = GetUserDefinedEventNumber();

	if (nEvent == 20000 + ACTION_MODE_DETECT)
	{
    	int bDetect = GetActionMode(GetMaster(), ACTION_MODE_DETECT);
		SetActionMode(OBJECT_SELF, ACTION_MODE_DETECT, bDetect);
    }

    
    
    RunSpecialBehaviors(nEvent);	
}
