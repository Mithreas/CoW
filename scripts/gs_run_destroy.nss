#include "inc_common"

void main()
{
    object oObject = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);

    if (! GetIsObjectValid(oObject) ||
        GetDistanceToObject(oObject) >= 40.0)
    {
        gsCMDestroyObject();
        return;
    }

    DelayCommand(60.0, ExecuteScript("gs_run_destroy", OBJECT_SELF));
}
