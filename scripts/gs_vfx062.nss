#include "inc_area"

void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

    object oArea     = GetArea(OBJECT_SELF);
    object oObject   = OBJECT_INVALID;
    location lLocation;
    vector vPosition = GetPosition(OBJECT_SELF);
    float fSizeX     = gsARGetSizeX(oArea);
    float fSizeY     = gsARGetSizeY(oArea);
    int nEffect      = GetLocalInt(OBJECT_SELF, "GS_EFFECT");
    effect eEffect   = ExtraordinaryEffect(EffectVisualEffect(nEffect));

    vPosition.x    = 5.0;

    while (vPosition.x < fSizeX)
    {
        vPosition.y  = 5.0;

        while (vPosition.y < fSizeY)
        {
            lLocation    = Location(oArea, vPosition, 0.0);
            oObject      = CreateObject(OBJECT_TYPE_PLACEABLE, "gs_null", lLocation);

            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oObject);

            vPosition.y += 10.0;
        }

        vPosition.x += 10.0;
    }

    DestroyObject(OBJECT_SELF);
}
