// zzdlg_end_normal
//
// Original filename under Z-Dialog: zdlg_end_normal
// Copyright (c) 2004 Paul Speed - BSD licensed.
//  NWN Tools - http://nwntools.sf.net/
//
// Additions and changes from original copyright (c) 2005-2006 Greyhawk0

//  Normal conversation end event script for the ZZ-Dialog system.

#include "zzdlg_tools_inc"

void main()
{
    object oSpeaker = _dlgGetPcSpeaker();
    _dlgSendEvent( oSpeaker, DLG_EVENT_END );
    _CleanupDlg( oSpeaker );
}
