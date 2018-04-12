/**
 * inc_external
 *
 * Deals with communicating with the operating system under which nwserver runs.
 * Note that this requires nwnx_ruby to run. For information about Ruby classes
 * and methods, refer to extern.rb and the files it includes.
 */

#include "inc_pc"
#include "inc_log"
#include "inc_database"
#include "inc_xfer"
#include "nwnx_ruby"
#include "nwnx_admin"

// Execute the ruby code sCode directly, and returns the result.
string fbEXRubyDirect(string sCode);
// Escape sInput by replacing \ by \\ and " by \".
string fbEXRubyEscape(string sInput);
// Prepares sCode
string fbEXPrepareStatement(string sCode, string sStr0 = "", string sStr1 = "", string sStr2 = "", string sStr3 = "", string sStr4 = "");
// Execute the ruby code sCode, replacing each ? in turn by sStr0, sStr1, etc.
// Do not surround ? with quotes.
// Example:
// - fbEXRuby("puts ?", sText);
string fbEXRuby(string sCode, string sStr0 = "", string sStr1 = "", string sStr2 = "", string sStr3 = "", string sStr4 = "");

// Some commands require a PC to be booted. In this case, store sCommand on
// oObject, to be executed on the next call of fbEXFlush().
void fbEXDoLater(string sCommand, object oObject);
// Wrapper for fbEXDoLater that additionally boots/portals the PC.
void fbEXDoAndPortal(string sCommand, object oObject, int bPortal = TRUE);
// Do any commands on oObject that have been stored.
void fbEXFlush(object oObject);
// Clear any commands on oObject so they are not executed more than once.
void fbEXClear(object oObject);

// A wrapper for fbEXDoAndPortal that deletes oPC.
void fbEXDeletePC(object oPC);
// Changes the name of oPC to sNewName.
void fbEXChangeName(object oPC, string sNewName);
// Fixes oPC's movement if it has gone wonky.
void fbEXFixMovement(object oPC);

string fbEXRubyDirect(string sCode)
{
  Log("EXTERNAL", "Command passed to Ruby: " + sCode);
  string sResponse = NWNX_Ruby_Evaluate(sCode); //-- disabled until NWNX Ruby available
  Log("EXTERNAL", "Response: " + sResponse);
  return sResponse;
}
//------------------------------------------------------------------------------
string fbEXRubyEscape(string sInput)
{
  Trace("EXTERNAL", "Escaping string " + sInput);
  object oModule      = GetModule();
  string sDoubleQuote = GetLocalString(oModule, "GS_DOUBLE_QUOTE");
  string sBackslash   = GetLocalString(oModule, "GS_BACKSLASH");

  int nPos      = 0;
  string sLeft  = "";
  string sRight = sInput;

  while ((nPos = FindSubString(sRight, sBackslash)) != -1)
  {
    sLeft += GetStringLeft(sRight, nPos) + sBackslash + sBackslash;
    sRight = GetStringRight(sRight, GetStringLength(sRight) - (nPos + 1));
  }

  sRight = sLeft + sRight;
  sLeft = "";

  while ((nPos = FindSubString(sRight, sDoubleQuote)) != -1)
  {
    sLeft += GetStringLeft(sRight, nPos) + sBackslash + sDoubleQuote;
    sRight = GetStringRight(sRight, GetStringLength(sRight) - (nPos + 1));
  }

  Trace("EXTERNAL", "Result: " + sLeft + sRight);
  return sLeft + sRight;
}
//------------------------------------------------------------------------------
string fbEXPrepareStatement(string sCode, string sStr0 = "", string sStr1 = "", string sStr2 = "", string sStr3 = "", string sStr4 = "")
{
  int nPos, nCount = 0;

  string sLeft = "", sRight = sCode;
  string sDoubleQuote = GetLocalString(GetModule(), "GS_DOUBLE_QUOTE");

  while ((nPos = FindSubString(sRight, "?")) != -1)
  {
    string sInsert;

    switch (nCount++)
    {
      case 0:  sInsert = sStr0; break;
      case 1:  sInsert = sStr1; break;
      case 2:  sInsert = sStr2; break;
      case 3:  sInsert = sStr3; break;
      case 4:  sInsert = sStr4; break;
      default: sInsert = "*INVALID*"; break;
    }

    sLeft += GetStringLeft(sRight, nPos) + sDoubleQuote + fbEXRubyEscape(sInsert) + sDoubleQuote;
    sRight = GetStringRight(sRight, GetStringLength(sRight) - (nPos + 1));
  }

  return sLeft + sRight;
}
//------------------------------------------------------------------------------
string fbEXRuby(string sCode, string sStr0 = "", string sStr1 = "", string sStr2 = "", string sStr3 = "", string sStr4 = "")
{
  return fbEXRubyDirect(fbEXPrepareStatement(sCode, sStr0, sStr1, sStr2, sStr3, sStr4));
}
//------------------------------------------------------------------------------
void fbEXDoLater(string sCommand, object oObject)
{
  int nCommands = GetLocalInt(oObject, "FB_EX_COMMANDS");
  SetLocalString(oObject, "FB_EX_COMMAND" + IntToString(nCommands), sCommand);
  SetLocalInt(oObject, "FB_EX_COMMANDS", nCommands + 1);
}
//------------------------------------------------------------------------------
void fbEXDoAndPortal(string sCommand, object oObject, int bPortal = TRUE)
{
  object oModule = GetModule();
  string sIP     = GetLocalString(oModule, "DS_LETOSCRIPT_PORTAL_IP");
  string sPass   = GetLocalString(oModule, "DS_LETOSCRIPT_PORTAL_PASSWORD");
  bPortal       &= GetLocalInt(oModule, "DS_LETOSCRIPT_USES_PORTAL");

  fbEXDoLater(sCommand, oObject);

  if (bPortal && sIP != "")
  {

    ExportSingleCharacter(oObject);
    gsPCSavePCLocation(oObject, GetLocation(oObject));
    miXFUnregisterPlayer(oObject);

    DelayCommand(2.5f, ActivatePortal(oObject, sIP, sPass, "", TRUE));

    // Sometimes portalling fails, e.g. when the server is full. If this
    // happens, explain to the PC.
    AssignCommand(oObject, DelayCommand(5.0, SendMessageToPC(oObject,
     "If you failed to portal, please quit the game and rejoin. This is " +
     "needed to apply your changes to your character. Thank you.")));
  }
  else
  {
    DelayCommand(2.5f, BootPC(oObject));
  }
}
//------------------------------------------------------------------------------
void fbEXFlush(object oObject)
{
  int nCommands = GetLocalInt(oObject, "FB_EX_COMMANDS");
  int nI        = 0;

  Trace("EXTERNAL", "fbEXFlush called on " + GetName(oObject) + " with " + IntToString(nCommands) + " commands.");

  for (; nI < nCommands; nI++)
  {
    fbEXRubyDirect(GetLocalString(oObject, "FB_EX_COMMAND" + IntToString(nI)));
  }
}
//------------------------------------------------------------------------------
void fbEXClear(object oObject)
{
  // No need to delete the commands themselves - once we lose the reference they
  // are harmless.
  SetLocalInt(oObject, "FB_EX_COMMANDS", 0);
}
//------------------------------------------------------------------------------
void _Delete(object oPC)
{
    NWNX_Administration_DeletePlayerCharacter(oPC);
    JumpToObject(GetWaypointByTag("WP_DELETED"), 0);
}
void fbEXDeletePC(object oPC)
{
  if (!GetIsPC(oPC) || GetIsDM(oPC))
  {
    return;
  }

  SendMessageToPC(oPC, "<cþþ >Deleting character. You will be "+
    "sent to the character selection screen, hold tight!");

  //fbEXDoAndPortal(fbEXPrepareStatement("Bic.remove(?, ?)", GetPCPlayerName(oPC),
   // GetName(oPC)), oPC);
  DelayCommand(2.5, _Delete(oPC));
  miDASetKeyedValue("gs_pc_data", gsPCGetPlayerID(oPC), "deleted", "1");
  DeleteLocalString(oPC, "GS_PC_ID");
  SetLocalInt(gsPCGetCreatureHide(oPC), "CONFIRM_DELETE", 2);
}
//------------------------------------------------------------------------------
void fbEXChangeName(object oPC, string sNewName)
{
  if (!GetIsPC(oPC) || GetIsDM(oPC))
  {
    return;
  }

  // dunshine: check if no special chars were used that will break the ruby command and thus the bic file
  // use the translate function to check
  string sRuby = fbEXPrepareStatement("Translator.create(:el).translate(? , 0, true)", sNewName);
  string sTestResult = fbEXRubyDirect(sRuby);
  WriteTimestampedLogEntry("NAME CHANGE CHECKER: Old name = " + GetName(oPC) + ", new name = " + sNewName + ", new name test = " + sTestResult);
  if (sTestResult != "") {

    SendMessageToPC(oPC, "<c þ >Renaming your character. You will be logged out and back in again, hold tight!");

    fbEXDoAndPortal(fbEXPrepareStatement("Bic.change_name(?, ?, ?)",GetPCPlayerName(oPC), GetName(oPC), sNewName), oPC);
    miDASetKeyedValue("gs_pc_data", gsPCGetPlayerID(oPC), "name", sNewName);

  } else {

    SendMessageToPC(oPC, "<c þ >Special characters encountered in the new name that are not allowed, try another name without special characters please.");

  }

}
//------------------------------------------------------------------------------
void fbEXFixMovement(object oPC)
{
  if (!GetIsPC(oPC) || GetIsDM(oPC))
  {
    return;
  }

  SendMessageToPC(oPC, "<c þ >Fixing your movement rate. You will be logged " +
    "out and back in again, hold tight!");

  fbEXDoAndPortal(fbEXPrepareStatement("Bic.fix_walk(?, ?)", GetPCPlayerName(oPC),
    GetName(oPC)), oPC);
}

