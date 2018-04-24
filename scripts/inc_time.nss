/* TIME Library by Gigaschatten */

//void main() {}

const int GS_TI_DAYTIME_NONE    =  0;
const int GS_TI_DAYTIME_DAY     =  1;
const int GS_TI_DAYTIME_NIGHT   =  2;
const int GS_TI_DAYTIME_CURRENT = -1;

//return actual timestamp
int gsTIGetActualTimestamp();
//return timestamp of given date
int gsTIGetTimestamp(int nYear, int nMonth = 0, int nDay = 0, int nHour = 0, int nMinute = 0, int nSecond = 0);
//retun year from nTimestamp (modified for module starting date)
int gsTIGetYear(int nTimestamp);
//retun year from nTimestamp (not modified for module starting date)
int gsTIGetAbsoluteYear(int nTimestamp);
//return month from nTimestamp
int gsTIGetMonth(int nTimestamp);
//return day from nTimestamp
int gsTIGetDay(int nTimestamp);
//return hour from nTimestamp
int gsTIGetHour(int nTimestamp);
//return minute from nTimestamp
int gsTIGetMinute(int nTimestamp);
//return second from nTimestamp
int gsTIGetSecond(int nTimestamp = 0);
//return game timestamp derived from realtime nTimestamp
int gsTIGetGameTimestamp(int nTimestamp = 0);
//return real timestamp derived from gametime nTimestamp
int gsTIGetRealTimestamp(int nTimestamp = 0);
//return standardized actual game minute (0 to 59)
int gsTIGetActualGameMinute();
//set game time to nTimestamp
void gsTISetTime(int nTimestamp);
//return current day time
int gsTIGetCurrentDayTime();
//return day time of oObject
int gsTIGetDayTime(object oObject = OBJECT_SELF);
//set nDayTime of oObject
void gsTISetDayTime(object oObject = OBJECT_SELF, int nDayTime = GS_TI_DAYTIME_CURRENT);
//return timestamp rounded to hour from nTimestamp
int gsTIGetFullHour(int nTimestamp);
//return a timestamp representing time1 - time2
int gsTIGetDifference(int nTime1, int nTime2);
//return a nicely formatted time and date - if nTime isn't specified, uses the
//current time.
string gsTIGetPresentableTime(int nTime=0);
// Returns the current time in seconds.
int GetModuleTime();

// This value is set in module properties.  We can calculate it dynamically from
// HoursToSeconds() etc, but having it as a constant makes it easier to follow
// the code.
const int MINUTES_PER_HOUR = 15;

int gsTIGetActualTimestamp()
{
    return gsTIGetTimestamp(GetCalendarYear(),
                            GetCalendarMonth() - 1,
                            GetCalendarDay() - 1,
                            GetTimeHour(),
                            GetTimeMinute(),
                            GetTimeSecond());
}
//----------------------------------------------------------------
int gsTIGetTimestamp(int nYear, int nMonth = 0, int nDay = 0, int nHour = 0, int nMinute = 0, int nSecond = 0)
{
    if (nYear) nYear -= GetLocalInt(GetModule(), "GS_YEAR");

    return 29030400 * nYear +
            2419200 * nMonth +
              86400 * nDay +
               3600 * nHour +
                3600/MINUTES_PER_HOUR * nMinute +
                  60/MINUTES_PER_HOUR * nSecond;
}
//----------------------------------------------------------------
int gsTIGetYear(int nTimestamp)
{
    return GetLocalInt(GetModule(), "GS_YEAR") + nTimestamp / 29030400;
}
//----------------------------------------------------------------
int gsTIGetAbsoluteYear(int nTimestamp)
{
    return nTimestamp / 29030400;
}
//----------------------------------------------------------------
int gsTIGetMonth(int nTimestamp)
{
    return nTimestamp % 29030400 / 2419200 + 1;
}
//----------------------------------------------------------------
int gsTIGetDay(int nTimestamp)
{
    return nTimestamp % 2419200 / 86400 + 1;
}
//----------------------------------------------------------------
int gsTIGetHour(int nTimestamp)
{
    return nTimestamp % 86400 / 3600;
}
//----------------------------------------------------------------
int gsTIGetMinute(int nTimestamp)
{
    return nTimestamp % 3600 / 60;
}
//----------------------------------------------------------------
int gsTIGetSecond(int nTimestamp = 0)
{
    return nTimestamp % 60;
}
//----------------------------------------------------------------
int gsTIGetGameTimestamp(int nTimestamp = 0)
{
    float fFloat = HoursToSeconds(1) / 3600.0;

    return FloatToInt(IntToFloat(nTimestamp) / fFloat);
}
//----------------------------------------------------------------
int gsTIGetRealTimestamp(int nTimestamp = 0)
{
    float fFloat = HoursToSeconds(1) / 3600.0;

    return FloatToInt(IntToFloat(nTimestamp) * fFloat);
}
//----------------------------------------------------------------
int gsTIGetActualGameMinute()
{
    float fFloat = 3600.0 / HoursToSeconds(1);

    return FloatToInt((IntToFloat(GetTimeMinute()) + IntToFloat(GetTimeSecond()) / 60) * fFloat);
}
//----------------------------------------------------------------
void gsTISetTime(int nTimestamp)
{
    SetTime(gsTIGetHour(nTimestamp), gsTIGetMinute(nTimestamp), gsTIGetSecond(nTimestamp), 0);
    SetCalendar(gsTIGetYear(nTimestamp), gsTIGetMonth(nTimestamp), gsTIGetDay(nTimestamp));

    SetLocalInt(OBJECT_SELF, "GS_TIMESTAMP", gsTIGetActualTimestamp());
}
//----------------------------------------------------------------
int gsTIGetCurrentDayTime()
{
    return GetIsDay() || GetIsDusk() ? GS_TI_DAYTIME_DAY : GS_TI_DAYTIME_NIGHT;
}
//----------------------------------------------------------------
int gsTIGetDayTime(object oObject = OBJECT_SELF)
{
    return GetLocalInt(oObject, "GS_TI_DAYTIME");
}
//----------------------------------------------------------------
void gsTISetDayTime(object oObject = OBJECT_SELF, int nDayTime = GS_TI_DAYTIME_CURRENT)
{
    if (nDayTime == GS_TI_DAYTIME_CURRENT) nDayTime = gsTIGetCurrentDayTime();
    SetLocalInt(oObject, "GS_TI_DAYTIME", nDayTime);
}
//----------------------------------------------------------------
int gsTIGetFullHour(int nTimestamp)
{
    int nNth = nTimestamp % 3600;
    if (nNth / 60 >= 15) return nTimestamp - nNth + 3600;
    else                 return nTimestamp - nNth;
}
//----------------------------------------------------------------
string gsTIGetPresentableTime(int nTime=0)
{
  if (!nTime) nTime = gsTIGetActualTimestamp();

  string sDate = "Day ";

  sDate += IntToString(gsTIGetDay(nTime));

  switch (gsTIGetMonth(nTime))
  {
    case 1:
      sDate += " - Month 1 (Hammer (Deepwinter)) - Year ";
      break;
    case 2:
      sDate += " - Month 2 (Alturiak) - Year ";
      break;
    case 3:
      sDate += " - Month 3 (Ches) - Year ";
      break;
    case 4:
      sDate += " - Month 4 (Tarsakh) - Year ";
      break;
    case 5:
      sDate += " - Month 5 (Mirtul) - Year ";
      break;
    case 6:
      sDate += " - Month 6 (Kythorn) - Year ";
      break;
    case 7:
      sDate += " - Month 7 (Flamerule (Summertide)) - Year ";
      break;
    case 8:
      sDate += " - Month 8 (Elasias (Highsun)) - Year ";
      break;
    case 9:
      sDate += " - Month 9 (Eleint) - Year ";
      break;
    case 10:
      sDate += " - Month 10 (Marpenoth (Leafall)) - Year ";
      break;
    case 11:
      sDate += " - Month 11 (Uktar) - Year ";
      break;
    case 12:
      sDate += " - Month 12 (Nightal) - Year ";
      break;
  }

  sDate += IntToString(gsTIGetYear(nTime));

  return sDate;
}

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
