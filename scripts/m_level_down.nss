#include "inc_checker"
#include "inc_bonuses"
void main()
{
    VerifyQuickbarMetaMagic(OBJECT_SELF);
    ApplyCharacterBonuses(OBJECT_SELF, TRUE);
	
	object oHide = gsPCGetCreatureHide();
	int nLevel = GetLocalInt(oHide, "FL_LEVEL");
	SetLocalInt(oHide, "FL_LEVEL", nLevel -1);
}