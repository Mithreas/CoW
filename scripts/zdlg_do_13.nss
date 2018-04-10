/**
 *  $Id: zdlg_do_13.nss,v 1.5 2004/09/18 19:11:45 paul Exp $
 *
 *  Entry selection script for the Z-Dialog system.
 *
 *  Copyright (c) 2004 Paul Speed - BSD licensed.
 *  NWN Tools - http://nwntools.sf.net/
 */
#include "zdlg_include_i"

const int ENTRY_NUM = 13;

void main()
{
    _DoDlgSelection( GetPCSpeaker(), ENTRY_NUM - 1 );
}
