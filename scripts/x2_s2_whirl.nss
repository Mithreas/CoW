/*
  x2_s2_whirl - Modified to work around the bug which freezes up movement when
  Whirlwind Attack / Improved Whirlwind Attack is used twice in succession on
  NWServer Linux.
*/

#include "inc_combat2"
#include "inc_time"

void main()
{
  object oPC     = OBJECT_SELF;
  int bImproved  = (GetSpellId() == 645);// improved whirlwind
  int nTimestamp = gsTIGetActualTimestamp();

  if (gsC2GetIsIncapacitated(oPC))
  {
    SendMessageToPC(oPC, "You can't do that in your current state!");
    return;
  }

  if (GetLocalInt(oPC, "X2_S2_WHIRL_TIMEOUT") > nTimestamp)
  {
    SendMessageToPC(oPC, "You must wait 10 seconds before using this ability again.");
    return;
  }

  SetLocalInt(oPC, "X2_S2_WHIRL_TIMEOUT", nTimestamp + 10);
  DelayCommand(10.0f, FloatingTextStringOnCreature("You can now use whirlwind again!", oPC));

  // * GZ, Sept 09, 2003 - Added dust cloud to improved whirlwind
  if (bImproved)
  {
    effect eVis = EffectVisualEffect(460);
    DelayCommand(1.0f,ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC));
  }

  DoWhirlwindAttack(TRUE, bImproved);
  // * make me resume combat

}

