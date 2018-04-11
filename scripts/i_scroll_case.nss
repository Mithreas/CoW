// i_scroll_case
// Activation script of scroll cases.

#include "inc_holders"
#include "zzdlg_color_inc"

void main()
{
    // Targeted Item Activation Script
    object oItem       = GetItemActivated();
    object oActivator  = GetItemActivator();
    string sTag        = GetStringUpperCase(GetTag(oItem));
    object oTarget     = GetItemActivatedTarget();
    location lLocation = GetItemActivatedTargetLocation();


    if (oTarget == oActivator) {
        // start a zdlg with the scroll case
        SetLocalString(oActivator, "dialog", "zdlg_gvd_contain");
        SetLocalObject(oActivator, "gvd_container_conv", oItem);
        AssignCommand(oActivator, ActionStartConversation(oActivator, "zdlg_converse", TRUE, FALSE));
    } else {
        if (GetBaseItemType(oTarget) == BASE_ITEM_SPELLSCROLL && GetDroppableFlag(oTarget) == TRUE && GetItemCursedFlag(oTarget) == FALSE) {
        // store the item
            int iContainerSucces = gvd_Container_AddObject(oItem, oTarget);
            if (iContainerSucces == 1) {
                SendMessageToPC(oActivator, "You've put the scroll in the scroll case.");
            } else {
                if (iContainerSucces == 9) {
                    SendMessageToPC(oActivator, txtRed + "That item cannot be placed into this container.");
                } else {
                    SendMessageToPC(oActivator, txtRed + "The scroll case is full.");
                }
            }
        } else {
            // invalid target
            SendMessageToPC(oActivator, txtRed + "That item cannot be put in this scroll case.");
        }
    }
}
