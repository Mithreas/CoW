/*
  Script to load all the quests into the database.
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


void main()
{
  string DB_QUEST;
  string DB_VARS;
  string QUEST;
  /* Set database type. MYSQL or SQLITE supported. */
  SetLocalString(GetModule(), "DB_TYPE", "MYSQL");

  /* House Renerrin Quests */
  DB_QUEST = "renerrin_quests";
  DB_VARS  = "renerrin_vars";

  QUEST = "train";
  SetStringValue(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "You could use some experience, I think. Head over to the Market Square, and " +
   "see if there are any small tasks for the people there. Otherwise, head down " +
   "to the Undercity Crypts. To get there, go to the Docks, head down into the " +
   "Undercity, and head south. There are never enough people to keep all the " +
   "dead at rest... and we suspect dark magic at play, too. Stay near the " +
   "entrances to the tombs, and you should be fine. \n\n When you think you're " +
   "ready to do more for the House, come back to me.",
   DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "01_01", DB_VARS);

  QUEST = "patrol_city";
  SetStringValue(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "I've heard there's trouble at the South Gates. Could you go there and check?",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "75", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "200", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "01_03", DB_VARS);
  SetStringValue(QUEST+AREA_TAGS, "southgates", DB_VARS);

  QUEST="drarayne_rats";
  SetStringValue(QUEST, HELP, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "A woman called Drarayne Thelas has appealed for help clearing out some " +
   "rats in her home. It would do the House's reputation good if we were seen "+
   "to help her. You can cope with that, can't you? Her house is in the " +
   "Northeast corner of the Merchants' District.", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "200", DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "10", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "01_03", DB_VARS);
  SetStringValue(QUEST+OTHER_NPC, "drarayne_thelas", DB_VARS);

  QUEST = "gather_gemstone";
  SetStringValue(QUEST, RETRIEVE, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "I need a gemstone, a phenalope. Can you get me one? I'll give you 50 gold for it.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "50", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "150", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "01_03", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "NW_IT_GEM004", DB_VARS);

  QUEST = "deliver_to_alian";
  SetStringValue(QUEST, MESSENGER, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
  "I've written a letter for an old friend, Alian. Will you take them to him? " +
  "You'll find him in the Imperial City, probably near the bank.",
  DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "01_15", DB_VARS);
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
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "01_15", DB_VARS);
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
  SetStringValue(QUEST+REWARD_FAC_REP, "2", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "02_05", DB_VARS);
  SetStringValue(QUEST+TARGET_TAG, "arin_meyo", DB_VARS);

  /* House Drannis Quests */
  DB_QUEST = "drannis_quests";
  DB_VARS  = "drannis_vars";

  QUEST = "train";
  SetStringValue(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "You could use some experience, I think. Head up to the Market Square, and " +
   "see if there are any small tasks for the people there. Otherwise, head down " +
   "to the Undercity Crypts. To get there, go to the Docks, head down into the " +
   "Undercity, and head south. There are never enough people to keep all the " +
   "dead at rest... and we suspect dark magic at play, too. Stay near the " +
   "entrances to the tombs, and you should be fine. \n\n When you think you're " +
   "ready to do more for the House, come back to me.",
   DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "01_01", DB_VARS);

  QUEST = "patrol_city";
  SetStringValue(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "I've heard there's trouble at the South Gates. Could you go there and check?",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "75", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "200", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "01_03", DB_VARS);
  SetStringValue(QUEST+AREA_TAGS, "southgates", DB_VARS);

  QUEST = "guard_arin_meyo";
  SetStringValue(QUEST, HELP, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "Arin Meyo is one of our more effective traders. Unfortunately, this means "+
   "that the other Houses don't like him much. Go and see if there's anything "+
   "you can do to make his life easier.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "100", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "200", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "02_05", DB_VARS);
  SetStringValue(QUEST+OTHER_NPC, "arin_meyo", DB_VARS);

  QUEST="drarayne_rats";
  SetStringValue(QUEST, HELP, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "A woman called Drarayne Thelas has appealed for help clearing out some " +
   "rats in her home. It would do the House's reputation good if we were seen "+
   "to help her. You can cope with that, can't you? Her house is in the " +
   "Northeast corner of the Merchants' District.", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "2", DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "10", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "200", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "01_03", DB_VARS);
  SetStringValue(QUEST+OTHER_NPC, "drarayne_thelas", DB_VARS);

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

  // 10+
  QUEST = "patrol_darzun_entrance";
  SetStringValue(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "We've had reports of Orcish patrols moving in and out of Dar'zun. I want " +
   "you to go down there and report to me what's happening. Be well prepared - " +
   "the orcs aren't to be taken lightly. Got that?", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "5000", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "10_15", DB_VARS);
  SetStringValue(QUEST+AREA_TAGS, "plainsofdarkness", DB_VARS);

  QUEST = "patrol_fire_pits";
  SetStringValue(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "There's a bridge deep in the depths, over the fire pits in the Fera Wastes. " +
   "I want you to go down there. Check the current status of the bridge, and " +
   "garrison it ", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "15000", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "15_20", DB_VARS);
  SetStringValue(QUEST+AREA_TAGS, "ferawastesfirepi", DB_VARS);


  /* House Erenia Quests */
  DB_QUEST = "erenia_quests";
  DB_VARS  = "erenia_vars";

  // Level 1+
  QUEST = "train";
  SetStringValue(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "You could use some experience, I think. Head over to the Market Square in the City, and " +
   "see if there are any small tasks for the people there. Otherwise, head down " +
   "to the Undercity Crypts. To get there, go to the Docks, head down into the " +
   "Undercity, and head south. There are never enough people to keep all the " +
   "dead at rest... and we suspect dark magic at play, too. Stay near the " +
   "entrances to the tombs, and you should be fine. \n\n When you think you're " +
   "ready to do more for the House, come back to me.",
   DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "01_01", DB_VARS);

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
  SetStringValue(QUEST+LEVEL_RANGE, "01_01", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "X1_WMGRENADE005", DB_VARS);

  QUEST="drarayne_rats";
  SetStringValue(QUEST, HELP, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "A woman called Drarayne Thelas has appealed for help clearing out some " +
   "rats in her home. It would do the House's reputation good if we were seen "+
   "to help her. You can cope with that, can't you? Her house is in the " +
   "Northeast corner of the Merchants' District.", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "10", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "200", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "01_03", DB_VARS);
  SetStringValue(QUEST+OTHER_NPC, "drarayne_thelas", DB_VARS);

  QUEST="pilgrimmage";
  SetStringValue(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "You should visit the holy sites, to further your knowledge of the gods. " +
   "There are temples to Morrian and Solkin maintained by the other Houses, " +
   "as well as the Temple to the Seven of our own House. Finally, you should " +
   "visit the Grove of the Gods, here on Sunrise Isle. It's not far from the " +
   "entrance to Sunrise Tower.", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "200", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "2", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "01_20", DB_VARS);
  SetStringValue(QUEST+AREA_TAGS,
                 "groveofthegods,templeoftheseven,templetomorri001,templetosolkin",
                 DB_VARS);

  // Level 2+
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
  SetStringValue(QUEST+REWARD_FAC_REP, "2", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "02_05", DB_VARS);
  SetStringValue(QUEST+TARGET_TAG, "arin_meyo", DB_VARS);

  QUEST="paronjariandesk";
  SetStringValue(QUEST, PATROL, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "I'd like you to go and check Cardinal Jarian's house. Due to his age and "+
   "station, he's often targetted by members of other Houses. Please check " +
   "his desk and make sure there's nothing untoward in it... his house is near "+
   "the docks, here on Sunrise Isle.", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "02_06", DB_VARS);
  SetStringValue(QUEST+AREA_TAGS, "paronjarianshous", DB_VARS);

  QUEST="paronjarian";
  SetStringValue(QUEST, HELP, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "Go and see if Cardinal Jarian needs any help. He's usually found in " +
   "the Garden of Contemplation, near the docks.", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "02_06", DB_VARS);
  SetStringValue(QUEST+OTHER_NPC, "paronjarian", DB_VARS);

  QUEST = "gather_incense";
  SetStringValue(QUEST, RETRIEVE, DB_QUEST);
  SetStringValue(QUEST+DESCRIPTION,
   "I'm low on incense. Please can you fetch me a couple of sticks? The temple "
   + "will have some.",
   DB_VARS);
  SetStringValue(QUEST+REWARD_GOLD, "500", DB_VARS);
  SetStringValue(QUEST+REWARD_XP, "150", DB_VARS);
  SetStringValue(QUEST+REWARD_FAC_REP, "1", DB_VARS);
  SetStringValue(QUEST+LEVEL_RANGE, "02_20", DB_VARS);
  SetStringValue(QUEST+ITEM_TAG, "stickofincense", DB_VARS);
  SetStringValue(QUEST+NUM_ITEMS, "2", DB_VARS);

}
