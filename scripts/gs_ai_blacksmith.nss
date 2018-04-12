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
        gsTARegisterTask(GS_TA_FETCH_SLUG,    7000);
        gsTARegisterTask(GS_TA_HEAT_SLUG,     7001);
        gsTARegisterTask(GS_TA_WORK_AT_ANVIL, 7002);
        gsTARegisterTask(GS_TA_COOL_SLUG,     7003);

        gsTASetTaskListener(GS_TA_FETCH_SLUG);

        gsTASeekTaskTrigger("GS_TA_SLUG",  GS_TA_FETCH_SLUG,    OBJECT_TYPE_ITEM);
        gsTASeekTaskTrigger("GS_TA_FIRE",  GS_TA_HEAT_SLUG,     OBJECT_TYPE_PLACEABLE);
        gsTASeekTaskTrigger("GS_TA_ANVIL", GS_TA_WORK_AT_ANVIL, OBJECT_TYPE_PLACEABLE);
        gsTASeekTaskTrigger("GS_TA_WATER", GS_TA_COOL_SLUG,     OBJECT_TYPE_PLACEABLE);

        break;

    case GS_EV_ON_SPELL_CAST_AT:
//................................................................

        break;

    case 7000: //fetch slug
//................................................................
        oTarget = gsTAGetLastTaskTrigger();
        ClearAllActions(TRUE);

        oObject = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
        if (! GetIsObjectValid(oObject) || GetTag(oObject) != "GS_TA_HAMMER")
        {
            oObject = GetItemPossessedBy(OBJECT_SELF, "GS_TA_HAMMER");
            if (GetIsObjectValid(oObject)) ActionEquipItem(oObject, INVENTORY_SLOT_RIGHTHAND);
        }

        if (GetIsObjectValid(oObject))
        {
            if (GetDistanceToObject(oTarget) > 2.0) ActionMoveToObject(oTarget, FALSE, 1.5);
            ActionDoCommand(SetFacingPoint(GetPosition(oTarget)));
            oObject = GetItemPossessedBy(OBJECT_SELF, "GS_TA_SLUG");
            if (GetIsObjectValid(oObject)) ActionPutDownItem(oObject);
            ActionPickUpItem(oTarget);
            ActionEquipItem(oTarget, INVENTORY_SLOT_LEFTHAND);
            ActionDoCommand(gsTASwitchTask(GS_TA_FETCH_SLUG, GS_TA_HEAT_SLUG));
        }

        break;

    case 7001: //heat slug
//................................................................
        oTarget = gsTAGetLastTaskTrigger();
        ClearAllActions(TRUE);

        oObject = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
        if (! GetIsObjectValid(oObject) || GetTag(oObject) != "GS_TA_HAMMER")
        {
            oObject = GetItemPossessedBy(OBJECT_SELF, "GS_TA_HAMMER");
            if (GetIsObjectValid(oObject)) ActionEquipItem(oObject, INVENTORY_SLOT_RIGHTHAND);
        }

        if (GetIsObjectValid(oObject))
        {
            oObject = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
            if (! GetIsObjectValid(oObject) || GetTag(oObject) != "GS_TA_SLUG")
            {
                oObject = GetItemPossessedBy(OBJECT_SELF, "GS_TA_SLUG");
                if (GetIsObjectValid(oObject)) ActionEquipItem(oObject, INVENTORY_SLOT_LEFTHAND);
            }

            if (GetIsObjectValid(oObject))
            {
                if (GetDistanceToObject(oTarget) > 2.0) ActionMoveToObject(oTarget, FALSE, 1.5);
                ActionDoCommand(SetFacingPoint(GetPosition(oTarget)));
                ActionDoCommand(ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FLAME_M), oTarget));
                ActionDoCommand(gsTASwitchTask(GS_TA_HEAT_SLUG, GS_TA_WORK_AT_ANVIL));
            }
            else
            {
                ActionDoCommand(gsTASwitchTask(GS_TA_HEAT_SLUG, GS_TA_FETCH_SLUG));
            }
        }

        break;

    case 7002: //work at anvil
//................................................................
        oTarget = gsTAGetLastTaskTrigger();
        ClearAllActions(TRUE);

        oObject = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
        if (! GetIsObjectValid(oObject) || GetTag(oObject) != "GS_TA_HAMMER")
        {
            oObject = GetItemPossessedBy(OBJECT_SELF, "GS_TA_HAMMER");
            if (GetIsObjectValid(oObject)) ActionEquipItem(oObject, INVENTORY_SLOT_RIGHTHAND);
        }

        if (GetIsObjectValid(oObject))
        {
            oObject = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
            if (! GetIsObjectValid(oObject) || GetTag(oObject) != "GS_TA_SLUG")
            {
                oObject = GetItemPossessedBy(OBJECT_SELF, "GS_TA_SLUG");
                if (GetIsObjectValid(oObject)) ActionEquipItem(oObject, INVENTORY_SLOT_LEFTHAND);
            }

            if (GetIsObjectValid(oObject))
            {
                if (GetDistanceToObject(oTarget) > 2.0) ActionMoveToObject(oTarget, FALSE, 1.5);
                ActionAttack(oTarget);
                if (Random(100) >= 75)
                {
                    if (Random(100) >= 50) gsTASwitchTask(GS_TA_WORK_AT_ANVIL, GS_TA_HEAT_SLUG);
                    else                   gsTASwitchTask(GS_TA_WORK_AT_ANVIL, GS_TA_COOL_SLUG);
                }
            }
            else
            {
                ActionDoCommand(gsTASwitchTask(GS_TA_WORK_AT_ANVIL, GS_TA_FETCH_SLUG));
            }
        }

        break;

    case 7003: //cool slug
//................................................................
        oTarget = gsTAGetLastTaskTrigger();
        ClearAllActions(TRUE);

        oObject = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
        if (! GetIsObjectValid(oObject) || GetTag(oObject) != "GS_TA_HAMMER")
        {
            oObject = GetItemPossessedBy(OBJECT_SELF, "GS_TA_HAMMER");
            if (GetIsObjectValid(oObject)) ActionEquipItem(oObject, INVENTORY_SLOT_RIGHTHAND);
        }

        if (GetIsObjectValid(oObject))
        {
            oObject = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
            if (! GetIsObjectValid(oObject) || GetTag(oObject) != "GS_TA_SLUG")
            {
                oObject = GetItemPossessedBy(OBJECT_SELF, "GS_TA_SLUG");
                if (GetIsObjectValid(oObject)) ActionEquipItem(oObject, INVENTORY_SLOT_LEFTHAND);
            }

            if (GetIsObjectValid(oObject))
            {
                if (GetDistanceToObject(oTarget) > 2.0) ActionMoveToObject(oTarget, FALSE, 1.5);
                ActionDoCommand(SetFacingPoint(GetPosition(oTarget)));
                ActionDoCommand(ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SMOKE_PUFF), oTarget));
            }

            ActionDoCommand(gsTASwitchTask(GS_TA_COOL_SLUG, GS_TA_FETCH_SLUG));
        }

        break;
    }
}
