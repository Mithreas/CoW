#include "inc_rename"
#include "inc_timelock"

void main()
{
    if (GetIsPC(OBJECT_SELF))
    {
        if (GetHasFeat(FEAT_HIDE_IN_PLAIN_SIGHT))
        {
            SetTimelock(OBJECT_SELF, 12, "Hide in Plain Sight", 0, 0);
        }

        SetLocalInt(OBJECT_SELF, "StealthTimer", -1);
        svSetAffix(OBJECT_SELF, STEALTH_PREFIX, FALSE);
    }
    else
        SetName(OBJECT_SELF, GetName(OBJECT_SELF, TRUE));

}