/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_deposit_ou
//
//  Desc:  When a player uses a deposit (clay or sand),
//         they must possess a shovel. They will dig
//         something up (clay or sand) some % of the time.
//
//  Author: David Bobeck 03Feb03
//          09May03 re-coded to work like gem mining.
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"

void SpawnNewDiggableDeposit(string sDepositTag, location locDeposit)
{
  object oDep = CreateObject(OBJECT_TYPE_PLACEABLE, sDepositTag, locDeposit);
  SetLocalInt(oDep, "GS_STATIC", TRUE);
  DestroyObject(OBJECT_SELF);
}

void DoPostDiggingSuccessCheck(object oUser, location locUserAtStart, object oDeposit)
{
  DeleteLocalInt(oDeposit, "CnrStopRapidClicks");

  location locUser = GetLocation(oUser);
  if (locUser != locUserAtStart)
  {
    return;
  }

  object oMisc = OBJECT_INVALID;

  // chance of success
  if (cnr_d100(1) <= CNR_FLOAT_MISC_MINING_DEPOSIT_CHANCE_OF_SUCCESS_PERCENTAGE)
  {
    string sDepositTag = GetTag(oDeposit);
    string sMiscTag = GetLocalString(GetModule(), sDepositTag + "_MiscTag");
    if (sMiscTag != "")
    {
      oMisc = CreateObject(OBJECT_TYPE_ITEM, sMiscTag, locUser);
      FloatingTextStringOnCreature(CNR_TEXT_YOU_DUG_UP_A + GetName(oMisc), oUser);

      ActionPickUpItem(oMisc);
    }
  }
  else
  {
    ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD, 1.0);
    string sFloat;
    int nFloat = d6(1);
    if (nFloat == 1)      {sFloat = CNR_TEXT_DEPOSIT_MUMBLE_1;}
    else if (nFloat == 2) {sFloat = CNR_TEXT_DEPOSIT_MUMBLE_2;}
    else if (nFloat == 3) {sFloat = CNR_TEXT_DEPOSIT_MUMBLE_3;}
    else if (nFloat == 4) {sFloat = CNR_TEXT_DEPOSIT_MUMBLE_4;}
    else if (nFloat == 5) {sFloat = CNR_TEXT_DEPOSIT_MUMBLE_5;}
    else if (nFloat == 6) {sFloat = CNR_TEXT_DEPOSIT_MUMBLE_6;}
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

  object oShovel = CnrGetItemByTag("cnrShovel", oUser);
  if (oShovel == OBJECT_INVALID)
  {
    FloatingTextStringOnCreature(CNR_TEXT_YOU_MUST_POSSESS_A_SHOVEL + GetName(OBJECT_SELF), oUser);
    SetLocalInt(OBJECT_SELF, "CnrStopRapidClicks", FALSE);
    return;
  }

  // there's a chance the shovel may break
  if (cnr_d100(1) <= CNR_FLOAT_MISC_MINING_DEPOSIT_SHOVEL_BREAKAGE_PERCENTAGE)
  {
    DestroyObject(oShovel);
    FloatingTextStringOnCreature(CNR_TEXT_YOU_HAVE_BROKEN_YOUR_SHOVEL, oUser);
    SetLocalInt(OBJECT_SELF, "CnrStopRapidClicks", FALSE);
    return;
  }

  location locDeposit = GetLocation(OBJECT_SELF);
  string sDepositTag = GetTag(OBJECT_SELF);

  // Sometimes the deposit will get used up
  if (cnr_d100(1) <= CNR_FLOAT_MISC_MINING_DEPOSIT_BREAKAGE_PERCENTAGE)
  {
    if (CNR_FLOAT_MISC_MINING_DEPOSIT_RESPAWN_TIME_SECS > 0.0)
    {
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), OBJECT_SELF);
      object oSpawner = CreateObject(OBJECT_TYPE_PLACEABLE, "cnrobjectspawner", locDeposit);
	  SetLocalInt(oSpawner, "GS_STATIC", TRUE);
      AssignCommand(oSpawner, DelayCommand(CNR_FLOAT_MISC_MINING_DEPOSIT_RESPAWN_TIME_SECS, SpawnNewDiggableDeposit(sDepositTag, locDeposit)));
      DestroyObject(OBJECT_SELF, 0.5); // provide time for death effect
      FloatingTextStringOnCreature(CNR_TEXT_THATS_THE_END_OF_THAT, oUser);
    }
    SetLocalInt(OBJECT_SELF, "CnrStopRapidClicks", FALSE);
    return;
  }

  AssignCommand(oUser, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 3.0));
  PlaySound("as_cv_mineshovl1");

  location locUser = GetLocation(oUser);
  AssignCommand(oUser, DelayCommand(3.0, DoPostDiggingSuccessCheck(oUser, locUser, oDeposit)));
}

