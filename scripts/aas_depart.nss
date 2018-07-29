#include "inc_awards"
#include "inc_external"
void _Drown(object oPC)
{
  AssignCommand(oPC, ClearAllActions());
  AssignCommand(oPC, ActionJumpToObject(GetObjectByTag("WATERY_GRAVE")));

  SendMessageToPC(oPC, "You get a little way out onto open water, then a large wave rises up out of nowhere and swallows your boat.  Death follows shortly thereafter.");
  
  // rewards
  gvd_DoRewards(oPC);

  // Delete character.
  fbEXDeletePC(oPC);
  SetCommandable(FALSE, oPC);
}

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
				if (GetLevelByClass(CLASS_TYPE_WIZARD, oObject) || GetLevelByClass(CLASS_TYPE_SORCERER, oObject))
 				{
				  _Drown(oObject);
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
