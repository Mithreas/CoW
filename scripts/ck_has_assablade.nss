//::///////////////////////////////////////////////
//:: FileName ck_has_curvedblade
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 9/28/2005 1:42:31 AM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

    // Make sure the PC speaker has these items in their inventory
    if(!HasItem(GetPCSpeaker(), "IR_CURVEDBLADE"))
        return FALSE;

    return TRUE;
}
