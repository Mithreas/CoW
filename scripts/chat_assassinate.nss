#include "inc_chatutils"
#include "inc_examine"

const string HELP = "-assassinate has been retired.  Please drag the Assassinate feat from your character sheet to your quickbar and use that.";

void main()
{
    string params = chatGetParams(OBJECT_SELF);

    DisplayTextInExamineWindow("-assassinate", HELP);
    chatVerifyCommand(OBJECT_SELF);
    return;
}
