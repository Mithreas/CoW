#include "fb_inc_chatutils"
#include "fb_inc_zombie"
#include "inc_examine"

const string HELP = "Cleans up a nearby pool of blood.";

void main()
{
    if (chatGetParams(OBJECT_SELF) == "?")
    {
        DisplayTextInExamineWindow("-cleanup", HELP);
    }
    else
    {
        ExecuteScript("bm_blood", OBJECT_SELF);
    }

    chatVerifyCommand(OBJECT_SELF);
}