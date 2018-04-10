//////////////////////////////////////////////////////////
/*
   Item Appearance Modification Conversation
   Changes the appearance of the currently active armorpart
   on the tailor to the next available appearance
*/
// created/updated 2003-06-24 Georg Zoeller, Bioware Corp
//////////////////////////////////////////////////////////

#include "x2_inc_craft"
void main()
{
    object oPC = GetPCSpeaker();
    int nPart =  GetLocalInt(oPC,"X2_TAILOR_CURRENT_PART");
    object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

    if(GetIsObjectValid(oItem) == TRUE)
    {
        object oNew;
        AssignCommand(oPC,ClearAllActions(TRUE));
        int nColour = GetLocalInt(oItem, "MI_WPN_CURRENT_COLOUR");

        if (nColour == 0 || nColour == 1)
        {
          nColour = 4;
        }
        else
        {
          nColour--;
        }

        oNew = gsCMCopyItemAndModify(oItem,
                                     ITEM_APPR_TYPE_WEAPON_COLOR,
                                     nPart,
                                     nColour,
                                     TRUE);
        if (oNew != OBJECT_INVALID)
        {
          DestroyObject(oItem);
          AssignCommand(oPC, ActionEquipItem(oNew, INVENTORY_SLOT_RIGHTHAND));
          SetLocalInt(oNew, "MI_WPN_CURRENT_COLOUR", nColour);
        }
    }
}

