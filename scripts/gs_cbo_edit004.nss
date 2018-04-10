#include "gs_inc_boss"

void main()
{
    gsBORemoveCreature(GetLocalInt(OBJECT_SELF, "GS_BO_SLOT"), GetArea(OBJECT_SELF));
}
