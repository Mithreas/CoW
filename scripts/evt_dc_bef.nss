#include "inc_bonuses.nss"
#include "inc_spells"
#include "inc_summons"

const int FIRST_ACTION_MODE = ACTION_MODE_PARRY;
const int LAST_ACTION_MODE = ACTION_MODE_DIRTY_FIGHTING;

void main()
{
    // Clear all action modes ... we do this to prevent any issue, as modes aren't preserved between logins.
    int i = FIRST_ACTION_MODE;
    while (i <= LAST_ACTION_MODE)
    {
        if (GetActionMode(OBJECT_SELF, i))
        {
            SetActionMode(OBJECT_SELF, i, FALSE);
        }
        ++i;
    }
    ActivateAssociateCooldowns(OBJECT_SELF);
}
