#include "inc_encounter"

void main()
{
    gsENSpawnAtLocation(14.0, GS_EN_LIMIT_SPAWN, GetLocalLocation(OBJECT_SELF, "GS_TARGET"));
}
