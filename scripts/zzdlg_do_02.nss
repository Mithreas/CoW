// zzdlg_do_02
//
// Original filename under Z-Dialog: zdlg_do_02
// Copyright (c) 2004 Paul Speed - BSD licensed.
//  NWN Tools - http://nwntools.sf.net/
//
// Additions and changes from original copyright (c) 2005-2006 Greyhawk0

#include "zzdlg_tools_inc"

const int ENTRY_NUM = 2;

void main()
{
    _dlgDoSelection( _dlgGetPcSpeaker(), ENTRY_NUM - 1 );
}
