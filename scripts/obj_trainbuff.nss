/*
  Name: obj_trainbuff
  Author: Mithreas
  Date: 22/01/06  (British date format... you know, ascending order? :))
  Description:
    Characters who have trained will get uses of this widget. It gives them a
    bonus of 2 to AB, AC and damage.
*/
#include "inc_database"
#include "x2_inc_switches"
#include "inc_log"
const string TRAINING = "TRAINING";
void main()
{
  if (GetUserDefinedItemEventNumber() != X2_ITEM_EVENT_ACTIVATE)
  { Trace(TRAINING, "Training buff object not activated"); return; }

  object oPC = GetItemActivator();
  string sName = GetName(oPC);
  int nNumOfUsesLeft = GetLocalInt(GetItemActivated(), "train_uses_" + sName);

  if (nNumOfUsesLeft <= 0)
  {
    SendMessageToPC(oPC, "You need to train more before you can use any more "
                         + "benefits.");
    return;
  }

  nNumOfUsesLeft--;
  SetLocalInt(GetItemActivated(), "train_uses_" + sName, nNumOfUsesLeft);

  effect eAttack = EffectAttackIncrease(2);
  effect eDamage = EffectDamageIncrease(2, DAMAGE_TYPE_BLUDGEONING);
  effect eLink = EffectLinkEffects(eAttack, eDamage);
  effect eAC = EffectACIncrease(2, AC_DODGE_BONUS);
  eLink = EffectLinkEffects(eLink, eAC);

  eLink = ExtraordinaryEffect(eLink);

  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(10));
}
