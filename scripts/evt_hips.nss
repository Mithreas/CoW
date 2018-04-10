#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"
#include "inc_item"
#include "inc_timelock"
#include "nwnx_alts"

int GetHasRangerHiPS();

void main()
{
    SetStealthSkipHIPS(GetIsTimelocked(OBJECT_SELF, "Hide in Plain Sight") || (GetHasRangerHiPS() && !GetIsAreaNatural(GetArea(OBJECT_SELF))));
}

int GetHasRangerHiPS()
{
    return (GetLevelByClass(CLASS_TYPE_RANGER) >= 21 && !GetLevelByClass(CLASS_TYPE_SHADOWDANCER) >= 5 && !GetHasFeatOnItem(OBJECT_SELF, IP_CONST_FEAT_HIDE_IN_PLAIN_SIGHT));
}
