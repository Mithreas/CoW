#include "mi_inc_totem"
void main()
{
   miTOGrantTotem(GetPCSpeaker(), MI_TO_BAT);
   SendMessageToPC(GetPCSpeaker(),
     "You feel Bat's spirit skin settle over you.  The experience is a shock, "
   + "but as the shock fades you can feel Bat's preternatural awareness of " +
     "the world around you.");
}
