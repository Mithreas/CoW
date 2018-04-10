// Ressurrects a dog if the correct components are used.
const string HOLY_WATER = "X1_WMGRENADE005";
const string INCENSE    = "stickofincense";
const string GEM_START  = "ca_gem";
const string COLLAR     = "dogcollar";
const string DEADCOLLAR = "deaddogcollar";
string DESCRIPTION      =
"Silently you light the incense and wait, letting its smoke fill the air, "+
"hoping its fragrance will please the Gods, and that they will heed your "+
"request.You pass the small tuft of fur that is all that remains of your dog "+
"through the incense smoke before placing it in a large, golden bowl. You "+
"sprinkle holy water on it, whispering prayers to the Seven Divines, and then "+
"the dust of a gem sacred to one of them. Eyes closed, you wait in prayer "+
"until a cold nose pushes into the back of your neck. The Seven Divines have "+
"smiled on you, and returned your dog to the World. ";

void main()
{
  object oPC = GetLastDisturbed();
  int    nHolyWater = 0;
  int    nIncense   = 0;
  int    nGem       = 0;
  int    nCollar    = 0;
  string sGemTag    = "";

  object oItem = GetFirstItemInInventory();
  string sTag = GetTag(oItem);

  while (GetIsObjectValid(oItem))
  {
    if (sTag == HOLY_WATER)
    {
      nHolyWater = 1;
    }
    else if (sTag == INCENSE)
    {
      nIncense =1;
    }
    else if (GetStringLeft(sTag, GetStringLength(GEM_START)) == GEM_START)
    {
      nGem = 1;
      sGemTag = sTag;
    }
    else if (sTag == DEADCOLLAR)
    {
      nCollar = 1;
    }

    oItem = GetNextItemInInventory();
    sTag = GetTag(oItem);
  }

  if (nHolyWater && nIncense && nGem && nCollar)
  {
    DestroyObject(GetItemPossessedBy(OBJECT_SELF, HOLY_WATER));
    DestroyObject(GetItemPossessedBy(OBJECT_SELF, INCENSE));
    DestroyObject(GetItemPossessedBy(OBJECT_SELF, sGemTag));
    DestroyObject(GetItemPossessedBy(OBJECT_SELF, DEADCOLLAR));
    SendMessageToPC(oPC, DESCRIPTION);
    CreateItemOnObject(COLLAR, oPC);
  }
}
