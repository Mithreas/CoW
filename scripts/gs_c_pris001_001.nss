#include "gs_inc_combat"

void main()
{
    object oSpeaker = GetPCSpeaker();

    //AdjustAlignment(oSpeaker, ALIGNMENT_EVIL, 10);
    gsCBDetermineCombatRound(oSpeaker);
}
