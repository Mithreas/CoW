// Make a bench or coutch usable by 2 creatures simultaneously
// Stolen with pride from NWVault
void main()
{
    // Set some variable for a beter understanding
    object oPlayer = GetLastUsedBy();
    object oBench  = OBJECT_SELF;

    // Get a hold on the 2 pillows
    object oPillow1 = GetLocalObject( OBJECT_SELF, "Pillow 1" );
    object oPillow2 = GetLocalObject( OBJECT_SELF, "Pillow 2" );

    // If the sitting places do not exist, create them
    if( !GetIsObjectValid( oPillow1 ) )
    {
        // Set up some variable for understanding
        object oArea = GetArea( oBench );
        vector locBench = GetPosition( oBench );
        float fOrient  = GetFacing( oBench );

        // Calculate location of the 2 pillows
        location locPillow1 = Location( oArea, locBench + AngleToVector( fOrient + 90.0f ) / 2.0f, fOrient );
        location locPillow2 = Location( oArea, locBench + AngleToVector( fOrient - 90.0f ) / 2.0f, fOrient );

        // Create the 2 pillows
        oPillow1 = CreateObject( OBJECT_TYPE_PLACEABLE, "plc_invisobj", locPillow1 );
        oPillow2 = CreateObject( OBJECT_TYPE_PLACEABLE, "plc_invisobj", locPillow2 );

        // Memorise the places
        SetLocalObject( OBJECT_SELF, "Pillow 1", oPillow1 );
        SetLocalObject( OBJECT_SELF, "Pillow 2", oPillow2 );
    }

    // Chose the nearest pillow if not used and sit
    if( GetDistanceBetween( oPlayer, oPillow1 ) < GetDistanceBetween( oPlayer, oPillow2 ) )
    {
        if( !GetIsObjectValid( GetSittingCreature( oPillow1 ) ) )
        {
            AssignCommand( oPlayer, ActionSit( oPillow1 ) );
        }
        else
        {
            AssignCommand( oPlayer, ActionSit( oPillow2 ) );
        }
    }
    else
    {
        if( !GetIsObjectValid( GetSittingCreature( oPillow2 ) ) )
        {
            AssignCommand( oPlayer, ActionSit( oPillow2 ) );
        }
        else
        {
            AssignCommand( oPlayer, ActionSit( oPillow1 ) );
        }
    }
}
