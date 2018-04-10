/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_minbath_ou
//
//  Desc:  This is the OnUsed handler for Mineral Baths.
//         Mystery minerals found in its inventory are
//         converted to known gem minerals.
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
#include "cnr_language_inc"

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

  object oUser = GetLastUsedBy();

  string sMineralTag = "cnrGemMineral001";
  object oItem = GetFirstItemInInventory(OBJECT_SELF);
  while (oItem != OBJECT_INVALID)
  {
    if (GetTag(oItem) == "cnrGemMineral000")
    {
      // mystery minerals don't stack
      DestroyObject(oItem);

      int nRand = Random(133)+1;
      if (nRand == 1) {sMineralTag = "cnrGemMineral012";}                           // 1
      else if ((nRand >= 2) && (nRand <= 3)) {sMineralTag = "cnrGemMineral006";}    // 2
      else if ((nRand >= 4) && (nRand <= 6)) {sMineralTag = "cnrGemMineral005";}    // 3
      else if ((nRand >= 7) && (nRand <= 10)) {sMineralTag = "cnrGemMineral009";}   // 4
      else if ((nRand >= 11) && (nRand <= 15)) {sMineralTag = "cnrGemMineral008";}  // 5
      else if ((nRand >= 16) && (nRand <= 23)) {sMineralTag = "cnrGemMineral010";}  // 8
      else if ((nRand >= 24) && (nRand <= 32)) {sMineralTag = "cnrGemMineral013";}  // 9
      else if ((nRand >= 33) && (nRand <= 43)) {sMineralTag = "cnrGemMineral011";}  // 10
      else if ((nRand >= 44) && (nRand <= 55)) {sMineralTag = "cnrGemMineral015";}  // 11
      else if ((nRand >= 56) && (nRand <= 67)) {sMineralTag = "cnrGemMineral003";}  // 12
      else if ((nRand >= 68) && (nRand <= 90)) {sMineralTag = "cnrGemMineral004";}  // 13
      else if ((nRand >= 91) && (nRand <= 113)) {sMineralTag = "cnrGemMineral014";} // 13
      else if ((nRand >= 114) && (nRand <= 127)) {sMineralTag = "cnrGemMineral002";}// 14
      else if ((nRand >= 128) && (nRand <= 141)) {sMineralTag = "cnrGemMineral007";}// 14
      else {sMineralTag = "cnrGemMineral001";}                                      // 14
      //                                                                            //----
      //                                                                            //133
      object oMineral = CreateItemOnObject(sMineralTag, oUser, 1);
      string sFloat;
      int nFloat = d3(1);
      switch (nFloat)
      {
        case 1: {sFloat = CNR_TEXT_MINBATH_MUMBLE_1 + GetName(oMineral); break;}
        case 2: {sFloat = CNR_TEXT_MINBATH_MUMBLE_2 + GetName(oMineral); break;}
        default: {sFloat = CNR_TEXT_MINBATH_MUMBLE_3 + GetName(oMineral); break;}
      }
      FloatingTextStringOnCreature(sFloat, oUser, FALSE);
    }
    oItem = GetNextItemInInventory(OBJECT_SELF);
  }
}
