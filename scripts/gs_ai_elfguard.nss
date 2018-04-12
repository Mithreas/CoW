#include "inc_combat"
#include "inc_event"
#include "inc_subrace"

void main()
{
    object oObject   = OBJECT_INVALID;
    object oCreature = OBJECT_INVALID;

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
        oObject   = GetLastPerceived();

        while (! GetIsPC(oObject))
        {
            oObject = GetMaster(oObject);
            if (! GetIsObjectValid(oObject)) return;
        }

        oCreature = GetFirstFactionMember(oObject);

        while (GetIsObjectValid(oCreature))
        {
            if (gsSUGetSubRaceByName(GetSubRace(oCreature)) != GS_SU_ELF_DROW &&
                GetRacialType(oCreature) == RACIAL_TYPE_ELF ) return;
            oCreature = GetNextFactionMember(oObject);
        }

        gsCBDetermineCombatRound(oObject);

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
