/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  readme_plants
//
//  Desc:  Plant initialization instructions.
//
//  Author: David Bobeck 13Apr03
//
/////////////////////////////////////////////////////////
//
// WHAT DOES A CNR PLANT DO?
//
// A CNR plant is a placeable object that represents something like
// a tree, a bush, a chest, or even a spider cacoon. Plants produce
// resource items, like apples, or berries, or potions, or spider silk.
//
// HOW DO I CREATE A CNR PLANT?
//
// 1) Create a new placeable object - the wizard is good at this.
// 2) Check both the "Usable" and "Has Inventory" checkboxes.
// 3) Add the appropriate 'fruit' item to the plant's inventory. (You may
//    need to create the fruit item before this step)
// 4) Set your plant's OnDisturbed handler to "cnr_plant_ondist".
// 5) Add a call to CnrPlantInitialize() into the "user_plant_init"
//    file. (see details below)
// 6) That's it.
//
// HOW DO I INITIALIZE A CNR PLANT?
//
// A plant is initialized using one function call. This is the prototype...
//
// void CnrPlantInitialize(string sPlantTag,
//                         string sFruitTag,
//                         int nMaxQty,
//                         float fSpawnSecs);
//
//  sPlantTag = the tag of the plant placeable.
//  sFruitTag = the tag of the item the plant will yield and spawn.
//  nMaxQty = a random number of fruit between 1 and nMaxQty will be spawned.
//  fSpawnSecs = the time a plant waits, after its inventory has been depleted,
//               before spawning more fruit.
//  nSpawnMode = if 0, mode will be determined by CNR_BOOL_RESPAWN_PLANTS_NOT_FRUIT
//                  config setting.
//               CNR_INT_ALWAYS_RESPAWN_FRUIT: overrides config setting.
//               CNR_INT_ALWAYS_RESPAWN_PLANT: overrides config setting.
//
// Examples...
// If you want an apple tree to yield up to 5 apples after 2 minutes, use...
// CnrPlantInitialize("cnrApplePlant", "cnrAppleFruit", 5, 120.0);
//
// If you want a chest to yield up to 3 heal potions after 1 minute, use...
// CnrPlantInitialize("Chest ABC", "NW_IT_MPOTION012", 3, 60.0);
//
/////////////////////////////////////////////////////////

