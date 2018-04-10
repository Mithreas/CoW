/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_tinker_anim
//
//  Desc:  This script animates the PC when crafting
//         at the tinker's table.
//
//  Author: David Bobeck 02Feb03
//
/////////////////////////////////////////////////////////
void main()
{
  object oPC = GetLocalObject(OBJECT_SELF, "oCnrCraftingPC");

  if (GetIsPC(oPC))
  {
    // The animation delay should be set to the number of seconds it
    // takes to complete this animation.
    SetLocalFloat(oPC, "fCnrAnimationDelay", 6.0);
    int bSuccess = GetLocalInt(oPC, "bCnrCraftingResult");

    location locDevice = GetLocation(OBJECT_SELF);
    vector vDevice = GetPositionFromLocation(locDevice);
    vDevice.z = vDevice.z + 0.75;
    locDevice = Location(GetArea(OBJECT_SELF), vDevice, 0.0);
    effect eSparks = EffectVisualEffect(VFX_COM_SPARKS_PARRY, FALSE);
    effect ePuff = EffectVisualEffect(VFX_FNF_SMOKE_PUFF, FALSE);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSparks, locDevice);
    DelayCommand(0.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSparks, locDevice));
    DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSparks, locDevice));
    DelayCommand(1.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, ePuff, locDevice));
    DelayCommand(2.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSparks, locDevice));
    DelayCommand(3.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSparks, locDevice));
    DelayCommand(3.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, ePuff, locDevice));
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 2.0));
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 1.0));
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 2.0));
    if (bSuccess)
    {
      AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY2, 1.0));
    }
    else
    {
      AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD, 1.0));
    }
    PlaySound("al_mg_pillrlght1");
  }
}
