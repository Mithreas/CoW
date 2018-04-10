void main()
{
 // don't face the speaker
 float fFacing = GetFacing(OBJECT_SELF);
 BeginConversation();
 SetFacing(fFacing);
}
