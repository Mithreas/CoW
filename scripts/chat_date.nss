#include "fb_inc_chatutils"
#include "inc_examine"
#include "gs_inc_craft"
#include "zzdlg_color_inc"


const string HELP = "This command shows the current date, including the Faerunian month and year.  It also shows the approximate time in which crafting points will reset and important meter states.  Using this command with the -s parameter will display the information in a shortened format.";

string PresentableCooldown(int nSeconds)
{
    int nMinutes;
    int nHours;
    string sPresentableTime = "";

    nHours = (nSeconds / 3600);
    nSeconds = nSeconds % 3600;
    nMinutes = (nSeconds / 60);
    nSeconds = nSeconds % 60;

    if(nHours)
    {
       sPresentableTime += IntToString(nHours) + " hour(s)";
    }
    if(nMinutes)
    {
        if(nHours)
        {
           if(!nMinutes)
           {
               sPresentableTime += " and ";
           }
           else
           {
               sPresentableTime += ", ";
           }
        }
        sPresentableTime += IntToString(nMinutes) + " minute(s)";
    }
    if(nSeconds || (!nHours && !nMinutes))
    {
        if(nHours || nMinutes)
        {
            sPresentableTime += " and ";
        }
        sPresentableTime += IntToString(nSeconds) + " second(s)";
    }

    return sPresentableTime;
}

void main()
{
    object oSpeaker = OBJECT_SELF;
    object oHide = gsPCGetCreatureHide(oSpeaker);
    int nTimeout, nTimestamp;
    string sCooldown, sLine;

    if (chatGetParams(oSpeaker) == "?") {
        DisplayTextInExamineWindow("-date", HELP);
    } else if (chatGetParams(oSpeaker) == "-s") {
        // Short version of this command.  We'll try to compress info.
        SendMessageToPC(oSpeaker, gsTIGetPresentableTime());
        sLine = "CP: " + txtLime + IntToString(gsCRGetCraftPoints(oSpeaker)) + "</c>";

        nTimestamp = gsTIGetActualTimestamp();
        nTimeout   = gsCRGetCraftTimeout(oSpeaker);
        if (nTimeout > nTimestamp) {
            sCooldown = PresentableCooldown((nTimeout - nTimestamp) / 10);
            sLine += ", Refresh: " + sCooldown;
    }
        SendMessageToPC(oSpeaker, sLine);

        // Let's show adventuring expees
        int nXP = GetLocalInt(oHide, "GVD_XP_POOL");
        SendMessageToPC(oSpeaker, "ADV XP: " + txtLime + IntToString(nXP) + "</c>");

        // Show states
        sLine = "";
        if (!fbZGetIsZombie(oSpeaker) && gsSUGetIsMortal(gsSUGetSubRaceByName(GetSubRace(oSpeaker)))) {
            // Food
            sLine += "F:" + txtLime + FloatToString(GetLocalFloat(oHide, "GS_ST_FOOD"), 0, 1) + "</c>";
            // Water
            sLine += " / W:" + txtLime + FloatToString(GetLocalFloat(oHide, "GS_ST_WATER"), 0, 1) + "</c>";
        }
        // Rest
            sLine += " / R:" + txtLime + FloatToString(GetLocalFloat(oHide, "GS_ST_REST"), 0, 1) + "</c>";
        // Piety
            sLine += " / P:" + txtLime + FloatToString(GetLocalFloat(oHide, "GS_ST_PIETY"), 0, 1) + "</c>";

        // Sobriety, if state is appropriate
        if (GetLocalFloat(oHide, "GS_ST_SOBRIETY") < 99.0)
            sLine += " / S:" + txtLime + FloatToString(GetLocalFloat(oHide, "GS_ST_SOBRIETY"), 0, 1) + "</c>";

        if (VampireIsVamp(oSpeaker)) {
            // Blood
            sLine += " / B:" + txtLime + FloatToString(GetLocalFloat(oHide, "GS_ST_BLOOD"), 0, 1) + "</c>";
        }
        SendMessageToPC(oSpeaker, sLine);

    } else {
        SendMessageToPC(oSpeaker, gsTIGetPresentableTime());

        // Let's get our crafting point info.
        SendMessageToPC(oSpeaker, "Available Crafting Points: " + txtTeal + IntToString(gsCRGetCraftPoints(oSpeaker)) + "</c>");
        nTimestamp = gsTIGetActualTimestamp();
        nTimeout   = gsCRGetCraftTimeout(oSpeaker);
        if (nTimeout > nTimestamp) {
            sCooldown = PresentableCooldown((nTimeout - nTimestamp) / 10);
            sCooldown = "Crafting points refresh in " + sCooldown + ".";
            SendMessageToPC(oSpeaker, sCooldown);
        }

        // Let's show adventuring expees
        int nXP = GetLocalInt(oHide, "GVD_XP_POOL");
        SendMessageToPC(oSpeaker, "Stored Adventuring XP: " + txtTeal + IntToString(nXP) + "</c>");

        // Show states
        if (!fbZGetIsZombie(oSpeaker) && gsSUGetIsMortal(gsSUGetSubRaceByName(GetSubRace(oSpeaker)))) {
            // Food
            SendMessageToPC(oSpeaker, GS_T_16777299 + ": " + txtLime + FloatToString(GetLocalFloat(oHide, "GS_ST_FOOD"), 0, 1) + "%</c>");
            // Water
            SendMessageToPC(oSpeaker, GS_T_16777300 + ": " + txtLime + FloatToString(GetLocalFloat(oHide, "GS_ST_WATER"), 0, 1) + "%</c>");
        }
        // Rest
        SendMessageToPC(oSpeaker, GS_T_16777301 + ": " + txtLime + FloatToString(GetLocalFloat(oHide, "GS_ST_REST"), 0, 1) + "%</c>");
        // Piety
        SendMessageToPC(oSpeaker, GS_T_16777592 + ": " + txtLime + FloatToString(GetLocalFloat(oHide, "GS_ST_PIETY"), 0, 1) + "%</c>");

        // Sobriety, if state is appropriate
        if (GetLocalFloat(oHide, "GS_ST_SOBRIETY") < 99.0)
            SendMessageToPC(oSpeaker, GS_T_16777302 + ": " + txtLime + FloatToString(GetLocalFloat(oHide, "GS_ST_SOBRIETY"), 0, 1) + "%</c>");

        if (VampireIsVamp(oSpeaker)) {
            // Blood
            SendMessageToPC(oSpeaker, "Blood: " + txtLime + FloatToString(GetLocalFloat(oHide, "GS_ST_BLOOD"), 0, 1) + "%</c>");
        }
    }

    chatVerifyCommand(oSpeaker);
}


