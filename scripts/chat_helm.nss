#include "inc_chatutils"
#include "inc_examine"
void main()
{
    object oSpeaker = OBJECT_SELF;
    string sParam =  chatGetParams(oSpeaker);
    if(sParam == "?" || sParam == "help")
    {
        DisplayTextInExamineWindow(chatCommandTitle("-helm"), "Toggles helmet display.");
    }
    else
    {
        object oItem = GetItemInSlot(INVENTORY_SLOT_HEAD, oSpeaker);
        if(GetIsObjectValid(oItem))
            SetHiddenWhenEquipped(oItem, !GetHiddenWhenEquipped(oItem));
    }

    chatVerifyCommand(oSpeaker);
}
