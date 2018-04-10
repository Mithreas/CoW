/*
  Name: mi_log
  Author: Mithreas
  Date: 10 Sep 06
  Version: 1.2

  Description: Defines the Log(string sStringToLog) method. This outputs a log
               to the server log if the module variable MI_LOGGING is set to 1.

  Updated to add Trace() method for greater control over which components log.
  Updated to integrate with Glorwing's debug flags.
  Updated (Gulni) to include multiple log levels:
  Trace():   Only debugging output, can be disabled.
  Log():     Always logs
  Warning(): Always logs, with additional WARNING: marker in log.
  Error():   Always logs, with additional ERROR: marker in log.

  All log outputs will be formatted consistently with a component string at the start.
*/

// Write a general log string to the server logs.
void Log(string sComponent, string sStringToLog)
{
    WriteTimestampedLogEntry(sComponent + " -- " + sStringToLog);
}

// Write a debug string that can be enabled selectively through module
// variables.
void Trace(string sComponent, string sLog)
{
  if (!GetLocalInt(GetModule(), "MI_DEBUG")) return;
  if (!GetLocalInt(GetModule(), "MI_DEBUG_" + sComponent)) return;

  WriteTimestampedLogEntry(sComponent + " -- " + sLog);
}

// Sends a debug message to oPC if the module is in debug mode.
void DebugMessage(object oPC, string sLog)
{
  if (!GetLocalInt(GetModule(), "MI_DEBUG")) return;
  
  SendMessageToPC(oPC, sLog);
}

// Write a log string for an warning condition that needs to be reported
// even with debugging turned off.
void Warning(string sComponent, string sLog)
{
  WriteTimestampedLogEntry(sComponent + " -- WARNING: " + sLog);
}

// Write a log string for an error condition that needs to be reported
// even with debugging turned off.
void Error(string sComponent, string sLog)
{
  WriteTimestampedLogEntry(sComponent + " -- ERROR: " + sLog);
}

void DMLog(object oDM, object oPC, string sLog)
{
  int dmValid = GetIsObjectValid(oDM);
  int pcValid = GetIsObjectValid(oPC);

  string logOutput = "DMLOG --";

  if (dmValid)
  {
    logOutput += " " + GetName(oDM) + " (" + GetPCPlayerName(oDM) + "), CD Key " + GetPCPublicCDKey(oDM);
  }
  else
  {
    logOutput += " Unknown";
  }

  logOutput += " did action [" + sLog + "]";

  if (pcValid)
  {
    if (GetIsPC(oPC) && !GetIsDM(oPC) && !GetIsDMPossessed(oPC)) {
      logOutput += " to PC " + GetName(oPC);
    } else {
      logOutput += " to " + GetName(oPC);
    }
  }

  if (dmValid || pcValid)
  {
    object area = GetArea(dmValid ? oDM : oPC);
    logOutput += " in area " + GetResRef(area);
  }

  WriteTimestampedLogEntry(logOutput);
}

void LeaderLog(object oLeader, string sLog)
{
  WriteTimestampedLogEntry("LEADER -- " + GetName(oLeader) + " performed action " + sLog);
}
