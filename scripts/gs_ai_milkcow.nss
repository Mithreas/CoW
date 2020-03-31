#include "inc_event"
#include "inc_time"

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
	{
	    int nMilk    = GetLocalInt(OBJECT_SELF, "COW_MILK_COUNT");
		int nTimeout = GetLocalInt(OBJECT_SELF, "COW_TIMEOUT");
				
		if (!nMilk && nTimeout < gsTIGetActualTimestamp())
		{
		  nMilk = d20();		    
		}
		
		if (!nMilk)
		{	    		  
          SpeakString("MooOOooo!");
		}
		else
		{
          CreateItemOnObject("mi_milk", GetLastSpeaker());
          SpeakString("Moo!");
		  nMilk--;
		  SetLocalInt(OBJECT_SELF, "COW_MILK_COUNT", nMilk);
		}

		if (!nMilk)
		{
		  // Set timeout for milk - 5 RL minutes.
		  SetLocalInt(OBJECT_SELF, "COW_TIMEOUT", gsTIGetActualTimestamp() + 60 * 5);
		}  		
//................................................................

        break;
    }
    case GS_EV_ON_DAMAGED:
//................................................................

        break;

    case GS_EV_ON_DEATH:
//................................................................

        break;

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

        break;

    case GS_EV_ON_RESTED:
//................................................................

        break;

    case GS_EV_ON_SPAWN:
//................................................................

        break;

    case GS_EV_ON_SPELL_CAST_AT:
//................................................................

        break;
    }
}
