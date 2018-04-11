#include "inc_citizen"

int StartingConditional()
{
    int iResult;

    // check if PC is a citizen of Andunor_The_Sharps or Andunor_Devils_District
    string sNation = GetLocalString(GetPCSpeaker(), VAR_NATION);
    if (GetStringUpperCase(GetStringLeft(sNation,7)) == "ANDUNOR") {
      iResult = 1;
    } else {
      iResult = 0;
    }
    return iResult;
}
