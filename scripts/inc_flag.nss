/* FLAG Library by Gigaschatten

Area functions improved a bit by Fireboar. Note that nValid != FALSE tends to be
used so that nValid can take any non-zero value and still work.
*/

#include "inc_time"

//void main() {}

const int GS_FL_DISABLE_AI     = 1;
const int GS_FL_DISABLE_CALL   = 2;
const int GS_FL_DISABLE_COMBAT = 3;
const int GS_FL_DISABLE_LOOT   = 4;
const int GS_FL_MORTAL         = 5;
const int GS_FL_ENCOUNTER      = 6;
const int GS_FL_BOSS           = 7;

//enable/disable nFlag for oObject
void gsFLSetFlag(int nFlag, object oObject = OBJECT_SELF, int nValid = TRUE);
//return TRUE if nFlag is enabled for oObject
int gsFLGetFlag(int nFlag, object oObject = OBJECT_SELF);
//enable/disable sFlag for area of oObject
void gsFLSetAreaFlag(string sFlag, object oObject = OBJECT_SELF, int nValid = TRUE, int nPermanent = TRUE);
//return TRUE if sFlag is enabled for area of oObject
int gsFLGetAreaFlag(string sFlag, object oObject = OBJECT_SELF);
// Set sFlag for area of oObject to nValid for nDuration seconds. If sFeedback
// is given, it will be used in a message sent to each PC in the area. Finally,
// bInvertFeedback is required for those OVERRIDE flags, because they need the
// messages generated the other way around.
void gsFLTemporarilySetAreaFlag(string sFlag, int nDuration, object oObject = OBJECT_SELF, int nValid = TRUE, string sFeedback = "", int bInvertFeedback = FALSE);

void gsFLSetFlag(int nFlag, object oObject = OBJECT_SELF, int nValid = TRUE)
{
    int nNth        = nFlag / 32;
    string sString  = "GS_FL_" + IntToString(nNth);
    int nMatrix     = GetLocalInt(oObject, sString);
    nFlag           = 1 << nFlag % 32;

    if (nValid) nMatrix |= nFlag;
    else        nMatrix &= ~nFlag;

    SetLocalInt(oObject, sString, nMatrix);
}
//----------------------------------------------------------------
int gsFLGetFlag(int nFlag, object oObject = OBJECT_SELF)
{
    int nNth       = nFlag / 32;
    string sString = "GS_FL_" + IntToString(nNth);
    int nMatrix    = GetLocalInt(oObject, sString);
    nFlag          = 1 << nFlag % 32;

    return GetLocalInt(oObject, sString) & nFlag;
}
//----------------------------------------------------------------
void gsFLSetAreaFlag(string sFlag, object oObject = OBJECT_SELF, int nValid = TRUE, int nPermanent = TRUE)
{
    object oArea = GetArea(oObject);
    int bNew     = nValid != FALSE;

    SetLocalInt(oArea, "GS_FL_" + sFlag, bNew);

    if (nPermanent)
    {
      SetLocalInt(oArea, "GS_FL__ORIG_" + sFlag, bNew + 1);
    }
}
//----------------------------------------------------------------
int gsFLGetAreaFlag(string sFlag, object oObject = OBJECT_SELF)
{
    object oArea = GetArea(oObject);

    return GetLocalInt(oArea, "GS_FL_" + sFlag);
}
//----------------------------------------------------------------
void _gsFLTemporarilySetAreaFlag(string sFlag, object oArea, string sFeedback, int bInvertFeedback)
{
  // Still waiting?
  int nTimeout = GetLocalInt(oArea, "GS_FL__TIMEOUT");
  int nNow     = gsTIGetActualTimestamp() + 1; // Little bit of leeway
  if (!nTimeout)
  {
    return;
  }

  if (nTimeout > nNow)
  {
    DelayCommand(IntToFloat(nTimeout - nNow), _gsFLTemporarilySetAreaFlag(sFlag, oArea, sFeedback, bInvertFeedback));
    return;
  }

  DeleteLocalInt(oArea, "GS_FL__TIMEOUT");

  int bNew      = GetLocalInt(oArea, "GS_FL__ORIG_" + sFlag);
  bNew --; // It's stored with a +1. Putting -1 on the previous line crashes the compiler.  IKR...
  int bCurrent  = GetLocalInt(oArea, "GS_FL_" + sFlag);

  if (bNew != bCurrent)
  {
    SetLocalInt(oArea, "GS_FL_" + sFlag, bNew);

    if (sFeedback != "")
    {
      // Does a tree fall if there's nobody to hear it? Not in this case it doesn't.
      object oObject = GetFirstObjectInArea(oArea);
      if (GetIsObjectValid(oObject))
      {
        if (bInvertFeedback)
        {
          bNew = !bNew;
        }

        int nNth   = 1;
        object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oObject, nNth);
        while (GetIsObjectValid(oPC))
        {
          SendMessageToPC(oPC, sFeedback + " is now " + ((bNew) ? "Enabled" : "Disabled"));
          oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oObject, ++nNth);
        }

        if (GetIsPC(oObject))
        {
          SendMessageToPC(oObject, sFeedback + " is now " + ((bNew) ? "Enabled" : "Disabled"));
        }
      }
    }
  }
}
//----------------------------------------------------------------
void gsFLTemporarilySetAreaFlag(string sFlag, int nDuration, object oObject = OBJECT_SELF, int nValid = TRUE, string sFeedback = "", int bInvertFeedback = FALSE)
{
  object oArea  = GetArea(oObject);

  // The timeout ensures we don't try to restore the old flag state more than
  // once.
  int nTimeout = GetLocalInt(oArea, "GS_FL__TIMEOUT");
  int nNow     = gsTIGetActualTimestamp();
  if (nTimeout > nNow + nDuration)
  {
    return;
  }
  else
  {
    SetLocalInt(oArea, "GS_FL__TIMEOUT", nNow + nDuration);
  }

  // Preserve the real flag.
  int bOriginal = GetLocalInt(oArea, "GS_FL__ORIG_" + sFlag) - 1;
  int bCurrent  = GetLocalInt(oArea, "GS_FL_" + sFlag);
  int bNew      = nValid != FALSE;
  if (bOriginal == -1)
  {
    bOriginal = bCurrent;
    SetLocalInt(oArea, "GS_FL__ORIG_" + sFlag, bOriginal + 1);
  }

  // End here if we're not actually changing anything.
  if (bCurrent == bNew)
  {
    return;
  }

  SetLocalInt(oArea, "GS_FL_" + sFlag, bNew);

  if (sFeedback != "")
  {
    if (bInvertFeedback)
    {
      bNew = !bNew;
    }

    int nNth   = 1;
    object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oObject, nNth);
    while (GetIsObjectValid(oPC))
    {
      SendMessageToPC(oPC, sFeedback + " is now " + ((bNew) ? "Enabled" : "Disabled"));
      oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oObject, ++nNth);
    }

    if (GetIsPC(oObject))
    {
      SendMessageToPC(oObject, sFeedback + " is now " + ((bNew) ? "Enabled" : "Disabled"));
    }
  }

  // Only do this if we haven't got another one on the go
  if (!nTimeout)
  {
    AssignCommand(oArea, DelayCommand(IntToFloat(nDuration), _gsFLTemporarilySetAreaFlag(sFlag, oArea, sFeedback, bInvertFeedback)));
  }
}

