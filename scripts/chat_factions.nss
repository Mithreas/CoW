#include "fb_inc_chatutils"
#include "zzdlg_tools_inc"
#include "inc_examine"

const string HELP = "Use the -factions command to bring up a dialog for managing your faction memberships. This feature was intended for use as an OOC message board for your faction. You can also create a faction here, and add people to a faction you have authority in.";

void main()
{
  object oSpeaker = OBJECT_SELF;
  if (chatGetParams(oSpeaker) == "?")
  {
    DisplayTextInExamineWindow("-factions", HELP);
  }
  else
  {
    _dlgStart(oSpeaker, oSpeaker, "zz_co_factions", TRUE, TRUE);
  }

  chatVerifyCommand(oSpeaker);
}
