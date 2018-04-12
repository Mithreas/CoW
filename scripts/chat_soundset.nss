// chat_soundset
#include "inc_chatutils"
#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"
#include "inc_examine"

const string HELP  = "<cþôh>-name</c><cþ£ > Number</c>\nChanges your soundset to <cþ£ >Number</c> - an index of soundset.2da.";

void main()
{
  object oSpeaker = OBJECT_SELF;
  if (!GetLocalInt(GetArea(oSpeaker), "MI_RENAME") || GetIsDM(oSpeaker)) return;

  string sParams = chatGetParams(oSpeaker);
  int nSoundset = StringToInt(sParams);

  if (sParams == "?" || sParams == "")
  {
    DisplayTextInExamineWindow("-soundset", HELP);
  }
  else if (nSoundset > 453)
  {
    SendMessageToPC(oSpeaker, "Please enter a number from 1 to 453.  See soundset.2da for values.");
  }
  else
  {
    NWNX_Creature_SetSoundset(oSpeaker, nSoundset);
  }

  chatVerifyCommand(oSpeaker);
}
