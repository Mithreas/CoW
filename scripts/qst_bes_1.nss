/*
  Name: qst_bes_1
  Author: Mithreas
  Date: 5/5/18
  Description: Dog-follows-nice-PC-with-meat-until-left-with-whiny-man-with-no
  -meat-then-runs-away-and-thu-resets-the-quest-script.

  Framework:
    Needs a waypoint, with tag "WP_bessy". This marks where Bessy starts and
      finishes the quest (she can wander around in the area in the meantime).
    This script needs to go in Bessy's OnConv event handler.
    qst_bes_2 needs to go in OnEnter for a trigger by the whiny handler.
    qst_bes_3 needs to be the OnExit script for the area the handler is in.
    Bessy needs to have the variable "quest1name" set with the name of the
      quest, as used by the standard quest scripts.
    Bessy needs the tag "qst_bessy".
    A meat object needs to exist with tag "cnrAnimalMeat".
*/
void main()
{
  object oPC = GetLastSpeaker();
  object oBessy = OBJECT_SELF;

  object oMeat = GetItemPossessedBy(oPC, "cnrAnimalMeat");

  if (oMeat == OBJECT_INVALID)
  {
    FloatingTextStringOnCreature("Bessy sniffs at you a bit, then wanders off.", oPC, FALSE);
  }
  else
  {
    FloatingTextStringOnCreature("Bessy sniffs at you a bit, then starts following you!", oPC, FALSE);

    AddHenchman(oPC);
	ActionForceFollowObject(oPC);
  }
}
