#include "gs_inc_ambience"
#include "gs_inc_time"

void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

    object oArea = GetArea(OBJECT_SELF);
    int nType    = GetLocalInt(OBJECT_SELF, "GS_AM_TYPE");
    int nOption  = GS_AM_OPTION_NONE;

    if (GetLocalInt(OBJECT_SELF, "GS_AM_LIGHTING"))  nOption |= GS_AM_OPTION_LIGHTING;
    if (GetLocalInt(OBJECT_SELF, "GS_AM_FOG"))       nOption |= GS_AM_OPTION_FOG;
    if (GetLocalInt(OBJECT_SELF, "GS_AM_SKY"))       nOption |= GS_AM_OPTION_SKY;
    if (GetLocalInt(OBJECT_SELF, "GS_AM_WEATHER"))   nOption |= GS_AM_OPTION_WEATHER;

    gsAMSetAmbienceType(nType, oArea);
    gsAMSetAmbienceOption(nOption, oArea);

    if (gsTIGetDayTime(oArea) != GS_TI_DAYTIME_NONE) gsAMApplyAmbience(nType, oArea, nOption);

    DestroyObject(OBJECT_SELF);
}
