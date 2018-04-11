/*
  Name: inc_crime
  Author: Mithreas
  Date: 9 Sep 05
  Version: 1.3

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

                Need wanted token items to exist with the tags defined below
                (wanted1, wanted2, wanted3 etc). The blueprints names must match
                the tags.

  Update 9 Sep 05 - NPCs now store their faction information in a local int.
  If need be, we can include a method to reset their faction information, to
  be called after they change faction.

*/
#include "inc_log" // uses BOUNTY string below.
/*
  Nation constants. If you add to this, you will have to update the list of
  wanted tokens as well (and probably the list of factions... and some other
  stuff if you add factions :)).
*/
const int NATION_INVALID           = 0;
const int NATION_DEFAULT           = 1; // Imperial
const int NATION_DRANNIS           = 2;
const int NATION_ERENIA            = 3;
const int NATION_RENERRIN          = 4;
const int NATION_SHADOW            = 5;

const int NUM_NATIONS              = 6;

/* Tags for nation wanted tokens are root + nation number. */

const string WANTED_TOKEN_ROOT        = "obj_wanted";

/*
  Faction constants. Note the standard faction values:
    Hostile: 0
    Commoner: 1
    Merchant: 2
    Defender: 3

    Note - if you update this list, UPDATE THE CheckFactionNation AND
    GetIsDefenderFaction METHODS TOO! :)
*/
const string FACTION = "faction";

const int FACTION_DRANNIS_COMMONER     = 4;
const int FACTION_DRANNIS_DEFENDER     = 5;
const int FACTION_ERENIA_COMMONER      = 6;
const int FACTION_ERENIA_DEFENDER      = 7;
const int FACTION_RENERRIN_COMMONER    = 8;
const int FACTION_RENERRIN_DEFENDER    = 9;
const int FACTION_SHADOW_COMMONER      = 10;
const int FACTION_SHADOW_DEFENDER      = 11;
const int FACTION_QUEST                = 12;

const int FACTION_DRANNIS_MERCS        = 13;
const int FACTION_ERENIA_MERCS         = 14;
const int FACTION_RENERRIN_MERCS       = 15;
const int FACTION_SHADOW_MERCS         = 16;
const int FACTION_ANIMAL               = 17;
const int FACTION_UNALIGNED_MERCS      = 18;

const int NUM_FACTIONS                 = 19;

/* Bounty values for crimes. */

const int FINE_MURDER       = 2000;
const int FINE_ASSAULT      = 200;
const int FINE_THEFT        = 100; // plus the value of the item(s) stolen.
const int FINE_DISOBEDIENCE = 50;

const int BOUNTY_THRESHOLD = 2999;

/* Name of the bounty variable. */

const string BOUNTY = "BOUNTY";

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
int CheckFactionNation(object oNPC, int nCountMercenaries = FALSE);

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
/* End prototypes. */

/*
  Gets the faction a creature is assigned to. This isn't provided as a standard
  method, and so is really nasty to get working.

  Now made more efficient by storing faction information in a local int.
*/
int GetFaction(object oCreature)
{
  Trace(BOUNTY, "GetFaction called");
  int nFaction = GetLocalInt(oCreature, FACTION);

  if (nFaction == 0)
  {
    int ii;
    for (ii = 0; ii < NUM_FACTIONS; ii++)
    {
      object oFactionExample = GetObjectByTag("factionexample" +
                                              IntToString(ii));

      if (oFactionExample != OBJECT_INVALID)
      {
        Trace(BOUNTY, "Got factionexample for faction " + IntToString(ii));
        object oFaction = GetFirstFactionMember(oFactionExample, 0);
        Trace(BOUNTY, ObjectToString(OBJECT_INVALID) + " " + ObjectToString(oFaction));
        while(GetIsObjectValid(oFaction))
        {
          Trace(BOUNTY, "Got faction member.");
          if (oCreature == oFaction)
          {
            Trace(BOUNTY, "Found faction of " + GetName(oCreature));
            nFaction = ii;

            // Save the value we've found to prevent us recalculating every
            // time the NPC sees a PC (!). Note that if we store 0 we won't
            // be able to distinguish hostiles from NPCs who haven't set their
            // value. So instead set a value of -1 for hostile.
            if (nFaction == 0)
            {
              Trace(BOUNTY, "Hostile, so setting value of -1 not 0");
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
    Trace(BOUNTY, "Hostile, so correcting value from -1 to 0");
    nFaction = 0;
  }

  Trace(BOUNTY, "Returning faction: " + IntToString(nFaction));
  return nFaction;
}

/*
  Checks whether the PC has a Wanted token of the nation in question.
  Returns 1 if they do, 0 if they don't.
*/
int CheckWantedToken(int nNation, object oPC)
{
  Trace(BOUNTY, "CheckWantedToken called");
  object oWantedToken = GetItemPossessedBy(oPC,
                                      WANTED_TOKEN_ROOT + IntToString(nNation));

  if (oWantedToken == OBJECT_INVALID)
  {
    Trace(BOUNTY, "CheckWantedToken returning 0.");
    return 0;
  }
  else
  {
    Trace(BOUNTY, "CheckWantedToken returning 1.");
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
  Trace(BOUNTY, "AddToBounty called");
  object oWantedToken = GetItemPossessedBy(oPC,
                                      WANTED_TOKEN_ROOT + IntToString(nNation));

  if (oWantedToken == OBJECT_INVALID)
  {
    Trace(BOUNTY, "Creating Wanted token on PC");
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
  Trace(BOUNTY, "RemoveBountyToken called");
  object oWantedToken = GetItemPossessedBy(oPC,
                                      WANTED_TOKEN_ROOT + IntToString(nNation));

  if (oWantedToken != OBJECT_INVALID)
  {
    // It appears that using while here can loop, because the DestroyObject
    // command executes once the script ends. Damn. So we only delete one
    // object.
    DestroyObject(oWantedToken);
    Trace(BOUNTY, "Destroyed token.");
  }
}

/*
  Checks whether the NPC's faction is associated with a bounty token (i.e. they
  are from a merchant, defender or civilian faction in a nation using this
  system of law). If so, returns the nNation value needed to pass into the other
  common methods.
*/
int CheckFactionNation(object oNPC, int nCountMercenaries = FALSE)
{
  Trace(BOUNTY, "CheckFactionNation called.");
  int nNation  = NATION_INVALID;
  int nFaction = GetFaction(oNPC);

  switch (nFaction)
  {
     case STANDARD_FACTION_COMMONER:
     case STANDARD_FACTION_MERCHANT:
     case STANDARD_FACTION_DEFENDER:
     {
       nNation = NATION_DEFAULT;
       break;
     }
     case FACTION_DRANNIS_COMMONER:
     case FACTION_DRANNIS_DEFENDER:
     {
       nNation = NATION_DRANNIS;
       break;
     }
     case FACTION_ERENIA_COMMONER:
     case FACTION_ERENIA_DEFENDER:
     {
       nNation = NATION_ERENIA;
       break;
     }
     case FACTION_RENERRIN_COMMONER:
     case FACTION_RENERRIN_DEFENDER:
     {
       nNation = NATION_RENERRIN;
       break;
     }
     case FACTION_SHADOW_COMMONER:
     case FACTION_SHADOW_DEFENDER:
     {
       nNation = NATION_SHADOW;
       break;
     }
     default:
     {
       nNation = NATION_INVALID;
       break;
     }
  }

  if (nCountMercenaries && (nNation == NATION_INVALID))
  {
    switch (nFaction)
    {
      case FACTION_DRANNIS_MERCS:
      {
        nNation = NATION_DRANNIS;
        break;
      }
      case FACTION_ERENIA_MERCS:
      {
        nNation = NATION_ERENIA;
        break;
      }
      case FACTION_RENERRIN_MERCS:
      {
        nNation = NATION_RENERRIN;
        break;
      }
      case FACTION_SHADOW_MERCS:
      {
        nNation = NATION_SHADOW;
        break;
      }
    }
  }

  Trace(BOUNTY, "CheckFactionNation returning: " + IntToString(nNation));
  return nNation;
}

/*
  Is this NPC a member of a defender faction?
*/
int GetIsDefender(object oNPC)
{
  Trace(BOUNTY, "GetIsDefender called");
  int nFaction = GetFaction(oNPC);
  switch (nFaction)
  {
    case STANDARD_FACTION_DEFENDER:
    case FACTION_DRANNIS_DEFENDER:
    case FACTION_ERENIA_DEFENDER:
    case FACTION_RENERRIN_DEFENDER:
    case FACTION_SHADOW_DEFENDER:
      Trace(BOUNTY, "GetIsDefender returning 1");
      return 1;
  }

  Trace(BOUNTY, "GetIsDefender returning 0");
  return 0;
}

/*
  Get the price on the PC's head in nNation.
*/
int GetBounty(int nNation, object oPC)
{
  Trace(BOUNTY, "GetBounty called");
  int nBounty = 0;
  object oWantedToken = GetItemPossessedBy(oPC,
                                      WANTED_TOKEN_ROOT + IntToString(nNation));

  if (oWantedToken != OBJECT_INVALID)
  {
    nBounty = GetLocalInt(oWantedToken, BOUNTY);
  }

  Trace(BOUNTY, "GetBounty returning " + IntToString(nBounty));
  return nBounty;
}

/*
  Marks all items as stolen so guards can confiscate them.
*/
void MarkAllItemsAsStolen(object oContainer)
{
  Trace(BOUNTY, "Marking all objects in chest as stolen: "+GetName(oContainer));
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
  Trace(BOUNTY, "Checking whether "+GetName(oNPC)+" can see "+GetName(oPC));
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
      Trace(BOUNTY, "NPC can see PC.");
      return TRUE;
    }
  }

  return FALSE;
}
