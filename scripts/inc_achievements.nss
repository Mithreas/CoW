/*
 * inc_achievements
 * Library for managing achievements
 * Achievements are stored in the DB and initialised from achieve_init
 * When a player is awarded an achievement, check whether they already have it.
 * If not, award it and give the text message associated with it.
 * Achievements are per PLAYER not per CHARACTER. So keyed off keydata / player ID. 
 * Achievement ID/key is an alphanumeric tag; achievements also have a name and description.
 * 
 * DB tables:
 * ac_pl_achieves (int player_id (foreign key gs_player_data->id), varchar(16) achievement (NOT formally keyed off ac_achieves->tag to allow table to be reinitialised))
 * ac_achieves (varchar(16) tag, varchar(64) name, text description)
 *
 * Utility scripts (configured via variables on their object):
 * ent_achievement - award an achievement to any PC entering this trigger.
 * ck_achievement  - dialog conditional script, show if the PC Speaker has a particular achievement
 * c_achievement   - grant achievement to PC Speaker
 * 
 */
 
#include "inc_database"
#include "inc_examine"
#include "inc_pc"

void acAwardAchievement(object oPC, string sAchievementTag);
int acPlayerHasAchievement(object oPC, string sAchievementTag);
void acInitialise(string sAchievementTag, string sAchievementName, string sAchievementDescription);
void acClearAchievements();
void acListAchievements(object oPC);

void acClearAchievements()
{
  SQLExecDirect("DELETE FROM ac_achieves");
}

void acInitialise(string sAchievementTag, string sAchievementName, string sAchievementDescription)
{
  SQLExecStatement("INSERT INTO ac_achieves (tag, name, description) VALUES (?, ?, ?)", sAchievementTag, sAchievementName, sAchievementDescription);
}

int acPlayerHasAchievement(object oPC, string sAchievementTag)
{
  SQLExecStatement("SELECT player_id FROM ac_pl_achieves WHERE player_id=? AND achievement=?", gsPCGetCDKeyID(GetPCPublicCDKey(oPC)), sAchievementTag);
  if (SQLFetch()) return TRUE;
  return FALSE;  
}

void acListAchievements(object oPC)
{
  SQLExecStatement("SELECT acs.name FROM ac_pl_achieves AS acpl INNER JOIN ac_achieves AS acs ON acpl.achievement = acs.tag WHERE acpl.player_id=?", gsPCGetCDKeyID(GetPCPublicCDKey(oPC)));
  string sAchievements = "";
  while (SQLFetch())
  {
    sAchievements += SQLGetData(1) + "\n";
  }
  
  DisplayTextInExamineWindow("Achievements", sAchievements, oPC);
}

void acAwardAchievement(object oPC, string sAchievementTag)
{
  if (acPlayerHasAchievement(oPC, sAchievementTag)) return;
  
  SQLExecStatement("INSERT INTO ac_pl_achieves (player_id, achievement) VALUES (?, ?)", gsPCGetCDKeyID(GetPCPublicCDKey(oPC)), sAchievementTag);
  
  SQLExecStatement("SELECT name, description FROM ac_achieves WHERE tag=?", sAchievementTag);
  if (SQLFetch())
  {
    FloatingTextStringOnCreature( "Congratulations! You earned achievement: " + SQLGetData(1), oPC);
	SendMessageToPC(oPC, SQLGetData(2));
  }
}