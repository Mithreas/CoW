#include "inc_totem"
void main()
{
   miTOGrantTotem(GetPCSpeaker(), MI_TO_PARROT);
   SendMessageToPC(GetPCSpeaker(),
     "You feel Parrot's spirit skin settle over you.  The experience is a shock, "
   + "but as the shock fades you can feel Parrot's natural radiance surround you.");
}
