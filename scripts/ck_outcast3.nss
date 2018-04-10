//::///////////////////////////////////////////////
//:: FileName ck_outcast3
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 2/13/2007 12:55:18 PM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

	// Make sure the PC speaker has these items in their inventory
	if(!HasItem(GetPCSpeaker(), "AR_ITEM_OUTCAST3"))
		return FALSE;

	return TRUE;
}
