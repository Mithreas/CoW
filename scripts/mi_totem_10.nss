#include "inc_totem"
void main()
{
   miTOGrantTotem(GetPCSpeaker(), MI_TO_SNAKE);
   SendMessageToPC(GetPCSpeaker(),
     "You feel Snake's spirit skin settle over you.  The experience is a shock, "
   + "but as the shock fades you can feel Snake's grace and resistance to disease " +
   "and poison inure your soul.");
}
