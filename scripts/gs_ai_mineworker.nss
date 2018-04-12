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
        gsTARegisterTask(GS_TA_MINE_AT_ROCK, 7005);

        gsTASetTaskListener(GS_TA_MINE_AT_ROCK);

        gsTASeekTaskTrigger("GS_TA_ROCK", GS_TA_MINE_AT_ROCK, OBJECT_TYPE_PLACEABLE);
        break;

    case GS_EV_ON_SPELL_CAST_AT:
//................................................................

        break;

    case 7005: //mine at rock
//................................................................
        oTarget = gsTAGetLastTaskTrigger();
        ClearAllActions(TRUE);

        if (Random(100) >= 90)
        {
            gsAIActionWalk();
            break;
        }

        oObject = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
        if (! GetIsObjectValid(oObject) || GetTag(oObject) != "GS_TA_AXE")
        {
            oObject = GetItemPossessedBy(OBJECT_SELF, "GS_TA_AXE");
            if (GetIsObjectValid(oObject)) ActionEquipItem(oObject, INVENTORY_SLOT_RIGHTHAND);
        }

        if (GetIsObjectValid(oObject))
        {
            if (GetDistanceToObject(oTarget) > 2.0) ActionMoveToObject(oTarget, FALSE, 1.5);
            ActionAttack(oTarget);
        }

        break;
    }
}
