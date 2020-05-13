#include "inc_combat"
#include "inc_event"
#include "inc_divination"
const int ITEM_PROPERTY_BOOMERANG = 14; // From 2da

void DoBoomerang(object oAttacker)
{
  object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oAttacker);
  int nType = GetBaseItemType (oWeapon);
  
  if (nType != BASE_ITEM_DART && nType != BASE_ITEM_SHURIKEN && nType != BASE_ITEM_THROWINGAXE) return;
  
  itemproperty iprp = GetFirstItemProperty(oWeapon);
  
  while (GetIsItemPropertyValid(iprp))
  {
    if (GetItemPropertyType(iprp) == ITEM_PROPERTY_BOOMERANG)
	{
	  SetItemStackSize(oWeapon, 99);
	  SetPlotFlag(oWeapon, TRUE); // avoid selling shenanigans
	  break;
	}
  
    iprp = GetNextItemProperty(oWeapon);
  }
}

void main()
{
    SignalEvent(OBJECT_SELF, EventUserDefined(GS_EV_ON_PHYSICAL_ATTACKED));

    object oAttacker = GetLastAttacker();
	
	if (!gsCBGetHasAttackTarget())
	{
	  if (d100() > 75 && GetAbilityModifier(ABILITY_INTELLIGENCE, OBJECT_SELF) >= -2)
	  {
	    PlayVoiceChat(VOICE_CHAT_ENEMIES);
	  }
	  else	  
	  {
	    switch (d3())
		{
		  case 1:
		    PlayVoiceChat(VOICE_CHAT_PAIN1);
			break;
		  case 2:
		    PlayVoiceChat(VOICE_CHAT_PAIN2);
			break;
		  case 3:
		    PlayVoiceChat(VOICE_CHAT_PAIN3);
			break;
		}	
	  }
	}

    if (fbZGetIsZombie(oAttacker) && Random(2))
    {
      fbZZombify(OBJECT_SELF, oAttacker);
    }

    if (gsCBGetHasAttackTarget())
    {
        object oTarget = gsCBGetLastAttackTarget();

        if (oAttacker != oTarget &&
            (gsCBGetIsFollowing() ||
             GetDistanceToObject(oAttacker) <=
             GetDistanceToObject(oTarget) + 5.0))
        {
            gsCBDetermineCombatRound(oAttacker);
        }
    }
    else
    {
        gsCBDetermineCombatRound(oAttacker);
    }
	
	// Workaround for Boomerang throwing weapons.
	DoBoomerang(oAttacker);
}
