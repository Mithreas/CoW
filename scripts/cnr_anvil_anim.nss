/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_anvil_anim
//
//  Desc:  This script animates the PC when crafting
//         at the anvil.
//
//  Author: David Bobeck 26Jan03
//
/////////////////////////////////////////////////////////
void main()
{
  object oPC = GetLocalObject(OBJECT_SELF, "oCnrCraftingPC");

  if (GetIsPC(oPC))
  {
    // The animation delay should be set to the number of seconds it
    // takes to complete this animation.
    SetLocalFloat(oPC, "fCnrAnimationDelay", 4.0);
    int bSuccess = GetLocalInt(oPC, "bCnrCraftingResult");

    location locDevice = GetLocation(OBJECT_SELF);
    vector vDevice = GetPositionFromLocation(locDevice);
    vDevice.z = vDevice.z + 0.75;
    locDevice = Location(GetArea(OBJECT_SELF), vDevice, 0.0);
    effect eSparks = EffectVisualEffect(VFX_COM_SPARKS_PARRY, FALSE);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSparks, locDevice);
    DelayCommand(0.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSparks, locDevice));
    DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSparks, locDevice));
    DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSparks, locDevice));
    DelayCommand(2.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSparks, locDevice));
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_TALK_FORCEFUL, 1.0, 3.0));
    if (bSuccess)
    {
      AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY2, 1.0));
    }
    else
    {
      AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD, 1.0));
    }
    PlaySound("as_cv_smithhamr1");
  }
}
