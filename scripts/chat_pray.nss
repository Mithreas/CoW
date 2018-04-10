#include "gs_inc_worship"
#include "fb_inc_chatutils"
#include "fb_inc_zombie"
#include "inc_examine"

const string HELP = "Pray to whichever god you worship to receive all sorts of fancy aid!";

void main()
{
    if (chatGetParams(OBJECT_SELF) == "?")
    {
        DisplayTextInExamineWindow("-pray", HELP);
    }
    else
    {
        if (fbZGetIsZombie(OBJECT_SELF))
        {
            FloatingTextStringOnCreature("You pray to the gods for brains. But they don't deliver for some reason.", OBJECT_SELF, FALSE);
        }
        else
        {
            gsWOGrantFavor(OBJECT_SELF);
        }
    }

    chatVerifyCommand(OBJECT_SELF);
}
