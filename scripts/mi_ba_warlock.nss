// Turns the PC into a warlock.  Muahaha.
#include "inc_warlock"
void main()
{
  object oWarlock = OBJECT_SELF;
  object oPC = GetPCSpeaker();
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD), oPC, 3.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_AURA_PULSE_RED_ORANGE), oPC, 3.0);

  // Delay coz it will force a relog.
  AssignCommand(oPC,
                DelayCommand(3.0,
                             miWATurnIntoWarlock(oPC, GetLocalInt(oWarlock, "MI_WA_PACT"))
                            )
                );
}
