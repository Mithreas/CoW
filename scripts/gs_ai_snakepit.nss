#include "gs_inc_event"

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

        break;

    case GS_EV_ON_PHYSICAL_ATTACKED:
//................................................................

        break;

    case GS_EV_ON_RESTED:
//................................................................

        break;

    case GS_EV_ON_SPAWN:
    {
//................................................................
        int nSnakes = d6(1) + 3;
        int nCount = 0;

        for (nCount = 0; nCount < nSnakes; nCount++)
        {
          CreateObject(OBJECT_TYPE_CREATURE, "j3snake1", GetLocation(OBJECT_SELF));
        }

        DestroyObject(OBJECT_SELF);
        break;
    }
    case GS_EV_ON_SPELL_CAST_AT:
//................................................................

        break;
    }
}
