#include "mi_inc_totem"
int StartingConditional()
{
  return (miTOGetTotemAnimalAppearance(GetPCSpeaker()) > 0);
}
