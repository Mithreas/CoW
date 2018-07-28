/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_gemdep_ou
//
//  Desc:  When a player uses a mineral deposit,
//         they must be equipped with a gem crafter's
//         chisel. They will dig something up 20% of
//         the time.
//
//  Author: David Bobeck 02Mar03
//
/////////////////////////////////////////////////////////
#include "cnr_config_inc"
#include "cnr_language_inc"

void SpawnNewGemDeposit(string sDepositTag, location locDeposit)
{
  CreateObject(OBJECT_TYPE_PLACEABLE, sDepositTag, locDeposit);
  DestroyObject(OBJECT_SELF);
}

void DoPostChiselingSuccessCheck(object oUser, location locUserAtStart, object oDeposit)
{
  DeleteLocalInt(oDeposit, "CnrStopRapidClicks");

  location locUser = GetLocation(oUser);
  if (locUser != locUserAtStart)
  {
    return;
  }

  object oMineral1 = OBJECT_INVALID;
  object oMineral2 = OBJECT_INVALID;
  object oMineral3 = OBJECT_INVALID;

  // chance of success
  if (cnr_d100(1) <= CNR_FLOAT_GEM_MINING_FIND_FIRST_MINERAL_PERCENTAGE)
  {
    string sDepositTag = GetTag(oDeposit);
    string sMineralTag = GetLocalString(GetModule(), sDepositTag + "_MineralTag");
    if (sMineralTag != "")
    {
      oMineral1 = CreateObject(OBJECT_TYPE_ITEM, sMineralTag, locUser);
      FloatingTextStringOnCreature(CNR_TEXT_YOU_CHISELED_OFF_A + GetName(oMineral1) + "!", oUser);

      if (cnr_d100(1) <= CNR_FLOAT_GEM_MINING_FIND_SECOND_MINERAL_PERCENTAGE)
      {
        oMineral2 = CreateObject(OBJECT_TYPE_ITEM, sMineralTag, locUser);
        FloatingTextStringOnCreature(CNR_TEXT_AND_A_SECOND + GetName(oMineral2) + "!", oUser);
      }

      if (cnr_d100(1) <= CNR_FLOAT_GEM_MINING_FIND_MYSTERY_MINERAL_PERCENTAGE)
      {
        oMineral3 = CreateObject(OBJECT_TYPE_ITEM, "cnrGemMineral000", locUser);
        FloatingTextStringOnCreature(CNR_TEXT_AND_A + GetName(oMineral3) + "!", oUser);
      }

      ActionPickUpItem(oMineral1);

      if (oMineral2 != OBJECT_INVALID)
      {
        ActionPickUpItem(oMineral2);
      }

      if (oMineral3 != OBJECT_INVALID)
      {
        ActionPickUpItem(oMineral3);
      }
    }
  }
  else
  {
    ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD, 1.0);
    //FloatingTextStringOnCreature("You failed to find anything in the deposit.", oUser);
    string sFloat;
    int nFloat = d6(1);
    if (nFloat == 1)      {sFloat = CNR_TEXT_GEMDEP_MUMBLE_1;}
    else if (nFloat == 2) {sFloat = CNR_TEXT_GEMDEP_MUMBLE_2;}
    else if (nFloat == 3) {sFloat = CNR_TEXT_GEMDEP_MUMBLE_3;}
    else if (nFloat == 4) {sFloat = CNR_TEXT_GEMDEP_MUMBLE_4;}
    else if (nFloat == 5) {sFloat = CNR_TEXT_GEMDEP_MUMBLE_5;}
    else if (nFloat == 6) {sFloat = CNR_TEXT_GEMDEP_MUMBLE_6;}
    DelayCommand(1.0, FloatingTextStringOnCreature(sFloat, oUser));
    DelayCommand(2.0, DoPlaceableObjectAction(oDeposit, PLACEABLE_ACTION_USE));
  }
}

void main()
{
  int bStopRapidClicks = GetLocalInt(OBJECT_SELF, "CnrStopRapidClicks");
  if (bStopRapidClicks == TRUE) return;
  SetLocalInt(OBJECT_SELF, "CnrStopRapidClicks", TRUE);

  object oDeposit = OBJECT_SELF;
  object oUser = GetLastUsedBy();

  int bValidTool = FALSE;
  object oChisel = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oUser);
  if (oChisel != OBJECT_INVALID)
  {
    if (GetTag(oChisel) == "cnrGemChisel")
    {
      bValidTool = TRUE;
    }
  }

  if (bValidTool == FALSE)
  {
    oChisel = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oUser);
    if (oChisel != OBJECT_INVALID)
    {
      if (GetTag(oChisel) == "cnrGemChisel")
      {
        bValidTool = TRUE;
      }
    }
  }

  if (!bValidTool)
  {
    FloatingTextStringOnCreature(CNR_TEXT_YOU_MUST_HOLD_A_CHISEL, oUser);
    SetLocalInt(OBJECT_SELF, "CnrStopRapidClicks", FALSE);
    return;
  }

  // there's a chance the chisel may break
  if (cnr_d100(1) <= CNR_FLOAT_GEM_MINING_CHISEL_BREAKAGE_PERCENTAGE)
  {
    DestroyObject(oChisel);
    FloatingTextStringOnCreature(CNR_TEXT_YOU_HAVE_BROKEN_YOUR_CHISEL, oUser);
    SetLocalInt(OBJECT_SELF, "CnrStopRapidClicks", FALSE);
    return;
  }

  location locDeposit = GetLocation(OBJECT_SELF);
  string sDepositTag = GetTag(OBJECT_SELF);

  // Sometimes the deposit will get used up
  if (cnr_d100(1) <= CNR_FLOAT_GEM_MINING_DEPOSIT_BREAKAGE_PERCENTAGE)
  {
    if (CNR_FLOAT_GEM_MINING_DEPOSIT_RESPAWN_TIME_SECS > 0.0)
    {
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), OBJECT_SELF);
      object oSpawner = CreateObject(OBJECT_TYPE_PLACEABLE, "cnrobjectspawner", locDeposit);
      AssignCommand(oSpawner, DelayCommand(CNR_FLOAT_GEM_MINING_DEPOSIT_RESPAWN_TIME_SECS, SpawnNewGemDeposit(sDepositTag, locDeposit)));
      DestroyObject(OBJECT_SELF, 0.5); // provide time for death effect
      FloatingTextStringOnCreature(CNR_TEXT_THATS_THE_END_OF_THAT, oUser);
    }
    SetLocalInt(OBJECT_SELF, "CnrStopRapidClicks", FALSE);
    return;
  }

  AssignCommand(oUser, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 3.0));
  DelayCommand(1.0, PlaySound("as_cv_chiseling2"));

  location locUser = GetLocation(oUser);
  AssignCommand(oUser, DelayCommand(3.0, DoPostChiselingSuccessCheck(oUser, locUser, oDeposit)));
}

