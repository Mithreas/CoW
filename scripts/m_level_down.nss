#include "inc_checker"
#include "inc_bonuses"
void main()
{
    VerifyQuickbarMetaMagic(OBJECT_SELF);
    ApplyCharacterBonuses(OBJECT_SELF, TRUE);
}