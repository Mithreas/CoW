#include "gs_inc_event"

void gsPolymorph()
{
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                        ExtraordinaryEffect(EffectPolymorph(POLYMORPH_TYPE_WERECAT)),
                        OBJECT_SELF);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,
                          EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD),
                          GetLocation(OBJECT_SELF));
}
//----------------------------------------------------------------
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
        if (! GetLocalInt(OBJECT_SELF, "GS_POLYMORPH"))
        {
            DelayCommand(1.0, gsPolymorph());
            SetLocalInt(OBJECT_SELF, "GS_POLYMORPH", TRUE);
        }

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
