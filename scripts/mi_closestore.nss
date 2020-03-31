// The OpenStore code adds this script to the Close Store event handler.
// It ensures that whenever a store is closed it is cleaned of anything sold to it.
// This is for performance reasons - large shop inventories cause lag even if
// nobody is using the store.  
void main()
{
    object oStore = OBJECT_SELF;
  
	object oItem = GetFirstItemInInventory(oStore);

	//clean store
	if (GetLocalInt(oStore, "GS_ENABLED"))
	{
		while (GetIsObjectValid(oItem))
		{
			if (! GetLocalInt(oItem, "GS_STORE"))
			{
				DestroyObject(oItem);
			}

			oItem = GetNextItemInInventory(oStore);
		}
	}
}