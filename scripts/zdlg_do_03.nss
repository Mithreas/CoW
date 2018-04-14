/**
 *  $Id: zdlg_do_03.nss,v 1.5 2004/09/18 19:11:45 paul Exp $
 *
 *  Entry selection script for the Z-Dialog system.
 *
 *  Copyright (c) 2004 Paul Speed - BSD licensed.
 *  NWN Tools - http://nwntools.sf.net/
 */
#include "inc_zdlg"

const int ENTRY_NUM = 3;

void main()
{
    _DoDlgSelection( GetPCSpeaker(), ENTRY_NUM - 1 );
}
