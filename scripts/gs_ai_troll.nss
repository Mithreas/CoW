#include "inc_achievements"
#include "inc_event"

void main()
{
    switch (GetUserDefinedEventNumber())
    {
    case GS_EV_ON_BLOCKED:
//................................................................

        break;

    case GS_EV_ON_COMBAT_ROUND_END:
//................................................................

        break;

    case GS_EV_ON_CONVERSATION:
//................................................................

        break;

    case GS_EV_ON_DAMAGED:
//................................................................
        if (GetImmortal(OBJECT_SELF))
        {
           if (GetDamageDealtByType(DAMAGE_TYPE_FIRE) > 0 ||
             GetDamageDealtByType(DAMAGE_TYPE_ACID) > 0)
           {
             SetImmortal(OBJECT_SELF, FALSE);
           }
        }

        break;

    case GS_EV_ON_DEATH:
//................................................................
    {
	  if (GetResRef(OBJECT_SELF) == "fey_troll")
	  {
		int nNth = 1;
		object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, OBJECT_SELF, nNth);
		
		while (GetIsObjectValid(oPC) && GetDistanceBetween(oPC, OBJECT_SELF) <= 35.0f)
		{
		    acAwardAchievement(oPC, "billygoat");
			nNth++;
			oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, OBJECT_SELF, nNth);
		}
      }
	  
      break;
    }
    case GS_EV_ON_DISTURBED:
//................................................................

        break;

    case GS_EV_ON_HEART_BEAT:
//................................................................
        ExecuteScript("gs_run_ai", OBJECT_SELF);

        break;

    case GS_EV_ON_PERCEPTION:
//................................................................

        break;

    case GS_EV_ON_PHYSICAL_ATTACKED:
//................................................................
        if (GetImmortal(OBJECT_SELF))
        {
          object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, GetLastAttacker());
          int nValue;

          if (GetIsObjectValid(oItem))
          {
            itemproperty ipProperty = GetFirstItemProperty(oItem);

            while (GetIsItemPropertyValid(ipProperty) && GetImmortal(OBJECT_SELF))
            {
              if (GetItemPropertyDurationType(ipProperty) == DURATION_TYPE_TEMPORARY)
              {
                switch (GetItemPropertyType(ipProperty))
                {

                  case ITEM_PROPERTY_ONHITCASTSPELL:
                    nValue = GetItemPropertySubType(ipProperty);

                    if (nValue == IP_CONST_ONHIT_CASTSPELL_ONHIT_DARKFIRE ||
                        nValue == IP_CONST_ONHIT_CASTSPELL_ONHIT_FIREDAMAGE)
                    {
                      SetImmortal(OBJECT_SELF, FALSE);
                    }

                    break;
                }
              }

              ipProperty = GetNextItemProperty(oItem);
            }
          }
        }

        break;

    case GS_EV_ON_RESTED:
//................................................................

        break;

    case GS_EV_ON_SPAWN:
//................................................................
        // Trolls are marked Immortal on spawn until damaged with fire or acid.
        SetImmortal(OBJECT_SELF, TRUE);

        break;

    case GS_EV_ON_SPELL_CAST_AT:
//................................................................

        break;
    }
}
