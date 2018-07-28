/*
  Persistent People Script

  Used for mercenaries and quest NPCs to ensure that they are respawned if the
  server resets.

  Uses a database table - pwpeopledata

  Works by waypoint. Each waypoint tag contains a list of NPC tags of the NPCs
  present at that waypoint.

*/
#include "inc_log"
#include "inc_database"
#include "pg_lists_i"
const string P_PEOPLE  = "PERSISTENT_PEOPLE"; // for logging
const string PEOPLE_DB = "pwpeopledata";
const string NPC_TAG_LIST = "npc_tag_list";

// Adds an NPC to the list of NPCs set up on restart.
void AddPersistentPerson(object oWP, string sNPCTag, int bAddIfAlreadyThere=TRUE);

// Removes an NPC from the list of NPCs set up on restart.
void RemovePersistentPerson(object oWP, string sNPCTag);

// Sets up all the persistent people in the database. Call in onmodload.
void SetUpPersistentPeople();

// Utility method to construct the database variable name.
string GetWPIdentifier(object oWP)
{
  return (GetName(oWP) + "__" + GetTag(oWP));
}

// Helper function to split the tag list into an array. A tag list is of the
// form :tag::tag::tag::tag::tag:...
void ParseNPCTagList(string sTagList)
{
  Trace(P_PEOPLE, "Parsing tag list.");
  DeleteList(NPC_TAG_LIST, OBJECT_SELF);

  int nIndex = FindSubString(sTagList, "::");

  if (nIndex == -1)
  {
    // Trim the leading and trailing commas.
    sTagList = GetStringLeft(sTagList, GetStringLength(sTagList) -1);
    sTagList = GetStringRight(sTagList, GetStringLength(sTagList) -1);
    AddStringElement(sTagList, NPC_TAG_LIST, OBJECT_SELF);
  }
  else
  {
    while (sTagList != "")
    {
      Trace(P_PEOPLE, "Tag list currently: " + sTagList);
      string sValue = GetStringLeft(sTagList, nIndex);
      // Trim the leading ':'
      sValue = GetStringRight(sValue, GetStringLength(sValue) -1);
      AddStringElement(sValue, NPC_TAG_LIST, OBJECT_SELF);
      // Get the length of the rest of the tag list.
      int nRest = GetStringLength(sTagList) - GetStringLength(sValue) - 2;
      // Trim the tag list and set up to extract the next value.
      sTagList = GetStringRight(sTagList, nRest);
      nIndex = FindSubString(sTagList, "::");
      // If we're on the last entry now, we won't have any more ::'s. So use the
      // whole remaining string, which will look like ':tag:', less the last
      // colon.
      if (nIndex == -1) nIndex = GetStringLength(sTagList) - 1;
    }
  }
}

void AddPersistentPerson(object oWP, string sNPCTag, int bAddIfAlreadyThere=TRUE)
{
  Trace(P_PEOPLE, "Adding "+sNPCTag+" to "+GetName(oWP));
  string sWaypointNPCs = GetPersistentString(OBJECT_INVALID, GetWPIdentifier(oWP), PEOPLE_DB);

  if (bAddIfAlreadyThere || (FindSubString(sWaypointNPCs, ":"+sNPCTag+":") == -1))
  {
    Trace(P_PEOPLE, "NPC isn't already in list, or we want to add them anyway.");
    sWaypointNPCs += ":"+sNPCTag+":";

    SetPersistentString(OBJECT_INVALID, GetWPIdentifier(oWP), sWaypointNPCs, 0, PEOPLE_DB);
  }
}

void RemovePersistentPerson(object oWP, string sNPCTag)
{
  Trace(P_PEOPLE, "Removing "+sNPCTag+" from "+GetWPIdentifier(oWP));
  string sWaypointNPCs = GetPersistentString(OBJECT_INVALID, GetWPIdentifier(oWP), PEOPLE_DB);

  // FindSubString ("string", "string") returns -1 not 0. So working around this
  // by looking for the tag.
  int nIndex = FindSubString(sWaypointNPCs, sNPCTag);
  Trace(P_PEOPLE, "Waypoint's NPCs: "+sWaypointNPCs+", looking for "+sNPCTag+
                  ", index: "+IntToString(nIndex));

  if (nIndex > -1)
  {
    // Cut out the tag we want to remove by taking the bit before it and the
    // bit after and sticking them together.
    string sStringLeft = GetStringLeft(sWaypointNPCs, nIndex - 1);
    int nRightLength = GetStringLength(sWaypointNPCs)-nIndex-GetStringLength(sNPCTag)-2;
    string sStringRight = GetStringRight(sWaypointNPCs, nRightLength);

    SetPersistentString(OBJECT_INVALID, GetWPIdentifier(oWP), sStringLeft+sStringRight, 0, PEOPLE_DB);
  }
  else
  {
    Trace(P_PEOPLE, "Didn't find NPC. Has this method been called wrongly?");
  }
}

void SetUpPersistentPeople()
{
  Trace(P_PEOPLE, "Setting up persistent people.");

  // Each time we get a row, we're going to add "and name <>'currentname'" to
  // it, ensuring that we get a new row each time.
  string sSQL = "SELECT name FROM "+PEOPLE_DB+" WHERE name<>'' ";

  while (TRUE)
  {
    Trace(P_PEOPLE, "Getting next set of NPCs to spawn.");
    string sWaypointIdentifier = "";
    string sSQLToExecute =  sSQL + "LIMIT 1";
    SQLExecDirect(sSQLToExecute);

    if (SQLFetch() == SQL_SUCCESS)
    {
      // The waypoint identifier is in the form 'name__tag'. Get it and parse
      // it.
      sWaypointIdentifier = SQLGetData(1);

      if (sWaypointIdentifier == "") break; // we're done.

      int n__index = FindSubString(sWaypointIdentifier, "__");
      string sWaypointName = GetStringLeft(sWaypointIdentifier, n__index);
      int nWIRightLength   = GetStringLength(sWaypointIdentifier) - n__index - 2;
      string sWaypointTag  = GetStringRight(sWaypointIdentifier, nWIRightLength);

      // Find the waypoint whose name matches the one we have. This will have a
      // unique name/tag combo, but may not have a unique name or tag.
      int nCount = 0;
      object oWP = GetObjectByTag(sWaypointTag, nCount);

      while (GetIsObjectValid(oWP))
      {
        if (GetName(oWP) == sWaypointName)
        {
          Trace(P_PEOPLE, "Found waypoint!");
          break;
        }

        nCount++;
        oWP = GetObjectByTag(sWaypointTag, nCount);
      }

      string sNPCTags = GetPersistentString(OBJECT_INVALID, sWaypointIdentifier, PEOPLE_DB);

      Trace(P_PEOPLE, "Got list of NPCs: " + sNPCTags);
      ParseNPCTagList(sNPCTags);

      int iCount = 0;
      string sNPCTag = GetStringElement(iCount, NPC_TAG_LIST, OBJECT_SELF);

      while (sNPCTag != "")
      {
        Trace(P_PEOPLE, "Creating NPC: " + sNPCTag);
        object oNPC = CreateObject(OBJECT_TYPE_CREATURE, sNPCTag, GetLocation(oWP));
		
        SetLocalObject(oNPC, "HOME_WP", oWP);

        iCount++;
        sNPCTag = GetStringElement(iCount, NPC_TAG_LIST, OBJECT_SELF);
      }

      DeletePersistentVariable(OBJECT_INVALID, sWaypointTag, PEOPLE_DB);
    }
    else
    {
      Trace(P_PEOPLE, "SQL query failed: " + sSQL);
      break;
    }

    sSQL += "AND name<>'"+sWaypointIdentifier+"' ";
  }
}
