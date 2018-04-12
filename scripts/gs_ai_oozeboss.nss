#include "inc_event"
#include "inc_flag"
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
    {
//................................................................
        string sResRef = GetLocalString(OBJECT_SELF, "UD_OOZE");
        if (sResRef != "")
        {
          ApplyEffectAtLocation(DURATION_TYPE_INSTANT,
                                EffectVisualEffect(VFX_IMP_ACID_S),
                                GetLocation(OBJECT_SELF));
          // Spawn two smaller oozes.
          object oOoze;
          oOoze = CreateObject(OBJECT_TYPE_CREATURE, sResRef, GetLocation(OBJECT_SELF));
          gsFLSetFlag(GS_FL_ENCOUNTER, oOoze);
          oOoze = CreateObject(OBJECT_TYPE_CREATURE, sResRef, GetLocation(OBJECT_SELF));
          gsFLSetFlag(GS_FL_ENCOUNTER, oOoze);
        }
        break;
    }
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

        break;

    case GS_EV_ON_SPELL_CAST_AT:
//................................................................

        break;
    }
}
