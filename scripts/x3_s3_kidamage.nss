// Custom breach effect for Weapon Masters.
// Removes all non-permanent effects from the target of type:
// AC increase
// DI increase
// Damage shield
// Deals 1 Magical damage per effect of the above types removed.
// All effects linked to the removed effect will also be removed.
//
// Called via NWNX Events - see setup in m_load.
#include "inc_generic"
#include "inc_state"
#include "nwnx_events"
#include "nwnx_object"
void BreachShields(object oTarget)
{
  effect eEffect = GetFirstEffect(oTarget);
  int nCount = 0;
  
  while (GetIsEffectValid(eEffect))
  {
    if ((GetEffectType(eEffect) == EFFECT_TYPE_AC_INCREASE ||
	     GetEffectType(eEffect) == EFFECT_TYPE_DAMAGE_IMMUNITY_INCREASE ||
		 GetEffectType(eEffect) == EFFECT_TYPE_ELEMENTALSHIELD) &&
		GetEffectDurationType(eEffect) == DURATION_TYPE_TEMPORARY)
	{
	  RemoveEffect(oTarget, eEffect);
	  nCount++;
	}
  
    eEffect = GetNextEffect(oTarget);
  }
  
  // Check for temp AC on armour.
  object oArmour = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);
  
  itemproperty ip = GetFirstItemProperty(oArmour);
  
  while (GetIsItemPropertyValid(ip))
  {
    if (GetItemPropertyType(ip) == ITEM_PROPERTY_AC_BONUS && 
	    GetItemPropertyDurationType(ip) == DURATION_TYPE_TEMPORARY)
	{
	  RemoveItemProperty(oArmour, ip);
	  nCount++;
	}
  
    ip = GetNextItemProperty(oArmour);
  }
  
  if (nCount)
  {
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectLinkEffects(
	  EffectDamage(nCount, DAMAGE_TYPE_MAGICAL),
	  EffectVisualEffect(VFX_IMP_MAGBLUE)), oTarget);
  }
}

void main()
{
  // Apparently the whitelist code isn't working, so do an explicit check here.
  if (StringToInt(NWNX_Events_GetEventData("FEAT_ID")) != FEAT_KI_DAMAGE) return;

  object oTarget = StringToObject(NWNX_Events_GetEventData("TARGET_OBJECT_ID"));
  
  if (GetIsObjectValid(oTarget) && 
      GetArea(oTarget) == GetArea(OBJECT_SELF) && 
	  GetDistanceBetween(oTarget, OBJECT_SELF) <= 10.0f) 
  {
	  BreachShields(oTarget);
	  
	  // Stamina cost.
	  int nWM = GetLevelByClass(CLASS_TYPE_WEAPON_MASTER, OBJECT_SELF);
	  gsSTDoCasterDamage(OBJECT_SELF, 50-5*nWM);
  }
  
  // Restore use of the feat.  Set to 2 because
  // - increment fails to work if you only have 1 level
  // - we're doing this before the feat fires so before the use is deducted, hence delay.
  DelayCommand (60.0f, IncrementRemainingFeatUses(OBJECT_SELF, 882));
  
  
}