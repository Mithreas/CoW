//::///////////////////////////////////////////////
//:: Item Update Library
//:: inc_itemupdates
//:://////////////////////////////////////////////
/*
    Handles item updates, useful for adding
    new features to existing items, as well as
    bug fixes and necessary buffs/nerfs.

    UpdateItem() is the main driver and should be
    called whenever an item is acquired.

    Scripts will then be called sequentially
    on the item using the following format:

    upd_<itemtag><versionnumber>

    Note that all underscores will be removed from
    the tag, and only the left-most portion of the
    tag will be taken to fill the full 16
    characters allowed for script names in the
    toolset.

    Version number refers to the version being
    updated to, with 1 being the number of the
    first update (i.e. the item in its release
    state would effectively be version 0).

    For example, given an item with the tag
    "sword_of_fubar" and the following scripts
    in the module...

    upd_swordoffuba1
    upd_swordoffuba2

    The first script would be called to update
    the item, and then the second -- if the item has
    never been updated. If the item had previously
    been updated to version 1, then only the second
    of the two scripts would be called.

    Note that in the above script names,
    underscores have been removed from the tag,
    and the end has been truncated to accommodate
    the sixteen character limit for script
    names.

    Finally, note that FlagItemUpdated() must
    be called from every upd_ script for updates
    to apply successfully.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 25, 2017
//:://////////////////////////////////////////////

#include "x2_inc_switches"
#include "x3_inc_string"

/**********************************************************************
 * CONFIG PARAMETERS
 **********************************************************************/

// Prefix for all item update scripts.
const string ITEM_UPDATE_SCRIPT_PREFIX = "upd_";

// Constant on items to designate its current version number.
const string ITEM_VERSION_NUMBER_CONSTANT = "VERSION_NUMBER";

/**********************************************************************
 * CONSTANT DEFINITIONS
 **********************************************************************/

// Maximum characters a script name can hold in the toolset.
const int SCRIPT_NAME_MAXIMUM_LENGTH = 16;

// Return value given when an item has been updated.
const int RETURN_VALUE_ITEM_UPDATED = 1;

/**********************************************************************
 * PUBLIC FUNCTION PROTOTYPES
 **********************************************************************/

// Flags the item has having been updated and increments its version number appropriately.
// This must be called from every item update script (i.e. "upd_") for updates to be
// applied successfully.
void FlagItemUpdated();
// Returns the current version number of the given item.
int GetItemVersionNumber(object oItem);
// Sets the current version number of the given item.
void SetItemVersionNumber(object oItem, int nVersionNumber);
// Updates the item, calling all related "upd_" scripts. See documentation in inc_itemupdates
// for useage details.
void UpdateItem(object oItem);

/**********************************************************************
 * PUBLIC FUNCTION DEFINITIONS
 **********************************************************************/

//::///////////////////////////////////////////////
//:: FlagItemUpdated
//:://////////////////////////////////////////////
/*
    Flags the item has having been updated and
    increments its version number appropriately.
    This must be called from every item update
    script (i.e. "upd_") for updates to be
    applied successfully.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 25, 2017
//:://////////////////////////////////////////////
void FlagItemUpdated()
{
    SetItemVersionNumber(OBJECT_SELF, GetItemVersionNumber(OBJECT_SELF) + 1);
    SetExecutedScriptReturnValue(RETURN_VALUE_ITEM_UPDATED);
}

//::///////////////////////////////////////////////
//:: GetItemVersionNumber
//:://////////////////////////////////////////////
/*
    Returns the current version number of the
    given item.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 25, 2017
//:://////////////////////////////////////////////
int GetItemVersionNumber(object oItem)
{
    return GetLocalInt(oItem, ITEM_VERSION_NUMBER_CONSTANT);
}

//::///////////////////////////////////////////////
//:: SetItemVersionNumber
//:://////////////////////////////////////////////
/*
    Sets the current version number of the
    given item.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 25, 2017
//:://////////////////////////////////////////////
void SetItemVersionNumber(object oItem, int nVersionNumber)
{
    SetLocalInt(oItem, ITEM_VERSION_NUMBER_CONSTANT, nVersionNumber);
}

//::///////////////////////////////////////////////
//:: UpdateItem
//:://////////////////////////////////////////////
/*
    Updates the item, calling all related "upd_"
    scripts. See documentation in inc_itemupdates
    for useage details.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 25, 2017
//:://////////////////////////////////////////////
void UpdateItem(object oItem)
{
    int nVersionNumber = GetItemVersionNumber(oItem);
    int nScriptLength;
    string sTag = StringReplace(GetTag(oItem), "_", "");

    do
    {
        nVersionNumber++;
        nScriptLength = SCRIPT_NAME_MAXIMUM_LENGTH - GetStringLength(ITEM_UPDATE_SCRIPT_PREFIX) - GetStringLength(IntToString(nVersionNumber));
    } while(ExecuteScriptAndReturnInt(ITEM_UPDATE_SCRIPT_PREFIX + GetStringLeft(sTag, nScriptLength) + IntToString(nVersionNumber), oItem));
}
