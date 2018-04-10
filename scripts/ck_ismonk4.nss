// Conversation conditional to check if PC has at least four levels in the
// Monk class.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 11/30/2003 jpavelch         Initial Release.
//

int StartingConditional( )
{
    if ( GetIsPC(GetPCSpeaker()) )
        return TRUE;

    return ( GetLevelByClass(CLASS_TYPE_MONK, GetPCSpeaker()) >= 4 );
}
