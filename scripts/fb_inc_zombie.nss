/*
ZOMBIE SURVIVAL
fb_inc_zombie
By Fireboar

Have fun! The best April Fool's joke ever. :)
*/

const int FB_Z_LANGUAGE_ZOMBIE = 100;

#include "gs_inc_ambience"
#include "inc_spells"

// Returns TRUE if oObject is a zombie, otherwise FALSE.
int fbZGetIsZombie(object oObject);
// Returns the APPEARANCE_TYPE_ that oObject is normally (when not zombified).
int fbZGetNaturalAppearance(object oObject);
// Turns oObject into a zombie - it will always be the same model for the same
// object, but the model used is random.
void fbZMakeZombie(object oObject);
// Returns TRUE if oObject is a humanoid, FALSE otherwise.
int fbZGetZombieRace(object oObject);
// Apply the effects to turn oObject into a zombie.
void fbZZombieEffects(object oObject);
// Called when oObject dies. Make them into a zombie, or pend a respawn.
void fbZDied(object oObject);
// Returns one of a selection of suitably zombie-ish phrases.
string fbZTranslateZombie();
// Turns oVictim into a zombie on hit... slowly and painfully.
void fbZZombify(object oVictim, object oZombie);
// Dance. Dance like only zombies know how.
void fbZInitializeDance();

void _fbZZombify(object oZombie, int nDC = 10)
{
  object oSelf = OBJECT_SELF;
  effect eEffect = GetFirstEffect(oSelf);
  while (GetIsEffectValid(eEffect))
  {
    if (GetEffectType(eEffect) == EFFECT_TYPE_DISEASE)
    {
      break;
    }
    eEffect = GetNextEffect(oSelf);
  }
  // End if disease is gone
  if (!GetIsEffectValid(eEffect))
  {
    return;
  }

  int nSave = FortitudeSave(oSelf, nDC, SAVING_THROW_TYPE_DISEASE, oZombie);
  switch (nSave)
  {
    case 0:
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oSelf);
      break;
    case 1:
      DelayCommand(6.0, _fbZZombify(oZombie, nDC + 2));
      break;
    case 2:
      break;
  }
}
int fbZGetIsZombie(object oObject)
{
  object oStateObject = gsPCGetCreatureHide(oObject);
  if (!GetIsObjectValid(oStateObject))
  {
    oStateObject = oObject;
  }
  return GetLocalInt(oStateObject, "FB_Z_ZOMBIFIED");
}
int fbZGetNaturalAppearance(object oObject)
{
  if (fbZGetIsZombie(oObject))
  {
    return GetLocalInt(oObject, "FB_Z_APPEARANCE");
  }
  else
  {
    return GetAppearanceType(oObject);
  }
}
void fbZMakeZombie(object oObject)
{
  int nAppearance = GetAppearanceType(oObject);
  if (nAppearance == APPEARANCE_TYPE_ZOMBIE ||
   nAppearance == APPEARANCE_TYPE_ZOMBIE_ROTTING ||
   nAppearance == APPEARANCE_TYPE_ZOMBIE_TYRANT_FOG ||
   nAppearance == APPEARANCE_TYPE_ZOMBIE_WARRIOR_1 ||
   nAppearance == APPEARANCE_TYPE_ZOMBIE_WARRIOR_2)
  {
    return;
  }

  SetLocalInt(oObject, "FB_Z_APPEARANCE", nAppearance);

  int nType = GetLocalInt(oObject, "FB_Z_TYPE");
  if (!nType)
  {
    switch (Random(5))
    {
      case 0: nType = APPEARANCE_TYPE_ZOMBIE; break;
      case 1: nType = APPEARANCE_TYPE_ZOMBIE_ROTTING; break;
      case 2: nType = APPEARANCE_TYPE_ZOMBIE_TYRANT_FOG; break;
      case 3: nType = APPEARANCE_TYPE_ZOMBIE_WARRIOR_1; break;
      case 4: nType = APPEARANCE_TYPE_ZOMBIE_WARRIOR_2; break;
    }
    SetLocalInt(oObject, "FB_Z_TYPE", nType);
  }
  SetCreatureAppearanceType(oObject, nType);
}
int fbZGetZombieRace(object oObject)
{
  int nRace = GetRacialType(oObject);
  return (nRace <= 6 || (nRace >= 12 && nRace <= 15));
}
void fbZZombieEffects(object oObject)
{
  effect eBad = GetFirstEffect(oObject);
  while (GetIsEffectValid(eBad))
  {
    RemoveEffect(oObject, eBad);
    eBad = GetNextEffect(oObject);
  }

  ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectMovementSpeedDecrease(30)), oObject);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageReduction(10, DAMAGE_POWER_PLUS_THREE)), oObject);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectAttackIncrease(10)), oObject);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSpellFailure()), oObject);
  fbZMakeZombie(oObject);

  object oZombTemplate = GetObjectByTag("FB_Z_TEMPLATE");

  if (GetIsPC(oObject))
  {
    SetLocalInt(oObject, "GS_LI_LANGUAGE", FB_Z_LANGUAGE_ZOMBIE);
    AdjustReputation(oObject, oZombTemplate, -100);
  }
  else
  {
    ChangeFaction(oObject, oZombTemplate);
  }
  SetStandardFactionReputation(STANDARD_FACTION_COMMONER, 0, oObject);
  SetStandardFactionReputation(STANDARD_FACTION_DEFENDER, 0, oObject);
  SetStandardFactionReputation(STANDARD_FACTION_MERCHANT, 0, oObject);

  object oPC = GetFirstPC();
  while (GetIsObjectValid(oPC))
  {
    if (!fbZGetIsZombie(oPC))
    {
      SetPCDislike(oObject, oPC);
    }
    else
    {
      SetPCLike(oObject, oPC);
    }
    oPC = GetNextPC();
  }

  object oItem;
  int nI = 2; // Keep helmet, armour and creature items.
  for (; nI < 14; nI++)
  {
    oItem = GetItemInSlot(nI, oObject);
    if (GetIsObjectValid(oItem))
    {
      CopyItem(oItem, oObject, TRUE);
      DestroyObject(oItem);
    }
  }
}
void fbZRespawn(object oObject)
{
  gsAMSetAmbienceType(GS_AM_TYPE_SPECIAL_SHADOW_INTERIOR, GetArea(oObject));
  ApplyResurrection(oObject);
  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oObject) + 10), oObject);
  fbZZombieEffects(oObject);
}
void fbZDied(object oObject)
{
  if (fbZGetIsZombie(oObject))
  {
    DelayCommand(60.0, fbZRespawn(oObject));
  }
  else if (fbZGetZombieRace(oObject))
  {
    if (!GetIsPC(oObject))
    {
      AssignCommand(oObject, SurrenderToEnemies());
    }
    object oStateObject = gsPCGetCreatureHide(oObject);
    if (!GetIsObjectValid(oStateObject))
    {
      oStateObject = oObject;
    }
    SetLocalInt(oStateObject, "FB_Z_ZOMBIFIED", TRUE);
    DelayCommand(4.0, fbZRespawn(oObject));
  }
}
string fbZTranslateZombie()
{
  switch (Random(5))
  {
    case 0: case 1: return "Braiiinnsss...";
    case 2: return "Urrrg...";
    case 3: return "Unnng.";
    case 4: return "More braiiinsss...";
  }
  return "Urrrg...";
}
void fbZZombify(object oVictim, object oZombie)
{
  if (!fbZGetIsZombie(oZombie) || GetIsDM(oVictim))
  {
    return;
  }
  if (d10() < 7 && GetDistanceBetween(oVictim, oZombie) <= 2.0)
  {
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDisease(DISEASE_ZOMBIE_CREEP), oVictim, 60.0);
    AssignCommand(oVictim, _fbZZombify(oZombie));
  }
}
void _fbZDoDanceMove(int nType, float fDir)
{
  ClearAllActions();
  ActionDoCommand(SetFacing(fDir));
  switch (nType)
  {
    case 0: ActionPlayAnimation(ANIMATION_FIREFORGET_BOW, 0.5);         break;
    case 1: ActionPlayAnimation(ANIMATION_FIREFORGET_DODGE_DUCK, 0.25); break;
    case 2: ActionPlayAnimation(ANIMATION_FIREFORGET_SPASM, 0.125);     break;
    case 3: ActionPlayAnimation(ANIMATION_FIREFORGET_TAUNT, 0.5);       break;
    case 4: ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY1, 0.5);    break;
    case 5: ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY2, 0.5);    break;
    case 6: ActionPlayAnimation(ANIMATION_LOOPING_CONJURE1, 0.5, 4.0);  break;
    case 7: ActionPlayAnimation(ANIMATION_LOOPING_CONJURE2, 0.5, 4.0);  break;
  }
}
void fbZInitializeDance()
{
  object oSelf  = OBJECT_SELF;
  object oEnemy = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oSelf);
  if (GetDistanceBetween(oSelf, oEnemy) < 40.0)
  {
    FloatingTextStringOnCreature("Enough of this folly, there are brains to be eaten nearby.", oSelf, TRUE);
    return;
  }

  object oAlly  = GetNearestObject(OBJECT_TYPE_CREATURE, oSelf);
  int nNth      = 1;
  int nRandom   = Random(8);
  float fDir    = IntToFloat(Random(360));

  DelayCommand(1.0, _fbZDoDanceMove(nRandom, fDir));

  while (GetIsObjectValid(oAlly) && GetDistanceBetween(oSelf, oAlly) < 30.0)
  {
    DelayCommand(1.0, AssignCommand(oAlly, _fbZDoDanceMove(nRandom, fDir)));
    oAlly = GetNearestObject(OBJECT_TYPE_CREATURE, oSelf, ++nNth);
  }

  // Slight delay to account for lag.
  DelayCommand(1.5, ActionDoCommand(fbZInitializeDance()));
}
