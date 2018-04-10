//  ----------------------------------------------------------------------------
//  sj_tilemagic_dm
//  ----------------------------------------------------------------------------
/*
    Combined Module OnActivateItem Event script and Item Tag-based Scripting
    script.

    NOTE: this is work in progress and is currently limited to clearing the
    targeted tile. Additional functionality will be included as an update in due
    course.
*/
//  ----------------------------------------------------------------------------
/*
   Version: 1.00 - 26/06/04 - Sunjammer
    - created
*/
//  ----------------------------------------------------------------------------
#include "x2_inc_switches"
#include "sj_tilemagic_i"

void main()
{
    object oDM = GetItemActivator();
    object oItem = GetItemActivated();

    // if run as tag-based scripting: exclude all cases except ACTIVATE or if
    // run as module event: exclude all items except TileMagic DM widget
    // NOTE: X2_ITEM_EVENT_ACTIVATE = 0
    if(GetUserDefinedItemEventNumber() || GetTag(oItem) != SJ_TAG_TILEMAGIC_WIDGET)
    {
        return;
    }

    // TODO: *_GetColumnFromLocation & *_GetRowFromLocation
    vector vTarget = GetPositionFromLocation(GetItemActivatedTargetLocation());
    int nColumn = FloatToInt(vTarget.x) / 10;
    int nRow = FloatToInt(vTarget.y) / 10;

    // clear current tile
    SJ_TileMagic_ClearTile(GetArea(oDM), nColumn, nRow);
}
