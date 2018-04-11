// Player tool 2 = Assassination tool.
// Fairly straightforward - implement the assassinate ability against target.

#include "inc_assassin"

void main()
{
    object oTarget =    GetSpellTargetObject();
    object oPC =        OBJECT_SELF;

    if (!asCanAssassinate(oPC, oTarget))
        return;

    asApplyDamage(oPC, oTarget);
}
