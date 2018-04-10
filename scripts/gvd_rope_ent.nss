void main()
{

  // set local variable on PC entering to flag him/her as in a rope use area
  object oPC = GetEnteringObject();

  if (GetIsPC(oPC) == TRUE) {

    // set variable to know PC is inside rope use area
    SetLocalInt(oPC,"gvd_rope_use",1);

    // store the trigger object on the PC as well, so we can pull variables from it later
    SetLocalObject(oPC, "gvd_rope_area", OBJECT_SELF);

    // any hint text for this trigger?
    string sHint = GetLocalString(OBJECT_SELF,"gvd_hinttext");

    if (sHint != "") {
      FloatingTextStringOnCreature(sHint, oPC);
    } else {
      // if there are no 100% hint texts, we use the Search/Spot skills of the PC entering to see if it detects the possibility for lasso use here

      // get the DC for the trigger
      int iDetectDC = GetLocalInt(OBJECT_SELF,"gvd_detect_dc");
      if (iDetectDC == 0) {
        // default to 10
        iDetectDC = 10;
      }

      // do the detect check (no d20 added in here to make it compatible with the lasso destination detection in gs_m_activate)
      if ((GetSkillRank(SKILL_SPOT, oPC) >= iDetectDC) || (GetSkillRank(SKILL_SEARCH, oPC) >= iDetectDC)) {
        // PC deteced possible use of lasso here
        FloatingTextStringOnCreature("You found a location to use your lasso nearby", oPC);
      }

    }

  }

}
