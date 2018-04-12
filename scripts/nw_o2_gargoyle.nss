//::///////////////////////////////////////////////
//:: NW_O2_GARGOYLE.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Turns the placeable into a gargoyle
   if a player comes near enough.
*/
//:://////////////////////////////////////////////
//:: Created By:   Brent
//:: Created On:   January 17, 2002
//:://////////////////////////////////////////////
#include "gs_inc_common"

void main()
{
   object oCreature = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
   if (GetIsObjectValid(oCreature) == TRUE && GetDistanceToObject(oCreature) < 10.0)
   {
    effect eMind = EffectVisualEffect(VFX_IMP_HOLY_AID);
    string sCreature = GetLocalString(OBJECT_SELF, "MI_CREATURE");
    if (sCreature == "") sCreature = "NW_GARGOYLE";
    object oGargoyle = CreateObject(OBJECT_TYPE_CREATURE, sCreature, GetLocation(OBJECT_SELF));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eMind, oGargoyle);
    SetPlotFlag(OBJECT_SELF, FALSE);
    DestroyObject(OBJECT_SELF, 0.5);

    gsCMCreateRecreator(10*30*60); // 30 RL minutes
   }
}