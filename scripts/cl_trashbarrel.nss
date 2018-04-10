// OnClose event of the trash barrel.  Destroys all objects contained
// inside.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 10/20/2003 jpavelch         Initial Release.
//

void main()
{
    object oItem = GetFirstItemInInventory( );
    while ( GetIsObjectValid(oItem) ) {
        if ( GetPlotFlag(oItem) ) SetPlotFlag(oItem, FALSE);
        DestroyObject( oItem );
        oItem = GetNextItemInInventory( );
    }
}
