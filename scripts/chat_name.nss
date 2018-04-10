// chat_name
#include "fb_inc_chatutils"
#include "fb_inc_external"
#include "inc_examine"

const string HELP  = "<cþôh>-name</c><cþ£ > Text</c>\nChanges your name to <cþ£ >Text</c>. Once you are done, you will appear to do an area transition - this is necessary to apply the new name and only takes a few seconds.";

void main()
{
  object oSpeaker = OBJECT_SELF;
  if (!GetLocalInt(GetArea(oSpeaker), "MI_RENAME") || GetIsDM(oSpeaker)) return;

  string sParams = chatGetParams(oSpeaker);

  if (sParams == "?" || sParams == "")
  {
    DisplayTextInExamineWindow("-name", HELP);
  }
  else if (GetStringLength(sParams) > 64)
  {
    SendMessageToPC(oSpeaker, "Name is too long. Please choose a shorter name.");
  }
  else
  {
    // this is done in function below as well: miDASetKeyedValue("gs_pc_data", gsPCGetPlayerID(oSpeaker), "name", sParams);
    fbEXChangeName(oSpeaker, sParams);
  }

  chatVerifyCommand(oSpeaker);
}
