void main()
{
    object oSpeaker = GetPCSpeaker();
    object oSelf    = OBJECT_SELF;

    AssignCommand(oSpeaker, ActionInteractObject(oSelf));
}
