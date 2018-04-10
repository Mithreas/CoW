//////////////////////////////////////////////////////////
/*
   Item Appearance Modification Conversation
   Cycle next part
   Changes the appearance of the currently active armorpart
   on the tailor to the next available appearance
*/
//  created/updated 2003-06-24 Georg Zoeller, Bioware Corp
//////////////////////////////////////////////////////////

#include "x2_inc_craft"
void main()
{
    object oPC = GetPCSpeaker();
    int nPart =  GetLocalInt(oPC,"X2_TAILOR_CURRENT_PART");
    object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

    int nCurrentAppearance;

    if(GetIsObjectValid(oItem) == TRUE)
    {
        object oNew;
        AssignCommand(oPC,ClearAllActions(TRUE));
        oNew = IPGetModifiedWeapon(oItem, nPart, X2_IP_WEAPONTYPE_NEXT, TRUE);
        AssignCommand(oPC, ActionEquipItem(oNew, INVENTORY_SLOT_RIGHTHAND));
    }
}
