#include "inc_totem"
void main()
{
   miTOGrantTotem(GetPCSpeaker(), MI_TO_PANTHER);
   SendMessageToPC(GetPCSpeaker(),
     "You feel Panther's spirit skin settle over you.  The experience is a shock, "
   + "but as the shock fades you can feel Panther's grace and stealth become a part of you.");
}
