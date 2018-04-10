#include "zzdlg_color_inc";

const int SCORE_501 = 501;

void main()
{
    object oPC = GetLastUsedBy();

    if ( !GetIsPC(oPC) && !GetIsDM(oPC) )   return;

    int nScore = GetLocalInt(oPC, "DART_SCORE");

    if (nScore != SCORE_501) {
        FloatingTextStringOnCreature(txtOrange + "Score Reset to " + IntToString(SCORE_501) + ".</c>", oPC, FALSE);
        SetLocalInt(oPC, "DART_SCORE", SCORE_501);
    }

}
