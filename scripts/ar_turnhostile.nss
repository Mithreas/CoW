//::  A simple script that makes the Owner of the Dialog attack the PC speaker and is turned hostile.

#include "NW_I0_GENERIC"

void main()
{
    //SetIsTemporaryEnemy(GetPCSpeaker(), OBJECT_SELF, TRUE);
    ChangeToStandardFaction(OBJECT_SELF, STANDARD_FACTION_HOSTILE);
    DetermineCombatRound();
}
