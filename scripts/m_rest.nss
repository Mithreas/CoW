#include "inc_common"
#include "inc_encounter"
#include "inc_flag"
#include "inc_state"
#include "inc_strack"
#include "inc_text"
#include "inc_healer"
#include "inc_tempvars"
#include "zzdlg_main_inc"

void DoNoctureDream(object oPC)
{
  if (GetDeity(oPC) == "Nocturne" && !GetLocalInt(gsPCGetCreatureHide(oPC), "FOUND_NOCTURNE") && d4() == 4)
  {
    string sText;
    switch (d6())
	{
	  case 1:
	    sText = "A whisper comes to you in a dream.  'Find me...!'";
		break;
	  case 2:
	    sText = "You dream of a woman standing before you, her arms open to embrace you.  You realise that she resembles the statue of Nocturne.";
		break;
	  case 3:
	    sText = "You wake refreshed, but with the overwhelming urge to be elsewhere.";
		break;
	  case 4:
	    sText = "You dream of cold snow and warm fires.  You can almost smell the pine needles in the air.";
		break;
	  case 5:
	    sText = "In your dreams, a voice speaks to you.  'Come to me, my disciple.'";
		break;
	  case 6:
	    sText = "Your dreams are warm and comfortable, a sense of belonging and love that is almost tangible.";
		break;
	}
	
	DelayCommand(1.0f, SendMessageToPC(oPC, sText));
  }
}
//----------------------------------------------------------------
void gsRestMonitor(int nEffect = TRUE)
{
    SetCommandable(TRUE);

    if (GetCurrentAction() == ACTION_REST)
    {
	    if (!gsFLGetAreaFlag("REST", OBJECT_SELF) || gsSTGetState(GS_ST_REST) < 25.0)
		{
		  // In taverns etc, allow resting to regain stamina and spells freely. 
          gsSTAdjustState(GS_ST_REST, 2.5);
		}
		
        gsSTAdjustState(GS_ST_STAMINA, 5.0);
        gsSTAdjustState(GS_ST_SOBRIETY, 5.0);

        //if (nEffect)
        //{
            //ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SLEEP), OBJECT_SELF);
        //}

        DelayCommand(2.0, gsRestMonitor(! nEffect));
        SetCommandable(FALSE);
    }
    else
    {
        FadeFromBlack(OBJECT_SELF);
    }
}
//----------------------------------------------------------------
void gsAmbush()
{
    int nChance = gsENGetEncounterChance(GetArea(OBJECT_SELF)) / 2;

    if ((Random(100) + 1) <= nChance)
    {
        location lLocation = GetLocation(OBJECT_SELF);

        //check for guards
        object oCreature   = GetFirstObjectInShape(SHAPE_SPHERE, 20.0, lLocation, TRUE);

        while (GetIsObjectValid(oCreature))
        {
            if (!(oCreature == OBJECT_SELF) &&
                ! GetIsDM(oCreature) &&
                ! GetPlotFlag(oCreature) &&
                ! GetIsDead(oCreature) &&
                GetCurrentAction(oCreature) != ACTION_REST &&
                (GetAssociateType(oCreature) == ASSOCIATE_TYPE_NONE ||
                 GetCurrentAction(GetMaster(oCreature)) != ACTION_REST))
            {
                return;
            }
             oCreature = GetNextObjectInShape(SHAPE_SPHERE, 20.0, lLocation, TRUE);
        }
            //spawn
        FloatingTextStringOnCreature("You have been ambushed.", OBJECT_SELF);
        gsENSpawnAtLocation(IntToFloat(GetHitDice(OBJECT_SELF)),
                            GS_EN_LIMIT_SPAWN,
                            GetLocation(OBJECT_SELF),
                            7.5);
    }
}
//----------------------------------------------------------------
void gsDoRest(object oRested, int eventType)
{
    object oArmor  = GetItemInSlot(INVENTORY_SLOT_CHEST, oRested);
    int nLimit     = -1;

    //Removes breath potion effect
    SetLocalInt(oRested, "WATER_BREATH", FALSE);

    switch (eventType)
    {
    case REST_EVENTTYPE_REST_STARTED:
    {
        //dm
        if (GetIsDM(oRested))
        {
            ForceRest(oRested);
            AssignCommand(oRested, ClearAllActions());
            break;
        }

        //no-rest areas.
        object oArea = GetArea(oRested);
        int nSubRace = gsSUGetSubRaceByName(GetSubRace(oRested));

        if ( FloatToInt(gsSTGetState(GS_ST_REST, oRested)) > -20 &&
             GetLocalInt(oArea, "MI_PLANE") > 0 && 
			 !GetIsAreaInterior(oArea))
        {
            // Send the 'resting isn't allowed in this area' message.
            AssignCommand(oRested, ClearAllActions());
            FloatingTextStrRefOnCreature(
                16787708,
                oRested,
                FALSE);
        }

        //armor
        if (GetIsObjectValid(oArmor) &&
            gsCMGetItemBaseAC(oArmor) >= 4)
        {
            AssignCommand(oRested, ClearAllActions());
            FloatingTextStringOnCreature(GS_T_16777328, oRested, FALSE);
            break;
        }

        if (! gsFLGetAreaFlag("REST", oRested))
          nLimit = 50;
        else nLimit = 90;

        //exhaustion limit
        if (nLimit == -1 ||
            FloatToInt(gsSTGetState(GS_ST_REST, oRested)) < nLimit)
        {
            FadeToBlack(oRested);
            AssignCommand(oRested, gsRestMonitor());
            SetCommandable(FALSE, oRested);
        }
        else
        {
            AssignCommand(oRested, ClearAllActions());
            FloatingTextStringOnCreature(
                gsCMReplaceString(GS_T_16777329, IntToString(nLimit)),
                oRested,
                FALSE);
        }
        break;
    }
    case REST_EVENTTYPE_REST_CANCELLED:
        md_SaveSpellLevel(oRested, 0);
        md_SaveSpellLevel(oRested, 1);
        md_SaveSpellLevel(oRested, 2);
        break;

    case REST_EVENTTYPE_REST_FINISHED:

        //spelltracker
        if (! GetIsDM(oRested) && ! GetIsDMPossessed(oRested)) gsSPTReset(oRested);
        md_SaveSpellLevel(oRested, 0);
        md_SaveSpellLevel(oRested, 1);
        md_SaveSpellLevel(oRested, 2);
        DeleteLocalInt(oRested, "md_spellclutch");
        UpdateSpontaneousSpellReadyStates(oRested);
        DeleteTempVariables(oRested, TEMP_VARIABLE_EXPIRATION_EVENT_REST);
        AssignCommand(oRested, DelayCommand(1.0, gsAmbush()));
        // Remove yoinking flags
        DeleteLocalInt(oRested, "YOINKING");
        DeleteLocalObject(oRested, "YOINK_TARGET");
		// Nocturne check.
		DoNoctureDream(oRested);
        break;
    }
}
//----------------------------------------------------------------
void main()
{
    object rested = GetLastPCRested();
    int eventType = GetLastRestEventType();

    if (eventType == REST_EVENTTYPE_REST_STARTED && !GetLocalInt(rested, "READY_TO_REST"))
    {
        AssignCommand(rested, ClearAllActions());
        _dlgStart(rested, rested, "zz_co_rest", TRUE, TRUE, TRUE);
    }
    else
    {
        DeleteLocalInt(rested, "READY_TO_REST");
        gsDoRest(rested, eventType);
    }
}
