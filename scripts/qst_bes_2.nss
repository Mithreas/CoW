/*
  Name: qst_bes_2
  Author: Mithreas
  Date: 5/5/18
  Description: Dog-follows-nice-PC-with-meat-until-left-with-whiny-man-with-no
  -meat-then-runs-away-and-thu-resets-the-quest-script.

  Framework:
    Needs a waypoint, with tag "WP_bessy". This marks where Bessy starts and
      finishes the quest (she can wander around in the area in the meantime).
    qst_bes_1 needs to go in Bessy's OnConv event handler.
    This script needs to go in OnEnter for a trigger by the whiny handler.
    qst_bes_3 needs to be the OnExit script for the area the handler is in.
    Bessy needs to have the variable "quest1name" set with the name of the
      quest, as used by the standard quest scripts.
    Bessy needs the tag "qst_bessy".
    A meat object needs to exist with tag "cnrAnimalMeat".
*/
void main()
{
  object oBessy = GetEnteringObject();
  if (GetTag(oBessy) == "qst_bessy")
  {
    object oPC = GetMaster(oBessy);
    RemoveHenchman(oPC, oBessy);

    string sQuestVarName = GetLocalString(oBessy, "quest1name");
    int nQuestVal = GetLocalInt(oPC, sQuestVarName);
    nQuestVal++;
    SetLocalInt(oPC, sQuestVarName, nQuestVal);
  }
}
