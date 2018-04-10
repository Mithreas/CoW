#include "gs_inc_pc"
#include "mi_inc_disguise"

/* Bar System, features:

  - Randomly named drinks are available in the NPC Barkeepers shop
  - Randomly named drinks are availble from the resources placed out for PC Barkeepers
  - The randomly named drinks are listed on an advertisement board
  - PCs can be hired by a bar recruiter to work in the bar and start out as Servants
  - Each rl week the PCs activity for a bar gets checked, 60 points in 1 week are needed to be/stay Servant, 120 points to become/be Bartender, 180 points for Brewmaster, if not active enough to stay servant, the PC gets fired
  - Fired PCs cannot apply again to the same bar for 2 rl weeks
  - Costprice of the drinks from the resources are 3 gc for a servant, 2 gc for a bartender and 1 gc for a brewmaster.
  - Each rl week the PC gets an XP reward of 1000 xp times the Barkeeper level
  - When a PC barkeeper starts to work in a Bar, the NPC Barkeeper will leave. He will return when no PC barkeepers are working in the bar anymore.

*/

/* Bar System, setup instructions

   These are the components available (all under special, custom 1):

   Placeable - Bar System: Chest (use only 1 for each module)
   Placeable - Bar System: Load (use only 1 for each module)
   Placeable - Bar System: Resource (use as many as you like in a bar)
   Placeable - Bar System: Sign (use as many as you like in a bar)
   Trigger - Bar System: Trigger (use 1 for each bar)
   Item - Bar System: Draft Template (not needed for builder)
   Item - Bar System: Cup Template 1 (not needed for builder)
   Item - Bar System: Cup Template 2 (not needed for builder)
   Item - Bar System: Cup Template 3 (not needed for builder)
   Item - Bar System: Tea Template (not needed for builder)
   Item - Bar System: Coffee Template (not needed for builder)
   Item - Bar System: Juice Template (not needed for builder)
   Creature - Bar System: Recruiter (use 1 for each bar)
   Creature - Bar System: NPC Barkeeper (use as many as you like in a bar)
   Merchant - Bar System: Store (use 1 for each bar)

   Instructions:

   1. Draw a trigger around the bar area, that will count as worktime for the PC Barkeepers.
   2. Place out resource placeables inside the trigger area where you like, change appearance to your liking. Name will be generated automatically each reset. 
	- You can set a gvd_fixed_drink string variable to make sure the resource always pours a drink with that name, also change the name and description of the placeable in that case.
        - gvd_draft = 0 (or not set) means cups will be used (wines, spirits and the likes)
	- You can set a gvd_draft int variable to 1, if you want that resource to produce draft drinks (beers)
        - You can set a gvd_draft int variable to 2, if you want that resource to produce tea drinks
        - You can set a gvd_draft int variable to 3, if you want that resource to produce coffee drinks
        - You can set a gvd_draft int variable to 4, if you want that resource to produce juice drinks
  - You can set a gvd_namelist int variable to 1 to use the UD namelists. Otherwise it will use the default (surface-centric) namelists.
   3. [optional] Place out 1 or more sign placeables in the same area as the bar. Change the name and the first part of the description to your liking. A list of random drinks will be added to the description each reset.
   4. Put a Recruiter in the same area as the bar. Change the name and appearance to your liking and change the tag to something unique, so you can use the daypost waypoint for this NPC.
      [places like the Nomad have a quarter ownership which determines who can serve drinks, so no need for Recruiter there, set the gvd_autohire int variable to 1 for the bar trigger area(s) in that case]
   5. Put 1 or more NPC Barkeeper(s) in the bar, who will sell the drinks when no PC barkeepers are around. You cannot change the tag, add a gvd_tag string variable instead to setup the tagname you want the NPC to end up with, that can be used with the daypost waypoints and stuff. Change name/appearance freely.
   6. Put 1 Store somewhere in/near the Bar area. The random drinks will be added automatically, other then that you can add any other items you like.

   You don't need to setup any other variables unless the bar consists of multiple areas, in that case set the same gvd_barid string variable on all of the Resources, Signs, Triggers and Recruiters to identify them belonging to the same bar.
   If the bar consists of 1 area this is not needed, the area tag the bar is located in, will be used to identify them as belonging to the same bar.


*/

/* PC hide variables usage, 4 for each bar

  gvd_barid_[baridhere], keeps track of the timestamp for the weekly activity calculations, a PC with a value here is a barkeeper for the bar
  gvd_baract_[baridhere], keeps track of the weekly activity points earned in the current workweek for this PC with the bar
  gvd_barlvl_[baridhere], keeps track of the current barkeeper level for this PC with the bar
  gvd_barfired_[baridhere], keeps track of the timestamp this PC was fired with the bar

*/

const string S_LOCATION = "Bendirian|Brogendensteiner|Cordorian|Guldorander|Myonian|Wharftowner|Amnian|Arabellan|Baldurian|Berduskan|Moonshae|Luiren|Gorgondy|Golden Sands|Saerloonian|Shadowdark|Vilhon|Waterdhavian";
const int I_LOCATION = 18;

const string S_LOCATION_UD = "Udosian|Grondian|Blingstonholder|Andunorian|Dirk Hargunenar|Iltkazari|Nasadran|Dunspeirrin|Eryndlar|Gracklstugh|Maerimydraen|Sshamathan|T'lindethi|Cairnheimer";
const int I_LOCATION_UD = 14;

const string S_TYPE = "Wine (White)|Wine (Red)|Wine (Bubbling)|Rum|Brandywine|Liqueur|Whiskey|Spirits|Glowfire|Moonshine|Vodka|Gin";
const int I_TYPE = 12;

const string S_TYPE_UD = "Wine (White)|Wine (Red)|Wine (Bubbling)|Rum|Brandywine|Liqueur|Whiskey|Spirits|Draught|Rotgut|Kykeon";
const int I_TYPE_UD = 11;

const string S_TYPEDRAFT = "Beer (Ale)|Brew|Beer (Amber)|Mead|Lager|Beer (Dark)|Beer (Blond)|Beer (Pale)|Beer (Stout)|Cider";
const int I_TYPEDRAFT = 10;

const string S_TYPEDRAFT_UD = "Beer (Mushroom Ale)|Beer (Mushroom Stout)|Brew|Mead|Lager|Grog|Cider|Scum (Fresh)|Scum (Lukewarm)";
const int I_TYPEDRAFT_UD = 9;

const string S_TYPETEA = "Tea (Black)|Tea (Green)|Tea (White)|Tea (Red)|Tea (Mint)";
const int I_TYPETEA = 5;

const string S_TYPETEA_UD = "Tea (Bloodroot)|Tea (Mushroom)|Tea (Algae)";
const int I_TYPETEA_UD = 3;

const string S_TYPECOFFEE = "Coffee (Regular)|Coffee (Strong)|Coffee (Milk)";
const int I_TYPECOFFEE = 3;

const string S_TYPEJUICE = "Juice (Orange)|Lemonade|Juice (Strawberry)|Juice (Lemon)|Juice (Pineapple)|Juice (Pear)|Milk|Chocolate Milk|Hot Chococate|Soda|Soda (Lemon)";
const int I_TYPEJUICE = 11;

const string S_TYPEJUICE_UD = "Juice (Barrelstalk)|Juice (Spore Mould)|Juice (Ooze)|Juice (Bubbling Ooze)|Rothe Milk|Spiced Rothe Milk|Squig Milk";
const int I_TYPEJUICE_UD = 7;

// never change the number of quality entries to anything above 9, since these are used to increase the cost price of the drinks with the NPC merchant, there are only 9 different item templates
const string S_QUALITY = "Cheap|Regular|Fine|Quality|Excellent|Premium|Rare|Vintage|Exquisite";
const int I_QUALITY = 9;

// function that creates a drink for the barkeeper PC for bar sBarID with name sDrinkName being a draft if iDraft = 1, otherwise none draft
void GetDrinkForBarkeeper(object oPC, string sBarID, string sDrinkName, int iDraft);

// function that returns a random drink, set iDraft to 1 to return draft beer, and to 0 to return none draft
string GetRandomDrinkName(int iDraft, int iNamelist = 0);

// function to add sDrinkName to any advertisement signs with sBarID
void AddDrinkToSign(string sDrinkName, string sBarID);

// function to add drink of type iDraft with name sDrinkName to any merchant stores with sBarID
void AddDrinkToStore(string sBarDrink, string sBarID, int iDraft);

// function to get the store object for sBarID
object GetStoreForBar(string sBarID);

// function to get the BarID of an object
string GetBarID(object oBarObject);

// function to hire oPC as barkeeper for the bar with sBarID, return 1 on succes, or 0 on failure
int HireBarkeeper(object oPC, string sBarID);

// function to fire oPC from bar with sBarID
void FireBarkeeper(object oPC, string sBarID);

// function to check if oPC works for bar with sBarID, return 1 is so, 0 is not
int GetIsBarkeeper(object oPC, string sBarID);

// function to get barkeeper oPC's activity for bar with sBarID
int GetBarkeeperActivity(object oPC, string sBarID);

// function to get the level of barkeeper oPC for bar with sBarID, returns 0 if no barkeeper
int GetBarkeeperLevel(object oPC, string sBarID);

// function to get the title of barkeeper oPC based on it's level for sBarID
string GetBarkeeperTitle(object oPC, string sBarID);

// function to log starttime of oPC with bar sBarID
void BarkeeperShiftStart(object oPC, string sBarID);

// function to check if oPC is working a shift in sBarID atm, returns 1 is so, 0 if not
int BarkeeperShiftActive(object oPC, string sBarID);

// function to log end of bar shift of oPC with bar sBarID
void BarkeeperShiftEnd(object oPC, string sBarID);

// function to get element number iElement from sString, which is seperated by sDelimeter
string gvd_GetStringElement(string sString, int iElement, string sDelimeter);

// function to (temporarily) remove the NPC Barkeeper for sBarID
void RemoveBarkeeperNPC(string sBarID);

// function to return the NPC Barkeeper for sBarID
void ReturnBarkeeperNPC(string sBarID);

// function to check if a PC is working inside sBarID atm
int GetIsBarActive(string sBarID);

// depending on barkeeper "level" generate a different priced drink
void GetDrinkForBarkeeper(object oPC, string sBarID, string sDrinkName, int iDraft) {

  // get the temporary chest object
  object oBarChest = GetObjectByTag("gvd_barsys_chest");
  string sDraft;

  // determine barkeeper level (starter is 3 gc, regular is 2 gc, pro = 1 gc)

  int iLevel = GetBarkeeperLevel(oPC, sBarID);

  int iCost = 4 - iLevel;

  // PC has enough gold to draw drink?
  if (GetGold(oPC) >= iCost) {

    TakeGoldFromCreature(iCost, oPC);

    // depending on draft or not get the resref with the corresponding appearance
    string sResRef;
    if (iDraft == 1) {
      // beer
      sDraft = "draft";
      sResRef = "gvd_barsys_draft";
    } else if (iDraft == 2) {
      // tea
      sDraft = "tea";
      sResRef = "gvd_barsys_tea";
    } else if (iDraft == 3) {
      // coffee
      sDraft = "coffee";
      sResRef = "gvd_barsys_coff";
    } else if (iDraft == 4) {
      // juice
      sDraft = "juice";
      sResRef = "gvd_barsys_juice";
    } else {
      // wine, spirits
      sDraft = "cup";

      // 3 types of cups
      if (d2(1) == 1) {
        sResRef = "gvd_barsys_cup1";
      } else {
        if (d2(1) == 1) {
          sResRef = "gvd_barsys_cup2";
        } else {
          sResRef = "gvd_barsys_cup3";
        }
      }
    }

    FloatingTextStringOnCreature("You pour a fresh " + sDrinkName, oPC);

    // create the drink in the temporary chest so we can rename it first
    object oDrink = CreateItemOnObject(sResRef, oBarChest, 1, "gvd_barsys_" + sDraft + "_" + sDrinkName);

    // set the correct name
    SetName(oDrink, sDrinkName);

    // transfer to barkeeper PC
    AssignCommand(oBarChest, ActionGiveItem(oDrink, oPC));

    // log the drink as sold
    int iDrinksSold = GetLocalInt(oPC, "gvd_barsys_drinkssold");
    SetLocalInt(oPC, "gvd_barsys_drinkssold", iDrinksSold + 1);

  } else {
    // not enough gold
    SendMessageToPC(oPC, "You don't have enough gold for this");
  }

}

string GetRandomDrinkName(int iDraft, int iNamelist) {

  int iRandom;
  string sDrink;

  int iDrinkLocation = I_LOCATION;
  int iDrinkType = I_TYPE;
  int iDrinkTypeDraft = I_TYPEDRAFT;
  int iDrinkTypeTea = I_TYPETEA;
  int iDrinkTypeCoffee = I_TYPECOFFEE;
  int iDrinkTypeJuice = I_TYPEJUICE;

  string sDrinkLocation = S_LOCATION;
  string sDrinkType = S_TYPE;
  string sDrinkTypeDraft = S_TYPEDRAFT;
  string sDrinkTypeTea = S_TYPETEA;
  string sDrinkTypeCoffee = S_TYPECOFFEE;
  string sDrinkTypeJuice = S_TYPEJUICE;

  // only add quality text for beers and wines/spirits
  if (iDraft <= 1) {
    iRandom = Random(I_QUALITY) + 1;
    sDrink = gvd_GetStringElement(S_QUALITY, iRandom, "|");

    // store quality number as variable on the load placeable for easy use in the add drink to merchant function
    object oBarLoad = GetObjectByTag("gvd_barsystem_load");
    SetLocalInt(oBarLoad, "drink_quality", iRandom);

    sDrink = sDrink + " ";

  } else {
    sDrink = "";
  }

  // Batra: check which namelist we're using
  // (0 = Surface (default), 1 = Underdark)
  if (iNamelist == 1)
  {
    iDrinkLocation = I_LOCATION_UD;
    iDrinkType = I_TYPE_UD;
    iDrinkTypeDraft = I_TYPEDRAFT_UD;
    iDrinkTypeTea = I_TYPETEA_UD;
    iDrinkTypeJuice = I_TYPEJUICE_UD;

    sDrinkLocation = S_LOCATION_UD;
    sDrinkType = S_TYPE_UD;
    sDrinkTypeDraft = S_TYPEDRAFT_UD;
    sDrinkTypeTea = S_TYPETEA_UD;
    sDrinkTypeJuice = S_TYPEJUICE_UD;
  }

  iRandom = Random(iDrinkLocation) + 1;
  sDrink = sDrink + gvd_GetStringElement(sDrinkLocation, iRandom, "|");

  // generate a draft drink or other
  if (iDraft == 0) {
    // other
    iRandom = Random(iDrinkType) + 1;
    sDrink = sDrink + " " + gvd_GetStringElement(sDrinkType, iRandom, "|");
  } else if (iDraft == 1) {
    // draft
    iRandom = Random(iDrinkTypeDraft) + 1;
    sDrink = sDrink + " " + gvd_GetStringElement(sDrinkTypeDraft, iRandom, "|");
  } else if (iDraft == 2) {
    // tea
    iRandom = Random(iDrinkTypeTea) + 1;
    sDrink = sDrink + " " + gvd_GetStringElement(sDrinkTypeTea, iRandom, "|");
  } else if (iDraft == 3) {
    // coffee
    iRandom = Random(iDrinkTypeCoffee) + 1;
    sDrink = sDrink + " " + gvd_GetStringElement(sDrinkTypeCoffee, iRandom, "|");
  } else if (iDraft == 4) {
    // juice
    iRandom = Random(iDrinkTypeJuice) + 1;
    sDrink = sDrink + " " + gvd_GetStringElement(sDrinkTypeJuice, iRandom, "|");
  }

  return sDrink;

}

void AddDrinkToSign(string sBarDrink, string sBarID) {

  int iBarSign = 0;
  object oBarSign = GetObjectByTag("gvd_barsys_sign", iBarSign);

  // loop through all bar sign objects
  while (oBarSign != OBJECT_INVALID) {

    // check if the BarID matches with the parameter
    if (sBarID == GetBarID(oBarSign)) {
      // add drink to the description of the signboard
      SetDescription(oBarSign, GetDescription(oBarSign) + "\n- " + sBarDrink);

    }

    // next object
    iBarSign = iBarSign + 1;
    oBarSign = GetObjectByTag("gvd_barsys_sign", iBarSign);

  }

}

void AddDrinkToStore(string sBarDrink, string sBarID, int iDraft) {

  int iBarStore = 0;
  object oBarStore = GetObjectByTag("gvd_barsys_store", iBarStore);
  string sResRef;
  int iQuality;
  string sDraft;

  // determine resref for drink item, use the NPC resrefs so the price is at least 5 gc, this allows PC bartenders to sell with some profit as well
  if (iDraft == 1) {
    // beer, check the quality of the drink to increase the price with the merchant
    sDraft = "draft";
    object oBarLoad = GetObjectByTag("gvd_barsystem_load");
    iQuality = GetLocalInt(oBarLoad, "drink_quality");

    // make sure we have a valid result
    if (iQuality < 1) {
      iQuality = 1;
    } else {
       if (iQuality > 9) {
         iQuality = 9;
       }
    }
    sResRef = "gvd_barsys_draf" + IntToString(iQuality);
  } else if (iDraft == 2) {
    // tea
    sDraft = "tea";
    sResRef = "gvd_barsys_tea1";
  } else if (iDraft == 3) {
    // coffee
    sDraft = "coffee";
    sResRef = "gvd_barsys_coff1";
  } else if (iDraft == 4) {
    // juice
    sDraft = "juice";
    sResRef = "gvd_barsys_juic1";
  } else {
    // wine, spirits, check the quality of the drink to increase the price with the merchant
    sDraft = "cup";
    object oBarLoad = GetObjectByTag("gvd_barsystem_load");
    iQuality = GetLocalInt(oBarLoad, "drink_quality");

    // make sure we have a valid result
    if (iQuality < 1) {
      iQuality = 1;
    } else {
       if (iQuality > 9) {
         iQuality = 9;
       }
    }

    // 3 types of cups
    if (d2(1) == 1) {
      sResRef = "gvd_barsys_cup1" + IntToString(iQuality);
    } else {
      if (d2(1) == 1) {
        sResRef = "gvd_barsys_cup2" + IntToString(iQuality);
      } else {
        sResRef = "gvd_barsys_cup3" + IntToString(iQuality);
      }
    }
  }

  // loop through all bar store objects
  while (oBarStore != OBJECT_INVALID) {

    // check if the BarID matches with the parameter
    if (sBarID == GetBarID(oBarStore)) {
      // add drink to the store

      // create the drink in the store
      object oDrink = CreateItemOnObject(sResRef, oBarStore, 1, "gvd_barsys_" + sDraft + "_" + sBarDrink);

      // set the correct name
      SetName(oDrink, sBarDrink);

      // make it infinite
      SetInfiniteFlag(oDrink, 1);

    }

    // next object
    iBarStore = iBarStore + 1;
    oBarStore = GetObjectByTag("gvd_barsys_store", iBarStore);

  }

}

object GetStoreForBar(string sBarID) {

  int iBarStore = 0;
  object oBarStore = GetObjectByTag("gvd_barsys_store", iBarStore);
  object oStore = OBJECT_INVALID;

  // loop through all bar store objects
  while ((oBarStore != OBJECT_INVALID) && (oStore == OBJECT_INVALID)) {

    // check if the BarID matches with the parameter
    if (sBarID == GetBarID(oBarStore)) {
      // found the correct store
      oStore = oBarStore;
    }

    // next object
    iBarStore = iBarStore + 1;
    oBarStore = GetObjectByTag("gvd_barsys_store", iBarStore);

  }

  return oStore;

}



string GetBarID(object oBarObject) {

  string sBarID;

  // check if a gvd_barid variable is used
  sBarID = GetLocalString(oBarObject, "gvd_barid");

  // if blank, use the area tag instead
  if (sBarID == "") {
    sBarID = GetTag(GetArea(oBarObject));
  }

  return sBarID;

}

int HireBarkeeper(object oPC, string sBarID) {

  object oHide = gsPCGetCreatureHide(oPC);

  // check if PC was fired within the last 14 rl days
  int iFired = GetLocalInt(oHide, "gvd_barfired_"+sBarID);
  int iTimestamp = GetLocalInt(GetModule(),"GS_TIMESTAMP");

  if (iFired != 0) {
    if (((gsTIGetRealTimestamp(iTimestamp) - gsTIGetRealTimestamp(iFired)) / 60) < 20160) {
      // still in 14 day fired time-out
      return 0;
    } else {
      // time-out passed
    }    
  }

  // log starting date/time of the PCs bar job for this bar by setting the timestamp as value

  SetLocalInt(oHide, "gvd_barid_"+sBarID, iTimestamp);

  // weekly activity tracker for this bar
  SetLocalInt(oHide, "gvd_baract_"+sBarID, 1);

  // starting level for this bar
  SetLocalInt(oHide, "gvd_barlvl_"+sBarID, 1);

  return 1;

}

void FireBarkeeper(object oPC, string sBarID) {

  object oHide = gsPCGetCreatureHide(oPC);

  // clean variables
  DeleteLocalInt(oHide, "gvd_barid_"+sBarID);
  DeleteLocalInt(oHide, "gvd_baract_"+sBarID);
  DeleteLocalInt(oHide, "gvd_barlvl_"+sBarID);
  
  FloatingTextStringOnCreature("You are fired for being lazy", oPC);
 
  // keep track of this, fired barkeepers can't work for the same bar again for at least 2 weeks
  int iTimestamp = GetLocalInt(GetModule(),"GS_TIMESTAMP");
  SetLocalInt(oHide, "gvd_barfired_"+sBarID, iTimestamp);

}

int GetIsBarkeeper(object oPC, string sBarID) {

  object oHide = gsPCGetCreatureHide(oPC);
  int iWeekStart = GetLocalInt(oHide, "gvd_barid_"+sBarID);


  if (iWeekStart == 0) {
    return 0;

  } else {

    // check if a full rl week has past since the beginning of this weeks activity tracking
    int iTimestamp = GetLocalInt(GetModule(),"GS_TIMESTAMP");

    // fix for epoch clock reset, on this rare occasion we consider 1 rl week has passed
    if ((((gsTIGetRealTimestamp(iTimestamp) - gsTIGetRealTimestamp(iWeekStart)) / 60) > 10080) || (iWeekStart > iTimestamp)) {
      // more then 1 rl week has passed since beginning of this weeks activity tracker, check if enough activity points were earned

      // servants need an activity of at least 30 (1/2 rl productive hour) points each rl week, or they get fired
      // bartenders need an activity of at least 60 (1 rl productive hours) points each rl week, or they become servants
      // brewmasters need an activity of at least 90 (1 1/2 rl productive hours) points each rl week, or they become bartenders

      int iActivity = GetBarkeeperActivity(oPC, sBarID);
      int iLevel = GetBarkeeperLevel(oPC, sBarID);

      if ((iActivity - (iLevel * 30)) < 0) {
        // not active enough this week, drop 1 level
        if (iLevel > 1) {
          FloatingTextStringOnCreature("You lost a Barkeeper level due to inactivity", oPC);
          SetLocalInt(oHide, "gvd_barlvl_" + sBarID, (iLevel - 1));

          // still give the XP for the new level:
          GiveXPToCreature(oPC, ((iLevel - 1) * 1000));
 
          // log to be able to check it's working
          WriteTimestampedLogEntry("BAR SYSTEM: " + GetName(oPC) + " lost a barkeeper:" + IntToString(iLevel-1) +", still got XP.");

        } else {
          // fired
          // for now, nobody gets fired
          // FireBarkeeper(oPC, sBarID);
          // return 0;

          // log to be able to check it's working
          WriteTimestampedLogEntry("BAR SYSTEM: " + GetName(oPC) + " lost a barkeeper level but already was level 1, no XP.");

        }

      } else if ((iActivity - (iLevel * 30)) > 30) {
        // very active week, gain 1 level
        FloatingTextStringOnCreature("You gained a new Barkeeper level", oPC);
        SetLocalInt(oHide, "gvd_barlvl_" + sBarID, (iLevel + 1));

        // give XP reward for this, 1000 xp for each level
        GiveXPToCreature(oPC, ((iLevel + 1) * 1000));

        // log to be able to check it's working
        WriteTimestampedLogEntry("BAR SYSTEM: " + GetName(oPC) + " gained a barkeeper level: " + IntToString(iLevel+1) + ".");

      } else {
        // normal week for barkeeper level, do nothing

        // give XP reward for this, 1000 xp for each level
        GiveXPToCreature(oPC, (iLevel * 1000));   
     
        // log to be able to check it's working
        WriteTimestampedLogEntry("BAR SYSTEM: " + GetName(oPC) + " did a regular week for the current barkeeper level: " + IntToString(iLevel) + ".");

      }

      // reset weekly activity tracker
      SetLocalInt(oHide, "gvd_baract_"+sBarID, 1);
      SetLocalInt(oHide, "gvd_barid_"+sBarID, iTimestamp);

    }

    return 1;

  }

}

int GetBarkeeperLevel(object oPC, string sBarID) {

  object oHide = gsPCGetCreatureHide(oPC);
  
  return GetLocalInt(oHide, "gvd_barlvl_" + sBarID);

}

string GetBarkeeperTitle(object oPC, string sBarID) {

  int iLevel = GetBarkeeperLevel(oPC, sBarID);
  string sTitle = "";

  if (iLevel == 1) {
    sTitle = "Server";
  } else if (iLevel == 2) {
    sTitle = "Bartender";
  } else if (iLevel >= 3) {
    sTitle = "Brewmaster";
  }

  return sTitle;

}


int GetBarkeeperActivity(object oPC, string sBarID) {

  object oHide = gsPCGetCreatureHide(oPC);

  // get PC weekly activity for the bar
  return GetLocalInt(oHide, "gvd_baract_"+sBarID);

}

void BarkeeperShiftStart(object oPC, string sBarID) {

  // store start time as variable on the PC
  int iTimestamp = GetLocalInt(GetModule(),"GS_TIMESTAMP");
  SetLocalInt(oPC, "gvd_barsys_shiftstart", iTimestamp);

  // add a barkeeper tag to the name, to identify the PC as working for the bar
  string sTitle = GetBarkeeperTitle(oPC, sBarID);
  if (sTitle != "") {
    fbNARemoveNameModifier(oPC, FB_NA_MODIFIER_DISGUISE);
    fbNAAddNameModifier(oPC, FB_NA_MODIFIER_DISGUISE, "", " (" + sTitle + ")");            
  }

}

int BarkeeperShiftActive(object oPC, string sBarID) {

  if (GetLocalInt(oPC, "gvd_barsys_shiftstart") != 0) {
    return 1;
  } else {
    return 0;
  }
 
}

void BarkeeperShiftEnd(object oPC, string sBarID) {

  // get starttime
  int iStart = GetLocalInt(oPC, "gvd_barsys_shiftstart");
  DeleteLocalInt(oPC, "gvd_barsys_shiftstart");

  // get endtime
  int iTimestamp = GetLocalInt(GetModule(),"GS_TIMESTAMP");

  // calculate barkeepers activity for this bar, keep track in rl minutes
  int iTimeShift = (gsTIGetRealTimestamp(iTimestamp) - gsTIGetRealTimestamp(iStart)) / 60;

  // 86400/60 = 1440 minutes = 1 rl day

  // formula used to calculate barkeepers acivitiy in bar, iTimeShift is in rl minutes:
  // max(1, (iDrinksSold / iTimeShift)) * (iTimeShift)

  if (iTimeShift > 0) {
    // update weekly activity for the PC with this Bar

    // get qty drinks sold during shift
    int iDrinksSold = GetLocalInt(oPC, "gvd_barsys_drinkssold");
    DeleteLocalInt(oPC, "gvd_barsys_drinkssold");

    // maximum factor is selling 1 drink each rl minute, selling more has no use for activity
    float fFactor = IntToFloat(iDrinksSold) / IntToFloat(iTimeShift);
    if (fFactor > 1.0f) {
      fFactor = 1.0f;
    }
  
    // update activity
    object oHide = gsPCGetCreatureHide(oPC);  
    int iActivity = GetBarkeeperActivity(oPC, sBarID);
    int iLevel = GetBarkeeperLevel(oPC, sBarID);
    SetLocalInt(oHide, "gvd_baract_"+sBarID, iActivity + FloatToInt(fFactor * iTimeShift));
        
  } else {
    // very short shift, no update needed
  }

  // remove the bartender tag behind the dynamic name again
  fbNARemoveNameModifier(oPC, FB_NA_MODIFIER_DISGUISE);

  // restore the disguised/slave tags if applicable
  if (gvd_CheckIsClamped(oPC)) {
    // add the (Slave) addition to the dynamic name of the PC
    if (GetIsPCDisguised(oPC) == TRUE) {
      int nPerform = GetSkillRank(SKILL_PERFORM, oPC);
      int nBluff   = GetSkillRank(SKILL_BLUFF,   oPC);
      if ((nPerform > 20) || (nBluff > 20)) {    
        fbNAAddNameModifier(oPC, FB_NA_MODIFIER_DISGUISE, "", " (Disguised)");
      } else {
        // disguising, but still recognisable as a slave
        fbNAAddNameModifier(oPC, FB_NA_MODIFIER_DISGUISE, "", " (Disguised Slave)");
      }
    } else {
      fbNAAddNameModifier(oPC, FB_NA_MODIFIER_DISGUISE, "", " (Slave)");            
    }
  }

  // check if this was the last PC barkeeper ending the shift for this bar, is so, return the NPC Barkeeper now
  if (GetIsBarActive(sBarID) != 1) {
    ReturnBarkeeperNPC(sBarID);
  }

}


string gvd_GetStringElement(string sString, int iElement, string sDelimeter) {

  int iDelimeter = FindSubString(sString, sDelimeter);
  int iDelimeterLen = GetStringLength(sDelimeter);
  int iCount = 1;
  int iLen;

  while ((iCount < iElement) && (iDelimeter >= 0)) {

    iLen = GetStringLength(sString);
    sString = GetStringRight(sString, iLen - iDelimeter - iDelimeterLen);
    iDelimeter = FindSubString(sString, sDelimeter);
    iCount = iCount + 1;

  }

  if (iCount == iElement) {
    if (iDelimeter < 0) {
      // last element
      return sString;
    } else {
      return GetStringLeft(sString, iDelimeter);
    }
  } else {
    return "";
  }

}

void RemoveBarkeeperNPC(string sBarID) {

  int iBarNPC = 0;
  object oBarNPC = GetObjectByTag("gvd_barsys_npc", iBarNPC);
  location locChest = GetLocation(GetObjectByTag("gvd_barsys_chest"));

  // loop through all bar npc objects
  while (oBarNPC != OBJECT_INVALID) {

    // check if the BarID matches with the parameter
    if (sBarID == GetBarID(oBarNPC)) {
      if (GetLocalInt(oBarNPC, "gvd_npc_inactive") != 1) {
        // move the barkeeper to the bars chest for the time being (inside a DM area someplace)
        SetLocalLocation(oBarNPC,"gvd_npc_loc", GetLocation(oBarNPC));
        SetLocalInt(oBarNPC, "gvd_npc_inactive", 1);
        AssignCommand(oBarNPC, JumpToLocation(locChest));      
      } else {
        // already inactive
      }

    }

    // next object
    iBarNPC = iBarNPC + 1;
    oBarNPC = GetObjectByTag("gvd_barsys_npc", iBarNPC);

  }  

}

void ReturnBarkeeperNPC(string sBarID) {  

  int iBarNPC = 0;
  object oBarNPC = GetObjectByTag("gvd_barsys_npc", iBarNPC);
  location locNPC;

  // loop through all bar npc objects
  while (oBarNPC != OBJECT_INVALID) {

    // check if the BarID matches with the parameter
    if (sBarID == GetBarID(oBarNPC)) {
      if (GetLocalInt(oBarNPC, "gvd_npc_inactive") == 1) {
        // move the barkeeper back to the bar
        locNPC = GetLocalLocation(oBarNPC, "gvd_npc_loc");
        AssignCommand(oBarNPC, JumpToLocation(locNPC));     
        DeleteLocalInt(oBarNPC, "gvd_npc_inactive");
        DeleteLocalLocation(oBarNPC, "gvd_npc_loc");
      } else {
        // already active
      }
 
    }

    // next object
    iBarNPC = iBarNPC + 1;
    oBarNPC = GetObjectByTag("gvd_barsys_npc", iBarNPC);

  }  

}

int GetIsBarActive(string sBarID) {

  // loop through all PCs and see if they are barkeeper in this bar and working their shift
  
  object oPC = GetFirstPC();
  int iActive = 0;

  while ((oPC != OBJECT_INVALID) && (iActive == 0)) {
    // PC barkeeper for this bar?
    if (GetIsBarkeeper(oPC, sBarID) == 1) {
      // active shift?
      if (BarkeeperShiftActive(oPC, sBarID) == 1) {
        // we found one
        iActive = 1;
      }
    }

    oPC = GetNextPC();
  }

  return iActive;

}

