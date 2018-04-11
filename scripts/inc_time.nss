//::///////////////////////////////////////////////
//:: Time Library
//:: inc_time
//:://////////////////////////////////////////////
/*
    Contains functions concerning timing.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 30, 2016
//:://////////////////////////////////////////////

/**********************************************************************
 * PUBLIC FUNCTION PROTOTYPES
 **********************************************************************/

// Returns the current time in seconds.
int GetModuleTime();

/**********************************************************************
 * PUBLIC FUNCTION DEFINITIONS
 **********************************************************************/

//::///////////////////////////////////////////////
//:: GetModuleTime
//:://////////////////////////////////////////////
/*
    Returns the current time in seconds.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 26, 2016
//:://////////////////////////////////////////////
int GetModuleTime()
{
    return 2903040 * (GetCalendarYear() - GetLocalInt(GetModule(), "GS_YEAR"))
        + 241920 * (GetCalendarMonth() - 1)
        + 8640 * (GetCalendarDay() - 1)
        + 360 * GetTimeHour()
        + 60 * GetTimeMinute()
        + GetTimeSecond();
}
