//  ScarFace's Persistent Banking system  - Listen -
void main()
{
    DeleteLocalString(OBJECT_SELF, "GOLD");
    SetListening(OBJECT_SELF, TRUE);
    SetListenPattern(OBJECT_SELF, "*n", 1);
    SetLocalObject(OBJECT_SELF, "Speaker", GetPCSpeaker());
}
