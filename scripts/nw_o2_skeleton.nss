//::///////////////////////////////////////////////
//:: NW_O2_SKELETON.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Turns the placeable into a skeleton
   if a player comes near enough.
*/
//:://////////////////////////////////////////////
//:: Created By:   Brent
//:: Created On:   January 17, 2002
//:://////////////////////////////////////////////
#include "inc_common"
#include "inc_flag"
void ActionCreate(string sCreature, location lLoc)
{
    object oCreature = CreateObject(OBJECT_TYPE_CREATURE, sCreature, lLoc);
	gsFLSetFlag(GS_FL_ENCOUNTER, oCreature);
}
void main()
{
   object oCreature = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
   if (GetIsObjectValid(oCreature) == TRUE && GetDistanceToObject(oCreature) < 10.0)
   {
    effect eMind = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
    string sCreature = GetLocalString(OBJECT_SELF, "MI_CREATURE");
    if (sCreature == "") 
	{
	  sCreature = "NW_SKELWARR01";
      // * 10% chance of a skeleton chief instead
      if (Random(100) > 90)
      {
        sCreature = "NW_SKELCHIEF";
      }
	}
	
    location lLoc = GetLocation(OBJECT_SELF);
    DelayCommand(0.3, ActionCreate(sCreature, lLoc));
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eMind, GetLocation(OBJECT_SELF));
    SetPlotFlag(OBJECT_SELF, FALSE);
    DestroyObject(OBJECT_SELF, 0.5);
	
    // gsCMCreateRecreator(10*30*60); // Removed - applied via the Effect: Skeleton Ambushers GS_ACTIVATOR (pl_doskellies)
   }
}