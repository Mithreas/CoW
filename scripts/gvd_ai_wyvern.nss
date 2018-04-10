#include "gs_inc_event"
#include "gs_inc_area"

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

        // 40 chance the wyvern will fly off
        if (Random(10) < 4) {

          // random waypoint
          int iWaypoint = Random(18)+1;

          // fly effect
          effect eFly = EffectDisappearAppear(GetLocation(GetWaypointByTag("WP_GVD_wyvern"+IntToString(iWaypoint))));

          // Apply the effect to the object
          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFly, OBJECT_SELF, 3.0);


        } else {
          // animation
          AssignCommand(OBJECT_SELF, PlayAnimation(ANIMATION_FIREFORGET_TAUNT));
          if (Random(10) < 4) {
            if (Random(1) == 1) {
              AssignCommand(OBJECT_SELF, PlaySound("c_mindalhon_bat1"));
            } else {
              AssignCommand(OBJECT_SELF, PlaySound("c_mindalhon_bat2"));
            }
          }

        }
    
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

        break;

    case GS_EV_ON_SPELL_CAST_AT:
//................................................................

        break;
    }
}
