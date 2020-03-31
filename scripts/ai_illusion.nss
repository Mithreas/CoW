// Illusion AI script.  
// Sets the illusion flag for the main combat script.  If an illusion is reduced below 
// 25% hit points, it vanishes (and drops loot).
#include "inc_event"
#include "inc_xp"
//----------------------------------------------------------------
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
        if (GetCurrentHitPoints() < GetMaxHitPoints()/4 && !GetLocalInt(OBJECT_SELF, "DEAD"))
        {
		  SpeakString("**fades away**");
		  gsXPRewardKill();
          ExecuteScript("gs_ai_death", OBJECT_SELF);
		  SetLocalInt(OBJECT_SELF, "DEAD", TRUE);
          DestroyObject(OBJECT_SELF);
        }

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
        SetLocalInt(OBJECT_SELF, "GS_CB_ILLUSION", TRUE);

        break;

    case GS_EV_ON_SPELL_CAST_AT:
//................................................................

        break;
    }
}
