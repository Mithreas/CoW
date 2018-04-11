// Simple Console Command, shows color tags defined in zzdlg_color_inc

#include "fb_inc_chatutils"
#include "zzdlg_color_inc"
#include "fb_inc_chat"
#include "inc_examine"

void main()
{
    object oSpeaker = OBJECT_SELF;
    string sExamine;
    sExamine = "Red : " + txtRed + "TEXT text</c>\n";
    sExamine += "Lime : " + txtLime + "TEXT text</c>\n";
    sExamine += "Blue : " + txtBlue + "TEXT text</c>\n";
    sExamine += "Yellow : " + txtYellow + "TEXT text</c>\n";
    sExamine += "Aqua : " + txtAqua + "TEXT text</c>\n";
    sExamine += "Fuchsia : " + txtFuchsia + "TEXT text</c>\n";
    sExamine += "Maroon : " + txtMaroon + "TEXT text</c>\n";
    sExamine += "Green : " + txtGreen + "TEXT text</c>\n";
    sExamine += "Navy : " + txtNavy + "TEXT text</c>\n";
    sExamine += "Olive : " + txtOlive + "TEXT text</c>\n";
    sExamine += "Teal : " + txtTeal + "TEXT text</c>\n";
    sExamine += "Black : " + txtBlack + "TEXT text</c>\n";
    sExamine += "White : " + txtWhite + "TEXT text</c>\n";
    sExamine += "Grey : " + txtGrey + "TEXT text</c>\n";
    sExamine += "Silver : " + txtSilver + "TEXT text</c>\n";
    sExamine += "Orange : " + txtOrange + "TEXT text</c>\n";
    sExamine += "Brown : " + txtBrown + "TEXT text</c>\n";
    DisplayTextInExamineWindow("Color Test", sExamine);

    SendMessageToPC(oSpeaker, "Red : " + txtRed + "TEXT text</c>\n");
    SendMessageToPC(oSpeaker, "Lime : " + txtLime + "TEXT text</c>\n");
    SendMessageToPC(oSpeaker, "Blue : " + txtBlue + "TEXT text</c>\n");
    SendMessageToPC(oSpeaker, "Yellow : " + txtYellow + "TEXT text</c>\n");
    SendMessageToPC(oSpeaker,"Aqua : " + txtAqua + "TEXT text</c>\n");
    SendMessageToPC(oSpeaker, "Fuchsia : " + txtFuchsia + "TEXT text</c>\n");
    SendMessageToPC(oSpeaker, "Maroon : " + txtMaroon + "TEXT text</c>\n");
    SendMessageToPC(oSpeaker, "Green : " + txtGreen + "TEXT text</c>\n");
    SendMessageToPC(oSpeaker, "Navy : " + txtNavy + "TEXT text</c>\n");
    SendMessageToPC(oSpeaker, "Olive : " + txtOlive + "TEXT text</c>\n");
    SendMessageToPC(oSpeaker, "Teal : " + txtTeal + "TEXT text</c>\n");
    SendMessageToPC(oSpeaker, "Black : " + txtBlack + "TEXT text</c>\n");
    SendMessageToPC(oSpeaker, "White : " + txtWhite + "TEXT text</c>\n");
    SendMessageToPC(oSpeaker, "Grey : " + txtGrey + "TEXT text</c>\n");
    SendMessageToPC(oSpeaker, "Silver : " + txtSilver + "TEXT text</c>\n");
    SendMessageToPC(oSpeaker, "Orange : " + txtOrange + "TEXT text</c>\n");
    SendMessageToPC(oSpeaker, "Brown : " + txtBrown + "TEXT text</c>\n");

    chatVerifyCommand(oSpeaker);
}
