#include "gs_inc_combat"
#include "gs_inc_event"
#include "mi_inc_divinatio"

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

    if (GetIsPC(oAttacker)) miDVGivePoints(oAttacker, ELEMENT_FIRE, 0.2);

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
}
