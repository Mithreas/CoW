void main()
{
    object oSelf = OBJECT_SELF;
    object oPC = GetLastUsedBy();

    if (!GetIsInCombat(oPC)) {
      AssignCommand(oPC, ActionStartConversation(oSelf, "", TRUE, FALSE));
    } else {
      FloatingTextStringOnCreature("You can't do this while you are in combat", oPC);
    }
}
