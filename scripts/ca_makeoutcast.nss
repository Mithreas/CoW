#include "inc_backgrounds"
#include "inc_citizen"
#include "inc_pc"
void main()
{
    object oSpeaker = GetPCSpeaker();
    TakeGoldFromCreature(100000, oSpeaker, TRUE);
    int nBackground = FALSE;

    SetSubRace(oSpeaker,
        GetSubRace(oSpeaker) + " (" + miBAGetBackgroundName(nBackground) + ")");
    miBAApplyBackground(oSpeaker, nBackground);

    // Revoke citizenship in any existing nations.
    SetLocalString(oSpeaker, VAR_NATION, "");
    SQLExecDirect("UPDATE gs_pc_data SET nation=NULL WHERE id=" + gsPCGetPlayerID(oSpeaker));
}
