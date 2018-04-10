void main()
{
    object oSelf = OBJECT_SELF;

    // use this for quarters that are only available to druids

    // check if PC has druid levels
    object oPC = GetLastUsedBy();
    if (GetLevelByClass(CLASS_TYPE_DRUID, oPC) > 0) {
      AssignCommand(oPC, ActionStartConversation(oSelf, "", TRUE, FALSE));
    } else {
      FloatingTextStringOnCreature("These quarters are only available to Druids.", oPC, FALSE);
    }
}
