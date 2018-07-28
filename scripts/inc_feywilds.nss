/**
  Name: inc_feywilds
  Author: Mithreas
  Date: 10 June 2018
  Description:
 
  Library for dynamic path generation.
  - Each path is defined as a list of transition areas and a list of possible final areas.
  - Each path is entered from a trigger with fw_enter script and the following variables:
    - FW_PATH - path ID (string)
	- FW_INSTANCE - (int) that allows multiple paths to use the same pool of areas.
	- FW_CHANCE - (int) % chance that the 2nd and subsequent area transitions will end the path.
	- FW_STAGE - (int) 0 for the entry transition.
	- FW_EDGE - (string) - N/S/E/W for the side of the map this transition is on.
  - The entry trigger needs a unique tag and a waypoint with tag WP_(trigger tag).
  - Transition areas should have exit transitions in the N,S,E and W with accompanying
    waypoints.  Tags should be TRANS_N, TRANS_S etc. and WP_TRANS_N, WP_TRANS_S etc. OnClick script
	should be fw_enter.
  - The system will handle dynamically retagging all the transitions.  It will randomly
    pick one of the three not being used to enter as the exit, and the other two will be
	disabled.
  - Exit areas will be entered from the north, and need a trigger with fw_enter and WP as above.
    The tag of the entry area should be (areatag_N) and the WP should be (WP_areatag_N).
  - The first time each reset that anyone walks a particular path, the system will select,
    clone and stitch together copies of transition areas to form a complete path.
  - There will always be at least 1 transition area, then there is a FW_CHANCE% chance of each 
    new transition leading to the end.  So an average of (1+1/FW_CHANCE) areas per path. 
  - Once the path has been generated, it is "set" until the next reset.  
  - Since area tags will be reused, the fixture and dynamic placeable systems 
    should NOT be used with transition areas.  Similarly, portals should not be placed in 
	transition areas.
  - Encounters will be copied from the master area, whether using placed or Giga style.
	
*/
#include "inc_boss"
#include "inc_encounter"
#include "inc_log"
#include "inc_placeable"
#include "zzdlg_lists_inc"

// Path lists - FW_Init() sets these up to contain a list of area template resrefs.
const string FW_PATH_PFWF = "FW_PERENOR_FEYWILDS_FRINGE";
const string FW_PATH_PFWD = "FW_PERENOR_FEYWILDS_DEEP";
const string ENDS         = "_ENDINGS"; // Added to another list name for the endings.

const string FEYWILDS     = "FEYWILDS"; // for tracing. 

// Called internally to set up the system variables.  Edit this to add support for new
// paths or to add new areas to existing paths. 
void FW_Init();
// Called by a transition that doesn't yet have its destination set up.
void FW_GeneratePath(object oTrigger);

string GetRandomStringElement(string sList, object oHolder)
{
  return GetStringElement(Random(GetElementCount(sList, oHolder)), sList, oHolder);
}

void FW_Init()
{
  Trace(FEYWILDS, "Initialising paths.");
  // Set up the lists for each path.  Tag and resref needs to match (though case
  // differences are allowed).  Use the tag case for the lists.
  // This is not elegant, but means we can avoid looping through everything in the 
  // end area.
  object oMod = GetModule();
  DeleteList(FW_PATH_PFWF, oMod);
  AddStringElement("PerFeyDryad", FW_PATH_PFWF, oMod);  // Dryad grove
  AddStringElement("PerFeyRuins", FW_PATH_PFWF, oMod); // Annoyed pixies 
  AddStringElement("PerFeyLivFor", FW_PATH_PFWF, oMod);  // Living Forest
  AddStringElement("PerFeyWispWood", FW_PATH_PFWF, oMod);  // Wispering Woods
  AddStringElement("PerFeyWispWood2", FW_PATH_PFWF, oMod); // Wisps and dead people
  AddStringElement("PerFeyNymPool", FW_PATH_PFWF, oMod); // Riddling nymph
  AddStringElement("PerFeyMistWood", FW_PATH_PFWF, oMod);  // bear and friends.
  AddStringElement("PerFeyMistWood2", FW_PATH_PFWF, oMod);  // wolves
  AddStringElement("PerFeyMistWood3", FW_PATH_PFWF, oMod);  // Illusionary terrain
  //AddStringElement("xxx", FW_PATH_PFWF, oMod);  
  // Transitions:
  // Fairy ring.
  
  DeleteList(FW_PATH_PFWF + ENDS, oMod);
  // Endings: White stag. Weatherstone. Treehouse. 
  AddStringElement("PerFeyAbaGrove", FW_PATH_PFWF + ENDS, oMod); // Abandoned grove
  AddStringElement("PerFeyWhiStag", FW_PATH_PFWF + ENDS, oMod); // White Stag grove
  
  DeleteList(FW_PATH_PFWD, oMod);
  // Transitions: 
  // Satyr pipers.  Earth elemental mound. Trolls.
  // Satyr warcamp.  Medusa and snakes.
  AddStringElement("perfeydwetlands", FW_PATH_PFWD, oMod); // Water elementals
  AddStringElement("perfeydcanyon", FW_PATH_PFWD, oMod);   // Air elementals
  AddStringElement("perfeydmistwoods", FW_PATH_PFWD, oMod);   // Old bear
  AddStringElement("perfeydmistwo001", FW_PATH_PFWD, oMod);  // Giant Spiders
  AddStringElement("perfeyddreamscap", FW_PATH_PFWD, oMod);  // Emerald Dreamings
  AddStringElement("perfeyddreamsca2", FW_PATH_PFWD, oMod);  // Emerald Dreamings
  
  // Endings:
  // Stirge boss.  Fairy Queen.  Ysera. 
  DeleteList(FW_PATH_PFWD + ENDS, oMod);
  AddStringElement("perfeydlifetree", FW_PATH_PFWD + ENDS, oMod); // Tree of Life
  AddStringElement("perfeyddreamend", FW_PATH_PFWD + ENDS, oMod); // Ysera
}

void FW_GeneratePath(object oTrigger)
{
  string sPath = GetLocalString(oTrigger, "FW_PATH");
  
  // Check that we have initialised our lists.
  if (GetFirstStringElement(sPath, GetModule()) == "") FW_Init();
  
  int nInstance = GetLocalInt(oTrigger, "FW_INSTANCE");
  int nChance   = GetLocalInt(oTrigger, "FW_CHANCE");
  int nStage    = GetLocalInt(oTrigger, "FW_STAGE");
  string sEdge  = GetLocalString(oTrigger, "FW_EDGE");
  string sArea  = GetRandomStringElement(sPath, GetModule());
  
  Trace(FEYWILDS, "Setting up path for " + sPath + ", instance " + IntToString(nInstance) + ".  Next area: " + sArea);
  
  string sNextTag = sPath+IntToString(nInstance)+"_"+IntToString(++nStage);
  
  object oSourceArea = GetObjectByTag(sNextTag);
  object oDestArea   = CreateArea(sArea, GetStringLowerCase(sNextTag));
  string sEndArea    = "";
  
  if (!GetLocalInt(oSourceArea, "GS_ENABLED"))
  {
    gvd_LoadAreaVars(oSourceArea);

    gsENLoadArea(oSourceArea, FALSE);
    gsBOLoadArea(oSourceArea);
    gsPLLoadArea(oSourceArea);
    SetLocalInt(oSourceArea, "GS_ENABLED", TRUE);	
  }
  
  gsENCopyArea(oSourceArea, oDestArea);
  
  string sEnterBy = "TRANS_N";
  if (sEdge == "E") sEnterBy = "TRANS_W";
  else if (sEdge == "W") sEnterBy = "TRANS_E";
  else if (sEdge == "N") sEnterBy = "TRANS_S";
  
  string sLeaveBy = "";
  
  // Check whether we should complete. 
  if (d100() <= nChance)
  {
    // Set up the south transition to a random destination, unless we are entering 
	// by it.  If so, pick the west one. 
	if (sEnterBy == "TRANS_S") sLeaveBy = "TRANS_W";
	else sLeaveBy = "TRANS_S";
	
	sEndArea = GetRandomStringElement(sPath + ENDS, GetModule());
  }
  else
  {
    // Pick exit direction.  If we clash, take the next clockwise.
	switch (d4())
	{
	  case 1:
	    sLeaveBy = "TRANS_N";
		if (sEnterBy != sLeaveBy) break;
	  case 2: 
	    sLeaveBy = "TRANS_E";
		if (sEnterBy != sLeaveBy) break;
	  case 3: 
	    sLeaveBy = "TRANS_S";
		if (sEnterBy != sLeaveBy) break;
	  case 4: 
	    sLeaveBy = "TRANS_W";
		if (sEnterBy != sLeaveBy) break;
	  default: 
	    sLeaveBy = "TRANS_N";
	}	
  }
  
  Trace(FEYWILDS, "Entering by: " + sEnterBy + ", leaving by " + sLeaveBy + ".  Final area?: " + sEndArea);
  
  // We have now oriented ourselves.  Strip out the unnecessary transitions
  // and set the remaining transition tags appropriately. 
  object oObject = GetFirstObjectInArea(oDestArea);
  object oDest;
  string sTag;
  
  while (GetIsObjectValid(oObject))
  {
    sTag = GetTag(oObject);
  
    if (sTag == sEnterBy)
	{
	  SetTag(oObject, sNextTag + sEnterBy);
	  SetTransitionTarget(oObject, GetObjectByTag("WP_" + GetTag(OBJECT_SELF)));
	}
	else if (sTag == "WP_" + sEnterBy)
	{
	  SetTag(oObject, "WP_" + sNextTag + sEnterBy);
	  SetTransitionTarget(OBJECT_SELF, oObject);
	}
	else if (sTag == sLeaveBy)
	{
	  SetTag(oObject, sNextTag + sLeaveBy);
	  if (sEndArea != "")
	  {
	    // Set up transition to the final area.
		oDest = GetObjectByTag("WP_" + sEndArea + "_N");
		SetTransitionTarget(oObject, oDest);		
	  }
	  else
	  {
	    // Prepare the variables to build the next stage of the trail.
		SetLocalString(oObject, "FW_PATH", sPath);
		SetLocalInt(oObject, "FW_INSTANCE", nInstance);
		SetLocalInt(oObject, "FW_CHANCE", nChance);
		SetLocalInt(oObject, "FW_STAGE", nStage + 1);
		SetLocalString(oObject, "FW_EDGE", GetStringRight(sLeaveBy, 1));
	  }
	}
	else if (sTag == "WP_" + sLeaveBy)
	{
	  SetTag(oObject, "WP_" + sNextTag + sLeaveBy);
	  if (sEndArea != "")
	  {
	    // Set up transition back from the final area.
		oDest = GetObjectByTag(sEndArea + "_N");
		SetTransitionTarget(oDest, oObject);
	  }
	}
	else if (sTag == "TRANS_N" || sTag == "TRANS_S" || sTag == "TRANS_E" || sTag == "TRANS_W" ||
	  sTag == "WP_TRANS_N" || sTag == "WP_TRANS_S" || sTag == "WP_TRANS_E" || sTag == "WP_TRANS_W")
	{
	  DestroyObject (oObject);
	}
	
    oObject = GetNextObjectInArea(oDestArea);
  }
}
 