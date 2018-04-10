// Conversation conditional that checks if PC is a bard of at least four
// levels.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 04/04/2004 jpavelch         Initial release.
//

int StartingConditional( )
{
    return ( GetLevelByClass(CLASS_TYPE_BARD, GetPCSpeaker()) >= 4 );
}
