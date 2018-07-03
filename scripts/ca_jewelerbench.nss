/////////////////////////////////////////////////////////
//
//  Gem Stone Socketing System by Cara
//
//  Name:  ca_jewelwebench
//
//  Desc:  Creating an item based on what was put in
//
//  Author: Cara 16Apr06
//
/////////////////////////////////////////////////////////

//Include snazzy logging script to see where things are going wrong

#include "inc_log"

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

  //Variable to set to how many you're allowed based on base item type

  int nMaxGem = 0;

  //Variable to check there's only one base item in there and cause an error
  //message if there are more than one

  int nHaveBase = 0;

  //Set variables to see if various things that can go wrong have

  //If we have more than one base, set this to 1, otherwise 0
  int nTooManyBases = 0;

  //If we have no bases at the end, set this to 1, otherwise 0
  int nNoBases = 0;

  //If we're trying to add too many gems, set this to 1, otherwise 0
  int nTooManyGems = 0;

  //If we're not adding any gems, set this to 1, otherwise 0
  int nNoGems = 0;

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
  //look at the first 6 letters of this, check that they belong to one of the
  //component items for gemcrafting - == means check if this equals one of
  //the tags I go on to describe, which are those of the subcomponents.
  //If that's a large diamond
  if(sTag == "ca_gemdialrg")
  //Add 1 to the large diamond count
  {
    nDiaLrg++; //the same as nDiaLrg = nDiaLrg + 1;
    Trace(GEMCRAFT, "Added large diamond");
    //This is the text that will appear in the log file
  }

  //Repeat many, many times for all the gem types

  else if(sTag == "ca_gemdiasml")
  {
    nDiaSml++;
    Trace(GEMCRAFT, "Added small diamond");
  }

  else if(sTag == "ca_gemsunlrg")
  {
    nSunLrg++;
    Trace(GEMCRAFT, "Added large sunstone");
  }

  else if(sTag == "ca_gemsunsml")
  {
    nSunSml++;
    Trace(GEMCRAFT, "Added small sunstone");
  }

  else if(sTag == "ca_gemmoolrg")
  {
    nMooLrg++;
    Trace(GEMCRAFT, "Added large moonstone");
  }

  else if(sTag == "ca_gemmoosml")
  {
    nMooSml++;
    Trace(GEMCRAFT, "Added small moonstone");
  }

  else if(sTag == "ca_gemskylrg")
  {
    nSkyLrg++;
    Trace(GEMCRAFT, "Added large skystone");
  }

  else if(sTag == "ca_gemskysml")
  {
    nSkySml++;
    Trace(GEMCRAFT, "Added small skystone");
  }

  else if(sTag == "ca_gemdarlrg")
  {
    nDarLrg++;
    Trace(GEMCRAFT, "Added large darkstone");
  }

  else if(sTag == "ca_gemdarsml")
  {
    nDarSml++;
    Trace(GEMCRAFT, "Added small darkstone");
  }

  else if(sTag == "ca_gemstalrg")
  {
    nStaLrg++;
    Trace(GEMCRAFT, "Added large starstone");
  }

  else if(sTag == "ca_gemstasml")
  {
    nStaSml++;
    Trace(GEMCRAFT, "Added small starstone");
  }

  else if(sTag == "ca_gemobslrg")
  {
    nObsLrg++;
    Trace(GEMCRAFT, "Added large obsidian");
  }

  else if(sTag == "ca_gemobssml")
  {
    nObsSml++;
    Trace(GEMCRAFT, "Added small obsidian");
  }

  //Now we're done seeing if they put a gem in and counting it
  //See if it's one of the allowed base item types
  //If so, count the number of gem slots it has and say we've found a base

  else if(GetStringLeft(sTag, 4) == "ca_1")
  {
    nMaxGem = 1;
    nHaveBase++;
    Trace(GEMCRAFT, "Added copper base");
	oBase = oItem;
  }

  else if(GetStringLeft(sTag, 4) == "ca_2")
  {
    nMaxGem = 2;
    nHaveBase++;
    Trace(GEMCRAFT, "Added bronze base");
	oBase = oItem;
  }

  else if(GetStringLeft(sTag, 4) == "ca_3")
  {
    nMaxGem = 3;
    nHaveBase++;
    Trace(GEMCRAFT, "Added iron base");
	oBase = oItem;
  }

  else if(GetStringLeft(sTag, 4) == "ca_4")
  {
    nMaxGem = 4;
    nHaveBase++;
    Trace(GEMCRAFT, "Added silver base");
	oBase = oItem;
  }

  else if(GetStringLeft(sTag, 4) == "ca_5")
  {
    nMaxGem = 5;
    nHaveBase++;
    Trace(GEMCRAFT, "Added gold base");
	oBase = oItem;
  }

  else if(GetStringLeft(sTag, 4) == "ca_6")
  {
    nMaxGem = 6;
    nHaveBase++;
    Trace(GEMCRAFT, "Added mithril base");
	oBase = oItem;
  }

  //If it's not tagged ca_ then we've found junk, stop and return
  //error message

  else if(GetStringLeft(sTag, 3) != "ca_")
  {
    nJunk = 1;
    Trace(GEMCRAFT, "You've found junk!");
    break;
  }

  //Check if we have too many bases, if so stop and return error message.

  if (nHaveBase > 1)
  {
    nTooManyBases = 1;
    Trace(GEMCRAFT, "You have too many bases!");
    break;
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

  nMaxGem -= GetLocalInt(oBase, "NUM_GEMS");
	
  if(nGems > nMaxGem)
  {
  nTooManyGems = 1;
  Trace(GEMCRAFT, "You have too many gems!");
  }

  if(nGems == 0)
  {
  nNoGems = 1;
  Trace(GEMCRAFT, "You have no gems!");
  }

  //Need to return error messages if the various error variables are triggered

  //Say who to send it to

  object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);

  //Note if there has been an error

  int nError = 0;

  //If we have more than one base
  if ((nTooManyBases == 1) && (nJunk == 0))
  {
    SendMessageToPC(oPC, "You have put in too many enhanceable items. "
    + "There should only be 1.");
    nError = 1;
  }

  //If we have no bases at the end, set this to 1, otherwise 0
  if((nNoBases == 1) && (nJunk == 0) && (nNoGems != 0))
  {
    SendMessageToPC(oPC, "You have put in no enhanceable items. "
    + "There should be 1.");
    nError = 1;
  }

  //If we're trying to add too many gems, set this to 1, otherwise 0
  if((nTooManyGems == 1) && (nHaveBase == 1) && (nJunk == 0))
  {
    SendMessageToPC(oPC, "You have put in too many gems. Take some out.");
    nError = 1;
  }

  //If we're not adding any gems, set this to 1, otherwise 0
  if((nNoGems == 1) && (nHaveBase == 1) && (nJunk == 0))
  {
    SendMessageToPC(oPC, "You have put in no gems. Put some in.");
    nError = 1;
  }

  //If there is anything else, or they closed it without putting anything in,
  //set this to 1, otherwise 0

  if(nJunk == 1)
  {
    SendMessageToPC(oPC, "You have put in an item which is not a"
    + " gem or enhanceable item. Please put in only gems and enhanceable items.");
    nError = 1;
  }

  if(nError == 0)
  {
    Trace(GEMCRAFT, "You have an acceptable number of gems, proceed!");

    if(nDiaLrg > 0)
    {
      AddItemProperty(DURATION_TYPE_PERMANENT,
      ItemPropertyACBonus(nDiaLrg), oBase);
      Trace(GEMCRAFT, "Added " +IntToString (nDiaLrg) + " to Universal saves");
	  SetDescription(oBase, GetDescription(oBase) + "\n\nA large clearstone occupies one socket.");
    }

    if(nSunLrg > 0)
    {
      AddItemProperty(DURATION_TYPE_PERMANENT,
      ItemPropertyAbilityBonus(ABILITY_STRENGTH, nSunLrg), oBase);
      Trace(GEMCRAFT, "Added " +IntToString (nSunLrg) + " to STR");
	  SetDescription(oBase, GetDescription(oBase) + "\n\nA large sunstone occupies one socket.");
    }

    if(nMooLrg > 0)
    {
      AddItemProperty(DURATION_TYPE_PERMANENT,
      ItemPropertyAbilityBonus(ABILITY_WISDOM, nMooLrg), oBase);
      Trace(GEMCRAFT, "Added " +IntToString (nMooLrg) + " to WIS");
	  SetDescription(oBase, GetDescription(oBase) + "\n\nA large moonstone occupies one socket.");
    }

    if(nSkyLrg > 0)
    {
      AddItemProperty(DURATION_TYPE_PERMANENT,
      ItemPropertyAbilityBonus(ABILITY_CONSTITUTION, nSkyLrg), oBase);
      Trace(GEMCRAFT, "Added " +IntToString (nSkyLrg) + " to CON");
	  SetDescription(oBase, GetDescription(oBase) + "\n\nA large skystone occupies one socket.");
    }

    if(nDarLrg > 0)
    {
      AddItemProperty(DURATION_TYPE_PERMANENT,
      ItemPropertyAbilityBonus(ABILITY_DEXTERITY, nDarLrg), oBase);
      Trace(GEMCRAFT, "Added " +IntToString (nDarLrg) + " to DEX");
	  SetDescription(oBase, GetDescription(oBase) + "\n\nA large nightstone occupies one socket.");
    }

    if(nStaLrg > 0)
    {
      AddItemProperty(DURATION_TYPE_PERMANENT,
      ItemPropertyAbilityBonus(ABILITY_CHARISMA, nStaLrg), oBase);
      Trace(GEMCRAFT, "Added " +IntToString (nStaLrg) + " to CHA");
	  SetDescription(oBase, GetDescription(oBase) + "\n\nA large starstone occupies one socket.");
    }

    if(nObsLrg > 0)
    {
      AddItemProperty(DURATION_TYPE_PERMANENT,
      ItemPropertyAbilityBonus(ABILITY_INTELLIGENCE, nObsLrg), oBase);
      Trace(GEMCRAFT, "Added " +IntToString (nObsLrg) + " to INT");
	  SetDescription(oBase, GetDescription(oBase) + "\n\nA large firestone occupies one socket.");
    }

    if(nDiaSml > 0)
    {
      AddItemProperty(DURATION_TYPE_PERMANENT,
      ItemPropertySkillBonus(SKILL_DISCIPLINE, 3*nDiaSml), oBase);
      Trace(GEMCRAFT, "Added " +IntToString (3*nDiaSml) + " to disc");
	  SetDescription(oBase, GetDescription(oBase) + "\n\nA small clearstone occupies one socket.");
    }

    if(nSunSml > 0)
    {
      AddItemProperty(DURATION_TYPE_PERMANENT,
      ItemPropertySkillBonus(SKILL_SPOT, 3*nSunSml), oBase);
      Trace(GEMCRAFT, "Added " +IntToString (3*nSunSml) + " to spot");
	  SetDescription(oBase, GetDescription(oBase) + "\n\nA small sunstone occupies one socket.");
    }

    if(nMooSml > 0)
    {
      AddItemProperty(DURATION_TYPE_PERMANENT,
      ItemPropertySkillBonus(SKILL_CONCENTRATION, 3*nMooSml), oBase);
      Trace(GEMCRAFT, "Added " +IntToString (3*nMooSml) + " to conc");
	  SetDescription(oBase, GetDescription(oBase) + "\n\nA small moonstone occupies one socket.");
    }

    if(nSkySml > 0)
    {
      AddItemProperty(DURATION_TYPE_PERMANENT,
      ItemPropertySkillBonus(SKILL_HEAL, 3*nSkySml), oBase);
      Trace(GEMCRAFT, "Added " +IntToString (3*nSkySml) + " to heal");
	  SetDescription(oBase, GetDescription(oBase) + "\n\nA small skystone occupies one socket.");
    }

    if(nDarSml > 0)
    {
      AddItemProperty(DURATION_TYPE_PERMANENT,
      ItemPropertySkillBonus(SKILL_HIDE, 3*nDarSml), oBase);
      Trace(GEMCRAFT, "Added " +IntToString (3*nDarSml) + " to hide");
	  SetDescription(oBase, GetDescription(oBase) + "\n\nA small nightstone occupies one socket.");
    }

    if(nStaSml > 0)
    {
      AddItemProperty(DURATION_TYPE_PERMANENT,
      ItemPropertySkillBonus(SKILL_SPELLCRAFT, 3*nStaSml), oBase);
      Trace(GEMCRAFT, "Added " +IntToString (3*nStaSml) + " to spell");
	  SetDescription(oBase, GetDescription(oBase) + "\n\nA small starstone occupies one socket.");
    }

    if(nObsSml > 0)
    {
      AddItemProperty(DURATION_TYPE_PERMANENT,
      ItemPropertySkillBonus(SKILL_SEARCH, 3*nObsSml), oBase);
      Trace(GEMCRAFT, "Added " +IntToString (3*nObsSml) + " to search");
	  SetDescription(oBase, GetDescription(oBase) + "\n\nA small firestone occupies one socket.");
    }

    //The item should now be done!
    //Send a lovely fluffy message to the PC saying so

    SendMessageToPC(oPC, "You have carefully set the gems.");

    //Delete the gems

    oItem = GetFirstItemInInventory();

    while(GetIsObjectValid(oItem))
    {
    string sTag = GetTag(oItem);
    if(sTag == "ca_gemdialrg")
    {
      DestroyObject(oItem);
    }

    else if(sTag == "ca_gemdiasml")
    {
      DestroyObject(oItem);
    }

    else if(sTag == "ca_gemsunlrg")
    {
      DestroyObject(oItem);
    }

    else if(sTag == "ca_gemsunsml")
    {
      DestroyObject(oItem);
    }

    else if(sTag == "ca_gemmoolrg")
    {
      DestroyObject(oItem);
    }

    else if(sTag == "ca_gemmoosml")
    {
      DestroyObject(oItem);
    }

    else if(sTag == "ca_gemskylrg")
    {
      DestroyObject(oItem);
    }

    else if(sTag == "ca_gemskysml")
    {
      DestroyObject(oItem);
    }

    else if(sTag == "ca_gemdarlrg")
    {
      DestroyObject(oItem);
    }

    else if(sTag == "ca_gemdarsml")
    {
      DestroyObject(oItem);
    }

    else if(sTag == "ca_gemstalrg")
    {
      DestroyObject(oItem);
    }

    else if(sTag == "ca_gemstasml")
    {
      DestroyObject(oItem);
    }

    else if(sTag == "ca_gemobslrg")
    {
      DestroyObject(oItem);
    }

    else if(sTag == "ca_gemobssml")
    {
      DestroyObject(oItem);
    }
    //If the item was a gemstone it is now destroyed
    oItem = GetNextItemInInventory();
    }
	
	// Store the number of gems set.
	nGems += GetLocalInt(oBase, "NUM_GEMS");
	SetLocalInt(oBase, "NUM_GEMS", nGems);
  }

}
