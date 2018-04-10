//::///////////////////////////////////////////////
//:: On Death: Angel of Decay
//:: dth_angelofdecay
//:://////////////////////////////////////////////
/*
    The angel of decay explodes into rampant pus.
    My, how ghastly!
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 22, 2017
//:://////////////////////////////////////////////

#include "inc_math"

// Creates a maggot at a random location within 1m of the source.
void CreateMaggot(location lSource);

void main()
{
    location lLoc = GetLocation(OBJECT_SELF);
    int i;
    int nMaggots = d4(2);

    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectAreaOfEffect(AOE_MOB_TROGLODYTE_STENCH, "****", "****", "****"), lLoc, 6.0);
    DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_GREEN_MEDIUM), OBJECT_SELF));
    DelayCommand(0.5, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectAreaOfEffect(43, "****", "****", "****"), lLoc, 3.0));

    for(i = 0; i <= nMaggots; i++)
    {
        DelayCommand(0.1, CreateMaggot(lLoc));
    }
}

//::///////////////////////////////////////////////
//:: CreateMaggot
//:://////////////////////////////////////////////
/*
    Creates a maggot at a random location
    within 1m of the source.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 24, 2017
//:://////////////////////////////////////////////
void CreateMaggot(location lSource)
{
    CreateObject(OBJECT_TYPE_CREATURE, "sum_maggot", Location(GetAreaFromLocation(lSource), GetPositionFromLocation(lSource) + GenerateCircleCoordinate(1), IntToFloat(Random(360))));
}
