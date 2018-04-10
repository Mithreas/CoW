// OnOpen event of door.  Automatically closes after 20 seconds.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 09/14/2003 jpavelch         Last Recorded Revision.
//

void main()
{
    DelayCommand( 20.0, ActionCloseDoor(OBJECT_SELF) );
}
