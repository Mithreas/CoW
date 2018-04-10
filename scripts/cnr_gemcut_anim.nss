/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_gemcut_anim
//
//  Desc:  This script animates the PC when crafting
//         at the gem cutting stone.
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
    SetLocalFloat(oPC, "fCnrAnimationDelay", 3.0);
    int bSuccess = GetLocalInt(oPC, "bCnrCraftingResult");

    location locDevice = GetLocation(OBJECT_SELF);
    vector vDevice = GetPositionFromLocation(locDevice);
    vDevice.z = vDevice.z + 1.0;
    locDevice = Location(GetArea(OBJECT_SELF), vDevice, 0.0);
    effect eSparks = EffectVisualEffect(VFX_COM_SPARKS_PARRY, FALSE);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSparks, locDevice);
    DelayCommand(0.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSparks, locDevice));
    DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSparks, locDevice));
    DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSparks, locDevice));
    DelayCommand(2.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSparks, locDevice));
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_TALK_FORCEFUL, 1.0, 3.0));
    PlaySound("as_cv_chiseling2");
  }
}
