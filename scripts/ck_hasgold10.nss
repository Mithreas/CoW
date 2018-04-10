// True if PC possesses at least 10 gold pieces.
//
// Revision History
// Date        Name               Description
// ----------  ------------------ ------------------------------------------
// 07/31/2003  Artos              Initial Release
//

int StartingConditional( )
{
    return ( GetGold(GetPCSpeaker()) >= 10 );
}
