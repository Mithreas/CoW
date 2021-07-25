#include "inc_chatutils"
#include "inc_examine"

const string HELP = "-secondwind has been retired.  Please drag the feat from your character sheet to the quickbar and use that instead.";

void main()
{
  DisplayTextInExamineWindow("-secondwind", HELP);
  
  chatVerifyCommand(OBJECT_SELF);
}