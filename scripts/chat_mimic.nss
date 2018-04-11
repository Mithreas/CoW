// chat_mimic
// This command permits a player to use Bluff / Perform
// to purposefully mimic or modify their statistics
// displayed during right-click examine.


#include "fb_inc_chatutils"
#include "gs_inc_common"
#include "inc_examine"

const string HELP  = "<cþôh>-mimic </c><cþ£ >[Attribute] [Hi / Lo / Av / St]</c>\nWith the help of Bluff or Perform ranks, you may change how your physical stats are displayed to others via right-click examine.  The first parameter of <cþ£ >[Attribute]</c> may be <cþ£ >STR</c>, <cþ£ >DEX</c>, <cþ£ >CON</c>, or <cþ£ >CHA</c>.";
const string HELP2 = "  The second parameter of may be <cþ£ >Hi</c> (High), <cþ£ >Lo</c> (Low), <cþ£ >Av</c> (Average), or <cþ£ >St</c> (Stop).'St' will have you Stop mimicking a certain value for that attribute, and will revert the displayed attribute to what is normally shown.";


// Param conversion
string mimicStatToWord(string sStat)
{
    if (sStat == "DEX")
        return "dexterity";
    if (sStat == "STR")
        return "strength";
    if (sStat == "CON")
        return "constitution";
    if (sStat == "CHA")
        return "charisma";

    return "attribute";
}

// Param conversion
string mimicValueToWord(string sVal)
{
    if (sVal == "HI")
        return "High";
    if (sVal == "LO")
        return "Low";
    if (sVal == "AV")
        return "Average";

    return "Unknown";
}



void main()
{
    // Set parameters
    object oSpeaker = OBJECT_SELF;
    object oHide = gsPCGetCreatureHide(oSpeaker);
    string sParams = chatGetParams(oSpeaker);

    // Register command as processed
    chatVerifyCommand(OBJECT_SELF);

    // Count up current mimicked traits.
    SendMessageToPC(oSpeaker, "You are currently mimicking the following physical traits:");
    int nMimicked = 0;
    if (GetLocalString(oHide, "MIMIC_STR") != "") {
        SendMessageToPC(oSpeaker, "Strength: " + mimicValueToWord(GetLocalString(oHide, "MIMIC_STR")));
        nMimicked++;
    }
    if (GetLocalString(oHide, "MIMIC_DEX") != "") {
        SendMessageToPC(oSpeaker, "Dexterity: " + mimicValueToWord(GetLocalString(oHide, "MIMIC_DEX")));
        nMimicked++;
    }
    if (GetLocalString(oHide, "MIMIC_CON") != "") {
        SendMessageToPC(oSpeaker, "Constitution: " + mimicValueToWord(GetLocalString(oHide, "MIMIC_CON")));
        nMimicked++;
    }
    if (GetLocalString(oHide, "MIMIC_CHA") != "") {
        SendMessageToPC(oSpeaker, "Charisma: " + mimicValueToWord(GetLocalString(oHide, "MIMIC_CHA")));
        nMimicked++;
    }
    if (!nMimicked)
        SendMessageToPC(oSpeaker, "None.");

    // Show help
    if (sParams == "?" || sParams == "")
    {
        DisplayTextInExamineWindow("-mimic", HELP + HELP2);
        return;
    }

    string sStat = GetStringUpperCase(GetStringLeft(sParams, 3));
    string sVal = GetStringUpperCase(GetStringRight(sParams, 2));

    // Check params, show help if improper
    if (sStat != "DEX" && sStat != "STR" && sStat != "CON" && sStat != "CHA")
    {
        DisplayTextInExamineWindow("-mimic", HELP + HELP2);
        return;
    }

    if (sVal != "HI" && sVal != "LO" && sVal != "AV" && sVal != "ST")
    {
        DisplayTextInExamineWindow("-mimic", HELP + HELP2);
        return;
    }

    // All right, now that we're confident we have the right params...
    sStat = GetStringUpperCase(sStat);

    // Stop mimicking
    if (sVal == "ST") {
        DeleteLocalString(oHide, "MIMIC_" + sStat);
        SendMessageToPC(oSpeaker, "You are no longer pretending to have particular degree of " + mimicStatToWord(sStat) + ".");
        return;
    }

    // Check skills
    int nSkill = GetSkillRank(SKILL_BLUFF, oSpeaker, TRUE) + GetSkillRank(SKILL_PERFORM, oSpeaker, TRUE);
    nSkill = nSkill / 7;

    if (!nSkill) {
        SendMessageToPC(oSpeaker, "You are not skilled enough in Bluff or Perform to pull this off.");
        return;
    }

    if (nSkill <= nMimicked && nSkill < 4) {
        SendMessageToPC(oSpeaker, "You may mimic a maximum of " + IntToString(nSkill) + " physical attributes at your current skill level.");
        return;
    }

    // We're still here so set the value.
    SetLocalString(oHide, "MIMIC_" + sStat, sVal);
    SendMessageToPC(oSpeaker, "You are now pretending to have a(n) " + mimicValueToWord(sVal) + " amount of " + mimicStatToWord(sStat) + ".");

}
