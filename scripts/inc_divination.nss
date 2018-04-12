/*
  Name: inc_divination
  Author: Mithreas
  Date: 20 Dec 2009
  Description: Divination system.  In essence, this works as follows.
  - There are 6 elements - fire, water, earth, air, life, and death.
  - Players accrue fire points from hitting enemies in battle, water points
    from using disguise, pickpocket and trading (with NPCs or using shops),
    earth points from mining and crafting, air points from casting most spells,
    life points from casting healing spells and summoning animal companions, and
    death points from killing things and casting necromantic spells.
  - People with Divination spell focus can see which element people are most
    attuned to.
  - The Deck of Stars object can be used for divination.  The cards in the deck
    consist of a number of titles, such as Archmage.  The character on the
    server with the highest ratio in the element or elements favoured by the
    title will show up on the card as the current holder.  If they are logged
    in, then users of the deck can find out information about what they're up
    to at that time.  (Only PCs active in the last 7 days are counted).
  - most races and subraces are attuned to one or more elements and accrue
    points in that element faster.

  TODO
  - island wide events that can be predicted using the Deck of Stars.  Include
   - Orc raid on an inland/Underdark settlement
   - Dark moon - all spawns replaced by undead, fog added, lighting messed with
   - eclipse?  (lighting to pure black on all areas)
   - Northman raiders on a coastal settlement
   - earthquakes (UD, earth elementals and screen shakes)

  New columns in gs_pc_data:
  # Element point scores
  - fire
  - earth
  - water
  - air
  - life
  - death
  # Store a brief description of each PC so that diviners can get a description
  # on their cards.
  - subrace
  - gender
  - wings
  - bone_arm
  - hair_color
  - skin_color
*/
#include "inc_log"
#include "inc_subrace"
#include "inc_relations"
#include "inc_weather"
const string DIVINATION = "DIVINATION";

const string ELEMENT_FIRE  = "Fire";
const string ELEMENT_WATER = "Water";
const string ELEMENT_EARTH = "Earth";
const string ELEMENT_AIR   = "Air";
const string ELEMENT_LIFE  = "Life";
const string ELEMENT_DEATH = "Death";
const string LAST_GAINED   = "LAST_GAINED";

const string ASPECT_WARLORD     = "ASPECT_WARLORD";     // Fire
const string ASPECT_ARCHMAGE    = "ASPECT_ARCHMAGE";    // Air
const string ASPECT_CRAFTSMAN   = "ASPECT_CRAFTSMAN";   // Earth
const string ASPECT_DECEIVER    = "ASPECT_DECEIVER";    // Water
const string ASPECT_LIFEBRINGER = "ASPECT_LIFEBRINGER"; // Life
const string ASPECT_DEATHSHAND  = "ASPECT_DEATHSHAND";  // Death
const string ASPECT_SMITH       = "ASPECT_SMITH";       // Fire/Earth
const string ASPECT_SLAYER      = "ASPECT_SLAYER";      // Fire/Water
const string ASPECT_BATTLEMAGE  = "ASPECT_BATTLEMAGE";  // Fire/Air
const string ASPECT_MERCHANT    = "ASPECT_MERCHANT";    // Earth/Water
const string ASPECT_NURTURER    = "ASPECT_NURTURER";    // Earth/Life
const string ASPECT_TRICKSTER   = "ASPECT_TRICKSTER";   // Air/Water
const string ASPECT_PROVIDER    = "ASPECT_PROVIDER";    // Water/Life
const string ASPECT_SOULSTEALER = "ASPECT_SOULSTEALER"; // Air/Death
const string ASPECT_JUDGE       = "ASPECT_JUDGE";       // Life/Death
const string ASPECT_ARTIFICER   = "ASPECT_ARTIFICER";   // Earth/Air
const string ASPECT_SCOURGE     = "ASPECT_SCOURGE";     // Fire/Death
const string ASPECT_TEMPLAR     = "ASPECT_TEMPLAR";     // Fire/Life
const string ASPECT_SHAMAN      = "ASPECT_SHAMAN";      // Air/Life
const string ASPECT_UNDERTAKER  = "ASPECT_UNDERTAKER";  // Earth/Death

// Get aspect description.  sAspect should be an ASPECT_* constant. Returns ""
// on error.
string miDVGetAspectDescription(string sAspect);
// Get the racial adjustment to use for oPC when incrementing their score.
float miDVGetMultiplier(object oPC, string sElement);
// Give nPoints in sElement to oPC.  Method will adjust for race automagically.
void miDVGivePoints(object oPC, string sElement, float fPoints);
// Sync oPC's current score to the database.
void miDVSavePoints(object oPC);
// Call on module startup and maybe occasionally afterwards to update the faces
// on the various cards.
void miDVShuffleDeck();
// View the card representing sAspect.  If oPlayer is not a diviner, won't work.
string miDVViewCard(object oPlayer, string sAspect);
// oPlayer lays a field of cards - this will show what the PCs represented by
// the cards are doing.  oPlayer must be a seer.
void miDVLayField(object oPlayer);
// Internal method used as part of miDVLayField.
string miDVGetAreaInfo(object oPC);
// Return the ASPECT_* that oPC fulfils, if any.  Returns "" if none.
string miDVGetAspect(object oPC);
// Return the element oPC is most strongly attuned to.
string miDVGetAttunement(object oPC);
// Send a message to oDM with the IDs of the holders of each rank.
void miDVListAspectsForDM(object oDM);
// Send a message to oDM with the Element values of the target PC.
void batDVListElementsForDM(object oDM, object oTarget);

string miDVGetAspectDescription(string sAspect)
{
  if (sAspect == "") return "";
  if (sAspect == ASPECT_WARLORD) return ("a torn battle-standard");
  if (sAspect == ASPECT_ARCHMAGE) return ("a silvered and jeweled staff");
  if (sAspect == ASPECT_CRAFTSMAN) return ("a hammer and nails");
  if (sAspect == ASPECT_LIFEBRINGER) return ("a nimbus of soft blue light");
  if (sAspect == ASPECT_DEATHSHAND) return ("a dried skull");
  if (sAspect == ASPECT_SMITH) return ("an well-beaten anvil");
  if (sAspect == ASPECT_SLAYER) return ("a wickedly curved dagger");
  if (sAspect == ASPECT_BATTLEMAGE) return ("a nimbus of flame");
  if (sAspect == ASPECT_MERCHANT) return ("a glinting golden coin");
  if (sAspect == ASPECT_NURTURER) return ("a healthy green leaf");
  if (sAspect == ASPECT_TRICKSTER) return ("a mirror suspended in smoke");
  if (sAspect == ASPECT_PROVIDER) return ("a mug of cool ale");
  if (sAspect == ASPECT_SOULSTEALER) return ("an ominous mist");
  if (sAspect == ASPECT_JUDGE) return ("a bundle of fasces");
  if (sAspect == ASPECT_DECEIVER) return ("a glass theatre masque");
  if (sAspect == ASPECT_ARTIFICER) return ("a halo of clockwork");
  if (sAspect == ASPECT_SCOURGE) return ("a pyre's corpsesmoke cloud");
  if (sAspect == ASPECT_TEMPLAR) return ("a sword burning with light");
  if (sAspect == ASPECT_SHAMAN) return ("a mass of charms and feathers");
  if (sAspect == ASPECT_UNDERTAKER) return ("a grave marker");

  return "";
}
float miDVGetMultiplier(object oPC, string sElement)
{
  Trace(DIVINATION, "Getting multiplier for " + GetName(oPC) + " and " + sElement);
  int nRace = GetRacialType(oPC);
  int nSubrace = gsSUGetSubRaceByName(GetSubRace(oPC));
  float fMultiplier = 1.0;

  switch (nSubrace)
  {
    case GS_SU_PLANETOUCHED_GENASI_AIR:
      if (sElement == ELEMENT_AIR) fMultiplier = 1.2;
      break;
    case GS_SU_PLANETOUCHED_GENASI_EARTH:
      if (sElement == ELEMENT_EARTH) fMultiplier = 1.2;
      break;
    case GS_SU_PLANETOUCHED_GENASI_FIRE:
    case GS_SU_SPECIAL_IMP:
      if (sElement == ELEMENT_FIRE) fMultiplier = 1.2;
      break;
    case GS_SU_PLANETOUCHED_GENASI_WATER:
      if (sElement == ELEMENT_WATER) fMultiplier = 1.2;
      break;
    case GS_SU_PLANETOUCHED_TIEFLING:
      if (sElement == ELEMENT_FIRE || sElement == ELEMENT_WATER) fMultiplier = 1.1;
      break;
    case GS_SU_SPECIAL_FEY:
      if (sElement == ELEMENT_LIFE) fMultiplier = 1.2;
      break;
    case GS_SU_SPECIAL_GOBLIN:
    case GS_SU_SPECIAL_HOBGOBLIN:
      if (sElement == ELEMENT_WATER || sElement == ELEMENT_DEATH) fMultiplier = 1.1;
      break;
    case GS_SU_SPECIAL_KOBOLD:
      if (sElement == ELEMENT_EARTH || sElement == ELEMENT_AIR) fMultiplier = 1.1;
      break;
    case GS_SU_SPECIAL_RAKSHASA:
      if (sElement == ELEMENT_WATER || sElement == ELEMENT_AIR) fMultiplier = 1.3;
      break;
    case GS_SU_SPECIAL_DRAGON:
      if (sElement == ELEMENT_EARTH || sElement == ELEMENT_FIRE) fMultiplier = 1.3;
      break;
    case GS_SU_SPECIAL_VAMPIRE:
      if (sElement == ELEMENT_DEATH) fMultiplier = 1.3;
      break;
    case GS_SU_SPECIAL_OGRE:
      if (sElement == ELEMENT_FIRE || sElement == ELEMENT_DEATH) fMultiplier = 1.2;
      break;
    case GS_SU_DEEP_IMASKARI:
      if (sElement == ELEMENT_AIR) fMultiplier = 1.4;
      break;
    case GS_SU_DWARF_WILD:
      if (sElement == ELEMENT_EARTH || sElement == ELEMENT_WATER) fMultiplier = 1.1;
      break;
  }

  if (fMultiplier != 1.0) return fMultiplier;

  switch (nRace)
  {
    case RACIAL_TYPE_DWARF:
      if (sElement == ELEMENT_EARTH || sElement == ELEMENT_FIRE) fMultiplier = 1.1;
      break;
    case RACIAL_TYPE_ELF:
      if (sElement == ELEMENT_AIR) fMultiplier = 1.2;
      break;
    case RACIAL_TYPE_GNOME:
      if (sElement == ELEMENT_EARTH || sElement == ELEMENT_AIR) fMultiplier = 1.2;
      break;
    case RACIAL_TYPE_HALFELF:
      if (sElement == ELEMENT_AIR) fMultiplier = 1.1;
      break;
    case RACIAL_TYPE_HALFLING:
      if (sElement == ELEMENT_EARTH || sElement == ELEMENT_WATER) fMultiplier = 1.1;
      break;
    case RACIAL_TYPE_HALFORC:
      if (sElement == ELEMENT_FIRE || sElement == ELEMENT_DEATH) fMultiplier = 1.1;
      break;
    case RACIAL_TYPE_HUMAN:
      break;
  }

  return fMultiplier;
}

void miDVGivePoints(object oPC, string sElement, float fPoints)
{
  Trace(DIVINATION, "Giving " + FloatToString(fPoints) + " to " + GetName(oPC) +
          " in element " + sElement);

  fPoints *= miDVGetMultiplier(oPC, sElement);

  object oHide = gsPCGetCreatureHide(oPC);
  SetLocalFloat(oHide, sElement, GetLocalFloat(oHide, sElement) + fPoints);
  SetLocalString(oHide, LAST_GAINED, sElement);
}

void miDVSavePoints(object oPC)
{
  Trace(DIVINATION, "Syncing player scores to database for " + GetName(oPC));
  object oHide = gsPCGetCreatureHide(oPC);

  SQLExecStatement("UPDATE gs_pc_data SET fire=?,earth=?,water=?,air=?,life=?,death=? where id=?",
   FloatToString(GetLocalFloat(oHide, ELEMENT_FIRE) + 1.0),
   FloatToString(GetLocalFloat(oHide, ELEMENT_EARTH) + 1.0),
   FloatToString(GetLocalFloat(oHide, ELEMENT_WATER) + 1.0),
   FloatToString(GetLocalFloat(oHide, ELEMENT_AIR) + 1.0),
   FloatToString(GetLocalFloat(oHide, ELEMENT_LIFE) + 1.0),
   FloatToString(GetLocalFloat(oHide, ELEMENT_DEATH) + 1.0),
   gsPCGetPlayerID(oPC));
}

void miDVShuffleDeck()
{
  Trace(DIVINATION, "Shuffling the Deck of Stars");

  // Primary cards: warlord (fire), archmage (air), craftsman (earth), deceiver
  // (water), death's hand (death), lifebringer (life).
  string sWarlord;
  string sArchmage;
  string sCraftsman;
  string sDeceiver;
  string sDeathHand;
  string sLifebringer;
  SQLExecStatement("SELECT id FROM gs_pc_data WHERE modified > (DATE_SUB(CURDATE(),INTERVAL 7 DAY)) ORDER BY (fire+100)/(fire+air+earth+water+life+death+600) DESC, fire DESC LIMIT 1");
  if (SQLFetch()) sWarlord = SQLGetData(1);
  SQLExecStatement("SELECT id FROM gs_pc_data WHERE modified > (DATE_SUB(CURDATE(),INTERVAL 7 DAY)) ORDER BY (air+100)/(fire+air+earth+water+life+death+600) DESC, air DESC LIMIT 1");
  if (SQLFetch()) sArchmage = SQLGetData(1);
  SQLExecStatement("SELECT id FROM gs_pc_data WHERE modified > (DATE_SUB(CURDATE(),INTERVAL 7 DAY)) ORDER BY (earth+100)/(fire+air+earth+water+life+death+600) DESC, earth DESC LIMIT 1");
  if (SQLFetch()) sCraftsman = SQLGetData(1);
  SQLExecStatement("SELECT id FROM gs_pc_data WHERE modified > (DATE_SUB(CURDATE(),INTERVAL 7 DAY)) ORDER BY (water+100)/(fire+air+earth+water+life+death+600) DESC, water DESC LIMIT 1");
  if (SQLFetch()) sDeceiver = SQLGetData(1);
  SQLExecStatement("SELECT id FROM gs_pc_data WHERE modified > (DATE_SUB(CURDATE(),INTERVAL 7 DAY)) ORDER BY (life+100)/(fire+air+earth+water+life+death+600) DESC, life DESC LIMIT 1");
  if (SQLFetch()) sLifebringer = SQLGetData(1);
  SQLExecStatement("SELECT id FROM gs_pc_data WHERE modified > (DATE_SUB(CURDATE(),INTERVAL 7 DAY)) ORDER BY (death+100)/(fire+air+earth+water+life+death+600) DESC, death DESC LIMIT 1");
  if (SQLFetch()) sDeathHand = SQLGetData(1);

  // Secondary cards: smith (fire/earth), slayer (fire/death), battlemage (fire/air),
  // merchant (earth/water), nurturer (earth/life), trickster (water/air),
  // provider (water/life), soul stealer (air/death), judge (life/death)
  string sSmith;
  string sSlayer;
  string sBattlemage;
  string sMerchant;
  string sNurturer;
  string sTrickster;
  string sProvider;
  string sSoulStealer;
  string sJudge;
  string sArtificer;
  string sScourge;
  string sTemplar;
  string sShaman;
  string sUndertaker;
  SQLExecStatement("SELECT id FROM gs_pc_data WHERE modified > (DATE_SUB(CURDATE(),INTERVAL 7 DAY)) ORDER BY (fire+earth+200)/(fire+air+earth+water+life+death+600) DESC, (fire+earth) DESC LIMIT 1");
  if (SQLFetch()) sSmith = SQLGetData(1);
  SQLExecStatement("SELECT id FROM gs_pc_data WHERE modified > (DATE_SUB(CURDATE(),INTERVAL 7 DAY)) ORDER BY (fire+water+200)/(fire+air+earth+water+life+death+600) DESC, (fire+water) DESC LIMIT 1");
  if (SQLFetch()) sSlayer = SQLGetData(1);
  SQLExecStatement("SELECT id FROM gs_pc_data WHERE modified > (DATE_SUB(CURDATE(),INTERVAL 7 DAY)) ORDER BY (fire+air+200)/(fire+air+earth+water+life+death+600) DESC, (fire+air) DESC LIMIT 1");
  if (SQLFetch()) sBattlemage = SQLGetData(1);
  SQLExecStatement("SELECT id FROM gs_pc_data WHERE modified > (DATE_SUB(CURDATE(),INTERVAL 7 DAY)) ORDER BY (earth+water+200)/(fire+air+earth+water+life+death+600) DESC, (earth+water) DESC LIMIT 1");
  if (SQLFetch()) sMerchant = SQLGetData(1);
  SQLExecStatement("SELECT id FROM gs_pc_data WHERE modified > (DATE_SUB(CURDATE(),INTERVAL 7 DAY)) ORDER BY (earth+life+200)/(fire+air+earth+water+life+death+600) DESC, (earth+life) DESC LIMIT 1");
  if (SQLFetch()) sNurturer = SQLGetData(1);
  SQLExecStatement("SELECT id FROM gs_pc_data WHERE modified > (DATE_SUB(CURDATE(),INTERVAL 7 DAY)) ORDER BY (water+air+200)/(fire+air+earth+water+life+death+600) DESC, (water+air) DESC LIMIT 1");
  if (SQLFetch()) sTrickster = SQLGetData(1);
  SQLExecStatement("SELECT id FROM gs_pc_data WHERE modified > (DATE_SUB(CURDATE(),INTERVAL 7 DAY)) ORDER BY (water+life+200)/(fire+air+earth+water+life+death+600) DESC, (water+life) DESC LIMIT 1");
  if (SQLFetch()) sProvider = SQLGetData(1);
  SQLExecStatement("SELECT id FROM gs_pc_data WHERE modified > (DATE_SUB(CURDATE(),INTERVAL 7 DAY)) ORDER BY (air+death+200)/(fire+air+earth+water+life+death+600) DESC, (air+death) DESC LIMIT 1");
  if (SQLFetch()) sSoulStealer = SQLGetData(1);
  SQLExecStatement("SELECT id FROM gs_pc_data WHERE modified > (DATE_SUB(CURDATE(),INTERVAL 7 DAY)) ORDER BY (life+death+200)/(fire+air+earth+water+life+death+600) DESC, (life+death) DESC LIMIT 1");
  if (SQLFetch()) sJudge = SQLGetData(1);
  SQLExecStatement("SELECT id FROM gs_pc_data WHERE modified > (DATE_SUB(CURDATE(),INTERVAL 7 DAY)) ORDER BY (air+earth+200)/(fire+air+earth+water+life+death+600) DESC, (air+earth) DESC LIMIT 1");
  if (SQLFetch()) sArtificer = SQLGetData(1);
  SQLExecStatement("SELECT id FROM gs_pc_data WHERE modified > (DATE_SUB(CURDATE(),INTERVAL 7 DAY)) ORDER BY (fire+death+200)/(fire+air+earth+water+life+death+600) DESC, (fire+death) DESC LIMIT 1");
  if (SQLFetch()) sScourge = SQLGetData(1);
  SQLExecStatement("SELECT id FROM gs_pc_data WHERE modified > (DATE_SUB(CURDATE(),INTERVAL 7 DAY)) ORDER BY (fire+life+200)/(fire+air+earth+water+life+death+600) DESC, (fire+air) DESC LIMIT 1");
  if (SQLFetch()) sTemplar = SQLGetData(1);
  SQLExecStatement("SELECT id FROM gs_pc_data WHERE modified > (DATE_SUB(CURDATE(),INTERVAL 7 DAY)) ORDER BY (air+life+200)/(fire+air+earth+water+life+death+600) DESC, (air+life) DESC LIMIT 1");
  if (SQLFetch()) sShaman = SQLGetData(1);
  SQLExecStatement("SELECT id FROM gs_pc_data WHERE modified > (DATE_SUB(CURDATE(),INTERVAL 7 DAY)) ORDER BY (earth+death+200)/(fire+air+earth+water+life+death+600) DESC, (earth+death) DESC LIMIT 1");
  if (SQLFetch()) sUndertaker = SQLGetData(1);

  SetLocalString(GetModule(), ASPECT_WARLORD, sWarlord);
  SetLocalString(GetModule(), ASPECT_ARCHMAGE, sArchmage);
  SetLocalString(GetModule(), ASPECT_CRAFTSMAN, sCraftsman);
  SetLocalString(GetModule(), ASPECT_DECEIVER, sDeceiver);
  SetLocalString(GetModule(), ASPECT_LIFEBRINGER, sLifebringer);
  SetLocalString(GetModule(), ASPECT_DEATHSHAND, sDeathHand);
  SetLocalString(GetModule(), ASPECT_SMITH, sSmith);
  SetLocalString(GetModule(), ASPECT_SLAYER, sSlayer);
  SetLocalString(GetModule(), ASPECT_BATTLEMAGE, sBattlemage);
  SetLocalString(GetModule(), ASPECT_MERCHANT, sMerchant);
  SetLocalString(GetModule(), ASPECT_NURTURER, sNurturer);
  SetLocalString(GetModule(), ASPECT_TRICKSTER, sTrickster);
  SetLocalString(GetModule(), ASPECT_PROVIDER, sProvider);
  SetLocalString(GetModule(), ASPECT_SOULSTEALER, sSoulStealer);
  SetLocalString(GetModule(), ASPECT_JUDGE, sJudge);
  SetLocalString(GetModule(), ASPECT_ARTIFICER, sArtificer);
  SetLocalString(GetModule(), ASPECT_SCOURGE, sScourge);
  SetLocalString(GetModule(), ASPECT_TEMPLAR, sTemplar);
  SetLocalString(GetModule(), ASPECT_SHAMAN, sShaman);
  SetLocalString(GetModule(), ASPECT_UNDERTAKER, sUndertaker);
}

string _miDVGetHairDescription(string sColor)
{
  if (sColor == "NULL") return "";
  int nColor = StringToInt(sColor);

  string sDesc = "";

  switch (nColor)
  {
    case 0:
    case 1:
    case 2:
    case 3:
    case 12:
    case 13:
    case 14:
    case 15:
    case 116:
    case 117:
    case 118:
    case 119:
    case 125:
    case 126:
    case 127:
    case 128:
    case 129:
    case 130:
    case 131:
    case 156:
    case 157:
    case 173:
      sDesc = "brown-haired ";
      break;
    case 4:
    case 5:
    case 6:
    case 7:
    case 53:
    case 88:
    case 89:
    case 90:
    case 91:
    case 100:
    case 101:
    case 102:
    case 103:
      sDesc = "red-haired ";
      break;
    case 8:
    case 9:
    case 10:
    case 11:
    case 48:
    case 58:
    case 62:
      sDesc = "fair-haired ";
      break;
    case 21:
    case 22:
    case 23:
    case 47:
    case 63:
    case 115:
    case 135:
    case 167:
    case 171:
      sDesc = "dark-haired ";
      break;
    case 16:
    case 17:
    case 18:
    case 19:
    case 56:
    case 60:
    case 164:
    case 166:
      sDesc = "white-haired ";
      break;
  }

  return sDesc;
}

string _miDVGetSkinDescription(string sColor)
{
  if (sColor == "NULL") return "";
  int nColor = StringToInt(sColor);

  string sDesc = "";

  switch (nColor)
  {
    case 0:
    case 1:
    case 2:
    case 8:
    case 9:
    case 12:
    case 16:
    case 128:
      sDesc = "pale-skinned ";
      break;
    case 3:
    case 4:
    case 13:
      sDesc = "tanned ";
      break;
    case 5:
    case 6:
    case 7:
      sDesc = "dark-skinned ";
      break;
    case 18:
    case 19:
    case 28:
    case 29:
    case 40:
    case 41:
    case 42:
    case 43:
    case 62:
      sDesc = "grey-skinned ";
      break;
    case 30:
    case 31:
    case 63:
      sDesc = "black-skinned ";
      break;
  }

  return sDesc;
}

string miDVGetDescription(string sPCID)
{
  SQLExecStatement("SELECT subrace,gender,wings,bone_arm,hair_color,skin_color FROM gs_pc_data WHERE id=?", sPCID);
  string sDesc = "";

  if (SQLFetch())
  {
    sDesc = _miDVGetHairDescription(SQLGetData(5)) + _miDVGetSkinDescription(SQLGetData(6));
    sDesc += GetStringLowerCase(SQLGetData(2)) + " " + GetStringLowerCase(SQLGetData(1));
    if (StringToInt(SQLGetData(3))) sDesc += " with the wings of a dragon";
    else if (StringToInt(SQLGetData(4))) sDesc += " holding an orb in the bony fingers of one fleshless hand";
  }

  return sDesc;
}

string miDVViewCard(object oPlayer, string sAspect)
{
  string sMessage = "";

  if (!GetHasFeat(FEAT_SPELL_FOCUS_DIVINATION, oPlayer))
  {
    sMessage = "You are not a seer, the card reveals nothing to you.";
  }
  else
  {
    string sPCID = GetLocalString(GetModule(), sAspect);
    sMessage = "It depicts the Aspect: a " + miDVGetDescription(sPCID);

    string sFriend = miREGetBestFriend(sPCID);
    if (sFriend != "") sMessage += ", closely flanked by a " + miDVGetDescription(sFriend);

    string sEnemy = miREGetWorstEnemy(sPCID);
    if (sEnemy != "") sMessage += ".  A " + miDVGetDescription(sEnemy) + " looms behind the Aspect menacingly.";
  }

  return sMessage;
}

void miDVLayField(object oPlayer)
{
  int nFetch = 0;
  object oPC;

  if (!GetHasFeat(FEAT_SPELL_FOCUS_DIVINATION, oPlayer))
  {
    AssignCommand(oPlayer, ActionSpeakString("You are not a seer; every card you draw is blank."));
    return;
  }

  // Check for PCs active on other servers.  Rather than doing 15 queries, we
  // just do a single one to look for generic activity, and hint to it.
  string sWarlord     = GetLocalString(GetModule(), ASPECT_WARLORD);
  string sArchmage    = GetLocalString(GetModule(), ASPECT_ARCHMAGE);
  string sCraftsman   = GetLocalString(GetModule(), ASPECT_CRAFTSMAN);
  string sDeceiver    = GetLocalString(GetModule(), ASPECT_DECEIVER);
  string sLifebringer = GetLocalString(GetModule(), ASPECT_LIFEBRINGER);
  string sDeathsHand  = GetLocalString(GetModule(), ASPECT_DEATHSHAND);
  string sSmith       = GetLocalString(GetModule(), ASPECT_SMITH);
  string sSlayer      = GetLocalString(GetModule(), ASPECT_SLAYER);
  string sBattlemage  = GetLocalString(GetModule(), ASPECT_BATTLEMAGE);
  string sMerchant    = GetLocalString(GetModule(), ASPECT_MERCHANT);
  string sNurturer    = GetLocalString(GetModule(), ASPECT_NURTURER);
  string sTrickster   = GetLocalString(GetModule(), ASPECT_TRICKSTER);
  string sProvider    = GetLocalString(GetModule(), ASPECT_PROVIDER);
  string sSoulStealer = GetLocalString(GetModule(), ASPECT_SOULSTEALER);
  string sJudge       = GetLocalString(GetModule(), ASPECT_JUDGE);
  string sArtificer   = GetLocalString(GetModule(), ASPECT_ARTIFICER);
  string sTemplar     = GetLocalString(GetModule(), ASPECT_TEMPLAR);
  string sScourge     = GetLocalString(GetModule(), ASPECT_SCOURGE);
  string sShaman      = GetLocalString(GetModule(), ASPECT_SHAMAN);
  string sUndertaker  = GetLocalString(GetModule(), ASPECT_UNDERTAKER);

  SQLExecStatement("SELECT pcid FROM mixf_currentplayers WHERE pcid IN (?,?,?,?,?,?)",
  sWarlord, sArchmage, sCraftsman, sDeceiver, sLifebringer, sDeathsHand, sSmith);

  if (SQLFetch())
  {
    nFetch = 1;

    oPC = gsPCGetPlayerByID(sWarlord);
    if(GetIsObjectValid(oPC))
    {
      string sElement = GetLocalString(gsPCGetCreatureHide(oPC), LAST_GAINED);
      AssignCommand(oPlayer, ActionSpeakString("The Warlord card plays under " + sElement +
       miDVGetAreaInfo(oPC) + miDVViewCard(oPlayer, ASPECT_WARLORD)));
    }

    oPC = gsPCGetPlayerByID(sArchmage);
    if(GetIsObjectValid(oPC))
    {
      string sElement = GetLocalString(gsPCGetCreatureHide(oPC), LAST_GAINED);
      AssignCommand(oPlayer, ActionSpeakString("The Archmage card plays under " + sElement +
       miDVGetAreaInfo(oPC) + miDVViewCard(oPlayer, ASPECT_ARCHMAGE)));
    }

    oPC = gsPCGetPlayerByID(sCraftsman);
    if(GetIsObjectValid(oPC))
    {
      string sElement = GetLocalString(gsPCGetCreatureHide(oPC), LAST_GAINED);
      AssignCommand(oPlayer, ActionSpeakString("The Craftsman card plays under " + sElement +
       miDVGetAreaInfo(oPC) + miDVViewCard(oPlayer, ASPECT_CRAFTSMAN)));
    }

    oPC = gsPCGetPlayerByID(sDeceiver);
    if(GetIsObjectValid(oPC))
    {
      string sElement = GetLocalString(gsPCGetCreatureHide(oPC), LAST_GAINED);
      AssignCommand(oPlayer, ActionSpeakString("The Deceiver card plays under " + sElement +
       miDVGetAreaInfo(oPC) + miDVViewCard(oPlayer, ASPECT_DECEIVER)));
    }

    oPC = gsPCGetPlayerByID(sLifebringer);
    if(GetIsObjectValid(oPC))
    {
      string sElement = GetLocalString(gsPCGetCreatureHide(oPC), LAST_GAINED);
      AssignCommand(oPlayer, ActionSpeakString("The Lifebringer card plays under " + sElement +
       miDVGetAreaInfo(oPC) + miDVViewCard(oPlayer, ASPECT_LIFEBRINGER)));
    }

    oPC = gsPCGetPlayerByID(sDeathsHand);
    if(GetIsObjectValid(oPC))
    {
      string sElement = GetLocalString(gsPCGetCreatureHide(oPC), LAST_GAINED);
      AssignCommand(oPlayer, ActionSpeakString("The Death's Hand card plays under " + sElement +
       miDVGetAreaInfo(oPC) + miDVViewCard(oPlayer, ASPECT_DEATHSHAND)));
    }
  }
  
  SQLExecStatement("SELECT pcid FROM mixf_currentplayers WHERE pcid IN (?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
  sSmith, sSlayer, sBattlemage, sMerchant, sNurturer, sTrickster, sProvider,
  sSoulStealer, sJudge, sArtificer, sTemplar, sScourge, sShaman, sUndertaker);

  if (!SQLFetch() && nFetch == 0)
  {
    ActionSpeakString("All the cards are blank.  The deck feels dull and lifeless.");
    return;
  }

  else
  {
    oPC = gsPCGetPlayerByID(sSmith);
    if(GetIsObjectValid(oPC))
    {
      string sElement = GetLocalString(gsPCGetCreatureHide(oPC), LAST_GAINED);
      AssignCommand(oPlayer, ActionSpeakString("The Smith card plays under " + sElement +
       miDVGetAreaInfo(oPC) + miDVViewCard(oPlayer, ASPECT_SMITH)));
    }

    oPC = gsPCGetPlayerByID(sSlayer);
    if(GetIsObjectValid(oPC))
    {
      string sElement = GetLocalString(gsPCGetCreatureHide(oPC), LAST_GAINED);
      AssignCommand(oPlayer, ActionSpeakString("The Slayer card plays under " + sElement +
       miDVGetAreaInfo(oPC) + miDVViewCard(oPlayer, ASPECT_SLAYER)));
    }

    oPC = gsPCGetPlayerByID(sBattlemage);
    if(GetIsObjectValid(oPC))
    {
      string sElement = GetLocalString(gsPCGetCreatureHide(oPC), LAST_GAINED);
      AssignCommand(oPlayer, ActionSpeakString("The Battlemage card plays under " + sElement +
       miDVGetAreaInfo(oPC) + miDVViewCard(oPlayer, ASPECT_BATTLEMAGE)));
    }

    oPC = gsPCGetPlayerByID(sMerchant);
    if(GetIsObjectValid(oPC))
    {
      string sElement = GetLocalString(gsPCGetCreatureHide(oPC), LAST_GAINED);
      AssignCommand(oPlayer, ActionSpeakString("The Merchant card plays under " + sElement +
       miDVGetAreaInfo(oPC) + miDVViewCard(oPlayer, ASPECT_MERCHANT)));
    }

    oPC = gsPCGetPlayerByID(sNurturer);
    if(GetIsObjectValid(oPC))
    {
      string sElement = GetLocalString(gsPCGetCreatureHide(oPC), LAST_GAINED);
      AssignCommand(oPlayer, ActionSpeakString("The Nurturer card plays under " + sElement +
       miDVGetAreaInfo(oPC) + miDVViewCard(oPlayer, ASPECT_NURTURER)));
    }

    oPC = gsPCGetPlayerByID(sTrickster);
    if(GetIsObjectValid(oPC))
    {
      string sElement = GetLocalString(gsPCGetCreatureHide(oPC), LAST_GAINED);
      AssignCommand(oPlayer, ActionSpeakString("The Trickster card plays under " + sElement +
       miDVGetAreaInfo(oPC) + miDVViewCard(oPlayer, ASPECT_TRICKSTER)));
    }

    oPC = gsPCGetPlayerByID(sProvider);
    if(GetIsObjectValid(oPC))
    {
      string sElement = GetLocalString(gsPCGetCreatureHide(oPC), LAST_GAINED);
      AssignCommand(oPlayer, ActionSpeakString("The Provider card plays under " + sElement +
       miDVGetAreaInfo(oPC) + miDVViewCard(oPlayer, ASPECT_PROVIDER)));
    }

    oPC = gsPCGetPlayerByID(sSoulStealer);
    if(GetIsObjectValid(oPC))
    {
      string sElement = GetLocalString(gsPCGetCreatureHide(oPC), LAST_GAINED);
      AssignCommand(oPlayer, ActionSpeakString("The Soulstealer card plays under " + sElement +
       miDVGetAreaInfo(oPC) + miDVViewCard(oPlayer, ASPECT_SOULSTEALER)));
    }

    oPC = gsPCGetPlayerByID(sJudge);
    if(GetIsObjectValid(oPC))
    {
      string sElement = GetLocalString(gsPCGetCreatureHide(oPC), LAST_GAINED);
      AssignCommand(oPlayer, ActionSpeakString("The Judge card plays under " + sElement +
       miDVGetAreaInfo(oPC) + miDVViewCard(oPlayer, ASPECT_JUDGE)));
    }

    oPC = gsPCGetPlayerByID(sArtificer);
    if(GetIsObjectValid(oPC))
    {
      string sElement = GetLocalString(gsPCGetCreatureHide(oPC), LAST_GAINED);
      AssignCommand(oPlayer, ActionSpeakString("The Artificer card plays under " + sElement +
       miDVGetAreaInfo(oPC) + miDVViewCard(oPlayer, ASPECT_ARTIFICER)));
    }

    oPC = gsPCGetPlayerByID(sScourge);
    if(GetIsObjectValid(oPC))
    {
      string sElement = GetLocalString(gsPCGetCreatureHide(oPC), LAST_GAINED);
      AssignCommand(oPlayer, ActionSpeakString("The Scourge card plays under " + sElement +
       miDVGetAreaInfo(oPC) + miDVViewCard(oPlayer, ASPECT_SCOURGE)));
    }

    oPC = gsPCGetPlayerByID(sTemplar);
    if(GetIsObjectValid(oPC))
    {
      string sElement = GetLocalString(gsPCGetCreatureHide(oPC), LAST_GAINED);
      AssignCommand(oPlayer, ActionSpeakString("The Templar card plays under " + sElement +
       miDVGetAreaInfo(oPC) + miDVViewCard(oPlayer, ASPECT_TEMPLAR)));
    }

    oPC = gsPCGetPlayerByID(sShaman);
    if(GetIsObjectValid(oPC))
    {
      string sElement = GetLocalString(gsPCGetCreatureHide(oPC), LAST_GAINED);
      AssignCommand(oPlayer, ActionSpeakString("The Shaman card plays under " + sElement +
       miDVGetAreaInfo(oPC) + miDVViewCard(oPlayer, ASPECT_JUDGE)));
    }

    oPC = gsPCGetPlayerByID(sUndertaker);
    if(GetIsObjectValid(oPC))
    {
      string sElement = GetLocalString(gsPCGetCreatureHide(oPC), LAST_GAINED);
      AssignCommand(oPlayer, ActionSpeakString("The Undertaker card plays under " + sElement +
       miDVGetAreaInfo(oPC) + miDVViewCard(oPlayer, ASPECT_JUDGE)));
    }
  }

  

  AssignCommand(oPlayer, ActionSpeakString("All the remaining cards are blurred and indistinct."));
}

string miDVGetAreaInfo(object oPC)
{
  object oArea = GetArea(oPC);

  if (GetIsAreaInterior(oArea))
  {
    return ", you can vaguely make out the lines of a wall and roof in the background. ";
  }
  else if (!GetIsAreaAboveGround(oArea))
  {
    return " in a dingy cave. ";
  }

  int nHeat     = miWHGetHeatIndex(oArea);
  int nHumidity = miWHGetHumidity(oArea);
  int nWind     = miWHGetWindStrength(oArea);
  int bStormy   = GetSkyBox(oArea) == SKYBOX_GRASS_STORM;
  int bAcidRain = GetLocalInt(oArea, VAR_WEATHER_ACID_RAIN);

  // Stormy
  if (bStormy) return " under a storm-wracked sky. ";

  // Acid rain
  else if (bAcidRain) return " under a virulent green sky, the card sizzling slightly! ";

  else if (nHumidity > 7 && nHeat > 3)
  {
    // Misty
    if (nWind < 3) return " under a damp, misty sky. ";
    // Rainy, hot
    else if (nHeat > 7) return " under a sky of steaming rainfall, the card warm to the touch. ";
    // Rainy, normal
    else return " under a rainy sky. ";
  }

  // Cold, snowing
  else if (nHumidity > 7) return " under a snow-flecked sky, the card cool to the touch. ";

  // Freezing
  else if (nHeat < 3) return " under a frozen, ice-hued sky, the card cold to the touch. ";

  // Boiling
  else if (nHeat > 8) return " under a burning, hazy sky, the card hot to the touch. ";

  // Cold (mild, cloudy, foggy)
  else if (nHeat < 5)
  {
    if (nWind < 5)      return " under clear skies, the card cool to the touch. ";
    else if (nWind < 8) return " under a cloudy sky, the card cool to the touch. ";
    else                return " under a sky wreathed with fog, the card cool to the touch. ";
  }
  // Hot (mild, cloudy, foggy)
  else if (nHeat > 6)
  {
    if (nWind < 5)      return " under clear skies, the card warm to the touch. ";
    else if (nWind < 8) return " under a cloudy sky, the card warm to the touch. ";
    else                return " under a sky wreathed with fog, the card warm to the touch. ";
  }
  // Mild
  else if (nWind < 5) return " under a beautiful, open sky. ";
  else if (nWind < 8) return " under a cloudy sky. ";
  else                return " under a sky wreathed with fog. ";
}

string miDVGetAspect(object oPC)
{
  string sWarlord     = GetLocalString(GetModule(), ASPECT_WARLORD);
  string sArchmage    = GetLocalString(GetModule(), ASPECT_ARCHMAGE);
  string sCraftsman   = GetLocalString(GetModule(), ASPECT_CRAFTSMAN);
  string sDeceiver    = GetLocalString(GetModule(), ASPECT_DECEIVER);
  string sLifebringer = GetLocalString(GetModule(), ASPECT_LIFEBRINGER);
  string sDeathsHand  = GetLocalString(GetModule(), ASPECT_DEATHSHAND);
  string sSmith       = GetLocalString(GetModule(), ASPECT_SMITH);
  string sSlayer      = GetLocalString(GetModule(), ASPECT_SLAYER);
  string sBattlemage  = GetLocalString(GetModule(), ASPECT_BATTLEMAGE);
  string sMerchant    = GetLocalString(GetModule(), ASPECT_MERCHANT);
  string sNurturer    = GetLocalString(GetModule(), ASPECT_NURTURER);
  string sTrickster   = GetLocalString(GetModule(), ASPECT_TRICKSTER);
  string sProvider    = GetLocalString(GetModule(), ASPECT_PROVIDER);
  string sSoulStealer = GetLocalString(GetModule(), ASPECT_SOULSTEALER);
  string sJudge       = GetLocalString(GetModule(), ASPECT_JUDGE);
  string sArtificer   = GetLocalString(GetModule(), ASPECT_ARTIFICER);
  string sTemplar     = GetLocalString(GetModule(), ASPECT_TEMPLAR);
  string sScourge     = GetLocalString(GetModule(), ASPECT_SCOURGE);
  string sShaman      = GetLocalString(GetModule(), ASPECT_SHAMAN);
  string sUndertaker  = GetLocalString(GetModule(), ASPECT_UNDERTAKER);

  string sPC = gsPCGetPlayerID(oPC);

  if (sPC == sWarlord) return ASPECT_WARLORD;
  if (sPC == sArchmage) return ASPECT_ARCHMAGE;
  if (sPC == sCraftsman) return ASPECT_CRAFTSMAN;
  if (sPC == sDeceiver) return ASPECT_DECEIVER;
  if (sPC == sLifebringer) return ASPECT_LIFEBRINGER;
  if (sPC == sDeathsHand) return ASPECT_DEATHSHAND;
  if (sPC == sSmith) return ASPECT_SMITH;
  if (sPC == sSlayer) return ASPECT_SLAYER;
  if (sPC == sBattlemage) return ASPECT_BATTLEMAGE;
  if (sPC == sMerchant) return ASPECT_MERCHANT;
  if (sPC == sNurturer) return ASPECT_NURTURER;
  if (sPC == sTrickster) return ASPECT_TRICKSTER;
  if (sPC == sProvider) return ASPECT_PROVIDER;
  if (sPC == sSoulStealer) return ASPECT_SOULSTEALER;
  if (sPC == sJudge) return ASPECT_JUDGE;
  if (sPC == sArtificer) return ASPECT_ARTIFICER;
  if (sPC == sTemplar) return ASPECT_TEMPLAR;
  if (sPC == sScourge) return ASPECT_SCOURGE;
  if (sPC == sShaman) return ASPECT_SHAMAN;
  if (sPC == sUndertaker) return ASPECT_UNDERTAKER;

  return "";
}

string miDVGetAttunement(object oPC)
{
  string sElement = ELEMENT_FIRE;
  object oHide = gsPCGetCreatureHide(oPC);
  float fHighest = GetLocalFloat(oHide, ELEMENT_FIRE);
  float fCurrent = GetLocalFloat(oHide, ELEMENT_WATER);

  if (fCurrent > fHighest)
  {
    fHighest = fCurrent;
    sElement = ELEMENT_WATER;
  }

  fCurrent = GetLocalFloat(oHide, ELEMENT_EARTH);

  if (fCurrent > fHighest)
  {
    fHighest = fCurrent;
    sElement = ELEMENT_EARTH;
  }

  fCurrent = GetLocalFloat(oHide, ELEMENT_AIR);

  if (fCurrent > fHighest)
  {
    fHighest = fCurrent;
    sElement = ELEMENT_AIR;
  }

  fCurrent = GetLocalFloat(oHide, ELEMENT_LIFE);

  if (fCurrent > fHighest)
  {
    fHighest = fCurrent;
    sElement = ELEMENT_LIFE;
  }

  fCurrent = GetLocalFloat(oHide, ELEMENT_DEATH);

  if (fCurrent > fHighest)
  {
    fHighest = fCurrent;
    sElement = ELEMENT_DEATH;
  }

  return sElement;
}

void miDVListAspectsForDM(object oDM)
{
   object oModule = GetModule();
   string sMessage = "Warlord: " + gsPCGetPlayerName(GetLocalString (oModule, ASPECT_WARLORD)) +
                    "\nArchmage: " + gsPCGetPlayerName(GetLocalString (oModule, ASPECT_ARCHMAGE)) +
                    "\nCraftsman: " + gsPCGetPlayerName(GetLocalString (oModule, ASPECT_CRAFTSMAN)) +
                    "\nDeceiver: " + gsPCGetPlayerName(GetLocalString (oModule, ASPECT_DECEIVER)) +
                    "\nLifebringer: " + gsPCGetPlayerName(GetLocalString (oModule, ASPECT_LIFEBRINGER)) +
                    "\nDeath's Hand: " + gsPCGetPlayerName(GetLocalString (oModule, ASPECT_DEATHSHAND)) +
                    "\nSmith: " + gsPCGetPlayerName(GetLocalString (oModule, ASPECT_SMITH)) +
                    "\nSlayer: " + gsPCGetPlayerName(GetLocalString (oModule, ASPECT_SLAYER)) +
                    "\nBattlemage: " + gsPCGetPlayerName(GetLocalString (oModule, ASPECT_BATTLEMAGE)) +
                    "\nMerchant: " + gsPCGetPlayerName(GetLocalString (oModule, ASPECT_MERCHANT)) +
                    "\nNurturer: " + gsPCGetPlayerName(GetLocalString (oModule, ASPECT_NURTURER)) +
                    "\nTrickster: " + gsPCGetPlayerName(GetLocalString (oModule, ASPECT_TRICKSTER)) +
                    "\nProvider: " + gsPCGetPlayerName(GetLocalString (oModule, ASPECT_PROVIDER)) +
                    "\nSoulstealer: " + gsPCGetPlayerName(GetLocalString (oModule, ASPECT_SOULSTEALER)) +
                    "\nJudge: " + gsPCGetPlayerName(GetLocalString (oModule, ASPECT_JUDGE)) +
                    "\nArtificer: " + gsPCGetPlayerName(GetLocalString (oModule, ASPECT_ARTIFICER)) +
                    "\nTemplar: " + gsPCGetPlayerName(GetLocalString (oModule, ASPECT_TEMPLAR)) +
                    "\nScourge: " + gsPCGetPlayerName(GetLocalString (oModule, ASPECT_SCOURGE)) +
                    "\nShaman: " + gsPCGetPlayerName(GetLocalString (oModule, ASPECT_SHAMAN)) +
                    "\nUndertaker: " + gsPCGetPlayerName(GetLocalString (oModule, ASPECT_UNDERTAKER));
   SendMessageToPC(oDM, sMessage);
}

void batDVListElementsForDM(object oDM, object oTarget)
{
    object oHide = gsPCGetCreatureHide(oTarget);
    int nFire  = FloatToInt(GetLocalFloat(oHide, ELEMENT_FIRE));
    int nWater = FloatToInt(GetLocalFloat(oHide, ELEMENT_WATER));
    int nAir   = FloatToInt(GetLocalFloat(oHide, ELEMENT_AIR));
    int nEarth = FloatToInt(GetLocalFloat(oHide, ELEMENT_EARTH));
    int nLife  = FloatToInt(GetLocalFloat(oHide, ELEMENT_LIFE));
    int nDeath = FloatToInt(GetLocalFloat(oHide, ELEMENT_DEATH));

    string sMessage = "Character: " + GetName(oTarget) + "\nFire: " + IntToString(nFire) + "\nWater: " + IntToString(nWater) + "\nAir: " + IntToString(nAir) + "\nEarth: " + IntToString(nEarth) + "\nLife: " + IntToString(nLife) + "\nDeath: " + IntToString(nDeath);
    SendMessageToPC(oDM, sMessage);
}