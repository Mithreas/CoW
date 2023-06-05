// Randomly spawns the creature whose resref is set as MI_CREATURE on this
// object.
//
// % spawn chance is MI_SPAWN_CHANCE (int, 0-100).
//
// Timeout is MI_TIMEOUT (int), defaults to the usual area cleanup timeout of
// 1 hour.
//
// Optional variables:
//
// MI_SPAWN_WAYPOINT (string) - tag of waypoint to spawn at
// MI_SPAWN_MINLEVEL (int) - min hit dice of the entering creature

#include "inc_flag"
#include "inc_log"
#include "ar_utils"

const string RANDOMSPAWN = "RANDOMSPAWN";   //:: For tracing

void main()
{

  object oTrigger  = OBJECT_SELF;
  object oEntering = GetEnteringObject();   //::  trigger
  //::  Maybe it was a placeable
  if ( !GetIsObjectValid(oEntering) )   oEntering = GetLastUsedBy();
  //::  Maybe it was a from a dialog
  if ( !GetIsObjectValid(oEntering) )   oEntering = GetPCSpeaker();

  if (!GetIsPC(oEntering)) return;

  string sResRef = GetLocalString(oTrigger, "MI_CREATURE");         // MI_CREATURE, MI_CREATURE_2, MI_CREATURE_3 (ResRefs)
  string sName   = GetLocalString(oTrigger, "MI_SETNAME");          // MI_SETNAME, MI_SETNAME_2, MI_SETNAME_3 (Optional name override)

  int    nChance = GetLocalInt(oTrigger, "MI_SPAWN_CHANCE");        // Spawn chance as an integer from 0-100
  int    nTimeout = GetLocalInt(oTrigger, "MI_TIMEOUT");            // Time in GAME HOURS between spawns.

  string sWaypoint = GetLocalString(oTrigger, "MI_SPAWN_WAYPOINT");
  int    nMinLevel = GetLocalInt(oTrigger, "MI_SPAWN_MINLEVEL");

  int bBurrowing     = GetLocalInt(oTrigger, "MI_BURROW");
  int bNoAnim        = GetLocalInt(oTrigger, "MI_NO_ANIM");         // If set to 1, do not use bAppearAnimation
  bNoAnim = (bNoAnim + 1) % 2;                                      // 1 becomes 0, 0 becomes 1.
  if (bBurrowing) bNoAnim = 0;
  int bDetect        = GetLocalInt(oTrigger, "MI_DETECT");          // Spawn in detect mode
  int bStealth       = GetLocalInt(oTrigger, "MI_STEALTH");         // Spawn in stealth mode

  int nMultiSpawn    = GetLocalInt(oTrigger, "MI_MULTI_SPAWN");     // If set to 1, will spawn in multiple enemy sets
  int nMultiSpawnNum = GetLocalInt(oTrigger, "MI_MULTI_NUM");       // MI_MULTI_NUM, MI_MULTI_NUM_2, MI_MULTI_NUM_3 ... (Multiplicity of MI_CREATURE, MI_CREATURE is many to one MI_MULTI_NUM)
  string sPCMessage  = GetLocalString(oTrigger, "MI_MESSAGE");      // Message to be delivered in PC's combat log
  string sOneLiner   = GetLocalString(oTrigger, "MI_ONELINER");     // String spoken by the lead spawn

  int nHour = GetTimeHour();
  int bDay = nHour > 6 && nHour < 21;

  int bNightSwitch = GetLocalInt(oTrigger, "MI_NIGHTSPAWNS");
  int nDespawn = GetLocalInt(oTrigger, "MI_DESPAWN");

  if (!nMultiSpawn)    nMultiSpawnNum = 1;
  if (!nMultiSpawnNum) nMultiSpawnNum = 1;

  string sNewTag        = GetLocalString(oTrigger, "MI_SETTAG");      // If empty, default tag will be used.

  // Valid resref?
  if (sResRef == "") return;
  if ((!nTimeout)||(nTimeout == 0)) nTimeout = 1; // One game hour.

  // Have we fired recently?
  int nTimestamp        = GetLocalInt(GetModule(), "GS_TIMESTAMP");
  int nTimestampTrigger = GetLocalInt(oTrigger, "GS_TIMESTAMP");

  if (abs(nTimestamp - nTimestampTrigger) < (nTimeout * 3600)) return;
  SetLocalInt(oTrigger, "GS_TIMESTAMP", nTimestamp);

  //::  Clean language use from One-liners
  if ( FindSubString(sOneLiner, "-xa") != -1) {
    sOneLiner = GetStringRight(sOneLiner, 3);
  }

  // Do we have a hit dice limit?
  if (nMinLevel && GetHitDice(oEntering) < nMinLevel) return;

  // Day and Night restrictions
  if (bNightSwitch != 0  &&
     (bNightSwitch == 1 && bDay) &&
     (bNightSwitch == 2 && !bDay))
  {
    // Don't run
    return;
  }

  // Do we have a location?
  location lLoc = GetLocation(oTrigger);
  object oWaypoint = GetObjectByTag(sWaypoint);
  if (GetIsObjectValid(oWaypoint)) lLoc = GetLocation(oWaypoint);

  // Create creature.
  if (d100() < nChance)
  {
    //::  Log it!
    Log(RANDOMSPAWN, "A Random Spawn was Triggered by " + GetName(oEntering, TRUE) + " in " + GetName(GetArea(OBJECT_SELF)) + ".");

    int nCreatureNum;
    int nResRefCounter = 1;
    object oSpawn;
    int iEffect = GetLocalInt(oTrigger, "AR_VFX");

    // Loop through MI_CREATURE, MI_CREATURE_2, MI_CREATURE_3 (ResRefs)
    while (sResRef != "")
    {
        // Create instance of creature nMultispawn number of times
        for (nCreatureNum = 0; nCreatureNum < nMultiSpawnNum; nCreatureNum++)
        {
            oSpawn = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lLoc, bNoAnim, sNewTag);
            SetLocalInt(oSpawn, "MI_DESPAWN", nDespawn);
            SetLocalInt(oSpawn, "MI_SPAWN", nTimestamp);
            SetLocalInt(oSpawn, "MI_SPAWNHOUR", GetTimeHour());
            gsFLSetFlag(GS_FL_ENCOUNTER, oSpawn);

            //First creature speaks the one-liner.
            if ((nCreatureNum == 0)&&(nResRefCounter==1)&&(sOneLiner != "")&&(sOneLiner != "0"))
            {
                DelayCommand(0.5, AssignCommand(oSpawn, ActionSpeakString(sOneLiner)));
            }

            // burrowing vfx if applicable
            if (bBurrowing)
            {
                effect eBurrow = EffectVisualEffect(137);
                DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBurrow, oSpawn, 4.0));
            }

            //::  Apply VFX
            if ( iEffect != 0 ) {
                //ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(iEffect), oSpawn);
                ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(iEffect), lLoc);
            }

            // Set action modes
            if (bStealth)  SetActionMode(oSpawn, ACTION_MODE_STEALTH, TRUE);
            if (bDetect) SetActionMode(oSpawn, ACTION_MODE_DETECT, TRUE);

            // Set name
            if (sName != "") SetName(oSpawn, sName);
        }

        if (!nMultiSpawn) break;
        // Next ResRef
        nResRefCounter++;
        sResRef = GetLocalString(oTrigger, "MI_CREATURE_"+IntToString(nResRefCounter));
        sName   = GetLocalString(oTrigger, "MI_SETNAME_"+IntToString(nResRefCounter));
        nMultiSpawnNum = GetLocalInt(oTrigger, "MI_MULTI_NUM_"+IntToString(nResRefCounter));
        // Must be at least 1 instance of multi-spawn number for each ResRef
        if (!nMultiSpawnNum) nMultiSpawnNum = 1;
    }

    // Encounter flavor text to first PC
    if ((sPCMessage != "")&&(sPCMessage != "0"))
    {
        FloatingTextStringOnCreature(sPCMessage, oEntering, TRUE);
    }
  }
}
