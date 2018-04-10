#include "inc_lgen"

void main()
{
    LGEN_SetMinPropertyCount(4);
    LGEN_SetMaxPropertyCount(GetBaseItemType(OBJECT_SELF) == BASE_ITEM_RING ? 5 : 6);
}
