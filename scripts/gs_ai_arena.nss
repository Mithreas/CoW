#include "gs_inc_arena"
#include "gs_inc_event"

void main()
{
    string sString = "";

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
//................................................................
        sString = GetLocalString(OBJECT_SELF, "GS_ARENA");

        if (sString != "")
        {
            object oArena = GetObjectByTag(sString);
            if (GetIsObjectValid(oArena)) gsAEAssignParticipant(oArena, OBJECT_SELF);
        }

        break;

    case GS_EV_ON_SPELL_CAST_AT:
//................................................................

        break;
    }
}
