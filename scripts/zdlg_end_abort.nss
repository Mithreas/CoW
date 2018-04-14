/**
 *  $Id: zdlg_end_abort.nss,v 1.4 2004/09/18 19:11:45 paul Exp $
 *
 *  Conversation abort event script for the Z-Dialog system.
 *
 *  Copyright (c) 2004 Paul Speed - BSD licensed.
 *  NWN Tools - http://nwntools.sf.net/
 */
#include "inc_zdlg"

void main()
{
    //PrintString( "Aborted." );
    object oSpeaker = GetPCSpeaker();
    _SendDlgEvent( oSpeaker, DLG_ABORT );
    _CleanupDlg( oSpeaker );
}
