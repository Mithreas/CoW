/*
  Name: mi_makequestitem
  Author: Mithreas
  Date: 27 Dec 05
  Version: 1.1
  Description: Put in the OnOpen slot of an object with an inventory. Then give
               the object a string variable "fill_with" with the value the
               resref of the item you want this container to have in it. If
               you want to spawn more than one, put an int variable
               "fill_quantity" with the desired quantity.
               Extension: use "fill_with1", "fill_with2"..."fill_with8" and
               "fill_quantity1"..."fill_quantity8" for different types of items.

*/
void _CreateItemVoid(string sResRef)
{
 CreateItemOnObject(sResRef);
}

void main()
{
  //Clear inventory and restock with quest item.
  string sResRef = GetLocalString(OBJECT_SELF, "fill_with");
  int nNumOf = GetLocalInt(OBJECT_SELF, "fill_quantity");
  if (nNumOf == 0) nNumOf = 1;

  object oItem = GetFirstItemInInventory();

  while (oItem != OBJECT_INVALID)
  {
    DestroyObject(oItem);
    oItem = GetNextItemInInventory();
  }

  int jj;
  int ii;
  for (jj = 1; jj < 10; jj++)
  {
    for (ii = 0; ii < nNumOf; ii++)
    {
      DelayCommand(0.1f, _CreateItemVoid(sResRef));
    }

    sResRef = GetLocalString(OBJECT_SELF, "fill_with" + IntToString(jj));
    nNumOf = GetLocalInt(OBJECT_SELF, "fill_quantity" + IntToString(jj));
    if (nNumOf == 0) nNumOf = 1;

  }
}
