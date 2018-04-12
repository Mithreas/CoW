#include "inc_respawn"
void main()
{
  if (GetIsPC(GetEnteringObject())) gsRESetRespawnLocation(GetEnteringObject());
}
