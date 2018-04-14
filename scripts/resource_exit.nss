#include "inc_teleport"
void main()
{
  object oWP = GetNearestObjectByTag("WP_resource_exit");

  JumpAllToLocation(GetEnteringObject(), GetLocation(oWP));
}
