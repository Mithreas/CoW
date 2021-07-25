/* ent_achievement
 * awards the achievement whose tag is set on this trigger as the String variable
 * ACHIEVEMENT to any PC who enters this trigger.
 */
#include "inc_achievements"

void main()
{
  object oPC = GetEnteringObject();
  
  if (!GetIsPC(oPC)) return;
  
  string sAchievement = GetLocalString(OBJECT_SELF, "ACHIEVEMENT");
  
  acAwardAchievement(oPC, sAchievement);
}