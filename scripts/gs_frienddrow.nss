#include "gs_inc_combat"
#include "gs_inc_event"
#include "gs_inc_subrace"
#include "sep_inc_event"
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
        ExecuteScript("sep_run_signals", OBJECT_SELF);
        break;

    case GS_EV_ON_PERCEPTION:
    {
//................................................................
        oObject   = GetLastPerceived();

        int bNeutral        = FALSE;
        int bUnderdarker    = FALSE;
        int bHaveDrow       = FALSE;
        int nSubRace;

        //::  Is drow?
        if ( GetIsPC(oObject) && gsSUGetSubRaceByName(GetSubRace(oObject)) == GS_SU_ELF_DROW )
            bHaveDrow = TRUE;

        if ( !GetIsPC(oObject) )
        {
            oObject = GetMaster(oObject);
            if ( !GetIsObjectValid(oObject) ) return;
        }

        oCreature = GetFirstFactionMember(oObject);
        while (GetIsObjectValid(oCreature))
        {
            //::  Drow in party?
            nSubRace = gsSUGetSubRaceByName(GetSubRace(oCreature));
            if ( gsSUGetIsUnderdarker(nSubRace) && nSubRace == GS_SU_ELF_DROW ) {
                bHaveDrow = TRUE;
                break;
            }

            oCreature = GetNextFactionMember(oObject);
        }

        //::  Make Friendly
        if ( bHaveDrow )
        {
          ChangeToStandardFaction(OBJECT_SELF, STANDARD_FACTION_COMMONER);
          DeleteLocalObject(OBJECT_SELF, "GS_CB_ATTACK_TARGET");
          gsCBDetermineCombatRound(OBJECT_SELF);
        }
        //::  Or Hostile
        else {
            ChangeToStandardFaction(OBJECT_SELF, STANDARD_FACTION_HOSTILE);
        }

        break;
    }
    case GS_EV_ON_PHYSICAL_ATTACKED:
//................................................................

        break;

    case GS_EV_ON_RESTED:
//................................................................

        break;

    case GS_EV_ON_SPAWN:
//................................................................
        ExecuteScript("sep_run_dn_init", OBJECT_SELF);
        break;

    case GS_EV_ON_SPELL_CAST_AT:
//................................................................

        break;

case SEP_EV_ON_NIGHTPOST:
//................................................................
        SetLocalInt(OBJECT_SELF, "sep_run_daynight", SEP_EV_ON_NIGHTPOST);
        ExecuteScript("sep_run_daynight", OBJECT_SELF);

        break;
    case SEP_EV_ON_DAYPOST:
//................................................................
        SetLocalInt(OBJECT_SELF, "sep_run_daynight", SEP_EV_ON_DAYPOST);
        ExecuteScript("sep_run_daynight", OBJECT_SELF);

        break;
case SEP_EV_ON_SECURITY_HEARD:
//................................................................
        break;
case SEP_EV_ON_SECURITY_SPOT:
//................................................................
        break;
case SEP_EV_ON_SECURITY_RESOLVE:
//................................................................
        break;
case SEP_EV_ON_GUARD_ALERT:
//................................................................
        break;
case SEP_EV_ON_GUARD_RESOLVE:
//................................................................
        break;
    }
}
