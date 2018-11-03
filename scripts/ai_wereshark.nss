// Wereshark shapechanger userdefined AI script.
// If one wereshark is brought below 50% health, the whole pack (school?) should shift. 
#include "inc_event"

void gsPolymorph()
{
    // Shark appearances are 447, 448 and 449.  Pick one at random.
	SetCreatureAppearanceType(OBJECT_SELF, 446 + d3());
    ApplyEffectToObject(DURATION_TYPE_INSTANT,
                        EffectHeal(50),
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
        if (GetListenPatternNumber() == 10005 && ! GetLocalInt(OBJECT_SELF, "GS_POLYMORPH"))
		{
            DelayCommand(1.0, gsPolymorph());
            SetLocalInt(OBJECT_SELF, "GS_POLYMORPH", TRUE);
		}

        break;

    case GS_EV_ON_DAMAGED:
//................................................................
        if (! GetLocalInt(OBJECT_SELF, "GS_POLYMORPH") && GetCurrentHitPoints() < GetMaxHitPoints()/2)
        {
            DelayCommand(1.0, gsPolymorph());
            SetLocalInt(OBJECT_SELF, "GS_POLYMORPH", TRUE);
			SpeakString("WERERAT_SHIFT", TALKVOLUME_SILENT_TALK);
        }


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
        SetListenPattern(OBJECT_SELF, "WERERAT_SHIFT", 10005);

        break;

    case GS_EV_ON_SPELL_CAST_AT:
//................................................................

        break;
    }
}
