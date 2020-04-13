/*
  Name: qst_bes_3
  Author: Mithreas
  Date: 5/5/18
  Description: Dog-follows-nice-PC-with-meat-until-left-with-whiny-man-with-no
  -meat-then-runs-away-and-thus-resets-the-quest-script.

  Framework:
    Needs a waypoint, with tag "WP_bessy". This marks where Bessy starts and
      finishes the quest (she can wander around in the area in the meantime).
    qst_bes_1 needs to go in Bessy's OnConv event handler.
    qst_bes_2 needs to go in OnEnter for a trigger by the whiny handler.
    This script needs to be the OnExit script for the area the handler is in.
    Bessy needs to have the variable "quest1name" set with the name of the
      quest, as used by the standard quest scripts.
    Bessy needs the tag "qst_bessy".
    A meat object needs to exist with tag "cnrAnimalMeat".
*/
void main()
{
  object oBessy = GetObjectByTag("qst_bessy");
  object oWP    = GetObjectByTag("WP_bessy");

  if (GetArea(oBessy) != GetArea(oWP))
  {
    // We have a wolf, who's come home. And doesn't want to be there.  Run away!
    location lLoc = GetLocation(oWP);
    AssignCommand(oBessy, JumpToLocation(lLoc));
  }
  else
  {
    // no effect
  }
  
  ExecuteScript("a_exit", OBJECT_SELF);
}
