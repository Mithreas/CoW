/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_book_init
//
//  Desc:  Recipe Book initialization. This script is
//         executed from "cnr_module_oml".
//
//  Author: David Bobeck 05Dec02
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"

void main()
{
  // Module builders: You should add your recipe books to the
  // file "user_book_init" so that future versions of
  // CNR don't over-write your work.

  // Translators: You should duplicate the calls below in a
  // file named "user_book_init" and translate the text there
  // so that future versions of CNR don't over-write your work.
  // Note: Duplicate calls to CnrRecipeBookCreateBook will return
  // the same key.
  
  string sKeyToBook;
  string sDesc;
  string sKeyToRecipe;

  PrintString("cnr_book_init");

  /////////////////////////////////////////////////////////
  // Default CNR reference recipe book for cnrBrewersKeg
  /////////////////////////////////////////////////////////
  sKeyToBook = CnrRecipeBookCreateBook("cnrCardsBrewKeg", "cnrBrewersKeg");
  sDesc = "A Brewer's Keg can be used to craft a variety of liqours. ";
  sDesc = sDesc + "Wort and water are required components. Hops and yeast are used in most. ";
  sDesc = sDesc + "Many beers, like lambics, use special ingredients to add flavor. ";
  sDesc = sDesc + "Whatever the ingredients, the mixture must be cooled and left to ferment. ";
  sDesc = sDesc + "As the sugars ferment, alcohol is produced.";
  CnrRecipeBookSetDescription(sKeyToBook, sDesc);

  /////////////////////////////////////////////////////////
  // Default CNR reference recipe book for cnrBrewersKettle
  /////////////////////////////////////////////////////////
  sKeyToBook = CnrRecipeBookCreateBook("cnrCardsWort", "cnrBrewersKettle");
  sDesc = "After being milled, malted grain can be mixed with hot water in a brewer's kettle. ";
  sDesc = sDesc + "In the heated kettle, the malt sugars will infuse in the water. ";
  sDesc = sDesc + "The resulting concoction is known as wort.";
  CnrRecipeBookSetDescription(sKeyToBook, sDesc);

  /////////////////////////////////////////////////////////
  // Default CNR reference recipe book for cnrBakersOven
  /////////////////////////////////////////////////////////
  sKeyToBook = CnrRecipeBookCreateBook("cnrCardsBakeOven", "cnrBakersOven");
  CnrRecipeBookSetDescription(sKeyToBook, "A Baker's oven can make some tasty treats!");

  /////////////////////////////////////////////////////////
  // Default CNR reference recipe book for cnrAlchemyTable
  /////////////////////////////////////////////////////////
  sKeyToBook = CnrRecipeBookCreateBook("cnrCardsAlchemy", "cnrAlchemyTable");
  sDesc = "Although the recipes within this book appear to have been scribed recently, ";
  sDesc = sDesc + "you have no reason to dispute the authenticity of these writings.";
  CnrRecipeBookSetDescription(sKeyToBook, sDesc);

  /////////////////////////////////////////////////////////
  // Default CNR reference recipe book for cnrAnvilPublic
  /////////////////////////////////////////////////////////
  sKeyToBook = CnrRecipeBookCreateBook("cnrCardsWeapons", "cnrAnvilPublic");
  sDesc = "Although the recipes within this book appear to have been scribed recently, ";
  sDesc = sDesc + "you have no reason to dispute the authenticity of these writings.";
  CnrRecipeBookSetDescription(sKeyToBook, sDesc);

  /////////////////////////////////////////////////////////
  // Default CNR reference recipe book for cnrGemTable
  /////////////////////////////////////////////////////////
  sKeyToBook = CnrRecipeBookCreateBook("cnrCardsJewelry", "cnrGemTable");
  sDesc = "Although the recipes within this book appear to have been scribed recently, ";
  sDesc = sDesc + "you have no reason to dispute the authenticity of these writings.";
  CnrRecipeBookSetDescription(sKeyToBook, sDesc);

  /////////////////////////////////////////////////////////
  // Default CNR reference recipe book for cnrEnchantAltar
  /////////////////////////////////////////////////////////
  sKeyToBook = CnrRecipeBookCreateBook("cnrCardsEnchAlt", "cnrEnchantAltar");
  sDesc = "Although the recipes within this book appear to have been scribed recently, ";
  sDesc = sDesc + "you have no reason to dispute the authenticity of these writings.";
  CnrRecipeBookSetDescription(sKeyToBook, sDesc);

  /////////////////////////////////////////////////////////
  // Default CNR reference recipe book for cnrEnchantPool
  /////////////////////////////////////////////////////////
  sKeyToBook = CnrRecipeBookCreateBook("cnrCardsEnchPool", "cnrEnchantPool");
  sDesc = "Although the recipes within this book appear to have been scribed recently, ";
  sDesc = sDesc + "you have no reason to dispute the authenticity of these writings.";
  CnrRecipeBookSetDescription(sKeyToBook, sDesc);

  /////////////////////////////////////////////////////////
  // Default CNR reference recipe book for cnrEnchantStatue
  /////////////////////////////////////////////////////////
  sKeyToBook = CnrRecipeBookCreateBook("cnrCardsEnchStat", "cnrEnchantStatue");
  sDesc = "Although the recipes within this book appear to have been scribed recently, ";
  sDesc = sDesc + "you have no reason to dispute the authenticity of these writings.";
  CnrRecipeBookSetDescription(sKeyToBook, sDesc);

  /////////////////////////////////////////////////////////
  // Default CNR reference recipe book for cnrCarpsBench
  /////////////////////////////////////////////////////////
  sKeyToBook = CnrRecipeBookCreateBook("cnrCardsWood", "cnrCarpsBench");
  sDesc = "Although the recipes within this book appear to have been scribed recently, ";
  sDesc = sDesc + "you have no reason to dispute the authenticity of these writings.";
  CnrRecipeBookSetDescription(sKeyToBook, sDesc);

  /////////////////////////////////////////////////////////
  // Default CNR reference recipe book for cnrTinkerDevice
  /////////////////////////////////////////////////////////
  sKeyToBook = CnrRecipeBookCreateBook("cnrCardsTinkDevi", "cnrTinkersDevice");
  sDesc = "Although the recipes within this book appear to have been scribed recently, ";
  sDesc = sDesc + "you have no reason to dispute the authenticity of these writings.";
  CnrRecipeBookSetDescription(sKeyToBook, sDesc);

  /////////////////////////////////////////////////////////
  // Default CNR reference recipe book for cnrTinkerToolbox
  /////////////////////////////////////////////////////////
  sKeyToBook = CnrRecipeBookCreateBook("cnrCardsTinkTbox", "cnrTinkerToolbox");
  sDesc = "Although the recipes within this book appear to have been scribed recently, ";
  sDesc = sDesc + "you have no reason to dispute the authenticity of these writings.";
  CnrRecipeBookSetDescription(sKeyToBook, sDesc);

  /////////////////////////////////////////////////////////
  // Default CNR reference recipe book for cnrAnvilArmor
  /////////////////////////////////////////////////////////
  sKeyToBook = CnrRecipeBookCreateBook("cnrCardsArmor", "cnrAnvilArmor");
  sDesc = "Although the recipes within this book appear to have been scribed recently, ";
  sDesc = sDesc + "you have no reason to dispute the authenticity of these writings.";
  CnrRecipeBookSetDescription(sKeyToBook, sDesc);

  /////////////////////////////////////////////////////////
  // Example CNR "crafting" recipe book. This scroll will
  // convert skeleton knuckles into potions of cure light!
  /////////////////////////////////////////////////////////
  sKeyToBook = CnrRecipeBookCreateBook("cnrTestScroll", "cnrTestScroll");
  sDesc = "This is an example of a crafting recipe book. It allows crafting without a device! ";
  sDesc = sDesc + "Recipe books don't have to be derived from book base object types. ";
  sDesc = sDesc + "They can be any item. A ring, wand, staff, amulet, or necklace might ";
  sDesc = sDesc + "be more appropriate. This item allows the possessor to transform one ";
  sDesc = sDesc + "item into another! The module builder can set the number of uses. A very powerful concept!";
  CnrRecipeBookSetDescription(sKeyToBook, sDesc);

  // You will find the following two lines in a file named "cnrtestscroll"
  //sKeyToRecipe = CnrRecipeCreateRecipe("cnrTestScroll", "Potion of Cure Light", "NW_IT_MPOTION001", 1);
  //CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_MSMLMISC13", 1); // skeleton knuckle
  CnrAddCraftingDevice ("cnrTestScroll");

  // Module builders: You should add your recipe books to the
  // file "user_book_init" so that future versions of
  // CNR don't over-write your work.
  ExecuteScript("user_book_init", OBJECT_SELF);
  // Note: This line is located at the end of this script so that
  // you can change the descriptions of the default books I've
  // created simply by making another call to CnrRecipeBookSetDescription

}
