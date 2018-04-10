// mi_jump_check
// Called from gs_chat when a player uses -climb. they get placed in the new
// position and then have to make a skill check. If they fail, they may take
// damage and may end up back where they started depending on the relative
// heights of the two locations.
#include "mi_inc_climb"
#include "__server_config"
void main()
{
  object oPC = OBJECT_SELF;
  location lStartLocation = GetLocalLocation(oPC, "MI_STARTING_LOCATION");
  location lEndLocation = GetLocation(oPC);
  vector vOldPos = GetPositionFromLocation(lStartLocation);
  vector vNewPos = GetPosition(oPC);

  /*
  SendMessageToPC(oPC, "Start location:" +
                       "\n  X=" + FloatToString(vOldPos.x) +
                       "\n  Y=" + FloatToString(vOldPos.y) +
                       "\n  Z=" + FloatToString(vOldPos.z));

  SendMessageToPC(oPC, "End location:" +
                       "\n  X=" + FloatToString(vNewPos.x) +
                       "\n  Y=" + FloatToString(vNewPos.y) +
                       "\n  Z=" + FloatToString(vNewPos.z));
  */
  // Make the check.
  int nSuccess = FALSE;

  int nArmorCheckPenalty = miCBGetArmorCheckPenalty(oPC);

  nSuccess = (d20() + miCBGetClimbBonus(oPC) - nArmorCheckPenalty) >= CLIMBING_DC;

  // Move PC back and/or damage them, if necessary.
  if (nSuccess)
  {
    SendMessageToPC(oPC, "<c þ >You successfully make the climb.");
  }
  else
  {
    float fDifference = vOldPos.z - vNewPos.z;

    if (fDifference > 0.0)
    {
      // PC was going down. Give them falling damage.
      int nDamage = d6(FloatToInt(fDifference)/5);
      ApplyEffectToObject(DURATION_TYPE_INSTANT,
                          EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING),
                          oPC);
    }
    else if (fDifference < 0.0)
    {
      // PC was going up. Give falling damage (but less) and return them to
      // their start location.
      int nDamage = d6(FloatToInt(fDifference)/10);
      ApplyEffectToObject(DURATION_TYPE_INSTANT,
                          EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING),
                          oPC);
      AssignCommand(oPC, ClearAllActions());
      AssignCommand(oPC, JumpToLocation(lStartLocation));
    }
    else
    {
      // Two points at the same level - e.g. jumping over a fence. No falling
      // damage but go back to where you started.
      AssignCommand(oPC, ClearAllActions());
      AssignCommand(oPC, JumpToLocation(lStartLocation));
    }

    //SetCommandable(FALSE, oPC); // So people can't run through the teleport
    //DelayCommand(0.1, SetCommandable(TRUE, oPC));
    DelayCommand(0.15, AssignCommand(oPC,
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oPC, 2.0)));

    SendMessageToPC(oPC, "<cþ  >You fail to make the climb. Climbing is based " +
    "on your strength, dexterity, armour check penalty, and level in suitable " +
    "classes (barbarian, fighter, monk, ranger, rogue, assassin, arcane archer, " +
    "and harper scout).");
  }

  DeleteLocalInt(oPC, "MI_CLIMBING"); // reset so we can climb more.
  SetCutsceneMode(oPC, FALSE);
}
