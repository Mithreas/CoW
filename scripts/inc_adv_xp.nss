// library that holds the functions for the adventuring XP system

#include "inc_pc"
#include "inc_area"
#include "X0_i0_stringlib"

const int DEFAULT_AREA_XP = 25;
const int DEFAULT_PORTAL_XP = 200;
const int DEFAULT_CREATURE_TYPE_XP = 150;
const int DEFAULT_TRIGGER_XP = 100;
const int DEFAULT_LASSO_XP = 250;

// checks if oPC explored oArea for the first time and logs this in the database, if so the exploration XP is added to the PCs pool
void gvd_AdventuringXP_ForArea(object oPC, object oArea);

// checks if oPC explored oObject for the first time and logs this in the database, if so the exploration XP is added to the PCs pool
void gvd_AdventuringXP_ForObject(object oPC, string sObjectType, object oObject);

// gives oPC an adventuring bonus (hourly tick in gs_m_hearbeat)
void gvd_AdventuringXP_XPBonus(object oPC);

// retrieves the current XP setting for exploring oArea
int gvd_AdventuringXP_GetAreaXP(object oArea);

// retrieves the current XP setting for exploring oObject
int gvd_AdventuringXP_GetObjectXP(string sObjectType, object oObject);

// sets the XP setting for exploring oArea to iXP
void gvd_AdventuringXP_SetAreaXP(object oArea, int iXP);

// returns a string name with the racial type of oCreature, or of iRacialType if that's provided
string gvd_GetRacialTypeName(object oCreature, int nRacialType = 0);

// adds iXP to oPC's adventuring XP pool, sFeedbackType will be included in the feedback message for the PC
void gvd_AdventuringXP_GiveXP(object oPC, int iXP, string sFeedbackType);

// toggles adventure mode on/off for oPC (on = 50% xp from kills directly, 100% to Adv pool, off = 100% xp from kills directly, 0% to pool)
void gvd_ToggleAdventureMode(object oPC);

// gets the adventuremode for oPC (1 = on, 0 = off)
int gvd_GetAdventureMode(object oPC);

void gvd_AdventuringXP_ForArea(object oPC, object oArea) {

  // valid objects?
  if ((oPC != OBJECT_INVALID) && (oArea != OBJECT_INVALID)) {

    // get id for the area
    int iAreaID = gvd_GetAreaID(oArea);
 
    if (iAreaID != 0) {

      // get the list of area id's the PC already explored
      string sAreaIDs = GetLocalString(oPC, "GVD_XP_AREAS");
      string sAreaID = IntToString(iAreaID);
 
      // init?
      if (sAreaIDs == "") {
        sAreaIDs = ",";
      }

      // first check if area is already explored by PC
      if (FindSubString(sAreaIDs, "," + sAreaID + ",") < 0) {
        // PC discovers a new area, add it to his list of explored areas in memory
        SetLocalString(oPC, "GVD_XP_AREAS", sAreaIDs + sAreaID + ",");

        // also write to db
        SQLExecDirect("INSERT INTO gvd_area_pc (area_id, pc_id) VALUES (" + sAreaID + ", " + gsPCGetPlayerID(oPC) + ")");

        // and add the XP for this area to the PCs XP pool
        int iAreaXP = gvd_AdventuringXP_GetAreaXP(oArea);

        // update PCs XP pool on the hide
        gvd_AdventuringXP_GiveXP(oPC, iAreaXP, "Exploration");

      } else {
        // already explored, nothing to do here
      } 
    

    } else {
      // no ID for this area, shouldn't be possible normally
    }
  }

}


void gvd_AdventuringXP_ForObject(object oPC, string sObjectType, object oObject) {

  // valid objects?
  if ((oPC != OBJECT_INVALID) && (oObject != OBJECT_INVALID)) {

    // get id for the object
    string sObjectID;
    sObjectType = GetStringUpperCase(sObjectType);
    int iXP;
    string sFeedback;

    if (sObjectType == "PORTAL") {
      sObjectID = IntToString(gvd_GetAreaID(GetArea(oObject)));
      sFeedback = "Portal Discovery";
    } else if (sObjectType == "CREATURE_TYPE") {
      sObjectID = IntToString(GetRacialType(oObject));
      sFeedback = "Defeated first " + gvd_GetRacialTypeName(oObject);
    } else if (sObjectType == "TRIGGER") {
      sObjectID = IntToString(gvd_GetAreaID(GetArea(oObject)));
      sFeedback = "Special Location";
    } else if (sObjectType == "LASSO") {
      sObjectID = IntToString(gvd_GetAreaID(GetArea(oObject)));
      sFeedback = "Lasso Discovery";
    }
 
    if (sObjectID != "") {

      // get the list of object id's the PC already explored
      string sObjectIDs = GetLocalString(oPC, "GVD_XP_" + sObjectType);

      // init?
      if (sObjectIDs == "") {
        sObjectIDs = ",";
      }

      // first check if object is already explored by PC
      if (FindSubString(sObjectIDs, "," + sObjectID + ",") < 0) {
        // PC discovers a new object, add it to his list of explored objects in memory
        SetLocalString(oPC, "GVD_XP_" + sObjectType, sObjectIDs + sObjectID + ",");

        // also write to db
        SQLExecDirect("INSERT INTO gvd_adv_xp_pc (object_id, pc_id, object_type) VALUES ('" + sObjectID + "', " + gsPCGetPlayerID(oPC) + ", '" + sObjectType + "')");

        // check if there are any flavor messages on the object
        string sMsg = GetLocalString(oObject, "GVD_ADVENTURE_MSG");
        if (sMsg != "") {
          FloatingTextStringOnCreature(sMsg, oPC);
        }

        // and add the XP for this object to the PCs XP pool
        int iXP = gvd_AdventuringXP_GetObjectXP(sObjectType, oObject);

        // for creature types, we do increments in XP
        if (sObjectType == "CREATURE_TYPE") {
          int iQty = GetNumberTokens(sObjectIDs, ",");
          iXP = iXP * iQty;
        }

        // update PCs XP pool on the hide
        gvd_AdventuringXP_GiveXP(oPC, iXP, sFeedback);

      } else {
        // already explored, nothing to do here
      } 
    }
  }

}

void gvd_AdventuringXP_XPBonus(object oPC) {

  // first check if PC isn't lvl 30 already or already has enough XP to gain a new lvl (taken from inc_xp)
  int nXP = GetXP(oPC);
  int nLevel = GetHitDice(oPC);
  int nXPLevel = (nLevel + 1) * nLevel / 2 * 1000;
  if (nXP >= nXPLevel) return;

  object oHide = gsPCGetCreatureHide(oPC);
  int iMax = 500;
  int iXPPool = GetLocalInt(oHide, "GVD_XP_POOL");
  int iXP;

  // in case of zero RPR, max will be 10
  if (iMax < 10) {
    iMax = 10;
  }

  // Improve max if the player is in a Tavern area.
  object oArea = GetArea(oPC);
  if (oArea != OBJECT_INVALID && GetLocalInt(oArea, "TAVERN_SUSTAIN")) 
  {
    iMax += 500;
  }  
  
  if (iXPPool > 0) {                        
    // 10% will be drawn from pool minimum = 10, maximum = 100
    if (iXPPool < 150) {
      iXP = 10;
    } else {
      iXP = FloatToInt(iXPPool / 100.0f); // always rounds down
      if ((iXPPool - (100 * iXP)) >= 50) {
        // should round up
        iXP = (iXP + 1);
      }
      iXP = iXP * 10;

      if (iXP > iMax) {
        iXP = iMax;
      }
    }

    int iNewXP = iXPPool - iXP;

    if (iNewXP < 0) {
      iNewXP = 0;
    }

    // update PCs XP pool on the hide
    SetLocalInt(oHide, "GVD_XP_POOL",  iNewXP);  

    // feedback for PC
    SendMessageToPC(oPC, "<cªÕþ>You receive a little adventuring bonus (" + IntToString(iXPPool - iXP) + " remaining)");

    if (GetHitDice(oPC) >= GetLocalInt(GetModule(), "STATIC_LEVEL"))
    {
      GiveGoldToCreature(oPC, iXP);
    }
    else
    {
      // don't use gsXPGiveExperience anymore because of recursive include mess
      // gsXPGiveExperience(oPC, iXP);

      // instead copied over parts of the code from there
      SetXP(oPC, nXP + iXP);   
      gsPCMemorizeClassData(oPC);
      SendMessageToPC(oPC, "<cªÕþ>+" + IntToString(iXP) + " " + GS_T_16777315);

    }

  }

}

int gvd_AdventuringXP_GetAreaXP(object oArea) {

  int iAreaXP = GetLocalInt(oArea, "GVD_AREA_XP");

  // if no variable is set, use the default value of 50
  if (iAreaXP == 0) {
    iAreaXP = DEFAULT_AREA_XP;
  } else if (iAreaXP < 0) {
    // when -1 is used, this means the area shouldn't reward XP
    iAreaXP = 0;
  }

  return iAreaXP;

}

void gvd_AdventuringXP_SetAreaXP(object oArea, int iXP) {

  gvd_SetAreaInt(oArea, "GVD_AREA_XP", iXP);

}

int gvd_AdventuringXP_GetObjectXP(string sObjectType, object oObject) {

  int iXP = GetLocalInt(oObject, "GVD_ADVENTURE_XP");

  // if no variable is set, use the default value for the object type
  if (iXP == 0) {
    if (sObjectType == "PORTAL") {
      iXP = DEFAULT_PORTAL_XP;
    } else if (sObjectType == "CREATURE_TYPE") {
      iXP = DEFAULT_CREATURE_TYPE_XP;
    } else if (sObjectType == "TRIGGER") {
      iXP = DEFAULT_TRIGGER_XP;
    } else if (sObjectType == "LASSO") {
      iXP = DEFAULT_LASSO_XP;
    }
  } else if (iXP < 0) {
    // when -1 is used, this means no xp reward
    iXP = 0;
  }

  return iXP;

}


string gvd_GetRacialTypeName(object oCreature, int nRacialType = 0) {

    if (nRacialType == 0) {
      nRacialType = GetRacialType(oCreature);
    }

    switch (nRacialType)
    {
    case RACIAL_TYPE_ABERRATION:
      return "Aberration";

    case RACIAL_TYPE_ANIMAL:
      return "Animal";

    case RACIAL_TYPE_BEAST:
      return "Beast";

    case RACIAL_TYPE_CONSTRUCT:
      return "Construct";

    case RACIAL_TYPE_DRAGON:
      return "Dragon";

    case RACIAL_TYPE_DWARF:
      return "Dwarf";

    case RACIAL_TYPE_ELEMENTAL:
      return "Elemental";

    case RACIAL_TYPE_ELF:
      return "Elf";

    case RACIAL_TYPE_FEY:
      return "Fey";

    case RACIAL_TYPE_GIANT:
      return "Giant";

    case RACIAL_TYPE_GNOME:
      return "Gnome";

    case RACIAL_TYPE_HALFELF:
      return "Half-Elf";

    case RACIAL_TYPE_HALFLING:
      return "Halfling";

    case RACIAL_TYPE_HALFORC:
      return "Half-Orc";

    case RACIAL_TYPE_HUMAN:
      return "Human";

    case RACIAL_TYPE_HUMANOID_GOBLINOID:
      return "Goblinoid";

    case RACIAL_TYPE_HUMANOID_MONSTROUS:
      return "Monstrous";

    case RACIAL_TYPE_HUMANOID_ORC:
      return "Orc";

    case RACIAL_TYPE_HUMANOID_REPTILIAN:
      return "Reptilian";

    case RACIAL_TYPE_INVALID:
      return "Unknown";

    case RACIAL_TYPE_MAGICAL_BEAST:
      return "Magical Beast";

    case RACIAL_TYPE_OOZE:
      return "Ooze";

    case RACIAL_TYPE_OUTSIDER:
      return "Outsider";

    case RACIAL_TYPE_SHAPECHANGER:
      return "Shapechanger";

    case RACIAL_TYPE_UNDEAD:
      return "Undead";

    case RACIAL_TYPE_VERMIN:
      return "Vermin";
    }

    return "Unknown";

}

void gvd_AdventuringXP_GiveXP(object oPC, int iXP, string sFeedbackType) {

  object oHide = gsPCGetCreatureHide(oPC);
  SetLocalInt(oHide, "GVD_XP_POOL", GetLocalInt(oHide, "GVD_XP_POOL") + iXP);  

  // feedback for the player
  SendMessageToPC(oPC, "<cªÕþ>Adventuring Bonus: " + sFeedbackType + " (+" + IntToString(iXP) + " delayed XP)");       


}

// toggles adventure mode on/off for oPC (on = 50% xp from kills directly, 100% to Adv pool, off = 100% xp from kills directly, 0% to pool)
void gvd_ToggleAdventureMode(object oPC) {

  object oHide = gsPCGetCreatureHide(oPC);
  int iXPPool = GetLocalInt(oHide, "GVD_XP_POOL");

  if (gvd_GetAdventureMode(oPC) == 0) {
    // turn on
    SetLocalInt(oHide, "GVD_ADVENTURE_MODE", 1);
    SendMessageToPC(oPC, "You have turned Adventure Mode ON. Current XP Pool: " + IntToString(iXPPool));

  } else {
    // turn off
    SetLocalInt(oHide, "GVD_ADVENTURE_MODE", 0);
    SendMessageToPC(oPC, "You have turned Adventure Mode OFF. Current XP Pool: " + IntToString(iXPPool));

  }

}

// gets the adventuremode for oPC (1 = on, 0 = off)
int gvd_GetAdventureMode(object oPC) {

  object oHide = gsPCGetCreatureHide(oPC);

  return GetLocalInt(oHide, "GVD_ADVENTURE_MODE");

}

