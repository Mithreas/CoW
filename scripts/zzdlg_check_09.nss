// zzdlg_check_09
//
// Original filename under Z-Dialog: zdlg_check_09
// Copyright (c) 2004 Paul Speed - BSD licensed.
//  NWN Tools - http://nwntools.sf.net/
//
// Additions and changes from original copyright (c) 2005-2006 Greyhawk0

#include "zzdlg_tools_inc"

const int ENTRY_NUM = 9;

int StartingConditional()
{
    object oSpeaker = _dlgGetPcSpeaker();
    return( _SetupDlgResponse( ENTRY_NUM - 1, oSpeaker ) );
}
