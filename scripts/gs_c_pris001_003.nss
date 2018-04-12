#include "inc_common"

void main()
{
    object oSpeaker = GetPCSpeaker();

    gsCMCreateGold(Random(10) + 1, oSpeaker);
    gsCMTransferInventory(OBJECT_SELF, oSpeaker);

    SetLocalInt(OBJECT_SELF, "GS_PRISONER_ENABLED", TRUE);
}
