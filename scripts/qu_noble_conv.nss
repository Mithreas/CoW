#include "inc_backgrounds"

void main()
{
    object oSelf = OBJECT_SELF;

    // use this for quarters that are only available to nobles

    // check if PC has noble background
    object oPC = GetLastUsedBy();
    if (miBAGetCasteByBackground(miBAGetBackground(oPC)) == CASTE_NOBILITY) {
      AssignCommand(oPC, ActionStartConversation(oSelf, "", TRUE, FALSE));
    } else {
      FloatingTextStringOnCreature("These quarters are only available to characters with the Noble background.", oPC, FALSE);
    }
}
