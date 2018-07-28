/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_trashcan_ou
//
//  Desc:  This is the OnUsed handler for trash
//         cans. Items placed into the trash evaporate.
//
//         This OnUsed handler is meant to fix a Bioware
//         bug that sometimes prevents placeables from
//         getting OnOpen or OnClose events. This OnUsed
//         handler in coordination with the OnDisturbed
//         ("cnr_device_od") handler work around the bug.
//
//  Author: David Bobeck 07Apr03
//
/////////////////////////////////////////////////////////
void main()
{
  // Note: A placeable will receive events in the following order...
  // OnOpen, OnUsed, OnDisturbed, OnClose, OnUsed.
  if (GetLocalInt(OBJECT_SELF, "bCnrDisturbed") != TRUE)
  {
    // Skip if the contents have not been altered.
    return;
  }

  SetLocalInt(OBJECT_SELF, "bCnrDisturbed", FALSE);

  // If the Bioware bug is in effect, simulate the closing
  if (GetIsOpen(OBJECT_SELF))
  {
    AssignCommand(OBJECT_SELF, ActionPlayAnimation(ANIMATION_PLACEABLE_CLOSE));
  }

  object oItem = GetFirstItemInInventory(OBJECT_SELF);
  while (oItem != OBJECT_INVALID)
  {
    DestroyObject(oItem);
    oItem = GetNextItemInInventory(OBJECT_SELF);
  }
}
