// zzdlg_check_end
//
// Copyright 2005-2006 by Greyhawk0
//
//  This is a "End Dialog" option for the final farewell dialog.

#include "zzdlg_tools_inc"

int StartingConditional()
{
    object oSpeaker = _dlgGetPcSpeaker();

    string sPageName = GetLocalString( oSpeaker, DLG_PAGE_NAME );
    if (sPageName=="") return ( TRUE );

    return ( FALSE );
}
