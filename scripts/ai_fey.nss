#include "inc_event"
#include "inc_behaviors"

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
    {
		// Check whether the creature carries a token from the Fairy Queen.
		object oPerceived = GetLastPerceived();
		if (GetLastPerceptionSeen() && GetIsPC(oPerceived) && 
			GetIsObjectValid(GetItemPossessedBy(oPerceived, "feytokenofpassag")))
		{
			SpeakString("You may pass, " + GetName(oPerceived));
			SetIsTemporaryFriend(oPerceived);
		}	

        break;
    }
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
    RunSpecialBehaviors(GetUserDefinedEventNumber());
}
