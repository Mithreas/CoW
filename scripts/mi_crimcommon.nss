/*
  Name: mi_crimcommon
  Author: Mithreas
  Date: 9 Sep 05
  Version: 1.4

  Description: This script provides a set of common functions to implement
               automatic law enforcement in a module/PW. It requires a set of
               token items in the mod, with the tags listed below, one per
               nation. Update this script with the nations in the world to
               update the law enforcement system.

  Dependencies: Need example creatures from each faction (as Bioware didn't
                implement a simple GetFaction() method!). These should be
                creatures with the tag factionexampleN, where N is the number
                of the faction (see below). Make sure the creatures are
                assigned to the correct factions!

                @@@nb FOR FUTURE - GetFactionID in nwnx_funcs

                Need wanted token items to exist with the tags defined below
                (wanted1, wanted2, wanted3 etc). The blueprints names must match
                the tags.

  Update 9 Sep 05 - NPCs now store their faction information in a local int.
  If need be, we can include a method to reset their faction information, to
  be called after they change faction.

*/
#include "mi_log"
const string FACTIONS = "FACTIONS"; // for logging

/*
  Nation constants. If you add to this, you will have to update the list of
  wanted tokens as well (and probably the list of factions... and some other
  stuff if you add factions :)).
*/
const int NATION_INVALID     = 0;
const int NATION_DEFAULT     = 1;
const int NATION_BLACKSILVER = 2;
const int NATION_BYRNE       = 3;
const int NATION_DARKWOODS   = 4;
const int NATION_DRUID       = 5;
const int NATION_GLORWING    = 6;
const int NATION_RAVENSCALL  = 7;
const int NATION_X           = 8;
const int NATION_Y           = 9;
const int NATION_NEWLYRUN    = 10;

/* Tags for nation wanted tokens. */

const string WANTED_TOKEN_ROOT        = "obj_wanted";
const string WANTED_TOKEN_DEFAULT     = "obj_wanted1";
const string WANTED_TOKEN_BLACKSILVER = "obj_wanted2";
const string WANTED_TOKEN_BYRNE       = "obj_wanted3";
const string WANTED_TOKEN_DARKWOODS   = "obj_wanted4";
const string WANTED_TOKEN_DRUID       = "obj_wanted5";
const string WANTED_TOKEN_GLORWING    = "obj_wanted6";
const string WANTED_TOKEN_RAVENSCALL  = "obj_wanted7";
const string WANTED_TOKEN_X           = "obj_wanted8";
const string WANTED_TOKEN_Y           = "obj_wanted9";
const string WANTED_TOKEN_NEWLYRUN    = "obj_wanted10";

/*
  Faction constants. Note the standard faction values:
    Hostile: 0
    Commoner: 1
    Merchant: 2
    Defender: 3

    Note - if you update this list, UPDATE THE CheckFactionNation,
    GetIsDefenderFaction and GetDefaultReputation METHODS TOO! :)
*/
const string FACTION = "faction";

const int FACTION_BLACKSILVER_COMMONER = 4;
const int FACTION_BLACKSILVER_DEFENDER = 5;
const int FACTION_BYRNE_COMMONER   = 6;
const int FACTION_BYRNE_DEFENDER   = 7;
const int FACTION_DARKWOODS_COMMONER    = 8;
const int FACTION_DARKWOODS_DEFENDER    = 9;
const int FACTION_DRUID_COMMONER   = 10;
const int FACTION_DRUID_DEFENDER   = 11;
const int FACTION_GLORWING_COMMONER   = 12;
const int FACTION_GLORWING_DEFENDER   = 13;
const int FACTION_RAVENSCALL_COMMONER   = 14;
const int FACTION_RAVENSCALL_DEFENDER   = 15;
const int FACTION_X_COMMONER   = 16;
const int FACTION_X_DEFENDER   = 17;
const int FACTION_Y_COMMONER   = 18;
const int FACTION_Y_DEFENDER   = 19;
const int FACTION_NEWLYRUN_COMMONER = 20;
const int FACTION_NEWLYRUN_DEFENDER = 21;

const int NUM_FACTIONS               = 22;

/* Bounty values for crimes. */

const int FINE_MURDER       = 2000;
const int FINE_ASSAULT      = 200;
const int FINE_THEFT        = 100; // plus the value of the item(s) stolen.
const int FINE_DISOBEDIENCE = 50;

const int BOUNTY_THRESHOLD = 2999;

/* Name of the bounty variable. */

const string BOUNTY = "bounty";

/*
  Function prototypes. With nice block comments so they show up in the right
  menu panel when this file is included.
*/

//------------------------------------------------------------------------------
// Gets the faction a creature is assigned to. This isn't provided as a standard
// method, and so is really nasty to get working.
//
// Now made more efficient by storing faction information in a local int.
//------------------------------------------------------------------------------
int GetFaction(object oCreature);

//------------------------------------------------------------------------------
// Checks whether the PC has a Wanted token of the nation in question.
// Returns 1 if they do, 0 if they don't.
//------------------------------------------------------------------------------
int CheckWantedToken(int nNation, object oPC);

//------------------------------------------------------------------------------
// Checks for the existence of a Wanted token from nation nNation on PC oPC. If
// they don't have one, it creates one. It then gets the existing bounty value,
// and increments it by nBounty. Finally, it tells the target PC and the
// character using it what the character's new bounty is via a server message.
//------------------------------------------------------------------------------
void AddToBounty(int nNation, int nBounty, object oPC);

//------------------------------------------------------------------------------
// Removes the bounty token for nNation from oPC.
//------------------------------------------------------------------------------
void RemoveBountyToken(int nNation, object oPC);

//------------------------------------------------------------------------------
// Checks whether the NPC's faction is associated with a bounty token (i.e. they
// are from a merchant, defender or civilian faction in a nation using this
// system of law). If so, returns the nNation value needed to pass into the
// other methods in the criminal script set.
//------------------------------------------------------------------------------
int CheckFactionNation(object oNPC);

//------------------------------------------------------------------------------
// Is this NPC a member of a defender faction?
//------------------------------------------------------------------------------
int GetIsDefender(object oNPC);

//------------------------------------------------------------------------------
// Get the price on the PC's head in nNation.
//------------------------------------------------------------------------------
int GetBounty(int nNation, object oPC);

//------------------------------------------------------------------------------
// Mark all the items in a container's inventory as stolen, so the guards will
// confiscate them.
//------------------------------------------------------------------------------
void MarkAllItemsAsStolen(object oContainer);

//------------------------------------------------------------------------------
// Returns true if oNPC can see oPC.
//------------------------------------------------------------------------------
int GetCanSeeParticularPC(object oPC, object oNPC = OBJECT_SELF);

//------------------------------------------------------------------------------
// Returns the default faction rep for each faction.
//------------------------------------------------------------------------------
int GetDefaultReputation(int nFaction);

//------------------------------------------------------------------------------
// Restores a PC to default reputations with all other factions. Use for
// e.g. respawning PCs.
//------------------------------------------------------------------------------
void ResetCustomFactionReputations(object oPC);

//------------------------------------------------------------------------------
// Jails a PC in nNation's jail and lets them out again 15 minutes later.
//------------------------------------------------------------------------------
void JailPC(object oPC, int nNation);
/* End prototypes. */

/*
  Gets the faction a creature is assigned to. This isn't provided as a standard
  method, and so is really nasty to get working.

  Now made more efficient by storing faction information in a local int.
*/
int GetFaction(object oCreature)
{
  Trace(FACTIONS, "GetFaction called");
  int nFaction = GetLocalInt(oCreature, FACTION);

  if (nFaction == 0)
  {
    int ii;
    for (ii = 0; ii <= NUM_FACTIONS; ii++)
    {
      object oFactionExample = GetObjectByTag("factionexample" +
                                              IntToString(ii));

      if (oFactionExample != OBJECT_INVALID)
      {
        Trace(FACTIONS, "Got factionexample for faction " + IntToString(ii));
        object oFaction = GetFirstFactionMember(oFactionExample, 0);
        Trace(FACTIONS, ObjectToString(OBJECT_INVALID) + " " + ObjectToString(oFaction));
        while(GetIsObjectValid(oFaction))
        {
          Trace(FACTIONS, "Got faction member.");
          if (oCreature == oFaction)
          {
            Trace(FACTIONS, "Found faction of " + GetName(oCreature));
            nFaction = ii;

            // Save the value we've found to prevent us recalculating every
            // time the NPC sees a PC (!). Note that if we store 0 we won't
            // be able to distinguish hostiles from NPCs who haven't set their
            // value. So instead set a value of -1 for hostile.
            if (nFaction == 0)
            {
              Trace(FACTIONS, "Hostile, so setting value of -1 not 0");
              SetLocalInt(oCreature, FACTION, -1);
            }
            else
            {
              SetLocalInt(oCreature, FACTION, nFaction);
            }

            break;
          }
          oFaction = GetNextFactionMember(oFactionExample, 0);
        }
      }
    }
  }
  else if (nFaction == -1)
  {
    // Workaround for the fact that an absent variable will return 0.
    Trace(FACTIONS, "Hostile, so correcting value from -1 to 0");
    nFaction = 0;
  }

  Trace(FACTIONS, "Returning faction: " + IntToString(nFaction));
  return nFaction;
}

/*
  Checks whether the PC has a Wanted token of the nation in question.
  Returns 1 if they do, 0 if they don't.
*/
int CheckWantedToken(int nNation, object oPC)
{
  Trace(FACTIONS, "CheckWantedToken called");
  object oWantedToken = GetItemPossessedBy(oPC,
                                      WANTED_TOKEN_ROOT + IntToString(nNation));

  if (oWantedToken == OBJECT_INVALID)
  {
    Trace(FACTIONS, "CheckWantedToken returning 0.");
    return 0;
  }
  else
  {
    Trace(FACTIONS, "CheckWantedToken returning 1.");
    return 1;
  }
}

/*
  Checks for the existence of a Wanted token from nation nNation on PC oPC. If
  they don't have one, it creates one. It then gets the existing bounty value,
  and increments it by nBounty. Finally, it tells the target PC and the
  character using it what the character's new bounty is via a server message.
*/
void AddToBounty(int nNation, int nBounty, object oPC)
{
  Trace(FACTIONS, "AddToBounty called");
  object oWantedToken = GetItemPossessedBy(oPC,
                                      WANTED_TOKEN_ROOT + IntToString(nNation));

  if (oWantedToken == OBJECT_INVALID)
  {
    Trace(FACTIONS, "Creating Wanted token on PC");
    oWantedToken = CreateItemOnObject(WANTED_TOKEN_ROOT + IntToString(nNation),
                                      oPC);
  }

  int nCurrentBounty = GetLocalInt(oWantedToken, BOUNTY);
  nCurrentBounty = nCurrentBounty + nBounty;
  SetLocalInt(oWantedToken, BOUNTY, nCurrentBounty);
  SendMessageToPC(oPC, "Increased bounty by " + IntToString(nBounty) + " to " +
      IntToString(nCurrentBounty));

}

/*
  Removes the bounty token for nNation from oPC.
*/
void RemoveBountyToken(int nNation, object oPC)
{
  Trace(FACTIONS, "RemoveBountyToken called");
  object oWantedToken = GetItemPossessedBy(oPC,
                                      WANTED_TOKEN_ROOT + IntToString(nNation));

  if (oWantedToken != OBJECT_INVALID)
  {
    // It appears that using while here can loop, because the DestroyObject
    // command is asynchronous. Damn. So we only delete one object.
    DestroyObject(oWantedToken);
    Trace(FACTIONS, "Destroyed token.");
  }
}

/*
  Checks whether the NPC's faction is associated with a bounty token (i.e. they
  are from a merchant, defender or civilian faction in a nation using this
  system of law). If so, returns the nNation value needed to pass into the other
  common methods.
*/
int CheckFactionNation(object oNPC)
{
  Trace(FACTIONS, "CheckFactionNation called.");
  int nNation  = NATION_INVALID;
  int nFaction = GetFaction(oNPC);

  switch (nFaction)
  {
     case STANDARD_FACTION_COMMONER:
     case STANDARD_FACTION_MERCHANT:
     case STANDARD_FACTION_DEFENDER:
      nNation = NATION_DEFAULT;
      break;
     case FACTION_BLACKSILVER_COMMONER:
     case FACTION_BLACKSILVER_DEFENDER:
      nNation = NATION_BLACKSILVER;
      break;
     case FACTION_BYRNE_COMMONER:
     case FACTION_BYRNE_DEFENDER:
      nNation = NATION_BYRNE;
      break;
     case FACTION_DARKWOODS_COMMONER:
     case FACTION_DARKWOODS_DEFENDER:
      nNation = NATION_DARKWOODS;
      break;
     case FACTION_DRUID_COMMONER:
     case FACTION_DRUID_DEFENDER:
      nNation = NATION_DRUID;
      break;
     case FACTION_GLORWING_COMMONER:
     case FACTION_GLORWING_DEFENDER:
      nNation = NATION_GLORWING;
      break;
     case FACTION_RAVENSCALL_COMMONER:
     case FACTION_RAVENSCALL_DEFENDER:
      nNation = NATION_RAVENSCALL;
      break;
     case FACTION_X_COMMONER:
     case FACTION_X_DEFENDER:
      nNation = NATION_X;
      break;
     case FACTION_Y_COMMONER:
     case FACTION_Y_DEFENDER:
      nNation = NATION_Y;
      break;
     case FACTION_NEWLYRUN_COMMONER:
     case FACTION_NEWLYRUN_DEFENDER:
       nNation = NATION_NEWLYRUN;
       break;
  }

  Trace(FACTIONS, "CheckFactionNation returning: " + IntToString(nNation));
  return nNation;
}

/*
  Is this NPC a member of a defender faction?
*/
int GetIsDefender(object oNPC)
{
  Trace(FACTIONS, "GetIsDefender called");
  int nFaction = GetFaction(oNPC);
  switch (nFaction)
  {
    case STANDARD_FACTION_DEFENDER:
    case FACTION_BLACKSILVER_DEFENDER:
    case FACTION_BYRNE_DEFENDER:
    case FACTION_DARKWOODS_DEFENDER:
    case FACTION_DRUID_DEFENDER:
    case FACTION_GLORWING_DEFENDER:
    case FACTION_RAVENSCALL_DEFENDER:
    case FACTION_X_DEFENDER:
    case FACTION_Y_DEFENDER:
    case FACTION_NEWLYRUN_DEFENDER:
      Trace(FACTIONS, "GetIsDefender returning 1");
      return 1;
  }

  Trace(FACTIONS, "GetIsDefender returning 0");
  return 0;
}

/*
  Get the price on the PC's head in nNation.
*/
int GetBounty(int nNation, object oPC)
{
  Trace(FACTIONS, "GetBounty called");
  int nBounty = 0;
  object oWantedToken = GetItemPossessedBy(oPC,
                                      WANTED_TOKEN_ROOT + IntToString(nNation));

  if (oWantedToken != OBJECT_INVALID)
  {
    nBounty = GetLocalInt(oWantedToken, BOUNTY);
  }

  Trace(FACTIONS, "GetBounty returning " + IntToString(nBounty));
  return nBounty;
}

/*
  Marks all items as stolen so guards can confiscate them.
*/
void MarkAllItemsAsStolen(object oContainer)
{
  Trace(FACTIONS, "Marking all objects in chest as stolen: "+GetName(oContainer));
  object oItem = GetFirstItemInInventory(oContainer);

  while (GetIsObjectValid(oItem))
  {
    SetStolenFlag(oItem, TRUE);

    oItem = GetNextItemInInventory(oContainer);
  }
}

/*
  Returns true if oNPC can see oPC.
*/
int GetCanSeeParticularPC(object oPC, object oNPC = OBJECT_SELF)
{
  Trace(FACTIONS, "Checking whether "+GetName(oNPC)+" can see "+GetName(oPC));
  int nCount = 1;
  object oPCSeen = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,
                                      PLAYER_CHAR_IS_PC,
                                      oNPC,
                                      nCount,
                                      CREATURE_TYPE_PERCEPTION,
                                      PERCEPTION_SEEN);

  while (GetIsObjectValid(oPCSeen))
  {
    if (oPCSeen == oPC)
    {
      Trace(FACTIONS, "NPC can see PC.");
      return TRUE;
    }
  }

  return FALSE;
}

int GetDefaultReputation(int nFaction)
{
  int nRetVal = 20;  // default hostile.
  switch (nFaction)
  {
  case STANDARD_FACTION_COMMONER:
  case STANDARD_FACTION_MERCHANT:
  case STANDARD_FACTION_DEFENDER:
  case FACTION_BLACKSILVER_COMMONER:
  case FACTION_BLACKSILVER_DEFENDER:
  case FACTION_BYRNE_COMMONER:
  case FACTION_BYRNE_DEFENDER:
  case FACTION_DARKWOODS_COMMONER:
  case FACTION_DARKWOODS_DEFENDER:
  case FACTION_DRUID_COMMONER:
  case FACTION_DRUID_DEFENDER:
  case FACTION_GLORWING_COMMONER:
  case FACTION_GLORWING_DEFENDER:
  case FACTION_RAVENSCALL_COMMONER:
  case FACTION_RAVENSCALL_DEFENDER:
  case FACTION_X_COMMONER:
  case FACTION_X_DEFENDER:
  case FACTION_Y_COMMONER:
  case FACTION_Y_DEFENDER:
  case FACTION_NEWLYRUN_COMMONER:
  case FACTION_NEWLYRUN_DEFENDER:
    nRetVal =  80; // friendly
  }

  return nRetVal;
}

void ResetCustomFactionReputations(object oPC)
{
  int nFaction = 4; // start at the first custom faction
  for (nFaction = 4; nFaction < NUM_FACTIONS; nFaction++)
  {
     object oFactionExample = GetObjectByTag("factionexample" +
                                              IntToString(nFaction));

     if (GetIsObjectValid(oFactionExample))
     {
       // Get current reputation
       int nRep = GetReputation(oFactionExample, oPC);
       int nIdeal = GetDefaultReputation(nFaction);
       int nDifference = nIdeal - nRep; // e.g if currently 80 and default is 20,
                                        // we want to adjust by -60.

       AdjustReputation(oPC, oFactionExample, nDifference);
     }
  }
}

void JailPC(object oPC, int nNation)
{
  string sNation = IntToString(nNation);
  object oWP = GetObjectByTag("jail" + sNation);
  object oExitWP = GetObjectByTag("jailexit" + sNation);
  AssignCommand(oPC, ClearAllActions());
  AssignCommand(oPC, JumpToLocation(GetLocation(oWP)));

  // Let them out after 15 minutes.
  SendMessageToPC(oPC, "((You have been jailed. You will automatically "
          + "be released after 15 (RL) minutes. Do not log out, or you won't "
          + "be released at all! Your weapons have not been removed in case the "
          + "server crashes, but please RP that they have been.))");
  DelayCommand(900.0, AssignCommand(oPC, JumpToLocation(GetLocation(oExitWP))));
}
