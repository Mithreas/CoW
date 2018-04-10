// OnOpen event of door.  Automatically closes after 60 seconds.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 09/14/2003 jpavelch         Last Recorded Revision.
//

void main()
{
    DelayCommand( 60.0, ActionCloseDoor(OBJECT_SELF) );
}
