#include "inc_teleport"
void main()
{
  // If the entering PC has a token from Elakadencia, allow them passage.
  // Put a string var DEST_WP on this object with the target tag.
  object oPC = GetEnteringObject();

  if (GetIsDM(oPC) || GetIsDMPossessed(oPC) ||
      (GetIsPC(oPC) && GetIsObjectValid(GetItemPossessedBy(oPC, "feytokenofpassag"))))
  {
     object oWaypoint = GetWaypointByTag(GetLocalString(OBJECT_SELF, "DEST_WP"));
	 AssignCommand(oPC, ClearAllActions());
     JumpAllToObject(oPC, oWaypoint);
  }
}