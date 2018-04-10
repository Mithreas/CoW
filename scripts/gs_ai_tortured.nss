#include "gs_inc_ai"
#include "gs_inc_event"
#include "gs_inc_task"
#include "gs_inc_torture"

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
        if (GetLocalInt(OBJECT_SELF, "GS_TO_ENABLED"))
        {
            ClearAllActions(TRUE);
            ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0, 1.0);
            ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_TIRED, 1.0, 5.0);
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
        if (! gsTOGetIsTortured())
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
        gsAISetActionMatrix(GS_AI_ACTION_TYPE_CREATURE, FALSE);

        gsTASetTaskTrigger(OBJECT_SELF, GS_TA_TORTURE);

        break;

    case GS_EV_ON_SPELL_CAST_AT:
//................................................................

        break;
    }
}
