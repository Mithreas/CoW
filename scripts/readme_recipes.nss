/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  readme_recipes
//
//  Desc:  Recipe creating instructions.
//
//  Author: David Bobeck 13Apr03
//
/////////////////////////////////////////////////////////
//
// WHAT DOES A CNR RECIPE DO?
//
// A CNR recipe defines a collection of components that, when put into
// the identified placeable object, will craft (create) an item...given
// the crafting PC meets the minimum level and beats the DC of the recipe.
// On success, the PC will be awarded the recipe's assigned XP.
//
// HOW DO I CREATE A PLACEABLE OBJECT THAT CAN CRAFT RECIPES?
//
// 1) Create a new placeable object - the wizard is good at this.
// 2) Check the "Usable", "Has Inventory" an "Plot" checkboxes.
// 3) Set your placeable's OnDisturbed handler to "cnr_device_od".
// 4a) If you want the PCs to see a dialog presenting the placeable's
//     recipe list, set your placeable's OnUsed handler to "cnr_device_ou".
// 4b) If you want the first satisfied recipe to be created automatically
//     (without interaction with a dialog), set your placeable's OnUsed
//     handler to "cnr_silent_ou".
// 5) If you chose 4a above, set the placeable's conversation file to
//    "cnr_c_recipe" and check the "No Interrupt" checkbox.
// 6) In your "user_recipe_init" file, you should add the placeable to CNR
//    with a call to CnrAddCraftingDevice("your placeable tag here");
//
//
//  To define an animation script to be executed for each recipe assigned to
//  this crafting device, use the following…
/////////////////////////////////////////////////////////
//  sDeviceTag = the tag of the crafting placeable.
//  sScript = a script that wil be executed when the player attempts to
//            craft a recipe.
//  void CnrRecipeSetDevicePreCraftingScript(string sDeviceTag, string sScript);
//  (No animation is assigned by default)
//
//
//  If you prefer to have crafted items remain in the device's inventory rather
//  than getting transferred into the player's inventory, use the following…
/////////////////////////////////////////////////////////
//  sDeviceTag = the tag of the crafting placeable.
//  bSpawnItemInDevice = if TRUE, item made are left in the device. Otherwise
//                       the items are moved to the PC for convenience.
//  void CnrRecipeSetDeviceSpawnItemInDevice(string sDeviceTag, int bSpawnItemInDevice);
//  (Unless specified, crafted items are moved to the PC's inventory by default)
//
//
//  If your players must possess a specific item to operate the crafting device,
//  use the following…
/////////////////////////////////////////////////////////
//  sDeviceTag = the tag of the crafting placeable.
//  sToolTag = the tag of the tool or item required to be in the player's
//             inventory before gaining access to the crafting device.
//  void CnrRecipeSetDeviceInventoryTool(string sDeviceTag, string sToolTag, int nBreakagePercentage=0);
//  (By default, no item is required)
//
//
//  If your players must equip a specific item to operate the crafting device,
//  use the following...
/////////////////////////////////////////////////////////
//  sDeviceTag = the tag of the crafting placeable.
//  sToolTag = the tag of the tool or item required to be equipped by
//             the player before gaining access to the crafting device.
//  void CnrRecipeSetDeviceEquippedTool(string sDeviceTag, string sToolTag, int nBreakagePercentage=0);
//  (By default, no item is required)
//
//
//  To track the work done at this crafting device, assign a trade using the
//  following...
/////////////////////////////////////////////////////////
//  sDeviceTag = the tag of the crafting placeable.
//  nTradeskillType = CNR_TRADESKILL_*** (see "cnr_config_inc")
//  void CnrRecipeSetDeviceTradeskillType(string sDeviceTag, int nTradeskillType);
//
//
// HOW DO I CREATE A RECIPE ASSOCIATED WITH A PLACEABLE?
//
// 1) Add a call to CnrRecipeCreateRecipe into your "user_recipe_init" file as
//    described below...
//
// string CnrRecipeCreateRecipe(string sDeviceTag,
//                              string sRecipeDesc,
//                              string sRecipeTag,
//                              int nQtyMade)
//
//  sDeviceTag = the tag of the crafting placeable.
//  sRecipeDesc = the description of the recipe (what the recipe will make).
//  sRecipeTag = the tag of the item the recipe will make.
//  nQtyMade = the quantity of sRecipeTag items the recipe makes.
//  NOTE: the returned string represents a key to permit further
//        access to the recipe just created.
//
// Example...
// If you want a chest to craft a single heal potion, use...
// CnrRecipeCreateRecipe("Chest ABC", "Heal Potion", "NW_IT_MPOTION012", 1);
//
// 2) Add as many calls to CnrRecipeAddComponent as required. See details
//    below...
//
// void CnrRecipeAddComponent(string sKeyToRecipe,
//                            string sComponentTag,
//                            int nComponentQty,
//                            int nRetainOnFailQty=0)
//
//  sKeyToRecipe = the string returned from CnrRecipeCreateRecipe()
//  sComponentTag = the tag of one of the items required by the recipe.
//  nComponentQty = the quantity of sComponentTag items required by the recipe
//  nRetainOnFailQty = the number of items to remain in the
//                     crafting placeable's inventory after a failed
//                     attempt to craft the recipe.
//
// Example...
// If you want the above heal potion to require 1 skeleton knuckle
// and 1 cure light potion, and both items are to be destroyed on failure...
// CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_MSMLMISC13", 1, 0);
// CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_MPOTION001", 1, 0);
//
// 3) Set the recipe's XP with...
//   CnrRecipeSetRecipeXP(sKeyToRecipe, <the XP here>);
//
// 4) Set the recipe's level with...
//   CnrRecipeSetRecipeLevel(sKeyToRecipe, <the level here>);
//
// 5) Use the following if you want the recipe to produce a bi-product.
//    (ex: this is useful for creating empty bottles when one of the recipe
//    components is a bottle filled with something. Or when a recipe simply
//    must create two items)
//
//  void CnrRecipeSetRecipeBiproduct(string sKeyToRecipe,
//                                   string sBiTag,
//                                   int nBiQty,
//                                   int nOnFailBiQty);
//
//  sKeyToRecipe = the string returned from CnrRecipeCreateRecipe()
//  sBiTag = the tag of an item that will be created as a bi-product of the recipe.
//  nBiQty = the quantity of sBiTag items created by the recipe
//  nOnFailBiQty = use a value > 0 if you want the bi-product to be created in
//                 the crafting placeable's inventory after a failed attempt to
//                 craft the recipe.
//
// 6) Use the following if you want this recipe to have unique animation. The
//    specified animation will run instead of the animation assigned (if any) to
//    the crafting device.
//
//  void CnrRecipeSetRecipePreCraftingScript(string sKeyToRecipe, string sScript);
//
//  sKeyToRecipe = the string returned from CnrRecipeCreateRecipe()
//  sScript = a script that wil be executed when the player attempts to
//            craft a recipe.
//
//  7) Define which player abilities to consider and what emphasis each ability
//     should have when rolling to beat the recipe's DC.
//
//   void CnrRecipeSetRecipeAbilityPercentages(string sKeyToRecipe,
//                                             int nStr,
//                                             int nDex,
//                                             int nCon,
//                                             int nInt,
//                                             int nWis,
//                                             int nCha);
//
//  sKeyToRecipe = the string returned from CnrRecipeCreateRecipe()
//  nXXX = the weighted percentage of the particular ability.
//  Note: The sum of all weighted ability percentages should equal 100.
//
//  8) Define a filter. CNR will first check to see if any item having sFilter as its tag
//     is located in the PC's inventory. If not found, CNR will then check for a local int
//     on the PC with sFilter as the VarName.
//
//   void CnrRecipeSetRecipeFilter(string sKeyToRecipe, string sFilter);
//
//  sKeyToRecipe = the string returned from CnrRecipeCreateRecipe().
//  sFilter = a string defining either a tag or a local variable set on the PC.
//
/////////////////////////////////////////////////////////

