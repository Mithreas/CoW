/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_caldron_anim
//
//  Desc:  This script animates the PC when they use
//         a caldron derived device.
//
//  Author: David Bobeck 21May03
//
/////////////////////////////////////////////////////////
void main()
{
  object oPC = GetLocalObject(OBJECT_SELF, "oCnrCraftingPC");

  if (GetIsPC(oPC))
  {
    // The animation delay should be set to the number of seconds it
    // takes to complete this animation.
    SetLocalFloat(oPC, "fCnrAnimationDelay", 9.0);
    int bSuccess = GetLocalInt(oPC, "bCnrCraftingResult");

    location locDevice = GetLocation(OBJECT_SELF);
    vector vDevice = GetPositionFromLocation(locDevice);
    vDevice.z = vDevice.z + 0.75;
    locDevice = Location(GetArea(OBJECT_SELF), vDevice, 0.0);
    effect eFire = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_FIRE, FALSE);
    effect ePuff = EffectVisualEffect(VFX_FNF_SMOKE_PUFF, FALSE);
    DelayCommand(0.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFire, locDevice));
    DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, ePuff, locDevice));
    DelayCommand(4.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFire, locDevice));
    DelayCommand(5.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, ePuff, locDevice));
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 2.0));
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_TALK_FORCEFUL, 1.0, 3.0));
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_LOOK_FAR, 1.0, 1.0));
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 2.0));
    if (bSuccess)
    {
      AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY2, 1.0));
    }
    else
    {
      AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD, 1.0));
    }
    //PlaySound("as_cv_mineshovl2");
  }
}

