/*
  Hidden transition, activated only on a successful Search check.
  The searcher, and any party members within 10m, are jumped to
  the destination waypoint on success.

  DEST_WP: The transition destination waypoint
  SEARCH_DC: The DC of the search check
*/

void main()
{
  object oPC = GetEnteringObject();
  if (!GetIsPC(oPC) && !GetIsDM(oPC) && !GetIsDMPossessed(oPC))
  {
    return;
  }

  int nDC        = GetLocalInt(OBJECT_SELF, "SEARCH_DC");
  string sDestWP = GetLocalString(OBJECT_SELF, "DEST_WP");

  if (GetIsSkillSuccessful(oPC, SKILL_SEARCH, nDC))
  {
    object oCreature = GetFirstFactionMember(oPC, TRUE);

    while (GetIsObjectValid(oCreature))
    {
      if (oCreature == oPC ||
          (GetArea(oPC) == GetArea(oCreature) && GetDistanceBetween(oCreature, oPC) < 10.0f))
      {
        AssignCommand(oPC, ActionJumpToObject(GetWaypointByTag(sDestWP)));
      }

      oCreature = GetNextFactionMember(oPC, TRUE);
    }
  }
}