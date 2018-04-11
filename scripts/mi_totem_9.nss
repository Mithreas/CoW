#include "inc_totem"
void main()
{
   miTOGrantTotem(GetPCSpeaker(), MI_TO_RAT);
   SendMessageToPC(GetPCSpeaker(),
     "You feel Rat's spirit skin settle over you.  The experience is a shock, "
   + "but as the shock fades you can feel Rat's cleverness augment your own.");
}
