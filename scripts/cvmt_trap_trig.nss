// Look for the two placeables with tag matching ours plus _1 and _2.
// If both have appearance 159 (blue sparks), okay.  If either has 164, trigger a big trap.
#include "nwnx_object"
#include "NW_I0_SPELLS"

void main()
{
    object oTarget = GetEnteringObject();
    if (! (GetIsPC(oTarget) || GetIsPC(GetMaster(oTarget)))) return; 

    object oSparks1 = GetObjectByTag(GetTag(OBJECT_SELF) + "_1");
    object oSparks2 = GetObjectByTag(GetTag(OBJECT_SELF) + "_2");
  
    if (NWNX_Object_GetAppearance(oSparks1) == 159 && NWNX_Object_GetAppearance(oSparks2) == 159) return;
   
    effect eDam = EffectDamage(d4(40), DAMAGE_TYPE_DIVINE);
	
    effect eFNF = EffectVisualEffect(VFX_FNF_SOUND_BURST);
	
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eFNF, GetLocation(GetEnteringObject()));
}