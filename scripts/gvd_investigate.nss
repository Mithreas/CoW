void main()
{
  // check if PC has enough search
  int iSearchDC = GetLocalInt(OBJECT_SELF,"search_dc");
  object oPC = GetLastUsedBy();
  if (GetSkillRank(SKILL_SEARCH, oPC) >= iSearchDC) {
    // found something
    SendMessageToPC(oPC,"There is a hidden passage behind the boxes, you manage to find your way through the small crack in the rocks.");
    object oTarget = GetObjectByTag(GetLocalString(OBJECT_SELF,"target_location"));
    AssignCommand(oPC, ClearAllActions(TRUE));
    DelayCommand(2.0f, AssignCommand(oPC, JumpToLocation(GetLocation(oTarget))));

  } else {
    // found nothing
    switch (Random(4)) {
      case 0 : SendMessageToPC(oPC,"Everything looks normal."); break;
      case 1 : SendMessageToPC(oPC,"There's nothing unusual here."); break;
      case 2 : SendMessageToPC(oPC,"You look around carefully but don't see anything interesting."); break;
      case 3 :SendMessageToPC(oPC,"You soon get bored looking around."); break;
    }
  }

}
