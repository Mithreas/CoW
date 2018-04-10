// Verifies that PC has enough gold to gamble.
//
// Revision History
// Date        Name               Description
// ----------  ------------------ ------------------------------------------
// 08/12/2003  Artos              Initial Release
//


int StartingConditional( )
{
    return ( GetGold(GetPCSpeaker()) >= 100 );
}
