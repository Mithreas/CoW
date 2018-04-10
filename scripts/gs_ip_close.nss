#include "gs_inc_text"

void main()
{
    object oItem = GetFirstItemInInventory();
    if (oItem != OBJECT_INVALID)
    {
        object oUser = GetLastClosedBy();

        if (GetIsObjectValid(GetNextItemInInventory()))
            FloatingTextStringOnCreature(GS_T_16777232, oUser, FALSE);
        else {
            // addition by Dunshine, check for a container item, and treat this as being multiple items, so it can't be enchanted
            if (GetLocalInt(oItem,"gvd_container_item") > 0) {
              // container found
              FloatingTextStringOnCreature(GS_T_16777232, oUser, FALSE);
            } else {   
              ActionStartConversation(oUser, "", TRUE, FALSE); 
            }
        }
    }
}
