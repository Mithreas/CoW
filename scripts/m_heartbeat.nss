#include "ar_sys_ship"
#include "inc_common"
#include "inc_daynight"
#include "inc_encounter"
#include "inc_execute"
#include "inc_flag"
#include "inc_istate"
#include "inc_sequencer"
#include "inc_spell"
#include "inc_theft"
#include "inc_time"
#include "inc_xp"
#include "inc_thrall"
#include "inc_caravan"
#include "inc_criers"
#include "inc_factions"
#include "inc_pop"
#include "inc_randomquest"
#include "inc_relations"
#include "inc_resource"
#include "inc_vampire"
#include "inc_weather"
#include "inc_werewolf"
#include "inc_xfer"
#include "inc_respawn"
#include "nwnx_admin"
#include "inc_adv_xp"
#include "inc_bondeditems"

void gsCombat()
{
    //get offense target
    object oTarget = GetAttemptedAttackTarget();

    // AWIA
    miAWInfect(OBJECT_SELF, oTarget);
    miAWSilverHit(OBJECT_SELF, oTarget);

    fbZZombify(OBJECT_SELF, oTarget);

    if (! GetIsObjectValid(oTarget) &&
        gsSPGetSpellCallback() &&
        gsSPGetLastSpellHarmful())
    {
        oTarget = gsSPGetLastSpellTarget();
    }

    if (GetIsObjectValid(oTarget))
    {
        if (GetIsPC(oTarget) &&
            oTarget != OBJECT_SELF &&
            ! (GetIsDM(oTarget) || GetIsDMPossessed(oTarget)))
        {
            SetPCDislike(oTarget, OBJECT_SELF);
            miRERecordCombatHit(oTarget, OBJECT_SELF);

            if (! GetIsObjectValid(GetLocalObject(oTarget, "GS_PVP_TARGET")))
            {
                if (gsTHGetHasItemStolenFrom(oTarget, OBJECT_SELF) ||
                    GetIsObjectValid(GetItemPossessedBy(OBJECT_SELF, "GS_PEACEKEEPER_BADGE")))
                {
                    SetLocalObject(oTarget, "GS_PVP_TARGET", OBJECT_SELF);
                    AssignCommand(oTarget, SpeakString("GS_AI_PVP", TALKVOLUME_SILENT_TALK));
                }
                else
                {
                    SetLocalObject(OBJECT_SELF, "GS_PVP_TARGET", oTarget);
                    SpeakString("GS_AI_PVP", TALKVOLUME_SILENT_TALK);
                }
            }
        }

        //corrupt equipment

        // Dunshine: added extra parameters for creatures that are flagged as being rustmonster or mothmonster, gvd_rust and gvd_moth being percentage chances each heartbeat during combat
        gsISCorruptEquipment(GetLocalInt(oTarget, "gvd_rust"), GetLocalInt(oTarget, "gvd_moth"));

        // Do weather checks.
        miWHDoCombatChecks(OBJECT_SELF);
    }
    else if (! GetIsInCombat() &&
             GetIsObjectValid(GetLocalObject(OBJECT_SELF, "GS_PVP_TARGET")))
    {
        DelayCommand(4.0, DeleteLocalObject(OBJECT_SELF, "GS_PVP_TARGET"));
    }
}
//----------------------------------------------------------------
void main()
{
    //force time update
    SetCalendar(GetCalendarYear(),
                GetCalendarMonth(),
                GetCalendarDay());
    SetTime(GetTimeHour(),
            GetTimeMinute(),
            GetTimeSecond(),
            GetTimeMillisecond());

    object oPC          = OBJECT_INVALID;
    object oArea        = OBJECT_INVALID;
    object oTarget      = OBJECT_INVALID;
    location lLocation1;
    location lLocation2;
    vector vPosition1;
    vector vPosition2;
    int nPreviousYear   = GetLocalInt(OBJECT_SELF, "GS_LAST_YEAR");
    int nCurrentYear    = GetCalendarYear();
    int nPreviousMonth  = GetLocalInt(OBJECT_SELF, "GS_LAST_MONTH");
    int nCurrentMonth   = GetCalendarMonth();
    int nPreviousDay    = GetLocalInt(OBJECT_SELF, "GS_DAY");
    int nCurrentDay     = GetCalendarDay();
    int nPreviousHour   = GetLocalInt(OBJECT_SELF, "GS_HOUR");
    int nCurrentHour    = GetTimeHour();
    int nTimestamp      = gsTIGetActualTimestamp();
    int nRestartTimeout = GetLocalInt(OBJECT_SELF, "GS_RESTART_TIMEOUT");
    int nNth            = 0;

    // temporary logging of timestamp to see when the differences between servers start happening
    //WriteTimestampedLogEntry("Current Timestamp (Server " + GetLocalString(GetModule(), VAR_SERVER_NAME) + "): " + IntToString(nTimestamp));

    //reboot
    if (nRestartTimeout &&
        nTimestamp >= nRestartTimeout)
    {
        DeleteLocalInt(OBJECT_SELF, "GS_RESTART_TIMEOUT");
        ExecuteScript("gs_run_reboot", OBJECT_SELF);
    }

    // per year
    if (nPreviousYear != nCurrentYear)
    {
      // Delay the annual trade method to prevent TMIs.
      AssignCommand(OBJECT_SELF, miCZDoAnnualTrade());
      SetLocalInt(OBJECT_SELF, "GS_LAST_YEAR", nCurrentYear);
    }

    // per month
    if (nPreviousMonth != nCurrentMonth)
    {
      DelayCommand(3.0f, DoMonthlySalary());

      // Gift of Wealth monthly income - active characters only.
      if (miXFGetCurrentServer() == SERVER_CORDOR || miXFGetCurrentServer() == SERVER_PREHISTORY)
      {
        DelayCommand(4.0f, SQLExecDirect("update gs_pc_data set modified=modified,bank=bank+1000 where wealth=1 and DATE_SUB(CURDATE(), INTERVAL 37 DAY) < modified"));
      }

      // Increment populations
      miPORepopulate();

      SetLocalInt(OBJECT_SELF, "GS_LAST_MONTH", nCurrentMonth);
    }

    //per day
    if (nPreviousDay != nCurrentDay)
    {
        SetLocalInt(OBJECT_SELF, "GS_DAY", nCurrentDay);
		
		miPODoNests();
		UpdateRepeatableQuests();
    }

    //per hour
    if (nPreviousHour != nCurrentHour)
    {
        oPC           = GetFirstPC();

        while (GetIsObjectValid(oPC))
        {

            miAWTransform(oPC);

            if (! GetIsDM(oPC) &&
                GetLocalInt(oPC, "GS_ENABLED") &&
                ! gsFLGetAreaFlag("OVERRIDE_STATE", oPC))
            {
                //activity -- moved here from per-round processing for lag reduction
                lLocation1 = GetLocation(oPC);
                lLocation2 = GetLocalLocation(oPC, "GS_LOCATION");
                vPosition1 = GetPositionFromLocation(lLocation1);
                vPosition2 = GetPositionFromLocation(lLocation2);;

                if (vPosition1.x != vPosition2.x ||
                    vPosition1.y != vPosition2.y)
                {
                    SetLocalLocation(oPC, "GS_LOCATION", lLocation1);
                    SetLocalInt(oPC, "GS_ACTIVE", TRUE);
                }

                //state animation - now every game hour not 6 seconds.
                AssignCommand(oPC, gsSTPlayAnimation());

                if (GetLocalInt(oPC, "GS_ACTIVE"))
                {

                    //experience bonus
                    if (! gsFLGetAreaFlag("OVERRIDE_DEATH", oPC))
                    {

                        int iRPR = gsPCGetRolePlay(oPC);
                        int nXP = iRPR + (GetIsObjectValid(GetItemPossessedBy(oPC, "mi_mark_destiny")) ? 20 : 0);

                        if (GetHitDice(oPC) >= GetLocalInt(GetModule(), "STATIC_LEVEL"))
                        {
                            CreateItemOnObject("ar_gem_" + IntToString(iRPR), oPC);
                        }
                        else
                        {
                            gsXPApply(oPC, 2 * nXP);
                        }

                        // Dunshine: handle the exploration XP pool here
                        gvd_AdventuringXP_XPBonus(oPC);

                    }
                    DeleteLocalInt(oPC, "GS_ACTIVE");
                }

                //state
                AssignCommand(oPC, gsSTProcessState());

                //respawn
                ExecuteScript("sep_respawn_tick", oPC);


                // Weather
                if (ALLOW_WEATHER) {
                    miWHDoWeatherEffects(oPC);
                }

                //:: Kirito - Increment Item Bonds
                UpdateBonds(oPC);
            }

            oPC = GetNextPC();
        }

        //clean area
        int nCount = gsARGetRegisteredAreaCount();
        int nNth   = 1;

        for (; nNth <= nCount; nNth++)
        {
            oArea = gsARGetRegisteredArea(nNth);
            gsSEAdd("gs_run_cleanarea", oArea);
        }

        SetLocalInt(OBJECT_SELF, "GS_HOUR", nCurrentHour);

        gsEXExecuteHour();

        // Do weather checks.
        if (ALLOW_WEATHER) {
            miWHAdjustWeather();
        }

        // Make caravans depart, at certain hours.
        switch (nCurrentHour)
        {
          case 6:
          case 9:
          case 12:
          case 15:
          case 18:
            DelayCommand(0.5, miCADoDepartures());
            break;
        }	
		
		// Dawn and dusk checks.
		if (GetIsDusk())
		{
		  DN_SignalNPCs(SEP_EV_ON_NIGHTPOST);		
		}
		else if (GetIsDawn())
		{
		  DN_SignalNPCs(SEP_EV_ON_DAYPOST);
		}
    }

    // Added by Mith - per RL minute (10 game minutes, 10 heartbeats)
    //
    int nCount = GetLocalInt(OBJECT_SELF, "MI_COUNT");

    // Per 30s
    if (nCount == 1 || nCount == 6)
    {
      miXFRespond();
      miXFProcessMessages();

      int nState = miXFGetState();
      if ((nState == MI_XF_STATE_REQUEST_REBOOT || nState == MI_XF_STATE_DOWN) &&
       !GetLocalInt(OBJECT_SELF, "REBOOT_SIGNALLED"))
      {
        SetLocalInt(OBJECT_SELF, "REBOOT_SIGNALLED", TRUE);
        ExecuteScript("gs_run_reboot", OBJECT_SELF);
      }
      else if (nState == MI_XF_STATE_CRASHED)
      {
        miXFSetState(MI_XF_STATE_UP);
      }
    }

    // per 60s
    if (nCount < 10) nCount++;
    else
    {
      nCount = 0;
      miCRDoShoutMessages();

      // moved this from 6 RL minute to 1 RL minute interval, so the maximum difference between both servers is now 1 RL minute
      miDASetKeyedValue("gs_system", "time", "value", IntToString(nTimestamp));
	  WriteTimestampedLogEntry("Server time: " + IntToString(nTimestamp));

      //::  Added by ActionReplay - Update Guild Ships every RL Minute for more frequent sea encounters.
      ar_UpdateShips();
	  
	  // Refill faction resource chests every minute. 
	  // On a delay to avoid TMI.
      DelayCommand(0.0, DistributeResources());
    }

    SetLocalInt(OBJECT_SELF, "MI_COUNT", nCount);

    //set timestamp
    SetLocalInt(OBJECT_SELF, "GS_TIMESTAMP", nTimestamp);

    //per round
    oPC = GetFirstPC();

    while (GetIsObjectValid(oPC))
    {
        oArea = GetArea(oPC);

        if (GetIsObjectValid(oArea) &&
            GetLocalInt(oArea, "GS_ENABLED"))
        {
            oArea = GetArea(oPC);

            if (GetLocalInt(oArea, "GS_TIMESTAMP") != nTimestamp)
            {
                //ambience
                gsSEAdd("gs_run_ambience", oArea);

                //timestamp
                SetLocalInt(oArea, "GS_TIMESTAMP", nTimestamp);
            }

            if (! (GetIsDM(oPC) || GetIsDMPossessed(oPC)))
            {
                //combat
                if (! gsFLGetAreaFlag("PVP", oPC)) AssignCommand(oPC, gsCombat());

                // AWIA
                miAWWolfishAI(oPC);

                gsSPResetSpellCallback(oPC);

                // Vampire heartbeat
                if (VampireIsVamp(oPC))
                {
                    VampireHeartbeat(oPC, gsSTGetState(GS_ST_BLOOD, oPC));
                }

                // Thrall heartbeat
                if (ThrallGetFeedCount(oPC) || ThrallGetFedFromCount(oPC))
                {
                    ThrallHeartbeat(oPC);
                }
            }
        }

        oPC = GetNextPC();
    }

    gsEXExecuteRound();
}
