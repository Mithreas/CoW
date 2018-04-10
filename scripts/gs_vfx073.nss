#include "gs_inc_area"

void gsRun()
{
    object oArea = GetArea(OBJECT_SELF);

    // Do an earthquake and trigger some random rockfalls.
    // Assumes 20 waypoints have been set up with tags areatag_1 through _20.

    if (gsARGetIsAreaActive(oArea))
    {
        int nRocks = d3();
        int nCount = 0;
        object oWP;
        object oRock;

        for (nCount; nCount < nRocks; nCount ++)
        {
          oWP = GetWaypointByTag(GetTag(oArea) + "_" + IntToString(Random(20)+1));
          oRock = CreateObject(OBJECT_TYPE_PLACEABLE, "gs_placeable419", GetLocation(oWP));
          AssignCommand(oRock, SetFacing(IntToFloat(Random(360))));
        }

        // Earthquake!
        ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SCREEN_SHAKE), GetLocation(oRock));
        DelayCommand( 2.8, ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, EffectVisualEffect ( VFX_FNF_SCREEN_BUMP), GetLocation(oRock)));
        DelayCommand( 3.0, ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, EffectVisualEffect ( VFX_FNF_SCREEN_SHAKE), GetLocation(oRock)));
        DelayCommand( 4.5, ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, EffectVisualEffect ( VFX_FNF_SCREEN_BUMP), GetLocation(oRock)));
        DelayCommand( 5.8, ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, EffectVisualEffect ( VFX_FNF_SCREEN_BUMP), GetLocation(oRock)));

        // play an earthquake sound
        AssignCommand ( oRock, PlaySound ("as_cv_boomdist1"));
        AssignCommand ( oRock, DelayCommand ( 2.0, PlaySound ("as_wt_thunderds3")));
        AssignCommand ( oRock, DelayCommand ( 4.0, PlaySound ("as_cv_boomdist1")));

        DelayCommand(IntToFloat(Random(75)) + 75.0, gsRun());
    }
}
//----------------------------------------------------------------
void main()
{
    gsRun();
}
