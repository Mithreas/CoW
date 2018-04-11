#include "inc_totem"
void main()
{
   miTOGrantTotem(GetPCSpeaker(), MI_TO_WOLF);
   SendMessageToPC(GetPCSpeaker(),
     "You feel Wolf's spirit skin settle over you.  The experience is a shock, "
   + "but as the shock fades you can feel Wolf's predator abilities sink into your soul.");
}
