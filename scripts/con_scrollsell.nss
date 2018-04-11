#include "inc_stacking"
int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oItem = GetItemPossessedBy(oPC, "i_scroll_case");
    if(!GetIsObjectValid(oItem))
    {
        oItem = GetFirstItemInInventory(oPC);

        while(GetIsObjectValid(oItem))
        {
            if(GetLocalString(oItem, NO_STACK_TAG) == "i_scroll_case")
            {
                SetLocalObject(oPC, "BULKSELLSCROLLCASE", oItem);
                break;
            }
            oItem = GetNextItemInInventory(oPC);
        }
    }
    if(GetIsObjectValid(oItem))
        return TRUE;

    return FALSE;
}
