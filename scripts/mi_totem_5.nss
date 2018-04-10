#include "mi_inc_totem"
void main()
{
   miTOGrantTotem(GetPCSpeaker(), MI_TO_EAGLE);
   SendMessageToPC(GetPCSpeaker(),
     "You feel Eagle's spirit skin settle over you.  The experience is a shock, "
   + "but as the shock fades you can feel Eagle's majesty and keen sight become a part of you.");
}
