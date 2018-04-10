/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  readme_books
//
//  Desc:  Recipe Book initialization instructions.
//
//  Author: David Bobeck 13Apr03
//
/////////////////////////////////////////////////////////
//
// WHAT DOES A CNR RECIPE BOOK DO?
//
// A CNR recipe book is an item the PC can carry around which, when
// activated, will display a list of recipes. There are two flavors
// of these books... (1) "For reference only". These books display the
// recipes supported by a crafting device. They can be thought of as
// grocery lists. (2) "Crafting books". These will not only display
// a list of recipes like #1, but also permits crafting of the recipes
// without the need for an associated crafting device.
//
// HOW DO I CREATE A CNR RECIPE BOOK?
//
// 1) Create a new item object - the wizard is good at this. You can
//    choose the book category, but a cnr recipe book can be any item.
//    Wands, scrolls, staffs or other magical items make good
//    "crafting" books.
// 2) Under the item's properties tab, expand "Cast Spell" and assign the
//    "Unique Power Self Only" property. Also, set the number of uses.
// 3) Add a call to CnrRecipeBookCreateBook() into your "user_book_init"
//    file. (see details below)
// 4) Execute the script "cnr_module_oml" from the module's OnModuleLoad
//    event handler.
// 5) That's it.
//
// HOW DO I INITIALIZE A CNR RECIPE BOOK?
//
// A book is initialized using the following function call...
//
//  string CnrRecipeBookCreateBook(string sBookTag, string sDeviceTag);
//
//  where...
//    sBookTag = the tag of the book the recipes will appear in when activated.
//    sDeviceTag = the tag of the placeable that crafts the recipes. (typically
//                 defined in "user_recipe_init".)
//    The function returns a unique string to be used in a subsequent call to
//    set the book's description.
//    NOTE: To make a "crafting" book, pass the book's tag in sDeviceTag as well.
//          You will also need to define the recipes the book will craft. I
//          recommend you put the recipe definitions where you create the book.
//          (I have an example of this below... see cnrTestScroll)
//
// Additionally, you can set a description for the book using the following call...
//
//  void CnrRecipeBookSetDescription(string sKeyToBook, string sDescription);
//
//  where...
//    sKeyToBook = a unique string returned from CnrRecipeBookCreateBook.
//    sDescription = the book's convo greeting text.
//
/////////////////////////////////////////////////////////

