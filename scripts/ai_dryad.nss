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
    {
        //tree - behaves like a boss phylactery.
        object oObject = GetNearestObjectByTag("GS_PHYLACTERY", OBJECT_SELF);
        int nNth       = 1;

        while (GetIsObjectValid(oObject) &&
               GetDistanceBetween(oObject, OBJECT_SELF) <= 35.0)
        {
            if (! GetIsObjectValid(GetLocalObject(oObject, "GS_PHYLACTERY_CREATURE")))
            {
                SetLocalObject(oObject, "GS_PHYLACTERY_CREATURE", OBJECT_SELF);
                SetImmortal(OBJECT_SELF, TRUE);
                ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                    EffectHeal(1000),
                                    oObject);
                break;
            }

            oObject = GetNearestObjectByTag("GS_PHYLACTERY", OBJECT_SELF, ++nNth);
        }

        break;
    }
    case GS_EV_ON_SPELL_CAST_AT:
//................................................................
        break;
    }
    RunSpecialBehaviors(GetUserDefinedEventNumber());
}
