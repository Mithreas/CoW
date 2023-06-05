//::///////////////////////////////////////////////
//:: x2_door_death
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    On death of a door it spawns in an appropriate
    item component.
    Updated by Mithreas 17 Apr 06 to also add to your bounty if you bash a
    door near an NPC.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: August 2003
//:://////////////////////////////////////////////
#include "x2_inc_compon"
#include "inc_crime"
#include "nwnx_object"

void DoRespawnDoor(string sDoor, vector vPosition, float fFacing)
{
  object oNewDoor = NWNX_Object_Deserialize(sDoor);
  NWNX_Object_AddToArea(oNewDoor, OBJECT_SELF, vPosition);
  NWNX_Object_SetFacing(oNewDoor, fFacing);
}

void main()
{
	//Check that this script hasn't already fired.
	if (GetLocalInt(OBJECT_SELF, "DESTROYED")) return;
	SetLocalInt(OBJECT_SELF, "DESTROYED", TRUE);

  /*
    Author: Mithreas
    Date: 17 Apr 06
    Description: Add to a PC's bounty if they bash down a door in front of an
    NPC.
  */
  object oPC = GetLastHostileActor();
  if (GetIsPC(oPC))
  {
    int nCount = 1;
    object oNPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,
                                     PLAYER_CHAR_NOT_PC,
                                     OBJECT_SELF,
                                     nCount);
    Trace(BOUNTY, "Door bashed. Found NPC: " + GetName(oNPC));
    float fDistance = GetDistanceBetween(OBJECT_SELF, oNPC);

    while (fDistance < 20.0 && GetIsObjectValid(oNPC))
    {
      Trace(BOUNTY, "NPC is close enough. Checking faction and visibility.");
      int nNation = CheckFactionNation(oNPC);
      if (GetCanSeeParticularPC(oPC, oNPC) && (nNation != NATION_INVALID))
      {
        Trace(BOUNTY, "NPC is from a nation that gives bounties, and can see PC.");
        AddToBounty(nNation, FINE_THEFT + Random(FINE_THEFT), oPC);
        break; // Only add to one bounty
      }

      nCount++;
      oNPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,
                              PLAYER_CHAR_NOT_PC,
                              OBJECT_SELF,
                              nCount);
      Trace(BOUNTY, "Got next NPC: " + GetName(oNPC));
      fDistance = GetDistanceBetween(OBJECT_SELF, oNPC);
    }

  }
  
  // Respawn the door. 
  string sDoor = GetLocalString (OBJECT_SELF, "NWNX_OBJECT_STRING");
  vector vPos = GetPosition(OBJECT_SELF);
  float fFacing = GetFacing(OBJECT_SELF);
  if (sDoor != "") AssignCommand(GetArea(OBJECT_SELF), DelayCommand(1800.0f, DoRespawnDoor(sDoor, vPos, fFacing)));

  craft_drop_placeable();
}
