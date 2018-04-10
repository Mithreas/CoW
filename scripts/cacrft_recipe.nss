//////////////////////////////////////////////////////////////////////
//cacrft_recipe
//Created by Cara 6/5/06
//This fires when a recipe card is activated and creates another one
/////////////////////////////////////////////////////////////////////

void main()
{
  object oItem = GetItemActivated();
  object oPC = GetItemActivator();
  string sItem = GetResRef(oItem);
  CreateItemOnObject(sItem, oPC, 1);
}
