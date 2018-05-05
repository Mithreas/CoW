/*
  Script to load all the quests into the database.
  
  TODO: refactor this system into a single table with proper SQL queries.
  Or store quest vars on a cache object and leave just the quests in place
  for random selection.
*/
#include "inc_randomquest"
  //Includes pg_lists_i,  inc_reputation, inc_database and inc_log
void SetStringValue(string sName, string sValue, string sDatabase)
{
  // Designed to break TMI by breaking this script up into lots of small actions.
  // This works because none of the code below needs to be executed in a particular
  // order.
  float fRand = IntToFloat(Random(1000))/10;
  DelayCommand(fRand, SetPersistentString(OBJECT_INVALID, sName, sValue, 0, sDatabase));
}

void CleanDB(string sDatabase)
{
  Trace(RQUEST, "Cleaning database: " + sDatabase);
  SQLExecDirect("DELETE FROM " + sDatabase);
}


void main()
{
  string DB_QUEST;
  string DB_VARS;
  string QUEST;
    
  /* Set database type. MYSQL or SQLITE supported. */
  SetLocalString(GetModule(), "DB_TYPE", "MYSQL");

  //-------------------------------------------------------------------------------------------
  /* House Renerrin Quests */
  DB_QUEST = "renerrin_quests";
  DB_VARS  = "renerrin_vars";
  
  CleanDB(DB_QUEST);
  CleanDB(DB_VARS);

  QUEST = "train";
  SetStringValue(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "You could use some experience, I think. Head over to the Market Square, and " +
   "see if there are any small tasks for the people there. Otherwise, head down " +
   "to the Undercity Crypts. To get there, head down into the Undercity via the " +
   "Imperial University, and head northeast. There are never enough people to keep all " +
   "the dead at rest... and we suspect dark magic at play, too. Stay near the " +
   "entrances to the tombs, and you should be fine. \n\n When you think you're " +
   "ready to do more for the House, come back to me.",
   DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "01_05", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+AREA_TAGS, "MarketSquare,UndercityAncestorsRest", DB_VARS);

  QUEST = "patrol_city";
  SetStringValue(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "I've heard there's trouble at the South Gates. Could you go there and check?",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "75", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "200", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "01_05", DB_VARS);
  SetStringValue(QUEST+AREA_TAGS, "southgates", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);

  QUEST = "drarayne_rats";
  SetStringValue(QUEST, HELP, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "A woman called Drarayne Thelas has appealed for help clearing out some " +
   "rats in her home. It would do the House's reputation good if we were seen "+
   "to help her. You can cope with that, can't you? Her house is in the " +
   "Northeast corner of the Merchants' District.", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "200", DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "100", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_05", DB_VARS);
  SetStringValue(QUEST+OTHER_NPC, "drarayne_thelas", DB_VARS);

  QUEST = "loose_hound";
  SetStringValue(QUEST, HELP, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "The fish market is being pestered by a badly trained dog.  Its handler is usually in the docks area. " +
   "Find him and help him get his hound under control, if you please.  The City's food supply is too important " +
   "to have stray animals around.", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "200", DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "100", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_15", DB_VARS);
  SetStringValue(QUEST+OTHER_NPC, "hound_handler", DB_VARS);

  QUEST = "gather_gemstone";
  SetStringValue(QUEST, RETRIEVE, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "I need a gemstone, a phenalope. Can you get me one? I'll give you 50 gold for it.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "50", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "150", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_15", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "NW_IT_GEM004", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);
  
  QUEST = "make_glass";
  SetStringValue(QUEST, RETRIEVE, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "I need an empty flask.  You can make one at a tinker's furnace if you can't find one yourself.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "50", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "150", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_15", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "cnremptyflask", DB_VARS);

  QUEST = "badger_skin";
  SetStringValue(QUEST, RETRIEVE, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "My wife got a badger skin muff, and now everyone wants one.  Please get me three skins.  " + 
   "There are usually badgers outside the West Gates, if you hunt around - you'll need a " +
   "skinning knife to part them from their fur.  Try the Market Square if you don't have one.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "75", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "25", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_15", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "cnrskinbadger", DB_VARS);
  SetStringValue(QUEST+NUM_ITEMS, "2", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);
  
  QUEST = "deliver_to_alian";
  SetStringValue(QUEST, MESSENGER, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
  "I've written a letter for an old friend, Alian. Will you take them to him? " +
  "You'll likely find him in the Imperial City, probably near the bank.",
  DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_15", DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "50", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "150", DB_VARS);
  SetStringValue(QUEST+ITEM_TO_GIVE, "hernen_letters", DB_VARS);
  SetStringValue(QUEST+TYPE, "GIVE", DB_VARS);
  SetStringValue(QUEST+OTHER_NPC, "alian_renerrin", DB_VARS);

  QUEST = "incriminate_paron_jarian";
  SetStringValue(QUEST, MESSENGER, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
  "I'd like you to plant these papers in the home of Paron Jarian, a Cardinal "+
  "in House Erenia. He's rarely at home, and even when he is, he's an old man "+
  "and very unobservant. The magistrates will receive a tip-off later... you "+
  "can find Cardinal Jarian's house on Sunrise Isle, near the docks.",
  DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "2", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_15", DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "100", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "500", DB_VARS);
  SetStringValue(QUEST+ITEM_TO_GIVE, "incriminatingpap", DB_VARS);
  SetStringValue(QUEST+TYPE, "GIVE", DB_VARS);
  
  QUEST = "kill_arin_meyo";
  SetStringValue(QUEST, KILL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
  "We have a minor problem. One of House Drannis' retainers, by the name of " +
  "Arin Meyo, has been sabotaging our attempts to supply demon's bane to the " +
  "Imperial House. I want him taught a lesson... the violent way. He lives in "+
  "a townhouse in the Northeast of Drannis District.",
  DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "1000", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "250", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "3", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_05", DB_VARS);
  SetStringValue(QUEST+TARGET_TAG, "arin_meyo", DB_VARS);

  QUEST = "research_1";
  SetStringValue(QUEST, RETRIEVE, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "Knowledge is power.  Make use of one of the libraries and bring me back some " +
   "research notes on a topic of your choice.\n\n(Use the '-research' command to research)",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "150", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "250", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "05_15", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "research_note", DB_VARS);

  QUEST = "mountain_patrol";
  SetStringValue(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "Controlling the various mines and farms outside of the city is essential to ensure that " +
   "our crafters have the resources they need.  Visit the mines amid the Skyreach Summits and " +
   "take control of any that are undefended.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "150", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "250", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "06_15", DB_VARS);
  SetStringValue(QUEST+AREA_TAGS, "TrallinTinMine,elenduselfurmine,irinironmine", DB_VARS);

  QUEST = "forest_patrol";
  SetStringValue(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "Controlling the various mines and farms outside of the city is essential to ensure that " +
   "our crafters have the resources they need.  Visit the reserves in the Feran Forest and " +
   "take control of any that are undefended.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "150", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "250", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "06_15", DB_VARS);
  SetStringValue(QUEST+AREA_TAGS, "WhisperingWood,DineaDeerReserve", DB_VARS);

  QUEST = "farm_patrol";
  SetStringValue(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "Controlling the various mines and farms outside of the city is essential to ensure that " +
   "our crafters have the resources they need.  Visit the farms on the South Road and " +
   "take control of any that are undefended.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "150", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "250", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "06_15", DB_VARS);
  SetStringValue(QUEST+AREA_TAGS, "barusbeetlefarm,CrannitCloverFields,crannitcottonfar", DB_VARS);

  QUEST = "kill_erenia_scout";
  SetStringValue(QUEST, KILL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
  "One of our mercenaries reported that House Erenia has one of their scouts posted " +
  "south of the city, probably near one of the resources around there.  Put a stop to " +
  "their scouting, would you?",
  DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "1000", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "250", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "2", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "07_12", DB_VARS);
  SetStringValue(QUEST+TARGET_TAG, "erenia_scout", DB_VARS);

  QUEST = "kill_drannis_scout";
  SetStringValue(QUEST, KILL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
  "One of our mercenaries reported that House Drannis has one of their scouts posted " +
  "to the Feran Forest, probably near one of the resources around there.  Put a stop to " +
  "their scouting, would you?",
  DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "1000", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "250", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "2", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "07_12", DB_VARS);
  SetStringValue(QUEST+TARGET_TAG, "drannis_scout", DB_VARS);
  
  QUEST = "make_black_powder";
  SetStringValue(QUEST, RETRIEVE, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "Our House stays at the forefront of the sciences.  Many of our best weapons are made with " +
   "black powder, yes?  Bring me back some black powder.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "150", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "2", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "300", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "08_15", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "blackpowder", DB_VARS);
  
  QUEST = "make_gonne";
  SetStringValue(QUEST, RETRIEVE, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "Our black powder weapons are not always reliable, but their power is unquestionable. " +
   "I want you to prove you are capable of sourcing such weapons.  Bring me a Gonne.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "1000", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "3", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "350", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "10_15", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "gonne", DB_VARS);

  //-------------------------------------------------------------------------------------------
  /* House Drannis Quests */
  DB_QUEST = "drannis_quests";
  DB_VARS  = "drannis_vars";

  CleanDB(DB_QUEST);
  CleanDB(DB_VARS);
  
  QUEST = "train";
  SetStringValue(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "You could use some experience, I think. Head up to the Market Square, and " +
   "see if there are any small tasks for the people there. Otherwise, head down " +
   "to the Undercity Crypts. To get there, take the entrance in our district, head down into the " +
   "Undercity, and head north, east and north. There are never enough people to keep all the " +
   "dead at rest... and we suspect dark magic at play, too. Stay near the " +
   "entrances to the tombs, and you should be fine. \n\n When you think you're " +
   "ready to do more for the House, come back to me.",
   DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "01_05", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+AREA_TAGS, "MarketSquare,UndercityAncestorsRest", DB_VARS);

  QUEST = "patrol_city";
  SetStringValue(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "I've heard there's trouble at the South Gates. Could you go there and check?",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "75", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "200", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "01_05", DB_VARS);
  SetStringValue(QUEST+AREA_TAGS, "southgates", DB_VARS);
  
  QUEST = "gather_wood";
  SetStringValue(QUEST, RETRIEVE, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "Maintaining our outposts always takes more wood.  Fetch five Irl branches " +
   "which our carpenters can use.  You'll need to head outside the city to find it.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "50", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "50", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_15", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "cnrbranch1", DB_VARS);
  SetStringValue(QUEST+NUM_ITEMS, "2", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);
  
  QUEST = "gather_ond";
  SetStringValue(QUEST, RETRIEVE, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "Ondaran does not make good weapons, but it makes excellent nails " +
   "and braces.  Since I have nothing more pressing for you right now, " +
   "bring back a couple of nuggets for our stores.  You'll need to head to " + 
   "a mine, most likely up among the Skyreach Summits.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "50", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "50", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_15", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "cnrnuggetond", DB_VARS);
  SetStringValue(QUEST+NUM_ITEMS, "2", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);
  
  QUEST = "make_glass";
  SetStringValue(QUEST, RETRIEVE, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "I need an empty flask.  You can make one at a tinker's furnace if you can't find one yourself.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "50", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "150", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_15", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "cnremptyflask", DB_VARS);

  QUEST = "guard_arin_meyo";
  SetStringValue(QUEST, HELP, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "Arin Meyo is one of our more effective traders. Unfortunately, this means "+
   "that the other Houses don't like him much. Go and see if there's anything "+
   "you can do to make his life easier.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "100", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "200", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "2", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_05", DB_VARS);
  SetStringValue(QUEST+OTHER_NPC, "arin_meyo", DB_VARS);

  QUEST = "drarayne_rats";
  SetStringValue(QUEST, HELP, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "A woman called Drarayne Thelas has appealed for help clearing out some " +
   "rats in her home. It would do the House's reputation good if we were seen "+
   "to help her. You can cope with that, can't you? Her house is in the " +
   "Northeast corner of the Merchants' District.", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "10", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "200", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_05", DB_VARS);
  SetStringValue(QUEST+OTHER_NPC, "drarayne_thelas", DB_VARS);

  QUEST = "loose_hound";
  SetStringValue(QUEST, HELP, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "The fish market is being pestered by a badly trained dog.  Its handler is usually in the docks area. " +
   "Find her and help her get the hound under control, if you please.  The City's food supply is too important " +
   "to have stray animals around.", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "200", DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "100", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_15", DB_VARS);
  SetStringValue(QUEST+OTHER_NPC, "hound_handler", DB_VARS);
  
  QUEST = "guardposts";
  SetStringValue(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "Visit our guard posts below and make sure that nothing untoward has happened. "+
   "One is in the southwest Undercity, just West of our entrance.  The other is in " +
   "the caves on the Second Level, below the North Undercity.", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "250", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_10", DB_VARS);
  SetStringValue(QUEST+AREA_TAGS, "UndercitySouthwest,av_DarkCave1", DB_VARS);

  QUEST = "no_agents_allowed";
  SetStringValue(QUEST, KILL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "We've had reports of a Renerrin agent snooping around near our outpost in the " +
   "southwest Undercity.  City law doesn't apply down there, so nothing stops you " +
   "removing a rival the permanent way.  Just try not to be too obvious.", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "2", DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "250", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "300", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "05_10", DB_VARS);
  SetStringValue(QUEST+TARGET_TAG, "renerrin_agent", DB_VARS);
				 
  QUEST = "laurisfetter";
  SetStringValue(QUEST, HELP, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "Knight Defender Lauris Fetter heads up the guard post down on the Second " +
   "Level. I'd like you to go down and lend him a hand. Do a job or two for " +
   "him, then come back here.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "1000", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "2500", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "2", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "06_10", DB_VARS);
  SetStringValue(QUEST+OTHER_NPC, "laurisfetter", DB_VARS);

  QUEST = "mountain_patrol";
  SetStringValue(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "Control of the ore-producing mines outside the city is key to ensure that our crafters " +
   "have the resources they need to make our weapons and armour.  Visit the mines amid the Skyreach Summits " +
   "and take control of any that are undefended.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "150", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "250", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "06_15", DB_VARS);
  SetStringValue(QUEST+AREA_TAGS, "TrallinTinMine,elenduselfurmine,irinironmine", DB_VARS);

  QUEST = "kill_erenia_scout";
  SetStringValue(QUEST, KILL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
  "One of our mercenaries reported that House Erenia has one of their scouts posted " +
  "south of the city, probably near one of the resources around there.  Put a stop to " +
  "their scouting, would you?",
  DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "1000", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "250", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "2", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "07_12", DB_VARS);
  SetStringValue(QUEST+TARGET_TAG, "erenia_scout", DB_VARS);

  QUEST = "kill_renerrin_scout";
  SetStringValue(QUEST, KILL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
  "One of our mercenaries reported that House Reneria has one of their scouts posted " +
  "to the Skyreach Summits, probably near one of the resources around there.  Put a stop to " +
  "their scouting, would you?  Renerrin scouts tend to train in sneaking, so keep your eyes peeled.",
  DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "1000", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "300", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "2", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "07_12", DB_VARS);
  SetStringValue(QUEST+TARGET_TAG, "renerrin_scout", DB_VARS);

  QUEST = "patrol_darzun_entrance";
  SetStringValue(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "We've had reports of Orcish patrols moving in and out of Dar'zun. I want " +
   "you to go down there and report to me what's happening. Be well prepared - " +
   "the orcs aren't to be taken lightly. Got that?", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "500", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "08_12", DB_VARS);
  SetStringValue(QUEST+AREA_TAGS, "plainsofdarkness", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);
  
  QUEST = "make_warhammer";
  SetStringValue(QUEST, RETRIEVE, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "I have a cousin over at the Wall, and he goes through warhammers like you wouldn't believe. " +
   "Bring me two Ondaran warhammers, that should keep him going for a bit.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "150", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "300", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "07_15", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "cnrwarhammer1", DB_VARS);
  SetStringValue(QUEST+NUM_ITEMS, "2", DB_VARS);
  
  QUEST = "patrol_fire_pits";
  SetStringValue(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "There's a bridge deep in the depths, over the fire pits in the Fera Wastes. " +
   "I want you to go down there. Check the current status of the bridge, and " +
   "garrison it ", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "1000", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "10_15", DB_VARS);
  SetStringValue(QUEST+AREA_TAGS, "ferawastesfirepi", DB_VARS);
  
  QUEST = "boss_heads";  
  SetStringValue(QUEST, RETRIEVE, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "House Drannis takes the defense of the City very seriously.  Bring back two " +
   "heads of creatures from beneath the City that could pose a threat.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "150", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "300", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "05_15", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "GS_HEAD_EVIL", DB_VARS);
  SetStringValue(QUEST+NUM_ITEMS, "2", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);

  //-------------------------------------------------------------------------------------------
  /* House Erenia Quests */
  DB_QUEST = "erenia_quests";
  DB_VARS  = "erenia_vars";

  CleanDB(DB_QUEST);
  CleanDB(DB_VARS);
  
  QUEST = "train";
  SetStringValue(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "You could use some experience, I think. Head over to the Market Square in the City, and " +
   "see if there are any small tasks for the people there. Otherwise, head down " +
   "to the Undercity Crypts. To get there, go to the Docks, head down into the " +
   "Undercity, and head north. There are never enough people to keep all the " +
   "dead at rest... and we suspect dark magic at play, too. Stay near the " +
   "entrances to the tombs, and you should be fine. \n\n When you think you're " +
   "ready to do more for the House, come back to me.",
   DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "01_05", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+AREA_TAGS, "MarketSquare,UndercityAncestorsRest", DB_VARS);

  QUEST = "gather_holywater";
  SetStringValue(QUEST, RETRIEVE, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "Freda told me there's a ghost in the Tower. I need some holy water to keep "
   + "it out of my rooms. Please can you fetch me some? The Temple should have "
   + "plenty.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "100", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "100", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "01_05", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "X1_WMGRENADE005", DB_VARS);

  QUEST = "more_holywater";
  SetStringValue(QUEST, RETRIEVE, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "I've run out of holy water to keep the ghost out of my rooms. " + 
   "Please can you fetch me some more?", DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "50", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "50", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_15", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "X1_WMGRENADE005", DB_VARS); 
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);
  
  QUEST = "make_glass";
  SetStringValue(QUEST, RETRIEVE, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "I need an empty flask.  You can make one at a tinker's furnace if you can't find one yourself.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "50", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "150", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_15", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "cnremptyflask", DB_VARS);
  
  QUEST = "drarayne_rats";
  SetStringValue(QUEST, HELP, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "A woman called Drarayne Thelas has appealed for help clearing out some " +
   "rats in her home. It would do the House's reputation good if we were seen "+
   "to help her. You can cope with that, can't you? Her house is in the " +
   "Northeast corner of the Merchants' District.", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "10", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "250", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_05", DB_VARS);
  SetStringValue(QUEST+OTHER_NPC, "drarayne_thelas", DB_VARS);

  QUEST = "loose_hound";
  SetStringValue(QUEST, HELP, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "The fish market is being pestered by a badly trained dog.  Its handler is usually in the docks area. " +
   "Find him and help him get his hound under control, if you please.  The City's food supply is too important " +
   "to have stray animals around.", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "200", DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "100", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_15", DB_VARS);
  SetStringValue(QUEST+OTHER_NPC, "hound_handler", DB_VARS);

  QUEST = "pilgrimmage";
  SetStringValue(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "You should visit the holy sites, to further your knowledge of the gods. " +
   "There are temples to Morrian and Solkin maintained by the other Houses, " +
   "as well as the Temple to the Seven of our own House. Finally, you should " +
   "visit the Grove of the Gods, here on Sunrise Isle. It's not far from the " +
   "entrance to Sunrise Tower.", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "250", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "2", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_15", DB_VARS);
  SetStringValue(QUEST+AREA_TAGS,
                 "groveofthegods,templeoftheseven,templetomorri001,templetosolkin",
                 DB_VARS);

  QUEST = "kill_arin_meyo";
  SetStringValue(QUEST, KILL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
  "We have a minor problem. One of House Drannis' retainers, by the name of " +
  "Arin Meyo, has been sabotaging our attempts to supply adanium to the " +
  "Imperial House. Teach him not to interfere with our divine work. He lives "+
  "in a townhouse in the Northeast of Drannis District.",
  DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "1000", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "250", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "3", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_05", DB_VARS);
  SetStringValue(QUEST+TARGET_TAG, "arin_meyo", DB_VARS);

  QUEST = "paronjariandesk";
  SetStringValue(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "I'd like you to go and check Cardinal Jarian's house. Due to his age and "+
   "station, he's often targetted by members of other Houses. Please check " +
   "his desk and make sure there's nothing untoward in it... his house is near "+
   "the docks, here on Sunrise Isle.", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_07", DB_VARS);
  SetStringValue(QUEST+AREA_TAGS, "paronjarianshous", DB_VARS);
  
  QUEST = "patrolcrypts";
  SetStringValue(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
  "Our brethren guarding the Undercity entrance report that the dead are stirring " +
  "in Ancestors' Rest again.  Please visit the four crypts there and restore peace.",
  DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_15", DB_VARS);
  SetStringValue(QUEST+AREA_TAGS, "DarkenedCrypt,hauntedcrypt,OldCrypt,ShadowedCrypt", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "250", DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "250", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);

  QUEST = "paronjarian";
  SetStringValue(QUEST, HELP, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "Go and see if Cardinal Jarian needs any help. He's usually found in " +
   "the Garden of Contemplation, near the docks.", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_06", DB_VARS);
  SetStringValue(QUEST+OTHER_NPC, "paronjarian", DB_VARS);

  QUEST = "gather_incense";
  SetStringValue(QUEST, RETRIEVE, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "I'm low on incense. Please can you fetch me a couple of sticks? The temple "
   + "will have some.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "600", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "50", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_20", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "stickofincense", DB_VARS);
  SetStringValue(QUEST+NUM_ITEMS, "2", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);

  QUEST = "forest_patrol";
  SetStringValue(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "The woods outside the city have many herbs that are useful for our potions; controlling them ensures " +
   "that our crafters have the resources they need.  Visit the reserves in the Feran Forest and " +
   "take control of any that are undefended.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "150", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "250", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "06_15", DB_VARS);
  SetStringValue(QUEST+AREA_TAGS, "WhisperingWood,DineaDeerReserve", DB_VARS);

  QUEST = "kill_drannis_scout";
  SetStringValue(QUEST, KILL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
  "One of our mercenaries reported that House Drannis has one of their scouts posted " +
  "to the Feran Forest, probably near one of the resources around there.  Put a stop to " +
  "their scouting, would you?",
  DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "1000", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "250", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "2", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "07_12", DB_VARS);
  SetStringValue(QUEST+TARGET_TAG, "drannis_scout", DB_VARS);

  QUEST = "kill_renerrin_scout";
  SetStringValue(QUEST, KILL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
  "One of our mercenaries reported that House Reneria has one of their scouts posted " +
  "to the Skyreach Summits, probably near one of the resources around there.  Put a stop to " +
  "their scouting, would you?  Renerrin scouts tend to train in sneaking, so keep your eyes peeled.",
  DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "1000", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "300", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "2", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "07_12", DB_VARS);
  SetStringValue(QUEST+TARGET_TAG, "renerrin_scout", DB_VARS);
  
  QUEST = "make_cunning_potions";
  SetStringValue(QUEST, RETRIEVE, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "Our agents make heavy use of Fox's Cunning potions to ensure they are always working at their " +
   "best.  Bring me 10 potions... brew them yourself if need be.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "50", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "150", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "2", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_15", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "nw_it_mpotion017", DB_VARS);
  SetStringValue(QUEST+NUM_ITEMS, "10", DB_VARS);
  
  //-------------------------------------------------------------------------------------------

}
