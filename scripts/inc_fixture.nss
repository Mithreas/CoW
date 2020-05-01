/* FIXTURE library by Gigaschatten */
/* SQL rewrite by SartriX */

#include "inc_location"
#include "inc_iprop"
#include "inc_combat2"
#include "inc_database"
#include "inc_seeds"
#include "inc_time"

const string FIXTURES = "FIXTURES"; // for logging

//void main() {}

//load nLimit objects from database sID
void gsFXLoadFixture(string sID, int nLimit = ALLOW_MAX_FIXTURES);
//save oFixture to database sID containing a maximum of nLimit objects and return TRUE on success
int gsFXSaveFixture(string sID, object oFixture = OBJECT_SELF, int nLimit = ALLOW_MAX_FIXTURES, int bExpire = FALSE, int bConversion = FALSE);
//delete oFixture from database sID containing a maximum of nLimit objects
void gsFXDeleteFixture(string sID, object oFixture = OBJECT_SELF, int nLimit = ALLOW_MAX_FIXTURES);
//update fixture from database id
void gsFXUpdateFixture(string unusedBioDBID, object fixture = OBJECT_SELF);
//pick up a fixture, transferring any custom name and description to a fixture object in
//the given player's inventory
object gsFXPickupFixture(object oPlayer, object oFixture);
//set a variable for the fixture, saving to the database for persistence.
void gsFXSetLocalString(object oFixture, string sVarName, string sValue);
//notify a player who has picked up a fixture.
void gsFXWarn(object oPC, object oFixture);

// create remains for oFixture, which can be worked on by PCs to restore the original
void gvdFXCreateRemains(object oFixture, object oDamager);

// get craft skill needed for oFixture
int gvd_FXGetSkillForFixture(object oFixture);

// determine best matching remains placeable resref for oFixture (appearance thing)
string gvd_GetRemainsResRefForFixture(object oFixture);

// function that retrieves seperate variables from a big variable string and stores them on oFixture
void gvd_SetFixtureRemainsData(object oFixture);

// copied these 2 over of inc_bloodstains because of include issues while compiling

string gvd_GetWeaponDamageType(object oWeapon)
{
  int nType = GetBaseItemType(oWeapon);

  switch (nType)
  {
    case BASE_ITEM_BASTARDSWORD:
    case BASE_ITEM_BATTLEAXE:
    case BASE_ITEM_DOUBLEAXE:
    case BASE_ITEM_DWARVENWARAXE:
    case BASE_ITEM_GREATSWORD:
    case BASE_ITEM_GREATAXE:
    case BASE_ITEM_HALBERD:
    case BASE_ITEM_HANDAXE:
    case BASE_ITEM_KAMA:
    case BASE_ITEM_KATANA:
    case BASE_ITEM_KUKRI:
    case BASE_ITEM_LONGSWORD:
    case BASE_ITEM_SCIMITAR:
    case BASE_ITEM_SCYTHE:
    case BASE_ITEM_SICKLE:
    case BASE_ITEM_THROWINGAXE:
    case BASE_ITEM_TWOBLADEDSWORD:
    case BASE_ITEM_WHIP:
      return "Slashing";
    case BASE_ITEM_DAGGER:
    case BASE_ITEM_DART:
    case BASE_ITEM_HEAVYCROSSBOW:
    case BASE_ITEM_LIGHTCROSSBOW:
    case BASE_ITEM_LONGBOW:
    case BASE_ITEM_RAPIER:
    case BASE_ITEM_SHORTSPEAR:
    case BASE_ITEM_SHORTBOW:
    case BASE_ITEM_SHORTSWORD:
    case BASE_ITEM_SHURIKEN:
    case BASE_ITEM_TRIDENT:
      return "Piercing";
    case BASE_ITEM_DIREMACE:
    case BASE_ITEM_HEAVYFLAIL:
    case BASE_ITEM_INVALID:
    case BASE_ITEM_LIGHTFLAIL:
    case BASE_ITEM_LIGHTHAMMER:
    case BASE_ITEM_LIGHTMACE:
    case BASE_ITEM_MAGICSTAFF:
    case BASE_ITEM_MORNINGSTAR:
    case BASE_ITEM_QUARTERSTAFF:
    case BASE_ITEM_SLING:
    case BASE_ITEM_WARHAMMER:
      return "Bludgeoning";
  }

  return "Bludgeoning";
}

string gvd_GetLargestDamageDealt(object oVictim)
{
  //----------------------------------------------------------------------------
  // Monster hack since GetDamageDealtByType only registers EffectDamage
  // and not standard melee damage.  Damn.
  // Logic as follows.
  // 1.  find the killer
  // 2.  if they're next to us and have a melee weapon equipped, use the damage
  //     type of that weapon.
  // 3.  if they have a ranged weapon equipped, use the damage type of that
  //     weapon
  // 4.  else assume death by spell; ExecuteScript something to populate the
  //     damage dealt to the caller of different types and return that.
  //----------------------------------------------------------------------------
  object oKiller = GetLastHostileActor(oVictim);
  //SendMessageToPC(oKiller, "Distance: " + FloatToString(GetDistanceBetween(oKiller, oVictim)));
  object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oKiller);

  if (GetDistanceBetween(oKiller, oVictim) < 2.5 && IPGetIsMeleeWeapon(oWeapon))
  {
    return gvd_GetWeaponDamageType(oWeapon);
  }
  else if (!IPGetIsMeleeWeapon(oWeapon))
  {
    return gvd_GetWeaponDamageType(oWeapon);
  }
  else
  {
    ExecuteScript("mi_getdamagetype", oVictim);
    return GetLocalString(oVictim, "MI_DAMAGE_TYPE");
  }
}

/*
Mysql:
CREATE TABLE `gs_fixtures` (
  `fixture_id` int(11) NOT NULL auto_increment,
  `set_id` varchar(64) default NULL,
  `location` varchar(255) default NULL,
  `resref` varchar(64) default NULL,
  `tag` varchar(64) default NULL,
  `name` varchar(128) default NULL,
  `description` TEXT default NULL,
  `expire` int(1) default NULL,
  `last` timestamp NOT NULL default CURRENT_TIMESTAMP,
  PRIMARY KEY  (`fixture_id`),
  UNIQUE KEY `LocIndex` (`location`)
)
SQLite alternative:
CREATE TABLE `gs_fixtures` (
  `fixture_id` integer primary key autoincrement NOT NULL,
  `set_id` varchar(64) default NULL,
  `location` varchar(255) default NULL,
  `resref` varchar(64) default NULL,
  `tag` varchar(64) default NULL,
  `name` varchar(128) default NULL,
  `description` TEXT default NULL,
  `expire` int(1) default NULL,
  `last` timestamp NOT NULL default CURRENT_TIMESTAMP,
  UNIQUE (`location`)
)
*/



void _LoadVars(object oFixture)
{
  SQLExecStatement("SELECT var_name,var_data FROM gs_fx_vars WHERE fixture_id=?",
             IntToString(GetLocalInt(oFixture, "DBFixtureID")));

  while (SQLFetch())
  {
    SetLocalString(oFixture, SQLGetData(1), SQLGetData(2));
    AddStringElement(SQLGetData(1), "VAR_LIST", oFixture);
  }

  gvd_SetFixtureRemainsData(oFixture);

}

void gsFXLoadFixture(string sID, int nLimit = ALLOW_MAX_FIXTURES)
{
    location lLocation;
    int iID = 0;
    string sTemplate = "";
    string sNth      = "";
    string sName     = "";
    string sDescription     = "";
    string sTag      = "";
    object oFixture;
    string SQL;

    if (FIXTURE_SAVE_SQL) {
        SQL = "SELECT fixture_id,location,resref,tag,name,description FROM gs_fixtures WHERE set_id='" + sID + "'";
        SQLExecDirect(SQL);

        while (SQLFetch()) {
            iID          = StringToInt(SQLGetData(1));
            lLocation    = APSStringToLocation(SQLGetData(2));
            sTemplate    = SQLGetData(3);
            sTag         = SQLGetData(4);
            sName        = SQLGetData(5);
            sDescription = SQLGetData(6);
            oFixture  = CreateObject(OBJECT_TYPE_PLACEABLE, sTemplate, lLocation, FALSE, sTag);
            if (sName != "") SetName(oFixture, sName);
            if (sDescription != "") SetDescription(oFixture, sDescription);
            SetLocalInt(oFixture, "DBFixtureID", iID);
            SetLocalInt(oFixture, "GS_STATIC", TRUE);

            // Dunshine: flag all pc planted seeds as withered by default, so we can id the ones outside designated areas later on
            if ((gvd_GetPlaceableIsSeed(oFixture) == 1) && !GetLocalInt(GetModule(), "STATIC_LEVEL")) {
              SetLocalInt(oFixture, "GVD_WITHERED", 1);
            }

            AssignCommand(oFixture, DelayCommand(6.0, _LoadVars(oFixture)));
            Trace(FIXTURES,sName + " loaded from SQL");
        }
    }
}
//----------------------------------------------------------------
int gsFXSaveFixture(string sID, object oFixture = OBJECT_SELF, int nLimit = ALLOW_MAX_FIXTURES, int bExpire = FALSE, int bConversion = FALSE)
{
    if (!GetIsObjectValid(oFixture)) return FALSE;
    SetLocalInt(oFixture, "GS_STATIC", TRUE);

    if (FIXTURE_SAVE_SQL) {
        string SQL;
        int iID;
        // Dunshine: exclude seeds from the placeable count
        if ((nLimit >= 0) && !gvd_GetPlaceableIsSeed(oFixture)) {
            SQL = "SELECT count(*) FROM gs_fixtures WHERE (set_id='"+ sID +"') and (left(tag,11) <> 'GS_FX_seeds')";
            int nCount = SQLExecAndFetchSingleInt(SQL) + 1;
	    SendMessageToPC(GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_IS_PC,oFixture, FALSE), "This is fixture number " + IntToString(nCount) + " of " + IntToString(nLimit) + " allowed in this area.");
            if (nCount > nLimit) {
              return FALSE;
	    }	
        }

        // Check for duplicate items in the database.
        // Note - originally the column was only 128 chars in size, and only
        // some fixtures were migrated.  So look for entries like that.
        SQL = "SELECT count(*) FROM gs_fixtures WHERE location like '" +
                GetStringLeft(APSLocationToString(GetLocation(oFixture)), 127) + "%'";

        if (SQLExecAndFetchSingleInt(SQL))
        {
          Trace(FIXTURES, "Item already exists at that location.  Don't save.");
          return FALSE;
        }

        SQL = "INSERT INTO gs_fixtures (set_id,location,resref,tag,name,description,expire) VALUES ('"
            + sID + "','" + APSLocationToString(GetLocation(oFixture)) + "','"
            + GetResRef(oFixture) + "','" + GetTag(oFixture) + "','"
            + SQLEncodeSpecialChars(GetName(oFixture)) + "','"
            + SQLEncodeSpecialChars(GetDescription(oFixture)) + "',"
            + IntToString(bExpire) + ")";
        SQLExecDirect(SQL);
        Trace(FIXTURES,GetName(oFixture) + " saved to SQL");

        // Return and save the fixture ID.
        SQLExecStatement("SELECT fixture_id FROM gs_fixtures WHERE location=?",
            APSLocationToString(GetLocation(oFixture)));
        SQLFetch();
        iID = StringToInt(SQLGetData(1));
        SetLocalInt(oFixture, "DBFixtureID", iID);
    }

    if (FIXTURE_SAVE_BIO && !bConversion) {
        string sNth = "";
        int nNth    = 0;

        for (nNth = 1; nNth <= nLimit; nNth++) {
            sNth = IntToString(nNth);

            if (! GetCampaignInt("GS_FX_" + sID, "SLOT_" + sNth)) {
                SetCampaignInt("GS_FX_" + sID, "SLOT_" + sNth, TRUE);
                SetCampaignString("GS_FX_" + sID, "TEMPLATE_" + sNth, GetResRef(oFixture));
                SetCampaignString("GS_FX_" + sID, "NAME_" + sNth, GetName(oFixture));
                SetCampaignString("GS_FX_" + sID, "TAG_" + sNth, GetTag(oFixture));

                gsLOSetDBLocationOf("GS_FX_" + sID, "LOCATION_" + sNth, oFixture);
                Trace(FIXTURES,GetName(oFixture) + " saved to BDB in slot " + sNth);
                return TRUE;
            }
        }
        return FALSE;
    }
    return TRUE;
}
//----------------------------------------------------------------
void gsFXDeleteFixture(string sID, object oFixture = OBJECT_SELF, int nLimit = ALLOW_MAX_FIXTURES)
{
    if (!GetIsObjectValid(oFixture)) return;

    if (FIXTURE_SAVE_SQL) {
        string SQL;
        string sLoc;
        int iID = GetLocalInt(oFixture, "DBFixtureID");

        if (iID>0) {
            SQL = "DELETE FROM gs_fixtures WHERE fixture_id='"+ IntToString(iID) +"'";
            Trace(FIXTURES,"Deleted from SQL by ID");
        } else {
            sLoc = APSLocationToString(GetLocation(oFixture));
            SQL = "DELETE FROM gs_fixtures WHERE location='"+ sLoc +"'";
            Trace(FIXTURES,"Deleted from SQL by location");
        }
        SQLExecDirect(SQL);
    }

    if (FIXTURE_SAVE_BIO) {
        struct gsLOLocation gsLocation = gsLOGetLocationX(oFixture);
        string sNth                    = "";
        int nNth                       = 0;

        for (nNth = 1; nNth <= nLimit; nNth++) {
            sNth      = IntToString(nNth);

            if (GetCampaignInt("GS_FX_" + sID, "SLOT_" + sNth) &&
                gsLOGetDBLocationX("GS_FX_" + sID, "LOCATION_" + sNth) == gsLocation)
            {
                SetCampaignInt("GS_FX_" + sID, "SLOT_" + sNth, FALSE);
                DeleteCampaignVariable("GS_FX_" + sID, "TAG_" + sNth);
                DeleteCampaignVariable("GS_FX_" + sID, "NAME_" + sNth);
                Trace(FIXTURES,"Deleted from BDB");
                return;
            }
        }
    }
}
//----------------------------------------------------------------
void gsFXUpdateFixture(string unusedBioDBID, object fixture)
{
    if (!GetIsObjectValid(fixture))
    {
        return;
    }

    if (FIXTURE_SAVE_SQL)
    {
        int id = GetLocalInt(fixture, "DBFixtureID");
        SQLExecDirect("UPDATE gs_fixtures SET location='" + APSLocationToString(GetLocation(fixture)) +
                      "' WHERE fixture_id='" + IntToString(id) + "'");
        Trace(FIXTURES, "Updated from SQL by ID.");
    }
}
//----------------------------------------------------------------
object gsFXPickupFixture(object oPlayer, object oPlaceable)
{
    string sTag = GetTag(oPlaceable);
    sTag        = GetStringRight(sTag, GetStringLength(sTag) - 6);

    // Addition by Mithreas.  Message boards need to have a unique tag
    // to work. So if there's a __ (double underscore) in the tag, cut
    // it short.
    // 123__12  index=3
    int __index = FindSubString(sTag, "__");
    string sTagg = "";
    if (__index > 0)
    {
      sTagg = GetStringRight(sTag, GetStringLength(sTag) - __index);
      sTag = GetStringLeft(sTag, __index);
    }

    // if the placeable is the remains of another fixture, then we need to use "gvd_it_remains" for the item resref, since there is only 1 remains item vs multiple remains placeables in the palette
    if (GetLocalString(oPlaceable, "GVD_REMAINS_STATUS") != "") {    
      sTag = "gvd_it_remains";
    }

    Trace(FIXTURES, "Creating item with tag: GS_FX_" + GetResRef(oPlaceable) + sTagg);

    object oFixture = CreateItemOnObject(sTag, oPlayer, 1, "GS_FX_" + GetResRef(oPlaceable) + sTagg);

    if (GetIsObjectValid(oFixture))
    {
        if (GetName(oPlaceable, TRUE) != GetName(oPlaceable, FALSE))
        {
           SetName(oFixture, GetName(oPlaceable));
        }

        if (GetDescription(oPlaceable, TRUE) != GetDescription(oPlaceable, FALSE))
        {
           SetDescription(oFixture, GetDescription(oPlaceable));
        }

        // Migrate variables.
        string sVarName = GetFirstStringElement("VAR_LIST", oPlaceable);

        while (sVarName != "")
        {
          SetLocalString(oFixture, sVarName, GetLocalString(oPlaceable, sVarName));
          AddStringElement(sVarName, "VAR_LIST", oFixture);
          sVarName = GetNextStringElement();
        }

        gsFXDeleteFixture(GetTag(GetArea(oPlaceable)), oPlaceable);
        // We don't actually delete the placeable object here: the caller must do that.
        // Most callers still have some logging to do once this function returns, so
        // it's a little too early to destroy the object here.
    }
    return oFixture;
}
//----------------------------------------------------------------
void gsFXSetLocalString(object oFixture, string sVarName, string sValue)
{
  int iID = GetLocalInt(oFixture, "DBFixtureID");

  if (GetLocalString(oFixture, sVarName) != "")
  {
    // Variable exists: update.
    SQLExecStatement("UPDATE gs_fx_vars SET var_data=? WHERE fixture_id=? AND var_name=?",
                     SQLEncodeSpecialChars(sValue), IntToString(iID), sVarName);
  }
  else
  {
    // Doesn't exist: add.
    SQLExecStatement("INSERT INTO gs_fx_vars (fixture_id,var_name,var_data) VALUES (?,?,?)",
                     IntToString(iID), sVarName, SQLEncodeSpecialChars(sValue));
    AddStringElement(sVarName, "VAR_LIST", oFixture);
  }

  SetLocalString(oFixture, sVarName, sValue);
}
//----------------------------------------------------------------
void gsFXWarn(object oPC, object oFixture)
{
  if (GetIsPC(oPC) && !GetIsDM(oPC) && gsIPGetOwner(oFixture) != gsPCGetPlayerID(oPC))
  {
    SendMessageToPC(oPC, "(That fixture does not seem to belong to you. " +
      "Please note that removing other people's fixtures without RP is a " +
      "breach of the Be Nice rule, and that we log every act of vandalism.)");
  }
}

void gvdFXCreateRemains(object oFixture, object oDamager) {

  if (!GetIsObjectValid(oFixture)) return;

  // check if it's a playermade fixture, if not it won't leave remains since these will be auto-created again after a reset
  // hopefully only playermade fixtures have the tag prefix GS_FX_
  if (GetStringLeft(GetTag(oFixture),6) != "GS_FX_") return;
  
  // first check if the fixture is not the remains of another fixture, is the remains gets bashed as well, then it's permanently destroyed
  if (GetLocalString(oFixture, "GVD_REMAINS_STATUS") == "") {
    // create remains and store info on original fixture as variables
    location lLocation = GetLocation(oFixture);
    string sTag = GetTag(oFixture);
    // we need the resref of the fixture item as well, this is stored in the placeables tag, after: GS_FX_
    string sResRefItem = GetStringRight(sTag, GetStringLength(sTag) - 6);
    string sResRef = GetResRef(oFixture);
    string sName = GetName(oFixture);
    string sDescription = GetDescription(oFixture);

    // remove the variable seperator (||) from the name and description, just in case
    sName = StringReplace(sName, "||", "--");
    sDescription = StringReplace(sDescription, "||", "--");

    object oRemains = CreateObject(OBJECT_TYPE_PLACEABLE, gvd_GetRemainsResRefForFixture(oFixture), lLocation, FALSE);  

    // set name
    SetName(oRemains, "Remains");
    SetDescription(oRemains, "Remains of " + sName);

    if (!gsFXSaveFixture(GetTag(GetArea(oRemains)), oRemains)) {
      SendMessageToPC(oDamager, "Fixture remains not saved! Max 60 per area.");
      Log(FIXTURES, "Fixture remains of " + GetName(oFixture) + " in area " + GetName(GetArea(oFixture)) + " by " + GetName(oDamager) + " could not be saved.");

    } else {
      Log(FIXTURES, "Fixture remains of " + GetName(oFixture) + " was left in area " + GetName(GetArea(oFixture)) + " by " + GetName(oDamager) + ".");

      // Migrate variables.
      string sVarName = GetFirstStringElement("VAR_LIST", oFixture);

      while (sVarName != "") {
        gsFXSetLocalString(oRemains, sVarName, GetLocalString(oFixture, sVarName));
        sVarName = GetNextStringElement();
      }

      // we also need the skill number for this placeable to be able to use it as a craft station
      int iSkill = gvd_FXGetSkillForFixture(oFixture);
      int iTimestamp = GetLocalInt(GetModule(),"GS_TIMESTAMP");

      // store variables locally on the object first
      SetLocalString(oRemains, "GVD_REMAINS_RESREF_ITEM", sResRefItem);
      SetLocalString(oRemains, "GVD_REMAINS_RESREF", sResRef);
      SetLocalString(oRemains, "GVD_REMAINS_TAG", sTag);
      SetLocalInt(oRemains, "GS_SKILL", iSkill);
      SetLocalString(oRemains, "GVD_REMAINS_NAME", sName);
      SetLocalString(oRemains, "GVD_REMAINS_DESCRIPTION", sDescription);
      SetLocalInt(oRemains, "GVD_REMAINS_TIMESTAMP", iTimestamp);

      // and add some clues for -investigate, variable RESULT_1 being the damagetype, RESULT_2 being the race, RESULT_3 being the gender of oDamager
      string sDamageType = gvd_GetLargestDamageDealt(oFixture);
      string sSubRace = GetSubRace(oDamager);
	  
	  // Remove background, if any.
      int nPara1 = FindSubString(sSubRace, "(");

      if (nPara1 > -1)
      {
        // subrace = player's subrace (player's background)
        sSubRace = GetStringLeft(sSubRace, nPara1 - 1);
      }
      
      // Override for polymorphed.
      if (gsC2GetHasEffect(EFFECT_TYPE_POLYMORPH, oDamager)) sSubRace = "creature";

      int nBaseAC = gsCMGetItemBaseAC(GetItemInSlot(INVENTORY_SLOT_CHEST, oDamager));
      if (nBaseAC == 0) sSubRace = "an unarmoured " + sSubRace;
      else if (nBaseAC < 4) sSubRace = "a lightly armoured " + sSubRace;
      else if (nBaseAC < 6) sSubRace = "a medium armoured " + sSubRace;
      else sSubRace = "a heavily armoured " + sSubRace;

      string sGender = (GetGender(oDamager) == GENDER_MALE) ? "male":"female";
      
      // handle lightning strikes from the weather system 
      if (GetLocalInt(oFixture, "GVD_REMAINS_LIGHTNINGSTRIKE") == 1) {
        sDamageType = "a lightning strike";
        sSubRace = "bad weather";
        sGender = "none";
      }

      SetLocalString(oRemains, "RESULT_1", sDamageType);
      SetLocalString(oRemains, "RESULT_2", sSubRace);
      SetLocalString(oRemains, "RESULT_3", sGender);

      // add variables to store data of original fixture as well, bundle all variables into 1 big string instead of seperate variables to prevent unnecessary sql calls
      string sRemainsData = sResRefItem + "||" + sResRef + "||" + sTag + "||" + IntToString(iSkill) + "||" + IntToString(iTimestamp) + "||" + sDamageType + "||" + sSubRace +  "||" + sGender + "||" + sName + "||" + sDescription; 
      gsFXSetLocalString(oRemains, "GVD_REMAINS_DATA", sRemainsData);
      gsFXSetLocalString(oRemains, "GVD_REMAINS_STATUS", "1");  
  
      // finally check if there is a NPC in the line of sight of this fixture, that witnessed it's destruction
      // look through all NPCs in a 30ft radius with a line of sight to the fixture
      location lLocation = GetLocation(oRemains);
      object oNPC = GetFirstObjectInShape(SHAPE_SPHERE, 30.0, lLocation, TRUE, OBJECT_TYPE_CREATURE);
 
      while (GetIsObjectValid(oNPC)) {
       
        // if not a PC
        if (!GetIsPC(oNPC)) {     

          // enter investigation data into the NPCs memory, use an execute script for this to prevent a big include mess with inc_disguise
          SetLocalObject(oNPC, "GVD_REMAINS_DAMAGER", oDamager);
          SetLocalString(oNPC, "GVD_REMAINS_NAME", sName);
          ExecuteScript("exe_investrem", oNPC);
        }
       
        // next creature
        oNPC = GetNextObjectInShape(SHAPE_SPHERE, 30.0, lLocation, TRUE, OBJECT_TYPE_CREATURE);
      
      }
      
    }

  } else {
    gsFXWarn(oDamager, oFixture);    
  }

}


int gvd_FXGetSkillForFixture(object oFixture) {

    string sTag = GetTag(oFixture);

    // in case of messageboards, there is an additional __number behind the tag, that needs to be removed to be able to find the recipe
    int __index = FindSubString(sTag, "__");
    if (__index > 0)
    {
      sTag = GetStringLeft(sTag, __index);
    }

    // we need the resref of the fixture item, not the fixture placeable, this is stored in the placeables tag, after: GS_FX_
    string sResRef = GetStringRight(sTag, GetStringLength(sTag) - 6);

    SQLExecStatement("SELECT skill FROM md_cr_recipes INNER JOIN md_cr_output ON (md_cr_recipes.id = md_cr_output.Recipe_ID) WHERE md_cr_output.Resref=? LIMIT 1", sResRef);
    if (SQLFetch()) {
      return StringToInt(SQLGetData(1));
    } else {
      return 0;
    }
}

string gvd_GetRemainsResRefForFixture(object oFixture) {

  // try to determine the best looking remains appearance for oFixture

  // possible placeable resrefs: gvd_fx_remainsXX , where XX = 
  // 01 = generic Debris
  // 02 = Broken Bookcase			
  // 03 = Broken Chair
  // 04 = Broken Furniture
  // 05 = Broken Table
  // 06 = generic small Garbage
  // 07 = Messageboard Many sheets of paper
  // 08 = generic stones Rubble

  // first see if there is a variable set for this on the placeable, which would be nice
  string sResRef = GetLocalString(oFixture, "GVD_REMAINS_RESREF");

  if (sResRef == "") {
    // nope, check for one of these known placeables based on their tags
    string sTag = GetTag(oFixture);

    if ((sTag == "GS_FX_gs_item036") || (sTag == "GS_FX_wt_item_tbl1") || (sTag == "GS_FX_gs_item438") || (sTag == "GS_FX_gs_item439")) {
      // tables
      sResRef = "gvd_fx_remains05";

    } else if (sTag == "GS_FX_wt_item_bkcase1") {
      // bookcases
      sResRef = "gvd_fx_remains02";

    } else if ((sTag == "GS_FX_gs_item033") || (sTag == "GS_FX_wt_item_chair1") || (sTag == "GS_FX_wt_item_chair2") || (sTag == "GS_FX_wt_item_stool")) {
      // chairs
      sResRef = "gvd_fx_remains03";

    } else if ((sTag == "GS_FX_wt_item_target1") || (sTag == "GS_FX_wt_item_gllw1") || (sTag == "wt_item_pllrwood") || (sTag == "GS_FX_gs_item060") || (sTag == "GS_FX_wt_item_sign2") || (sTag == "GS_FX_wt_item_tlscp1") || (sTag == "GS_FX_wt_item_trch1") || (sTag == "GS_FX_gs_item116") || (sTag == "GS_FX_gs_item440") || (sTag == "GS_FX_gs_item436")) {
      // generic
      sResRef = "gvd_fx_remains01";

    } else if ((sTag == "GS_FX_gs_item067") || (sTag == "GS_FX_wt_item_keg1") || (sTag == "GS_FX_wt_item_bench1") || (sTag == "GS_FX_wt_item_bench3") || (sTag == "GS_FX_wt_item_bench2") || (sTag == "GS_FX_gs_item034") || (sTag == "wt_item_lecturn") || (sTag == "GS_FX_wt_item_sign3") || (sTag == "GS_FX_wt_item_wrktlr")) {
      // furniture
      sResRef = "gvd_fx_remains04";

    } else if ((GetStringLeft(sTag, 16) == "GS_FX_gs_item059")) {
      // message board
      sResRef = "gvd_fx_remains07";

    } else if ((sTag == "wt_placeable1") || (sTag == "GS_FX_gs_item413") || (sTag == "GS_FX_gs_item217") || (sTag == "GS_FX_gs_item114") || (sTag == "wt_item_gargoyle") || (sTag == "GS_FX_gs_item411") || (sTag == "GS_FX_wt_item_hdstn") || (sTag == "GS_FX_gs_item410") || (sTag == "wt_item_pllrrune") || (sTag == "wt_item_sphynx") || (sTag == "GS_FX_wt_item_altar1") || (sTag == "GS_FX_gs_item112") || (sTag == "wt_item_statbrkn") || (sTag == "wt_item_stattall") || (sTag == "GS_FX_gs_item376") || (sTag == "GS_FX_gs_item377") || (sTag == "GS_FX_gs_item113") || (sTag == "GS_FX_wt_item_tortr1") || (sTag == "GS_FX_gs_item437")) {
      // generic stones
      sResRef = "gvd_fx_remains08";

    } else {
      // everything else, we use small garbage
      sResRef = "gvd_fx_remains06";

    }
 
  }

  return sResRef;

}

void gvd_SetFixtureRemainsData(object oFixture) {

  // in case this is a fixture remains, then split the variable data in seperate local variables
  if (GetLocalString(oFixture, "GVD_REMAINS_DATA") != "") {

    // variable value buildup: sResRefItem + "||" + sResRef + "||" + sTag + "||" + sSkill + "||" + nTimestamp + "||" + sDamageType + "||" + sSubrace +  "||" + sGender + "||" + sName + "||" + sDescription  
    string sRemainsData = GetLocalString(oFixture, "GVD_REMAINS_DATA");
    int iSeperator = FindSubString(sRemainsData, "||");
    SetLocalString(oFixture, "GVD_REMAINS_RESREF_ITEM", GetStringLeft(sRemainsData, iSeperator));

    sRemainsData = GetStringRight(sRemainsData, GetStringLength(sRemainsData) - iSeperator - 2);
    iSeperator = FindSubString(sRemainsData, "||");
    SetLocalString(oFixture, "GVD_REMAINS_RESREF", GetStringLeft(sRemainsData, iSeperator));

    sRemainsData = GetStringRight(sRemainsData, GetStringLength(sRemainsData) - iSeperator - 2);
    iSeperator = FindSubString(sRemainsData, "||");
    SetLocalString(oFixture, "GVD_REMAINS_TAG", GetStringLeft(sRemainsData, iSeperator));

    sRemainsData = GetStringRight(sRemainsData, GetStringLength(sRemainsData) - iSeperator - 2);
    iSeperator = FindSubString(sRemainsData, "||");
    SetLocalInt(oFixture, "GS_SKILL", StringToInt(GetStringLeft(sRemainsData, iSeperator)));

    sRemainsData = GetStringRight(sRemainsData, GetStringLength(sRemainsData) - iSeperator - 2);
    iSeperator = FindSubString(sRemainsData, "||");
    int iRemainsTimestamp = StringToInt(GetStringLeft(sRemainsData, iSeperator));
    SetLocalInt(oFixture, "GVD_REMAINS_TIMESTAMP", iRemainsTimestamp);

    sRemainsData = GetStringRight(sRemainsData, GetStringLength(sRemainsData) - iSeperator - 2);
    iSeperator = FindSubString(sRemainsData, "||");
    SetLocalString(oFixture, "RESULT_1", GetStringLeft(sRemainsData, iSeperator));

    sRemainsData = GetStringRight(sRemainsData, GetStringLength(sRemainsData) - iSeperator - 2);
    iSeperator = FindSubString(sRemainsData, "||");
    SetLocalString(oFixture, "RESULT_2", GetStringLeft(sRemainsData, iSeperator));

    sRemainsData = GetStringRight(sRemainsData, GetStringLength(sRemainsData) - iSeperator - 2);
    iSeperator = FindSubString(sRemainsData, "||");
    SetLocalString(oFixture, "RESULT_3", GetStringLeft(sRemainsData, iSeperator));

    sRemainsData = GetStringRight(sRemainsData, GetStringLength(sRemainsData) - iSeperator - 2);
    iSeperator = FindSubString(sRemainsData, "||");
    SetLocalString(oFixture, "GVD_REMAINS_NAME", GetStringLeft(sRemainsData, iSeperator));

    sRemainsData = GetStringRight(sRemainsData, GetStringLength(sRemainsData) - iSeperator - 2);
    SetLocalString(oFixture, "GVD_REMAINS_DESCRIPTION", sRemainsData);

    // if the timestamp is older then 10 RL days, the fixture remains is lost forever so destroy it here
    int iTimestamp = GetLocalInt(GetModule(),"GS_TIMESTAMP");
    int iDaysOld = gsTIGetDay(gsTIGetRealTimestamp(iTimestamp) - gsTIGetRealTimestamp(iRemainsTimestamp));
    if (iDaysOld > 10) {
      WriteTimestampedLogEntry("FIXTURE REMAINS " + GetName(oFixture) + " in area " + GetTag(GetArea(oFixture)) + " auto-destroyed, not repaired within 10 RL days");
      gsFXDeleteFixture(GetTag(GetArea(oFixture)), oFixture);
      DestroyObject(oFixture);
    } else {
      // if the timestamp is older then 1 RL day, the remains is no longer flagged as plot, so it can be destroyed
      if (iDaysOld > 1) {
        SetPlotFlag(oFixture, 0);
      }
    }

  }

}
