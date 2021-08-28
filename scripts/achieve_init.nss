// Run on startup to initialise achievements.
#include "inc_achievements"

void main()
{
  acClearAchievements();
  
  // Shapechanger achievements
  acInitialise("werecats", "Found Werecats", "Discovered a clan of werecats.");
  acInitialise("wererats", "Found Wererats", "Discovered a clan of wererats.");
  acInitialise("werebeetles", "Found Werebeetles", "Discovered a clan of werebeetles.");
  acInitialise("weresharks", "Found Weresharks", "Discovered a clan of weresharks.");
  
  // Levelling achievements  
  acInitialise("level10", "Level 10", "Reached level 10.");
  acInitialise("level11", "Level 11", "Reached level 11.");
  acInitialise("level12", "Level 12", "Reached level 12.");
  acInitialise("level13", "Level 13", "Reached level 13.");
  acInitialise("level14", "Level 14", "Reached level 14.");
  acInitialise("level15", "Level 15", "Reached level 15 - max level!");
  
  acInitialise("level10ren", "Level 10 (Renerrin)", "Reached level 10 as a House Renerrin player.");
  acInitialise("level10dran", "Level 10 (Drannis)", "Reached level 10 as a House Drannis player.");
  acInitialise("level10eren", "Level 10 (Erenia)", "Reached level 10 as a House Erenia player.");
  acInitialise("level10shad", "Level 10 (Shadow)", "Reached level 10 as a Shadow player.");
  acInitialise("level10fern", "Level 10 (Fernvale)", "Reached level 10 as a Fernvale player.");
  acInitialise("level10ward", "Level 10 (Wardens)", "Reached level 10 as a Wardens player.");
  acInitialise("level10aire", "Level 10 (Airevorn)", "Reached level 10 as an Airevorn player.");
  
  acInitialise("carp20", "Master Carpenter", "Reached Carpentry level 20.");
  acInitialise("arm20", "Master Armourer", "Reached Armoursmithing level 20.");
  acInitialise("weap20", "Master Weaponsmith", "Reached Weaponsmithing level 20.");
  acInitialise("jewel20", "Master Jeweller", "Reached Jewellery level 20.");
  acInitialise("tailor20", "Master Tailor", "Reached Tailoring level 20.");
  acInitialise("invest20", "Master Investor", "Reached Investing level 20.");
  acInitialise("imbue20", "Master Imbuer", "Reached Imbuing level 20.");
  acInitialise("chem20", "Master Alchemist", "Reached Chemistry level 20.");
  //acInitialise("cook20", "Master Chef", "Reached Cooking level 20.");
  //acInitialise("enchant20", "Master Enchanter", "Reached Enchanting level 20.");
  
  // Boss killing achievements
  acInitialise("shelob", "Need A Bigger Bugswat?", "Killed Fera'Deth.");
  acInitialise("watcher", "Can't Hide, Don't Need To", "Killed the Watcher in the Deep.");
  acInitialise("hrongar", "Feeling Horny", "Killed Hrongar the Horned.");
  acInitialise("ysera", "Morning Person", "Defeated Ysera, the Emerald Dream.");
  acInitialise("calyn", "Thankfully Didn't Have To Spell Its Name", "Defeated Calynsedrianas.");
  acInitialise("stirges", "Bugs Bugs Everywhere", "Killed Cenarius.");
  acInitialise("nagashi", "A Mistake Addressed", "Killed Nagashi, the Forsaken.");
  acInitialise("mushroom", "Mushrooms for Dinner", "Defeated the Myconid Mind");
  
  // Exploration achievements
  acInitialise("undercity", "A Wretched Hive of Scum and Villainy", "Discovered the Dead Man's Walk Inn at the heart of the Undercity.");
  acInitialise("airevorn", "Love Conquers All", "Discovered Airevorn.");
  acInitialise("izuna", "She's So Hot", "Discovered Izuna's lair in the heart of the volcano.");
  acInitialise("akavos", "He's So Hot", "Discovered Akavos' lair in the heart of the volcano.");
  acInitialise("elakadencia", "The Fairy Queen", "Discovered a Fairy Queen.  You can get this achievement multiple times.");
  acInitialise("trixiveria", "The Fairy Queen", "Discovered a Fairy Queen.  You can get this achievement multiple times.");
  acInitialise("seravithia", "Mother of Magic", "Discovered Seravithia's aerie.");
  acInitialise("death", "The Gates of Death", "Passed through the gates of Death.");
  acInitialise("lostlibrary", "Lost Library", "Discovered a lost library, hidden away.");
  acInitialise("dunkhazak", "World's Biggest Campsite", "Discovered Dun Khazak.");
    
  // Misc achievements
  acInitialise("miscast", "Miscast a Spell", "Had a spell go wrong due to a wild magic zone.");
  acInitialise("billygoat", "Billy Goat Gruff", "Killed a Bridge Troll.");
  acInitialise("feydiner", "Dinner Guest", "Escaped the Fey Banquet.");
  acInitialise("ghost_death", "Corporeal Again", "Recovered your physical form after an accident in Death.");
  
}