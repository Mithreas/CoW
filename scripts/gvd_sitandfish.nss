string sDeny;
/*   Script generated by
Lilac Soul's NWN Script Generator, v. 2.3

For download info, please visit:
http://nwvault.ign.com/View.php?view=Other.Detail&id=4683&id=625    */

//Put this script OnUsed
void main()
{

object oPC = GetLastUsedBy();

if (!GetIsPC(oPC)) return;

if (GetTag(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) != "AR_IT_FISHINGPOLE")
   {
   sDeny="You must have a fishing pole equipped to fish.";

   SendMessageToPC(oPC, sDeny);

   return;
   }

AssignCommand(oPC, ClearAllActions());

ActionStartConversation(oPC, "c_fishing", TRUE, FALSE);

DelayCommand(1.0f, AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_SIT_CROSS,1.0f,3600.0f)));

}
