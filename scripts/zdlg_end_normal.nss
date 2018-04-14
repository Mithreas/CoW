/**
 *  $Id: zdlg_end_normal.nss,v 1.4 2004/09/18 19:11:45 paul Exp $
 *
 *  Normal conversation end event script for the Z-Dialog system.
 *
 *  Copyright (c) 2004 Paul Speed - BSD licensed.
 *  NWN Tools - http://nwntools.sf.net/
 */
#include "inc_zdlg"

void main()
{
    //PrintString( "End normal." );
    object oSpeaker = GetPCSpeaker();
    _SendDlgEvent( oSpeaker, DLG_END );
    _CleanupDlg( oSpeaker );
}
