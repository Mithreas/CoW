/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_device_od
//
//  Desc:  This OnDisturbed handler is meant to fix a Bioware
//         bug that sometimes prevents placeables from
//         getting OnOpen or OnClose events. This OnDisturbed
//         handler in coordination with the OnUsed
//         ("cnr_device_ou") handler work around the bug.
//
//  Author: David Bobeck 06Apr03
//
/////////////////////////////////////////////////////////
void main()
{
  // We only want to start crafting if the PC added stuff. 
  if (GetInventoryDisturbType() == INVENTORY_DISTURB_TYPE_ADDED)
    SetLocalInt(OBJECT_SELF, "bCnrDisturbed", TRUE);
}
