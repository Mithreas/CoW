#include "gs_inc_event"
#include "gs_inc_task"

void gsDance()
{
    int nNth = 0;

    for (; nNth < 6; nNth++)
    {
        switch (Random(8))
        {
        case 0: ActionPlayAnimation(ANIMATION_FIREFORGET_BOW, 0.5);         break;
        case 1: ActionPlayAnimation(ANIMATION_FIREFORGET_DODGE_DUCK, 0.25); break;
        case 2: ActionPlayAnimation(ANIMATION_FIREFORGET_SPASM, 0.125);     break;
        case 3: ActionPlayAnimation(ANIMATION_FIREFORGET_TAUNT, 0.5);       break;
        case 4: ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY1, 0.5);    break;
        case 5: ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY2, 0.5);    break;
        case 6: ActionPlayAnimation(ANIMATION_LOOPING_CONJURE1, 0.5, 4.0);  break;
        case 7: ActionPlayAnimation(ANIMATION_LOOPING_CONJURE2, 0.5, 4.0);  break;
        }
    }
}
//----------------------------------------------------------------
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
        gsTARegisterTask(GS_TA_DANCE, 7004);

        gsTASetTaskListener(GS_TA_DANCE);

        gsTASeekTaskTrigger("GS_TA_DANCE", GS_TA_DANCE, OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_WAYPOINT);

        break;

    case GS_EV_ON_SPELL_CAST_AT:
//................................................................

        break;

    case 7004: //dance
//................................................................
        oTarget = gsTAGetLastTaskTrigger();
        ClearAllActions(TRUE);

        if (GetDistanceToObject(oTarget) > 0.25)
        {
            ActionWait(1.0);
            ActionMoveToLocation(GetLocation(oTarget));
        }

        oObject = GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN,
                                     OBJECT_SELF, 1,
                                     CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC,
                                     CREATURE_TYPE_IS_ALIVE, TRUE);

        if (GetIsObjectValid(oObject)) ActionDoCommand(SetFacingPoint(GetPosition(oObject)));

        gsDance();
        break;
    }
}
