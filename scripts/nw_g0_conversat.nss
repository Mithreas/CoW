////////////////////////////////////////////////////////////
// OnConversation
// g_ConversationDG.nss
// Copyright (c) 2001 Bioware Corp.
////////////////////////////////////////////////////////////
// Created By: Noel Borstad
// Created On: 04/25/02001
// Description: This is the default script that is called if
//              no OnConversation script is specified.
////////////////////////////////////////////////////////////

void main()
{


    // When a placable is set to listening, it will fire the default OnConversation script, nw_g0_conversat


    if ( GetListenPatternNumber() == -1 )
    {
        BeginConversation();
    }
    // Because a listening placeable triggers this script, we can then create a hook to OnUserDefined on the placeable.
    if ((GetObjectType(OBJECT_SELF) == OBJECT_TYPE_PLACEABLE)||(GetObjectType(OBJECT_SELF) == OBJECT_TYPE_DOOR))
    {
      event eListen = EventUserDefined(EVENT_DIALOGUE);
      SignalEvent(OBJECT_SELF,eListen);
    }
}
