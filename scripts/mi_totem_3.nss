#include "mi_inc_totem"
void main()
{
   miTOGrantTotem(GetPCSpeaker(), MI_TO_SPIDER);
   SendMessageToPC(GetPCSpeaker(),
     "You feel Spider's spirit skin settle over you.  The experience is a shock, "
   + "but as the shock fades you can feel Spider's cunning and resistance settle into your soul.");
}
