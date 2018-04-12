#include "inc_event"
#include "inc_area"

void _GiantWurmEffect() {

  // giant wurm effect

  // now generate a new one
  effect eWurm = ExtraordinaryEffect(EffectVisualEffect(323));
  //ApplyEffectToObject(DURATION_TYPE_PERMANENT, eWurm, OBJECT_SELF);

  ApplyEffectToObject(DURATION_TYPE_INSTANT, eWurm, OBJECT_SELF);

  DelayCommand(5.0f, _GiantWurmEffect());

}


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
    {

      if (gsARGetIsAreaActive(GetArea(OBJECT_SELF))) {

        ExecuteScript("gs_run_ai", OBJECT_SELF);

      }

      break;
    }

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


        _GiantWurmEffect();

        //effect eWurm2 = ExtraordinaryEffect(EffectVisualEffect(490));
        //ApplyEffectToObject(DURATION_TYPE_PERMANENT, eWurm2, OBJECT_SELF);

        break;

    case GS_EV_ON_SPELL_CAST_AT:
//................................................................

        break;
    }
}
