#include "inc_chatutils"
#include "gs_inc_common"
#include "inc_examine"

const string HELP  = "<cþôh>-description </c><cþ£ >[+] Text</c>\nChanges your description to <cþ£ >Text</c>. If the optional parameter <cþ£ >+</c> is given, then instead of changing your description this command will append <cþ£ >Text</c> to the end of your current description as a new paragraph.\nExample:\n<cþôh>-description The new description.\n-description + An extra paragraph.\n-description +np An extra paragraph.\n-description +nl An extra line.\n-description +ap Adds onto the current line.</c>";

void main()
{
  // Command not valid
  if (!ALLOW_CHANGE_DESCRIPTION) return;

  object oSpeaker = OBJECT_SELF;
  string sParams = chatGetParams(oSpeaker);
  string sPrefix=" ";
  int nFrom = 3;

  chatVerifyCommand(oSpeaker);

  if (sParams == "?" || sParams == "")
  {
    DisplayTextInExamineWindow("-description", HELP);
    return;
  }

  else
  {
    if (GetStringLeft(sParams, 3) == "+ap")
    {
      sPrefix = "";
    }

    else if (GetStringLeft(sParams, 3) == "+nl")
    {
      sPrefix = "\n";
    }

    else if (GetStringLeft(sParams, 3) == "+np" )
    {
      sPrefix = "\n\n";
    }
    else if (GetStringLeft(sParams, 1) == "+")
     {
      sPrefix = "\n\n";
      nFrom = 1;
    }
  }

 if (sPrefix != " ")
 {
    sParams = chatGetStringFrom(sParams, nFrom);
    sParams = gsCMTrimString(sParams, " ");

    if (sParams == "")
    {
      SendMessageToPC(oSpeaker, HELP);
    }
    else
    {
     SetDescription(oSpeaker, GetDescription(oSpeaker) + sPrefix + sParams);
     SendMessageToPC(oSpeaker, "You have appended '" + sParams + "' to your current description.");
    }
 }

 else
   {
    SetDescription(oSpeaker, sParams);
    SendMessageToPC(oSpeaker, "You have set your description to '" + sParams + "'.");
   }
}
