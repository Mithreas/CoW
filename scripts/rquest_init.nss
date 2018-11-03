/*
  Script to load all the quests into the database.
  
  TODO: refactor this system into a single table with proper SQL queries.
  Quest variables are now stored on a local cache and only the main quest
  needs to be stored - all quests should move into one table.
*/
#include "inc_randomquest"
  //Includes pg_lists_i,  inc_reputation, inc_database and inc_log
void SetStringValue(string sName, string sValue, string sDatabase)
{
  object oCache = miDAGetCacheObject(sDatabase);
  SetLocalString(oCache, sName, sValue);
}

void AddQuest(string sName, string sValue, string sDatabase)
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

  QUEST = "patrol_city";
  AddQuest(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "I've heard there's trouble at the South Gates. Could you go there and check? " +
   "Careful not to upset the guards, don't be a hero.  Just find out what's going on " +
   "and come back and tell me.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "75", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "2000", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "01_02", DB_VARS);
  SetStringValue(QUEST+AREA_TAGS, "southgates", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);

  QUEST = "train";
  AddQuest(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "You could use some experience, I think. Head over to the Market Square, and " +
   "see if there are any small tasks for the people there. Otherwise, head down " +
   "to the Undercity Crypts. To get there, head down into the Undercity via the " +
   "Imperial University, and head northeast. There are never enough people to keep all " +
   "the dead at rest... and we suspect dark magic at play, too. Stay near the " +
   "entrances to the tombs, and you should be fine. \n\n When you think you're " +
   "ready to do more for the House, come back to me.",
   DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "03_05", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+AREA_TAGS, "MarketSquare,UndercityAncestorsRest", DB_VARS);

  QUEST = "drarayne_rats";
  AddQuest(QUEST, HELP, DB_QUEST);
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
  AddQuest(QUEST, HELP, DB_QUEST);
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
  AddQuest(QUEST, RETRIEVE, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "I need a gemstone, a phenalope. Can you get me one? I'll give you 50 gold for it.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "50", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "150", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_15", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "NW_IT_GEM004", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);
  
  QUEST = "make_glass";
  AddQuest(QUEST, RETRIEVE, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "I need an empty flask.  You can make one at a tinker's furnace if you can't find one yourself.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "50", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "150", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_15", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "cnremptyflask", DB_VARS);

  QUEST = "badger_skin";
  AddQuest(QUEST, RETRIEVE, DB_QUEST);
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
  AddQuest(QUEST, MESSENGER, DB_QUEST);
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
  AddQuest(QUEST, MESSENGER, DB_QUEST);
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
  AddQuest(QUEST, KILL, DB_QUEST);
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
  AddQuest(QUEST, RETRIEVE, DB_QUEST);
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
  AddQuest(QUEST, PATROL, DB_QUEST);
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
  AddQuest(QUEST, PATROL, DB_QUEST);
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
  AddQuest(QUEST, PATROL, DB_QUEST);
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
  AddQuest(QUEST, KILL, DB_QUEST);
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
  AddQuest(QUEST, KILL, DB_QUEST);
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
  AddQuest(QUEST, RETRIEVE, DB_QUEST);
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
  AddQuest(QUEST, RETRIEVE, DB_QUEST);
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

  QUEST = "patrol_city";
  AddQuest(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "I've heard there's trouble at the South Gates. Could you go there and check?",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "75", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "2000", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "01_02", DB_VARS);
  SetStringValue(QUEST+AREA_TAGS, "southgates", DB_VARS);
    
  QUEST = "train";
  AddQuest(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "You could use some experience, I think. Head up to the Market Square, and " +
   "see if there are any small tasks for the people there. Otherwise, head down " +
   "to the Undercity Crypts. To get there, take the entrance in our district, head down into the " +
   "Undercity, and head north, east and north. There are never enough people to keep all the " +
   "dead at rest... and we suspect dark magic at play, too. Stay near the " +
   "entrances to the tombs, and you should be fine. \n\n When you think you're " +
   "ready to do more for the House, come back to me.",
   DB_VARS);   
  SetStringValue(QUEST+LEVEL_RANGE, "03_05", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+AREA_TAGS, "MarketSquare,UndercityAncestorsRest", DB_VARS);
  
  QUEST = "gather_wood";
  AddQuest(QUEST, RETRIEVE, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "Maintaining our outposts always takes more wood.  Fetch five Irl branches " +
   "which our carpenters can use.  You'll need to head outside the city to find it.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "50", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "50", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_15", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "cnrbranch1", DB_VARS);
  SetStringValue(QUEST+NUM_ITEMS, "5", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);
  
  QUEST = "gather_ond";
  AddQuest(QUEST, RETRIEVE, DB_QUEST);
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
  AddQuest(QUEST, RETRIEVE, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "I need an empty flask.  You can make one at a tinker's furnace if you can't find one yourself.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "50", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "150", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_15", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "cnremptyflask", DB_VARS);

  QUEST = "guard_arin_meyo";
  AddQuest(QUEST, HELP, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "Arin Meyo is one of our more effective traders. Unfortunately, this means "+
   "that the other Houses don't like him much. Go and see if there's anything "+
   "you can do to make his life easier, his house is in our District.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "100", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "200", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "2", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_05", DB_VARS);
  SetStringValue(QUEST+OTHER_NPC, "arin_meyo", DB_VARS);

  QUEST = "drarayne_rats";
  AddQuest(QUEST, HELP, DB_QUEST);
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
  AddQuest(QUEST, HELP, DB_QUEST);
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
  AddQuest(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "Visit our guard posts below and make sure that nothing untoward has happened. "+
   "One is in the southwest Undercity, just West of our entrance.  The other is in " +
   "the caves on the Second Level, below the North Undercity.", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "250", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_10", DB_VARS);
  SetStringValue(QUEST+AREA_TAGS, "UndercitySouthwest,av_DarkCave1", DB_VARS);

  QUEST = "no_agents_allowed";
  AddQuest(QUEST, KILL, DB_QUEST);
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
  AddQuest(QUEST, HELP, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "Knight Defender Lauris Fetter heads up the guard post down on the Second " +
   "Level. I'd like you to go down and lend him a hand; do a job or two for " +
   "him, then come back here.  You'll need to head into the caves below the North " +
   "Undercity, mind the spiders.", 
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "1000", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "2500", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "2", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "06_10", DB_VARS);
  SetStringValue(QUEST+OTHER_NPC, "laurisfetter", DB_VARS);

  QUEST = "mountain_patrol";
  AddQuest(QUEST, PATROL, DB_QUEST);
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
  AddQuest(QUEST, KILL, DB_QUEST);
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
  AddQuest(QUEST, KILL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
  "One of our mercenaries reported that House Renerrin has one of their scouts posted " +
  "to the Skyreach Summits, probably near one of the resources around there.  Put a stop to " +
  "their scouting, would you?  Renerrin scouts tend to train in sneaking, so keep your eyes peeled.",
  DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "1000", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "300", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "2", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "07_12", DB_VARS);
  SetStringValue(QUEST+TARGET_TAG, "renerrin_scout", DB_VARS);

  QUEST = "patrol_darzun_entrance";
  AddQuest(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "We've had reports of Orcish patrols moving in and out of Dar'zun. I want " +
   "you to go down there and report to me what's happening. Be well prepared - " +
   "the orcs aren't to be taken lightly. Got that?", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "500", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "08_12", DB_VARS);
  SetStringValue(QUEST+AREA_TAGS, "plainsofdarkness", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);
  
  QUEST = "make_warhammer";
  AddQuest(QUEST, RETRIEVE, DB_QUEST);
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
  AddQuest(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "There's a bridge deep in the depths, over the fire pits in the Fera Wastes. " +
   "I want you to go down there. Check the current status of the bridge, and " +
   "garrison it ", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "1000", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "10_15", DB_VARS);
  SetStringValue(QUEST+AREA_TAGS, "ferawastesfirepi", DB_VARS);
  
  QUEST = "boss_heads";  
  AddQuest(QUEST, RETRIEVE, DB_QUEST);
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

  QUEST = "gather_holywater";
  AddQuest(QUEST, RETRIEVE, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "Freda told me there's a ghost in the Tower. I need some holy water to keep "
   + "it out of my rooms. Please can you fetch me some? The Temple should have "
   + "plenty.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "100", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "1000", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "01_02", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "X1_WMGRENADE005", DB_VARS);
  
  QUEST = "train";
  AddQuest(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "You could use some experience, I think. Head over to the Market Square in the City, and " +
   "see if there are any small tasks for the people there. Otherwise, head down " +
   "to the Undercity Crypts. To get there, go to the Docks, head down into the " +
   "Undercity, and head north. There are never enough people to keep all the " +
   "dead at rest... and we suspect dark magic at play, too. Stay near the " +
   "entrances to the tombs, and you should be fine. \n\n When you think you're " +
   "ready to do more for the House, come back to me.",
   DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "03_05", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+AREA_TAGS, "MarketSquare,UndercityAncestorsRest", DB_VARS);

  QUEST = "more_holywater";
  AddQuest(QUEST, RETRIEVE, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "I've run out of holy water to keep the ghost out of my rooms. " + 
   "Please can you fetch me some more?", DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "50", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "50", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_15", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "X1_WMGRENADE005", DB_VARS); 
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);
  
  QUEST = "make_glass";
  AddQuest(QUEST, RETRIEVE, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "I need an empty flask.  You can make one at a tinker's furnace if you can't find one yourself.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "50", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "150", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_15", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "cnremptyflask", DB_VARS);
  
  QUEST = "drarayne_rats";
  AddQuest(QUEST, HELP, DB_QUEST);
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
  AddQuest(QUEST, HELP, DB_QUEST);
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
  AddQuest(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "You should visit the holy sites, to further your knowledge of the gods. " +
   "There are temples to Morrian and Solkin maintained by the other Houses, " +
   "as well as the Temple to the Seven of our own House. Finally, you should " +
   "visit the Grove of the Gods, here on Sunrise Isle. It's not far from the " +
   "entrance to the estate.", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "250", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "2", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_15", DB_VARS);
  SetStringValue(QUEST+AREA_TAGS,
                 "groveofthegods,templeoftheseven,templetomorri001,templetosolkin",
                 DB_VARS);

  QUEST = "kill_arin_meyo";
  AddQuest(QUEST, KILL, DB_QUEST);
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
  AddQuest(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "I'd like you to go and check Cardinal Jarian's house. Due to his age and "+
   "station, he's often targeted by members of other Houses. Please check " +
   "his desk and make sure there's nothing untoward in it... his house is near "+
   "the docks, here on Sunrise Isle.", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_07", DB_VARS);
  SetStringValue(QUEST+AREA_TAGS, "paronjarianshous", DB_VARS);
  
  QUEST = "patrolcrypts";
  AddQuest(QUEST, PATROL, DB_QUEST);
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
  AddQuest(QUEST, HELP, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "Go and see if Cardinal Jarian needs any help. He's usually found in " +
   "the Garden of Contemplation, near the docks.", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_06", DB_VARS);
  SetStringValue(QUEST+OTHER_NPC, "paronjarian", DB_VARS);

  QUEST = "gather_incense";
  AddQuest(QUEST, RETRIEVE, DB_QUEST);
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
  AddQuest(QUEST, PATROL, DB_QUEST);
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
  AddQuest(QUEST, KILL, DB_QUEST);
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
  AddQuest(QUEST, KILL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
  "One of our mercenaries reported that House Renerrin has one of their scouts posted " +
  "to the Skyreach Summits, probably near one of the resources around there.  Put a stop to " +
  "their scouting, would you?  Renerrin scouts tend to train in sneaking, so keep your eyes peeled.",
  DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "1000", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "300", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "2", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "07_12", DB_VARS);
  SetStringValue(QUEST+TARGET_TAG, "renerrin_scout", DB_VARS);
  
  QUEST = "make_cunning_potions";
  AddQuest(QUEST, RETRIEVE, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "A disciple of Erenia should always be prepared to offer blessings.  Since not all of us are gifted " +
   "with divine magics, potions must serve.  Bring me 10 Potions of Bless... brew them yourself if need be. " +
   "You can find what you need at the Garden of Contemplation, here on Sunrise Isle.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "50", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "150", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "2", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_15", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "NW_IT_MPOTION009", DB_VARS);
  SetStringValue(QUEST+NUM_ITEMS, "10", DB_VARS);
  

  //-------------------------------------------------------------------------------------------
  /* Wardens Quests */
  DB_QUEST = "wardens_quests";
  DB_VARS  = "wardens_vars";

  CleanDB(DB_QUEST);
  
  QUEST = "patrol_tannery";
  AddQuest(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION, 
    "Please check on the tannery to the east of the village, and make sure there are no fey causing " +
	"trouble there.  They aren't usually among the buildings, but I always worry about the exposed outer " +
	"dwellings.", DB_VARS);
  SetStringValue(QUEST+AREA_TAGS, "PerVyvTradeRoute", DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "25", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "1000", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "01_02", DB_VARS);

  QUEST = "patrol_docks";
  AddQuest(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
    "I'm expecting a trade ship to come in shortly, bringing us tools from the City in exchange for food. " +
	"Please can you head up to the docks and let me know whether it's arrived?  Just follow the road north.", DB_VARS);
  SetStringValue(QUEST+AREA_TAGS, "PerVilDocks", DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "25", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "250", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "03_04", DB_VARS);
  
  QUEST = "cure_potion";
  AddQuest(QUEST, RETRIEVE, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
    "Drat, my back is acting up again.  Please can you get me a Cure Light Wounds potion?  That usually makes " +
	"me feel better.  If you haven't got one on you, Allie should have some for sale in the Tankard of Mead.", DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "125", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "250", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "03_04", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "NW_IT_MPOTION001", DB_VARS);
  SetStringValue(QUEST+NUM_ITEMS, "1", DB_VARS);
  
  QUEST = "retrieve_ondaran";
  AddQuest(QUEST, RETRIEVE, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
    "While iron weapons are the best to use against fey, ondaran has its uses as well, not least for tools.  Please "+
	"head to the cave north of Lake Vyvian and mine four pieces of ondaran.  If you haven't already got an axe, Freddy "+
	"in the Tankard of Mead probably has one you can buy.", DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "250", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "250", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "03_05", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "cnrnuggetond", DB_VARS);
  SetStringValue(QUEST+NUM_ITEMS, "4", DB_VARS);
  
  QUEST = "patrol_farms";
  AddQuest(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
    "We always need to be watchful against fey incursions into our fields.  Please check on the Home Farms, " +
	"South Farms and West Farms and clear out any wandering fey you see.",
  DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_15", DB_VARS);
  SetStringValue(QUEST+AREA_TAGS, "PerHomeFarms,PerVilSouthFarms,PerVyvVilWestFarms", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "200", DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "150", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);
  
  QUEST = "patrol_borders";
  AddQuest(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
    "Time to go a little further afield.  Please do a patrol of the East, South and Southwest borderland and " +
	"report back on any fey you find.",
  DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_05", DB_VARS);
  SetStringValue(QUEST+AREA_TAGS, "PerVyvEastBorder,PerVilSouthBorder,PerVyvVilSWBorders", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "250", DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "200", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);
  
  QUEST = "pixie_command";
  AddQuest(QUEST, RETRIEVE, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
    "The Sprites in the borderlands are a constant threat.  They are surprisingly well organised, too... there must be some " +
	"leaders among them.  Please find out where their command lurks, and bring me back one of their leaders.  Dead or alive.", DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "250", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "400", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_05", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "qst_spritecmd", DB_VARS);
  
  QUEST = "polish_greenstone";
  AddQuest(QUEST, RETRIEVE, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "It's useful to learn how to polish gems.  Not only does it make them worth more in trade, but jewelry with inset gems will hold " +
   "investments better.  Polish a greenstone, and bring it to me.  There are tables in the greeting hall of the manor, and you can " +
   "usually find the rough stones out west among the beetles.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "100", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "150", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_06", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "cow_gemgree", DB_VARS);
  
  QUEST = "make_dex_potions";
  AddQuest(QUEST, RETRIEVE, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "Potions are always of use to the village's protectors.  Please bring me ten Cat's Grace potions... you may need to brew them yourself. " +
   "They need peppermint and catnip, which you should be able to find about the village.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "300", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "250", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "06_15", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "NW_IT_MPOTION014", DB_VARS);
  SetStringValue(QUEST+NUM_ITEMS, "10", DB_VARS);
  
  QUEST = "boss_heads";  
  AddQuest(QUEST, RETRIEVE, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "As a Warden, you are expected to help in the defense of the village.  Bring me two heads from creatures that mean us harm.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "200", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "250", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "06_15", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "GS_HEAD_EVIL", DB_VARS);
  SetStringValue(QUEST+NUM_ITEMS, "2", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);
  
  QUEST = "fey_silver";  
  AddQuest(QUEST, RETRIEVE, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "The human city has asked me to send them some silver.  I'm not sure why.  I have heard tell of people finding it in the Feywilds, " +
   "near a grove that was overrun some time back.  I know it's a lot to ask, but please can you seek it out?  I only need a couple of nuggets.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "300", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "350", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "06_09", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "cnrnuggetsil", DB_VARS);
  SetStringValue(QUEST+NUM_ITEMS, "2", DB_VARS);
  
  //-------------------------------------------------------------------------------------------
  /* Fernvale Quests */
  DB_QUEST = "fernvale_quests";
  DB_VARS  = "fernvale_vars";
  
  QUEST = "explore_fernvale";
  AddQuest(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION, 
    "You should get to know the village.  Visit the Rangers' Guild, the Mages' Guild, the Canopy, and the Temple. " +
	"They're all nearby; the guilds are to your left and right, the way up to the canopy is further to your left, " +
	"and the temple is a short walk to the east.", DB_VARS);
  SetStringValue(QUEST+AREA_TAGS, "fevCanopy,fevMageGuild,fevRangersGuild,fevtemple", DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "25", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "2000", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "01_02", DB_VARS);
  
  QUEST = "kill_gobbo_carrier";
  AddQuest(QUEST, KILL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
  "There is a nasty plague in the lands.  The nearby tribe of goblins is deeply afflicted; this is not helped by " +
  "some of them acting as carriers, and passing the disease on to each generation.  Go to the goblin cave in the " +
  "north woods, and remove one of the carriers.",
  DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "250", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "250", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "2", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "03_05", DB_VARS);
  SetStringValue(QUEST+TARGET_TAG, "qst_gobcarrier", DB_VARS);
  
  QUEST = "retrieve_bark";
  AddQuest(QUEST, MESSENGER, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
  "One of the Entish has been growing some very special bark for me, which might help us deal with the plague that's " +
  "troubling our land.  He usually wanders in the southern woods.  Please find out whether the bark is ready, and if so, " +
  "bring it back to me.",
  DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "03_05", DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "50", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "250", DB_VARS);
  SetStringValue(QUEST+ITEM_TO_BRING, "special_bark", DB_VARS);
  SetStringValue(QUEST+TYPE, "GET", DB_VARS);
  SetStringValue(QUEST+OTHER_NPC, "ent_bark_grower", DB_VARS);
  
  QUEST = "craft_arrows";
  AddQuest(QUEST, RETRIEVE, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
    "You should learn how to make bundles of arrows; later you will be able to enchant whole bundles to make many powerful " +
	"arrows.  Firstly, you will need to obtain some twigs from an ent.  Speak with an ent bare-handed, and they will let you " +
	"gather some twigs.  You will also need some feathers; you have probably noticed the birds in the canopy.  Harvest wisely. " +
	"Then in the Rangers' Guild you will find a craft station for making arrows.", DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "125", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "250", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "03_05", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "ca_gen_arrow_ent", DB_VARS);
  SetStringValue(QUEST+NUM_ITEMS, "1", DB_VARS);
  
  QUEST = "craft_chitin";
  AddQuest(QUEST, RETRIEVE, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
    "You should learn how to work with chitin.  Ask an arachne if they have any spare; they are always shedding their skins as they " +
	"grow, so most have a ready supply.  Take it to the Rangers' Guild and use the armour crafting anvil to make small plates, and " +
	"make a helmet from those plates and bring it to me.", DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "255", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "250", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "03_05", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "cnrhelm5", DB_VARS);
  SetStringValue(QUEST+NUM_ITEMS, "1", DB_VARS);
  
  QUEST = "hobgob_caves";
  AddQuest(QUEST, HELP, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "Ranger Rathendriel has sent a request for help.  He's stationed at the outpost just west of the village.  Please " +
   "go and see what you can do to help him.", 
   DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_06", DB_VARS);
  SetStringValue(QUEST+OTHER_NPC, "qst_rathendriel", DB_VARS);
  
  QUEST = "cure_ingredients";  
  AddQuest(QUEST, RETRIEVE, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "Keeping the plague from affecting our peoples requires a constant source of cure.  Happily this can be made with " +
   "local ingredients.  Please bring back some ginseng from the foothills to the west.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "100", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "100", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "04_05", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "cnrginsengroot", DB_VARS);
  SetStringValue(QUEST+NUM_ITEMS, "2", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);
  
  QUEST = "make_cure";  
  AddQuest(QUEST, RETRIEVE, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "Keeping the plague from affecting our peoples requires a constant source of cure.  Please deliver me five potions " +
   "of cure disease.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "250", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "250", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "06_10", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "it_mpotion007", DB_VARS);
  SetStringValue(QUEST+NUM_ITEMS, "5", DB_VARS);
  SetStringValue(QUEST+IS_REPEATABLE, "true", DB_VARS);
  
  QUEST = "ent_bark";  
  AddQuest(QUEST, RETRIEVE, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "You've already worked with ent twigs.  But to make things like shields and crossbows, you'll need to learn how to harvest " +
   "bark from our entish companions.  First, you will need fungus juice... you can find fungi in some caves.  Rub the fungus " +
   "juice on an ent, and then you'll be able to peel a strip of bark off.  You'll only be able to take loose bark, so if you " +
   "have a lot of juice, use it in small amounts at a time.  Show you've managed this by bringing me a piece of bark.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "250", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "250", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "06_10", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "cnrbarkent", DB_VARS);
  SetStringValue(QUEST+NUM_ITEMS, "1", DB_VARS);
  
  QUEST = "kill_vampire";
  AddQuest(QUEST, KILL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
  "A vampire is blocking the bridge south of the village!  Please banish it at once.",
  DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "1000", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "250", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "2", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "07_10", DB_VARS);
  SetStringValue(QUEST+TARGET_TAG, "qst_vampire", DB_VARS); 

  QUEST = "kill_orc_scout";
  AddQuest(QUEST, KILL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
  "An arachne brought word of an orc scout skulking by the foothills. Orc axes must never be permitted in these woods. " + 
  "Deal with the problem,please.",
  DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "1000", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "250", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "2", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "07_10", DB_VARS);
  SetStringValue(QUEST+TARGET_TAG, "qst_orc_scout", DB_VARS);  
}
