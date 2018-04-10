#include "mi_inc_totem"
void main()
{
   miTOGrantTotem(GetPCSpeaker(), MI_TO_RAVEN);
   SendMessageToPC(GetPCSpeaker(),
     "You feel Raven's spirit skin settle over you.  The experience is a shock, "
   + "but as the shock fades you can feel Raven's wisdom and knowledge in your soul.");
}
