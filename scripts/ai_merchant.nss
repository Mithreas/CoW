// AI script for merchants and other NPCs that close their homes
// at day or night.  See sep_run_daynight.
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
        ExecuteScript("sep_run_signals", OBJECT_SELF);
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
        ExecuteScript("sep_run_dn_init", OBJECT_SELF);
        break;

    case GS_EV_ON_SPELL_CAST_AT:
//................................................................

        break;
    case SEP_EV_ON_NIGHTPOST:
//................................................................
        SetLocalInt(OBJECT_SELF, "sep_run_daynight", SEP_EV_ON_NIGHTPOST);
        ExecuteScript("sep_run_daynight", OBJECT_SELF);

        break;
    case SEP_EV_ON_DAYPOST:
//................................................................
        SetLocalInt(OBJECT_SELF, "sep_run_daynight", SEP_EV_ON_DAYPOST);
        ExecuteScript("sep_run_daynight", OBJECT_SELF);

        break;
case SEP_EV_ON_SECURITY_HEARD:
//................................................................
        break;
case SEP_EV_ON_SECURITY_SPOT:
//................................................................
        break;
case SEP_EV_ON_SECURITY_RESOLVE:
//................................................................
        break;
case SEP_EV_ON_GUARD_ALERT:
//................................................................
        break;
case SEP_EV_ON_GUARD_RESOLVE:
//................................................................
        break;
    }
    RunSpecialBehaviors(GetUserDefinedEventNumber());
}
