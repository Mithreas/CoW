// chat_portrait
#include "inc_chatutils"
#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"
#include "inc_examine"
#include "inc_pc"
#include "inc_disguise"

const string HELP  = "<cþôh>-name</c><cþ£ > Text</c>\nChanges your portrait to <cþ£ >Text</c>. You must know the name of the portrait file you wish to use.";

void main()
{
  object oSpeaker = OBJECT_SELF;
  if (!GetLocalInt(GetArea(oSpeaker), "MI_RENAME") || GetIsDM(oSpeaker)) return;

  string sParams = chatGetParams(oSpeaker);

  if (sParams == "?" || sParams == "")
  {
    DisplayTextInExamineWindow("-portrait", HELP);
  }
  else if (GetStringLength(sParams) > 15)
  {
    SendMessageToPC(oSpeaker, "Name is too long. Portrait names can be up to 15 characters.");
  }
  else
  {
    SetPortraitResRef(oSpeaker, sParams);
    SetLocalString(gsPCGetCreatureHide(oSpeaker), "PORTRAIT", sParams);
    UpdatePortraitInDB(oSpeaker, sParams);
  }

  chatVerifyCommand(oSpeaker);
}
