#include "inc_encounter"

void main()
{
    gsENSpawnAtLocation(54.0, GS_EN_LIMIT_SPAWN, GetLocalLocation(OBJECT_SELF, "GS_TARGET"));
}
