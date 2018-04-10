#include "gs_inc_common"
#include "inc_item"

void main()
{
  //---------------------------
  // Take:
  // blank book
  // woodcut
  // ink
  // book with text
  //
  // output
  // two books with text
  //---------------------------
  object oPress = OBJECT_SELF;
  object oItem = GetFirstItemInInventory(oPress);

  object oBlankBook;
  object oWoodcut;
  object oInk;
  object oBookToCopy;
  string sTag;

  while (GetIsObjectValid(oItem))
  {
    sTag = GetTag(oItem);
    if (sTag == "Book" &&
        (GetDescription(oItem, TRUE) == GetDescription(oItem, FALSE)))
    {
      oBlankBook = oItem;
    }
    else if (sTag == "mi_woodcut") oWoodcut = oItem;
    else if (sTag == "mi_ink") oInk = oItem;
    else if (GetBaseItemType(oItem) == BASE_ITEM_BOOK && GetIsItemCopyable(oItem)) oBookToCopy = oItem;

    oItem = GetNextItemInInventory(oPress);
  }

  if (GetIsObjectValid(oBlankBook) && GetIsObjectValid(oInk) &&
      GetIsObjectValid(oWoodcut) && GetIsObjectValid(oBookToCopy))
  {
    // play effects, copy book
    ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
    SpeakString("*The press whirs and clonks as it sets to work*");
    DelayCommand(5.0, ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));

    gsCMReduceItem(oWoodcut);
    gsCMReduceItem(oInk);
    gsCMReduceItem(oBlankBook);
    gsCMCopyItem(oBookToCopy, oPress, TRUE);
  }
  else
  {
    // Suppress the activation animation that usually plays.
    ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);
    SendMessageToPC(GetLastUsedBy(),
      "To use the press, put in a blank book, a woodcut, some ink and the book "
      + "that you wish to copy.");
  }
}
