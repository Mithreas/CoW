void main()
{
    //slot 1

    object oSpeaker = GetPCSpeaker();
    int nID         = GetLocalInt(OBJECT_SELF, "GS_ID");
    int nValue      = GetLocalInt(OBJECT_SELF, "GS_OFFSET") + 0;

    SetColor(oSpeaker, nID, nValue);

    switch (Random(3))
    {
    case 0: PlayVoiceChat(VOICE_CHAT_PAIN1, oSpeaker); break;
    case 1: PlayVoiceChat(VOICE_CHAT_PAIN2, oSpeaker); break;
    case 2: PlayVoiceChat(VOICE_CHAT_PAIN3, oSpeaker); break;
    }
}
