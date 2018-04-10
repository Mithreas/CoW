/////////////////////////////////////////////////////////
//
//  Gem Stone Socketing System by Cara
//
//  Name:  ca_jewelwebench
//
//  Desc:  Creating an item based on what was put in
//
//  Author: Cara 02Jul06
//
/////////////////////////////////////////////////////////

//Include snazzy logging script to see where things are going wrong

#include "mi_log"

//Logs will have the CARA_GEM_CRAFTING name, however I only have to type
//GEMCRAFT

const string GEMCRAFT = "CARA_GEM_CRAFTING";

//Start main script

void main()
{
  //Variables for counting number of each gem
  //Diamonds
  int nDiaLrg = 0;
  int nDiaSml = 0;
  //Sunstone
  int nSunLrg = 0;
  int nSunSml = 0;
  //Moonstone
  int nMooLrg = 0;
  int nMooSml = 0;
  //Skystone
  int nSkyLrg = 0;
  int nSkySml = 0;
  //Darkstone
  int nDarLrg = 0;
  int nDarSml = 0;
  //Starstone
  int nStaLrg = 0;
  int nStaSml = 0;
  //Obsidian
  int nObsLrg = 0;
  int nObsSml = 0;

  //Variable to say which item is the base one

  object oBase = OBJECT_INVALID;

  //Variable to say whether we've found a propertied item

  int nBaseItemFound = 0;

  //Variable to check there's only one base item in there and cause an error
  //message if there are more than one

  int nHaveBase = 0;

  //Set variables to see if various things that can go wrong have

  //If we have more than one base, set this to 1, otherwise 0
  int nTooManyBases = 0;

  //If we have no bases at the end, set this to 1, otherwise 0
  int nNoBases = 0;


  //If there is anything else, or they closed it without putting anything in,
  //set this to 1, otherwise 0

  int nJunk = 0;

  //Go through the item's inventory, check this is sensible
  //Get the first item in inventory, call it oItem
  object oItem = GetFirstItemInInventory();

  while(GetIsObjectValid(oItem))
  {
  //get its tag
  string sTag = GetTag(oItem);

  //There shouldn't be gems in here, this is the unsetting bench

  //Now we're done seeing if they put a gem in and counting it
  //See if it's one of the allowed base item types
  //If so, count the number of gem slots it has and say we've found a base

  if(GetStringLeft(sTag, 4) == "ca_1")
  {
    nHaveBase++;
    Trace(GEMCRAFT, "Added copper base");
  }

  else if(GetStringLeft(sTag, 4) == "ca_2")
  {
    nHaveBase++;
    Trace(GEMCRAFT, "Added bronze base");
  }

  else if(GetStringLeft(sTag, 4) == "ca_3")
  {
    nHaveBase++;
    Trace(GEMCRAFT, "Added iron base");
  }

  else if(GetStringLeft(sTag, 4) == "ca_4")
  {
    nHaveBase++;
    Trace(GEMCRAFT, "Added silver base");
  }

  else if(GetStringLeft(sTag, 4) == "ca_5")
  {
    nHaveBase++;
    Trace(GEMCRAFT, "Added gold base");
  }

  else if(GetStringLeft(sTag, 4) == "ca_6")
  {
    nHaveBase++;
    Trace(GEMCRAFT, "Added mithril base");
  }

  //If it's not tagged ca_ then we've found junk, stop and return
  //error message

  else if(GetStringLeft(sTag, 3) != "ca_")
  {
    nJunk = 1;
    Trace(GEMCRAFT, "You've found junk!");
    break;
  }

  else if(GetStringLeft(sTag, 4) == "ca_g")
  {
    nJunk = 1;
    break;
  }

  //Check if we have too many bases, if so stop and return error message.

  if (nHaveBase > 1)
  {
    nTooManyBases = 1;
    Trace(GEMCRAFT, "You have too many bases!");
    break;
  }

  //Check if we have one base, if so start counting properties and add
  //virtual gems so the new item will have those properties plus whatever
  //you're adding from the other gems

  if ((nHaveBase == 1) && (nBaseItemFound == 0))
  {
    Trace(GEMCRAFT, "You have one base, proceed!");
    itemproperty iprop = GetFirstItemProperty(oItem);
    while (GetIsItemPropertyValid(iprop))
    {
      //If there's a saves bonus on it, count how much and add that to the number of
      //large diamonds you have
      if (GetItemPropertyType(iprop) == ITEM_PROPERTY_AC_BONUS)
      {
        int nUS = GetItemPropertyCostTableValue(iprop);
        nDiaLrg += nUS; //nDiaLrg +nUS
        Trace(GEMCRAFT, "Added " +IntToString (nUS) + " large virtual diamonds");
      }

      //Repeat many, many times for the other properties possible

      else if (GetItemPropertyType(iprop) == ITEM_PROPERTY_ABILITY_BONUS)
      {

        if (GetItemPropertySubType(iprop) == ABILITY_CHARISMA)
        {
          int nCHA = GetItemPropertyCostTableValue(iprop);
          nStaLrg += nCHA;
          Trace(GEMCRAFT, "Added " +IntToString (nCHA) + " large virtual starstones");
        }

        else if (GetItemPropertySubType(iprop) == ABILITY_CONSTITUTION)
        {
          int nCON = GetItemPropertyCostTableValue(iprop);
          nSkyLrg += nCON;
          Trace(GEMCRAFT, "Added " +IntToString (nCON) + " large virtual skystones");
        }

        else if (GetItemPropertySubType(iprop) == ABILITY_DEXTERITY)
        {
          int nDEX = GetItemPropertyCostTableValue(iprop);
          nDarLrg += nDEX;
          Trace(GEMCRAFT, "Added " +IntToString (nDEX) + " large virtual darkstones");
        }

        else if (GetItemPropertySubType(iprop) == ABILITY_INTELLIGENCE)
        {
          int nINT = GetItemPropertyCostTableValue(iprop);
          nObsLrg += nINT;
          Trace(GEMCRAFT, "Added " +IntToString (nINT) + " large virtual obsidians");
        }

        else if (GetItemPropertySubType(iprop) == ABILITY_STRENGTH)
        {
          int nSTR = GetItemPropertyCostTableValue(iprop);
          nSunLrg += nSTR;
          Trace(GEMCRAFT, "Added " +IntToString (nSTR) + " large virtual sunstones");
        }

        else if (GetItemPropertySubType(iprop) == ABILITY_WISDOM)
        {
          int nWIS = GetItemPropertyCostTableValue(iprop);
          nMooLrg += nWIS;
          Trace(GEMCRAFT, "Added " +IntToString (nWIS) + " large virtual moonstones");
        }
      }

      else if (GetItemPropertyType(iprop) == ITEM_PROPERTY_SKILL_BONUS)
      {

        if (GetItemPropertySubType(iprop) == SKILL_CONCENTRATION)
        {
          float fCONC = IntToFloat(GetItemPropertyCostTableValue(iprop))/3;
          int nCONC = FloatToInt(fCONC);
          nMooSml += nCONC;
          Trace(GEMCRAFT, "Added " +IntToString (nCONC) + " small virtual moonstones");
        }

        else if (GetItemPropertySubType(iprop) == SKILL_DISCIPLINE)
        {
          float fDISC = IntToFloat(GetItemPropertyCostTableValue(iprop))/3;
          int nDISC = FloatToInt(fDISC);
          nDiaSml += nDISC;
          Trace(GEMCRAFT, "Added " +IntToString (nDISC) + " small virtual diamonds");
        }

        else if (GetItemPropertySubType(iprop) == SKILL_HEAL)
        {
          float fHEAL = IntToFloat(GetItemPropertyCostTableValue(iprop))/3;
          int nHEAL = FloatToInt(fHEAL);
          nSkySml += nHEAL;
          Trace(GEMCRAFT, "Added " +IntToString (nHEAL) + " small virtual skystones");
        }

        else if (GetItemPropertySubType(iprop) == SKILL_HIDE)
        {
          float fHIDE = IntToFloat(GetItemPropertyCostTableValue(iprop))/3;
          int nHIDE = FloatToInt(fHIDE);
          nDarSml += nHIDE;
          Trace(GEMCRAFT, "Added " +IntToString (nHIDE) + " small virtual darkstones");
        }

        else if (GetItemPropertySubType(iprop) == SKILL_SEARCH)
        {
          float fSEAR = IntToFloat(GetItemPropertyCostTableValue(iprop))/3;
          int nSEAR = FloatToInt(fSEAR);
          nObsSml += nSEAR;
          Trace(GEMCRAFT, "Added " +IntToString (nSEAR) + " small virtual obsidians");
        }

        else if (GetItemPropertySubType(iprop) == SKILL_SPELLCRAFT)
        {
          float fSPEL = IntToFloat(GetItemPropertyCostTableValue(iprop))/3;
          int nSPEL = FloatToInt(fSPEL);
          nStaSml += nSPEL;
          Trace(GEMCRAFT, "Added " +IntToString (nSPEL) + " small virtual skystones");
        }

        else if (GetItemPropertySubType(iprop) == SKILL_SPOT)
        {
          float fSPOT = IntToFloat(GetItemPropertyCostTableValue(iprop))/3;
          int nSPOT = FloatToInt(fSPOT);
          nSunSml += nSPOT;
          Trace(GEMCRAFT, "Added " +IntToString (nSPOT) + " small virtual sunstones");
        }
      }

      //The first property has been counted

      RemoveItemProperty(oItem, iprop);

      //And removed

      //Now count the next one

      iprop = GetNextItemProperty(oItem);

    }

    //Now everything should have been counted on that item

    nBaseItemFound = 1;

    //So we never do this again

    oBase = oItem;

    //So when we come to put the properties back on, we do it to this item

  }

  oItem = GetNextItemInInventory();
  }

  //Now all the items have been counted. Check if there are too many gems

  //Variable to define how many
  int nGems = nDiaLrg + nDiaSml + nSunLrg +nSunSml + nMooLrg + nMooSml +
  nSkyLrg + nSkySml + nDarLrg + nDarSml + nStaLrg + nStaSml + nObsLrg +
  nObsSml;

  if(nHaveBase == 0)
  {
    nNoBases =1;
  }

  //Need to return error messages if the various error variables are triggered

  //Say who to send it to

  object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);

  //Note if there has been an error

  int nError = 0;

  //If we have more than one base
  if ((nTooManyBases == 1) && (nJunk == 0))
  {
    SendMessageToPC(oPC, "You have put in too many socketted items. "
    + "There should only be 1.");
    nError = 1;
  }

  //If we have no bases at the end, set this to 1, otherwise 0
  if((nNoBases == 1) && (nJunk == 0))
  {
    SendMessageToPC(oPC, "You have put in no socketted items. "
    + "There should be 1.");
    nError = 1;
  }


  //If there is anything else, or they closed it without putting anything in,
  //set this to 1, otherwise 0

  if(nJunk == 1)
  {
    SendMessageToPC(oPC, "You have put in an item which is not a"
    + " a socketted item. Please put in socketted items.");
    nError = 1;
  }

  if(nError == 0)
  {
    Trace(GEMCRAFT, "You have an acceptable number of gems, proceed!");

    while(nDiaLrg > 0)
    {
      CreateItemOnObject("ca_gemdialrg", OBJECT_SELF);
      nDiaLrg--;
    }

    while(nSunLrg > 0)
    {
      CreateItemOnObject("ca_gemsunlrg", OBJECT_SELF);
      nSunLrg--;
    }

    while(nMooLrg > 0)
    {
      CreateItemOnObject("ca_gemmoolrg", OBJECT_SELF);
      nMooLrg--;
    }

    while(nSkyLrg > 0)
    {
      CreateItemOnObject("ca_gemskylrg", OBJECT_SELF);
      nSkyLrg--;
    }

    while(nDarLrg > 0)
    {
      CreateItemOnObject("ca_gemdarlrg", OBJECT_SELF);
      nDarLrg--;
    }

    while(nStaLrg > 0)
    {
      CreateItemOnObject("ca_gemstalrg", OBJECT_SELF);
      nStaLrg--;
    }

    while(nObsLrg > 0)
    {
      CreateItemOnObject("ca_gemobslrg", OBJECT_SELF);
      nObsLrg--;
    }

    while(nDiaSml > 0)
    {
      CreateItemOnObject("ca_gemdiasml", OBJECT_SELF);
      nDiaSml--;
    }

    while(nSunSml > 0)
    {
      CreateItemOnObject("ca_gemsunsml", OBJECT_SELF);
      nSunSml--;
    }

    while(nMooSml > 0)
    {
      CreateItemOnObject("ca_gemmoosml", OBJECT_SELF);
      nMooSml--;
    }

    while(nSkySml > 0)
    {
      CreateItemOnObject("ca_gemskysml", OBJECT_SELF);
      nSkySml--;
    }

    while(nDarSml > 0)
    {
      CreateItemOnObject("ca_gemdarsml", OBJECT_SELF);
      nDarSml--;
    }

    while(nStaSml > 0)
    {
      CreateItemOnObject("ca_gemstasml", OBJECT_SELF);
      nStaSml--;
    }

    while(nObsSml > 0)
    {
      CreateItemOnObject("ca_gemobssml", OBJECT_SELF);
      nObsSml--;
    }

    //The item should now be done!
    //Send a lovely fluffy message to the PC saying so

    SendMessageToPC(oPC, "You have carefully removed the gems.");

  }

}
