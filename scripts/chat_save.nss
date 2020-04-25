#include "inc_chatutils"
#include "inc_combat2"
#include "inc_common"
#include "inc_pc"
#include "inc_time"
#include "inc_examine"

const string HELP = "The -save command allows you to save your character at any time. This is done automatically periodically, but you may sometimes want to save manually as a safeguard against server crashes. You can only save once per minute.";

void main()
{
    object oSpeaker = OBJECT_SELF;

    // Exploit safeguard.
    if (GetHasEffect(EFFECT_TYPE_POLYMORPH, oSpeaker))
    {
        SendMessageToPC(oSpeaker, "You cannot use the -save command while polymorphed.");
        chatVerifyCommand(oSpeaker);
        return;
    }

    if (chatGetParams(oSpeaker) == "?")
    {
        DisplayTextInExamineWindow("-save", HELP);
    }
    else
    {
        // Save once per minute. As there's an exploit/biobug where druids
        // regain temporary HP when shifted.
        int nTimestamp = gsTIGetActualTimestamp();
        int nTimeout   = GetLocalInt(oSpeaker, "MI_SAVE_TIMEOUT");

        if (nTimeout < nTimestamp)
        {
            nTimeout = nTimestamp + FloatToInt(TurnsToSeconds(1)); //1 minute

            SetLocalInt(oSpeaker, "MI_SAVE_TIMEOUT", nTimeout);

            ExportSingleCharacter(oSpeaker);

            gsPCSavePCLocation(oSpeaker, GetLocation(oSpeaker));
            SendMessageToPC(oSpeaker, "Your character has been saved.");
        }
        else
        {
            SendMessageToPC(oSpeaker, "You may only save your character once per minute.");
        }
    }

    chatVerifyCommand(oSpeaker);
}
