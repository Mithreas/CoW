// zzdlg_do_10
//
// Original filename under Z-Dialog: zdlg_do_10
// Copyright (c) 2004 Paul Speed - BSD licensed.
//  NWN Tools - http://nwntools.sf.net/
//
// Additions and changes from original copyright (c) 2005-2006 Greyhawk0

#include "zzdlg_tools_inc"

const int ENTRY_NUM = 10;

void main()
{
    _dlgDoSelection( _dlgGetPcSpeaker(), ENTRY_NUM - 1 );
}
