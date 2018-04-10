#include "gvd_inc_rope"

void main()
{

  // this will trigger, when a PC that used a rope in a rope use trigger area
  // and clicked on this marker to target it. We can't use the gs_m_activate
  // for this, because the target is to far away if done targetted with the rope item
  // so it has to be a independent click on the placeable

  object oPC = GetPlaceableLastClickedBy();

  // clear all actions, to prevent the PC trying to use the possible unreachable placeable
  AssignCommand(oPC, ClearAllActions(FALSE));

  // see if the clicking PC is actually the rope user PC
  if (oPC == GetLocalObject(OBJECT_SELF, "gvd_rope_user")) {

    // first check if the PC still has a rope item in it's inventory
    object oRope = GetItemPossessedBy(oPC, "gvd_lasso"); 

    if (oRope != OBJECT_INVALID) {

      // double check the gvd_dest_marker variable from the source against this target

      // retrieve the gvd_tr_rope_area trigger where the PC is in from the local variable on the PC
      object oRopeArea = GetLocalObject(oPC, "gvd_rope_area");

      if (oRopeArea != OBJECT_INVALID) {
        // get the name of the variables for the destination markers from the trigger
        string sDestMarker = GetLocalString(oRopeArea,"gvd_dest_marker");

        if (GetLocalInt(OBJECT_SELF, sDestMarker) != 0) {
          // yes, valid target, make the lasso connection between the source and destination markers visible for the PCs to use

          // retrieve the source marker object from the trigger area, this was stored there in gs_m_activate with the lasso item
          object oSourceMarker = GetLocalObject(oRopeArea, "gvd_source_marker_object");

          // in case someone didn't use the lasso, but retrieved a lasso, he will be able to use the lasso points also, so make sure 
          // that we have a valid object here
          if (oSourceMarker == OBJECT_INVALID) {
            oSourceMarker = GetNearestObjectByTag("gvd_rope_marker", oRopeArea);
          }

          // check if there is no rope between these two markers yet
          string sSourceMarker = GetLocalString(OBJECT_SELF, "gvd_source_marker");

          // do this by checking if there is a variable with name equal to the value of the gvd_source_marker string variable from the target, on the source
          if (GetLocalInt(oSourceMarker, sSourceMarker) == 0) {        

            // do some animations and sound effects here
            vector vTarget = GetPosition(OBJECT_SELF);
            AssignCommand(oPC, ActionMoveToLocation(GetLocation(oSourceMarker)));
            AssignCommand(oPC, SetFacingPoint(vTarget));
            AssignCommand(oPC, PlaySound("as_cv_shipsail1"));
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE2, 1.0f, 3.0f));
        
            // check if the PCs Rope Use skill is high enough for the targets gvd_rope_dc
            int iRopeDC = GetLocalInt(OBJECT_SELF,"gvd_rope_dc");
            if (iRopeDC == 0) {
              // default 10
              iRopeDC = 10;
            }
            int iSkillRank = GetSkillRankRopeUse(oPC);
            if (iSkillRank >= iRopeDC) {
              // succes, feedback
              DelayCommand(2.5f, SendMessageToPC(oPC, StringToRGBString(GetName(oPC), "477") + StringToRGBString(" attempts a lasso throw towards " + GetName(OBJECT_SELF) + " : *succes* : (" + IntToString(iSkillRank) + " vs DC: " + IntToString(iRopeDC) + ")", "720")));

              // no connection yet, continue
              SetUseableFlag(oSourceMarker,TRUE);        

              // set a variable with the name of the source marker string value on the target to keep track of this rope connection between source and destination
              // the value of this variable also serves to set the DC for rope retrieval later on, which is set to the RopeUse skill rank of this PC
              int iSkillRank = GetSkillRankRopeUse(oPC);

              sSourceMarker = GetLocalString(oSourceMarker,"gvd_source_marker");
              SetLocalInt(OBJECT_SELF, sSourceMarker, iSkillRank);
  
              // and the other way around
              sSourceMarker = GetLocalString(OBJECT_SELF,"gvd_source_marker");
              SetLocalInt(oSourceMarker, sSourceMarker, iSkillRank);

              // keep track of the qty of ropes tied to these markers
              SetLocalInt(oSourceMarker,"gvd_qty_ropes", GetLocalInt(oSourceMarker,"gvd_qty_ropes") + 1);
              SetLocalInt(OBJECT_SELF,"gvd_qty_ropes", GetLocalInt(OBJECT_SELF,"gvd_qty_ropes") + 1);

              // delay the rest a bit, to sync with the animation time
              object oTargetMarker = OBJECT_SELF;
              DelayCommand(3.0f, ApplyRopeBetweenObjects(oPC, oSourceMarker, oTargetMarker));

            } else {
              // PC fails the rope use check
              DelayCommand(2.5f, SendMessageToPC(oPC, StringToRGBString(GetName(oPC), "477") + StringToRGBString(" attempts a lasso throw towards " + GetName(OBJECT_SELF) + " : *miss* : (" + IntToString(iSkillRank) + " vs DC: " + IntToString(iRopeDC) + ")", "720")));
              DelayCommand(3.0f, FloatingTextStringOnCreature("You try to swing the lasso to it's target, but it seems beyond your skills.", oPC));             
            }
      
          } else {
            // already a rope between these two markers
            FloatingTextStringOnCreature("*There already is a rope tied to this target", oPC);        

          }

        } else {
          // check if it's the source marker for this location
          if (GetLocalString(oRopeArea, "gvd_source_marker") == GetLocalString(OBJECT_SELF, "gvd_source_marker")) {
            // the PC clicked on the marker near him/her, obviously wanting to use it for climbing, not targetting the lasso

            // make sure the PC walks towards the rope marker
            location lSourceMarker = GetLocation(OBJECT_SELF);
            AssignCommand(oPC, ActionMoveToLocation(lSourceMarker));

            // now check if the marker has a rope at all
            if (GetLocalInt(OBJECT_SELF, "gvd_qty_ropes") > 0) {
              // start a zdlg with the PC listing all possible destinations from here, and an option to retrieve the lasso item
              SetLocalObject(oPC, "gvd_current_marker", OBJECT_SELF);
              SetLocalString(oPC, "dialog", "zdlg_gvd_lasso");
              AssignCommand(oPC, ActionStartConversation(oPC, "zdlg_converse", TRUE, FALSE));

            } else {
              // no ropes
              FloatingTextStringOnCreature("There is nothing your can do here without the help of a rope.", oPC);
            }

          } else {
            // invalid target
            FloatingTextStringOnCreature("You try to swing the lasso to it's target, but you fail.", oPC);
          }
        }
      }

    } else {
      // no more rope...
      FloatingTextStringOnCreature("You don't have any lassos left for this.", oPC);
    }

  } else {
    // the rope marker was not clicked as being a target of a rope user from another location, now check if it was clicked by a PC standing near it
    // and see if there are already ropes available (tied) to other locations for this PC to climb to

    // is the PC in the trigger area that is tied to this marker by the gvd_source_marker string variable on both
    object oRopeArea = GetLocalObject(oPC, "gvd_rope_area");    

    if (oRopeArea != OBJECT_INVALID) {

      if (GetLocalString(oRopeArea, "gvd_source_marker") == GetLocalString(OBJECT_SELF, "gvd_source_marker")) {
        // the PC clicked on the marker near him/her, obviously wanting to use it for climbing, not targetting the lasso

        // make sure the PC walks towards the rope marker
        location lSourceMarker = GetLocation(OBJECT_SELF);
        AssignCommand(oPC, ActionMoveToLocation(lSourceMarker));

        // now check if the marker has a rope at all
        if (GetLocalInt(OBJECT_SELF, "gvd_qty_ropes") > 0) {
          // start a zdlg with the PC listing all possible destinations from here, and an option to retrieve the lasso item
          SetLocalObject(oPC, "gvd_current_marker", OBJECT_SELF);
          SetLocalString(oPC, "dialog", "zdlg_gvd_lasso");
          AssignCommand(oPC, ActionStartConversation(oPC, "zdlg_converse", TRUE, FALSE));

        } else {
          // no ropes
          FloatingTextStringOnCreature("There is nothing your can do here without the help of a rope.", oPC);
        }

      } else {
        // PC has clicked on a marker from a distance, and it not wielding a lasso, so nothing to do here
      }

    }

  }

}
