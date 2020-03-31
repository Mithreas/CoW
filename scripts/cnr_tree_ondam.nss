/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_tree_ondam
//
//  Desc:  When a tree is beaten, wood is produced.
//
//  Author: David Bobeck 26Jan03
//
/////////////////////////////////////////////////////////
#include "cnr_language_inc"
#include "cnr_config_inc"

void SpawnNewTree(string sTreeTag, location locTree)
{
  object oTree = CreateObject(OBJECT_TYPE_PLACEABLE, sTreeTag, locTree);
  SetLocalInt(oTree, "GS_STATIC", TRUE);
  DestroyObject(OBJECT_SELF);
}

void main()
{
  object oDamager = GetLastDamager();
  location locTree = GetLocation(OBJECT_SELF);
  string sTreeTag = GetTag(OBJECT_SELF);
  string sResref  = GetResRef(OBJECT_SELF);

  if (!GetIsObjectValid(oDamager) || !GetIsPC(oDamager))
  {
    return;
  }

  if (GetLocalInt(OBJECT_SELF, "CnrDamageBelowThreshold"))
  {
    return;
  }

  // the tree starts with 100 hit points or more
  if (GetCurrentHitPoints() < 80)
  {
    SetLocalInt(OBJECT_SELF, "CnrDamageBelowThreshold", TRUE);

    // Create a branch and have the PC pick it up.
    string sBranchTag = GetLocalString(GetModule(), sTreeTag + "_BranchTag");
    if (sBranchTag != "")
    {
      object oBranch = CreateObject(OBJECT_TYPE_ITEM, sBranchTag, GetLocation(oDamager));
      FloatingTextStringOnCreature(CNR_TEXT_YOU_HAVE_CHOPPED_OFF_A + GetName(oBranch) + "!", oDamager);
      AssignCommand(GetLastDamager(), ActionPickUpItem(oBranch));
    }

    // Sometimes the tree will get used up
    if (cnr_d100(1) <= CNR_FLOAT_WOOD_MINING_TREE_BREAKAGE_PERCENTAGE)
    {
      if (CNR_FLOAT_WOOD_MINING_TREE_RESPAWN_TIME_SECS > 0.0)
      {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), OBJECT_SELF);
        object oSpawner = CreateObject(OBJECT_TYPE_PLACEABLE, "cnrobjectspawner", locTree);
		SetLocalInt(oSpawner, "GS_STATIC", TRUE);
        AssignCommand(oSpawner, DelayCommand(CNR_FLOAT_WOOD_MINING_TREE_RESPAWN_TIME_SECS, SpawnNewTree(sResref, locTree)));
        DestroyObject(OBJECT_SELF, 2.0); // provide time for death effect
        FloatingTextStringOnCreature(CNR_TEXT_THATS_THE_END_OF_THAT, oDamager);
      }
      return;
    }

    // Create a new tree with full hitpoints
    DestroyObject(OBJECT_SELF);
    SetLocalInt(CreateObject(OBJECT_TYPE_PLACEABLE, sResref, locTree), "GS_STATIC", TRUE);
  }
}
