/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_enchant_anim
//
//  Desc:  This script animates the PC when crafting
//         at the enchanting altar.
//
//  Author: David Bobeck 10Mar03
//
/////////////////////////////////////////////////////////
void main()
{
  object oPC = GetLocalObject(OBJECT_SELF, "oCnrCraftingPC");

  if (GetIsPC(oPC))
  {
    // The animation delay should be set to the number of seconds it
    // takes to complete this animation.
    SetLocalFloat(oPC, "fCnrAnimationDelay", 3.0);
    int bSuccess = GetLocalInt(oPC, "bCnrCraftingResult");

    location locDevice = GetLocation(OBJECT_SELF);
    vector vDevice = GetPositionFromLocation(locDevice);
    vDevice.z = vDevice.z + 0.75;
    locDevice = Location(GetArea(OBJECT_SELF), vDevice, 0.0);
    effect eEnchant;
    if (bSuccess)
    {
      eEnchant = EffectVisualEffect(VFX_FNF_LOS_NORMAL_10, FALSE);
    }
    else
    {
      eEnchant = EffectVisualEffect(VFX_FNF_SMOKE_PUFF, FALSE);
    }
    DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eEnchant, locDevice));
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.0, 3.0));
    //PlaySound("as_cv_smithhamr1");
  }
}
