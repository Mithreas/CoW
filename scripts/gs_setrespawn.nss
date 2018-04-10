#include "gs_inc_respawn"
void main()
{
  if (GetIsPC(GetEnteringObject())) gsRESetRespawnLocation(GetEnteringObject());
}
