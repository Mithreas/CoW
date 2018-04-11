/*
  Name: inc_log
  Author: Mithreas
  Date: 4 Sep 05
  Version: 1.0

  Description: Defines the Log(string sStringToLog) method. This outputs a log
               to the server log if the module variable MI_LOGGING is set to 1.
*/
//------------------------------------------------------------------------------
// If module logging is enabled (MI_LOGGING flag set to true in the module) will
// write a timestamped log entry. If logging is disabled, does nothing.
//------------------------------------------------------------------------------
void Log(string sStringToLog);
void Log(string sStringToLog)
{
  if (GetLocalInt(GetModule(), "MI_LOGGING"))
  {
    WriteTimestampedLogEntry(sStringToLog);
  }
}

//------------------------------------------------------------------------------
// Logs only if MI_LOGGING is set to true and MI_LOGGING_sMethod is set to true.
// Where sMethod can be any string.
//------------------------------------------------------------------------------
void Trace(string sMethod, string sStringToLog);
void Trace(string sMethod, string sStringToLog)
{
  if (GetLocalInt(GetModule(), "MI_LOGGING"))
  {
    if (GetLocalInt(GetModule(), "MI_LOGGING_" + sMethod))
    {
      WriteTimestampedLogEntry(sMethod + " --- " + sStringToLog);
    }
  }
}
