void main()
{

  // delete local variables on PC leaving a rope use area
  object oPC = GetExitingObject();

  if (GetIsPC(oPC) == TRUE) {

    // check if there are any target markers from this locations still visible with no ropes tied to them, if so, make them unuseable again
    object oRopeArea = OBJECT_SELF;  
    object oArea = GetArea(OBJECT_SELF);

    string sDestMarker = GetLocalString(oRopeArea,"gvd_dest_marker");
    string sSourceMarker = GetLocalString(oRopeArea,"gvd_source_marker");

    // loop through all gvd_rope_marker placeables
    int iRopeMarker = 0;

    object oRopeMarker = GetObjectByTag("gvd_rope_marker", iRopeMarker);
    while (oRopeMarker != OBJECT_INVALID) {

      // same area?
      if (GetArea(oRopeMarker) == oArea) {

        // belongs to the destination markers for this trigger?
        if (GetLocalInt(oRopeMarker, sDestMarker) == 1) {

          // is the leaving PC the one that reveiled the target?
          if (GetLocalObject(oRopeMarker, "gvd_rope_user") == oPC) {

            // yes, no more ropes?
            if (GetLocalInt(oRopeMarker,"gvd_qty_ropes") == 0) {

              SetUseableFlag(oRopeMarker,FALSE);

            }

            // clean up the rope user PC object variable on the target marker
            DeleteLocalObject(oRopeMarker,"gvd_rope_user");

          } else {
            // other PCs leaving the trigger shouldn't interfere
          }
                
        } else {
          // nope, check if it's the source marker for this trigger area
          if (GetLocalString(oRopeMarker, "gvd_source_marker") == sSourceMarker) {
            // yes, no more ropes?
            if (GetLocalInt(oRopeMarker,"gvd_qty_ropes") == 0) {
              SetUseableFlag(oRopeMarker,FALSE);
            }

            // clean up the rope user PC object variable (if any) on the source marker
            DeleteLocalObject(oRopeMarker,"gvd_rope_user");
          }

        }
      } else {
        // different area, do not handle it here
      }

      // next rope marker
      iRopeMarker = iRopeMarker + 1;            
      oRopeMarker = GetObjectByTag("gvd_rope_marker", iRopeMarker);

    }
      
    // clean up
    DeleteLocalInt(oPC,"gvd_rope_use");
    DeleteLocalObject(oPC,"gvd_rope_area");  

  } 

}
