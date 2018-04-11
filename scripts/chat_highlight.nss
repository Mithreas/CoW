#include "fb_inc_chatutils"
#include "inc_examine"
#include "fb_inc_names"

const string HELP = "DM Command: Highlight the player's text in the DM combat window by sending them -highlight as a Tell, or by entering their name (or part of it) after the command.";

void main ()
{
    object oSpeaker = OBJECT_SELF;
    string sDM = GetPCPlayerName(oSpeaker);
    object oTarget = chatGetTarget(oSpeaker);

    // Command not valid if not used by DM.
    if (!GetIsDM(oSpeaker)) return;

    string sParams = chatGetParams(oSpeaker);

    // Return help text with ? parameter.
    if (sParams == "?")
    {
        DisplayTextInExamineWindow("-highlight", HELP);
    }

    else
    {
        // Command passed without parameters.
        if (sParams == "")
        {
            // Is the target valid? If not, notify the user.
            if (!GetIsObjectValid(oTarget))
            {
              SendMessageToPC(oSpeaker, "Try typing a name after -highlight, or send it as a Tell. Use -highlight ? for help.");
            }

            // Don't be sneaky!
            else if (GetIsDM(oTarget)) SendMessageToPC(oSpeaker, "Don't be sneaky! They'll speak up if they need to.");

            // We found a valid target, let's (un)highlight them.
            else
            {
                SetLocalInt(oTarget, "MI_HIGHLIGHT_" + sDM, !GetLocalInt(oTarget, "MI_HIGHLIGHT_" + sDM));
                SendMessageToPC(oSpeaker, "Toggled chat highlighting for character: " + GetName(oTarget));
            }
        }

        // Command passed with a character name. Look for them on the server and (un)highlight them.
        else if (sParams != "")
        {
            string sName = sParams;
            int nLength = GetStringLength(sParams);
            object oPC = GetFirstPC();
            while (GetIsObjectValid(oPC))
            {
                // Search for real name and disguised name.
                if (GetStringLeft(GetName(oPC), nLength) == sParams || (!GetIsObjectValid(oTarget) && GetStringLeft(fbNAGetGlobalDynamicName(oPC), nLength) == sParams))
                {
                    oTarget = oPC;
                }
                oPC = GetNextPC();
            }

            if (!GetIsObjectValid(oTarget))
            {
                SendMessageToPC(oSpeaker, "Could not find character: " + sParams);
            }

            if (GetIsDM(oTarget))
            {
                SendMessageToPC(oSpeaker, "Don't be sneaky! They'll speak up if they need to.");
            }

            else
            {
                SetLocalInt(oTarget, "MI_HIGHLIGHT_" + sDM, !GetLocalInt(oTarget, "MI_HIGHLIGHT_" + sDM));
                SendMessageToPC(oSpeaker, "Toggled chat highlighting for character: " + GetName(oTarget));
            }
        }   
    }
    chatVerifyCommand(oSpeaker);
}