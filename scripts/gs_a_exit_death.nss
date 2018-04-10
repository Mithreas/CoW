#include "gs_inc_effect"

void main()
{
    object oExiting = GetExitingObject();

    gsFXRemoveEffect(oExiting, OBJECT_SELF);
}
