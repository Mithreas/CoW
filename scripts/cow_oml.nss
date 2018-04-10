#include "mi_perspeople"
void main()
{
  // Initialise APS (the database system)
  Log ("Initialising DB");
  //SetLocalString(GetModule(),"NWNX!INIT","1");

  // Initialise CNR - this script calls aps_onload too.
  Log ("Initialising CNR");
  //ExecuteScript("cnr_module_oml", OBJECT_SELF);

  // Run the standard on mod load script.
  Log ("Initialising module");
  ExecuteScript("x2_mod_def_load", OBJECT_SELF);

  // Initialise the random quests - loading them into the database.
  Log ("Initialising random quests");
  //DelayCommand(60.0, ExecuteScript("rquest_init", OBJECT_SELF));

  // Initialise the ranks (loading them into the database).
  Log ("Initialising ranks");
  //ExecuteScript("ranks_init", OBJECT_SELF);

  // Kick off the script that checks who owns resource points and grants
  // faction points accordingly.
  Log ("Initialising resources");
  //DelayCommand(60.0, ExecuteScript("module_hb", OBJECT_SELF));

  // Set up persistent people.
  Log ("Not Initialising persistent people");
  // SetUpPersistentPeople();

}
