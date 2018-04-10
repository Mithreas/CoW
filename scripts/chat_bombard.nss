#include "fb_inc_chat"
#include "fb_inc_chatutils"
#include "inc_examine"
#include "inc_dm"
#include "mi_log"

void main()
{
    if(!GetIsDM(OBJECT_SELF)) return;

    chatVerifyCommand(OBJECT_SELF);

    object oThisArea = GetArea(OBJECT_SELF);
    string sParams = chatGetParams(OBJECT_SELF);

    if(sParams == "?")
    {
      DisplayTextInExamineWindow(chatCommandTitle("-bombard") + " " + chatCommandParameter("[Params]"),
            "You type the command, and fireballs will rain down from the sky. The direction they fall in depends on which way you are facing when the function is called. \n"+
            "So they always originate from behind your avatar and fall towards the point you're facing. Fireballs do 100 + Random(200) / 3 magic damage,\n"+
            "reflex save negates, DC 50. One in every 20 projectiles will instead be a hellball which deals 100 + Random(200) magic damage, no save. \n"+
            "The fireballs will destroy fixtures and doors, and static placeables (or should). Those static placeables will only be visually gone if someone reloads the area.\n\n" +

            chatCommandTitle("-bombard") + " " + chatCommandParameter("debug") +
            "\nRemoves all bombardment placeables in case something bugs up.\n\n");
      return;
    }
    else if (sParams == "debug") {
      object oFirst = GetFirstObjectInArea(oThisArea);
      while(GetIsObjectValid(oFirst)) {
        if (GetResRef(oFirst) == "sep_bombard") {
          SetPlotFlag(oFirst, FALSE);
          DestroyObject(oFirst);
        }
        oFirst = GetNextObjectInArea(oThisArea);
      }
      DeleteLocalObject(oThisArea, "bombardObject");
      DMLog(OBJECT_SELF, oThisArea, "Bombardment debugged, all bombard placeables destroyed in area.");
      return;
    }

    object oBombarding = GetLocalObject(oThisArea, "bombardObject");
    object oPC = GetFirstPC();
    while (GetIsObjectValid(oPC)) {
      if (GetArea(oPC) == oThisArea) {
        if (oBombarding == OBJECT_INVALID) {
          SendMessageToPC(oPC, "There is a deafening crack as the region begins to be bombarded with projectiles. Run!");
          DMLog(OBJECT_SELF, oThisArea, "Bombarding area!!");
        }
        else {
          SendMessageToPC(oPC, "The bombardment in this region has ceased.");
          DMLog(OBJECT_SELF, oThisArea, "Bombardment ceased.");
        }
      }
      oPC = GetNextPC();
    }
    
    if (oBombarding == OBJECT_INVALID) {
      vector vLoc = Vector(0.0f, 0.0f, -10.0f);
      location lLoc = Location(oThisArea, vLoc, GetFacing(OBJECT_SELF));
      object oBombard = CreateObject(OBJECT_TYPE_PLACEABLE, "sep_bombard", lLoc);
      SetLocalObject(oThisArea, "bombardObject", oBombard);
      SetLocalFloat(oBombard, "fZPosition", GetPosition(OBJECT_SELF).z);
    }
    else {
      DestroyObject(oBombarding);
      DeleteLocalObject(oThisArea, "bombardObject");    
    }
}
