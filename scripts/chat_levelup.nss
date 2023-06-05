#include "inc_chat"

void main()
{
	if (GetLocalInt(GetModule(), "MI_DEBUG") == 2)
	{
	  GiveXPToCreature(OBJECT_SELF, GetHitDice(OBJECT_SELF) * 1000);
	}
	
    chatVerifyCommand(OBJECT_SELF);
}