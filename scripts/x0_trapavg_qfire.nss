
//::///////////////////////////////////////////////////
//:: X0_TRAPAVG_QFIRE
//:: OnTriggered script for a projectile trap
//:: Spell fired: SPELL_QUILLFIRE
//:: Spell caster level: 5
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/17/2002
//::///////////////////////////////////////////////////

#include "x0_i0_projtrap"

void main()
{
    TriggerProjectileTrap(SPELL_QUILLFIRE, GetEnteringObject(), 5);
}

