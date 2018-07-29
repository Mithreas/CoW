#include "inc_ai"
#include "inc_event"
#include "inc_task"

void main()
{
    object oObject = OBJECT_INVALID;
    object oTarget = OBJECT_INVALID;

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
        gsTARegisterTask(GS_TA_BANG_DRUM,    7007);
		gsTASetTaskListener(GS_TA_BANG_DRUM);
        gsTASeekTaskTrigger("GS_TA_DRUM",  GS_TA_BANG_DRUM,     OBJECT_TYPE_PLACEABLE);

        break;

    case GS_EV_ON_SPELL_CAST_AT:
//................................................................

        break;

    case 7007: //play drums
//................................................................
        oTarget = gsTAGetLastTaskTrigger();
        ClearAllActions(TRUE);

        if (GetDistanceToObject(oTarget) > 2.0) ActionMoveToObject(oTarget, FALSE, 1.5);
        ActionAttack(oTarget);

        break;
    }
}