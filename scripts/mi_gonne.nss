// mi_gonne
// Needs its own script so we can call TouchAttackRanged.
#include "mi_inc_scry"
void main()
{
  object oShooter = OBJECT_SELF;
  object oTarget  = GetLocalObject (oShooter, "GONNE_TARGET");

  // Check for no-PVP zone
  if (GetIsReactionTypeFriendly(oTarget))
  {
    SendMessageToPC(oShooter, "You can't shoot someone in a no PvP zone!");
    return;
  }

  // Remove invisibility and sanctuary.
  miSCRemoveInvis(oShooter);

  // 5% chance of ammunition exploding.
  if (d20() == 1)
  {
    FloatingTextStringOnCreature("*** Misfire! ***", oShooter);
    ActionCastSpellAtObject(SPELL_COMBUST,
                            oShooter,
                            METAMAGIC_ANY,
                            TRUE,
                            0,
                            PROJECTILE_PATH_TYPE_DEFAULT,
                            TRUE);
    return;
  }

  FloatingTextStringOnCreature("*** Bang! ***", oShooter);

  // Roll to hit.  Touch attack; Gonnes really don't care about armour.
  int nHit = TouchAttackRanged(oTarget);

  if (!nHit) return; // Miss

  // Damage
  int nDamage = (nHit == 1) ? d6(30) : d6(60);

  // Reducing the gonne's utility in blowing up epic treasure chests and bypassing traps.
  if (GetTag(oTarget) == "GS_ARMOR_UNIQUE" ||
      GetTag(oTarget) == "GS_TREASURE_UNIQUE" ||
      GetTag(oTarget) == "GS_WEAPON_UNIQUE")
        nDamage = d6(10);

  ApplyEffectToObject(DURATION_TYPE_INSTANT,
                      EffectDamage(nDamage, DAMAGE_TYPE_PIERCING, DAMAGE_POWER_NORMAL),
                      oTarget);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                      EffectVisualEffect(VFX_DUR_ARROW_IN_STERNUM),
                      oTarget,
                      1.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                      EffectVisualEffect(VFX_FNF_SMOKE_PUFF),
                      oShooter,
                      1.0);

}
