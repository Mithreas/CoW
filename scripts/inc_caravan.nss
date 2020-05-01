/*
  Name: inc_caravan
  Author: Mithreas
  Date: 10 Nov 2008

  Include library for caravan (travel) functions.
*/
#include "inc_awards"
#include "inc_customspells"
#include "inc_log"

const string CARAVANS = "CARAVANS"; // for tracing

const int TRAVEL_TYPE_LAND   = 0;
const int TRAVEL_TYPE_SEA    = 1;
const int TRAVEL_TYPE_RANGER = 2;

// Sends the caller to sDestinationTag via a cutscene.
void miCADoJourney(string sDestinationTag, int bType = TRAVEL_TYPE_LAND);
// Handles departures for all PCs with tickets in oCaravan's area.
void miCADepart(object oCaravan);
// Runs through all the caravans in the module, and handles departures for each
// of them.  Call in the module heartbeat.
void miCADoDepartures();
// Adds oCaravan to the module's list.
void miCARegisterCaravan(object oCaravan);
// Returns the number of destinations in the module.
int miCAGetCaravanCount();
// Internal method called from miCADoJourney to make the PC arrive.  Also used
// by the 'rescue' script.
void miCAArrive(string sDestinationTag);
// Check whether a PC is able to cross the sea safely. 
int miCACanSwim(object oPC);
// Consumed by the sea.
void miCADrown(object oPC);

// Variable name - where is the PC going.  See zdlg_caravan.
const string MICA_DESTINATION = "mica_destination";
// Variable name - where is the PC departing from.  Ticket only valid from here.
const string MICA_AREA        = "mica_area";
// Variable name - is this a land (0) or sea (1) trip? [Future: flying??]
const string MICA_TYPE        = "mica_type";
// Variable name - is the PC currently in transit (& so can move on at once)
const string MICA_TRAVELLING  = "mica_travelling";

//------------------------------------------------------------------------------
void miCAArrive(string sDestinationTag)
{
  if (sDestinationTag == "") sDestinationTag = "MICA_CORDOR";

  object oDestination = GetWaypointByTag(sDestinationTag);
  object oPC = OBJECT_SELF;
  Trace(CARAVANS, GetName(oPC) + " arriving at " + GetName(GetArea(oDestination)) +
  " (" + sDestinationTag + ").");

  object oServant = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oPC);
  if (GetIsObjectValid(oServant)) DelayCommand(8.0, miSCRemoveInvis(oServant));

  oServant = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oPC);
  if (GetIsObjectValid(oServant)) DelayCommand(8.0, miSCRemoveInvis(oServant));

  SetPlotFlag(oPC,FALSE);
  AssignCommand(oPC, ClearAllActions(TRUE));
  AssignCommand(oPC, ActionJumpToObject(oDestination, FALSE));

  SetCutsceneMode(oPC,FALSE);

  blackout(oPC);
  SetLocalInt(oPC, MICA_TRAVELLING, 2);
}
//------------------------------------------------------------------------------
int miCAGetCaravanCount()
{
  return GetLocalInt(GetModule(), "MI_CA_COUNT");
}
//------------------------------------------------------------------------------
void miCARegisterCaravan(object oCaravan)
{
  object oModule = GetModule();
  int nIndex     = miCAGetCaravanCount();

  Trace(CARAVANS, "Registering new caravan in area: " + GetName(GetArea(oCaravan)));

  SetLocalObject(oModule, "MI_CA_" + IntToString(nIndex), oCaravan);
  SetLocalInt(oModule, "MI_CA_COUNT", nIndex + 1);
}
//------------------------------------------------------------------------------
void miCADoJourney(string sDestinationTag, int bType = TRAVEL_TYPE_LAND)
{
  object oPC = OBJECT_SELF;
  Trace(CARAVANS, GetName(oPC) + " is departing to " + sDestinationTag);
	
  if (bType == TRAVEL_TYPE_SEA) 
  {
    SpeakString("*departs with the ship*");
	// Todo: travel duration and ship.
	
    SetLocalInt(oPC, MICA_TRAVELLING, 2);
	AssignCommand(oPC, ActionJumpToObject(GetObjectByTag(sDestinationTag)));
  }	
  else if (bType == TRAVEL_TYPE_RANGER)
  {
    SpeakString("*departs with the ranger*");

    object oCaravan = GetObjectByTag("MICA_CAMERA_2");  
    miSCDoScrying(oPC, oCaravan, FALSE);
	
	AssignCommand(oPC, DelayCommand(30.0, FloatingTextStringOnCreature("Whose woods these are I think I know...", oPC)));

    AssignCommand(oPC, DelayCommand(60.0, miCAArrive(sDestinationTag)));
  }
  else 
  {
    SpeakString("*departs with the caravan*");

    object oCaravan = GetObjectByTag("MICA_CAMERA");  
    miSCDoScrying(oPC, oCaravan, FALSE);

    AssignCommand(oPC, DelayCommand(60.0, miCAArrive(sDestinationTag)));
  }	
  
  DeleteLocalString(oPC, MICA_DESTINATION);
  DeleteLocalString(oPC, MICA_TYPE);		
  
}
//------------------------------------------------------------------------------
void miCADepart(object oCaravan)
{
  object oPC = GetFirstObjectInArea(GetArea(oCaravan));

  // Get all players in vicinity of triggering player
  while(GetIsObjectValid(oPC))
  {
    int bIsPC = GetIsPC(oPC);

    // Check Object is a Player
    if (bIsPC)
    {
      // Check they have a valid ticket.
      string sDestinationTag = GetLocalString(oPC, MICA_DESTINATION);
      object oArea           = GetLocalObject(oPC, MICA_AREA);
	  int    bType           = GetLocalInt(oPC, MICA_TYPE);

      if (sDestinationTag != "" && GetArea(oPC) == oArea)
      {
        // Go!
        Trace(CARAVANS, GetName(oPC) + " has destination " + sDestinationTag);
        AssignCommand(oPC, ClearAllActions(TRUE));
        AssignCommand(oPC, miCADoJourney(sDestinationTag, bType));
      }
    }

    // Check next object in the area.
    oPC = GetNextObjectInArea(GetArea(oCaravan));
  }
}
//------------------------------------------------------------------------------
void miCADoDepartures()
{
  int nCount = 0;
  object oModule = GetModule();
  object oCaravan;

  for (; nCount < miCAGetCaravanCount(); nCount++)
  {
    oCaravan = GetLocalObject(oModule, "MI_CA_" + IntToString(nCount));
    miCADepart(oCaravan);
  }
}
//------------------------------------------------------------------------------
int miCACanSwim(object oPC)
{
  int nRace = GetRacialType(oPC);
  int nAppearance = GetAppearanceType(oPC);
  int bArcanist = GetLevelByClass(CLASS_TYPE_SORCERER, oPC) || GetLevelByClass(CLASS_TYPE_WIZARD, oPC);
  
  if (nAppearance == 68 || nAppearance == 69) return TRUE;  // Water elemental form
  
  if (bArcanist)
  {
    // Check for polymorph effects.
	if (nAppearance == 159 || nAppearance == 167 || nAppearance == 168) return TRUE; // Spider, troll, umber hulk
	else return FALSE;
  }
  
  if (nRace == RACIAL_TYPE_ELF) return FALSE;  
  
  return TRUE;
}
//------------------------------------------------------------------------------
void miCADrown(object oPC)
{
  AssignCommand(oPC, ClearAllActions());
  AssignCommand(oPC, ActionJumpToObject(GetObjectByTag("WATERY_GRAVE")));

  SendMessageToPC(oPC, "You get a little way out onto open water, then a large wave rises up out of nowhere and swallows your boat.  Death follows shortly thereafter.");
  
  // rewards
  gvd_DoRewards(oPC);

  // Delete character.
  fbEXDeletePC(oPC);
  SetCommandable(FALSE, oPC);
}