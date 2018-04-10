/*
  Name: mi_onareaenter
  Author: Mithreas
  Date: 14/01/06
  Description: City of Winds area OnEnter script. Implements the area counter.
*/
#include "mi_log"
#include "aps_include"
#include "mi_randquestcomm"
#include "cow_xp"
const string AREA_COUNTER_TABLE = "pwareadata";
const string AC_LOG = "AREA_COUNTER"; // See mi_log

void IncrementAreaCounter()
{
  Trace(AC_LOG, "Entering Area Counter");
  object oPC = GetEnteringObject();
  if (!GetIsPC(oPC)) return;
  Trace(AC_LOG, "Got PC");

  int nCount = GetPersistentInt(OBJECT_INVALID, GetName(OBJECT_SELF), AREA_COUNTER_TABLE);
  Trace(AC_LOG, "Area had been entered " + IntToString(nCount) + " times");
  DeletePersistentVariable(OBJECT_INVALID,  GetName(OBJECT_SELF), AREA_COUNTER_TABLE);
  nCount++;
  SetPersistentInt(OBJECT_INVALID, GetName(OBJECT_SELF), nCount, 0, AREA_COUNTER_TABLE);
  Trace(AC_LOG, "Area has now been entered " + IntToString(nCount) + " times");
  Trace(AC_LOG, "Exiting Area Counter");
}

void main()
{
  object oPC = GetEnteringObject();
  if(!GetIsPC(oPC)) return;

  // Clear PC state if they've been using the training/research/praying widgets
  // and logged off unexpectedly, or changed areas.
  DeleteLocalInt(oPC, "training_time");
  DeleteLocalInt(oPC, "is_training");
  DeleteLocalLocation(oPC, "pray_location");
  DeleteLocalInt(oPC, "praying_time");
  DeleteLocalLocation(oPC, "research_location");
  DeleteLocalInt(oPC, "research_time");

  string sDescription = GetLocalString(OBJECT_SELF, "description");
  if (sDescription != "")
  {
    SendMessageToPC(oPC, sDescription);
  }

  IncrementAreaCounter();

  // Check whether to explore the area.
  if (GetLocalInt(OBJECT_SELF, "explore") == 1)
  {
    ExploreAreaForPlayer(OBJECT_SELF, oPC);
  }

  // Hook into the quest scripts.
  CheckIfOnPatrol(oPC, OBJECT_SELF);

  //Get exploration xp if you haven't been here before

  if (GetPersistentInt(oPC, GetTag(OBJECT_SELF) + "_visited") == 0)
  {
    GiveXPToPC(oPC);
    SetPersistentInt(oPC, GetTag(OBJECT_SELF) + "_visited", 1);
  }
}
