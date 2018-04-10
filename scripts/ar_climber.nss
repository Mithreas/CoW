// Do a climb check and jump to destination if successful
// DC is set by the AR_CLIMBING_DC variable
// Give the Tagged destination in AR_CLIMBING_DEST
// Set AR_CLIMB_FALL to TRUE (1) if a failure results into sending
// the player to the destination anyway, but with damage (E.g Climbing DOWN from something)
// AR_CLIMBING_DICES (Defaults 3) number of d6 dices to take as fall damage

//::  Extended from Mith's climbing system!


#include "fb_inc_names"
#include "mi_inc_climb"
void main()
{
  object oPC = GetLastUsedBy();
  // Allow NPCs to climb too.

  int nDC = GetLocalInt(OBJECT_SELF, "AR_CLIMBING_DC");
  string sTag = GetLocalString(OBJECT_SELF, "AR_CLIMBING_DEST");
  int isPitFall = GetLocalInt(OBJECT_SELF, "AR_CLIMB_FALL");
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

    location dest = GetLocation(GetObjectByTag(sTag));
    AssignCommand(oPC, ActionJumpToLocation(dest));
  }
  else
  {
    // Falling damage
    int nDices  = GetLocalInt(OBJECT_SELF, "AR_CLIMBING_DICES");
    if ( nDices <= 0) nDices = 3;
    int nDamage = d6(nDices);

    //::  No death on fall damage!
    if (nDamage >= GetCurrentHitPoints(oPC)) nDamage = GetCurrentHitPoints(oPC) - 1;

    ApplyEffectToObject(DURATION_TYPE_INSTANT,
                        EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING),
                        oPC);


    if ( isPitFall ) {
        location dest = GetLocation(GetObjectByTag(sTag));
        AssignCommand(oPC, ActionJumpToLocation(dest));
        DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oPC, 2.0));

        SendMessageToPC(oPC, "<cþ  >You fail to make the climb and fell down. Climbing is based " +
        "on your strength, dexterity, armour check penalty, and level in suitable " +
        "classes (barbarian, fighter, monk, ranger, rogue, assassin, arcane archer, " +
        "and harper scout).");

    }
    else {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oPC, 2.0);

        SendMessageToPC(oPC, "<cþ  >You fail to make the climb. Climbing is based " +
        "on your strength, dexterity, armour check penalty, and level in suitable " +
        "classes (barbarian, fighter, monk, ranger, rogue, assassin, arcane archer, " +
        "and harper scout).");
    }
  }
}
