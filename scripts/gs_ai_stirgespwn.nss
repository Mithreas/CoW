#include "inc_achievements"
#include "inc_event"
#include "x0_i0_position"

void main()
{
    switch (GetUserDefinedEventNumber())
    {
    case GS_EV_ON_BLOCKED:
//................................................................

        break;

    case GS_EV_ON_COMBAT_ROUND_END:
    {
	    string sSpeak = GetLocalString(OBJECT_SELF, "GS_TEXT");
		if (sSpeak == "") sSpeak = "*Raises his arms, calling more stirges into the fray*";
        SpeakString(sSpeak);
        int nCount = d3();

        string sResref = GetLocalString(OBJECT_SELF, "GS_RESREF");
		if (sResref == "") sResref = "ar_cr_doomstirge";
        while (nCount > 0)
        {
          CreateObject(OBJECT_TYPE_CREATURE, sResref, GetBehindLocation(OBJECT_SELF), TRUE);
          nCount--;
        }
    }
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
    {
		int nNth = 1;
		object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, OBJECT_SELF, nNth);
		
		while (GetIsObjectValid(oPC) && GetDistanceBetween(oPC, OBJECT_SELF) <= 35.0f)
		{
		    acAwardAchievement(oPC, "stirges");
			nNth++;
			oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, OBJECT_SELF, nNth);
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
