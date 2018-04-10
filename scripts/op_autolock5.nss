void main( )
{
    object oDoor = OBJECT_SELF;

    DelayCommand( 5.0, ActionCloseDoor(oDoor) );
    SetLocked( oDoor, TRUE );
}
