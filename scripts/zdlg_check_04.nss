/**
 *  $Id: zdlg_check_04.nss,v 1.5 2004/09/18 19:11:45 paul Exp $
 *
 *  Entry conditional check for the Z-Dialog system.
 *
 *  Copyright (c) 2004 Paul Speed - BSD licensed.
 *  NWN Tools - http://nwntools.sf.net/
 */
#include "inc_zdlg"

const int ENTRY_NUM = 4;

int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();
    return( _SetupDlgResponse( ENTRY_NUM - 1, oSpeaker ) );
}
