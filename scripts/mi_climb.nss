// Do a climb check and jump to destination if successful
// DC is set by the MI_CLIMBING_DC variable
// Destination is nearest waypoint with tag MI_CLIMBING_DEST
//
#include "inc_names"
#include "inc_climb"
void main()
{
  object oPC = GetEnteringObject();
  // Allow NPCs to climb too.

  int nDC = GetLocalInt(OBJECT_SELF, "MI_CLIMBING_DC");
  if (!nDC) nDC = 30;

  // See if the PC is getting help.
  object oHelper = GetLocalObject(oPC, "MI_CL_HELPER");

  if (!GetIsObjectValid (oHelper) || GetDistanceBetween(oPC, oHelper) > 5.0f)
  {
    oHelper = OBJECT_INVALID;
  }
  else
  {
    FloatingTextStringOnCreature(fbNAGetGlobalDynamicName(oHelper) + " helps you with the climb.", oPC);
  }

  int nArmorCheckPenalty = miCBGetArmorCheckPenalty(oPC);
  int nHelperBonus = GetIsObjectValid(oHelper) ?
                        (miCBGetClimbBonus(oHelper) - miCBGetArmorCheckPenalty(oHelper)) :
                        0;
  int nSuccess = (d20() + miCBGetClimbBonus(oPC) - nArmorCheckPenalty + nHelperBonus) >= nDC;



  // Move PC back and/or damage them, if necessary.
  if (nSuccess)
  {
    SendMessageToPC(oPC, "<c þ >You successfully make the climb.");

    location dest = GetLocation(GetNearestObjectByTag("MI_CLIMBING_DEST"));
    AssignCommand(oPC, ActionJumpToLocation(dest));
  }
  else if (GetIsSkillSuccessful(oPC, SKILL_TUMBLE, nDC))
  {
    SendMessageToPC(oPC, "<cþ  >You fail to make the climb (DC " + IntToString(nDC) + ") but tumble safely to the ground.");
  }
  else
  {
    // Falling damage
    int nDamage = d6(3);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,
                        EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING),
                        oPC);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oPC, 2.0);

    SendMessageToPC(oPC, "<cþ  >You fail to make the climb (DC " + IntToString(nDC) + "). Climbing is based " +
    "on your strength, dexterity, armour check penalty, and level in suitable " +
    "classes (barbarian, fighter, monk, ranger, rogue, assassin, arcane archer, " +
    "and harper scout).");
  }
}
