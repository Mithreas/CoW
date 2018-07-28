/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx & Hrnac
//
//  Name:  cnr_hide_anim
//
//  Desc:  This script animates the PC when crafting
//         at the hide rack.
//
//  Author: Gary Corcoran 05Aug03
//
/////////////////////////////////////////////////////////
void main()
{
  object oPC = GetLocalObject(OBJECT_SELF, "oCnrCraftingPC");

  if (GetIsPC(oPC))
  {
    // The animation delay should be set to the number of seconds it
    // takes to complete this animation.
    SetLocalFloat(oPC, "fCnrAnimationDelay", 5.0);
    int bSuccess = GetLocalInt(oPC, "bCnrCraftingResult");

    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 2.0));
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 1.0));
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 2.0));
    PlaySound("as_sw_clothcl1");
    DelayCommand(1.5, PlaySound("as_sw_clothlk1"));
    DelayCommand(3.0, PlaySound("as_sw_clothcl1"));
  }
}

