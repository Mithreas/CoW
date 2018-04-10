#include "mi_inc_totem"
void main()
{
   miTOGrantTotem(GetPCSpeaker(), MI_TO_BEAR);
   SendMessageToPC(GetPCSpeaker(),
     "You feel Bear's spirit skin settle over you.  The experience is a shock, "
   + "but as the shock fades you can feel Bear's strength and endurance become a part of you.");
}
