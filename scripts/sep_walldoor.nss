void main()
{
    int nOpenState = GetLocalInt(OBJECT_SELF, "nOpenState");
    string sWaypoint = GetLocalString(OBJECT_SELF, "Target");

    object wpt = GetWaypointByTag(sWaypoint);
    object oUser = GetLastUsedBy();

    location wpt_loc = GetLocation(wpt);

    if (!nOpenState)
        {
            // play animation of user opening it
            AssignCommand(oUser, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID));
            DelayCommand(1.0, ActionPlayAnimation(ANIMATION_PLACEABLE_OPEN));
            SetLocalInt(OBJECT_SELF, "nOpenState", 1);
        }
        else
        {
            // it's open -- go through and then close
            AssignCommand(oUser, ClearAllActions());
            AssignCommand(oUser, ActionJumpToLocation(wpt_loc));
            ActionPlayAnimation(ANIMATION_PLACEABLE_CLOSE);
            DeleteLocalInt(OBJECT_SELF, "nOpenState");
        }

}
