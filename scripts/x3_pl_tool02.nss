// Player tool 2 = Assassination tool.
// Fairly straightforward - implement the assassinate ability against target.

#include "inc_assassinate"

void main()
{
    object oTarget =    GetSpellTargetObject();
    object oPC =        OBJECT_SELF;

    if (!asCanAssassinate(oPC, oTarget))
        return;

    asApplyDamage(oPC, oTarget);
}
