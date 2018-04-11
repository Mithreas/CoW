//::///////////////////////////////////////////////
//:: Executed Script: Add VFX
//:: exe_addvfx
//:://////////////////////////////////////////////
/*
    Adds VFX to the calling object based on
    variables set on the object.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 23, 2016
//:://////////////////////////////////////////////

void main()
{
    int i;
    int nVFX;

    do
    {
        i++;
        nVFX = GetLocalInt(OBJECT_SELF, "VFX_ADD_" + IntToString(i));
        if(nVFX) ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectVisualEffect(nVFX)), OBJECT_SELF);
    } while(nVFX);
}
