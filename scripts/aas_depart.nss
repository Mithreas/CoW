#include "inc_caravan"
#include "inc_external"

void main()
{
    object oObject      = GetFirstObjectInArea(GetArea(OBJECT_SELF));

    // Get all players in vicinity of triggering player
    while(GetIsObjectValid(oObject))
	{
        int iIsPC           = GetIsPC(oObject);

        // Check Object is a Player
        if (iIsPC)
		{
            int iIsGoing        = GetLocalInt(oObject, "liTravelling");

            // If they're in the area near a boat, 'send em packing.
            if(iIsGoing)
			{			
			    // Check that they are not an arcanist!
				if (!miCACanSwim(oObject))
 				{
				  miCADrown(oObject);
			    }
				else
				{
                  AssignCommand(oObject, ClearAllActions(TRUE));
                  AssignCommand(oObject, JumpToObject(GetWaypointByTag("wp_highseas")));
				}  
            }
        }

        // Check next object in the area.
        oObject             = GetNextObjectInArea(GetArea(OBJECT_SELF));
    }
}
