/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_gempol_anim
//
//  Desc:  This script animates the PC when crafting
//         at the gem polishing table.
//
//  Author: David Bobeck 10Feb03
//
/////////////////////////////////////////////////////////
void main()
{
  object oPC = GetLocalObject(OBJECT_SELF, "oCnrCraftingPC");

  if (GetIsPC(oPC))
  {
    // The animation delay should be set to the number of seconds it
    // takes to complete this animation.
    SetLocalFloat(oPC, "fCnrAnimationDelay", 8.0);
    int bSuccess = GetLocalInt(oPC, "bCnrCraftingResult");

    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 3.0));
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_TIRED, 1.0, 1.0));
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 3.0));
    if (bSuccess)
    {
      AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY3, 1.0));
    }
    else
    {
      AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD, 1.0));
    }
    PlaySound("as_cv_ropepully1");
    DelayCommand(4.0, PlaySound("as_cv_ropepully1"));
  }
}
