#include "inc_chatutils"
#include "inc_examine"
#include "zzdlg_main_inc"

const string HELP = "Calls up the modify gear menu where you can edit, load and save outfits.";

void main()
{
  object oSpeaker = OBJECT_SELF;
  string sParam = chatGetParams(oSpeaker);
  
  if (sParam == "?")
  {
    DisplayTextInExamineWindow("-loadoutfit", HELP);
  }
  else 
  {
    _dlgStart(oSpeaker, oSpeaker, "zz_co_form", 1, 1);
  }

  chatVerifyCommand(oSpeaker);
}
