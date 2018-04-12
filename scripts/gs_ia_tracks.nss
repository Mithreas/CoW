#include "inc_pc"
void main()
{
  object oPC = GetLastUsedBy();

  if ((GetLevelByClass(CLASS_TYPE_RANGER, oPC) + GetLocalInt(gsPCGetCreatureHide(oPC), "FL_BONUS_RGR_LEVELS") >= 3) || GetLocalInt(gsPCGetCreatureHide(oPC), "GVD_MAJORAWARD_TRACK") == 1)
  {
    SendMessageToPC(oPC, "You find the following tracks: " +
      GetLocalString(OBJECT_SELF, "MI_TRACKS"));
  }
  else
  {
     SendMessageToPC(oPC, "You can't tell anything from the tracks.");
  }
}
