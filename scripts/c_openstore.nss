/*
 * Dialog script to open the nearest store.
 * 
 */
#include "inc_shop"
#include "inc_divination"
void main()
{
    miDVGivePoints(GetPCSpeaker(), ELEMENT_WATER, 8.0);

    object oStore = GetNearestObject(OBJECT_TYPE_STORE);
    if (GetIsObjectValid(oStore)) gsSHOpenStore(oStore, OBJECT_SELF, GetPCSpeaker());
}
