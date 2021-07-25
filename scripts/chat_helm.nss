#include "inc_chatutils"
#include "inc_examine"
void main()
{
    object oSpeaker = OBJECT_SELF;
    string sParams =  chatGetParams(oSpeaker);
    if(sParams == "?" || sParams == "help")
    {
        DisplayTextInExamineWindow(chatCommandTitle("-helm"), "Toggles helmet or cloak display (use -cloak to toggle cloak).");
    }
    else if (FindSubString("cloak",sParams) == 0)
    {
        object oItem = GetItemInSlot(INVENTORY_SLOT_CLOAK, oSpeaker);
        if(GetIsObjectValid(oItem))
            SetHiddenWhenEquipped(oItem, !GetHiddenWhenEquipped(oItem));
    }
    else
    {
        object oItem = GetItemInSlot(INVENTORY_SLOT_HEAD, oSpeaker);
        if(GetIsObjectValid(oItem))
            SetHiddenWhenEquipped(oItem, !GetHiddenWhenEquipped(oItem));
    }

    chatVerifyCommand(oSpeaker);
}
