//::  A simple script that makes the Owner of the Dialog attack the PC speaker.
//::  Hostility is temporary and will last 180 seconds.

#include "NW_I0_GENERIC"

void main()
{
    SetIsTemporaryEnemy(GetPCSpeaker(), OBJECT_SELF, TRUE);
    DetermineCombatRound();
}
