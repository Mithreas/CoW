#include "gs_inc_event"
#include "gs_inc_task"
#include "gs_inc_torture"

void main()
{
    object oTarget = OBJECT_INVALID;
    object oObject = OBJECT_INVALID;

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
        gsTARegisterTask(GS_TA_TORTURE, 7006);

        gsTASetTaskListener(GS_TA_TORTURE);

        break;

    case GS_EV_ON_SPELL_CAST_AT:
//................................................................

        break;

//................................................................
    case 7006: //torture
        oTarget = gsTAGetLastTaskTrigger();
        ClearAllActions(TRUE);

        oObject = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
        if (! GetIsObjectValid(oObject) || GetTag(oObject) != "GS_TA_WHIP")
        {
            oObject = GetItemPossessedBy(OBJECT_SELF, "GS_TA_WHIP");
            if (GetIsObjectValid(oObject)) ActionEquipItem(oObject, INVENTORY_SLOT_RIGHTHAND);
        }

        if (GetIsObjectValid(oObject))
        {
            if (GetLocalInt(oTarget, "GS_TO_ENABLED") &&
                Random(100) >= 75)
            {
                DelayCommand(IntToFloat(Random(31) + 30),
                             gsTASetTaskTrigger(oTarget, GS_TA_TORTURE));
                gsTAReleaseTaskTrigger(oTarget, GS_TA_TORTURE);
            }
            else
            {
                gsTODoTorture(oTarget);
                if (GetDistanceToObject(oTarget) > 2.0) ActionMoveToObject(oTarget, FALSE, 1.5);
                ActionAttack(oTarget);
            }
        }

        break;
    }
}
