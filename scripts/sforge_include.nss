// sforge_include
// Gold cost = ((item property cost) ^2) * 810
// But there's no simple cost/level ratio.
/*
lev/cost/ xp
1  657    0
4  2925   6000
7  6813   21000
9  12321  36000
11 19449  55000
16 58523  120000
19 98010  171000
21 158760 210000
21 207360 210000
23 547560 253000

As soulforging is going up to level 20, we will use the gold cost as the XP
cost of the item.

*/
#include "x2_inc_itemprop"
#include "mi_log"
const string SOULFORGING = "SOULFORGING"; // For logging
const string SOULFORGE_ITEM    = "SOULFORGE_ITEM"; // Notes which item we've
                                                   // targetted.

// Returns the 2da value of the item property
float GetItemPropertyCost(itemproperty iprp);

// Returns the GP value of the item's properties. This does not include the
// base cost of the item. Returns 0 for a propertyless item or non-item object.
int GetItemCost(object oItem);

float GetItemPropertyCost(itemproperty iprp)
{
  int nCostTable = GetItemPropertyCostTable(iprp);
  int nValue = GetItemPropertyCostTableValue(iprp);
  Trace(SOULFORGING, "Cost table number: " + IntToString(nCostTable));
  Trace(SOULFORGING, "Cost table value number: " + IntToString(nValue));

  string s2DA = Get2DAString("iprp_costtable", "Name", nCostTable);
  Trace(SOULFORGING, "Cost table name: " + s2DA);
  string sValue = Get2DAString(s2DA, "Cost", nValue);
  Trace(SOULFORGING, "Cost table value: " + sValue);
  float fValue = StringToFloat(sValue);

  // If bonus damage, add the cost of the damage itself.
  if (GetItemPropertyType(iprp) == ITEM_PROPERTY_DAMAGE_BONUS)
  {
    int nSubType = GetItemPropertySubType(iprp);
    string sExtraCost = Get2DAString("iprp_damagetype", "Cost", nSubType);
    Trace(SOULFORGING, "Adding cost for damage type: " + sExtraCost);
    fValue += StringToFloat(sExtraCost);
  }

  return fValue;
}

int GetItemCost(object oItem)
{
  float fCost = 0.0;
  itemproperty iprp = GetFirstItemProperty(oItem);

  while (GetIsItemPropertyValid(iprp))
  {
    Trace(SOULFORGING, "Got item property.");
    fCost += GetItemPropertyCost(iprp);
    iprp = GetNextItemProperty(oItem);
  }

  int nGoldCost = FloatToInt(fCost * fCost * 810.0);

  Trace(SOULFORGING, "Returning value:   " + IntToString(nGoldCost));
  return nGoldCost;
}
