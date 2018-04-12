#include "inc_chatutils"
#include "inc_pc"
#include "nwnx_alts"
#include "inc_examine"

const string HELP = "-revealparty\nToggles yourself revealed to your party if you are stealthed. Persists through resets.";

void main()
{
    string charName = chatGetParams(OBJECT_SELF);

    if (charName == "?")
    {
        DisplayTextInExamineWindow("-revealparty", HELP);
    }
    else
    {
        object hide = gsPCGetCreatureHide(OBJECT_SELF);

        if (GetLocalInt(hide, "REVEALED_TO_PARTY"))
        {
            DeleteLocalInt(hide, "REVEALED_TO_PARTY");
            SetStealthPartyRevealed(FALSE);
            SendMessageToPC(OBJECT_SELF, "You are no longer revealed to your party.");
        }
        else
        {
            SetLocalInt(hide, "REVEALED_TO_PARTY", 1);
            SetStealthPartyRevealed(TRUE);
            SendMessageToPC(OBJECT_SELF, "You are now revealed to your party.");
        }
    }

    chatVerifyCommand(OBJECT_SELF);
}
