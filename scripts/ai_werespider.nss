// Werespider (arachne) shapechanger userdefined AI script.
// Werespiders do not shift in packs, but the size of the spider varies with the CL of the shifter.
// 50% chance of spawning in shifted.
#include "inc_encounter"
#include "inc_event"

void gsPolymorph()
{
    // Spider appearances are 157-162.  Pick one at random, unless one is set as a var.
	int nAppearance = GetLocalInt(OBJECT_SELF, "APPEARANCE");
	if (!nAppearance) nAppearance = 156 + d6();
	SetCreatureAppearanceType(OBJECT_SELF, nAppearance);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,
                        EffectHeal(50),
                        OBJECT_SELF);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,
                          EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD),
                          GetLocation(OBJECT_SELF));
						  
	// Not sure if we need to apply this again. 					  
	if (GetLocalFloat(OBJECT_SELF, "AR_SCALE") > 0.0f)
	{
	   SetObjectVisualTransform(OBJECT_SELF, OBJECT_VISUAL_TRANSFORM_SCALE, GetLocalFloat(OBJECT_SELF, "AR_SCALE"));
	}						  
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
        if (! GetLocalInt(OBJECT_SELF, "GS_POLYMORPH") && GetCurrentHitPoints() < GetMaxHitPoints()/2)
        {
            DelayCommand(1.0, gsPolymorph());
            SetLocalInt(OBJECT_SELF, "GS_POLYMORPH", TRUE);
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
        if (d2() == 2 && ! GetLocalInt(OBJECT_SELF, "GS_POLYMORPH"))
		{
            DelayCommand(1.0, gsPolymorph());
            SetLocalInt(OBJECT_SELF, "GS_POLYMORPH", TRUE);
		}
		
		// Arachnes have a bigger scale range than other creatures. Override the standard scaling function.
	    if (GetLocalFloat(OBJECT_SELF, "AR_SCALE") > 0.0f)
	    {
	        SetObjectVisualTransform(OBJECT_SELF, OBJECT_VISUAL_TRANSFORM_SCALE, GetLocalFloat(OBJECT_SELF, "AR_SCALE"));
	    }
	    else if (gsENGetIsEncounterCreature())
	    {
		    float fScale = 0.7 + GetChallengeRating(OBJECT_SELF)/30.0f;
	        SetObjectVisualTransform(OBJECT_SELF, OBJECT_VISUAL_TRANSFORM_SCALE, fScale);
			SetLocalFloat(OBJECT_SELF, "AR_SCALE", fScale);
	    }

        break;

    case GS_EV_ON_SPELL_CAST_AT:
//................................................................

        break;
    }
}
