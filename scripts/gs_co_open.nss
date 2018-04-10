#include "gs_inc_container"

void main()
{
    SendMessageToPC(GetLastOpenedBy(), "<c þ >Remember, you can only steal one item from " +
    "each person in any 24 hour (RL) period.  And we have detailed logs to check...");
    if (! GetLocalInt(OBJECT_SELF, "GS_ENABLED"))
    {
        int nLimit = GetLocalInt(OBJECT_SELF, "GS_LIMIT");

        if (! nLimit) nLimit = GS_LIMIT_DEFAULT;
        gsCOLoad(GetTag(OBJECT_SELF), OBJECT_SELF, nLimit);
        SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);
    }
}
