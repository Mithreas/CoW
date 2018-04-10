/*
  Name: mi_secret
  Author: Mithreas
  Date: 26 July 09

  Description:
    Reads the MI_RESREF and MI_DC variables from this trigger, and locates the
    waypoint with tag WP_(tag), where (tag) is this trigger's tag.

    If the PC passes a search check against the specified DC, creates the
    placeable with the specified resref at the waypoint.  The object is given
    the tag SECRET_(tag), where (tag) is the tag of this trigger.

    If the waypoint or resref don't exist, does nothing.  If the DC is not
    specified, defaults to 30.

    Destroys the created object after 300s, and does nothing if the hidden
    object has already been spotted.

    If the MI_NIGHT_ONLY var is set, then the secret object cannot be found
    during the day in above-ground areas.
*/
void _cleanup(object oSecret)
{
  DestroyObject(oSecret);
  SetLocalInt(OBJECT_SELF, "MI_ACTIVE", FALSE);
}

void main()
{
  object oPC = GetEnteringObject();
  if (!GetIsPC(oPC)) return;

  object oSelf = OBJECT_SELF;
  int nActive = GetLocalInt(oSelf, "MI_ACTIVE");
  if (nActive) return;

  int nDC = GetLocalInt(oSelf, "MI_DC");
  if (!nDC) nDC = 30;
  string sResRef = GetLocalString(oSelf, "MI_RESREF");
  if (sResRef == "") return;

  int bNightOnly = GetLocalInt(oSelf,"MI_NIGHT_ONLY");
  if (bNightOnly && GetIsDay() && GetIsAreaAboveGround(GetArea(oSelf))) return;

  if (d20() + GetSkillRank(SKILL_SEARCH, oPC) < nDC) return;

  object oWP = GetWaypointByTag("WP_" + GetTag(oSelf));
  if (!GetIsObjectValid(oWP)) return;

  // All checks completed, now create our object.
  object oSecret = CreateObject(OBJECT_TYPE_PLACEABLE, sResRef,
                            GetLocation(oWP), FALSE, "SECRET_" + GetTag(oSelf));
  SetLocalInt(oSelf, "MI_ACTIVE", TRUE);

  AssignCommand(oSelf, DelayCommand(300.0, _cleanup(oSecret)));
}
