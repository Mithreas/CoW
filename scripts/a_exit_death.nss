#include "inc_effect"

void main()
{
    object oExiting = GetExitingObject();

    gsFXRemoveEffect(oExiting, OBJECT_SELF);
}
