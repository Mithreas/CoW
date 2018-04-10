//  ScarFace's Persistent Banking system - OnConversation -
void main()
{
    if(!IsInConversation(OBJECT_SELF))
    {
      BeginConversation();
    }
    else
    {
      string sGold;
      object oSpeaker = GetLastSpeaker();
      object oPC = GetLocalObject(OBJECT_SELF, "Speaker");

      if ((GetListenPatternNumber() == 1) && (oSpeaker == oPC))
      {
        sGold = GetMatchedSubstring(0);
        SetLocalString(OBJECT_SELF, "GOLD", sGold);
        SetCustomToken(1000, sGold);
      }
    }
}
