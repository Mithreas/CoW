#include "inc_ambience"
#include "inc_time"

void main()
{
    int nDayTime = gsTIGetCurrentDayTime();

    if (nDayTime != gsTIGetDayTime())
    {
        gsTISetDayTime(OBJECT_SELF, nDayTime);
        gsAMRefreshAmbience();
    }
    else if (gsAMGetAmbienceOption() & GS_AM_OPTION_WEATHER)
    {
        if (Random(100) >= 95)
        {
            gsAMApplyAmbience(
                gsAMGetAmbienceType(),
                OBJECT_SELF,
                GS_AM_OPTION_WEATHER);
        }
    }
    else
    {
        gsAMApplyWeatherEffect();
    }
}
