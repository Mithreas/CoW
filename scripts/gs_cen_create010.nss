#include "inc_encounter"

void main()
{
    gsENSpawnAtLocation(30.0, GS_EN_LIMIT_SPAWN, GetLocalLocation(OBJECT_SELF, "GS_TARGET"));
}
